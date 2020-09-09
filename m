Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B438826322E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbgIIQgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:36:50 -0400
Received: from lists.nic.cz ([217.31.204.67]:34640 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731056AbgIIQ0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:26:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id EF442140A6D;
        Wed,  9 Sep 2020 18:25:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668755; bh=u3IRK7xXgZ5VpwhMjFOls8Tmo4FXyAhmL45+VBDAzGQ=;
        h=From:To:Date;
        b=ML2TxvAbqcLwYDA0iPUeyrPLt7/bWP2m5GIAVAYoln6nWfuooRfcZy2RVrmzjS6cj
         qmzIEH+URpE8jFAlG9leOJRAMFPvg28Zqlud4BWYV1XBLgjEYyoONyIk3RU51Iefx6
         Dn4QklVmNXP4LmWWd2ckC6Jx9pm5NoQENhkuFwoo=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs that can be controlled by hardware
Date:   Wed,  9 Sep 2020 18:25:47 +0200
Message-Id: <20200909162552.11032-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909162552.11032-1-marek.behun@nic.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
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

Many an ethernet PHY (and other chips) supports various HW control modes
for LEDs connected directly to them.

This patch adds a generic API for registering such LEDs when described
in device tree. This API also exposes generic way to select between
these hardware control modes.

This API registers a new private LED trigger called dev-hw-mode. When
this trigger is enabled for a LED, the various HW control modes which
are supported by the device for given LED can be get/set via hw_mode
sysfs file.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 .../sysfs-class-led-trigger-dev-hw-mode       |   8 +
 drivers/leds/Kconfig                          |  10 +
 drivers/leds/Makefile                         |   1 +
 drivers/leds/leds-hw-controlled.c             | 227 ++++++++++++++++++
 include/linux/leds-hw-controlled.h            |  74 ++++++
 5 files changed, 320 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode
 create mode 100644 drivers/leds/leds-hw-controlled.c
 create mode 100644 include/linux/leds-hw-controlled.h

diff --git a/Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode b/Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode
new file mode 100644
index 0000000000000..7bca112e7ff93
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode
@@ -0,0 +1,8 @@
+What:		/sys/class/leds/<led>/hw_mode
+Date:		September 2020
+KernelVersion:	5.10
+Contact:	Marek Behún <marek.behun@nic.cz>
+		linux-leds@vger.kernel.org
+Description:	(W) Set the HW control mode of this LED. The various available HW control modes
+		    are specific per device to which the LED is connected to and per LED itself.
+		(R) Show the available HW control modes and the currently selected one.
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 1c181df24eae4..5e47ab21aafb4 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -49,6 +49,16 @@ config LEDS_BRIGHTNESS_HW_CHANGED
 
 	  See Documentation/ABI/testing/sysfs-class-led for details.
 
+config LEDS_HW_CONTROLLED
+	bool "API for LEDs that can be controlled by hardware"
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	help
+	  This option enables support for a generic API via which other drivers
+	  can register LEDs that can be put into hardware controlled mode, eg.
+	  a LED connected to an ethernet PHY can be configured to blink on
+	  network activity.
+
 comment "LED drivers"
 
 config LEDS_88PM860X
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index c2c7d7ade0d06..858e468e40df0 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
 obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-class-flash.o
 obj-$(CONFIG_LEDS_CLASS_MULTICOLOR)	+= led-class-multicolor.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
+obj-$(CONFIG_LEDS_HW_CONTROLLED)	+= leds-hw-controlled.o
 
 # LED Platform Drivers (keep this sorted, M-| sort)
 obj-$(CONFIG_LEDS_88PM860X)		+= leds-88pm860x.o
diff --git a/drivers/leds/leds-hw-controlled.c b/drivers/leds/leds-hw-controlled.c
new file mode 100644
index 0000000000000..9ef58bf275efd
--- /dev/null
+++ b/drivers/leds/leds-hw-controlled.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Generic API for LEDs that can be controlled by hardware (eg. by an ethernet PHY chip)
+ *
+ * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
+ */
+#include <linux/leds-hw-controlled.h>
+#include <linux/module.h>
+#include <linux/of.h>
+
+int hw_controlled_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness)
+{
+	struct hw_controlled_led *led = led_cdev_to_hw_controlled_led(cdev);
+	int ret;
+
+	mutex_lock(&led->lock);
+	ret = led->ops->led_brightness_set(cdev->dev->parent, led, brightness);
+	mutex_unlock(&led->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hw_controlled_led_brightness_set);
+
+static int of_register_hw_controlled_led(struct device *dev, struct device_node *np,
+					 const char *devicename,
+					 const struct hw_controlled_led_ops *ops)
+{
+	struct led_init_data init_data = {};
+	struct hw_controlled_led *led;
+	u32 reg;
+	int ret;
+
+	ret = of_property_read_u32(np, "reg", &reg);
+	if (ret < 0)
+		return ret;
+
+	led = devm_kzalloc(dev, sizeof(struct hw_controlled_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->ops = ops;
+
+	led->cdev.max_brightness = 1;
+	led->cdev.brightness_set_blocking = hw_controlled_led_brightness_set;
+	led->cdev.trigger_type = &hw_control_led_trig_type;
+	led->addr = reg;
+
+	of_property_read_string(np, "linux,default-trigger", &led->cdev.default_trigger);
+	of_property_read_string(np, "linux,default-hw-mode", &led->hw_mode);
+
+	led->active_low = !of_property_read_bool(np, "enable-active-high");
+	led->tristate = of_property_read_bool(np, "led-tristate");
+
+	init_data.fwnode = &np->fwnode;
+	init_data.devname_mandatory = true;
+	init_data.devicename = devicename;
+
+	ret = led->ops->led_init(dev, led);
+	if (ret < 0)
+		goto err_free;
+
+	ret = devm_led_classdev_register_ext(dev, &led->cdev, &init_data);
+	if (ret < 0)
+		goto err_free;
+
+	return 0;
+err_free:
+	devm_kfree(dev, led);
+	return ret;
+}
+
+int of_register_hw_controlled_leds(struct device *dev, const char *devicename,
+				   const struct hw_controlled_led_ops *ops)
+{
+	struct device_node *node = dev->of_node;
+	struct device_node *leds, *led;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (!ops)
+		return -EINVAL;
+
+	/* maybe we should have of_get_compatible_available_child as well */
+	leds = of_get_compatible_child(node, "linux,hw-controlled-leds");
+	if (!leds)
+		return 0;
+
+	if (!devicename)
+		devicename = dev_name(dev);
+
+	for_each_available_child_of_node(leds, led) {
+		ret = of_register_hw_controlled_led(dev, led, devicename, ops);
+		if (ret < 0)
+			dev_err(dev, "Nonfatal error: cannot register LED from node %pOFn: %i\n",
+				led, ret);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_register_hw_controlled_leds);
+
+static int hw_control_led_trig_activate(struct led_classdev *cdev)
+{
+	struct hw_controlled_led *led;
+	int ret;
+
+	led = led_cdev_to_hw_controlled_led(cdev);
+
+	if (!led->hw_mode)
+		return 0;
+
+	mutex_lock(&led->lock);
+	ret = led->ops->led_set_hw_mode(cdev->dev->parent, led, led->hw_mode);
+	mutex_unlock(&led->lock);
+
+	if (ret < 0)
+		dev_warn(cdev->dev->parent, "Could not set HW mode %s on LED %s: %i\n",
+			 led->hw_mode, cdev->name, ret);
+
+	/* don't fail to activate this trigger so that user can write hw_mode file */
+	return 0;
+}
+
+static void hw_control_led_trig_deactivate(struct led_classdev *cdev)
+{
+	struct hw_controlled_led *led;
+	int ret;
+
+	led = led_cdev_to_hw_controlled_led(cdev);
+
+	mutex_lock(&led->lock);
+	/* store HW mode before deactivation */
+	led->hw_mode = led->ops->led_get_hw_mode(cdev->dev->parent, led);
+	ret = led->ops->led_set_hw_mode(cdev->dev->parent, led, NULL);
+	mutex_unlock(&led->lock);
+
+	if (ret < 0)
+		dev_err(cdev->dev->parent, "Failed deactivating HW mode on LED %s\n", cdev->name);
+}
+
+static ssize_t hw_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct hw_controlled_led *led;
+	const char *mode, *cur_mode;
+	void *iter = NULL;
+	int len = 0;
+
+	led = led_cdev_to_hw_controlled_led(led_trigger_get_led(dev));
+
+	mutex_lock(&led->lock);
+
+	cur_mode = led->ops->led_get_hw_mode(dev->parent, led);
+
+	for (mode = led->ops->led_iter_hw_mode(dev->parent, led, &iter);
+	     mode;
+	     mode = led->ops->led_iter_hw_mode(dev->parent, led, &iter)) {
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
+	mutex_unlock(&led->lock);
+
+	return len;
+}
+
+static ssize_t hw_mode_store(struct device *dev, struct device_attribute *attr, const char *buf,
+			     size_t count)
+{
+	struct hw_controlled_led *led;
+	int ret;
+
+	led = led_cdev_to_hw_controlled_led(led_trigger_get_led(dev));
+
+	mutex_lock(&led->lock);
+	ret = led->ops->led_set_hw_mode(dev->parent, led, buf);
+	if (ret < 0)
+		return ret;
+	mutex_unlock(&led->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(hw_mode);
+
+static struct attribute *hw_control_led_trig_attrs[] = {
+	&dev_attr_hw_mode.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(hw_control_led_trig);
+
+struct led_hw_trigger_type hw_control_led_trig_type;
+EXPORT_SYMBOL_GPL(hw_control_led_trig_type);
+
+struct led_trigger hw_control_led_trig = {
+	.name		= "dev-hw-mode",
+	.activate	= hw_control_led_trig_activate,
+	.deactivate	= hw_control_led_trig_deactivate,
+	.trigger_type	= &hw_control_led_trig_type,
+	.groups		= hw_control_led_trig_groups,
+};
+EXPORT_SYMBOL_GPL(hw_control_led_trig);
+
+static int __init hw_controlled_leds_init(void)
+{
+	return led_trigger_register(&hw_control_led_trig);
+}
+
+static void __exit hw_controlled_leds_exit(void)
+{
+	led_trigger_unregister(&hw_control_led_trig);
+}
+
+subsys_initcall(hw_controlled_leds_init);
+module_exit(hw_controlled_leds_exit);
+
+MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("API for HW controlled LEDs");
diff --git a/include/linux/leds-hw-controlled.h b/include/linux/leds-hw-controlled.h
new file mode 100644
index 0000000000000..2c9b8a06def18
--- /dev/null
+++ b/include/linux/leds-hw-controlled.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Generic API for LEDs that can be controlled by hardware (eg. by an ethernet PHY chip)
+ *
+ * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
+ */
+#ifndef _LINUX_LEDS_HW_CONTROLLED_H_
+#define _LINUX_LEDS_HW_CONTROLLED_H_
+
+#include <linux/kernel.h>
+#include <linux/leds.h>
+
+struct hw_controlled_led {
+	struct led_classdev cdev;
+	const struct hw_controlled_led_ops *ops;
+	struct mutex lock;
+
+	/* these members are filled in by OF if OF is enabled */
+	int addr;
+	bool active_low;
+	bool tristate;
+
+	/* also filled in by OF, but changed by led_set_hw_mode operation */
+	const char *hw_mode;
+
+	void *priv;
+};
+#define led_cdev_to_hw_controlled_led(l) container_of(l, struct hw_controlled_led, cdev)
+
+/* struct hw_controlled_led_ops: Operations on LEDs that can be controlled by HW
+ *
+ * All the following operations must be implemented:
+ * @led_init: Should initialize the LED from OF data (and sanity check whether they are correct).
+ *            This should also change led->cdev.max_brightness, if the value differs from default,
+ *            which is 1.
+ * @led_brightness_set: Sets brightness.
+ * @led_iter_hw_mode: Iterates available HW control mode names for this LED.
+ * @led_set_hw_mode: Sets HW control mode to value specified by given name.
+ * @led_get_hw_mode: Returns current HW control mode name.
+ */
+struct hw_controlled_led_ops {
+	int (*led_init)(struct device *dev, struct hw_controlled_led *led);
+	int (*led_brightness_set)(struct device *dev, struct hw_controlled_led *led,
+				  enum led_brightness brightness);
+	const char *(*led_iter_hw_mode)(struct device *dev, struct hw_controlled_led *led,
+					void **iter);
+	int (*led_set_hw_mode)(struct device *dev, struct hw_controlled_led *led,
+			       const char *mode);
+	const char *(*led_get_hw_mode)(struct device *dev, struct hw_controlled_led *led);
+};
+
+#if IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED)
+
+#define hw_controlled_led_ops_ptr(s) (s)
+
+int of_register_hw_controlled_leds(struct device *dev, const char *devicename,
+				   const struct hw_controlled_led_ops *ops);
+int hw_controlled_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness);
+
+extern struct led_hw_trigger_type hw_control_led_trig_type;
+extern struct led_trigger hw_control_led_trig;
+
+#else /* !IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */
+
+#define hw_controlled_led_ops_ptr(s) NULL
+static inline int of_register_hw_controlled_leds(struct device *dev, const char *devicename,
+						 const struct hw_controlled_led_ops *ops)
+{
+	return 0;
+}
+
+#endif /* !IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */
+
+#endif /* _LINUX_LEDS_HW_CONTROLLED_H_ */
-- 
2.26.2

