DROP DATABASE cinema;
CREATE DATABASE cinema;
USE cinema;

CREATE TABLE studio(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bulstat VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255) DEFAULT NULL
);

INSERT INTO studio(name, bulstat, address) VALUES 
    ('Studio Diana', '123456', 'Sofia, Boris str. 56'),
    ('Studio Express', '232323', 'Sofia, Ivan str. 87'),
    ('Studio Martini', '878787', 'London, Pepin str. 90');

CREATE TABLE producers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bulstat VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255) DEFAULT NULL
);

INSERT INTO producers(name, bulstat, address) VALUES 
    ('Ivan Petrov', '1111', 'Sofia'),
    ('Sofia Ivanova', '2222', 'Sofia'),
    ('Petur Ivanov', '3333', 'London, Pepin str. 90');

CREATE TABLE actors(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    birthday DATE NOT NULL,
    address VARCHAR(255) NOT NULL,
    gender ENUM('MALE', 'FEMALE')
);

INSERT INTO actors(name, birthday, address, gender) VALUES 
    ('Stefan Simitliev', '2001-06-07', 'Sofia', 'Male'),
    ('Jenifer Popova', '1999-02-11', 'Sofia', 'Female'),
    ('Dilqna Dimitrova', '1987-09-07', 'London', 'Female');

CREATE TABLE movies(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL UNIQUE,
    year YEAR NOT NULL,
    budget DOUBLE NOT NULL,
    length INT UNSIGNED NOT NULL,
    studio_id INT NOT NULL,
    producer_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (studio_id) REFERENCES studio(id),
    CONSTRAINT FOREIGN KEY (producer_id) REFERENCES producers(id)
);

INSERT INTO movies(title, year, budget, length, studio_id, producer_id) VALUES 
    ('Greetings', 1968, 5000000, 120, 2, 3),
    ('Juniour', 1994, 50000000, 115, 3, 1),
    ('If somebody loves you', 2010, 500000, 90, 1, 2);

CREATE TABLE movies_actors(
   movies_id INT NOT NULL,
   CONSTRAINT FOREIGN KEY (movies_id) REFERENCES movies(id),
   actors_id INT NOT NULL,
   CONSTRAINT FOREIGN KEY (actors_id) REFERENCES actors(id),
   PRIMARY KEY(movies_id, actors_id)
);

INSERT INTO movies_actors(movies_id, actors_id) VALUES
    (1, 2),
    (2, 1),
    (3, 3);
    
SELECT name 
FROM actors
WHERE gender = 'Male' OR address = 'Sofia';

SELECT title, year, budget
FROM movies
WHERE year BETWEEN 1990 AND 2000
ORDER BY budget DESC
LIMIT 3;

SELECT movies.title AS movie_name, actors.name AS actors_name
FROM movies
JOIN movies_actors ON movies.id = movies_actors.movies_id
JOIN producers ON movies.producer_id = producers.id
JOIN actors ON movies_actors.actors_id = actors.id
WHERE producers.name = 'Ivan Petrov';

SELECT actors.name AS actor_name, AVG(movies.length) as average_ln
FROM actors
JOIN movies_actors ON actors.id = movies_actors.actors_id
JOIN movies ON movies_actors.movies_id = movies.id
WHERE movies.length > (
    SELECT AVG(movies.length)
    FROM movies
    WHERE year < 2000
) GROUP BY actors.name;


-- using having
SELECT actors.name AS actor_name, AVG(movies.length) AS average_ln
FROM actors 
JOIN movies_actors ON actors.id = movies_actors.actors_id
JOIN movies ON movies_actors.movies_id = movies.id
GROUP BY actors.name
HAVING average_ln > (
    SELECT AVG(m.length)
    FROM movies as m
    WHERE m.year < 2000
);