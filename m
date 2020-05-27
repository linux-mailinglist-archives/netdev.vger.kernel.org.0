Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F33B1E4AF5
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbgE0QuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:50:04 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:45080 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730694AbgE0QuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:50:02 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04RGnuiV083922;
        Wed, 27 May 2020 11:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590598196;
        bh=dRys4SyEsTPUvsxrlOxuMVmtB0m1gpns1jd3eGMUcZw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=dlhgtTeYMp/xt7dYzysTxRMaJtQF7L8hXJQGd4zSMwyYJolqFlJsLSVhix3cEiLtA
         0msBn2iG2K1r0BsycwjQOwdN87Tm2rXLmPpITDOlyBwi3pvPSWIJW9Gh+hTW2mi6E7
         maHOL/1Blw0lIYoiiwe4TSgpM63kAMPtZAy/dp9A=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04RGnull006021
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 11:49:56 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 27
 May 2020 11:49:56 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 27 May 2020 11:49:56 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04RGnuVL085739;
        Wed, 27 May 2020 11:49:56 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v4 4/4] net: dp83869: Add RGMII internal delay configuration
Date:   Wed, 27 May 2020 11:49:34 -0500
Message-ID: <20200527164934.28651-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527164934.28651-1-dmurphy@ti.com>
References: <20200527164934.28651-1-dmurphy@ti.com>
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
 drivers/net/phy/dp83869.c | 82 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index cfb22a21a2e6..ba1e3d599888 100644
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
+	s32 rx_id_delay;
+	s32 tx_id_delay;
 	int io_impedance;
 	int port_mirroring;
 	bool rxctrl_strap_quirk;
@@ -232,6 +239,22 @@ static int dp83869_of_init(struct phy_device *phydev)
 				 &dp83869->tx_fifo_depth))
 		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
 
+	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
+				   &dp83869->rx_id_delay);
+	if (ret) {
+		dp83869->rx_id_delay =
+				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		ret = 0;
+	}
+
+	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
+				   &dp83869->tx_id_delay);
+	if (ret) {
+		dp83869->tx_id_delay =
+				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		ret = 0;
+	}
+
 	return ret;
 }
 #else
@@ -367,10 +390,35 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 	return ret;
 }
 
+static int dp83869_get_delay(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
+	int tx_delay;
+	int rx_delay;
+
+	tx_delay = phy_get_delay_index(phydev, &dp83869_internal_delay[0],
+				       delay_size, dp83869->tx_id_delay);
+	if (tx_delay < 0) {
+		phydev_err(phydev, "Tx internal delay is invalid\n");
+		return tx_delay;
+	}
+
+	rx_delay = phy_get_delay_index(phydev, &dp83869_internal_delay[0],
+				       delay_size, dp83869->rx_id_delay);
+	if (rx_delay < 0) {
+		phydev_err(phydev, "Rx internal delay is invalid\n");
+		return rx_delay;
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
@@ -394,6 +442,34 @@ static int dp83869_config_init(struct phy_device *phydev)
 				     dp83869->clk_output_sel <<
 				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
 
+	if (phy_interface_is_rgmii(phydev)) {
+		delay = dp83869_get_delay(phydev);
+		if (delay < 0)
+			return delay;
+
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

