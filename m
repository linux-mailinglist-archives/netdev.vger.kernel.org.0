Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5981D387E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgENRkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:40:51 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:59466 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgENRkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:40:51 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04EHeeN5069015;
        Thu, 14 May 2020 12:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589478040;
        bh=FigQr+2Mv2wX+Wfrei1Ja0e3JTrb7EYrHkDL262CaN0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Mndkhuelw8rrz0NPNRU0yF6rqJ3WpEf7eZFX2j1LJvYYReY4LZbnwtZpGO8i1ID9Q
         DHfMJdyBSr+ZuqQ9DeFHWamGGIzxE9448CpjgXnBrmcQ9WE5foiGTkH2x42JCne3bT
         FXy8JcssYcLylUn7V45S4AUYIBZ/BB5F+P3eKI0Y=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EHee0c092960;
        Thu, 14 May 2020 12:40:40 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 12:40:40 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 12:40:40 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EHee0D031800;
        Thu, 14 May 2020 12:40:40 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 2/2] net: phy: DP83822: Add ability to advertise Fiber connection
Date:   Thu, 14 May 2020 12:30:55 -0500
Message-ID: <20200514173055.15013-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514173055.15013-1-dmurphy@ti.com>
References: <20200514173055.15013-1-dmurphy@ti.com>
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
 drivers/net/phy/dp83822.c | 140 +++++++++++++++++++++++++++++++++++---
 1 file changed, 132 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 1dd19d0cb269..fe7443bc8b06 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -27,6 +27,11 @@
 #define MII_DP83822_MISR1	0x12
 #define MII_DP83822_MISR2	0x13
 #define MII_DP83822_RESET_CTRL	0x1f
+#define MII_DP83822_GENCFG	0x465
+#define MII_DP83822_SOR1	0x467
+
+/* GENCFG */
+#define DP83822_SIG_DET_POLARITY BIT(0)
 
 #define DP83822_HW_RESET	BIT(15)
 #define DP83822_SW_RESET	BIT(14)
@@ -77,6 +82,21 @@
 #define DP83822_WOL_INDICATION_SEL BIT(8)
 #define DP83822_WOL_CLR_INDICATION BIT(11)
 
+/* SOR1 bits */
+#define DP83822_FX_EN_STRAP	BIT(11)
+#define DP83822_FX_DUPLEX_STRAP	BIT(0)
+
+#define MII_DP83822_FIBER_ADVERTISE	(SUPPORTED_AUI | SUPPORTED_FIBRE | \
+					 SUPPORTED_BNC | SUPPORTED_Pause | \
+					 SUPPORTED_Asym_Pause | \
+					 SUPPORTED_100baseT_Full)
+
+struct dp83822_private {
+	bool fx_signal_detect_low;
+	int fx_enabled;
+	u16 fx_duplex_mode;
+};
+
 static int dp83822_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -255,7 +275,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83822_PHYSCR, physcr_status);
 }
 
-static int dp83822_config_init(struct phy_device *phydev)
+static int dp8382x_disable_wol(struct phy_device *phydev)
 {
 	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
 		    DP83822_WOL_SECURE_ON;
@@ -264,6 +284,41 @@ static int dp83822_config_init(struct phy_device *phydev)
 				  MII_DP83822_WOL_CFG, value);
 }
 
