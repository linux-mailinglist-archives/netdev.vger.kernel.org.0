Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6BE112B5F
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 13:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfLDMWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 07:22:42 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40506 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbfLDMWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 07:22:42 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4CMaag011912;
        Wed, 4 Dec 2019 06:22:36 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575462156;
        bh=2T/wwk3W1LKzBzA5mnDpSGz8/pr3rFU9EQeKYaI8FpY=;
        h=From:To:CC:Subject:Date;
        b=MuercMXVYw0B3SAJq95QsDwe7eLxZ+ROSst/3GL+yzsoSKucCj0VWGhHibKFOuRE1
         0fIwFHh0qjDK0T903uEGr+Z/supGShmixl5JUcE2BycHrnDhqyGAuAgFl6nNfWGn7+
         rNpYfhQyjptM4g6r+JuUAeENDUar7D5QwbgFhjhg=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB4CMau1069396
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Dec 2019 06:22:36 -0600
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 06:22:34 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 06:22:34 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4CMXwW103192;
        Wed, 4 Dec 2019 06:22:34 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: phy: dp83867: fix hfs boot in rgmii mode
Date:   Wed, 4 Dec 2019 14:22:32 +0200
Message-ID: <20191204122232.18107-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit ef87f7da6b28 ("net: phy: dp83867: move dt parsing to probe")
causes regression on TI dra71x-evm and dra72x-evm, where DP83867 PHY is
used in "rgmii-id" mode - the networking stops working.
Unfortunately, it's not enough to just move DT parsing code to .probe() as
it depends on phydev->interface value, which is set to correct value abter
the .probe() is completed and before calling .config_init(). So, RGMII
configuration can't be loaded from DT.

To fix and issue
- move RGMII validation code to .config_init()
- parse RGMII parameters in dp83867_of_init(), but consider them as
optional.

Fixes: ef87f7da6b28 ("net: phy: dp83867: move dt parsing to probe")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Hi All,

i'm very sorry for this regression. I've tested it on only one board and
was just lucky probably. 
I still think it's better to DT parsing at .probe(),
but as second option - buggy patch can be reverted.

 drivers/net/phy/dp83867.c | 117 +++++++++++++++++++++++---------------
 1 file changed, 71 insertions(+), 46 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 0b95e7a2e273..f3fc49a93245 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -101,8 +101,11 @@
 /* RGMIIDCTL bits */
 #define DP83867_RGMII_TX_CLK_DELAY_MAX		0xf
 #define DP83867_RGMII_TX_CLK_DELAY_SHIFT	4
+#define DP83867_RGMII_TX_CLK_DELAY_INV	(DP83867_RGMII_TX_CLK_DELAY_MAX + 1)
 #define DP83867_RGMII_RX_CLK_DELAY_MAX		0xf
 #define DP83867_RGMII_RX_CLK_DELAY_SHIFT	0
+#define DP83867_RGMII_RX_CLK_DELAY_INV	(DP83867_RGMII_RX_CLK_DELAY_MAX + 1)
+
 
 /* IO_MUX_CFG bits */
 #define DP83867_IO_MUX_CFG_IO_IMPEDANCE_MASK	0x1f
@@ -294,6 +297,48 @@ static int dp83867_config_port_mirroring(struct phy_device *phydev)
 	return 0;
 }
 
