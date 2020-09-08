Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDE426075C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgIHADQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgIHADK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 20:03:10 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439DAC061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 17:03:08 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTP id C3BC314085D;
        Tue,  8 Sep 2020 02:03:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599523381; bh=paU03e2esrN0TVh4GiRVFK6N0gxWf+6bIDfOeUqP8AA=;
        h=From:To:Date;
        b=ttjYfFTQcdq1ffrXcznhEfsmpc5oJkp6pr26/pkFpMmC2ZeUjjIg44KAB2TIkPA/b
         2HH/UWAZZ7WsbganG1vRMYCF2R+A8zPBrdvgd3834NqYkndMKkusGrhvqh0n2plv8i
         LN6Eb8i0sAOVua33wfrrMnJEgeyBtlgAJTxgeZi4=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v1 2/3] net: phy: add API for LEDs controlled by ethernet PHY chips
Date:   Tue,  8 Sep 2020 02:02:59 +0200
Message-Id: <20200908000300.6982-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908000300.6982-1-marek.behun@nic.cz>
References: <20200908000300.6982-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many an ethernet PHY supports various HW control modes for LEDs
connected directly to the PHY chip.

This patch adds code for registering such LEDs when described in device
tree and also adds a new private LED trigger called phydev-hw-mode.
When this trigger is enabled for a LED, the various HW control modes
which are supported by the PHY for given LED cat be get/set via hw_mode
sysfs file.

A PHY driver wishing to utilize this API needs to implement all the
methods in the phy_device_led_ops structure.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Kconfig      |   4 +
 drivers/net/phy/Makefile     |   1 +
 drivers/net/phy/phy_device.c |  28 +++--
 drivers/net/phy/phy_led.c    | 224 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  91 ++++++++++++++
 5 files changed, 341 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/phy/phy_led.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 698bea312adc6..6ab8956c49b06 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -61,6 +61,10 @@ config SFP
 	depends on HWMON || HWMON=n
 	select MDIO_I2C
 
+config PHY_LEDS
+	bool
+	default y if LEDS_TRIGGERS
+
 comment "MII PHY device drivers"
 
 config AMD_PHY
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf8..8a54fb30a729d 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -20,6 +20,7 @@ endif
 obj-$(CONFIG_MDIO_DEVRES)	+= mdio_devres.o
 libphy-$(CONFIG_SWPHY)		+= swphy.o
 libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
+libphy-$(CONFIG_PHY_LEDS)		+= phy_led.o
 
 obj-$(CONFIG_PHYLINK)		+= phylink.o
 obj-$(CONFIG_PHYLIB)		+= libphy.o
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8adfbad0a1e8f..8a28134841ec3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -892,6 +893,7 @@ EXPORT_SYMBOL(get_phy_device);
  */
 int phy_device_register(struct phy_device *phydev)
 {
+	static atomic_t phyindex;
 	int err;
 
 	err = mdiobus_register_device(&phydev->mdio);
@@ -908,6 +910,7 @@ int phy_device_register(struct phy_device *phydev)
 		goto out;
 	}
 
+	phydev->phyindex = atomic_inc_return(&phyindex) - 1;
 	err = device_add(&phydev->mdio.dev);
 	if (err) {
 		phydev_err(phydev, "failed to add\n");
@@ -2909,6 +2912,8 @@ static int phy_probe(struct device *dev)
 				 phydev->supported);
 	}
 
+	of_phy_register_leds(phydev);
+
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
 
@@ -3040,24 +3045,32 @@ static int __init phy_init(void)
 {
 	int rc;
 
-	rc = mdio_bus_init();
+	rc = phy_leds_init();
 	if (rc)
 		return rc;
 
+	rc = mdio_bus_init();
+	if (rc)
+		goto err_leds;
+
 	ethtool_set_ethtool_phy_ops(&phy_ethtool_phy_ops);
 	features_init();
 
 	rc = phy_driver_register(&genphy_c45_driver, THIS_MODULE);
 	if (rc)
-		goto err_c45;
+		goto err_mdio;
 
 	rc = phy_driver_register(&genphy_driver, THIS_MODULE);
-	if (rc) {
-		phy_driver_unregister(&genphy_c45_driver);
-err_c45:
-		mdio_bus_exit();
-	}
+	if (rc)
+		goto err_c45;
 
+	return 0;
+err_c45:
+	phy_driver_unregister(&genphy_c45_driver);
+err_mdio:
+	mdio_bus_exit();
+err_leds:
+	phy_leds_exit();
 	return rc;
 }
 
