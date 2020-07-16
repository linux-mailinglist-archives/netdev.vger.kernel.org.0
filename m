Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3F82228D1
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgGPRRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:17:39 -0400
Received: from lists.nic.cz ([217.31.204.67]:53322 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgGPRRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 13:17:34 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 585BB140A99;
        Thu, 16 Jul 2020 19:17:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594919851; bh=9gBgMVTGWI6R21ETi1juDE57kDe+bkwLeMiohfwaUHQ=;
        h=From:To:Date;
        b=gXqYfFef6Xrz5rFUjMpR2ydbyZGCtbocNXBeytlnyZHGoe1BPg/v3RlYm+7vFa2sk
         Ia/AVZ0iLlAXA20ezgOy7xGz5vnsfsOnF0Otz0V8+EKYVRCOrbkEkuGEb4wcmDRDwq
         Vzd754H0Qmm58gIdf/t2qSVF3SSzIZPhN2I3kn88=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     linux-leds@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC leds + net-next 3/3] net: phy: marvell: add support for PHY LEDs via LED class
Date:   Thu, 16 Jul 2020 19:17:30 +0200
Message-Id: <20200716171730.13227-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716171730.13227-1-marek.behun@nic.cz>
References: <20200716171730.13227-1-marek.behun@nic.cz>
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

This patch adds support for controlling the LEDs connected to Marvell
PHYs via Linux' LED API.

The code reads LEDs definitions from the device-tree node of the PHY.

Since the LEDs can be controlled by hardware, we add LED-private LED
triggers for every possible HW controlled mode.

This does not yet add support for compound LED modes. This could be
achieved via the LED multicolor framework (which is not yet in
upstream).

Settings such as HW blink rate or pulse stretch duration are not yet
supported.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Kconfig   |   7 +
 drivers/net/phy/marvell.c | 307 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 313 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index dd20c2c27c2f..fb75abdb9f24 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -456,6 +456,13 @@ config MARVELL_PHY
 	help
 	  Currently has a driver for the 88E1011S
 
+config MARVELL_PHY_LEDS
+	bool "Support LEDs on Marvell PHYs"
+	depends on MARVELL_PHY && LEDS_TRIGGERS
+	help
+	  This option enables support for controlling LEDs connected to Marvell
+	  PHYs.
+
 config MARVELL_10G_PHY
 	tristate "Marvell Alaska 10Gbit PHYs"
 	help
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb86ac0bd092..066bb0a77840 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -23,6 +23,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
+#include <linux/leds.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mii.h>
@@ -148,6 +149,11 @@
 #define MII_88E1510_PHY_LED_DEF		0x1177
 #define MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE	0x1040
 
+#define MII_PHY_LED45_CTRL		19
+
+#define MII_PHY_LED_CTRL_FORCE_ON	0x9
+#define MII_PHY_LED_CTRL_FORCE_OFF	0x8
+
 #define MII_M1011_PHY_STATUS		0x11
 #define MII_M1011_PHY_STATUS_1000	0x8000
 #define MII_M1011_PHY_STATUS_100	0x4000
@@ -252,6 +258,8 @@
 #define LPA_PAUSE_FIBER		0x180
 #define LPA_PAUSE_ASYM_FIBER	0x100
 
+#define MARVELL_PHY_MAX_LEDS	6
+
 #define NB_FIBER_STATS	1
 
 MODULE_DESCRIPTION("Marvell PHY driver");
