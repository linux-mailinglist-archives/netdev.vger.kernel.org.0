Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF1422CB5A
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgGXQqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:46:24 -0400
Received: from mail.nic.cz ([217.31.204.67]:36608 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgGXQqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 12:46:07 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 2A6781409D1;
        Fri, 24 Jul 2020 18:46:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595609164; bh=ekWiIinLAdpTYp1fD53vrA/hEgyTpgoQeB5n1DE3wYk=;
        h=From:To:Date;
        b=n5s1lsjU3xhdoWCWa933FnkWug/yPtpKNlkGqsjUb/0TnjYsTomL+L08/+w8PruRX
         1kqR9tdehBntUuwk1TpGPPCzzdaRwtB4vomNr9FJIw5p730w8Sb1FMbSjEaEIX4U25
         1dzVVpvm2QjZlJl9+AeFU/yMYJP7uiYwg2EyiSN4=
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
Subject: [PATCH RFC leds + net-next v3 1/2] net: phy: add API for LEDs controlled by PHY HW
Date:   Fri, 24 Jul 2020 18:46:02 +0200
Message-Id: <20200724164603.29148-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724164603.29148-1-marek.behun@nic.cz>
References: <20200724164603.29148-1-marek.behun@nic.cz>
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

This code adds a new private LED trigger called phydev-hw-mode. When
this trigger is enabled for a LED, the various HW control modes which
the PHY supports for given LED can be get/set via hw_mode sysfs file.

A PHY driver wishing to utilize this API needs to register the LEDs on
its own and set the .trigger_type member of LED classdev to
&phy_hw_led_trig_type. It also needs to implement the methods
.led_iter_hw_mode, .led_set_hw_mode and .led_get_hw_mode in struct
phydev.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Kconfig           |  9 +++
 drivers/net/phy/Makefile          |  1 +
 drivers/net/phy/phy_hw_led_mode.c | 96 +++++++++++++++++++++++++++++++
 include/linux/phy.h               | 15 +++++
 4 files changed, 121 insertions(+)
 create mode 100644 drivers/net/phy/phy_hw_led_mode.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index dd20c2c27c2f..ffea11f73acd 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -283,6 +283,15 @@ config LED_TRIGGER_PHY
 		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
 		for any speed known to the PHY.
 
+config LED_TRIGGER_PHY_HW
+	bool "Support HW LED control modes"
+	depends on LEDS_TRIGGERS
+	help
+	  Many PHYs can control blinking of LEDs connected directly to them.
+	  This adds a special LED trigger called phydev-hw-mode. When enabled,
+	  the various control modes supported by the PHY on given LED can be
+	  chosen via hw_mode sysfs file.
+
 
 comment "MII PHY device drivers"
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d84bab489a53..fd0253ab8097 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -20,6 +20,7 @@ endif
 obj-$(CONFIG_MDIO_DEVRES)	+= mdio_devres.o
 libphy-$(CONFIG_SWPHY)		+= swphy.o
 libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
+libphy-$(CONFIG_LED_TRIGGER_PHY_HW)	+= phy_hw_led_mode.o
 
 obj-$(CONFIG_PHYLINK)		+= phylink.o
 obj-$(CONFIG_PHYLIB)		+= libphy.o
diff --git a/drivers/net/phy/phy_hw_led_mode.c b/drivers/net/phy/phy_hw_led_mode.c
new file mode 100644
index 000000000000..b4c2f25266a5
--- /dev/null
+++ b/drivers/net/phy/phy_hw_led_mode.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * drivers/net/phy/phy_hw_led_mode.c
+ *
+ * PHY HW LED mode trigger
+ *
+ * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
+ */
+#include <linux/leds.h>
+#include <linux/phy.h>
+
+static void phy_hw_led_trig_deactivate(struct led_classdev *cdev)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	int ret;
+
+	ret = phydev->drv->led_set_hw_mode(phydev, cdev, NULL);
+	if (ret < 0) {
+		phydev_err(phydev, "failed deactivating HW mode on LED %s\n", cdev->name);
+		return;
+	}
+}
+
+static ssize_t hw_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *cdev = led_trigger_get_led(dev);
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	const char *mode, *cur_mode;
+	void *iter = NULL;
+	int len = 0;
+
+	cur_mode = phydev->drv->led_get_hw_mode(phydev, cdev);
+
+	for (mode = phydev->drv->led_iter_hw_mode(phydev, cdev, &iter);
+	     mode;
+	     mode = phydev->drv->led_iter_hw_mode(phydev, cdev, &iter)) {
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
+	return len;
+}
+
+static ssize_t hw_mode_store(struct device *dev, struct device_attribute *attr, const char *buf,
+			     size_t count)
+{
+	struct led_classdev *cdev = led_trigger_get_led(dev);
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	int ret;
+
+	ret = phydev->drv->led_set_hw_mode(phydev, cdev, buf);
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
+
+static int __init phy_led_triggers_init(void)
+{
+	return led_trigger_register(&phy_hw_led_trig);
+}
+
+module_init(phy_led_triggers_init);
+
+static void __exit phy_led_triggers_exit(void)
+{
+	led_trigger_unregister(&phy_hw_led_trig);
+}
+
+module_exit(phy_led_triggers_exit);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0403eb799913..3abaed18f63d 100644
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
@@ -736,6 +737,14 @@ struct phy_driver {
 	int (*set_loopback)(struct phy_device *dev, bool enable);
 	int (*get_sqi)(struct phy_device *dev);
 	int (*get_sqi_max)(struct phy_device *dev);
+
+#if IS_ENABLED(CONFIG_LED_TRIGGER_PHY_HW)
+	/* PHY LED HW modes support */
+	const char *(*led_iter_hw_mode)(struct phy_device *dev, struct led_classdev *cdev,
+					void **	iter);
+	int (*led_set_hw_mode)(struct phy_device *dev, struct led_classdev *cdev, const char *mode);
+	const char *(*led_get_hw_mode)(struct phy_device *dev, struct led_classdev *cdev);
+#endif
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
@@ -747,6 +756,12 @@ struct phy_driver {
 #define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 4)
 #define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 10)
 
+#if IS_ENABLED(CONFIG_LED_TRIGGER_PHY_HW)
+/* PHY LED HW mode private trigger */
+extern struct led_hw_trigger_type phy_hw_led_trig_type;
+extern struct led_trigger phy_hw_led_trig;
+#endif
+
 /* A Structure for boards to register fixups with the PHY Lib */
 struct phy_fixup {
 	struct list_head list;
-- 
2.26.2

