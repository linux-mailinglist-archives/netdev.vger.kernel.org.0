Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0D17224B
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgB0PaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:30:18 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39053 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgB0PaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:30:18 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id E0AB61C000F;
        Thu, 27 Feb 2020 15:30:15 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: [PATCH net-next 3/3] net: phy: mscc: implement RGMII skew delay configuration
Date:   Thu, 27 Feb 2020 16:28:59 +0100
Message-Id: <20200227152859.1687119-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
References: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for configuring the RGMII skews in Rx and Tx
thanks to properties defined in the device tree.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index ecb45c43e5ed..56d6a45a90c2 100644
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
@@ -2682,6 +2686,7 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 
 static int vsc8584_config_init(struct phy_device *phydev)
 {
+	u32 skew_rx = VSC8584_RGMII_SKEW_0_2, skew_tx = VSC8584_RGMII_SKEW_0_2;
 	struct vsc8531_private *vsc8531 = phydev->priv;
 	u16 addr, val;
 	int ret, i;
@@ -2830,6 +2835,19 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	if (of_find_property(dev->of_node, "vsc8584,rgmii-skew-rx", NULL) ||
+	    of_find_property(dev->of_node, "vsc8584,rgmii-skew-tx", NULL)) {
+		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-rx", &skew_rx);
+		of_property_read_u32(dev->of_node, "vsc8584,rgmii-skew-tx", &skew_tx);
+
+		phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
+				 MSCC_PHY_RGMII_SETTINGS,
+				 (0x7 << RGMII_SKEW_RX_POS) |
+				 (0x7 << RGMII_SKEW_TX_POS),
+				 (skew_rx << RGMII_SKEW_RX_POS) |
+				 (skew_tx << RGMII_SKEW_TX_POS));
+	}
+
 	for (i = 0; i < vsc8531->nleds; i++) {
 		ret = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i]);
 		if (ret)
-- 
2.24.1

