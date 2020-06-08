Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0621F1CB0
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgFHQC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:02:27 -0400
Received: from gloria.sntech.de ([185.11.138.130]:57392 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbgFHQC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 12:02:27 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jiKE0-0004S9-Ux; Mon, 08 Jun 2020 18:02:13 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: [PATCH] net: phy: mscc: handle the clkout control on some phy variants
Date:   Mon,  8 Jun 2020 18:02:07 +0200
Message-Id: <20200608160207.1316052-1-heiko@sntech.de>
X-Mailer: git-send-email 2.26.2
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
So follow the example the at803x already set and introduce a
vsc8531,clk-out-frequency property to set that output.

Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
---
 .../bindings/net/mscc-phy-vsc8531.txt         |  3 +
 drivers/net/phy/mscc/mscc.h                   |  9 ++
 drivers/net/phy/mscc/mscc_main.c              | 93 +++++++++++++++++--
 3 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
index 5ff37c68c941..4a1f50ae48e1 100644
--- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
+++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
@@ -1,6 +1,8 @@
 * Microsemi - vsc8531 Giga bit ethernet phy
 
 Optional properties:
+- vsc8531,clk-out-frequency: Clock output frequency in Hertz.
+			  Should be one of 25000000, 50000000, 125000000
 - vsc8531,vddmac	: The vddmac in mV. Allowed values is listed
 			  in the first row of Table 1 (below).
 			  This property is only used in combination
@@ -63,6 +65,7 @@ Example:
 
         vsc8531_0: ethernet-phy@0 {
                 compatible = "ethernet-phy-id0007.0570";
+                vsc8531,clk-out-frequency = <125000000>;
                 vsc8531,vddmac		= <3300>;
                 vsc8531,edge-slowdown	= <7>;
                 vsc8531,led-0-mode	= <LINK_1000_ACTIVITY>;
diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 414e3b31bb1f..c8c395a041c2 100644
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
@@ -361,6 +368,8 @@ struct vsc8531_private {
 	 */
 	unsigned int base_addr;
 
+	u32 clkout_rate;
+
 #if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec fields:
 	 * - One SecY per device (enforced at the s/w implementation level)
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index c8aa6d905d8e..8e63af3628cd 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -432,6 +432,18 @@ static int vsc85xx_dt_led_mode_get(struct phy_device *phydev,
 	return led_mode;
 }
 
+static void vsc8531_dt_clkout_rate_get(struct phy_device *phydev)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+
+	if (!of_node)
+		return;
+
+	of_property_read_u32(of_node, "vsc8531,clk-out-frequency",
+			     &priv->clkout_rate);
+}
 #else
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
@@ -444,6 +456,10 @@ static int vsc85xx_dt_led_mode_get(struct phy_device *phydev,
 {
 	return default_mode;
 }
+
+static void vsc8531_dt_clkout_rate_get(struct phy_device *phydev)
+{
+}
 #endif /* CONFIG_OF_MDIO */
 
 static int vsc85xx_dt_led_modes_get(struct phy_device *phydev,
@@ -1540,6 +1556,37 @@ static int vsc85xx_config_init(struct phy_device *phydev)
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
+	switch (vsc8531->clkout_rate) {
+	case 0:
+		val = 0;
+		break;
+	case 25000000:
+		val = CLKOUT_FREQ_25M | CLKOUT_ENABLE;
+		break;
+	case 50000000:
+		val = CLKOUT_FREQ_50M | CLKOUT_ENABLE;
+		break;
+	case 125000000:
+		val = CLKOUT_FREQ_125M | CLKOUT_ENABLE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return phy_write_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
+			       MSCC_CLKOUT_CNTL, val);
+}
+
 static int vsc8584_did_interrupt(struct phy_device *phydev)
 {
 	int rc = 0;
@@ -2008,6 +2055,38 @@ static int vsc8514_probe(struct phy_device *phydev)
 	return vsc85xx_dt_led_modes_get(phydev, default_mode);
 }
 
+static int vsc8531_probe(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531;
+	int rate_magic;
+	u32 default_mode[2] = {VSC8531_LINK_1000_ACTIVITY,
+	   VSC8531_LINK_100_ACTIVITY};
+
+	rate_magic = vsc85xx_edge_rate_magic_get(phydev);
+	if (rate_magic < 0)
+		return rate_magic;
+
+	vsc8531 = devm_kzalloc(&phydev->mdio.dev, sizeof(*vsc8531), GFP_KERNEL);
+	if (!vsc8531)
+		return -ENOMEM;
+
+	phydev->priv = vsc8531;
+
+	vsc8531->rate_magic = rate_magic;
+	vsc8531->nleds = 2;
+	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
+	vsc8531->hw_stats = vsc85xx_hw_stats;
+	vsc8531->nstats = ARRAY_SIZE(vsc85xx_hw_stats);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
+	if (!vsc8531->stats)
+		return -ENOMEM;
+
+	vsc8531_dt_clkout_rate_get(phydev);
+
+	return vsc85xx_dt_led_modes_get(phydev, default_mode);
+}
+
 static int vsc8574_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2174,14 +2253,14 @@ static struct phy_driver vsc85xx_driver[] = {
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
@@ -2198,14 +2277,14 @@ static struct phy_driver vsc85xx_driver[] = {
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
@@ -2222,14 +2301,14 @@ static struct phy_driver vsc85xx_driver[] = {
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
@@ -2246,7 +2325,7 @@ static struct phy_driver vsc85xx_driver[] = {
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

