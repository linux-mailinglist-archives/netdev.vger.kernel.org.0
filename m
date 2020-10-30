Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD7E2A0499
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgJ3Lo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgJ3Lo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:44:57 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C96C72083B;
        Fri, 30 Oct 2020 11:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058295;
        bh=plgDzjSsOk9XLxXzM1odiJm4W1YvjhI2cPZI5xc8Rys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWyNBDzmXRDqgP1t1FXnbqiG5ox05SpyEYGBYksHhsa19e9ZZU57ghwGxsrnvo8YJ
         4zf1JWeTBF8pfZ+LYw41mogNSM1nnvACuL/FlJQgO7sky3TtqjGAN6yWrl2FG/ZCNH
         CInLWwuOBQkkWREpq/5ef8GwPTuJ1sisA7Gy6hek=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC leds + net-next 6/7] net: phy: add support for LEDs connected to ethernet PHYs
Date:   Fri, 30 Oct 2020 12:44:34 +0100
Message-Id: <20201030114435.20169-7-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030114435.20169-1-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many an ethernet PHY chip has pins dedicated for LEDs. On some PHYs it
can be configured via registers whether the LED should be ON, OFF, or
whether its state should depend on events within the chip (link, rx/tx
activity and so on).

Add support for probing such LEDs.

A PHY driver wishing to utilize this API must implement methods
led_init() and led_brightness_set(). Methods led_blink_set() and
led_trigger_offload() are optional.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phy_device.c | 140 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |  50 +++++++++++++
 2 files changed, 190 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 38f581cc9713..6bea8635cac8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2816,6 +2816,140 @@ s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 }
 EXPORT_SYMBOL(phy_get_internal_delay);
 
