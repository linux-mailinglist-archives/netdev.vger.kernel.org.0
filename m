Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F73C99AE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 10:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfJCIVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 04:21:23 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54201 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfJCIVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 04:21:23 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFwMR-00031C-PP; Thu, 03 Oct 2019 10:21:19 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFwMO-0003f2-6w; Thu, 03 Oct 2019 10:21:16 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] net: phy: at803x: remove probe and struct at803x_priv
Date:   Thu,  3 Oct 2019 10:21:13 +0200
Message-Id: <20191003082113.13993-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003082113.13993-1-o.rempel@pengutronix.de>
References: <20191003082113.13993-1-o.rempel@pengutronix.de>
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

struct at803x_priv is never used in this driver. So remove it
and the probe function allocating it.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/at803x.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 8fb7abdf10d0..463fc681dead 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -63,10 +63,6 @@ MODULE_DESCRIPTION("Atheros 803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
-struct at803x_priv {
-	bool phy_reset:1;
-};
-
 struct at803x_context {
 	u16 bmcr;
 	u16 advertise;
@@ -232,20 +228,6 @@ static int at803x_resume(struct phy_device *phydev)
 	return phy_modify(phydev, MII_BMCR, BMCR_PDOWN | BMCR_ISOLATE, 0);
 }
 
-static int at803x_probe(struct phy_device *phydev)
-{
-	struct device *dev = &phydev->mdio.dev;
-	struct at803x_priv *priv;
-
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	phydev->priv = priv;
-
-	return 0;
-}
-
 static int at803x_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -368,7 +350,6 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id			= ATH8035_PHY_ID,
 	.name			= "Atheros 8035 ethernet",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
-	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
@@ -382,7 +363,6 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id			= ATH8030_PHY_ID,
 	.name			= "Atheros 8030 ethernet",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
-	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
 	.set_wol		= at803x_set_wol,
@@ -397,7 +377,6 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id			= ATH8031_PHY_ID,
 	.name			= "Atheros 8031 ethernet",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
-	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
-- 
2.23.0

