Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1274F1FFD40
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbgFRVKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:10:47 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:49236 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbgFRVKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:10:45 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05ILAcIM091040;
        Thu, 18 Jun 2020 16:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592514638;
        bh=4E5KHNl9oTC+RZ54rEq6HG+IBnY8toM5mVy2z1lrdtM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UBgKux4o97JQDQ1hUq1q/TGJ69DrJ5bAaFvgPQkj/QApvyR/a9Q8LldARJXBJPx0p
         9qb6B+P0KepYvBM39mfJWsjfHAadXlIFtbQfeM+Uv5kwN7si6MDBr/XyiT4XT/YoJq
         s/4JvhK1uoQN5v64fZMEUXeFFHguT51f7YYGrToI=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05ILAccm003024
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 16:10:38 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 18
 Jun 2020 16:10:38 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 18 Jun 2020 16:10:38 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05ILAcKY065901;
        Thu, 18 Jun 2020 16:10:38 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v8 4/5] net: dp83869: Add RGMII internal delay configuration
Date:   Thu, 18 Jun 2020 16:10:10 -0500
Message-ID: <20200618211011.28837-5-dmurphy@ti.com>
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

Add RGMII internal delay configuration for Rx and Tx.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 53 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 53ed3abc26c9..21b7d3de14a9 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -64,6 +64,10 @@
 #define DP83869_RGMII_TX_CLK_DELAY_EN		BIT(1)
 #define DP83869_RGMII_RX_CLK_DELAY_EN		BIT(0)
 
+/* RGMIIDCTL */
+#define DP83869_RGMII_CLK_DELAY_SHIFT		4
+#define DP83869_CLK_DELAY_DEF			7
+
 /* STRAP_STS1 bits */
 #define DP83869_STRAP_OP_MODE_MASK		GENMASK(2, 0)
 #define DP83869_STRAP_STS1_RESERVED		BIT(11)
@@ -78,9 +82,6 @@
 #define DP83869_PHYCR_FIFO_DEPTH_MASK	GENMASK(15, 12)
 #define DP83869_PHYCR_RESERVED_MASK	BIT(11)
 
-/* RGMIIDCTL bits */
-#define DP83869_RGMII_TX_CLK_DELAY_SHIFT	4
-
 /* IO_MUX_CFG bits */
 #define DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL	0x1f
 
@@ -99,6 +100,10 @@
 #define DP83869_OP_MODE_MII			BIT(5)
 #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
 
+static const int dp83869_internal_delay[] = {250, 500, 750, 1000, 1250, 1500,
+					     1750, 2000, 2250, 2500, 2750, 3000,
+					     3250, 3500, 3750, 4000};
+
 enum {
 	DP83869_PORT_MIRRORING_KEEP,
 	DP83869_PORT_MIRRORING_EN,
@@ -108,6 +113,8 @@ enum {
 struct dp83869_private {
 	int tx_fifo_depth;
 	int rx_fifo_depth;
+	s32 rx_int_delay;
+	s32 tx_int_delay;
 	int io_impedance;
 	int port_mirroring;
 	bool rxctrl_strap_quirk;
@@ -182,6 +189,7 @@ static int dp83869_of_init(struct phy_device *phydev)
 	struct dp83869_private *dp83869 = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
+	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
 	int ret;
 
 	if (!of_node)
@@ -235,6 +243,20 @@ static int dp83869_of_init(struct phy_device *phydev)
 				 &dp83869->tx_fifo_depth))
 		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
 
+	dp83869->rx_int_delay = phy_get_internal_delay(phydev, dev,
+						       &dp83869_internal_delay[0],
+						       delay_size, true);
+	if (dp83869->rx_int_delay < 0)
+		dp83869->rx_int_delay =
+				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+
+	dp83869->tx_int_delay = phy_get_internal_delay(phydev, dev,
+						       &dp83869_internal_delay[0],
+						       delay_size, false);
+	if (dp83869->tx_int_delay < 0)
+		dp83869->tx_int_delay =
+				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+
 	return ret;
 }
 #else
@@ -397,6 +419,31 @@ static int dp83869_config_init(struct phy_device *phydev)
 				     dp83869->clk_output_sel <<
 				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
 
+	if (phy_interface_is_rgmii(phydev)) {
+		ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIIDCTL,
+				    dp83869->rx_int_delay |
+			dp83869->tx_int_delay << DP83869_RGMII_CLK_DELAY_SHIFT);
+		if (ret)
+			return ret;
+
+		val = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL);
+		val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN |
+			 DP83869_RGMII_RX_CLK_DELAY_EN);
+
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+			val |= (DP83869_RGMII_TX_CLK_DELAY_EN |
+				DP83869_RGMII_RX_CLK_DELAY_EN);
+
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			val |= DP83869_RGMII_TX_CLK_DELAY_EN;
+
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+			val |= DP83869_RGMII_RX_CLK_DELAY_EN;
+
+		ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL,
+				    val);
+	}
+
 	return ret;
 }
 
-- 
2.26.2

