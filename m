Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24961C335E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 09:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgEDHMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 03:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727944AbgEDHM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 03:12:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44AC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 00:12:28 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVVH2-0001Ta-0P; Mon, 04 May 2020 09:12:20 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVVGx-0001YL-Tn; Mon, 04 May 2020 09:12:15 +0200
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
Subject: [PATCH v5 2/2] net: phy: tja11xx: add support for master-slave configuration
Date:   Mon,  4 May 2020 09:12:14 +0200
Message-Id: <20200504071214.5890-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504071214.5890-1-o.rempel@pengutronix.de>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
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
 drivers/net/phy/nxp-tja11xx.c | 43 +++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index cc766b2d4136e..ca5f9d4dc57ed 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -30,6 +30,7 @@
 #define MII_ECTRL_WAKE_REQUEST		BIT(0)
 
 #define MII_CFG1			18
+#define MII_CFG1_MASTER_SLAVE		BIT(15)
 #define MII_CFG1_AUTO_OP		BIT(14)
 #define MII_CFG1_SLEEP_CONFIRM		BIT(6)
 #define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
@@ -167,6 +168,32 @@ static int tja11xx_soft_reset(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int tja11xx_config_aneg(struct phy_device *phydev)
+{
+	u16 ctl = 0;
+	int ret;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		ctl |= MII_CFG1_MASTER_SLAVE;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		break;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
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
@@ -224,10 +251,22 @@ static int tja11xx_read_status(struct phy_device *phydev)
 {
 	int ret;
 
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNSUPPORTED;
+
 	ret = genphy_update_link(phydev);
 	if (ret)
 		return ret;
 
+	ret = phy_read(phydev, MII_CFG1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MII_CFG1_MASTER_SLAVE)
+		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+	else
+		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+
 	if (phydev->link) {
 		ret = phy_read(phydev, MII_COMMSTAT);
 		if (ret < 0)
@@ -504,6 +543,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -519,6 +559,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja11xx_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.suspend	= genphy_suspend,
@@ -533,6 +574,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		.probe		= tja1102_p0_probe,
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p0_match_phy_device,
@@ -551,6 +593,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 		/* currently no probe for Port 1 is need */
 		.soft_reset	= tja11xx_soft_reset,
+		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
 		.match_phy_device = tja1102_p1_match_phy_device,
-- 
2.26.2

