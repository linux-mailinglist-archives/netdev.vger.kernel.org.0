Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA701DB302
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgETMTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:19:13 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59142 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgETMTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:19:07 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KCJ33W111672;
        Wed, 20 May 2020 07:19:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589977143;
        bh=JZa+FauZgdrffwPtxZ/aHDBLsKUhof7X2r2VtyoJh2I=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=nFGLU/tcAR795VH2XkdkETnoqSu5y1aW2h8ctzmGLTx1MrvARKq+LVgjBNAOzLjdL
         1FtWy+4l8vAOHPclhs7rmDI9ZpKmxWFg+3DxahUJajtl4Guzq4RM1S04Z65RxmU+S8
         6von1LAEMeVqqszVpkiHpF54HprlWhDua+IUlBQ8=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KCJ2VY067278
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 07:19:03 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 07:19:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 07:19:02 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KCJ2ki109121;
        Wed, 20 May 2020 07:19:02 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 4/4] net: dp83869: Add RGMII internal delay configuration
Date:   Wed, 20 May 2020 07:18:35 -0500
Message-ID: <20200520121835.31190-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520121835.31190-1-dmurphy@ti.com>
References: <20200520121835.31190-1-dmurphy@ti.com>
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
 drivers/net/phy/dp83869.c | 84 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index cfb22a21a2e6..f08008050177 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -99,6 +99,14 @@
 #define DP83869_OP_MODE_MII			BIT(5)
 #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
 
+/* RGMIIDCTL bits */
+#define DP83869_RGMII_TX_CLK_DELAY_MAX		0xf
+#define DP83869_RGMII_TX_CLK_DELAY_SHIFT	4
+#define DP83869_RGMII_TX_CLK_DELAY_INV	(DP83869_RGMII_TX_CLK_DELAY_MAX + 1)
+#define DP83869_RGMII_RX_CLK_DELAY_MAX		0xf
+#define DP83869_RGMII_RX_CLK_DELAY_SHIFT	0
+#define DP83869_RGMII_RX_CLK_DELAY_INV	(DP83869_RGMII_RX_CLK_DELAY_MAX + 1)
+
 enum {
 	DP83869_PORT_MIRRORING_KEEP,
 	DP83869_PORT_MIRRORING_EN,
@@ -108,6 +116,8 @@ enum {
 struct dp83869_private {
 	int tx_fifo_depth;
 	int rx_fifo_depth;
+	u32 rx_id_delay;
+	u32 tx_id_delay;
 	int io_impedance;
 	int port_mirroring;
 	bool rxctrl_strap_quirk;
@@ -232,6 +242,26 @@ static int dp83869_of_init(struct phy_device *phydev)
 				 &dp83869->tx_fifo_depth))
 		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
 
+	dp83869->rx_id_delay = DP83869_RGMII_RX_CLK_DELAY_INV;
+	ret = of_property_read_u32(of_node, "ti,rx-internal-delay",
+				   &dp83869->rx_id_delay);
+	if (!ret && dp83869->rx_id_delay > DP83869_RGMII_RX_CLK_DELAY_MAX) {
+		phydev_err(phydev,
+			   "ti,rx-internal-delay value of %u out of range\n",
+			   dp83869->rx_id_delay);
+		return -EINVAL;
+	}
+
+	dp83869->tx_id_delay = DP83869_RGMII_TX_CLK_DELAY_INV;
+	ret = of_property_read_u32(of_node, "ti,tx-internal-delay",
+				   &dp83869->tx_id_delay);
+	if (!ret && dp83869->tx_id_delay > DP83869_RGMII_TX_CLK_DELAY_MAX) {
+		phydev_err(phydev,
+			   "ti,tx-internal-delay value of %u out of range\n",
+			   dp83869->tx_id_delay);
+		return -EINVAL;
+	}
+
 	return ret;
 }
 #else
@@ -270,6 +300,29 @@ static int dp83869_configure_rgmii(struct phy_device *phydev,
 	return ret;
 }
 
+static int dp83869_verify_rgmii_cfg(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+
+	/* RX delay *must* be specified if internal delay of RX is used. */
+	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	     phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) &&
+	     dp83869->rx_id_delay == DP83869_RGMII_RX_CLK_DELAY_INV) {
+		phydev_err(phydev, "ti,rx-internal-delay must be specified\n");
+		return -EINVAL;
+	}
+
+	/* TX delay *must* be specified if internal delay of TX is used. */
+	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	     phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) &&
+	     dp83869->tx_id_delay == DP83869_RGMII_TX_CLK_DELAY_INV) {
+		phydev_err(phydev, "ti,tx-internal-delay must be specified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int dp83869_configure_mode(struct phy_device *phydev,
 				  struct dp83869_private *dp83869)
 {
@@ -371,6 +424,11 @@ static int dp83869_config_init(struct phy_device *phydev)
 {
 	struct dp83869_private *dp83869 = phydev->priv;
 	int ret, val;
+	u16 delay;
+
+	ret = dp83869_verify_rgmii_cfg(phydev);
+	if (ret)
+		return ret;
 
 	ret = dp83869_configure_mode(phydev, dp83869);
 	if (ret)
@@ -394,6 +452,32 @@ static int dp83869_config_init(struct phy_device *phydev)
 				     dp83869->clk_output_sel <<
 				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
 
+	if (phy_interface_is_rgmii(phydev)) {
+		val = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL);
+
+		val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN | DP83869_RGMII_RX_CLK_DELAY_EN);
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+			val |= (DP83869_RGMII_TX_CLK_DELAY_EN | DP83869_RGMII_RX_CLK_DELAY_EN);
+
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			val |= DP83869_RGMII_TX_CLK_DELAY_EN;
+
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+			val |= DP83869_RGMII_RX_CLK_DELAY_EN;
+
+		phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL, val);
+
+		delay = 0;
+		if (dp83869->rx_id_delay != DP83869_RGMII_RX_CLK_DELAY_INV)
+			delay |= dp83869->rx_id_delay;
+		if (dp83869->tx_id_delay != DP83869_RGMII_TX_CLK_DELAY_INV)
+			delay |= dp83869->tx_id_delay <<
+				 DP83869_RGMII_TX_CLK_DELAY_SHIFT;
+
+		phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIIDCTL,
+			      delay);
+	}
+
 	return ret;
 }
 
-- 
2.26.2

