Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A52A230D05
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgG1PFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:05:36 -0400
Received: from lists.nic.cz ([217.31.204.67]:44844 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730530AbgG1PFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:05:35 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 9FB9B140BB4;
        Tue, 28 Jul 2020 17:05:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595948732; bh=mih9/eMGjTxKCbgxc/tx175Hm4SDJMekqQtelzers28=;
        h=From:To:Date;
        b=Y9Jsxt77vKyE1OZe9J2QBS0D4rRgB1m4L1nf6sffqFGq2FyxmE7gixXy5SiXLjCI2
         NFzX7uqzFr0sg8sUt5iUlvPfkkHkCGNFZbbPoD8ZVePL0g3pU8a2lkPrmV7rBDcIWH
         e1WNKdawSO2seFpztqr0WA2r9k49C47qrmicbgCU=
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
Subject: [PATCH RFC leds + net-next v4 2/2] net: phy: marvell: add support for PHY LEDs via LED class
Date:   Tue, 28 Jul 2020 17:05:30 +0200
Message-Id: <20200728150530.28827-3-marek.behun@nic.cz>
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

This patch adds support for controlling the LEDs connected to several
families of Marvell PHYs via the PHY HW LED trigger API. These families
are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More can
be added.

This patch does not yet add support for compound LED modes. This could
be achieved via the LED multicolor framework (which is not yet in
upstream).

Settings such as HW blink rate or pulse stretch duration are not yet
supported, nor are LED polarity settings.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/marvell.c | 287 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 287 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb86ac0bd092..55882ce24e67 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -148,6 +148,11 @@
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
@@ -252,6 +257,8 @@
 #define LPA_PAUSE_FIBER		0x180
 #define LPA_PAUSE_ASYM_FIBER	0x100
 
+#define MARVELL_PHY_MAX_LEDS	6
+
 #define NB_FIBER_STATS	1
 
 MODULE_DESCRIPTION("Marvell PHY driver");
@@ -662,6 +669,244 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_PHY_LEDS)
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
+#define LED(fam,n,flg)								\
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
+static int marvell_led_brightness_set(struct phy_device *phydev, struct phy_device_led *led,
+				      enum led_brightness brightness)
+{
+	u8 val;
+
+	/* don't do anything if HW control is enabled */
+	if (led->cdev.trigger == &phy_hw_led_trig)
+		return 0;
+
+	val = brightness ? MII_PHY_LED_CTRL_FORCE_ON : MII_PHY_LED_CTRL_FORCE_OFF;
+
+	return marvell_led_set_regval(phydev, led->addr, val);
+}
+
+static inline bool is_valid_led_mode(struct phy_device_led *led,
+				     const struct marvell_led_mode_info *mode)
+{
+	return mode->regval[led->addr] != -1 && (led->flags & mode->flags);
+}
+
+static const char *marvell_led_iter_hw_mode(struct phy_device *phydev, struct phy_device_led *led,
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
+static int marvell_led_set_hw_mode(struct phy_device *phydev, struct phy_device_led *led,
+				   const char *name)
+{
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
+static const char *marvell_led_get_hw_mode(struct phy_device *phydev, struct phy_device_led *led)
+{
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
+static int marvell_led_init(struct phy_device *phydev, struct phy_device_led *led)
+{
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
+		return -ENOTSUPP;
+
+	if (led->addr >= info->nleds)
+		return -EINVAL;
+
+	led->flags = info->flags;
+	led->cdev.max_brightness = 1;
+
+	return 0;
+}
+
+#endif /* IS_ENABLED(CONFIG_PHY_LEDS) */
+
 static void marvell_config_led(struct phy_device *phydev)
 {
 	u16 def_config;
@@ -2656,6 +2901,13 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+		.led_init = marvell_led_init,
+		.led_brightness_set = marvell_led_brightness_set,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
+#endif
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1111,
@@ -2717,6 +2969,13 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+		.led_init = marvell_led_init,
+		.led_brightness_set = marvell_led_brightness_set,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
+#endif
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1318S,
@@ -2796,6 +3055,13 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+		.led_init = marvell_led_init,
+		.led_brightness_set = marvell_led_brightness_set,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
+#endif
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1116R,
@@ -2844,6 +3110,13 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+		.led_init = marvell_led_init,
+		.led_brightness_set = marvell_led_brightness_set,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
+#endif
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -2896,6 +3169,13 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+		.led_init = marvell_led_init,
+		.led_brightness_set = marvell_led_brightness_set,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
+#endif
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -2964,6 +3244,13 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+#if IS_ENABLED(CONFIG_PHY_LEDS)
+		.led_init = marvell_led_init,
+		.led_brightness_set = marvell_led_brightness_set,
+		.led_iter_hw_mode = marvell_led_iter_hw_mode,
+		.led_set_hw_mode = marvell_led_set_hw_mode,
+		.led_get_hw_mode = marvell_led_get_hw_mode,
+#endif
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1548P,
-- 
2.26.2

