Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF3027163F
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 19:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgITRR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 13:17:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46156 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgITRRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 13:17:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kK2xi-00FUYn-U2; Sun, 20 Sep 2020 19:17:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 5/5] net: mdio: Add kerneldoc for main data structures and some functions
Date:   Sun, 20 Sep 2020 19:17:03 +0200
Message-Id: <20200920171703.3692328-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200920171703.3692328-1-andrew@lunn.ch>
References: <20200920171703.3692328-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the main structures, a few inline helpers and exported
functions which are not already documented.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/kapi.rst | 15 ++++++
 drivers/net/phy/mdio_bus.c        | 37 +++++++++++++
 drivers/net/phy/mdio_device.c     | 21 ++++++++
 include/linux/mdio.h              | 88 ++++++++++++++++++++++++++++---
 4 files changed, 154 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/kapi.rst b/Documentation/networking/kapi.rst
index d198fa5eaacd..88361ccf976b 100644
--- a/Documentation/networking/kapi.rst
+++ b/Documentation/networking/kapi.rst
@@ -155,6 +155,21 @@ PHY Support
 .. kernel-doc:: drivers/net/phy/mdio_bus.c
    :internal:
 
+.. kernel-doc:: drivers/net/phy/mdio_device.c
+   :export:
+
+.. kernel-doc:: drivers/net/phy/mdio_device.c
+   :internal:
+
+.. kernel-doc:: drivers/net/phy/mdio_devres.c
+   :export:
+
+.. kernel-doc:: include/linux/mdio.h
+   :internal:
+
+.. kernel-doc:: drivers/net/phy/mdio-boardinfo.c
+   :export:
+
 PHYLINK
 -------
 
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 0af20faad69d..b887544990c1 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -106,6 +106,15 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
 }
 EXPORT_SYMBOL(mdiobus_unregister_device);
 
+/**
+ * mdiobus_get_phy - Get the device at the address on the bus
+ *
+ * @bus: MDIO bus of interest
+ * @addr: Address on bus of device
+ *
+ * If there is a  device registered on the bus for the given address
+ * return the device. Else return NULL.
+ */
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
@@ -120,6 +129,16 @@ struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 }
 EXPORT_SYMBOL(mdiobus_get_phy);
 
+/**
+ * mdiobus_is_registered_device - Is there a device registered at the
+ *                                address on the bus
+ *
+ * @bus: MDIO bus of interest
+ * @addr: Address on bus of device
+ *
+ * Returns True if there is a device registered on the bus for the given address.
+ * Otherwise False.
+ */
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr)
 {
 	return bus->mdio_map[addr];
@@ -603,6 +622,14 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 }
 EXPORT_SYMBOL(__mdiobus_register);
 
