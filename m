Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A3230CFA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbgG1PFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:05:37 -0400
Received: from lists.nic.cz ([217.31.204.67]:44806 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbgG1PFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:05:35 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 79A05140BAE;
        Tue, 28 Jul 2020 17:05:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595948732; bh=alruMr1METBt+lv/grduwk/8NbGGqGvGG1bZlH0sia4=;
        h=From:To:Date;
        b=uDGPJX9RAMu5uAFAF39iif7wtI0LTjaLRztK009QhzIRSDM0ZwB8KErGy/z0booKR
         TpXNtzO70hXwT/CqPlcJdrsVvNNKr6cOOWnY9Lo26IPSP301Y8LLMSJYVgiN5U6RHk
         AugAMH/3I2E0IJ0fzkiExvX9pC2jS3Y7cBdbYsOs=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC leds + net-next v4 1/2] net: phy: add API for LEDs controlled by PHY HW
Date:   Tue, 28 Jul 2020 17:05:29 +0200
Message-Id: <20200728150530.28827-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728150530.28827-1-marek.behun@nic.cz>
References: <20200728150530.28827-1-marek.behun@nic.cz>
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

Many PHYs support various HW control modes for LEDs connected directly
to them.

This adds code for registering such LEDs when described in device tree
and also adds a new private LED trigger called phydev-hw-mode. When
this trigger is enabled for a LED, the various HW control modes which
the PHY supports for given LED can be get/set via hw_mode sysfs file.

A PHY driver wishing to utilize this API needs to implement these
methods:
- led_brightness_set for software brightness changing
- led_iter_hw_mode, led_set_hw_mode and led_get_hw_mode for
  getting/setting HW control mode
- led_init if the drivers wants phy-core to register the LEDs from
  device tree

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Kconfig      |   4 +
 drivers/net/phy/Makefile     |   1 +
 drivers/net/phy/phy_device.c |  25 +++--
 drivers/net/phy/phy_led.c    | 176 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  51 ++++++++++
 5 files changed, 250 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/phy/phy_led.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index dd20c2c27c2f..8972d2de25f6 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -283,6 +283,10 @@ config LED_TRIGGER_PHY
 		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
 		for any speed known to the PHY.
 
+config PHY_LEDS
+	bool
+	default y if LEDS_TRIGGERS
+
 
 comment "MII PHY device drivers"
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d84bab489a53..ef3c83759f93 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -20,6 +20,7 @@ endif
 obj-$(CONFIG_MDIO_DEVRES)	+= mdio_devres.o
 libphy-$(CONFIG_SWPHY)		+= swphy.o
 libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
+libphy-$(CONFIG_PHY_LEDS)	+= phy_led.o
 
 obj-$(CONFIG_PHYLINK)		+= phylink.o
 obj-$(CONFIG_PHYLIB)		+= libphy.o
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1b9523595839..9a1e9da30f71 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2909,6 +2909,8 @@ static int phy_probe(struct device *dev)
 				 phydev->supported);
 	}
 
+	of_phy_register_leds(phydev);
+
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
 
@@ -3040,24 +3042,32 @@ static int __init phy_init(void)
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
 
@@ -3067,6 +3077,7 @@ static void __exit phy_exit(void)
 	phy_driver_unregister(&genphy_driver);
 	mdio_bus_exit();
 	ethtool_set_ethtool_phy_ops(NULL);
+	phy_leds_exit();
 }
 
 subsys_initcall(phy_init);
diff --git a/drivers/net/phy/phy_led.c b/drivers/net/phy/phy_led.c
new file mode 100644
index 000000000000..85f67f39594f
--- /dev/null
+++ b/drivers/net/phy/phy_led.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * drivers/net/phy/phy_hw_led_mode.c
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
+	ret = phydev->drv->led_brightness_set(phydev, led, brightness);
+	mutex_unlock(&phydev->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phy_led_brightness_set);
+
+static int of_phy_register_led(struct phy_device *phydev, struct device_node *np)
+{
+	struct led_init_data init_data = {};
+	struct phy_device_led *led;
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
+
+	init_data.fwnode = &np->fwnode;
+	init_data.devname_mandatory = true;
+	init_data.devicename = phydev->attached_dev ? netdev_name(phydev->attached_dev) : "";
+
+	ret = phydev->drv->led_init(phydev, led);
+	if (ret < 0)
+		goto err_free;
+
+	ret = devm_led_classdev_register_ext(&phydev->mdio.dev, &led->cdev, &init_data);
+	if (ret < 0)
+		goto err_free;
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
+	if (!phydev->drv->led_init)
+		return 0;
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
+static void phy_hw_led_trig_deactivate(struct led_classdev *cdev)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_set_hw_mode(phydev, led_cdev_to_phy_device_led(cdev), NULL);
+	mutex_unlock(&phydev->lock);
+	if (ret < 0) {
+		phydev_err(phydev, "failed deactivating HW mode on LED %s\n", cdev->name);
+		return;
+	}
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
+	cur_mode = phydev->drv->led_get_hw_mode(phydev, led);
+
+	for (mode = phydev->drv->led_iter_hw_mode(phydev, led, &iter);
+	     mode;
+	     mode = phydev->drv->led_iter_hw_mode(phydev, led, &iter)) {
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
+	ret = phydev->drv->led_set_hw_mode(phydev, led, buf);
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
+	.deactivate	= phy_hw_led_trig_deactivate,
+	.trigger_type	= &phy_hw_led_trig_type,
+	.groups		= phy_hw_led_trig_groups,
+};
+EXPORT_SYMBOL_GPL(phy_hw_led_trig);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0403eb799913..d8901f97844f 100644
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
@@ -560,6 +561,46 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
+/* PHY LEDs support */
+struct phy_device_led {
+	struct led_classdev cdev;
+	int addr;
+	u32 flags;
+};
+#define led_cdev_to_phy_device_led(l) container_of(l, struct phy_device_led, cdev)
+
+#if IS_ENABLED(CONFIG_PHY_LEDS)
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
@@ -736,6 +777,16 @@ struct phy_driver {
 	int (*set_loopback)(struct phy_device *dev, bool enable);
 	int (*get_sqi)(struct phy_device *dev);
 	int (*get_sqi_max)(struct phy_device *dev);
+
+	/* PHY LED support */
+	int (*led_init)(struct phy_device *dev, struct phy_device_led *led);
+	int (*led_brightness_set)(struct phy_device *dev, struct phy_device_led *led,
+				  enum led_brightness brightness);
+	const char *(*led_iter_hw_mode)(struct phy_device *dev, struct phy_device_led *led,
+					void **	iter);
+	int (*led_set_hw_mode)(struct phy_device *dev, struct phy_device_led *led,
+			       const char *mode);
+	const char *(*led_get_hw_mode)(struct phy_device *dev, struct phy_device_led *led);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.26.2

