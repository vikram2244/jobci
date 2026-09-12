FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline -B
# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:17.0.1-jdk-slim
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/careersite-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your application runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]