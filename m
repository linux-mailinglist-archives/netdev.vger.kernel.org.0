Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928BC22B578
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgGWSNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgGWSNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:13:23 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF338C0619E2;
        Thu, 23 Jul 2020 11:13:22 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 71A9F140A9C;
        Thu, 23 Jul 2020 20:13:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595528000; bh=Q/LHB/T0Lvg0Tn2wNFyqSuFbO/DGeW2atOBiVJySvB4=;
        h=From:To:Date;
        b=j5ocxyncjeeV5zblyPKQdzfUM8S0XA4VXP7REiEFaL9HYcbEFP9csqNsGbch7agUM
         +pniv1oWVkLY0GTaoIIcskoGII76PyHU0kDeKXUaCXxx5JV6Ptp8Z1s7vBX7nUDW+E
         DrXrVGrrfJCNDY2JZvD/QTp9ra1bRm9bDeCQK9XM=
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
Subject: [PATCH RFC leds + net-next v2 1/1] net: phy: marvell: add support for PHY LEDs via LED class
Date:   Thu, 23 Jul 2020 20:13:19 +0200
Message-Id: <20200723181319.15988-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723181319.15988-1-marek.behun@nic.cz>
References: <20200723181319.15988-1-marek.behun@nic.cz>
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
families of Marvell PHYs via Linux' LED API. These families are:
88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More can be
added.

The code reads LEDs definitions from the device-tree node of the PHY.

Since the LEDs can be controlled by hardware, we add one LED-private LED
trigger named "hw-control". This trigger is private and displayed only
for Marvell PHY LEDs.

When this driver is activated, another sysfs file is created in that
LEDs sysfs directory, names "hw_control". This file contains space
separated list of possible HW controlled modes for this LED. The one
which is selected is enclosed by square brackets. To change HW control
mode the user has to write the name of desired mode to this "hw_control"
file.

This patch does not yet add support for compound LED modes. This could
be achieved via the LED multicolor framework (which is not yet in
upstream).

Settings such as HW blink rate or pulse stretch duration are not yet
supported, nor are LED polarity settings.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/Kconfig   |   7 +
 drivers/net/phy/marvell.c | 423 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 429 insertions(+), 1 deletion(-)

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
index bb86ac0bd092..e2bb2cc889ef 100644
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
@@ -271,10 +279,23 @@ static struct marvell_hw_stat marvell_hw_stats[] = {
 	{ "phy_receive_errors_fiber", 1, 21, 16},
 };
 
