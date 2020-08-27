Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8B125465D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgH0N7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 09:59:11 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57926 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbgH0Npm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 09:45:42 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07RDjBxn057738;
        Thu, 27 Aug 2020 08:45:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598535911;
        bh=Mo8eplEgTCW0YBBXa6rpnHfd7Z1uSgpBWxJe8oN1Ums=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=QCrjoRCIs+muqZMMl8EafQtNT8ChXDvtM541oGu7UnKOYgX33LYIhwpaBicXSw2fe
         N5Po9FJ0YNdnlMzeQnO20GTMjwlmNHRW1oUkv69IHqNju5VFBHz8tqhZtbnSrQYnM7
         479LrjU/VK0SZlD/GpY/tvrgGcOlP3EIAEP6KC7s=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07RDjBmq073643
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 08:45:11 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 27
 Aug 2020 08:45:11 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 27 Aug 2020 08:45:11 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07RDjAqs058279;
        Thu, 27 Aug 2020 08:45:10 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 2/2] net: phy: DP83822: Add ability to advertise Fiber connection
Date:   Thu, 27 Aug 2020 08:45:09 -0500
Message-ID: <20200827134509.23854-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827134509.23854-1-dmurphy@ti.com>
References: <20200827134509.23854-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83822 can be configured to use a Fiber connection.  The strap
register is read to determine if the device has been configured to use
a fiber connection.  With the fiber connection the PHY can be configured
to detect whether the fiber connection is active by either a high signal
or a low signal.

Fiber mode is only applicable to the DP83822 so rework the PHY match
table so that non-fiber PHYs can still use the same driver but not call
or use any of the fiber features.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83822.c | 225 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 218 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 37643c468e19..732c8bec7452 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -23,16 +23,31 @@
 
 #define DP83822_DEVADDR		0x1f
 
+#define MII_DP83822_CTRL_2	0x0a
+#define MII_DP83822_PHYSTS	0x10
 #define MII_DP83822_PHYSCR	0x11
 #define MII_DP83822_MISR1	0x12
 #define MII_DP83822_MISR2	0x13
+#define MII_DP83822_FCSCR	0x14
 #define MII_DP83822_RCSR	0x17
 #define MII_DP83822_RESET_CTRL	0x1f
 #define MII_DP83822_GENCFG	0x465
+#define MII_DP83822_SOR1	0x467
+
+/* GENCFG */
+#define DP83822_SIG_DET_LOW	BIT(0)
+
+/* Control Register 2 bits */
+#define DP83822_FX_ENABLE	BIT(14)
 
 #define DP83822_HW_RESET	BIT(15)
 #define DP83822_SW_RESET	BIT(14)
 
+/* PHY STS bits */
+#define DP83822_PHYSTS_DUPLEX			BIT(2)
+#define DP83822_PHYSTS_10			BIT(1)
+#define DP83822_PHYSTS_LINK			BIT(0)
+
 /* PHYSCR Register Fields */
 #define DP83822_PHYSCR_INT_OE		BIT(0) /* Interrupt Output Enable */
 #define DP83822_PHYSCR_INTEN		BIT(1) /* Interrupt Enable */
@@ -83,6 +98,28 @@
 #define DP83822_RX_CLK_SHIFT	BIT(12)
 #define DP83822_TX_CLK_SHIFT	BIT(11)
 
