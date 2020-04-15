Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85521AA13B
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369798AbgDOMfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S369795AbgDOMe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 08:34:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCA7C061A0E
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 05:34:59 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jOhFj-0001s4-DF; Wed, 15 Apr 2020 14:34:51 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jOhFi-00082N-He; Wed, 15 Apr 2020 14:34:50 +0200
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
        Marek Vasut <marex@denx.de>
Subject: [PATCH v1] net: phy: tja11xx: add support for master-slave configuration
Date:   Wed, 15 Apr 2020 14:34:47 +0200
Message-Id: <20200415123447.29769-1-o.rempel@pengutronix.de>
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

The TJA11xx PHYs have a vendor specific Master/Slave configuration bit,
which is not compatible with IEEE 803.2-2018 spec for 100Base-T1
devices. So, provide a custom config_ange call back to solve this
problem.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 2bde9386baf1f..0042ee453cbd4 100644
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
+	switch (phydev->master_slave) {
+	case PORT_MODE_MASTER:
+		ctl |= MII_CFG1_MASTER_SLAVE;
+		break;
+	case PORT_MODE_SLAVE:
+		break;
+	case PORT_MODE_UNKNOWN:
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
@@ -245,6 +271,15 @@ static int tja11xx_read_status(struct phy_device *phydev)
 
 		if (!(ret & MII_COMMSTAT_LINK_UP))
 			phydev->link = 0;
+
+		ret = phy_read(phydev, MII_CFG1);
+		if (ret < 0)
+			return ret;
+
+		if (ret & MII_CFG1_MASTER_SLAVE)
+			phydev->master_slave = PORT_MODE_MASTER;
+		else
+			phydev->master_slave = PORT_MODE_SLAVE;
 	}
 
 	return 0;
@@ -514,6 +549,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -529,6 +565,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -543,6 +580,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja1102_p0_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p0_match_phy_device,
@@ -561,6 +599,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		/* currently no probe for Port 1 is need */
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p1_match_phy_device,
-- 
2.26.0.rc2

