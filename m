Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F79117358
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLISCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:02:02 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58666 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfLISCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:02:00 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB9I1sEs119818;
        Mon, 9 Dec 2019 12:01:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575914514;
        bh=OSPe/QWwbGv5rEkM1GTgw52VUOMrBBQsY+i7pQwIszU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=n1xWiFs1sdZ74KT4nPfL/PFm+m/RMiEUqcowWrWy+CEMVWgF5fIyA7OnTW/HVFemv
         EqDGNcUyCSbRe6Wo3JIZ+Vio2AwoHp9gCeCFdyV9I/qzNVS7ge5q+KWZP2SuruVUTL
         MY3PtssLCSxG5PzmpTbD7sv01SC0RdgE2bRoSmh8=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9I1sld024438;
        Mon, 9 Dec 2019 12:01:54 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 9 Dec
 2019 12:01:52 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 9 Dec 2019 12:01:52 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9I1qN7053053;
        Mon, 9 Dec 2019 12:01:52 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 2/2] net: phy: dp83867: Add rx-fifo-depth and tx-fifo-depth
Date:   Mon, 9 Dec 2019 11:59:43 -0600
Message-ID: <20191209175943.23110-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191209175943.23110-1-dmurphy@ti.com>
References: <20191209175943.23110-1-dmurphy@ti.com>
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
index 9cd9dcee4eb2..adda0d0eab80 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -93,9 +93,11 @@
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
@@ -131,7 +133,8 @@ enum {
 struct dp83867_private {
 	u32 rx_id_delay;
 	u32 tx_id_delay;
-	u32 fifo_depth;
+	u32 tx_fifo_depth;
+	u32 rx_fifo_depth;
 	int io_impedance;
 	int port_mirroring;
 	bool rxctrl_strap_quirk;
@@ -408,18 +411,32 @@ static int dp83867_of_init(struct phy_device *phydev)
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
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(of_node, "rx-fifo-depth",
+				   &dp83867->rx_fifo_depth);
+	if (ret)
+		dp83867->rx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+
+	if (dp83867->rx_fifo_depth > DP83867_PHYCR_FIFO_DEPTH_MAX) {
+		phydev_err(phydev, "rx-fifo-depth value %u out of range\n",
+			   dp83867->rx_fifo_depth);
 		return -EINVAL;
 	}
+
 	return 0;
 }
 #else
@@ -458,12 +475,31 @@ static int dp83867_config_init(struct phy_device *phydev)
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

