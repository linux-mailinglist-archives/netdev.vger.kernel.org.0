Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975F4201526
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405620AbgFSQSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 12:18:41 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60010 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405602AbgFSQSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 12:18:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05JGIWdc001299;
        Fri, 19 Jun 2020 11:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592583512;
        bh=iLdvMCbgjuB3IvjEffc3VbBTcvc2wltvJLix5r4FFus=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=VS1Razg+H3pShYMTBz7cL7oiJYLe9femNbmtoxAouLyjN6WqqdNbsEHbxfj2Lvjgg
         /jfONy1cg7KwhNoMOPt2Txdv3+OG6P5XbexuVVo3bS55oOKjpAS6oZ4zfZsw6VwXpF
         0Uw34uNaz7LdQRtg9YqJFZYACWbjMucWPyf5jUAY=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05JGIWlX122299
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 11:18:32 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 19
 Jun 2020 11:18:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 19 Jun 2020 11:18:31 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05JGIVoW034961;
        Fri, 19 Jun 2020 11:18:31 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v9 4/5] net: dp83869: Add RGMII internal delay configuration
Date:   Fri, 19 Jun 2020 11:18:12 -0500
Message-ID: <20200619161813.2716-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619161813.2716-1-dmurphy@ti.com>
References: <20200619161813.2716-1-dmurphy@ti.com>
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
index 53ed3abc26c9..58103152c601 100644
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
 
@@ -108,6 +109,8 @@ enum {
 struct dp83869_private {
 	int tx_fifo_depth;
 	int rx_fifo_depth;
+	s32 rx_int_delay;
+	s32 tx_int_delay;
 	int io_impedance;
 	int port_mirroring;
 	bool rxctrl_strap_quirk;
@@ -177,11 +180,16 @@ static int dp83869_set_strapped_mode(struct phy_device *phydev)
 }
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
+static const int dp83869_internal_delay[] = {250, 500, 750, 1000, 1250, 1500,
+					     1750, 2000, 2250, 2500, 2750, 3000,
+					     3250, 3500, 3750, 4000};
+
 static int dp83869_of_init(struct phy_device *phydev)
 {
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

