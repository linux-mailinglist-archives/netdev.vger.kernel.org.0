Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E2173C53
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgB1P5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 10:57:14 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45645 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbgB1P5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 10:57:14 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id F39891C0011;
        Fri, 28 Feb 2020 15:57:11 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: [PATCH net-next v2 1/3] net: phy: mscc: add support for RGMII MAC mode
Date:   Fri, 28 Feb 2020 16:57:00 +0100
Message-Id: <20200228155702.2062570-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for connecting VSC8584 PHYs to the MAC using
RGMII.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index d24577de0775..c389d7e59f91 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -272,6 +272,7 @@ enum macsec_bank {
 #define MAC_CFG_MASK			  0xc000
 #define MAC_CFG_SGMII			  0x0000
 #define MAC_CFG_QSGMII			  0x4000
+#define MAC_CFG_RGMII			  0x8000
 
 /* Test page Registers */
 #define MSCC_PHY_TEST_PAGE_5		  5
@@ -2751,27 +2752,35 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
 	val &= ~MAC_CFG_MASK;
-	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII)
+	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII) {
 		val |= MAC_CFG_QSGMII;
-	else
+	} else if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
 		val |= MAC_CFG_SGMII;
+	} else if (phy_interface_is_rgmii(phydev)) {
+		val |= MAC_CFG_RGMII;
+	} else {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
 	if (ret)
 		goto err;
 
-	val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
-		PROC_CMD_READ_MOD_WRITE_PORT;
-	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII)
-		val |= PROC_CMD_QSGMII_MAC;
-	else
-		val |= PROC_CMD_SGMII_MAC;
+	if (!phy_interface_is_rgmii(phydev)) {
+		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
+		      PROC_CMD_READ_MOD_WRITE_PORT;
+		if (phydev->interface == PHY_INTERFACE_MODE_QSGMII)
+			val |= PROC_CMD_QSGMII_MAC;
+		else
+			val |= PROC_CMD_SGMII_MAC;
 
-	ret = vsc8584_cmd(phydev, val);
-	if (ret)
-		goto err;
+		ret = vsc8584_cmd(phydev, val);
+		if (ret)
+			goto err;
 
-	usleep_range(10000, 20000);
+		usleep_range(10000, 20000);
+	}
 
 	/* Disable SerDes for 100Base-FX */
 	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
-- 
2.24.1

