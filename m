Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B174A18B943
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCSOUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:20:12 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40537 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgCSOUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:20:11 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 60978E001D;
        Thu, 19 Mar 2020 14:20:05 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 2/2] net: phy: mscc: RGMII skew delay configuration
Date:   Thu, 19 Mar 2020 15:19:58 +0100
Message-Id: <20200319141958.383626-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200319141958.383626-1-antoine.tenart@bootlin.com>
References: <20200319141958.383626-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for configuring the RGMII skew delays in Rx and
Tx. The Rx and Tx skews are set based on the interface mode. By default
their configuration is set to the default value in hardware (0.2ns);
this means the driver do not rely anymore on the bootloader
configuration.

Then based on the interface mode being used, a 2ns delay is added:
- RGMII_ID adds it for both Rx and Tx.
- RGMII_RXID adds it for Rx.
- RGMII_TXID adds it for Tx.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc.h      | 14 ++++++++++++++
 drivers/net/phy/mscc/mscc_main.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index d1b8bbe8acca..25729302714c 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -161,6 +161,20 @@ enum rgmii_rx_clock_delay {
 /* Extended Page 2 Registers */
 #define MSCC_PHY_CU_PMD_TX_CNTL		  16
 
+#define MSCC_PHY_RGMII_SETTINGS		  18
+#define RGMII_SKEW_RX_POS		  1
+#define RGMII_SKEW_TX_POS		  4
+
+/* RGMII skew values, in ns */
+#define VSC8584_RGMII_SKEW_0_2		  0
+#define VSC8584_RGMII_SKEW_0_8		  1
+#define VSC8584_RGMII_SKEW_1_1		  2
+#define VSC8584_RGMII_SKEW_1_7		  3
+#define VSC8584_RGMII_SKEW_2_0		  4
+#define VSC8584_RGMII_SKEW_2_3		  5
+#define VSC8584_RGMII_SKEW_2_6		  6
+#define VSC8584_RGMII_SKEW_3_4		  7
+
 #define MSCC_PHY_RGMII_CNTL		  20
 #define RGMII_RX_CLK_DELAY_MASK		  0x0070
 #define RGMII_RX_CLK_DELAY_POS		  4
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 86bb5c3c911a..5d78732de702 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1288,6 +1288,32 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 	return false;
 }
 
+static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
+{
+	u32 skew_rx, skew_tx;
+
+	/* We first set the Rx and Tx skews to their default value in h/w
+	 * (0.2 ns).
+	 */
+	skew_rx = VSC8584_RGMII_SKEW_0_2;
+	skew_tx = VSC8584_RGMII_SKEW_0_2;
+
+	/* We then set the skews based on the interface mode. */
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+		skew_rx = VSC8584_RGMII_SKEW_2_0;
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+		skew_tx = VSC8584_RGMII_SKEW_2_0;
+
+	/* Finally we apply the skews configuration. */
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
@@ -1422,6 +1448,9 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	if (phy_interface_is_rgmii(phydev))
+		vsc8584_rgmii_set_skews(phydev);
+
 	ret = genphy_soft_reset(phydev);
 	if (ret)
 		return ret;
-- 
2.25.1