+struct marvell_phy_led {
+	struct led_classdev cdev;
+	u8 idx;
+	/* register value when in HW ctrl mode */
+	u8 regval;
+};
+
+#define to_marvell_phy_led(l)	container_of(l, struct marvell_phy_led, cdev)
+
 struct marvell_priv {
 	u64 stats[ARRAY_SIZE(marvell_hw_stats)];
 	char *hwmon_name;
 	struct device *hwmon_dev;
+#if IS_ENABLED(CONFIG_MARVELL_PHY_LEDS)
+	struct marvell_phy_led leds[MARVELL_PHY_MAX_LEDS];
+	u32 led_flags;
+#endif
 	bool cable_test_tdr;
 	u32 first;
 	u32 last;
@@ -662,6 +683,379 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_MARVELL_PHY_LEDS)
+
+static struct led_hw_trigger_type marvell_led_trigger_type;
+
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
+struct marvell_led_ctrl_info {
+	const char *name;
+	s8 regval[MARVELL_PHY_MAX_LEDS];
+	u32 flags;
+};
+
+static const struct marvell_led_ctrl_info marvell_led_ctrl_info[] = {
+	{ "link/nolink",		{ 0x0,  -1, 0x0,  -1,  -1,  -1, }, 0 },
+	{ "link/act/nolink",		{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, 0 },
+	{ "1000/100/10/nolink",		{ 0x2,  -1,  -1,  -1,  -1,  -1, }, 0 },
+	{ "act/noact",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, 0 },
+	{ "blink-act/noact",		{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, 0 },
+	{ "transmit/notransmit",	{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, 0 },
+	{ "transmit/notransmit",	{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
+	{ "recv/norecv",		{  -1,  -1,  -1,  -1, 0x0, 0x0, }, 0 },
+	{ "recv/norecv",		{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },
+	{ "copperlink/else",		{ 0x6,  -1,  -1,  -1,  -1,  -1, }, 0 },
+	{ "copperlink/else",		{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
+	{ "1000/else",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, 0 },
+	{ "link/recv/nolink",		{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, 0 },
+	{ "100-fiber/else",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
+	{ "100-10/else",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
+	{ "1000-100/else",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, 0 },
+	{ "1000-10/else",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, 0 },
+	{ "100/else",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, 0 },
+	{ "10/else",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, 0 },
+	{ "fiber/else",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
+	{ "fiber/else",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
+	{ "full/half",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
+	{ "full/half",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, 0 },
+	{ "full/collision/half",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, 0 },
+	{ "full/collision/half",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLEX },
+	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
+	{ "normal-init",		{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
+	{ "normal-los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
+	{ "force-hi-z",			{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, }, 0 },
+	{ "force-blink",		{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, 0 },
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
+static struct led_trigger marvell_hw_led_trigger;
+
+static int _marvell_led_brightness_set(struct led_classdev *cdev, enum led_brightness brightness,
+				       bool check_trigger)
+{
+	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
+	struct marvell_phy_led *led = to_marvell_phy_led(cdev);
+	u8 val;
+
+	/* don't do anything if HW control is enabled */
+	if (check_trigger && cdev->trigger == &marvell_hw_led_trigger)
+		return 0;
+
+	val = brightness ? MII_PHY_LED_CTRL_FORCE_ON : MII_PHY_LED_CTRL_FORCE_OFF;
+
+	return marvell_led_set_regval(phydev, led->idx, val);
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
+	struct marvell_phy_led *led = to_marvell_phy_led(cdev);
+
+	return marvell_led_set_regval(phydev, led->idx, led->regval);
+}
+
+static void marvell_led_trigger_deactivate(struct led_classdev *cdev)
+{
+	_marvell_led_brightness_set(cdev, cdev->brightness, false);
+}
+
+static ssize_t hw_control_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct marvell_phy_led *led = to_marvell_phy_led(led_trigger_get_led(dev));
+	struct phy_device *phydev = to_phy_device(led->cdev.dev->parent);
+	const struct marvell_led_ctrl_info *info;
+	struct marvell_priv *priv = phydev->priv;
+	int i, len = 0;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_ctrl_info); ++i) {
+		bool sel;
+
+		info = &marvell_led_ctrl_info[i];
+
+		/* skip HW triggers unsupported by this LED */
+		if (info->regval[led->idx] == -1)
+			continue;
+
+		if (info->flags && !(priv->led_flags & info->flags))
+			continue;
+
+		sel = led->regval == info->regval[led->idx];
+
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s%s%c", sel ? "[" : "", info->name,
+				 sel ? "]" : "",
+				 i == ARRAY_SIZE(marvell_led_ctrl_info) - 1 ? '\n' : ' ');
+	}
+
+	return len;
+}
+
+static ssize_t hw_control_store(struct device *dev, struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	struct marvell_phy_led *led = to_marvell_phy_led(led_trigger_get_led(dev));
+	struct phy_device *phydev = to_phy_device(led->cdev.dev->parent);
+	const struct marvell_led_ctrl_info *info;
+	struct marvell_priv *priv = phydev->priv;
+	int i, ret = -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_ctrl_info); ++i) {
+		info = &marvell_led_ctrl_info[i];
+
+		/* skip HW triggers unsupported by this LED */
+		if (info->regval[led->idx] == -1)
+			continue;
+
+		if (info->flags && !(priv->led_flags & info->flags))
+			continue;
+
+		if (sysfs_streq(buf, info->name)) {
+			ret = marvell_led_set_regval(phydev, led->idx, info->regval[led->idx]);
+			if (!ret)
+				led->regval = info->regval[led->idx];
+			break;
+		}
+	}
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_RW(hw_control);
+
+static struct attribute *marvell_led_trig_attrs[] = {
+	&dev_attr_hw_control.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(marvell_led_trig);
+
+static struct led_trigger marvell_hw_led_trigger = {
+	.name		= "hw-control",
+	.activate	= marvell_led_trigger_activate,
+	.deactivate	= marvell_led_trigger_deactivate,
+	.trigger_type	= &marvell_led_trigger_type,
+	.groups		= marvell_led_trig_groups,
+};
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
+	led->cdev.brightness_set_blocking = marvell_led_brightness_set_blocking;
+	led->cdev.trigger_type = &marvell_led_trigger_type;
+	led->idx = reg;
+	led->regval = marvell_led_get_regval(phydev, reg);
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
+static inline int marvell_leds_init(void)
+{
+	return led_trigger_register(&marvell_hw_led_trigger);
+}
+
+static inline void marvell_leds_exit(void)
+{
+	led_trigger_unregister(&marvell_hw_led_trigger);
+}
+
+#else /* !IS_ENABLED(CONFIG_MARVELL_PHY_LEDS) */
+
+static inline void marvell_register_leds(struct phy_device *phydev)
+{
+}
+
+static inline int marvell_leds_init(void)
+{
+	return 0;
+}
+
+static inline void marvell_leds_exit(void)
+{
+}
+
+#endif /* !IS_ENABLED(CONFIG_MARVELL_PHY_LEDS) */
+
 static void marvell_config_led(struct phy_device *phydev)
 {
 	u16 def_config;
@@ -692,6 +1086,8 @@ static void marvell_config_led(struct phy_device *phydev)
 			      def_config);
 	if (err < 0)
 		phydev_warn(phydev, "Fail to config marvell phy LED.\n");
+
+	marvell_register_leds(phydev);
 }
 
 static int marvell_config_init(struct phy_device *phydev)
@@ -2989,7 +3385,32 @@ static struct phy_driver marvell_drivers[] = {
 	},
 };
 
-module_phy_driver(marvell_drivers);
+static int __init phy_module_init(void)
+{
+	int ret;
+
+	ret = marvell_leds_init();
+	if (ret < 0)
+		return ret;
+
+	ret = phy_drivers_register(marvell_drivers, ARRAY_SIZE(marvell_drivers), THIS_MODULE);
+	if (ret < 0) {
+		marvell_leds_exit();
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
+	marvell_leds_exit();
+}
+
+module_exit(phy_module_exit);
 
 static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1101, MARVELL_PHY_ID_MASK },
-- 
2.26.2