+#if IS_ENABLED(CONFIG_LEDS_CLASS)
+
+static int phy_led_brightness_set(struct led_classdev *cdev,
+				  enum led_brightness brightness)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct phy_led *led = to_phy_led(cdev);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_brightness_set(phydev, led, brightness);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+static int phy_led_blink_set(struct led_classdev *cdev, unsigned long *delay_on,
+			     unsigned long *delay_off)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct phy_led *led = to_phy_led(cdev);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_blink_set(phydev, led, delay_on, delay_off);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+#if IS_ENABLED(CONFIG_LEDS_TRIGGERS)
+static int phy_led_trigger_offload(struct led_classdev *cdev, bool enable)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct phy_led *led = to_phy_led(cdev);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_trigger_offload(phydev, led, enable);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+#endif /* IS_ENABLED(CONFIG_LEDS_TRIGGERS) */
+
+static int phy_probe_led(struct phy_device *phydev,
+			 struct fwnode_handle *fwnode, char *devicename)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct led_init_data init_data = {};
+	struct phy_led *led;
+	u32 reg;
+	int ret;
+
+	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->addr = -1;
+	if (!fwnode_property_read_u32(fwnode, "reg", &reg))
+		led->addr = reg;
+
+	led->active_low = !fwnode_property_read_bool(fwnode,
+						     "enable-active-high");
+	led->tristate = fwnode_property_read_bool(fwnode, "tristate");
+
+	led->cdev.max_brightness = 1;
+	led->cdev.brightness_set_blocking = phy_led_brightness_set;
+	if (phydev->drv->led_blink_set)
+		led->cdev.blink_set = phy_led_blink_set;
+#if IS_ENABLED(CONFIG_LEDS_TRIGGERS)
+	if (phydev->drv->led_trigger_offload)
+		led->cdev.trigger_offload = phy_led_trigger_offload;
+#endif /* IS_ENABLED(CONFIG_LEDS_TRIGGERS) */
+
+	ret = phydev->drv->led_init(phydev, led, fwnode);
+	if (ret)
+		goto err;
+
+	init_data.fwnode = fwnode;
+	init_data.devname_mandatory = true;
+	init_data.devicename = devicename;
+
+	ret = devm_led_classdev_register_ext(dev, &led->cdev, &init_data);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	devm_kfree(dev, led);
+	return ret;
+}
+
+static int phy_probe_leds(struct phy_device *phydev)
+{
+	struct fwnode_handle *leds, *led;
+	char devicename[32];
+	int ret;
+
+	if (!phydev->drv->led_init)
+		return 0;
+
+	if (WARN_ON(!phydev->drv->led_brightness_set))
+		return 0;
+
+	leds = device_get_named_child_node(&phydev->mdio.dev, "leds");
+	if (!leds)
+		return 0;
+
+	snprintf(devicename, sizeof(devicename), "ethernet-phy%i",
+		 phydev->phyindex);
+
+	fwnode_for_each_available_child_node(leds, led) {
+		ret = phy_probe_led(phydev, led, devicename);
+		if (ret) {
+			phydev_err(phydev, "Error probing PHY LED %pfw: %d\n",
+				   led, ret);
+			fwnode_handle_put(led);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+#else /* !IS_ENABLED(CONFIG_LEDS_CLASS) */
+
+static inline int phy_probe_leds(struct phy_device *phydev)
+{
+	return 0;
+}
+
+#endif /* IS_ENABLED(CONFIG_LEDS_CLASS) */
+
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
 	return phydrv->config_intr && phydrv->ack_interrupt;
@@ -2923,6 +3057,12 @@ static int phy_probe(struct device *dev)
 
 	mutex_unlock(&phydev->lock);
 
+	/* LEDs have to be registered with phydev mutex unlocked, because some
+	 * operations can be called during registration that lock the mutex.
+	 */
+	if (!err)
+		err = phy_probe_leds(phydev);
+
 	return err;
 }
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6dd4a28135c3..7df3f4632bdc 100644
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
@@ -679,6 +680,28 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
+/**
+ * struct phy_led - a PHY connected LED instance
+ *
+ * @cdev: underlying LED classdev
+ * @addr: identifier of the LED on the PHY, -1 if not present
+ * @active_low: whether this LED is connected as active low
+ * @tristate: whether this LED should be put into tristate mode when off
+ * @priv: private data for the underlying driver
+ */
+struct phy_led {
+	struct led_classdev cdev;
+
+	/* These come from firmware/OF */
+	int addr;
+	unsigned active_low:1;
+	unsigned tristate:1;
+
+	/* driver private data */
+	void *priv;
+};
+#define to_phy_led(l) container_of(l, struct phy_led, cdev)
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -884,6 +907,33 @@ struct phy_driver {
 	int (*get_sqi)(struct phy_device *dev);
 	/** @get_sqi_max: Get the maximum signal quality indication */
 	int (*get_sqi_max)(struct phy_device *dev);
+
+#if IS_ENABLED(CONFIG_LEDS_CLASS)
+	/* PHY connected LEDs operations */
+	/** @led_init: Check for valid configuration and initialize the LED */
+	int (*led_init)(struct phy_device *dev, struct phy_led *led,
+			struct fwnode_handle *fwnode);
+	/**
+	 * @led_brightness_set: Set the brightness of the LED. Mandatory if
+	 * led_init is present. Refer to method brightness_set_blocking() from
+	 * struct led_classdev in linux/leds.h
+	 */
+	int (*led_brightness_set)(struct phy_device *dev, struct phy_led *led,
+				  enum led_brightness brightness);
+	/**
+	 * @led_blink:set: Set HW blinking. Refer to method blink_set() from
+	 * struct led_classdev in linux/leds.h
+	 */
+	int (*led_blink_set)(struct phy_device *dev, struct phy_led *led,
+			     unsigned long *delay_on, unsigned long *delay_off);
+	/**
+	 * @led_trigger_offload: If possible, offload LED trigger to HW.
+	 * Refer to method trigger_offload() from struct led_classdev in
+	 * linux/leds.h
+	 */
+	int (*led_trigger_offload)(struct phy_device *dev, struct phy_led *led,
+				   bool enable);
+#endif /* IS_ENABLED(CONFIG_LEDS_CLASS) */
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.26.2

