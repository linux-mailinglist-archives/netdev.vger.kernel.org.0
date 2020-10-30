Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F472A049E
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgJ3LpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgJ3LpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:45:00 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B59221FF;
        Fri, 30 Oct 2020 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058298;
        bh=NBOZhauj4WTg86VxfkfBjwilzEvHXZmrdaQO7yOpeCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1uJwAZGvmV28HcongR7LMvD2fOhQcccCYDRukoanr8BGlyvvMDRQrupC8GBm0fnk
         5gm5ciEoPkU/oGHMqVSvl7tgrZg80u1dh0El7zx6P6qdBRnXMwQVx1RJIQo5DpRRwK
         V1Xk+2pzygnoOBSLnF6uoVos6IYZKZ5soEc1ov9Q=
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
Subject: [PATCH RFC leds + net-next 7/7] net: phy: marvell: support LEDs connected on Marvell PHYs
Date:   Fri, 30 Oct 2020 12:44:35 +0100
Message-Id: <20201030114435.20169-8-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030114435.20169-1-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for controlling the LEDs connected to several families of
Marvell PHYs via Linux LED API. These families currently are: 88E1112,
88E1116R, 88E1118, 88E1121R, 88E1149R, 88E1240, 88E1318S, 88E1340S,
88E1510, 88E1545 and 88E1548P.

This does not yet add support for compound LED modes. This could be
achieved via the LED multicolor framework.

netdev trigger offloading is also implemented.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell.c | 388 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 383 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..ffbf8da7c0a3 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/ledtrig.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
@@ -143,9 +144,26 @@
 #define MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS		BIT(12)
 #define MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE	BIT(14)
 
-#define MII_PHY_LED_CTRL	        16
-#define MII_88E1121_PHY_LED_DEF		0x0030
-#define MII_88E1510_PHY_LED_DEF		0x1177
+#define MII_PHY_LED_CTRL		0x10
+#define MII_PHY_LED45_CTRL		0x13
+#define MII_PHY_LED_CTRL_OFF		0x8
+#define MII_PHY_LED_CTRL_ON		0x9
+#define MII_PHY_LED_CTRL_BLINK		0xb
+
+#define MII_PHY_LED_POLARITY_CTRL	0x11
+
+#define MII_PHY_LED_TCR			0x12
+#define MII_PHY_LED_TCR_PULSESTR_MASK	0x7000
+#define MII_PHY_LED_TCR_PULSESTR_SHIFT	12
+#define MII_PHY_LED_TCR_BLINKRATE_MASK	0x0700
+#define MII_PHY_LED_TCR_BLINKRATE_SHIFT	8
+#define MII_PHY_LED_TCR_SPDOFF_MASK	0x000c
+#define MII_PHY_LED_TCR_SPDOFF_SHIFT	2
+#define MII_PHY_LED_TCR_SPDON_MASK	0x0003
+#define MII_PHY_LED_TCR_SPDON_SHIFT	0
+
+#define MII_88E1121_PHY_LED_DEF			0x0030
+#define MII_88E1510_PHY_LED_DEF			0x1177
 #define MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE	0x1040
 
 #define MII_M1011_PHY_STATUS		0x11
@@ -280,6 +298,7 @@ struct marvell_priv {
 	u32 last;
 	u32 step;
 	s8 pair;
+	u16 legacy_led_config_mask;
 };
 
 static int marvell_read_page(struct phy_device *phydev)
