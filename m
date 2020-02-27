Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7760B172267
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgB0PlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:41:17 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:53685 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbgB0PlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:41:16 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 5E1FEFF814;
        Thu, 27 Feb 2020 15:41:13 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phy: mscc: support LOS being active low
Date:   Thu, 27 Feb 2020 16:40:33 +0100
Message-Id: <20200227154033.1688498-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
References: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for describing the LOS pin as being active low
when using MSCC PHYs.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 56d6a45a90c2..3755919b03e8 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -172,6 +172,7 @@ enum macsec_bank {
 #define VALID_CRC_CNT_CRC_MASK		  GENMASK(13, 0)
 
 #define MSCC_PHY_EXT_MODE_CNTL		  19
+#define SIGDET_ACTIVE_LOW		  BIT(0)
 #define FORCE_MDI_CROSSOVER_MASK	  0x000C
 #define FORCE_MDI_CROSSOVER_MDIX	  0x000C
 #define FORCE_MDI_CROSSOVER_MDI		  0x0008
@@ -2688,6 +2689,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 {
 	u32 skew_rx = VSC8584_RGMII_SKEW_0_2, skew_tx = VSC8584_RGMII_SKEW_0_2;
 	struct vsc8531_private *vsc8531 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
 	u16 addr, val;
 	int ret, i;
 
@@ -2831,6 +2833,11 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	       (VSC8584_MAC_IF_SELECTION_SGMII << VSC8584_MAC_IF_SELECTION_POS);
 	ret = phy_write(phydev, MSCC_PHY_EXT_PHY_CNTL_1, val);
 
+	if (of_property_read_bool(dev->of_node, "vsc8584,los-active-low"))
+		phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED,
+				 MSCC_PHY_EXT_MODE_CNTL, SIGDET_ACTIVE_LOW,
+				 SIGDET_ACTIVE_LOW);
+
 	ret = genphy_soft_reset(phydev);
 	if (ret)
 		return ret;
-- 
2.24.1

