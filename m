Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956D31252B9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfLRUIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:08:41 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34495 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfLRUIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:08:40 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcc-0004WR-M3; Wed, 18 Dec 2019 21:08:38 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcb-0004bU-6a; Wed, 18 Dec 2019 21:08:37 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v2 1/4] micrel: fix config_aneg for ksz886x
Date:   Wed, 18 Dec 2019 21:08:28 +0100
Message-Id: <20191218200831.13796-2-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
References: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The third port of the ksz886x is fixed to be connected to the
cpu. This port has no possibility to do auto negotiation.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/phy/micrel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 63dedec0433de..913a8b68da350 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -841,6 +841,16 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz886x_config_aneg(struct phy_device *phydev)
+{
+	if (phydev->mdio.addr == 3) {
+		phydev->autoneg = AUTONEG_DISABLE;
+		genphy_read_status(phydev);
+	}
+
+	return genphy_config_aneg(phydev);
+}
+
 static int kszphy_get_sset_count(struct phy_device *phydev)
 {
 	return ARRAY_SIZE(kszphy_hw_stats);
@@ -1171,6 +1181,7 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ886X Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
+	.config_aneg	= ksz886x_config_aneg,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-- 
2.24.0

