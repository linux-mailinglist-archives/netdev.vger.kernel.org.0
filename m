Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F47C1BB823
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgD1HxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgD1HxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:53:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B32C03C1A9
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 00:53:20 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jTL3I-000289-0X; Tue, 28 Apr 2020 09:53:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jTL3G-0000xR-7J; Tue, 28 Apr 2020 09:53:10 +0200
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
Subject: [PATCH net-next v3 2/2] net: phy: tja11xx: add support for master-slave configuration
Date:   Tue, 28 Apr 2020 09:53:08 +0200
Message-Id: <20200428075308.2938-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428075308.2938-1-o.rempel@pengutronix.de>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
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
 drivers/net/phy/nxp-tja11xx.c | 58 ++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index cc766b2d4136e..c316d22ea7530 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -30,6 +30,7 @@
 #define MII_ECTRL_WAKE_REQUEST		BIT(0)
 
 #define MII_CFG1			18
+#define MII_CFG1_MASTER_SLAVE		BIT(15)
 #define MII_CFG1_AUTO_OP		BIT(14)
 #define MII_CFG1_SLEEP_CONFIRM		BIT(6)
 #define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
@@ -167,6 +168,33 @@ static int tja11xx_soft_reset(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int tja11xx_config_aneg(struct phy_device *phydev)
+{
+	u16 ctl = 0;
+	int ret;
+
+	switch (phydev->master_slave_set) {
+	case PORT_MODE_CFG_MASTER_FORCE:
+	case PORT_MODE_CFG_MASTER_PREFERRED:
+		ctl |= MII_CFG1_MASTER_SLAVE;
+		break;
+	case PORT_MODE_CFG_SLAVE_FORCE:
+	case PORT_MODE_CFG_SLAVE_PREFERRED:
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
@@ -222,12 +250,24 @@ static int tja11xx_config_init(struct phy_device *phydev)
 
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
+	if (cfg1 & MII_CFG1_MASTER_SLAVE)
+		cfg = PORT_MODE_CFG_MASTER_FORCE;
+	else
+		cfg = PORT_MODE_CFG_SLAVE_FORCE;
+
 	if (phydev->link) {
 		ret = phy_read(phydev, MII_COMMSTAT);
 		if (ret < 0)
@@ -235,8 +275,20 @@ static int tja11xx_read_status(struct phy_device *phydev)
 
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
 
+	phydev->master_slave_get = cfg;
+	phydev->master_slave_state = state;
+
 	return 0;
 }
 
@@ -504,6 +556,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -519,6 +572,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -533,6 +587,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja1102_p0_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p0_match_phy_device,
@@ -551,6 +606,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		/* currently no probe for Port 1 is need */
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p1_match_phy_device,
-- 
2.26.2

