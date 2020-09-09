Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224982631CF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgIIQ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbgIIQ0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:26:04 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3966DC0613ED;
        Wed,  9 Sep 2020 09:26:03 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 790C0140A76;
        Wed,  9 Sep 2020 18:25:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668755; bh=ZrVlwYH21zVLENLWv1RHoCy4rTc2/MBngwHI5nVk+sk=;
        h=From:To:Date;
        b=FFePVVajsmNyWURu2rdDUSTaREBB6CsBiagszeJWJJvVROiUuJAsaAutbMfKIWmne
         miPgZK4F4TJZZ5btbfM5Yr7dznZvo9mCmBllbTd2fJXm1BsP4kW8cLJGIWILtokaIE
         T+bKddxLiBE5IfZIVViPov4YFIOz9cEKJWkZ1dpU=
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
Subject: [PATCH net-next + leds v2 5/7] net: phy: add support for LEDs controlled by ethernet PHY chips
Date:   Wed,  9 Sep 2020 18:25:50 +0200
Message-Id: <20200909162552.11032-6-marek.behun@nic.cz>
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

This patch uses the new API for HW controlled LEDs to add support for
probing and control of LEDs connected to an ethernet PHY chip.

A PHY driver wishing to utilize this API needs to implement the methods
in struct hw_controlled_led_ops and set the member led_ops in struct
phy_driver to point to that structure.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/phy_device.c | 103 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |   4 ++
 2 files changed, 107 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 38f56d39f1229..54d5c88e4d4b2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2820,6 +2820,103 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->ack_interrupt;
 }
 
+#if IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED)
+
+/* PHY mutex lock wrappers for operations on PHY HW controlled LEDs, so that PHY drivers
+ * implementing these operations don't have to lock phydev->lock themselves.
+ */
+static int phy_led_init(struct device *dev, struct hw_controlled_led *led)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_ops->led_init(dev, led);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+static int phy_led_brightness_set(struct device *dev, struct hw_controlled_led *led,
+				  enum led_brightness brightness)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_ops->led_brightness_set(dev, led, brightness);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+static const char *phy_led_iter_hw_mode(struct device *dev, struct hw_controlled_led *led,
+					void **iter)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	const char *ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_ops->led_iter_hw_mode(dev, led, iter);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+static int phy_led_set_hw_mode(struct device *dev, struct hw_controlled_led *led, const char *mode)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_ops->led_set_hw_mode(dev, led, mode);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+static const char *phy_led_get_hw_mode(struct device *dev, struct hw_controlled_led *led)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	const char *ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->led_ops->led_get_hw_mode(dev, led);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+static const struct hw_controlled_led_ops phy_hw_controlled_led_ops = {
+	.led_init		= phy_led_init,
+	.led_brightness_set	= phy_led_brightness_set,
+	.led_iter_hw_mode	= phy_led_iter_hw_mode,
+	.led_set_hw_mode	= phy_led_set_hw_mode,
+	.led_get_hw_mode	= phy_led_get_hw_mode,
+};
+
+static int of_phy_probe_leds(struct phy_device *phydev)
+{
+	char devicename[32];
+
+	if (!phydev->drv->led_ops)
+		return 0;
+
+	snprintf(devicename, sizeof(devicename), "ethernet-phy%i", phydev->phyindex);
+
+	return of_register_hw_controlled_leds(&phydev->mdio.dev, devicename,
+					      &phy_hw_controlled_led_ops);
+}
+
+#else /* !IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */
+
+static inline int of_phy_probe_leds(struct phy_device *phydev)
+{
+	return 0;
+}
+
+#endif /* !IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
@@ -2922,6 +3019,12 @@ static int phy_probe(struct device *dev)
 
 	mutex_unlock(&phydev->lock);
 
+	/* LEDs have to be registered with phydev mutex unlocked, because some operations can be
+	 * called during registration that lock the mutex themselves
+	 */
+	if (!err)
+		of_phy_probe_leds(phydev);
+
 	return err;
 }
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 52881e21ad951..8a4ab72c74dd4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
+#include <linux/leds-hw-controlled.h>
 #include <linux/linkmode.h>
 #include <linux/netlink.h>
 #include <linux/mdio.h>
@@ -741,6 +742,9 @@ struct phy_driver {
 	int (*set_loopback)(struct phy_device *dev, bool enable);
 	int (*get_sqi)(struct phy_device *dev);
 	int (*get_sqi_max)(struct phy_device *dev);
+
+	/* PHY connected and controlled LEDs */
+	const struct hw_controlled_led_ops *led_ops;
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.26.2