+/* SOR1 mode */
+#define DP83822_STRAP_MODE1	0
+#define DP83822_STRAP_MODE2	BIT(0)
+#define DP83822_STRAP_MODE3	BIT(1)
+#define DP83822_STRAP_MODE4	GENMASK(1, 0)
+
+#define DP83822_COL_STRAP_MASK	GENMASK(11, 10)
+#define DP83822_COL_SHIFT	10
+#define DP83822_RX_ER_STR_MASK	GENMASK(9, 8)
+#define DP83822_RX_ER_SHIFT	8
+
+#define MII_DP83822_FIBER_ADVERTISE    (ADVERTISED_TP | ADVERTISED_MII | \
+					ADVERTISED_FIBRE | ADVERTISED_BNC |  \
+					ADVERTISED_Pause | ADVERTISED_Asym_Pause | \
+					ADVERTISED_100baseT_Full)
+
+struct dp83822_private {
+	bool fx_signal_det_low;
+	int fx_enabled;
+	u16 fx_sd_enable;
+};
+
 static int dp83822_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -197,6 +234,7 @@ static void dp83822_get_wol(struct phy_device *phydev,
 
 static int dp83822_config_intr(struct phy_device *phydev)
 {
+	struct dp83822_private *dp83822 = phydev->priv;
 	int misr_status;
 	int physcr_status;
 	int err;
@@ -208,13 +246,16 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
 		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
 				DP83822_FALSE_CARRIER_HF_INT_EN |
-				DP83822_ANEG_COMPLETE_INT_EN |
-				DP83822_DUP_MODE_CHANGE_INT_EN |
-				DP83822_SPEED_CHANGED_INT_EN |
 				DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 
+		if (!dp83822->fx_enabled)
+			misr_status |= DP83822_ANEG_COMPLETE_INT_EN |
+				       DP83822_DUP_MODE_CHANGE_INT_EN |
+				       DP83822_SPEED_CHANGED_INT_EN;
+
+
 		err = phy_write(phydev, MII_DP83822_MISR1, misr_status);
 		if (err < 0)
 			return err;
@@ -224,14 +265,16 @@ static int dp83822_config_intr(struct phy_device *phydev)
 			return misr_status;
 
 		misr_status |= (DP83822_JABBER_DET_INT_EN |
-				DP83822_WOL_PKT_INT_EN |
 				DP83822_SLEEP_MODE_INT_EN |
-				DP83822_MDI_XOVER_INT_EN |
 				DP83822_LB_FIFO_INT_EN |
 				DP83822_PAGE_RX_INT_EN |
-				DP83822_ANEG_ERR_INT_EN |
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
+		if (!dp83822->fx_enabled)
+			misr_status |= DP83822_MDI_XOVER_INT_EN |
+				       DP83822_ANEG_ERR_INT_EN |
+				       DP83822_WOL_PKT_INT_EN;
+
 		err = phy_write(phydev, MII_DP83822_MISR2, misr_status);
 		if (err < 0)
 			return err;
@@ -270,13 +313,60 @@ static int dp8382x_disable_wol(struct phy_device *phydev)
 				  MII_DP83822_WOL_CFG, value);
 }
 
+static int dp83822_read_status(struct phy_device *phydev)
+{
+	struct dp83822_private *dp83822 = phydev->priv;
+	int status = phy_read(phydev, MII_DP83822_PHYSTS);
+	int ctrl2;
+	int ret;
+
+	if (dp83822->fx_enabled) {
+		if (status & DP83822_PHYSTS_LINK) {
+			phydev->speed = SPEED_UNKNOWN;
+			phydev->duplex = DUPLEX_UNKNOWN;
+		} else {
+			ctrl2 = phy_read(phydev, MII_DP83822_CTRL_2);
+			if (ctrl2 < 0)
+				return ctrl2;
+
+			if (!(ctrl2 & DP83822_FX_ENABLE)) {
+				ret = phy_write(phydev, MII_DP83822_CTRL_2,
+						DP83822_FX_ENABLE | ctrl2);
+				if (ret < 0)
+					return ret;
+			}
+		}
+	}
+
+	ret = genphy_read_status(phydev);
+	if (ret)
+		return ret;
+
+	if (status < 0)
+		return status;
+
+	if (status & DP83822_PHYSTS_DUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
+	if (status & DP83822_PHYSTS_10)
+		phydev->speed = SPEED_10;
+	else
+		phydev->speed = SPEED_100;
+
+	return 0;
+}
+
 static int dp83822_config_init(struct phy_device *phydev)
 {
+	struct dp83822_private *dp83822 = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	int rgmii_delay;
 	s32 rx_int_delay;
 	s32 tx_int_delay;
 	int err = 0;
+	int bmcr;
 
 	if (phy_interface_is_rgmii(phydev)) {
 		rx_int_delay = phy_get_internal_delay(phydev, dev, NULL, 0,
@@ -302,6 +392,53 @@ static int dp83822_config_init(struct phy_device *phydev)
 		}
 	}
 
+	if (dp83822->fx_enabled) {
+		err = phy_modify(phydev, MII_DP83822_CTRL_2,
+				 DP83822_FX_ENABLE, 1);
+		if (err < 0)
+			return err;
+
+		/* Only allow advertising what this PHY supports */
+		linkmode_and(phydev->advertising, phydev->advertising,
+			     phydev->supported);
+
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+				 phydev->supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+				 phydev->advertising);
+
+		/* Auto neg is not supported in fiber mode */
+		bmcr = phy_read(phydev, MII_BMCR);
+		if (bmcr < 0)
+			return bmcr;
+
+		if (bmcr & BMCR_ANENABLE) {
+			err =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
+			if (err < 0)
+				return err;
+		}
+		phydev->autoneg = AUTONEG_DISABLE;
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				   phydev->supported);
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				   phydev->advertising);
+
+		/* Setup fiber advertisement */
+		err = phy_modify_changed(phydev, MII_ADVERTISE,
+					 MII_DP83822_FIBER_ADVERTISE,
+					 MII_DP83822_FIBER_ADVERTISE);
+
+		if (err < 0)
+			return err;
+
+		if (dp83822->fx_signal_det_low) {
+			err = phy_set_bits_mmd(phydev, DP83822_DEVADDR,
+					       MII_DP83822_GENCFG,
+					       DP83822_SIG_DET_LOW);
+			if (err)
+				return err;
+		}
+	}
 	return dp8382x_disable_wol(phydev);
 }
 
