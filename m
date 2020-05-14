Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021AD1D3DC2
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgENTm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727118AbgENTm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:42:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95225C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 12:42:25 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jZJkL-0008Kr-Ok; Thu, 14 May 2020 21:42:21 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jZJkJ-0005js-Cc; Thu, 14 May 2020 21:42:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
Subject: [PATCH net-next v1] net: phy: tja11xx: execute cable test on link up
Date:   Thu, 14 May 2020 21:42:18 +0200
Message-Id: <20200514194218.22011-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
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

A typical 100Base-T1 link should be always connected. If the link is in
a shot or open state, it is a failure. In most cases, we won't be able
to automatically handle this issue, but we need to log it or notify user
(if possible).

With this patch, the cable will be tested on "ip l s dev .. up" attempt
and send ethnl notification to the user space.

This patch was tested with TJA1102 PHY and "ethtool --monitor" command.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 48 +++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 8b743d25002b9..0d4f9067ca715 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -180,10 +180,43 @@ static int tja11xx_soft_reset(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int tja11xx_config_aneg_cable_test(struct phy_device *phydev)
+{
+	bool finished = false;
+	int ret;
+
+	if (phydev->link)
+		return 0;
+
+	if (!phydev->drv->cable_test_start ||
+	    !phydev->drv->cable_test_get_status)
+		return 0;
+
+	ret = ethnl_cable_test_alloc(phydev);
+	if (ret)
+		return ret;
+
+	ret = phydev->drv->cable_test_start(phydev);
+	if (ret)
+		return ret;
+
+	/* According to the documentation this test takes 100 usec */
+	usleep_range(100, 200);
+
+	ret = phydev->drv->cable_test_get_status(phydev, &finished);
+	if (ret)
+		return ret;
+
+	if (finished)
+		ethnl_cable_test_finished(phydev);
+
+	return 0;
+}
+
 static int tja11xx_config_aneg(struct phy_device *phydev)
 {
+	int ret, changed = 0;
 	u16 ctl = 0;
-	int ret;
 
 	switch (phydev->master_slave_set) {
 	case MASTER_SLAVE_CFG_MASTER_FORCE:
@@ -193,17 +226,22 @@ static int tja11xx_config_aneg(struct phy_device *phydev)
 		break;
 	case MASTER_SLAVE_CFG_UNKNOWN:
 	case MASTER_SLAVE_CFG_UNSUPPORTED:
-		return 0;
+		goto do_test;
 	default:
 		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
 		return -ENOTSUPP;
 	}
 
-	ret = phy_modify_changed(phydev, MII_CFG1, MII_CFG1_MASTER_SLAVE, ctl);
-	if (ret < 0)
+	changed = phy_modify_changed(phydev, MII_CFG1, MII_CFG1_MASTER_SLAVE, ctl);
+	if (changed < 0)
+		return changed;
+
+do_test:
+	ret = tja11xx_config_aneg_cable_test(phydev);
+	if (ret)
 		return ret;
 
-	return __genphy_config_aneg(phydev, ret);
+	return __genphy_config_aneg(phydev, changed);
 }
 
 static int tja11xx_config_init(struct phy_device *phydev)
-- 
2.26.2