@@ -275,6 +283,9 @@ struct marvell_priv {
 	u64 stats[ARRAY_SIZE(marvell_hw_stats)];
 	char *hwmon_name;
 	struct device *hwmon_dev;
+#if IS_ENABLED(CONFIG_MARVELL_PHY_LEDS)
+	struct led_classdev leds[MARVELL_PHY_MAX_LEDS];
+#endif
 	bool cable_test_tdr;
 	u32 first;
 	u32 last;
@@ -662,6 +673,273 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_MARVELL_PHY_LEDS)
+
+static struct led_hw_trigger_type marvell_led_trigger_type;
+
+struct marvell_led_trigger_info {
+	s8 regval[MARVELL_PHY_MAX_LEDS];
+};
+
+static const s8 marvell_led_trigger_info[][MARVELL_PHY_MAX_LEDS] = {
+	{ 0x0,  -1, 0x0,  -1,  -1,  -1, },
+	{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, },
+	{ 0x2,  -1,  -1,  -1,  -1,  -1, },
+	{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, },
+	{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, },
+	{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, },
+	{  -1,  -1,  -1,  -1, 0x0, 0x0, },
+	{ 0x6, 0x0,  -1,  -1,  -1,  -1, },
+	{ 0x7,  -1,  -1,  -1,  -1,  -1, },
+	{  -1, 0x2,  -1, 0x2, 0x2, 0x2, },
+	{  -1, 0x5,  -1,  -1,  -1,  -1, },
+	{  -1, 0x6,  -1,  -1,  -1,  -1, },
+	{  -1,  -1, 0x6, 0x6,  -1,  -1, },
+	{  -1, 0x7,  -1,  -1,  -1,  -1, },
+	{  -1,  -1, 0x7,  -1,  -1,  -1, },
+	{  -1,  -1,  -1, 0x0,  -1,  -1, },
+	{  -1,  -1,  -1, 0x7, 0x6, 0x6, },
+	{  -1,  -1,  -1,  -1, 0x7, 0x7, },
+	{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, },
+	{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, },
+};
+
+static int marvell_led_trigger_activate(struct led_classdev *led_cdev);
+static void marvell_led_trigger_deactivate(struct led_classdev *led_cdev);
+
+#define DEF_MARVELL_LED_TRIG(n)						\
+	{								\
+		.name		= (n),					\
+		.activate	= marvell_led_trigger_activate,		\
+		.deactivate	= marvell_led_trigger_deactivate,	\
+		.trigger_type	= &marvell_led_trigger_type,		\
+	}
+
+/*
+ * TODO: Do we want to check LED capabilities based on PHY ID?
+ * For example some support PTP triggering while others have that register
+ * value specified as "Reserved".
+ */
+static struct led_trigger marvell_led_triggers[] = {
+	DEF_MARVELL_LED_TRIG("hw:link/nolink"),
+	DEF_MARVELL_LED_TRIG("hw:link/act/nolink"),
+	DEF_MARVELL_LED_TRIG("hw:1000/100/10/nolink"),
+	DEF_MARVELL_LED_TRIG("hw:act/noact"),
+	DEF_MARVELL_LED_TRIG("hw:blink-act/noact"),
+	DEF_MARVELL_LED_TRIG("hw:transmit/notransmit"),
+	DEF_MARVELL_LED_TRIG("hw:recv/norecv"),
+	DEF_MARVELL_LED_TRIG("hw:copperlink/else"),
+	DEF_MARVELL_LED_TRIG("hw:1000/else"),
+	DEF_MARVELL_LED_TRIG("hw:link/recv/nolink"),
+	DEF_MARVELL_LED_TRIG("hw:100-fiber/else"),
+	DEF_MARVELL_LED_TRIG("hw:1000-100/else"),
+	DEF_MARVELL_LED_TRIG("hw:1000-10/else"),
+	DEF_MARVELL_LED_TRIG("hw:100/else"),
+	DEF_MARVELL_LED_TRIG("hw:10/else"),
+	DEF_MARVELL_LED_TRIG("hw:fiber/else"),
+	DEF_MARVELL_LED_TRIG("hw:full/half"),
+	DEF_MARVELL_LED_TRIG("hw:full/collision/half"),
+	DEF_MARVELL_LED_TRIG("hw:force-hi-z"),
+	DEF_MARVELL_LED_TRIG("hw:force-blink"),
+};
+
+static int marvell_register_led_triggers(void)
+{
+	int i, err;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_triggers); ++i) {
+		err = led_trigger_register(&marvell_led_triggers[i]);
+		if (err)
+			goto fail;
+	}
+
+	return 0;
+fail:
+	for (--i; i >= 0; --i)
+		led_trigger_unregister(&marvell_led_triggers[i]);
+
+	return err;
+}
+
+static void marvell_unregister_led_triggers(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_triggers); ++i)
+		led_trigger_unregister(&marvell_led_triggers[i]);
+}
+
+static int marvell_led_set_regval(struct phy_device *phydev, int led, u16 val)
+{
+	u16 mask;
+	int reg;
+
+	switch (led) {
+	case 0 ... 3:
+		reg = MII_PHY_LED_CTRL;
+		break;
+	case 4 ... 5:
+		reg = MII_PHY_LED45_CTRL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val <<= (led % 4) * 4;
+	mask = 0xf << ((led % 4) * 4);
+
+	return phy_modify_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL, mask, val);
+}
+
+static inline int marvell_led_index(struct led_classdev *cdev)
+{
+	struct marvell_priv *priv = to_phy_device(cdev->dev->parent)->priv;
+
+	return cdev - &priv->leds[0];
+}
+
+static int _marvell_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness,
+				       bool check_trigger)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct marvell_priv *priv = phydev->priv;
+	int led;
+	u8 val;
+
+	/* don't do anything if one of HW triggers is set */
+	if (check_trigger && &marvell_led_triggers[0] <= cdev->trigger &&
+	    cdev->trigger < &marvell_led_triggers[ARRAY_SIZE(marvell_led_triggers)])
+		return 0;
+
+	led = cdev - &priv->leds[0];
+	val = brightness ? MII_PHY_LED_CTRL_FORCE_ON : MII_PHY_LED_CTRL_FORCE_OFF;
+
+	return marvell_led_set_regval(phydev, marvell_led_index(cdev), val);
+}
+
+static int marvell_led_brightness_set_blocking(struct led_classdev *cdev,
+					       enum led_brightness brightness)
+{
+	return _marvell_led_brightness_set(cdev, brightness, true);
+}
+
+static int marvell_led_trigger_activate(struct led_classdev *cdev)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct marvell_priv *priv = phydev->priv;
+	int trig, led;
+	s8 regval;
+
+	trig = cdev->trigger - &marvell_led_triggers[0];
+	led = cdev - &priv->leds[0];
+
+	regval = marvell_led_trigger_info[trig][led];
+	if (regval < 0)
+		return -EOPNOTSUPP;
+
+	return marvell_led_set_regval(phydev, led, regval);
+}
+
+static void marvell_led_trigger_deactivate(struct led_classdev *cdev)
+{
+	_marvell_led_brightness_set(cdev, cdev->brightness, false);
+}
+
+static int marvell_register_led(struct phy_device *phydev, struct device_node *np)
+{
+	struct marvell_priv *priv = phydev->priv;
+	struct led_init_data init_data = {};
+	struct led_classdev *cdev;
+	u32 reg, color;
+	int err;
+
+	err = of_property_read_u32(np, "reg", &reg);
+	if (err < 0)
+		return err;
+
+	/*
+	 * Maybe we should check here if reg >= nleds, where nleds is number of LEDs of this specific
+	 * PHY.
+	 */
+	if (reg >= MARVELL_PHY_MAX_LEDS) {
+		phydev_err(phydev, "LED node %pOF has invaling 'reg' property %u\n", np, reg);
+		return -EINVAL;
+	}
+
+	cdev = &priv->leds[reg];
+
+	err = of_property_read_u32(np, "color", &color);
+	if (err < 0) {
+		phydev_err(phydev, "LED node %pOF does not specify color\n", np);
+		return -EINVAL;
+	}
+
+#if 0
+	/* LED_COLOR_ID_MULTI is not yet merged in Linus' tree */
+	/* TODO: Support DUAL MODE */
+	if (color == LED_COLOR_ID_MULTI) {
+		phydev_warn(phydev, "node %pOF: This driver does not yet support multicolor LEDs\n",
+			    np);
+		return -ENOTSUPP;
+	}
+#endif
+
+	init_data.fwnode = &np->fwnode;
+	init_data.devname_mandatory = true;
+	init_data.devicename = phydev->attached_dev ? netdev_name(phydev->attached_dev) : "";
+
+	if (cdev->max_brightness) {
+		phydev_err(phydev, "LED node %pOF 'reg' property collision with another LED\n", np);
+		return -EEXIST;
+	}
+
+	cdev->max_brightness = 1;
+	cdev->brightness_set_blocking = marvell_led_brightness_set_blocking;
+	cdev->trigger_type = &marvell_led_trigger_type;
+
+	of_property_read_string(np, "linux,default-trigger", &cdev->default_trigger);
+
+	err = devm_led_classdev_register_ext(&phydev->mdio.dev, cdev, &init_data);
+	if (err < 0) {
+		phydev_err(phydev, "Cannot register LED %pOF: %i\n", np, err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void marvell_register_leds(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device_node *leds, *led;
+
+	leds = of_get_child_by_name(node, "leds");
+	if (!leds)
+		return;
+
+	for_each_available_child_of_node(leds, led) {
+		/* Should this check if some LED registration failed? */
+		marvell_register_led(phydev, led);
+	}
+}
+
+#else /* !IS_ENABLED(CONFIG_MARVELL_PHY_LEDS) */
+
+static inline int marvell_register_led_triggers(void)
+{
+	return 0;
+}
+
+static inline void marvell_unregister_led_triggers(void)
+{
+}
+
+static inline void marvell_register_leds(struct phy_device *phydev)
+{
+}
+
+#endif /* !IS_ENABLED(CONFIG_MARVELL_PHY_LEDS) */
+
 static void marvell_config_led(struct phy_device *phydev)
 {
 	u16 def_config;
@@ -692,6 +970,8 @@ static void marvell_config_led(struct phy_device *phydev)
 			      def_config);
 	if (err < 0)
 		phydev_warn(phydev, "Fail to config marvell phy LED.\n");
+
+	marvell_register_leds(phydev);
 }
 
 static int marvell_config_init(struct phy_device *phydev)
@@ -2989,7 +3269,32 @@ static struct phy_driver marvell_drivers[] = {
 	},
 };
 
-module_phy_driver(marvell_drivers);
+static int __init phy_module_init(void)
+{
+	int ret;
+
+	ret = marvell_register_led_triggers();
+	if (ret < 0)
+		return ret;
+
+	ret = phy_drivers_register(marvell_drivers, ARRAY_SIZE(marvell_drivers), THIS_MODULE);
+	if (ret < 0) {
+		marvell_unregister_led_triggers();
+		return ret;
+	}
+
+	return 0;
+}
+
+module_init(phy_module_init);
+
+static void __exit phy_module_exit(void)
+{
+	phy_drivers_unregister(marvell_drivers, ARRAY_SIZE(marvell_drivers));
+	marvell_unregister_led_triggers();
+}
+
+module_exit(phy_module_exit);
 
 static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1101, MARVELL_PHY_ID_MASK },
-- 
2.26.2

