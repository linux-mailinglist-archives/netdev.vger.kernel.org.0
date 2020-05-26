Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627C51E2968
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389085AbgEZRsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:48:50 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58428 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388499AbgEZRsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:48:50 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QHmhNP103268;
        Tue, 26 May 2020 12:48:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590515323;
        bh=qHVpA1Q6epqnqSqEAx0SKTTya9mqUNPldRJpAOKn1GQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=keLEo3SzQPdpQzCKQ058xrEz58iG72v5jTMmZ4gBcHJ7BT3pWilfssK4BAB9A4Gio
         XEU5p24R3OQ7SRLeHWjJw9Znv2Y+RUkLNQni9OPTwfvvsdIW8KIF+93oIb2dfAaM93
         FPaoAuUTKZWNqdzrzSIIaMGTIBPuGUUPd+7dccZk=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04QHmhte124674
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 12:48:43 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 12:47:18 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 12:47:18 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QHlIgs107893;
        Tue, 26 May 2020 12:47:18 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 4/4] net: dp83869: Add RGMII internal delay configuration
Date:   Tue, 26 May 2020 12:47:16 -0500
Message-ID: <20200526174716.14116-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526174716.14116-1-dmurphy@ti.com>
References: <20200526174716.14116-1-dmurphy@ti.com>
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
 drivers/net/phy/dp83869.c | 91 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index cfb22a21a2e6..1c440e0c0d64 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -64,6 +64,9 @@
 #define DP83869_RGMII_TX_CLK_DELAY_EN		BIT(1)
 #define DP83869_RGMII_RX_CLK_DELAY_EN		BIT(0)
 
+/* RGMIIDCTL */
+#define DP83869_RGMII_CLK_DELAY_SHIFT		4
+
 /* STRAP_STS1 bits */
 #define DP83869_STRAP_OP_MODE_MASK		GENMASK(2, 0)
 #define DP83869_STRAP_STS1_RESERVED		BIT(11)
@@ -78,9 +81,6 @@
 #define DP83869_PHYCR_FIFO_DEPTH_MASK	GENMASK(15, 12)
 #define DP83869_PHYCR_RESERVED_MASK	BIT(11)
 
-/* RGMIIDCTL bits */
-#define DP83869_RGMII_TX_CLK_DELAY_SHIFT	4
-
 /* IO_MUX_CFG bits */
 #define DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL	0x1f
 
@@ -99,6 +99,10 @@
 #define DP83869_OP_MODE_MII			BIT(5)
 #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
 
+static int dp83869_internal_delay[] = {250, 500, 750, 1000, 1250, 1500, 1750,
+				       2000, 2250, 2500, 2750, 3000, 3250,
+				       3500, 3750, 4000};
+
 enum {
 	DP83869_PORT_MIRRORING_KEEP,
 	DP83869_PORT_MIRRORING_EN,
@@ -108,6 +112,8 @@ enum {
 struct dp83869_private {
 	int tx_fifo_depth;
 	int rx_fifo_depth;
+	s32 rx_id_delay;
+	s32 tx_id_delay;
 	int io_impedance;
 	int port_mirroring;
 	bool rxctrl_strap_quirk;
@@ -218,6 +224,7 @@ static int dp83869_of_init(struct phy_device *phydev)
 		ret = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_STRAP_STS1);
 		if (ret < 0)
 			return ret;
+
 		if (ret & DP83869_STRAP_MIRROR_ENABLED)
 			dp83869->port_mirroring = DP83869_PORT_MIRRORING_EN;
 		else
@@ -232,6 +239,20 @@ static int dp83869_of_init(struct phy_device *phydev)
 				 &dp83869->tx_fifo_depth))
 		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
 
+	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
+				   &dp83869->rx_id_delay);
+	if (ret) {
+		dp83869->rx_id_delay = ret;
+		ret = 0;
+	}
+
+	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
+				   &dp83869->tx_id_delay);
+	if (ret) {
+		dp83869->tx_id_delay = ret;
+		ret = 0;
+	}
+
 	return ret;
 }
 #else
@@ -367,10 +388,45 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 	return ret;
 }
 
+static int dp83869_get_delay(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
+	int tx_delay = 0;
+	int rx_delay = 0;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
+		tx_delay = phy_get_delay_index(phydev,
+					       &dp83869_internal_delay[0],
+					       delay_size, dp83869->tx_id_delay,
+					       false);
+		if (tx_delay < 0) {
+			phydev_err(phydev, "Tx internal delay is invalid\n");
+			return tx_delay;
+		}
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
+		rx_delay = phy_get_delay_index(phydev,
+					       &dp83869_internal_delay[0],
+					       delay_size, dp83869->rx_id_delay,
+					       false);
+		if (rx_delay < 0) {
+			phydev_err(phydev, "Rx internal delay is invalid\n");
+			return rx_delay;
+		}
+	}
+
+	return rx_delay | tx_delay << DP83869_RGMII_CLK_DELAY_SHIFT;
+}
+
 static int dp83869_config_init(struct phy_device *phydev)
 {
 	struct dp83869_private *dp83869 = phydev->priv;
 	int ret, val;
+	int delay;
 
 	ret = dp83869_configure_mode(phydev, dp83869);
 	if (ret)
@@ -394,6 +450,35 @@ static int dp83869_config_init(struct phy_device *phydev)
 				     dp83869->clk_output_sel <<
 				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
 
+	if (phy_interface_is_rgmii(phydev)) {
+		ret = dp83869_get_delay(phydev);
+		if (ret < 0)
+			return ret;
+
+		delay = ret;
+		ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIIDCTL,
+				    delay);
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

