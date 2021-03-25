Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E243492E7
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCYNOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhCYNNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271BB619FE;
        Thu, 25 Mar 2021 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678020;
        bh=Dh8a329t1G45WAPNL3cfzHwBiAaBysqzITPpx1n4aHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYvNH4zcRKt/M1MEeQ0AQyF8tUVqf00OwUXG5tMHrUEH5M4m33YNtN2dTeuguHbbF
         wGWJJF1ZrcAOOS9wsdWpMx3JcuyxFmrP/douYljnNCRPK5OGMwpKuvpYsiUo0rBvQp
         SF8oGOKoDNmOwUhDYD4sjM7eAfhX0E68y3/cA5725eQJCb1HGa50i9V6/fp0PvlQrP
         OdruZzoS2RwSIB2gUUgIr8+Lbw74XDKAZUhtm/Wtgc9Pg9P82XxYlj2EDZG/LDK2wj
         I3N3ZyTy0hqJzk8C4uH6Hv4bGz0Mwh5vc3fuL7YcBlF2xype2IzWczfzTySER6elNq
         Vuypee3V0bMug==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 09/12] net: phy: marvell10g: support other MACTYPEs
Date:   Thu, 25 Mar 2021 14:12:47 +0100
Message-Id: <20210325131250.15901-10-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the only "changing" MACTYPE we support is when the PHY changes
between
  10gbase-r / 5gbase-r / 2500base-x / sgmii

Add support for
  xaui / 5gbase-r / 2500base-x / sgmii
  rxaui / 5gbase-r / 2500base-x / sgmii

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 95 +++++++++++++++++++++++-------------
 1 file changed, 60 insertions(+), 35 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 025473512581..6df67c12f012 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -524,10 +524,21 @@ static int mv2110_init_interface(struct phy_device *phydev)
 
 	mactype &= MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
 
-	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH) {
+	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH)
 		priv->rate_match = true;
+
+	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_USXGMII ||
+	    (priv->model == MV_MODEL_88E218X &&
+	     (mactype == MV_PMA_2180_PORT_CTRL_MACTYPE_DXGMII ||
+	      mactype == MV_PMA_2180_PORT_CTRL_MACTYPE_QXGMII)))
+		priv->const_interface = PHY_INTERFACE_MODE_USXGMII;
+	else if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH)
 		priv->const_interface = PHY_INTERFACE_MODE_10GBASER;
-	}
+	else if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER ||
+		 mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER_NO_SGMII_AN)
+		priv->const_interface = PHY_INTERFACE_MODE_NA;
+	else
+		return -EINVAL;
 
 	return 0;
 }
@@ -549,13 +560,23 @@ static int mv3310_init_interface(struct phy_device *phydev)
 	     priv->model == MV_MODEL_88X3310))
 		priv->rate_match = true;
 
-	if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH)
+	if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII)
+		priv->const_interface = PHY_INTERFACE_MODE_USXGMII;
+	else if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH ||
+		 mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN ||
+		 mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER)
 		priv->const_interface = PHY_INTERFACE_MODE_10GBASER;
-	else if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH)
+	else if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH ||
+		 mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI ||
+		 (mactype == MV_V2_3340_PORT_CTRL_MACTYPE_RXAUI_NO_SGMII_AN &&
+		  priv->model == MV_MODEL_88X3340))
 		priv->const_interface = PHY_INTERFACE_MODE_RXAUI;
 	else if (priv->model == MV_MODEL_88X3310 &&
-		 mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH)
+		 (mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH ||
+		  mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI))
 		priv->const_interface = PHY_INTERFACE_MODE_XAUI;
+	else
+		return -EINVAL;
 
 	return 0;
 }
@@ -585,8 +606,10 @@ static int mv3310_config_init(struct phy_device *phydev)
 		err = mv2110_init_interface(phydev);
 	else
 		err = mv3310_init_interface(phydev);
-	if (err < 0)
+	if (err < 0) {
+		phydev_err(phydev, "MACTYPE configuration invalid\n");
 		return err;
+	}
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
@@ -696,6 +719,9 @@ static void mv3310_update_interface(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 
+	if (!phydev->link)
+		return;
+
 	/* In all of the "* with Rate Matching" modes the PHY interface is fixed
 	 * at 10Gb. The PHY adapts the rate to actual wire speed with help of
 	 * internal 16KB buffer.
@@ -705,35 +731,34 @@ static void mv3310_update_interface(struct phy_device *phydev)
 		return;
 	}
 
-	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
-	     phydev->interface == PHY_INTERFACE_MODE_5GBASER ||
-	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
-	    phydev->link) {
-		/* The PHY automatically switches its serdes interface (and
-		 * active PHYXS instance) between Cisco SGMII, 10GBase-R and
-		 * 2500BaseX modes according to the speed.  Florian suggests
-		 * setting phydev->interface to communicate this to the MAC.
-		 * Only do this if we are already in one of the above modes.
-		 */
-		switch (phydev->speed) {
-		case SPEED_10000:
-			phydev->interface = PHY_INTERFACE_MODE_10GBASER;
-			break;
-		case SPEED_5000:
-			phydev->interface = PHY_INTERFACE_MODE_5GBASER;
-			break;
-		case SPEED_2500:
-			phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
-			break;
-		case SPEED_1000:
-		case SPEED_100:
-		case SPEED_10:
-			phydev->interface = PHY_INTERFACE_MODE_SGMII;
-			break;
-		default:
-			break;
-		}
+	if (priv->const_interface == PHY_INTERFACE_MODE_USXGMII) {
+		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
+		return;
+	}
+
+	/* The PHY automatically switches its serdes interface (and active PHYXS
+	 * instance) between Cisco SGMII, 2500BaseX, 5GBase-R and 10GBase-R /
+	 * xaui / rxaui modes according to the speed.
+	 * Florian suggests setting phydev->interface to communicate this to the
+	 * MAC. Only do this if we are already in one of the above modes.
+	 */
+	switch (phydev->speed) {
+	case SPEED_10000:
+		phydev->interface = priv->const_interface;
+		break;
+	case SPEED_5000:
+		phydev->interface = PHY_INTERFACE_MODE_5GBASER;
+		break;
+	case SPEED_2500:
+		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+		break;
+	case SPEED_1000:
+	case SPEED_100:
+	case SPEED_10:
+		phydev->interface = PHY_INTERFACE_MODE_SGMII;
+		break;
+	default:
+		break;
 	}
 }
 
-- 
2.26.2

