Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CF91155B5
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLFQr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 11:47:27 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57204 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfLFQr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 11:47:26 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB6GlMio016593;
        Fri, 6 Dec 2019 10:47:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575650842;
        bh=YM3VwWjblZ+96a50E5Kk0PHMfn6mkHDwsOR8RbqQotE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=CnFFcQlCv2DuqyT7CPjsraExT648eCgs8MnYMK9qN3UGo6GTIdfkwK9NiPFLnqfCa
         Cd7mVwjBSQVIxZCvUXXI4YmRFVfDBXOEMH+L0djc7HRlvJjcJkVsSuXSz5O92dfL4P
         K/cwRPiNuuRTRWVt480X1N/F5anyjNboA0USxqQI=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB6GlMf6046460
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Dec 2019 10:47:22 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Dec
 2019 10:47:21 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Dec 2019 10:47:21 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6GlLF6062776;
        Fri, 6 Dec 2019 10:47:21 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 2/2] net: phy: dp83867: Add rx-fifo-depth and tx-fifo-depth
Date:   Fri, 6 Dec 2019 10:45:16 -0600
Message-ID: <20191206164516.2702-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191206164516.2702-1-dmurphy@ti.com>
References: <20191206164516.2702-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code changes the TI specific ti,fifo-depth to the common
tx-fifo-depth property.  The tx depth is applicable for both RGMII and
SGMII modes of operation.

rx-fifo-depth was added as well but this is only applicable for SGMII
mode.

So in summary
if RGMII mode write tx fifo depth only
if SGMII mode write both rx and tx fifo depths

If the property is not populated in the device tree then set the value
to the default values.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
Reported-by: Adrian Bunk <bunk@kernel.org>
---
 drivers/net/phy/dp83867.c | 62 +++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 1f1ecee0ee2f..93649ebc87b5 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -72,9 +72,11 @@
 #define DP83867_STRAP_STS2_CLK_SKEW_NONE	BIT(2)
 
 /* PHY CTRL bits */
-#define DP83867_PHYCR_FIFO_DEPTH_SHIFT		14
+#define DP83867_PHYCR_TX_FIFO_DEPTH_SHIFT	14
+#define DP83867_PHYCR_RX_FIFO_DEPTH_SHIFT	12
 #define DP83867_PHYCR_FIFO_DEPTH_MAX		0x03
-#define DP83867_PHYCR_FIFO_DEPTH_MASK		GENMASK(15, 14)
+#define DP83867_PHYCR_TX_FIFO_DEPTH_MASK	GENMASK(15, 14)
+#define DP83867_PHYCR_RX_FIFO_DEPTH_MASK	GENMASK(13, 12)
 #define DP83867_PHYCR_RESERVED_MASK		BIT(11)
 
 /* RGMIIDCTL bits */
@@ -103,7 +105,8 @@ enum {
 struct dp83867_private {
 	u32 rx_id_delay;
 	u32 tx_id_delay;
-	u32 fifo_depth;
+	u32 tx_fifo_depth;
+	u32 rx_fifo_depth;
 	int io_impedance;
 	int port_mirroring;
 	bool rxctrl_strap_quirk;
@@ -255,18 +258,32 @@ static int dp83867_of_init(struct phy_device *phydev)
 		dp83867->port_mirroring = DP83867_PORT_MIRROING_DIS;
 
 	ret = of_property_read_u32(of_node, "ti,fifo-depth",
-				   &dp83867->fifo_depth);
+				   &dp83867->tx_fifo_depth);
 	if (ret) {
-		phydev_err(phydev,
-			   "ti,fifo-depth property is required\n");
-		return ret;
+		ret = of_property_read_u32(of_node, "tx-fifo-depth",
+					   &dp83867->tx_fifo_depth);
+		if (ret)
+			dp83867->tx_fifo_depth =
+					DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
 	}
-	if (dp83867->fifo_depth > DP83867_PHYCR_FIFO_DEPTH_MAX) {
-		phydev_err(phydev,
-			   "ti,fifo-depth value %u out of range\n",
-			   dp83867->fifo_depth);
+
+	if (dp83867->tx_fifo_depth > DP83867_PHYCR_FIFO_DEPTH_MAX) {
+		phydev_err(phydev, "tx-fifo-depth value %u out of range\n",
+			   dp83867->tx_fifo_depth);
 		return -EINVAL;
 	}
+
+	ret = of_property_read_u32(of_node, "rx-fifo-depth",
+				   &dp83867->rx_fifo_depth);
+	if (ret)
+		dp83867->rx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+
+	if (dp83867->rx_fifo_depth > DP83867_PHYCR_FIFO_DEPTH_MAX) {
+		phydev_err(phydev, "rx-fifo-depth value %u out of range\n",
+			   dp83867->rx_fifo_depth);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 #else
@@ -305,12 +322,31 @@ static int dp83867_config_init(struct phy_device *phydev)
 		phy_clear_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
 				   BIT(7));
 
+	if (phy_interface_is_rgmii(phydev) ||
+	    phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		val = phy_read(phydev, MII_DP83867_PHYCTRL);
+		if (val < 0)
+			return val;
+
+		val &= ~DP83867_PHYCR_TX_FIFO_DEPTH_MASK;
+		val |= (dp83867->tx_fifo_depth <<
+			DP83867_PHYCR_TX_FIFO_DEPTH_SHIFT);
+
+		if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+			val &= ~DP83867_PHYCR_RX_FIFO_DEPTH_MASK;
+			val |= (dp83867->rx_fifo_depth <<
+				DP83867_PHYCR_RX_FIFO_DEPTH_SHIFT);
+		}
+
+		ret = phy_write(phydev, MII_DP83867_PHYCTRL, val);
+		if (ret)
+			return ret;
+	}
+
 	if (phy_interface_is_rgmii(phydev)) {
 		val = phy_read(phydev, MII_DP83867_PHYCTRL);
 		if (val < 0)
 			return val;
-		val &= ~DP83867_PHYCR_FIFO_DEPTH_MASK;
-		val |= (dp83867->fifo_depth << DP83867_PHYCR_FIFO_DEPTH_SHIFT);
 
 		/* The code below checks if "port mirroring" N/A MODE4 has been
 		 * enabled during power on bootstrap.
-- 
2.23.0

