Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E1D22CB4E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGXQqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgGXQqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:46:06 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF49C0619D3;
        Fri, 24 Jul 2020 09:46:06 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 4E4EE1409DB;
        Fri, 24 Jul 2020 18:46:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595609164; bh=6l3UEN9HKkuWGgM/vp2xZ0eCEFH5x5KhXv43A9WJddI=;
        h=From:To:Date;
        b=UKhz6My+BI9KSp+MvjffE3U47DttAYBIJcUnqgPyfeB306E+G8Ntg1bG92W74ZVxB
         udtTG7ZDf4If4GCNKJQ72gOpdOeB429XFppc78/8+7T9mSM3/d2VIPEf633pePiVtD
         MpGjj7vtDLcstoZLfJO7ulELytdyL791pFRFQtgg=
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
Subject: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add support for PHY LEDs via LED class
Date:   Fri, 24 Jul 2020 18:46:03 +0200
Message-Id: <20200724164603.29148-3-marek.behun@nic.cz>
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

This patch adds support for controlling the LEDs connected to several
families of Marvell PHYs via the PHY HW LED trigger API. These families
are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More can
be added.

The code reads LEDs definitions from the device-tree node of the PHY.

This patch does not yet add support for compound LED modes. This could
be achieved via the LED multicolor framework (which is not yet in
upstream).

Settings such as HW blink rate or pulse stretch duration are not yet
supported, nor are LED polarity settings.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Kconfig   |   1 +
 drivers/net/phy/marvell.c | 364 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 365 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index ffea11f73acd..5428a8af26d2 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -462,6 +462,7 @@ config LXT_PHY
 
 config MARVELL_PHY
 	tristate "Marvell PHYs"
+	depends on LED_TRIGGER_PHY_HW
 	help
 	  Currently has a driver for the 88E1011S
 
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb86ac0bd092..08cd79a1aa8d 100644
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
@@ -271,10 +279,19 @@ static struct marvell_hw_stat marvell_hw_stats[] = {
 	{ "phy_receive_errors_fiber", 1, 21, 16},
 };
 