@@ -3067,6 +3080,7 @@ static void __exit phy_exit(void)
 	phy_driver_unregister(&genphy_driver);
 	mdio_bus_exit();
 	ethtool_set_ethtool_phy_ops(NULL);
+	phy_leds_exit();
 }
 
 subsys_initcall(phy_init);
diff --git a/drivers/net/phy/phy_led.c b/drivers/net/phy/phy_led.c
new file mode 100644
index 0000000000000..80d203b41c92e
--- /dev/null
+++ b/drivers/net/phy/phy_led.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* drivers/net/phy/phy_hw_led_mode.c
+ *
+ * PHY HW LED mode trigger
+ *
+ * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
+ */
+#include <linux/leds.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+
+int phy_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness)
+{
+	struct phy_device_led *led = led_cdev_to_phy_device_led(cdev);
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->led_ops->led_brightness_set(phydev, led, brightness);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_led_brightness_set);
+
+static int of_phy_register_led(struct phy_device *phydev, struct device_node *np)
+{
+	struct phy_device_led_init_data pdata = {};
+	struct led_init_data init_data = {};
+	struct phy_device_led *led;
+	char devicename[16];
+	u32 reg;
+	int ret;
+
+	ret = of_property_read_u32(np, "reg", &reg);
+	if (ret < 0)
+		return ret;
+
+	led = devm_kzalloc(&phydev->mdio.dev, sizeof(struct phy_device_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->cdev.brightness_set_blocking = phy_led_brightness_set;
+	led->cdev.trigger_type = &phy_hw_led_trig_type;
+	led->addr = reg;
+
+	of_property_read_string(np, "linux,default-trigger", &led->cdev.default_trigger);
+	of_property_read_string(np, "linux,default-hw-mode", &led->hw_mode);
+
+	pdata.active_low = !of_property_read_bool(np, "enable-active-high");
+	pdata.open_drain = of_property_read_bool(np, "led-open-drain");
+
+	init_data.fwnode = &np->fwnode;
+	init_data.devname_mandatory = true;
+	snprintf(devicename, sizeof(devicename), "phy%d", phydev->phyindex);
+	init_data.devicename = devicename;
+
+	ret = phydev->led_ops->led_init(phydev, led, &pdata);
+	if (ret < 0)
+		goto err_free;
+
+	ret = devm_led_classdev_register_ext(&phydev->mdio.dev, &led->cdev, &init_data);
+	if (ret < 0)
+		goto err_free;
+
+	led->flags |= PHY_DEVICE_LED_REGISTERED;
+
+	return 0;
+err_free:
+	devm_kfree(&phydev->mdio.dev, led);
+	return ret;
+}
+
+int of_phy_register_leds(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device_node *leds, *led;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (!phydev->drv->led_ops)
+		return 0;
+
+	phydev->led_ops = phydev->drv->led_ops;
+
+	leds = of_get_child_by_name(node, "leds");
+	if (!leds)
+		return 0;
+
+	for_each_available_child_of_node(leds, led) {
+		ret = of_phy_register_led(phydev, led);
+		if (ret < 0)
+			phydev_err(phydev, "Nonfatal error: cannot register LED from node %pOFn: %i\n",
+				   led, ret);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_phy_register_leds);
+
+static int phy_hw_led_trig_activate(struct led_classdev *cdev)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct phy_device_led *led;
+	int ret;
+
+	led = led_cdev_to_phy_device_led(cdev);
+
+	if (!led->hw_mode)
+		return 0;
+
+	/* When this trigger is being activated from devm_led_classdev_register_ext, the mutex is
+	 * already locked (in phy_probe), so only lock/unlock it if the LED is already registered.
+	 */
+	if (led->flags & PHY_DEVICE_LED_REGISTERED)
+		mutex_lock(&phydev->lock);
+
+	ret = phydev->led_ops->led_set_hw_mode(phydev, led, led->hw_mode);
+
+	if (led->flags & PHY_DEVICE_LED_REGISTERED)
+		mutex_unlock(&phydev->lock);
+
+	if (ret < 0)
+		phydev_warn(phydev, "could not set HW mode %s on LED %s: %i\n", led->hw_mode,
+			    cdev->name, ret);
+
+	/* don't fail to activate this trigger so that user can write hw_mode file */
+	return 0;
+}
+
+static void phy_hw_led_trig_deactivate(struct led_classdev *cdev)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct phy_device_led *led;
+	int ret;
+
+	led = led_cdev_to_phy_device_led(cdev);
+
+	mutex_lock(&phydev->lock);
+
+	/* store HW mode before deactivation */
+	led->hw_mode = phydev->led_ops->led_get_hw_mode(phydev, led);
+
+	ret = phydev->led_ops->led_set_hw_mode(phydev, led_cdev_to_phy_device_led(cdev), NULL);
+
+	mutex_unlock(&phydev->lock);
+
+	if (ret < 0)
+		phydev_err(phydev, "failed deactivating HW mode on LED %s\n", cdev->name);
+}
+
+static ssize_t hw_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct phy_device *phydev = to_phy_device(dev->parent);
+	const char *mode, *cur_mode;
+	struct phy_device_led *led;
+	void *iter = NULL;
+	int len = 0;
+
+	led = led_cdev_to_phy_device_led(led_trigger_get_led(dev));
+
+	mutex_lock(&phydev->lock);
+
+	cur_mode = phydev->led_ops->led_get_hw_mode(phydev, led);
+
+	for (mode = phydev->led_ops->led_iter_hw_mode(phydev, led, &iter);
+	     mode;
+	     mode = phydev->led_ops->led_iter_hw_mode(phydev, led, &iter)) {
+		bool sel;
+
+		sel = cur_mode && !strcmp(mode, cur_mode);
+
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s%s ", sel ? "[" : "", mode,
+				 sel ? "]" : "");
+	}
+
+	if (buf[len - 1] == ' ')
+		buf[len - 1] = '\n';
+
+	mutex_unlock(&phydev->lock);
+
+	return len;
+}
+
+static ssize_t hw_mode_store(struct device *dev, struct device_attribute *attr, const char *buf,
+			     size_t count)
+{
+	struct phy_device *phydev = to_phy_device(dev->parent);
+	struct phy_device_led *led;
+	int ret;
+
+	led = led_cdev_to_phy_device_led(led_trigger_get_led(dev));
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->led_ops->led_set_hw_mode(phydev, led, buf);
+	mutex_unlock(&phydev->lock);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(hw_mode);
+
+static struct attribute *phy_hw_led_trig_attrs[] = {
+	&dev_attr_hw_mode.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(phy_hw_led_trig);
+
+struct led_hw_trigger_type phy_hw_led_trig_type;
+EXPORT_SYMBOL_GPL(phy_hw_led_trig_type);
+
+struct led_trigger phy_hw_led_trig = {
+	.name		= "phydev-hw-mode",
+	.activate	= phy_hw_led_trig_activate,
+	.deactivate	= phy_hw_led_trig_deactivate,
+	.trigger_type	= &phy_hw_led_trig_type,
+	.groups		= phy_hw_led_trig_groups,
+};
+EXPORT_SYMBOL_GPL(phy_hw_led_trig);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea4..2c651375becd1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
+#include <linux/leds.h>
 #include <linux/linkmode.h>
 #include <linux/netlink.h>
 #include <linux/mdio.h>
@@ -406,6 +407,7 @@ struct macsec_ops;
 /* phy_device: An instance of a PHY
  *
  * drv: Pointer to the driver for this PHY instance
+ * phyindex: a simple incrementing PHY index
  * phy_id: UID for this device found during discovery
  * c45_ids: 802.3-c45 Device Identifers if is_c45.
  * is_c45:  Set to true if this phy uses clause 45 addressing.
@@ -420,6 +422,7 @@ struct macsec_ops;
  * downshifted_rate: Set true if link speed has been downshifted.
  * state: state of the PHY for management purposes
  * dev_flags: Device-specific flags used by the PHY driver.
+ * led_ops: PHY connected LEDs ops
  * irq: IRQ number of the PHY's interrupt (-1 if none)
  * phy_timer: The timer for handling the state machine
  * sfp_bus_attached: flag indicating whether the SFP bus has been attached
@@ -446,6 +449,8 @@ struct phy_device {
 	/* And management functions */
 	struct phy_driver *drv;
 
+	int phyindex;
+
 	u32 phy_id;
 
 	struct phy_c45_device_ids c45_ids;
@@ -505,6 +510,10 @@ struct phy_device {
 	struct phy_led_trigger *led_link_trigger;
 #endif
 
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+	const struct phy_device_led_ops *led_ops;
+#endif
+
 	/*
 	 * Interrupt number for this PHY
 	 * -1 means no interrupt
@@ -562,6 +571,85 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
+struct phy_device_led_init_data {
+	bool active_low;
+	bool open_drain;
+};
+
+#define PHY_DEVICE_LED_REGISTERED	BIT(31)
+
+/* PHY LEDs support */
+struct phy_device_led {
+	struct led_classdev cdev;
+	const char *hw_mode;
+	int addr;
+	u32 flags;
+};
+#define led_cdev_to_phy_device_led(l) container_of(l, struct phy_device_led, cdev)
+
+/* struct phy_device_led_ops: Operations on LEDs controlled by PHY chips
+ *
+ * All the following operations must be implemented:
+ * @led_init: Should initialize LED from init_data (and check whether they are correct).
+ *            This should also set led->cdev.max_brightness, for example.
+ * @led_brightness_set: Sets brightness.
+ * @led_iter_hw_mode: Iterates available HW control mode names for this LED.
+ * @led_set_hw_mode: Sets HW control mode to value specified by given name.
+ * @led_get_hw_mode: Returns current HW control mode name.
+ *
+ * This methods must not lock the phy_device lock mutex. When they are called, the mutex
+ * is already locked.
+ */
+struct phy_device_led_ops {
+	int (*led_init)(struct phy_device *dev, struct phy_device_led *led,
+			const struct phy_device_led_init_data *pdata);
+	int (*led_brightness_set)(struct phy_device *dev, struct phy_device_led *led,
+				  enum led_brightness brightness);
+	const char *(*led_iter_hw_mode)(struct phy_device *dev, struct phy_device_led *led,
+					void **iter);
+	int (*led_set_hw_mode)(struct phy_device *dev, struct phy_device_led *led,
+			       const char *mode);
+	const char *(*led_get_hw_mode)(struct phy_device *dev, struct phy_device_led *led);
+};
+
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+
+#define phy_device_led_ops_ptr(s) (s)
+
+int of_phy_register_leds(struct phy_device *phydev);
+
+extern struct led_hw_trigger_type phy_hw_led_trig_type;
+extern struct led_trigger phy_hw_led_trig;
+int phy_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness);
+
+static inline int phy_leds_init(void)
+{
+	return led_trigger_register(&phy_hw_led_trig);
+}
+
+static inline void phy_leds_exit(void)
+{
+	led_trigger_unregister(&phy_hw_led_trig);
+}
+#else /* !IS_ENABLED(CONFIG_PHY_LEDS) */
+
+#define phy_device_led_ops_ptr(s) NULL
+
+static inline int of_phy_register_leds(struct phy_device *phydev)
+{
+	return 0;
+}
+
+static inline int phy_leds_init(void)
+{
+	return 0;
+}
+
+static inline void phy_leds_exit(void)
+{
+}
+#endif /* !IS_ENABLED(CONFIG_PHY_LEDS) */
+
 /* struct phy_driver: Driver structure for a particular PHY type
  *
  * driver_data: static driver data
@@ -738,6 +826,9 @@ struct phy_driver {
 	int (*set_loopback)(struct phy_device *dev, bool enable);
 	int (*get_sqi)(struct phy_device *dev);
 	int (*get_sqi_max)(struct phy_device *dev);
+
+	/* PHY connected LEDs operations */
+	const struct phy_device_led_ops *led_ops;
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.26.2

