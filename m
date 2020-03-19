Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712B118B942
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgCSOUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:20:14 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44679 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727613AbgCSOUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:20:12 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id DF21B60015;
        Thu, 19 Mar 2020 14:20:08 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/2] net: phy: mscc: add support for RGMII MAC mode
Date:   Thu, 19 Mar 2020 15:19:57 +0100
Message-Id: <20200319141958.383626-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200319141958.383626-1-antoine.tenart@bootlin.com>
References: <20200319141958.383626-1-antoine.tenart@bootlin.com>
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
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 32 ++++++++++++++++++++------------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 29ccb2c9c095..d1b8bbe8acca 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -241,6 +241,7 @@ enum rgmii_rx_clock_delay {
 #define MAC_CFG_MASK			  0xc000
 #define MAC_CFG_SGMII			  0x0000
 #define MAC_CFG_QSGMII			  0x4000
+#define MAC_CFG_RGMII			  0x8000
 
 /* Test page Registers */
 #define MSCC_PHY_TEST_PAGE_5		  5
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index bc6beec8aff0..86bb5c3c911a 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1360,27 +1360,35 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
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
+			PROC_CMD_READ_MOD_WRITE_PORT;
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
2.25.1

