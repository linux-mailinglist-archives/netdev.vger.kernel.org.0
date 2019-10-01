Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B89DC2D15
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 08:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbfJAGIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 02:08:17 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37057 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfJAGIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 02:08:17 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBKY-0005n4-S4; Tue, 01 Oct 2019 08:08:14 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBKW-0006Ne-R5; Tue, 01 Oct 2019 08:08:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] net: phy: at803x: remove probe and struct at803x_priv
Date:   Tue,  1 Oct 2019 08:08:11 +0200
Message-Id: <20191001060811.24291-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191001060811.24291-1-o.rempel@pengutronix.de>
References: <20191001060811.24291-1-o.rempel@pengutronix.de>
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
---
 drivers/net/phy/at803x.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 42492f83c8d7..e64f77e152f4 100644
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
@@ -367,7 +349,6 @@ static struct phy_driver at803x_driver[] = {
 	/* ATHEROS 8035 */
 	PHY_ID_MATCH_EXACT(ATH8035_PHY_ID),
 	.name			= "Atheros 8035 ethernet",
-	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
@@ -380,7 +361,6 @@ static struct phy_driver at803x_driver[] = {
 	/* ATHEROS 8030 */
 	PHY_ID_MATCH_EXACT(ATH8030_PHY_ID),
 	.name			= "Atheros 8030 ethernet",
-	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
 	.set_wol		= at803x_set_wol,
@@ -394,7 +374,6 @@ static struct phy_driver at803x_driver[] = {
 	/* ATHEROS 8031 */
 	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
 	.name			= "Atheros 8031 ethernet",
-	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
-- 
2.23.0