+/**
+ * mdiobus_unregister - Unregister an MDIO bus
+ *
+ * @bus: target mii_bus
+ *
+ * For all devices on the bus, any GPIOs held are released. If the bus
+ * as a reset GPIO the devices on the bus are put into reset
+ */
 void mdiobus_unregister(struct mii_bus *bus)
 {
 	struct mdio_device *mdiodev;
@@ -1002,6 +1029,11 @@ struct bus_type mdio_bus_type = {
 };
 EXPORT_SYMBOL(mdio_bus_type);
 
+/**
+ * mdio_bus_init - Initialize the MDIO bus subsystem
+ *
+ * Register the MDIO bus class and the MDIO bus type
+ */
 int __init mdio_bus_init(void)
 {
 	int ret;
@@ -1018,6 +1050,11 @@ int __init mdio_bus_init(void)
 EXPORT_SYMBOL_GPL(mdio_bus_init);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
+/**
+ * mdio_bus_exit - Cleanup the MDIO bus subsystem
+ *
+ * Unregister the MDIO bus class and the MDIO bus type
+ */
 void mdio_bus_exit(void)
 {
 	class_unregister(&mdio_bus_class);
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 0837319a52d7..826d19293985 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -44,6 +44,12 @@ int mdio_device_bus_match(struct device *dev, struct device_driver *drv)
 	return strcmp(mdiodev->modalias, drv->name) == 0;
 }
 
+/**
+ * mdio_device_create - Create an MDIO device
+ *
+ * @bus: Bus the device is on
+ * @addr: Address of the device on the bus
+ */
 struct mdio_device *mdio_device_create(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev;
@@ -113,6 +119,17 @@ void mdio_device_remove(struct mdio_device *mdiodev)
 }
 EXPORT_SYMBOL(mdio_device_remove);
 
+/**
+ * mdio_device_reset - Reset the MDIO device
+ *
+ * @mdiodev:  Device to reset
+ * @value:  1 for reset, 0 for out of reset
+ *
+ * Place the device into our out of reset, depending on the value of
+ * @value.  Reset the device via a GPIO of a reset controller. If
+ * delays have been defined, wait the given time after change the
+ * reset.
+ */
 void mdio_device_reset(struct mdio_device *mdiodev, int value)
 {
 	unsigned int d;
@@ -206,6 +223,10 @@ int mdio_driver_register(struct mdio_driver *drv)
 }
 EXPORT_SYMBOL(mdio_driver_register);
 
+/**
+ * mdio_driver_unregister - Unregister an MDIO driver
+ * @drv: mdio_driver to unregister
+ */
 void mdio_driver_unregister(struct mdio_driver *drv)
 {
 	struct mdio_driver_common *mdiodrv = &drv->mdiodrv;
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index dbd69b3d170b..a3ca3e7c83f3 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -31,6 +31,21 @@ enum mdio_mutex_lock_class {
 	MDIO_MUTEX_NESTED,
 };
 
+/**
+ * struct mdio_device - A device on an MDIO bus
+ *
+ * @dev: Kernel device representation
+ * @bus: The MDIO bus this device is on
+ * @modalias: Alias of device driver
+ * @bus_match: Function to match driver to device
+ * @device_free: Free any resources used by the device
+ * @device_remove: Called before removing the device from the kernel
+ * @flags: Flags about the device, e.g. is it a PHY
+ * @reset_gpio: GPIO to reset the device
+ * @reset_ctrl: Reset controller to reset the device
+ * @reset_assert_delay: How long to old the device in reset
+ * @reset_deassert_delay: How long to wait after resetting the device
+ */
 struct mdio_device {
 	struct device dev;
 
@@ -41,7 +56,7 @@ struct mdio_device {
 	void (*device_free)(struct mdio_device *mdiodev);
 	void (*device_remove)(struct mdio_device *mdiodev);
 
-	/* Bus address of the MDIO device (0-31) */
+	/** @addr: Bus address of the MDIO device (0-31) */
 	int addr;
 	int flags;
 	struct gpio_desc *reset_gpio;
@@ -51,7 +66,12 @@ struct mdio_device {
 };
 #define to_mdio_device(d) container_of(d, struct mdio_device, dev)
 
-/* struct mdio_driver_common: Common to all MDIO drivers */
+/**
+ * struct mdio_driver_common - Common to all MDIO drivers
+ *
+ * @driver: Kernel driver representation
+ * @flags: Flags about this driver
+ */
 struct mdio_driver_common {
 	struct device_driver driver;
 	int flags;
@@ -60,28 +80,41 @@ struct mdio_driver_common {
 #define to_mdio_common_driver(d) \
 	container_of(d, struct mdio_driver_common, driver)
 
-/* struct mdio_driver: Generic MDIO driver */
+/**
+ * struct mdio_driver - Generic MDIO driver
+ * @mdiodrv: Common part to all MDIO drivers
+ */
 struct mdio_driver {
 	struct mdio_driver_common mdiodrv;
 
-	/*
-	 * Called during discovery.  Used to set
+	/**
+	 * @probe: Called during discovery.  Used to set
 	 * up device-specific structures, if any
 	 */
 	int (*probe)(struct mdio_device *mdiodev);
 
-	/* Clears up any memory if needed */
+	/** @remove: Clears up any memory if needed */
 	void (*remove)(struct mdio_device *mdiodev);
 };
 #define to_mdio_driver(d)						\
 	container_of(to_mdio_common_driver(d), struct mdio_driver, mdiodrv)
 
-/* device driver data */
+/**
+ * mdiodev_set_drvdata - Set the device driver data
+ *
+ * @mdio: MDIO device to set the driver data for
+ * @data: Pointer to the data
+ */
 static inline void mdiodev_set_drvdata(struct mdio_device *mdio, void *data)
 {
 	dev_set_drvdata(&mdio->dev, data);
 }
 
+/**
+ * mdiodev_get_drvdata - Get the device driver data associated with the device
+ *
+ * @mdio: MDIO device to get the driver data for
+ */
 static inline void *mdiodev_get_drvdata(struct mdio_device *mdio)
 {
 	return dev_get_drvdata(&mdio->dev);
@@ -96,16 +129,31 @@ int mdio_driver_register(struct mdio_driver *drv);
 void mdio_driver_unregister(struct mdio_driver *drv);
 int mdio_device_bus_match(struct device *dev, struct device_driver *drv);
 
+/**
+ * mdio_phy_id_is_c45 - Is the PHY id for a C45 transfer
+ *
+ * @phy_id: PHY address to determine if it is C45, otherwise C22
+ */
 static inline bool mdio_phy_id_is_c45(int phy_id)
 {
 	return (phy_id & MDIO_PHY_ID_C45) && !(phy_id & ~MDIO_PHY_ID_C45_MASK);
 }
 
+/*
+ * mdio_phy_id_prtad - Return the part address
+ *
+ * @phy_id: PHY address to return the part address of
+ */
 static inline __u16 mdio_phy_id_prtad(int phy_id)
 {
 	return (phy_id & MDIO_PHY_ID_PRTAD) >> 5;
 }
 
+/*
+ * mdio_phy_id_devad - Return the device address
+ *
+ * @phy_id: PHY address to return the device address of
+ */
 static inline __u16 mdio_phy_id_devad(int phy_id)
 {
 	return phy_id & MDIO_PHY_ID_DEVAD;
@@ -334,6 +382,15 @@ int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 		   u16 set);
 
+/**
+ * mdiobus_c44_addr - Construct a C45 Address
+ *
+ * @devad: Device address
+ * @regnum: Register number
+ *
+ * C45 accesses comprise of a device address and a register address, plus
+ * a flag to indicate it is a C45 address.
+ */
 static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 {
 	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
@@ -352,12 +409,29 @@ static inline int __mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
 			       val);
 }
 
+/**
+ * mdiobus_c45_read - Helper to perform a C45 read
+ *
+ * @bus: MDIO bus the device is on
+ * @prtad: Part address
+ * @devad: Device address
+ * @regnum: Register to read
+ */
 static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 				   u16 regnum)
 {
 	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
 }
 
+/**
+ * mdiobus_c45_write - Helper to perform a C45 write
+ *
+ * @bus: MDIO bus the device is on
+ * @prtad: Part address
+ * @devad: Device address
+ * @regnum: Register to write
+ * @val: Value to write to the register
+ */
 static inline int mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
 				    u16 regnum, u16 val)
 {
-- 
2.28.0