+static int dp83867_verify_rgmii_cfg(struct phy_device *phydev)
+{
+	struct dp83867_private *dp83867 = phydev->priv;
+
+	/* Existing behavior was to use default pin strapping delay in rgmii
+	 * mode, but rgmii should have meant no delay.  Warn existing users.
+	 */
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
+		const u16 val = phy_read_mmd(phydev, DP83867_DEVADDR,
+					     DP83867_STRAP_STS2);
+		const u16 txskew = (val & DP83867_STRAP_STS2_CLK_SKEW_TX_MASK) >>
+				   DP83867_STRAP_STS2_CLK_SKEW_TX_SHIFT;
+		const u16 rxskew = (val & DP83867_STRAP_STS2_CLK_SKEW_RX_MASK) >>
+				   DP83867_STRAP_STS2_CLK_SKEW_RX_SHIFT;
+
+		if (txskew != DP83867_STRAP_STS2_CLK_SKEW_NONE ||
+		    rxskew != DP83867_STRAP_STS2_CLK_SKEW_NONE)
+			phydev_warn(phydev,
+				    "PHY has delays via pin strapping, but phy-mode = 'rgmii'\n"
+				    "Should be 'rgmii-id' to use internal delays txskew:%x rxskew:%x\n",
+				    txskew, rxskew);
+	}
+
+	/* RX delay *must* be specified if internal delay of RX is used. */
+	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	     phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) &&
+	     dp83867->rx_id_delay == DP83867_RGMII_RX_CLK_DELAY_INV) {
+		phydev_err(phydev, "ti,rx-internal-delay must be specified\n");
+		return -EINVAL;
+	}
+
+	/* TX delay *must* be specified if internal delay of RX is used. */
+	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	     phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) &&
+	     dp83867->tx_id_delay == DP83867_RGMII_TX_CLK_DELAY_INV) {
+		phydev_err(phydev, "ti,tx-internal-delay must be specified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_OF_MDIO
 static int dp83867_of_init(struct phy_device *phydev)
 {
@@ -335,55 +380,27 @@ static int dp83867_of_init(struct phy_device *phydev)
 	dp83867->sgmii_ref_clk_en = of_property_read_bool(of_node,
 					"ti,sgmii-ref-clock-output-enable");
 
-	/* Existing behavior was to use default pin strapping delay in rgmii
-	 * mode, but rgmii should have meant no delay.  Warn existing users.
-	 */
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
-		const u16 val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_STRAP_STS2);
-		const u16 txskew = (val & DP83867_STRAP_STS2_CLK_SKEW_TX_MASK) >>
-				   DP83867_STRAP_STS2_CLK_SKEW_TX_SHIFT;
-		const u16 rxskew = (val & DP83867_STRAP_STS2_CLK_SKEW_RX_MASK) >>
-				   DP83867_STRAP_STS2_CLK_SKEW_RX_SHIFT;
-
-		if (txskew != DP83867_STRAP_STS2_CLK_SKEW_NONE ||
-		    rxskew != DP83867_STRAP_STS2_CLK_SKEW_NONE)
-			phydev_warn(phydev,
-				    "PHY has delays via pin strapping, but phy-mode = 'rgmii'\n"
-				    "Should be 'rgmii-id' to use internal delays\n");
-	}
 
 	/* RX delay *must* be specified if internal delay of RX is used. */
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
-		ret = of_property_read_u32(of_node, "ti,rx-internal-delay",
-					   &dp83867->rx_id_delay);
-		if (ret) {
-			phydev_err(phydev, "ti,rx-internal-delay must be specified\n");
-			return ret;
-		}
-		if (dp83867->rx_id_delay > DP83867_RGMII_RX_CLK_DELAY_MAX) {
-			phydev_err(phydev,
-				   "ti,rx-internal-delay value of %u out of range\n",
-				   dp83867->rx_id_delay);
-			return -EINVAL;
-		}
+	dp83867->rx_id_delay = DP83867_RGMII_RX_CLK_DELAY_INV;
+	ret = of_property_read_u32(of_node, "ti,rx-internal-delay",
+				   &dp83867->rx_id_delay);
+	if (!ret && dp83867->rx_id_delay > DP83867_RGMII_RX_CLK_DELAY_MAX) {
+		phydev_err(phydev,
+			   "ti,rx-internal-delay value of %u out of range\n",
+			   dp83867->rx_id_delay);
+		return -EINVAL;
 	}
 
 	/* TX delay *must* be specified if internal delay of RX is used. */
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
-		ret = of_property_read_u32(of_node, "ti,tx-internal-delay",
-					   &dp83867->tx_id_delay);
-		if (ret) {
-			phydev_err(phydev, "ti,tx-internal-delay must be specified\n");
-			return ret;
-		}
-		if (dp83867->tx_id_delay > DP83867_RGMII_TX_CLK_DELAY_MAX) {
-			phydev_err(phydev,
-				   "ti,tx-internal-delay value of %u out of range\n",
-				   dp83867->tx_id_delay);
-			return -EINVAL;
-		}
+	dp83867->tx_id_delay = DP83867_RGMII_TX_CLK_DELAY_INV;
+	ret = of_property_read_u32(of_node, "ti,tx-internal-delay",
+				   &dp83867->tx_id_delay);
+	if (!ret && dp83867->tx_id_delay > DP83867_RGMII_TX_CLK_DELAY_MAX) {
+		phydev_err(phydev,
+			   "ti,tx-internal-delay value of %u out of range\n",
+			   dp83867->tx_id_delay);
+		return -EINVAL;
 	}
 
 	if (of_property_read_bool(of_node, "enet-phy-lane-swap"))
@@ -434,6 +451,10 @@ static int dp83867_config_init(struct phy_device *phydev)
 	int ret, val, bs;
 	u16 delay;
 
+	ret = dp83867_verify_rgmii_cfg(phydev);
+	if (ret)
+		return ret;
+
 	/* RX_DV/RX_CTRL strapped in mode 1 or mode 2 workaround */
 	if (dp83867->rxctrl_strap_quirk)
 		phy_clear_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
@@ -485,8 +506,12 @@ static int dp83867_config_init(struct phy_device *phydev)
 
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIICTL, val);
 
-		delay = (dp83867->rx_id_delay |
-			(dp83867->tx_id_delay << DP83867_RGMII_TX_CLK_DELAY_SHIFT));
+		delay = 0;
+		if (dp83867->rx_id_delay != DP83867_RGMII_RX_CLK_DELAY_INV)
+			delay |= dp83867->rx_id_delay;
+		if (dp83867->tx_id_delay != DP83867_RGMII_TX_CLK_DELAY_INV)
+			delay |= dp83867->tx_id_delay <<
+				 DP83867_RGMII_TX_CLK_DELAY_SHIFT;
 
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIIDCTL,
 			      delay);
-- 
2.17.1