+static int dp83822_config_init(struct phy_device *phydev)
+{
+	struct dp83822_private *dp83822 = phydev->priv;
+	int err = 0;
+
+	if (dp83822->fx_enabled) {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+				 phydev->supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+				 phydev->advertising);
+
+		/*  Auto negotiation is not available in fiber mode */
+		phydev->autoneg = AUTONEG_DISABLE;
+		phydev->speed = SPEED_100;
+		phydev->duplex = DUPLEX_FULL;
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
+	}
+
+	return dp8382x_disable_wol(phydev);
+}
+
+static int dp8382x_config_init(struct phy_device *phydev)
+{
+	return dp8382x_disable_wol(phydev);
+}
+
 static int dp83822_phy_reset(struct phy_device *phydev)
 {
 	int err;
@@ -272,7 +327,60 @@ static int dp83822_phy_reset(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	dp83822_config_init(phydev);
+	return phydev->drv->config_init(phydev);
+}
+
+#ifdef CONFIG_OF_MDIO
+static int dp83822_of_init(struct phy_device *phydev)
+{
+	struct dp83822_private *dp83822 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+
+	if (dp83822->fx_enabled)
+		dp83822->fx_signal_detect_low = device_property_present(dev,
+									"ti,signal-polarity-low");
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
+	u16 val;
+
+	val = phy_read_mmd(phydev, DP83822_DEVADDR, MII_DP83822_SOR1);
+	if (val < 0)
+		return val;
+
+	dp83822->fx_enabled = val & DP83822_FX_EN_STRAP;
+	dp83822->fx_duplex_mode = val & DP83822_FX_DUPLEX_STRAP;
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
 
 	return 0;
 }
@@ -308,6 +416,7 @@ static int dp83822_resume(struct phy_device *phydev)
 		PHY_ID_MATCH_MODEL(_id),			\
 		.name		= (_name),			\
 		/* PHY_BASIC_FEATURES */			\
+		.probe          = dp83822_probe,		\
 		.soft_reset	= dp83822_phy_reset,		\
 		.config_init	= dp83822_config_init,		\
 		.get_wol = dp83822_get_wol,			\
@@ -318,14 +427,29 @@ static int dp83822_resume(struct phy_device *phydev)
 		.resume = dp83822_resume,			\
 	}
 
+#define DP8382X_PHY_DRIVER(_id, _name)				\
+	{							\
+		PHY_ID_MATCH_MODEL(_id),			\
+		.name		= (_name),			\
+		/* PHY_BASIC_FEATURES */			\
+		.soft_reset	= dp83822_phy_reset,		\
+		.config_init	= dp8382x_config_init,		\
+		.get_wol = dp83822_get_wol,			\
+		.set_wol = dp83822_set_wol,			\
+		.ack_interrupt = dp83822_ack_interrupt,		\
+		.config_intr = dp83822_config_intr,		\
+		.suspend = dp83822_suspend,			\
+		.resume = dp83822_resume,			\
+	}
+
 static struct phy_driver dp83822_driver[] = {
 	DP83822_PHY_DRIVER(DP83822_PHY_ID, "TI DP83822"),
-	DP83822_PHY_DRIVER(DP83825I_PHY_ID, "TI DP83825I"),
-	DP83822_PHY_DRIVER(DP83826C_PHY_ID, "TI DP83826C"),
-	DP83822_PHY_DRIVER(DP83826NC_PHY_ID, "TI DP83826NC"),
-	DP83822_PHY_DRIVER(DP83825S_PHY_ID, "TI DP83825S"),
-	DP83822_PHY_DRIVER(DP83825CM_PHY_ID, "TI DP83825M"),
-	DP83822_PHY_DRIVER(DP83825CS_PHY_ID, "TI DP83825CS"),
+	DP8382X_PHY_DRIVER(DP83825I_PHY_ID, "TI DP83825I"),
+	DP8382X_PHY_DRIVER(DP83826C_PHY_ID, "TI DP83826C"),
+	DP8382X_PHY_DRIVER(DP83826NC_PHY_ID, "TI DP83826NC"),
+	DP8382X_PHY_DRIVER(DP83825S_PHY_ID, "TI DP83825S"),
+	DP8382X_PHY_DRIVER(DP83825CM_PHY_ID, "TI DP83825M"),
+	DP8382X_PHY_DRIVER(DP83825CS_PHY_ID, "TI DP83825CS"),
 };
 module_phy_driver(dp83822_driver);
 
-- 
2.26.2