@@ -662,8 +681,354 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_LEDS_CLASS)
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
+static int marvell_led_set_polarity(struct phy_device *phydev, int led,
+				    bool active_low, bool tristate)
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
+static int marvell_led_brightness_set(struct phy_device *phydev,
+				      struct phy_led *led,
+				      enum led_brightness brightness)
+{
+	u8 val;
+
+	/* don't do anything if a trigger is offloaded to HW */
+	if (led->cdev.offloaded)
+		return 0;
+
+	val = brightness ? MII_PHY_LED_CTRL_ON : MII_PHY_LED_CTRL_OFF;
+
+	return marvell_led_set_regval(phydev, led->addr, val);
+}
+
+static int marvell_led_round_blink_rate(unsigned long *period)
+{
+	/* Each interval is (0.7 * p, 1.3 * p), where p is the period supported
+	 * by the chip. Should we change this so that there are no holes between
+	 * these intervals?
+	 */
+	switch (*period) {
+	case 29 ... 55:
+		*period = 42;
+		return 0;
+	case 58 ... 108:
+		*period = 84;
+		return 1;
+	case 119 ... 221:
+		*period = 170;
+		return 2;
+	case 238 ... 442:
+		*period = 340;
+		return 3;
+	case 469 ... 871:
+		*period = 670;
+		return 4;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int marvell_leds_set_blink_rate(struct phy_device *phydev,
+				       unsigned long *period)
+{
+	int val;
+
+	val = marvell_led_round_blink_rate(period);
+	if (val < 0)
+		return val;
+
+	val = val << MII_PHY_LED_TCR_BLINKRATE_SHIFT &
+	      MII_PHY_LED_TCR_BLINKRATE_MASK;
+
+	return phy_modify_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_TCR,
+				MII_PHY_LED_TCR_BLINKRATE_MASK, val);
+}
+
+static int marvell_led_blink_set(struct phy_device *phydev, struct phy_led *led,
+				 unsigned long *on, unsigned long *off)
+{
+	unsigned long period;
+	int ret;
+
+	/* default to period 670ms, which is the maximum the HW is capable of */
+	if (!*on || !*off)
+		*on = *off = 670 / 2;
+
+	/* blink in software if there is more than 30% difference between the
+	 * delays
+	 */
+	if (*on * 100 / *off > 130 || *off * 100 / *on > 130)
+		return -EOPNOTSUPP;
+
+	period = *on + *off;
+
+	ret = marvell_leds_set_blink_rate(phydev, &period);
+	if (ret < 0)
+		return ret;
+
+	ret = marvell_led_set_regval(phydev, led->addr, MII_PHY_LED_CTRL_BLINK);
+	if (ret < 0)
+		return ret;
+
+	*on = *off = period / 2;
+
+	return 0;
+}
+
+#define BITIF(i, cond)			((cond) ? BIT(i) : 0)
+#define LED_MODE(link, tx, rx)					\
+	(BITIF(0, (link)) | BITIF(1, (tx)) | BITIF(2, (rx)))
+
+struct marvell_led_mode_info {
+	u32 key;
+	s8 regval[6];
+	enum {
+		COMMON	= BIT(0),
+		L1V0_RX	= BIT(1),
+		L3V5_TX	= BIT(2),
+	} flags;
+};
+
+struct marvell_leds_info {
+	u32 family;
+	int nleds;
+	u32 flags;
+};
+
+#define LED(f, n, flg)							\
+	{								\
+		.family = MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E##f),	\
+		.nleds = (n),						\
+		.flags = (flg),						\
+	}								\
+
+static const struct marvell_leds_info marvell_leds_info[] = {
+	LED(1112,  4, COMMON | L3V5_TX),
+	LED(1116R, 3, COMMON),
+	LED(1118,  3, COMMON),
+	LED(1121R, 3, COMMON),
+	LED(1149R, 4, COMMON | L3V5_TX),
+	LED(1240,  6, COMMON | L3V5_TX),
+	LED(1318S, 3, COMMON | L1V0_RX),
+	LED(1340S, 6, COMMON),
+	LED(1510,  3, COMMON | L1V0_RX),
+	LED(1545,  6, COMMON),
+	LED(1548P, 6, COMMON),
+};
+
+static const struct marvell_led_mode_info marvell_led_mode_info[] = {
+	{ LED_MODE(1, 0, 0), { 0x0,  -1, 0x0,  -1,  -1,  -1, }, COMMON },
+	{ LED_MODE(1, 1, 1), { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, COMMON },
+	{ LED_MODE(0, 1, 1), { 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, COMMON },
+	{ LED_MODE(1, 0, 1), {  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, COMMON },
+	{ LED_MODE(0, 1, 0), { 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, COMMON },
+	{ LED_MODE(0, 1, 0), {  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TX },
+	{ LED_MODE(0, 0, 1), {  -1,  -1,  -1,  -1, 0x0, 0x0, }, COMMON },
+	{ LED_MODE(0, 0, 1), {  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RX },
+};
+
+static int marvell_find_led_mode(struct phy_device *phydev, struct phy_led *led,
+				 struct led_netdev_data *trig)
+{
+	const struct marvell_leds_info *info = led->priv;
+	const struct marvell_led_mode_info *mode;
+	u32 key;
+	int i;
+
+	key = LED_MODE(trig->link, trig->tx, trig->rx);
+
+	for (i = 0; i < ARRAY_SIZE(marvell_led_mode_info); ++i) {
+		mode = &marvell_led_mode_info[i];
+
+		if (key != mode->key || mode->regval[led->addr] == -1 ||
+		    !(info->flags & mode->flags))
+			continue;
+
+		return mode->regval[led->addr];
+	}
+
+	dev_dbg(led->cdev.dev,
+		"cannot offload trigger configuration (%s, link=%i, tx=%i, rx=%i)\n",
+		netdev_name(trig->net_dev), trig->link, trig->tx, trig->rx);
+
+	return -1;
+}
+
+/* FIXME: Blinking rate is shared by all LEDs on a PHY. Should we check whether
+ * another LED is currently blinking with incompatible rate? It would be cleaner
+ * if we in this case failed to offload blinking this LED.
+ * But consider this situation:
+ *   1. user sets LED[1] to blink with period 500ms for some reason. This would
+ *      start blinking LED[1] with perion 670ms here
+ *   2. user sets netdev trigger to LED[0] to blink on activity, default there
+ *      is 100ms period, which would translate here to 84ms. This is
+ *      incompatible with the already blinking LED, so we fail to offload to HW,
+ *      and netdev trigger does software offloading instead.
+ *   3. user unsets blinking od LED[1], so now we theoretically can offload
+ *      netdev trigger to LED[0], but we don't know about it, and so it is left
+ *      in SW triggering until user writes the settings again
+ * This could be solved by the netdev trigger periodically trying to offload to
+ * HW if we reported that it is theoretically possible (by returning -EAGAIN
+ * instead of -EOPNOTSUPP, for example). Do we want to do this?
+ */
+static int marvell_led_trigger_offload(struct phy_device *phydev,
+				       struct phy_led *led, bool enable)
+{
+	struct led_netdev_data *trig = led_get_trigger_data(&led->cdev);
+	struct device *dev = led->cdev.dev;
+	unsigned long period;
+	int mode;
+	int ret;
+
+	if (!enable)
+		goto offload_disable;
+
+	/* Sanity checks first */
+	if (led->cdev.trigger != &netdev_led_trigger || !phydev->attached_dev ||
+	    phydev->attached_dev != trig->net_dev)
+		goto offload_disable;
+
+	mode = marvell_find_led_mode(phydev, led, trig);
+	if (mode < 0)
+		goto offload_disable;
+
+	/* TODO: this should only be checked if blinking is needed */
+	period = jiffies_to_msecs(atomic_read(&trig->interval)) * 2;
+	ret = marvell_leds_set_blink_rate(phydev, &period);
+	if (ret) {
+		dev_dbg(dev, "cannot offload trigger (unsupported blinking period)\n");
+		goto offload_disable;
+	}
+
+	ret = marvell_led_set_regval(phydev, led->addr, mode);
+	if (!ret) {
+		atomic_set(&trig->interval, msecs_to_jiffies(period / 2));
+		dev_dbg(led->cdev.dev, "netdev trigger offloaded\n");
+	}
+
+	return ret;
+
+offload_disable:
+	ret = marvell_led_set_regval(phydev, led->addr, MII_PHY_LED_CTRL_OFF);
+	if (ret)
+		return ret;
+
+	return -EOPNOTSUPP;
+}
+
+static int marvell_led_init(struct phy_device *phydev, struct phy_led *led,
+			    struct fwnode_handle *fwnode)
+{
+	struct marvell_priv *priv = phydev->priv;
+	const struct marvell_leds_info *info;
+	int ret, i;
+
+	if (led->addr == -1) {
+		phydev_err(phydev, "Missing 'reg' property for node %pfw\n",
+			   fwnode);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(marvell_leds_info); ++i) {
+		info = &marvell_leds_info[i];
+		if (MARVELL_PHY_FAMILY_ID(phydev->phy_id) == info->family)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(marvell_leds_info))
+		return -EOPNOTSUPP;
+
+	if (led->addr >= info->nleds) {
+		phydev_err(phydev, "Invalid 'reg' property for node %pfw\n",
+			   fwnode);
+		return -EINVAL;
+	}
+
+	led->priv = (void *)info;
+
+	ret = marvell_led_set_polarity(phydev, led->addr, led->active_low,
+				       led->tristate);
+	if (ret < 0)
+		return ret;
+
+	/* ensure marvell_config_led below does not change settings we have set
+	 * for this LED
+	 */
+	if (led->addr < 3)
+		priv->legacy_led_config_mask &= ~(0xf << (led->addr * 4));
+
+	return 0;
+}
+
+#define MARVELL_LED_OPS							\
+		.led_init = marvell_led_init,				\
+		.led_brightness_set = marvell_led_brightness_set,	\
+		.led_blink_set = marvell_led_blink_set,			\
+		.led_trigger_offload = marvell_led_trigger_offload,
+
+#else /* !IS_ENABLED(CONFIG_LEDS_CLASS) */
+
+#define MARVELL_LED_OPS
+
+#endif /* IS_ENABLED(CONFIG_LEDS_CLASS) */
+
 static void marvell_config_led(struct phy_device *phydev)
 {
+	struct marvell_priv *priv = phydev->priv;
 	u16 def_config;
 	int err;
 
@@ -688,8 +1053,9 @@ static void marvell_config_led(struct phy_device *phydev)
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
@@ -2574,6 +2940,7 @@ static int marvell_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->legacy_led_config_mask = 0xffff;
 	phydev->priv = priv;
 
 	return 0;
@@ -2650,6 +3017,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1111,
@@ -2689,6 +3057,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1121R,
@@ -2711,6 +3080,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1318S,
@@ -2733,6 +3103,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1145,
@@ -2772,6 +3143,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1240,
@@ -2790,6 +3162,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1116R,
@@ -2809,6 +3182,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1510,
@@ -2838,6 +3212,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -2890,6 +3265,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -2958,6 +3334,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		MARVELL_LED_OPS
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1548P,
@@ -2980,6 +3357,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		MARVELL_LED_OPS
 	},
 };
 
-- 
2.26.2

