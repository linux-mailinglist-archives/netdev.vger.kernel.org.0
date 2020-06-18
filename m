Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814CC1FFD41
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgFRVKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:10:54 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57058 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbgFRVKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:10:48 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05ILAh43036218;
        Thu, 18 Jun 2020 16:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592514643;
        bh=ehq+Ty1gZ2t4R0aAfzFJjltOQ0z7TJBMi3aVsQVQchg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=opI/u/XVls5qmauY8k3rC4TzC+lQsGCbqkcL55OjFbLaMI5VFm0heUj5WIyJjLZM+
         ylY+iYoz9W6kr6oxkcB/Gp15EhsWejlPcX+hPMgW/3U2KHOC+RCt+tWmS8l0rHEvXr
         eIfB7PrmNSGMO1YAR4U7gINWilqGOrJxrmvmmBBg=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05ILAhSQ084551;
        Thu, 18 Jun 2020 16:10:43 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 18
 Jun 2020 16:10:43 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 18 Jun 2020 16:10:43 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05ILAhgF015270;
        Thu, 18 Jun 2020 16:10:43 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v8 5/5] net: phy: DP83822: Add setting the fixed internal delay
Date:   Thu, 18 Jun 2020 16:10:11 -0500
Message-ID: <20200618211011.28837-6-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618211011.28837-1-dmurphy@ti.com>
References: <20200618211011.28837-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83822 can be configured to use the RGMII interface. There are
independent fixed 3.5ns clock shift (aka internal delay) for the TX and RX
paths. This allow either one to be set if the MII interface is RGMII and
the value is set in the firmware node.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83822.c | 78 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 1dd19d0cb269..0fe91119d57f 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -26,7 +26,9 @@
 #define MII_DP83822_PHYSCR	0x11
 #define MII_DP83822_MISR1	0x12
 #define MII_DP83822_MISR2	0x13
+#define MII_DP83822_RCSR	0x17
 #define MII_DP83822_RESET_CTRL	0x1f
+#define MII_DP83822_GENCFG	0x465
 
 #define DP83822_HW_RESET	BIT(15)
 #define DP83822_SW_RESET	BIT(14)
@@ -77,6 +79,10 @@
 #define DP83822_WOL_INDICATION_SEL BIT(8)
 #define DP83822_WOL_CLR_INDICATION BIT(11)
 
+/* RSCR bits */
+#define DP83822_RX_CLK_SHIFT	BIT(12)
+#define DP83822_TX_CLK_SHIFT	BIT(11)
+
 static int dp83822_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -255,7 +261,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_DP83822_PHYSCR, physcr_status);
 }
 
-static int dp83822_config_init(struct phy_device *phydev)
+static int dp8382x_disable_wol(struct phy_device *phydev)
 {
 	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
 		    DP83822_WOL_SECURE_ON;
@@ -264,6 +270,45 @@ static int dp83822_config_init(struct phy_device *phydev)
 				  MII_DP83822_WOL_CFG, value);
 }
 
+static int dp83822_config_init(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	int rgmii_delay;
+	s32 rx_int_delay;
+	s32 tx_int_delay;
+	int err = 0;
+
+	if (phy_interface_is_rgmii(phydev)) {
+		rx_int_delay = phy_get_internal_delay(phydev, dev, NULL, 0,
+						      true);
+		if (rx_int_delay <= 0)
+			rx_int_delay = 0;
+		else
+			rgmii_delay = DP83822_RX_CLK_SHIFT;
+
+		tx_int_delay = phy_get_internal_delay(phydev, dev, NULL, 0,
+						      false);
+		if (tx_int_delay <= 0)
+			tx_int_delay = 0;
+		else
+			rgmii_delay |= DP83822_TX_CLK_SHIFT;
+
+		if (rgmii_delay) {
+			err = phy_set_bits_mmd(phydev, DP83822_DEVADDR,
+					       MII_DP83822_RCSR, rgmii_delay);
+			if (err)
+				return err;
+		}
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
@@ -272,9 +317,7 @@ static int dp83822_phy_reset(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	dp83822_config_init(phydev);
-
-	return 0;
+	return phydev->drv->config_init(phydev);
 }
 
 static int dp83822_suspend(struct phy_device *phydev)
@@ -318,14 +361,29 @@ static int dp83822_resume(struct phy_device *phydev)
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