@@ -314,13 +451,85 @@ static int dp83822_phy_reset(struct phy_device *phydev)
 {
 	int err;
 
-	err = phy_write(phydev, MII_DP83822_RESET_CTRL, DP83822_HW_RESET);
+	err = phy_write(phydev, MII_DP83822_RESET_CTRL, DP83822_SW_RESET);
 	if (err < 0)
 		return err;
 
 	return phydev->drv->config_init(phydev);
 }
 
+#ifdef CONFIG_OF_MDIO
+static int dp83822_of_init(struct phy_device *phydev)
+{
+	struct dp83822_private *dp83822 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+
+	/* Signal detection for the PHY is only enabled if the FX_EN and the
+	 * SD_EN pins are strapped. Signal detection can only enabled if FX_EN
+	 * is strapped otherwise signal detection is disabled for the PHY.
+	 */
+	if (dp83822->fx_enabled && dp83822->fx_sd_enable)
+		dp83822->fx_signal_det_low = device_property_present(dev,
+								     "ti,link-loss-low");
+	if (!dp83822->fx_enabled)
+		dp83822->fx_enabled = device_property_present(dev,
+							      "ti,fiber-mode");
+
+	return 0;
+}
+#else
+static int dp83822_of_init(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif /* CONFIG_OF_MDIO */
+
+static int dp83822_read_straps(struct phy_device *phydev)
+{
+	struct dp83822_private *dp83822 = phydev->priv;
+	int fx_enabled, fx_sd_enable;
+	int val;
+
+	val = phy_read_mmd(phydev, DP83822_DEVADDR, MII_DP83822_SOR1);
+	if (val < 0)
+		return val;
+
+	fx_enabled = (val & DP83822_COL_STRAP_MASK) >> DP83822_COL_SHIFT;
+	if (fx_enabled == DP83822_STRAP_MODE2 ||
+	    fx_enabled == DP83822_STRAP_MODE3)
+		dp83822->fx_enabled = 1;
+
+	if (dp83822->fx_enabled) {
+		fx_sd_enable = (val & DP83822_RX_ER_STR_MASK) >> DP83822_RX_ER_SHIFT;
+		if (fx_sd_enable == DP83822_STRAP_MODE3 ||
+		    fx_sd_enable == DP83822_STRAP_MODE4)
+			dp83822->fx_sd_enable = 1;
+	}
+
+	return 0;
+}
+
+static int dp83822_probe(struct phy_device *phydev)
+{
+	struct dp83822_private *dp83822;
+	int ret;
+
+	dp83822 = devm_kzalloc(&phydev->mdio.dev, sizeof(*dp83822),
+			       GFP_KERNEL);
+	if (!dp83822)
+		return -ENOMEM;
+
+	phydev->priv = dp83822;
+
+	ret = dp83822_read_straps(phydev);
+	if (ret)
+		return ret;
+
+	dp83822_of_init(phydev);
+
+	return 0;
+}
+
 static int dp83822_suspend(struct phy_device *phydev)
 {
 	int value;
@@ -352,8 +561,10 @@ static int dp83822_resume(struct phy_device *phydev)
 		PHY_ID_MATCH_MODEL(_id),			\
 		.name		= (_name),			\
 		/* PHY_BASIC_FEATURES */			\
+		.probe          = dp83822_probe,		\
 		.soft_reset	= dp83822_phy_reset,		\
 		.config_init	= dp83822_config_init,		\
+		.read_status	= dp83822_read_status,		\
 		.get_wol = dp83822_get_wol,			\
 		.set_wol = dp83822_set_wol,			\
 		.ack_interrupt = dp83822_ack_interrupt,		\
-- 
2.28.0

