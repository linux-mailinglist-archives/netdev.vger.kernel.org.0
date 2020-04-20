Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352591B0C64
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgDTNPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727069AbgDTNPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:15:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9060C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:15:30 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQWGh-00034S-Qe; Mon, 20 Apr 2020 15:15:23 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQWGh-0007UD-Da; Mon, 20 Apr 2020 15:15:23 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH v2 2/2] net: phy: tja11xx: add support for master-slave configuration
Date:   Mon, 20 Apr 2020 15:15:07 +0200
Message-Id: <20200420131508.1539-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420131508.1539-1-o.rempel@pengutronix.de>
References: <20200420131508.1539-1-o.rempel@pengutronix.de>
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

The TJA11xx PHYs have a vendor specific Master/Slave configuration bit,
which is not compatible with IEEE 803.2-2018 spec for 100Base-T1
devices. So, provide a custom config_ange call back to solve this
problem.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 56 ++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 2bde9386baf1f..eb2c3be19456e 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -30,6 +30,7 @@
 #define MII_ECTRL_WAKE_REQUEST		BIT(0)
 
 #define MII_CFG1			18
+#define MII_CFG1_MASTER_SLAVE		BIT(15)
 #define MII_CFG1_AUTO_OP		BIT(14)
 #define MII_CFG1_SLEEP_CONFIRM		BIT(6)
 #define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
@@ -177,6 +178,31 @@ static int tja11xx_soft_reset(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int tja11xx_config_aneg(struct phy_device *phydev)
+{
+	u16 ctl = 0;
+	int ret;
+
+	switch (FIELD_GET(PORT_MODE_CFG_MASK, phydev->master_slave_set)) {
+	case PORT_MODE_CFG_MASTER_FORCE:
+		ctl |= MII_CFG1_MASTER_SLAVE;
+		break;
+	case PORT_MODE_CFG_SLAVE_FORCE:
+		break;
+	case PORT_MODE_CFG_UNKNOWN:
+		return 0;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -ENOTSUPP;
+	}
+
+	ret = phy_modify_changed(phydev, MII_CFG1, MII_CFG1_MASTER_SLAVE, ctl);
+	if (ret < 0)
+		return ret;
+
+	return __genphy_config_aneg(phydev, ret);
+}
+
 static int tja11xx_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -232,12 +258,24 @@ static int tja11xx_config_init(struct phy_device *phydev)
 
 static int tja11xx_read_status(struct phy_device *phydev)
 {
-	int ret;
+	int cfg, state = 0;
+	int ret, cfg1;
+
+	phydev->master_slave_get = 0;
 
 	ret = genphy_update_link(phydev);
 	if (ret)
 		return ret;
 
+	cfg1 = phy_read(phydev, MII_CFG1);
+	if (cfg1 < 0)
+		return cfg1;
+
+	if (ret & MII_CFG1_MASTER_SLAVE)
+		cfg = PORT_MODE_CFG_MASTER_FORCE;
+	else
+		cfg = PORT_MODE_CFG_SLAVE_FORCE;
+
 	if (phydev->link) {
 		ret = phy_read(phydev, MII_COMMSTAT);
 		if (ret < 0)
@@ -245,8 +283,20 @@ static int tja11xx_read_status(struct phy_device *phydev)
 
 		if (!(ret & MII_COMMSTAT_LINK_UP))
 			phydev->link = 0;
+
+		ret = phy_read(phydev, MII_CFG1);
+		if (ret < 0)
+			return ret;
+
+		if (cfg1 & MII_CFG1_MASTER_SLAVE)
+			state = PORT_MODE_STATE_MASTER;
+		else
+			state = PORT_MODE_STATE_SLAVE;
 	}
 
+	phydev->master_slave_get = FIELD_PREP(PORT_MODE_CFG_MASK, cfg) |
+		FIELD_PREP(PORT_MODE_STATE_MASK, state);
+
 	return 0;
 }
 
@@ -514,6 +564,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -529,6 +580,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -543,6 +595,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja1102_p0_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p0_match_phy_device,
@@ -561,6 +614,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		/* currently no probe for Port 1 is need */
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p1_match_phy_device,
-- 
2.26.1

