Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CF81D9763
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgESNO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729023AbgESNOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:14:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE6FC08C5C1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:14:49 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jb24v-0007Jy-Kj; Tue, 19 May 2020 15:14:41 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jb24p-00017J-VI; Tue, 19 May 2020 15:14:35 +0200
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
Subject: [PATCH net-next v2 2/2] net: phy: tja11xx: add SQI support
Date:   Tue, 19 May 2020 15:14:33 +0200
Message-Id: <20200519131433.4224-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519131433.4224-1-o.rempel@pengutronix.de>
References: <20200519131433.4224-1-o.rempel@pengutronix.de>
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

This patch implements reading of the Signal Quality Index for better
cable/link troubleshooting.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 0d4f9067ca715..1e79c30ca81a5 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -53,6 +53,8 @@
 
 #define MII_COMMSTAT			23
 #define MII_COMMSTAT_LINK_UP		BIT(15)
+#define MII_COMMSTAT_SQI_STATE		GENMASK(7, 5)
+#define MII_COMMSTAT_SQI_MAX		7
 
 #define MII_GENSTAT			24
 #define MII_GENSTAT_PLL_LOCKED		BIT(14)
@@ -329,6 +331,22 @@ static int tja11xx_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int tja11xx_get_sqi(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, MII_COMMSTAT);
+	if (ret < 0)
+		return ret;
+
+	return FIELD_GET(MII_COMMSTAT_SQI_STATE, ret);
+}
+
+static int tja11xx_get_sqi_max(struct phy_device *phydev)
+{
+	return MII_COMMSTAT_SQI_MAX;
+}
+
 static int tja11xx_get_sset_count(struct phy_device *phydev)
 {
 	return ARRAY_SIZE(tja11xx_hw_stats);
@@ -683,6 +701,8 @@ static struct phy_driver tja11xx_driver[] = {
 		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
+		.get_sqi	= tja11xx_get_sqi,
+		.get_sqi_max	= tja11xx_get_sqi_max,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.set_loopback   = genphy_loopback,
@@ -699,6 +719,8 @@ static struct phy_driver tja11xx_driver[] = {
 		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
+		.get_sqi	= tja11xx_get_sqi,
+		.get_sqi_max	= tja11xx_get_sqi_max,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.set_loopback   = genphy_loopback,
@@ -715,6 +737,8 @@ static struct phy_driver tja11xx_driver[] = {
 		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
+		.get_sqi	= tja11xx_get_sqi,
+		.get_sqi_max	= tja11xx_get_sqi_max,
 		.match_phy_device = tja1102_p0_match_phy_device,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
@@ -736,6 +760,8 @@ static struct phy_driver tja11xx_driver[] = {
 		.config_aneg	= tja11xx_config_aneg,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
+		.get_sqi	= tja11xx_get_sqi,
+		.get_sqi_max	= tja11xx_get_sqi_max,
 		.match_phy_device = tja1102_p1_match_phy_device,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
-- 
2.26.2

