Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCC1173C54
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgB1P5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 10:57:20 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39555 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgB1P5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 10:57:14 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id E129060015;
        Fri, 28 Feb 2020 15:57:10 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: [PATCH net-next v2 3/3] net: phy: mscc: RGMII skew delay configuration
Date:   Fri, 28 Feb 2020 16:57:02 +0100
Message-Id: <20200228155702.2062570-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for configuring the RGMII skew delays in Rx and
Tx. The delay value is retrieved from the device tree, and set based on
the PHY interface mode (rgmii, rgmii-id, rgmii-rx, rgmii-tx). If no
configuration is provided in the device tree, or of a delay isn't used,
its value will be set to the default one at probe time: this driver do
not rely anymore on the bootloader configuration for RGMII skews.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc.c | 50 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index c389d7e59f91..4e9d788d95b9 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -192,6 +192,10 @@ enum macsec_bank {
 /* Extended Page 2 Registers */
 #define MSCC_PHY_CU_PMD_TX_CNTL		  16
 
+#define MSCC_PHY_RGMII_SETTINGS		  18
+#define RGMII_SKEW_RX_POS		  1
+#define RGMII_SKEW_TX_POS		  4
+
 #define MSCC_PHY_RGMII_CNTL		  20
 #define RGMII_RX_CLK_DELAY_MASK		  0x0070
 #define RGMII_RX_CLK_DELAY_POS		  4
@@ -2680,6 +2684,49 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 	return false;
 }
 
+static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
+{
+	u32 skew_rx, skew_tx;
+	struct device *dev = &phydev->mdio.dev;
+
+	/* We first set the Rx and Tx skews to their default value in h/w
+	 * (0.2 ns).
+	 */
+	skew_rx = VSC8584_RGMII_SKEW_0_2;
+	skew_tx = VSC8584_RGMII_SKEW_0_2;
+
+	/* Based on the interface mode, we then retrieve (if available) Rx
+	 * and/or Tx skews from the device tree. We do not fail if the
+	 * properties do not exist, the default skew configuration is a valid
+	 * one.
+	 */
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-rx",
+				     &skew_rx);
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-tx",
+				     &skew_tx);
+
+	/* Make sure we did not retrieve unsupported values. */
+	if (skew_rx > VSC8584_RGMII_SKEW_3_4) {
+		phydev_err(phydev, "Invalid Rx skew, fix the device tree.");
+		skew_rx = VSC8584_RGMII_SKEW_0_2;
+	}
+	if (skew_tx > VSC8584_RGMII_SKEW_3_4) {
+		phydev_err(phydev, "Invalid Tx skew, fix the device tree.");
+		skew_tx = VSC8584_RGMII_SKEW_0_2;
+	}
+
+	/* Finally we do apply the skew configuration. */
+	phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
+			 MSCC_PHY_RGMII_SETTINGS,
+			 (0x7 << RGMII_SKEW_RX_POS) | (0x7 << RGMII_SKEW_TX_POS),
+			 (skew_rx << RGMII_SKEW_RX_POS) |
+			 (skew_tx << RGMII_SKEW_TX_POS));
+}
+
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -2826,6 +2873,9 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	       (VSC8584_MAC_IF_SELECTION_SGMII << VSC8584_MAC_IF_SELECTION_POS);
 	ret = phy_write(phydev, MSCC_PHY_EXT_PHY_CNTL_1, val);
 
+	if (phy_interface_is_rgmii(phydev))
+		vsc8584_rgmii_set_skews(phydev);
+
 	ret = genphy_soft_reset(phydev);
 	if (ret)
 		return ret;
-- 
2.24.1

