Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256E910A085
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfKZOkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:40:53 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:33112 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZOkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 09:40:52 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAQEeiae068708;
        Tue, 26 Nov 2019 08:40:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574779245;
        bh=/lX0a4HRjn9vIBiDA09cjjnBJ9xLaVcrKuRQEoaNQrQ=;
        h=From:To:CC:Subject:Date;
        b=uB9vMWvbl3SYq7E0dGcUpV5nIkNTddbADqhKRBxjPTuQXL7p9KOCbnnBGRiI2dXjn
         j0SkdQrkW3JWKlhZ7SpaNQFwwhvkQqPB7r72yyugJlnTKAigFur5U/XFT5o6JMzS/d
         h/5spFLazLrGzch0C/BA6cZx13dgcZ96UiubGF0A=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAQEeigl119717;
        Tue, 26 Nov 2019 08:40:44 -0600
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 26
 Nov 2019 08:40:44 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 26 Nov 2019 08:40:44 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAQEeiMe086463;
        Tue, 26 Nov 2019 08:40:44 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] net: phy: dp83869: Fix return paths to return proper values
Date:   Tue, 26 Nov 2019 08:38:56 -0600
Message-ID: <20191126143856.26451-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the return paths for all I/O operations to ensure
that the I/O completed successfully.  Then pass the return
to the caller for further processing

Reported-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 01db923e8377 ("net: phy: dp83869: Add TI dp83869 phy")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 49 +++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 1c7a7c57dec3..93021904c5e4 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -151,13 +151,13 @@ static int dp83869_config_port_mirroring(struct phy_device *phydev)
 	struct dp83869_private *dp83869 = phydev->priv;
 
 	if (dp83869->port_mirroring == DP83869_PORT_MIRRORING_EN)
-		phy_set_bits_mmd(phydev, DP83869_DEVADDR, DP83869_GEN_CFG3,
-				 DP83869_CFG3_PORT_MIRROR_EN);
+		return phy_set_bits_mmd(phydev, DP83869_DEVADDR,
+					DP83869_GEN_CFG3,
+					DP83869_CFG3_PORT_MIRROR_EN);
 	else
-		phy_clear_bits_mmd(phydev, DP83869_DEVADDR, DP83869_GEN_CFG3,
-				   DP83869_CFG3_PORT_MIRROR_EN);
-
-	return 0;
+		return phy_clear_bits_mmd(phydev, DP83869_DEVADDR,
+					  DP83869_GEN_CFG3,
+					  DP83869_CFG3_PORT_MIRROR_EN);
 }
 
 #ifdef CONFIG_OF_MDIO
@@ -204,7 +204,7 @@ static int dp83869_of_init(struct phy_device *phydev)
 				 &dp83869->tx_fifo_depth))
 		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
 
-	return 0;
+	return ret;
 }
 #else
 static int dp83869_of_init(struct phy_device *phydev)
@@ -216,7 +216,7 @@ static int dp83869_of_init(struct phy_device *phydev)
 static int dp83869_configure_rgmii(struct phy_device *phydev,
 				   struct dp83869_private *dp83869)
 {
-	int ret, val;
+	int ret = 0, val;
 
 	if (phy_interface_is_rgmii(phydev)) {
 		val = phy_read(phydev, MII_DP83869_PHYCTRL);
@@ -233,13 +233,13 @@ static int dp83869_configure_rgmii(struct phy_device *phydev,
 	}
 
 	if (dp83869->io_impedance >= 0)
-		phy_modify_mmd(phydev, DP83869_DEVADDR,
-			       DP83869_IO_MUX_CFG,
-			       DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL,
-			       dp83869->io_impedance &
-			       DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
+		ret = phy_modify_mmd(phydev, DP83869_DEVADDR,
+				     DP83869_IO_MUX_CFG,
+				     DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL,
+				     dp83869->io_impedance &
+				     DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
 
-	return 0;
+	return ret;
 }
 
 static int dp83869_configure_mode(struct phy_device *phydev,
@@ -284,9 +284,11 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 			return ret;
 		break;
 	case DP83869_RGMII_SGMII_BRIDGE:
-		phy_modify_mmd(phydev, DP83869_DEVADDR, DP83869_OP_MODE,
-			       DP83869_SGMII_RGMII_BRIDGE,
-			       DP83869_SGMII_RGMII_BRIDGE);
+		ret = phy_modify_mmd(phydev, DP83869_DEVADDR, DP83869_OP_MODE,
+				     DP83869_SGMII_RGMII_BRIDGE,
+				     DP83869_SGMII_RGMII_BRIDGE);
+		if (ret)
+			return ret;
 
 		ret = phy_write_mmd(phydev, DP83869_DEVADDR,
 				    DP83869_FX_CTRL, DP83869_FX_CTRL_DEFAULT);
@@ -334,7 +336,7 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 		return -EINVAL;
 	};
 
-	return 0;
+	return ret;
 }
 
 static int dp83869_config_init(struct phy_device *phydev)
@@ -358,12 +360,13 @@ static int dp83869_config_init(struct phy_device *phydev)
 
 	/* Clock output selection if muxing property is set */
 	if (dp83869->clk_output_sel != DP83869_CLK_O_SEL_REF_CLK)
-		phy_modify_mmd(phydev, DP83869_DEVADDR, DP83869_IO_MUX_CFG,
-			       DP83869_IO_MUX_CFG_CLK_O_SEL_MASK,
-			       dp83869->clk_output_sel <<
-			       DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
+		ret = phy_modify_mmd(phydev,
+				     DP83869_DEVADDR, DP83869_IO_MUX_CFG,
+				     DP83869_IO_MUX_CFG_CLK_O_SEL_MASK,
+				     dp83869->clk_output_sel <<
+				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
 
-	return 0;
+	return ret;
 }
 
 static int dp83869_probe(struct phy_device *phydev)
-- 
2.23.0