+struct marvell_phy_led {
+	struct led_classdev cdev;
+	u8 idx;
+};
+
+#define to_marvell_phy_led(l)	container_of(l, struct marvell_phy_led, cdev)
+
 struct marvell_priv {
 	u64 stats[ARRAY_SIZE(marvell_hw_stats)];
 	char *hwmon_name;
 	struct device *hwmon_dev;
+	struct marvell_phy_led leds[MARVELL_PHY_MAX_LEDS];
+	u32 led_flags;
 	bool cable_test_tdr;
 	u32 first;
 	u32 last;
@@ -662,6 +679,333 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
+enum {
+	L1V0_RECV		= BIT(0),
+	L1V0_COPPER		= BIT(1),
+	L1V5_100_FIBER		= BIT(2),
+	L1V5_100_10		= BIT(3),
+	L2V2_INIT		= BIT(4),
+	L2V2_PTP		= BIT(5),
+	L2V2_DUPLEX		= BIT(6),
+	L3V0_FIBER		= BIT(7),
+	L3V0_LOS		= BIT(8),
+	L3V5_TRANS		= BIT(9),
+	L3V7_FIBER		= BIT(10),
+	L3V7_DUPLEX		= BIT(11),
+};
+
+struct marvell_led_mode_info {
+	const char *name;
+	s8 regval[MARVELL_PHY_MAX_LEDS];
+	u32 flags;
+};
+
+static const struct marvell_led_mode_info marvell_led_mode_info[] = {
+	{ "link",			{ 0x0,  -1, 0x0,  -1,  -1,  -1, }, 0 },
+	{ "link/act",			{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, 0 },
+	{ "1Gbps/100Mbps/10Mbps",	{ 0x2,  -1,  -1,  -1,  -1,  -1, }, 0 },
+	{ "act",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, 0 },
+	{ "blink-act",			{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, 0 },
+	{ "tx",				{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, 0 },
+	{ "tx",				{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
+	{ "rx",				{  -1,  -1,  -1,  -1, 0x0, 0x0, }, 0 },
+	{ "rx",				{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },
+	{ "copper",			{ 0x6,  -1,  -1,  -1,  -1,  -1, }, 0 },
+	{ "copper",			{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
+	{ "1Gbps",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, 0 },
+	{ "link/rx",			{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, 0 },
+	{ "100Mbps-fiber",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
+	{ "100Mbps-10Mbps",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
+	{ "1Gbps-100Mbps",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, 0 },
+	{ "1Gbps-10Mbps",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, 0 },
+	{ "100Mbps",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, 0 },
+	{ "10Mbps",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, 0 },
+	{ "fiber",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
+	{ "fiber",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
+	{ "FullDuplex",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
+	{ "FullDuplex",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, 0 },
+	{ "FullDuplex/collision",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, 0 },
+	{ "FullDuplex/collision",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLEX },
+	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
+	{ "init",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
+	{ "los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
+	{ "hi-z",			{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, }, 0 },
+	{ "blink",			{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, 0 },
+};
+
+struct marvell_leds_info {
+	u32 family;
+	int nleds;
+	u32 flags;
+};
+
+#define LED(fam,n,flg)								\
+	{									\
+		.family = MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E##fam),	\
+		.nleds = (n),							\
+		.flags = (flg),							\
+	}									\
+
+static const struct marvell_leds_info marvell_leds_info[] = {
+	LED(1112,  4, L1V0_COPPER | L1V5_100_FIBER | L2V2_INIT | L3V0_LOS | L3V5_TRANS | L3V7_FIBER),
+	LED(1121R, 3, L1V5_100_10),
+	LED(1240,  6, L3V5_TRANS),
+	LED(1340S, 6, L1V0_COPPER | L1V5_100_FIBER | L2V2_PTP | L3V0_FIBER | L3V7_DUPLEX),
+	LED(1510,  3, L1V0_RECV | L1V5_100_FIBER | L2V2_DUPLEX),
+	LED(1545,  6, L1V0_COPPER | L1V5_100_FIBER | L3V0_FIBER | L3V7_DUPLEX),
+};
+
+static inline int marvell_led_reg(int led)
+{
+	switch (led) {
+	case 0 ... 3:
+		return MII_PHY_LED_CTRL;
+	case 4 ... 5:
+		return MII_PHY_LED45_CTRL;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int marvell_led_set_regval(struct phy_device *phydev, int led, u16 val)
+{
+	u16 mask;
+	int reg;
+
+	reg = marvell_led_reg(led);
+	if (reg < 0)
+		return reg;
+
+	val <<= (led % 4) * 4;
+	mask = 0xf << ((led % 4) * 4);
+
+	return phy_modify_paged(phydev, MII_MARVELL_LED_PAGE, reg, mask, val);
+}
+
+static int marvell_led_get_regval(struct phy_device *phydev, int led)
+{
+	int reg, val;
+
+	reg = marvell_led_reg(led);
+	if (reg < 0)
+		return reg;
+
+	val = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, reg);
+	if (val < 0)
+		return val;
+
+	val >>= (led % 4) * 4;
+	val &= 0xf;
+
+	return val;
+}
+
+static int marvell_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct marvell_phy_led *led = to_marvell_phy_led(cdev);
+	u8 val;
+
+	/* don't do anything if HW control is enabled */
+	if (cdev->trigger == &phy_hw_led_trig)
+		return 0;
+
+	val = brightness ? MII_PHY_LED_CTRL_FORCE_ON : MII_PHY_LED_CTRL_FORCE_OFF;
+
+	return marvell_led_set_regval(phydev, led->idx, val);
+}
+
+static inline bool is_valid_led_mode(struct marvell_priv *priv, struct marvell_phy_led *led,
+				     const struct marvell_led_mode_info *mode)
+{
+	return mode->regval[led->idx] != -1 && (!mode->flags || (priv->led_flags & mode->flags));
+}
+
+static const char *marvell_led_iter_hw_mode(struct phy_device *phydev, struct led_classdev *cdev,
+					    void **iter)
+{
+	struct marvell_phy_led *led = to_marvell_phy_led(cdev);
+	const struct marvell_led_mode_info *mode = *iter;
+	struct marvell_priv *priv = phydev->priv;
+
+	if (!mode)
+		mode = marvell_led_mode_info;
+
+	if (mode - marvell_led_mode_info == ARRAY_SIZE(marvell_led_mode_info))
+		goto end;
+
+	while (!is_valid_led_mode(priv, led, mode)) {
+		++mode;
+		if (mode - marvell_led_mode_info == ARRAY_SIZE(marvell_led_mode_info))
+			goto end;
+	}
+
+	*iter = (void *)(mode + 1);
+	return mode->name;
+end:
+	*iter = NULL;
+	return NULL;
+}
+
+static int marvell_led_set_hw_mode(struct phy_device *phydev, struct led_classdev *cdev,
+				   const char *name)
+{
+	struct marvell_phy_led *led = to_marvell_phy_led(cdev);
+	struct marvell_priv *priv = phydev->priv;
+	const struct marvell_led_mode_info *mode;
+	int i;
+
+	if (!name)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_mode_info); ++i) {
+		mode = &marvell_led_mode_info[i];
+
+		if (!is_valid_led_mode(priv, led, mode))
+			continue;
+
+		if (sysfs_streq(name, mode->name))
+			return marvell_led_set_regval(phydev, led->idx, mode->regval[led->idx]);
+	}
+
+	return -EINVAL;
+}
+
+static const char *marvell_led_get_hw_mode(struct phy_device *phydev, struct led_classdev *cdev)
+{
+	struct marvell_phy_led *led = to_marvell_phy_led(cdev);
+	struct marvell_priv *priv = phydev->priv;
+	const struct marvell_led_mode_info *mode;
+	int i, regval;
+
+	regval = marvell_led_get_regval(phydev, led->idx);
+	if (regval < 0)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_mode_info); ++i) {
+		mode = &marvell_led_mode_info[i];
+
+		if (!is_valid_led_mode(priv, led, mode))
+			continue;
+
+		if (mode->regval[led->idx] == regval)
+			return mode->name;
+	}
+
+	return NULL;
+}
+
+static int marvell_register_led(struct phy_device *phydev, struct device_node *np, int nleds)
+{
+	struct marvell_priv *priv = phydev->priv;
+	struct led_init_data init_data = {};
+	struct marvell_phy_led *led;
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
+	if (reg >= nleds) {
+		phydev_err(phydev,
+			   "LED node %pOF 'reg' property too large (%u, PHY supports max %u)\n",
+			   np, reg, nleds - 1);
+		return -EINVAL;
+	}
+
+	led = &priv->leds[reg];
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
+	if (led->cdev.max_brightness) {
+		phydev_err(phydev, "LED node %pOF 'reg' property collision with another LED\n", np);
+		return -EEXIST;
+	}
+
+	led->cdev.max_brightness = 1;
+	led->cdev.brightness_set_blocking = marvell_led_brightness_set;
+	led->cdev.trigger_type = &phy_hw_led_trig_type;
+	led->idx = reg;
+
+	of_property_read_string(np, "linux,default-trigger", &led->cdev.default_trigger);
+
+	err = devm_led_classdev_register_ext(&phydev->mdio.dev, &led->cdev, &init_data);
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
+	struct marvell_priv *priv = phydev->priv;
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device_node *leds, *led;
+	const struct marvell_leds_info *info = NULL;
+	int i;
+
+	/* some families don't support LED control in this driver yet */
+	if (!phydev->drv->led_set_hw_mode)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_leds_info); ++i) {
+		if (MARVELL_PHY_FAMILY_ID(phydev->phy_id) == marvell_leds_info[i].family) {
+			info = &marvell_leds_info[i];
+			break;
+		}
+	}
+
+	if (!info)
+		return;
+
+	priv->led_flags = info->flags;
+
+#if 0
+	/*
+	 * TODO: here priv->led_flags should be changed so that hw_control values
+	 * for unsupported modes won't be shown. This cannot be deduced from
+	 * family only: for example the 88E1510 family contains 88E1510 which
+	 * does not support fiber, but also 88E1512, which supports fiber.
+	 */
+	switch (MARVELL_PHY_FAMILY_ID(phydev->phy_id)) {
+	}
+#endif
+
+	leds = of_get_child_by_name(node, "leds");
+	if (!leds)
+		return;
+
+	for_each_available_child_of_node(leds, led) {
+		/* Should this check if some LED registration failed? */
+		marvell_register_led(phydev, led, info->nleds);
+	}
+}
+
 static void marvell_config_led(struct phy_device *phydev)
 {
 	u16 def_config;
@@ -692,6 +1036,8 @@ static void marvell_config_led(struct phy_device *phydev)
 			      def_config);
 	if (err < 0)
 		phydev_warn(phydev, "Fail to config marvell phy LED.\n");
+
+	marvell_register_leds(phydev);
 }
 
 static int marvell_config_init(struct phy_device *phydev)
@@ -2656,6 +3002,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1111,
@@ -2717,6 +3066,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1318S,
@@ -2796,6 +3148,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1116R,
@@ -2844,6 +3199,9 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -2896,6 +3254,9 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -2964,6 +3325,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1548P,
-- 
2.26.2

