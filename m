Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C0E1FF161
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgFRML4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:11:56 -0400
Received: from gloria.sntech.de ([185.11.138.130]:53388 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgFRMLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:11:51 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jltOQ-0007op-Ph; Thu, 18 Jun 2020 14:11:42 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: [PATCH v5 3/3] net: phy: mscc: handle the clkout control on some phy variants
Date:   Thu, 18 Jun 2020 14:11:39 +0200
Message-Id: <20200618121139.1703762-4-heiko@sntech.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618121139.1703762-1-heiko@sntech.de>
References: <20200618121139.1703762-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

At least VSC8530/8531/8540/8541 contain a clock output that can emit
a predefined rate of 25, 50 or 125MHz.

This may then feed back into the network interface as source clock.
So expose a clock-provider from the phy using the common clock framework
to allow setting the rate.

Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
---
 drivers/net/phy/mscc/mscc.h      |  13 +++
 drivers/net/phy/mscc/mscc_main.c | 182 +++++++++++++++++++++++++++++--
 2 files changed, 187 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index fbcee5fce7b2..94883dab5cc1 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -218,6 +218,13 @@ enum rgmii_clock_delay {
 #define INT_MEM_DATA_M			  0x00ff
 #define INT_MEM_DATA(x)			  (INT_MEM_DATA_M & (x))
 
+#define MSCC_CLKOUT_CNTL		  13
+#define CLKOUT_ENABLE			  BIT(15)
+#define CLKOUT_FREQ_MASK		  GENMASK(14, 13)
+#define CLKOUT_FREQ_25M			  (0x0 << 13)
+#define CLKOUT_FREQ_50M			  (0x1 << 13)
+#define CLKOUT_FREQ_125M		  (0x2 << 13)
+
 #define MSCC_PHY_PROC_CMD		  18
 #define PROC_CMD_NCOMPLETED		  0x8000
 #define PROC_CMD_FAILED			  0x4000
@@ -360,6 +367,12 @@ struct vsc8531_private {
 	 */
 	unsigned int base_addr;
 
+#ifdef CONFIG_COMMON_CLK
+	struct clk_hw clkout_hw;
+#endif
+	u32 clkout_rate;
+	int clkout_enabled;
+
 #if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec fields:
 	 * - One SecY per device (enforced at the s/w implementation level)
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 5d2777522fb4..727a9dd58403 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2016 Microsemi Corporation
  */
 
+#include <linux/clk-provider.h>
 #include <linux/firmware.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
@@ -431,7 +432,6 @@ static int vsc85xx_dt_led_mode_get(struct phy_device *phydev,
 
 	return led_mode;
 }
-
 #else
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
@@ -1508,6 +1508,43 @@ static int vsc85xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int vsc8531_config_init(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	u16 val;
+	int rc;
+
+	rc = vsc85xx_config_init(phydev);
+	if (rc)
+		return rc;
+
+#ifdef CONFIG_COMMON_CLK
+	switch (vsc8531->clkout_rate) {
+	case 25000000:
+		val = CLKOUT_FREQ_25M;
+		break;
+	case 50000000:
+		val = CLKOUT_FREQ_50M;
+		break;
+	case 125000000:
+		val = CLKOUT_FREQ_125M;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (vsc8531->clkout_enabled)
+		val |= CLKOUT_ENABLE;
+
+	rc = phy_write_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
+			     MSCC_CLKOUT_CNTL, val);
+	if (rc)
+		return rc;
+#endif
+
+	return 0;
+}
+
 static int vsc8584_did_interrupt(struct phy_device *phydev)
 {
 	int rc = 0;
@@ -1935,6 +1972,107 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+#ifdef CONFIG_COMMON_CLK
+#define clkout_hw_to_vsc8531(_hw) container_of(_hw, struct vsc8531_private, clkout_hw)
+
+static int clkout_rates[] = {
+	125000000,
+	50000000,
+	25000000,
+};
+
+static unsigned long vsc8531_clkout_recalc_rate(struct clk_hw *hw,
+						unsigned long parent_rate)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+
+	return vsc8531->clkout_rate;
+}
+
+static long vsc8531_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *prate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(clkout_rates); i++)
+		if (clkout_rates[i] <= rate)
+			return clkout_rates[i];
+	return 0;
+}
+
+static int vsc8531_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
+				   unsigned long parent_rate)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+
+	vsc8531->clkout_rate = rate;
+	return 0;
+}
+
+static int vsc8531_clkout_prepare(struct clk_hw *hw)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+
+	vsc8531->clkout_enabled = true;
+	return 0;
+}
+
+static void vsc8531_clkout_unprepare(struct clk_hw *hw)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+
+	vsc8531->clkout_enabled = false;
+}
+
+static int vsc8531_clkout_is_prepared(struct clk_hw *hw)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+
+	return vsc8531->clkout_enabled;
+}
+
+static const struct clk_ops vsc8531_clkout_ops = {
+	.prepare = vsc8531_clkout_prepare,
+	.unprepare = vsc8531_clkout_unprepare,
+	.is_prepared = vsc8531_clkout_is_prepared,
+	.recalc_rate = vsc8531_clkout_recalc_rate,
+	.round_rate = vsc8531_clkout_round_rate,
+	.set_rate = vsc8531_clkout_set_rate,
+};
+
+static int vsc8531_register_clkout(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+	struct clk_init_data init;
+	int ret;
+
+	init.name = "vsc8531-clkout";
+	init.ops = &vsc8531_clkout_ops;
+	init.flags = 0;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	vsc8531->clkout_hw.init = &init;
+
+	/* optional override of the clockname */
+	of_property_read_string(of_node, "clock-output-names", &init.name);
+
+	/* register the clock */
+	ret = devm_clk_hw_register(dev, &vsc8531->clkout_hw);
+	if (!ret)
+		ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get,
+						  &vsc8531->clkout_hw);
+
+	return ret;
+}
+#else
+static int vsc8531_register_clkout(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif
+
 static int vsc85xx_probe_helper(struct phy_device *phydev,
 				u32 *leds, int num_leds, u16 led_modes,
 				const struct vsc85xx_hw_stat *stats, int nstats)
@@ -1981,6 +2119,34 @@ static int vsc8514_probe(struct phy_device *phydev)
 				     vsc8531->base_addr, 0);
 }
 
