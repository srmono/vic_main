
-- --------------------------------------------------------
-- Table Structure for Vasavi Information Center
-- --------------------------------------------------------

-- 1. USERS TABLE
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role ENUM('Chairman', 'Coordinator', 'Promoter') NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NULL,
    password_hash VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255) NULL,
    location_id INT, -- Refers to Mandal/City
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE SET NULL
);

-- 2. LOCATIONS TABLE (Country → State → District → Mandal)
CREATE TABLE locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    parent_id INT NULL,
    type ENUM('Country', 'State', 'District', 'Mandal') NOT NULL,
    FOREIGN KEY (parent_id) REFERENCES locations(id) ON DELETE CASCADE
);

-- 3. SECTIONS TABLE (Types of Services)
CREATE TABLE sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. MANDAL SECTIONS TABLE (Available Services in a Mandal)
CREATE TABLE mandal_sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mandal_id INT NOT NULL,
    section_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mandal_id) REFERENCES locations(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE
);

-- 5. SERVICE UNITS TABLE (Multiple Units Under a Section)
CREATE TABLE service_units (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mandal_section_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255) NULL,
    phone VARCHAR(15) NULL,
    management_contact JSON NULL,
    images JSON NULL,
    address TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mandal_section_id) REFERENCES mandal_sections(id) ON DELETE CASCADE
);

-- 6. PROMOTERS TABLE (Promoters Assigned to Sections)
CREATE TABLE promoters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    mandal_section_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (mandal_section_id) REFERENCES mandal_sections(id) ON DELETE CASCADE
);

-- 7. UPLOADS TABLE (Images & Files)
CREATE TABLE uploads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uploader_id INT NOT NULL,
    service_unit_id INT NULL,
    file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploader_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (service_unit_id) REFERENCES service_units(id) ON DELETE CASCADE
);

-- 8. EVENTS TABLE
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date DATE,
    location_id INT,
    created_by INT,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 9. SUBSCRIPTIONS TABLE
CREATE TABLE subscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. BUSINESS CATEGORIES TABLE
CREATE TABLE business_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- 11. BUSINESS LISTINGS TABLE
CREATE TABLE business_listings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT,
    business_name VARCHAR(255) NOT NULL,
    description TEXT,
    phone VARCHAR(15),
    email VARCHAR(255),
    website VARCHAR(255),
    location_id INT,
    logo_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES business_categories(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

-- 12. CLASSIFIEDS TABLE
CREATE TABLE classifieds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('Job', 'Business') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location_id INT,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

-- 13. ADMIN CENTER TABLE
CREATE TABLE admin_centers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location_id INT NOT NULL,
    admin_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id),
    FOREIGN KEY (admin_user_id) REFERENCES users(id)
);
