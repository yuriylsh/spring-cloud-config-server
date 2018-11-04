FROM maven:latest as BUILD

COPY . /opt/spring-cloud-config-server/
WORKDIR /opt/spring-cloud-config-server/
RUN mvn package

FROM openjdk:8-jdk

# install Java Cryptography Extension
RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository ppa:webupd8team/java -y \
    && apt-get update \
    && apt-get -y install oracle-java8-unlimited-jce-policy

COPY --from=BUILD /opt/spring-cloud-config-server/target/*.jar /opt/spring-cloud-config-server/target/
EXPOSE 8888
VOLUME /config
WORKDIR /
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar",\
            "/opt/spring-cloud-config-server/target/spring-cloud-config-server.jar",\
            "--server.port=8888",\
            "--spring.config.name=application"]