+static int vsc8531_probe(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531;
+	int rate_magic, rc;
+	u32 default_mode[2] = {VSC8531_LINK_1000_ACTIVITY,
+	   VSC8531_LINK_100_ACTIVITY};
+
+	rate_magic = vsc85xx_edge_rate_magic_get(phydev);
+	if (rate_magic < 0)
+		return rate_magic;
+
+	rc = vsc85xx_probe_helper(phydev, default_mode,
+				  ARRAY_SIZE(default_mode),
+				  VSC85XX_SUPP_LED_MODES,
+				  vsc85xx_hw_stats,
+				  ARRAY_SIZE(vsc85xx_hw_stats));
+	if (rc < 0)
+		return rc;
+
+	vsc8531 = phydev->priv;
+	vsc8531->rate_magic = rate_magic;
+	rc = vsc8531_register_clkout(phydev);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
 static int vsc8574_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2136,14 +2302,14 @@ static struct phy_driver vsc85xx_driver[] = {
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
-	.config_init	= &vsc85xx_config_init,
+	.config_init	= &vsc8531_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt	= &vsc85xx_ack_interrupt,
 	.config_intr	= &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
-	.probe		= &vsc85xx_probe,
+	.probe		= &vsc8531_probe,
 	.set_wol	= &vsc85xx_wol_set,
 	.get_wol	= &vsc85xx_wol_get,
 	.get_tunable	= &vsc85xx_get_tunable,
@@ -2160,14 +2326,14 @@ static struct phy_driver vsc85xx_driver[] = {
 	.phy_id_mask    = 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
-	.config_init    = &vsc85xx_config_init,
+	.config_init    = &vsc8531_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
-	.probe		= &vsc85xx_probe,
+	.probe		= &vsc8531_probe,
 	.set_wol	= &vsc85xx_wol_set,
 	.get_wol	= &vsc85xx_wol_get,
 	.get_tunable	= &vsc85xx_get_tunable,
@@ -2184,14 +2350,14 @@ static struct phy_driver vsc85xx_driver[] = {
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
-	.config_init	= &vsc85xx_config_init,
+	.config_init	= &vsc8531_config_init,
 	.config_aneg	= &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt	= &vsc85xx_ack_interrupt,
 	.config_intr	= &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
-	.probe		= &vsc85xx_probe,
+	.probe		= &vsc8531_probe,
 	.set_wol	= &vsc85xx_wol_set,
 	.get_wol	= &vsc85xx_wol_get,
 	.get_tunable	= &vsc85xx_get_tunable,
@@ -2208,7 +2374,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.phy_id_mask    = 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
-	.config_init    = &vsc85xx_config_init,
+	.config_init    = &vsc8531_config_init,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
-- 
2.26.2

