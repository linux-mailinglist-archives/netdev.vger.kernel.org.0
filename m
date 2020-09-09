Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F8E26322B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgIIQgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:36:18 -0400
Received: from mail.nic.cz ([217.31.204.67]:34820 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731068AbgIIQ0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:26:06 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id A4CB5140A77;
        Wed,  9 Sep 2020 18:25:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668755; bh=CCID+6XO7E5eXop8eKP/NFb1pvL8WXiQXdWzIDrO1ko=;
        h=From:To:Date;
        b=R6qBombeGlUUJI8+cD9oVr800xcBkPHmLu9PoxsEh9GYi5WmDhU2uYJ5Q1Z1euztx
         aI+N6LjqzkoFeGn7xzuRS4eqSgaQ84EFPqgQw6Z+qWwIQI1MNL0FA0VADA88Ssb+xc
         xd2B9yPTQa/694GSdImzwU4rDjxPBKBhTUIh3ryE=
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
Subject: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support for LEDs controlled by Marvell PHYs
Date:   Wed,  9 Sep 2020 18:25:51 +0200
Message-Id: <20200909162552.11032-7-marek.behun@nic.cz>
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

This patch adds support for controlling the LEDs connected to several
families of Marvell PHYs via the PHY HW LED trigger API. These families
are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More can
be added.

This patch does not yet add support for compound LED modes. This could
be achieved via the LED multicolor framework.

Settings such as HW blink rate or pulse stretch duration are not yet
supported.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/marvell.c | 314 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 312 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb86ac0bd0920..7aedb529e1540 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -148,6 +148,13 @@
 #define MII_88E1510_PHY_LED_DEF		0x1177
 #define MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE	0x1040
 
+#define MII_PHY_LED_POLARITY_CTRL	17
+#define MII_PHY_LED_TIMER_CTRL		18
+#define MII_PHY_LED45_CTRL		19
+
+#define MII_PHY_LED_CTRL_FORCE_ON	0x9
+#define MII_PHY_LED_CTRL_FORCE_OFF	0x8
+
 #define MII_M1011_PHY_STATUS		0x11
 #define MII_M1011_PHY_STATUS_1000	0x8000
 #define MII_M1011_PHY_STATUS_100	0x4000
@@ -252,6 +259,8 @@
 #define LPA_PAUSE_FIBER		0x180
 #define LPA_PAUSE_ASYM_FIBER	0x100
 
+#define MARVELL_PHY_MAX_LEDS	6
+
 #define NB_FIBER_STATS	1
 
 MODULE_DESCRIPTION("Marvell PHY driver");
@@ -280,6 +289,7 @@ struct marvell_priv {
 	u32 last;
 	u32 step;
 	s8 pair;
+	u16 legacy_led_config_mask;
 };
 
 static int marvell_read_page(struct phy_device *phydev)
@@ -662,8 +672,300 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED)
+
+enum {
+	COMMON			= BIT(0),
+	L1V0_RECV		= BIT(1),
+	L1V0_COPPER		= BIT(2),
+	L1V5_100_FIBER		= BIT(3),
+	L1V5_100_10		= BIT(4),
+	L2V2_INIT		= BIT(5),
+	L2V2_PTP		= BIT(6),
+	L2V2_DUPLEX		= BIT(7),
+	L3V0_FIBER		= BIT(8),
+	L3V0_LOS		= BIT(9),
+	L3V5_TRANS		= BIT(10),
+	L3V7_FIBER		= BIT(11),
+	L3V7_DUPLEX		= BIT(12),
+};
+
+struct marvell_led_mode_info {
+	const char *name;
+	s8 regval[MARVELL_PHY_MAX_LEDS];
+	u32 flags;
+};
+
+static const struct marvell_led_mode_info marvell_led_mode_info[] = {
+	{ "link",			{ 0x0,  -1, 0x0,  -1,  -1,  -1, }, COMMON },
+	{ "link/act",			{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, COMMON },
+	{ "1Gbps/100Mbps/10Mbps",	{ 0x2,  -1,  -1,  -1,  -1,  -1, }, COMMON },
+	{ "act",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, COMMON },
+	{ "blink-act",			{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, COMMON },
+	{ "tx",				{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, COMMON },
+	{ "tx",				{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
+	{ "rx",				{  -1,  -1,  -1,  -1, 0x0, 0x0, }, COMMON },
+	{ "rx",				{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },
+	{ "copper",			{ 0x6,  -1,  -1,  -1,  -1,  -1, }, COMMON },
+	{ "copper",			{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
+	{ "1Gbps",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, COMMON },
+	{ "link/rx",			{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, COMMON },
+	{ "100Mbps-fiber",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
+	{ "100Mbps-10Mbps",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
+	{ "1Gbps-100Mbps",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, COMMON },
+	{ "1Gbps-10Mbps",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, COMMON },
+	{ "100Mbps",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, COMMON },
+	{ "10Mbps",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, COMMON },
+	{ "fiber",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
+	{ "fiber",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
+	{ "FullDuplex",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
+	{ "FullDuplex",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, COMMON },
+	{ "FullDuplex/collision",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, COMMON },
+	{ "FullDuplex/collision",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLEX },
+	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
+	{ "init",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
+	{ "los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
+	{ "blink",			{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, COMMON },
+};
+
+struct marvell_leds_info {
+	u32 family;
+	int nleds;
+	u32 flags;
+};
+
+#define LED(fam, n, flg)							\
+	{									\
+		.family = MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E##fam),	\
+		.nleds = (n),							\
+		.flags = (flg),							\
+	}									\
+
+static const struct marvell_leds_info marvell_leds_info[] = {
+	LED(1112,  4, COMMON | L1V0_COPPER | L1V5_100_FIBER | L2V2_INIT | L3V0_LOS | L3V5_TRANS |
+		      L3V7_FIBER),
+	LED(1121R, 3, COMMON | L1V5_100_10),
+	LED(1240,  6, COMMON | L3V5_TRANS),
+	LED(1340S, 6, COMMON | L1V0_COPPER | L1V5_100_FIBER | L2V2_PTP | L3V0_FIBER | L3V7_DUPLEX),
+	LED(1510,  3, COMMON | L1V0_RECV | L1V5_100_FIBER | L2V2_DUPLEX),
+	LED(1545,  6, COMMON | L1V0_COPPER | L1V5_100_FIBER | L3V0_FIBER | L3V7_DUPLEX),
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
+static int marvell_led_set_polarity(struct phy_device *phydev, int led, bool active_low,
+				    bool tristate)
+{
+	int reg, shift;
+	u16 mask, val;
+
+	switch (led) {
+	case 0 ... 3:
+		reg = MII_PHY_LED_POLARITY_CTRL;
+		break;
+	case 4 ... 5:
+		reg = MII_PHY_LED45_CTRL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val = 0;
+	if (!active_low)
+		val |= BIT(0);
+	if (tristate)
+		val |= BIT(1);
+
+	shift = led * 2;
+	val <<= shift;
+	mask = 0x3 << shift;
+
+	return phy_modify_paged(phydev, MII_MARVELL_LED_PAGE, reg, mask, val);
+}
+
+static int marvell_led_brightness_set(struct device *dev, struct hw_controlled_led *led,
+				      enum led_brightness brightness)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	u8 val;
+
+	/* don't do anything if HW control is enabled */
+	if (led->cdev.trigger == &hw_control_led_trig)
+		return 0;
+
+	val = brightness ? MII_PHY_LED_CTRL_FORCE_ON : MII_PHY_LED_CTRL_FORCE_OFF;
+
+	return marvell_led_set_regval(phydev, led->addr, val);
+}
+
+static inline bool is_valid_led_mode(struct hw_controlled_led *led,
+				     const struct marvell_led_mode_info *mode)
+{
+	const struct marvell_leds_info *info = led->priv;
+
+	return mode->regval[led->addr] != -1 && (info->flags & mode->flags);
+}
+
+static const char *marvell_led_iter_hw_mode(struct device *dev, struct hw_controlled_led *led,
+					    void **iter)
+{
+	const struct marvell_led_mode_info *mode = *iter;
+
+	if (!mode)
+		mode = marvell_led_mode_info;
+
+	if (mode - marvell_led_mode_info == ARRAY_SIZE(marvell_led_mode_info))
+		goto end;
+
+	while (!is_valid_led_mode(led, mode)) {
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
+static int marvell_led_set_hw_mode(struct device *dev, struct hw_controlled_led *led,
+				   const char *name)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	const struct marvell_led_mode_info *mode;
+	int i;
+
+	if (!name)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_mode_info); ++i) {
+		mode = &marvell_led_mode_info[i];
+
+		if (!is_valid_led_mode(led, mode))
+			continue;
+
+		if (sysfs_streq(name, mode->name))
+			return marvell_led_set_regval(phydev, led->addr, mode->regval[led->addr]);
+	}
+
+	return -EINVAL;
+}
+
+static const char *marvell_led_get_hw_mode(struct device *dev, struct hw_controlled_led *led)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	const struct marvell_led_mode_info *mode;
+	int i, regval;
+
+	regval = marvell_led_get_regval(phydev, led->addr);
+	if (regval < 0)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_mode_info); ++i) {
+		mode = &marvell_led_mode_info[i];
+
+		if (!is_valid_led_mode(led, mode))
+			continue;
+
+		if (mode->regval[led->addr] == regval)
+			return mode->name;
+	}
+
+	return NULL;
+}
+
+static int marvell_led_init(struct device *dev, struct hw_controlled_led *led)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+	const struct marvell_leds_info *info = NULL;
+	struct marvell_priv *priv = phydev->priv;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(marvell_leds_info); ++i) {
+		if (MARVELL_PHY_FAMILY_ID(phydev->phy_id) == marvell_leds_info[i].family) {
+			info = &marvell_leds_info[i];
+			break;
+		}
+	}
+
+	if (!info)
+		return -EOPNOTSUPP;
+
+	if (led->addr >= info->nleds)
+		return -EINVAL;
+
+	led->priv = (void *)info;
+	led->cdev.max_brightness = 1;
+
+	ret = marvell_led_set_polarity(phydev, led->addr, led->active_low, led->tristate);
+	if (ret < 0)
+		return ret;
+
+	/* ensure marvell_config_led below does not change settings we have set for this LED */
+	if (led->addr < 3)
+		priv->legacy_led_config_mask &= ~(0xf << (led->addr * 4));
+
+	return 0;
+}
+
+static const struct hw_controlled_led_ops marvell_led_ops = {
+	.led_init		= marvell_led_init,
+	.led_brightness_set	= marvell_led_brightness_set,
+	.led_iter_hw_mode	= marvell_led_iter_hw_mode,
+	.led_set_hw_mode	= marvell_led_set_hw_mode,
+	.led_get_hw_mode	= marvell_led_get_hw_mode,
+};
+
+#endif /* IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */
+
 static void marvell_config_led(struct phy_device *phydev)
 {
+	struct marvell_priv *priv = phydev->priv;
 	u16 def_config;
 	int err;
 
@@ -688,8 +990,9 @@ static void marvell_config_led(struct phy_device *phydev)
 		return;
 	}
 
-	err = phy_write_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL,
-			      def_config);
+	def_config &= priv->legacy_led_config_mask;
+	err = phy_modify_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL,
+			       priv->legacy_led_config_mask, def_config);
 	if (err < 0)
 		phydev_warn(phydev, "Fail to config marvell phy LED.\n");
 }
@@ -2580,6 +2883,7 @@ static int marvell_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->legacy_led_config_mask = 0xffff;
 	phydev->priv = priv;
 
 	return 0;
@@ -2656,6 +2960,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+		.led_ops = hw_controlled_led_ops_ptr(&marvell_led_ops),
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1111,
@@ -2717,6 +3022,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+		.led_ops = hw_controlled_led_ops_ptr(&marvell_led_ops),
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1318S,
@@ -2796,6 +3102,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.led_ops = hw_controlled_led_ops_ptr(&marvell_led_ops),
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1116R,
@@ -2844,6 +3151,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_ops = hw_controlled_led_ops_ptr(&marvell_led_ops),
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -2896,6 +3204,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_ops = hw_controlled_led_ops_ptr(&marvell_led_ops),
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -2964,6 +3273,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		.led_ops = hw_controlled_led_ops_ptr(&marvell_led_ops),
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1548P,
-- 
2.26.2

