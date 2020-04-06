Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6F119F187
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 10:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDFIZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 04:25:55 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50577 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgDFIZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 04:25:55 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jLN4o-0007J7-Ta; Mon, 06 Apr 2020 10:25:50 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jLN4j-0007px-FF; Mon, 06 Apr 2020 10:25:45 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v2] net: phy: micrel: add phy-mode support for the KSZ9031 PHY
Date:   Mon,  6 Apr 2020 10:25:44 +0200
Message-Id: <20200406082544.28924-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid, rgmii-rxid.

This PHY has an internal RX delay of 1.2ns and no delay for TX.

The pad skew registers allow to set the total TX delay to max 1.38ns and
the total RX delay to max of 2.58ns (configurable 1.38ns + build in
1.2ns) and a minimal delay of 0ns.

According to the RGMII v2 specification the delay provided by PCB traces
should be between 1.5ns and 2.0ns. As this PHY can provide max delay of
only 1.38ns on the TX line, in RGMII-ID mode a symmetric delay of 1.38ns
for both the RX and TX lines is chosen, even if the RX line could be
configured with the 1.5ns according to the standard.

The phy-modes can still be fine tuned/overwritten by *-skew-ps
device tree properties described in:
Documentation/devicetree/bindings/net/micrel-ksz90x1.txt

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v2:
- change RX_ID value from 0x1a to 0xa. The overflow bit was detected by
  FIELD_PREP() build check.
  Reported-by: kbuild test robot <lkp@intel.com>

 drivers/net/phy/micrel.c | 109 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 05d20343b8161..8b5907a9a4c0f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -19,6 +19,7 @@
  *			 ksz9477
  */
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
@@ -490,9 +491,50 @@ static int ksz9021_config_init(struct phy_device *phydev)
 
 /* MMD Address 0x2 */
 #define MII_KSZ9031RN_CONTROL_PAD_SKEW	4
+#define MII_KSZ9031RN_RX_CTL_M		GENMASK(7, 4)
+#define MII_KSZ9031RN_TX_CTL_M		GENMASK(3, 0)
+
 #define MII_KSZ9031RN_RX_DATA_PAD_SKEW	5
+#define MII_KSZ9031RN_RXD3		GENMASK(15, 12)
+#define MII_KSZ9031RN_RXD2		GENMASK(11, 8)
+#define MII_KSZ9031RN_RXD1		GENMASK(7, 4)
+#define MII_KSZ9031RN_RXD0		GENMASK(3, 0)
+
 #define MII_KSZ9031RN_TX_DATA_PAD_SKEW	6
+#define MII_KSZ9031RN_TXD3		GENMASK(15, 12)
+#define MII_KSZ9031RN_TXD2		GENMASK(11, 8)
+#define MII_KSZ9031RN_TXD1		GENMASK(7, 4)
+#define MII_KSZ9031RN_TXD0		GENMASK(3, 0)
+
 #define MII_KSZ9031RN_CLK_PAD_SKEW	8
+#define MII_KSZ9031RN_GTX_CLK		GENMASK(9, 5)
+#define MII_KSZ9031RN_RX_CLK		GENMASK(4, 0)
+
+/* KSZ9031 has internal RGMII_IDRX = 1.2ns and RGMII_IDTX = 0ns. To
+ * provide different RGMII options we need to configure delay offset
+ * for each pad relative to build in delay.
+ */
+/* set rx to +0.18ns and rx_clk to "No delay adjustment" value to get delays of
+ * 1.38ns
+ */
+#define RX_ID				0xa
+#define RX_CLK_ID			0xf
+
+/* set rx to +0.30ns and rx_clk to -0.90ns to compensate the
+ * internal 1.2ns delay.
+ */
+#define RX_ND				0xc
+#define RX_CLK_ND			0x0
+
+/* set tx to -0.42ns and tx_clk to +0.96ns to get 1.38ns delay */
+#define TX_ID				0x0
+#define TX_CLK_ID			0x1f
+
+/* set tx and tx_clk to "No delay adjustment" to keep 0ns
+ * dealy
+ */
+#define TX_ND				0x7
+#define TX_CLK_ND			0xf
 
 /* MMD Address 0x1C */
 #define MII_KSZ9031RN_EDPD		0x23
@@ -565,6 +607,67 @@ static int ksz9031_enable_edpd(struct phy_device *phydev)
 			     reg | MII_KSZ9031RN_EDPD_ENABLE);
 }
 
+static int ksz9031_config_rgmii_delay(struct phy_device *phydev)
+{
+	u16 rx, tx, rx_clk, tx_clk;
+	int ret;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		tx = TX_ND;
+		tx_clk = TX_CLK_ND;
+		rx = RX_ND;
+		rx_clk = RX_CLK_ND;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		tx = TX_ID;
+		tx_clk = TX_CLK_ID;
+		rx = RX_ID;
+		rx_clk = RX_CLK_ID;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		tx = TX_ND;
+		tx_clk = TX_CLK_ND;
+		rx = RX_ID;
+		rx_clk = RX_CLK_ID;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		tx = TX_ID;
+		tx_clk = TX_CLK_ID;
+		rx = RX_ND;
+		rx_clk = RX_CLK_ND;
+		break;
+	default:
+		return 0;
+	}
+
+	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_CONTROL_PAD_SKEW,
+			    FIELD_PREP(MII_KSZ9031RN_RX_CTL_M, rx) |
+			    FIELD_PREP(MII_KSZ9031RN_TX_CTL_M, tx));
+	if (ret < 0)
+		return ret;
+
+	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_RX_DATA_PAD_SKEW,
+			    FIELD_PREP(MII_KSZ9031RN_RXD3, rx) |
+			    FIELD_PREP(MII_KSZ9031RN_RXD2, rx) |
+			    FIELD_PREP(MII_KSZ9031RN_RXD1, rx) |
+			    FIELD_PREP(MII_KSZ9031RN_RXD0, rx));
+	if (ret < 0)
+		return ret;
+
+	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_TX_DATA_PAD_SKEW,
+			    FIELD_PREP(MII_KSZ9031RN_TXD3, tx) |
+			    FIELD_PREP(MII_KSZ9031RN_TXD2, tx) |
+			    FIELD_PREP(MII_KSZ9031RN_TXD1, tx) |
+			    FIELD_PREP(MII_KSZ9031RN_TXD0, tx));
+	if (ret < 0)
+		return ret;
+
+	return phy_write_mmd(phydev, 2, MII_KSZ9031RN_CLK_PAD_SKEW,
+			     FIELD_PREP(MII_KSZ9031RN_GTX_CLK, tx_clk) |
+			     FIELD_PREP(MII_KSZ9031RN_RX_CLK, rx_clk));
+}
+
 static int ksz9031_config_init(struct phy_device *phydev)
 {
 	const struct device *dev = &phydev->mdio.dev;
@@ -597,6 +700,12 @@ static int ksz9031_config_init(struct phy_device *phydev)
 	} while (!of_node && dev_walker);
 
 	if (of_node) {
+		if (phy_interface_is_rgmii(phydev)) {
+			result = ksz9031_config_rgmii_delay(phydev);
+			if (result < 0)
+				return result;
+		}
+
 		ksz9031_of_load_skew_values(phydev, of_node,
 				MII_KSZ9031RN_CLK_PAD_SKEW, 5,
 				clk_skews, 2);
-- 
2.26.0.rc2

