Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD40170178
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 15:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBZOpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 09:45:10 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53595 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgBZOpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 09:45:09 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6D1186000A;
        Wed, 26 Feb 2020 14:45:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: [PATCH net-next] net: phy: mscc: add missing shift for media operation mode selection
Date:   Wed, 26 Feb 2020 15:40:34 +0100
Message-Id: <20200226144034.1519658-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a missing shift for the media operation mode selection.
This does not fix the driver as the current operation mode (copper) has
a value of 0, but this wouldn't work for other modes.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 937ac7da2789..880425466bc8 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -2813,8 +2813,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	val = phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_1);
 	val &= ~(MEDIA_OP_MODE_MASK | VSC8584_MAC_IF_SELECTION_MASK);
-	val |= MEDIA_OP_MODE_COPPER | (VSC8584_MAC_IF_SELECTION_SGMII <<
-				       VSC8584_MAC_IF_SELECTION_POS);
+	val |= (MEDIA_OP_MODE_COPPER << MEDIA_OP_MODE_POS) |
+	       (VSC8584_MAC_IF_SELECTION_SGMII << VSC8584_MAC_IF_SELECTION_POS);
 	ret = phy_write(phydev, MSCC_PHY_EXT_PHY_CNTL_1, val);
 
 	ret = genphy_soft_reset(phydev);
@@ -3276,7 +3276,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		return ret;
 
 	ret = phy_modify(phydev, MSCC_PHY_EXT_PHY_CNTL_1, MEDIA_OP_MODE_MASK,
-			 MEDIA_OP_MODE_COPPER);
+			 MEDIA_OP_MODE_COPPER << MEDIA_OP_MODE_POS);
 
 	if (ret)
 		return ret;
-- 
2.24.1

