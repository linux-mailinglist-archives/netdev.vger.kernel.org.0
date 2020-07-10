Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE3721B8D5
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgGJOhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:37:54 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34560 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGJOhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 10:37:52 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06AEbjOb033359;
        Fri, 10 Jul 2020 09:37:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594391865;
        bh=lp+64EuogP85x4TheVhqiulF12tNqqBbMyXR3SEe11Y=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=P2JwmLAk7TiZJswSitgv839cyEbPXSCde9fGhxMK6syAHTv3VLoNeEZLuNKw0u+9E
         ivMOCT+8LvPlC6nFUoq5ikOcxXR65HqiNFMdB/a7hAz15JAFqEG1kYpbwN0WWKR7bz
         LDJKfA+abvvnxqSbYhkjVVevHbPE6Eo9BkxeRh5A=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06AEbjoU118829
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 09:37:45 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 10
 Jul 2020 09:37:45 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 10 Jul 2020 09:37:45 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06AEbjHE025235;
        Fri, 10 Jul 2020 09:37:45 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 2/2] net: phy: DP83822: Add ability to advertise Fiber connection
Date:   Fri, 10 Jul 2020 09:37:33 -0500
Message-ID: <20200710143733.30751-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710143733.30751-1-dmurphy@ti.com>
References: <20200710143733.30751-1-dmurphy@ti.com>
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
 drivers/net/phy/dp83822.c | 161 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 37643c468e19..b797e3d2a4e5 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -23,16 +23,29 @@
 
 #define DP83822_DEVADDR		0x1f
 
+#define MII_DP83822_CTRL_2	0x0a
+#define MII_DP83822_PHYSTS	0x10
 #define MII_DP83822_PHYSCR	0x11
 #define MII_DP83822_MISR1	0x12
 #define MII_DP83822_MISR2	0x13
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
+
 /* PHYSCR Register Fields */
 #define DP83822_PHYSCR_INT_OE		BIT(0) /* Interrupt Output Enable */
 #define DP83822_PHYSCR_INTEN		BIT(1) /* Interrupt Enable */
@@ -83,6 +96,21 @@
 #define DP83822_RX_CLK_SHIFT	BIT(12)
 #define DP83822_TX_CLK_SHIFT	BIT(11)
 
+/* SOR1 bits */
+#define DP83822_FX_EN_STRAP	BIT(11)
+#define DP83822_FX_SD_EN_STRAP	BIT(8)
+
+#define MII_DP83822_FIBER_ADVERTISE	(SUPPORTED_AUI | SUPPORTED_FIBRE | \
+					 SUPPORTED_BNC | SUPPORTED_Pause | \
+					 SUPPORTED_Asym_Pause | \
+					 SUPPORTED_100baseT_Full)
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
@@ -270,13 +298,40 @@ static int dp8382x_disable_wol(struct phy_device *phydev)
 				  MII_DP83822_WOL_CFG, value);
 }
 
+static int dp83822_read_status(struct phy_device *phydev)
+{
+	int status = phy_read(phydev, MII_DP83822_PHYSTS);
+	int ret;
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
@@ -302,6 +357,48 @@ static int dp83822_config_init(struct phy_device *phydev)
 		}
 	}
 
+	if (dp83822->fx_enabled) {
+		err = phy_modify(phydev, MII_DP83822_CTRL_2,
+				 DP83822_FX_ENABLE, 1);
+		if (err < 0)
+			return err;
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
+
+		/* Setup fiber advertisement */
+		err = phy_modify_changed(phydev, MII_ADVERTISE,
+					 ADVERTISE_1000XFULL |
+					 ADVERTISE_1000XPAUSE |
+					 ADVERTISE_1000XPSE_ASYM,
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
+
 	return dp8382x_disable_wol(phydev);
 }
 
@@ -321,6 +418,68 @@ static int dp83822_phy_reset(struct phy_device *phydev)
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
+	int val;
+
+	val = phy_read_mmd(phydev, DP83822_DEVADDR, MII_DP83822_SOR1);
+	if (val < 0)
+		return val;
+
+	dp83822->fx_enabled = val & DP83822_FX_EN_STRAP;
+	dp83822->fx_sd_enable = val & DP83822_FX_SD_EN_STRAP;
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
@@ -352,8 +511,10 @@ static int dp83822_resume(struct phy_device *phydev)
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
2.27.0

