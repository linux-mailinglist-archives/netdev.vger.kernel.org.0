Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A9B347E38
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhCXQvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236829AbhCXQvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8082F61A06;
        Wed, 24 Mar 2021 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604670;
        bh=NwIaq81F8keD9a2lUJdtmdYwyazBdQn4CsmtxA+wGas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2rKG/gLZ1zJrO7mb1isfLpooOWzAmpHKVYawVsBurVNykempcTbMuFgbuA5V2RJ9
         /3Xl8GvtOsjDV97JZZO0APaa6HXbJpsU7iRdYnVKSBt2iAstujO5QJT8aS6hrHATLe
         2NNXb84+RiX1l4wShqJnn3nXYuQ3R7BjU3Mh35SbAVTfs+DAQ8ZonlTQrR9E4Q4XgY
         +UHN3KD1mOGYED8Cejn7STlTboH6Z5OjK2Nw2quqQWM3K92iWWzTMcu2T+bfhn6SqQ
         9NutxRCa47ILjiCch4eBIJivzkZh5Wqx5+U+r0dcfyzdiQ+3uofSHnJa6RhjF6KPsN
         ZnOMAjipSLzfA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 7/7] net: phy: marvell10g: support other MACTYPEs
Date:   Wed, 24 Mar 2021 17:50:23 +0100
Message-Id: <20210324165023.32352-8-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324165023.32352-1-kabel@kernel.org>
References: <20210324165023.32352-1-kabel@kernel.org>
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
 drivers/net/phy/marvell10g.c | 70 +++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index c764795a142a..a0fc74456d32 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -595,6 +595,10 @@ static int mv3310_aneg_done(struct phy_device *phydev)
 static void mv3310_update_interface(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	phy_interface_t interface10g;
+
+	if (!phydev->link)
+		return;
 
 	/* In all of the "* with Rate Matching" modes the PHY interface is fixed
 	 * at 10Gb. The PHY adapts the rate to actual wire speed with help of
@@ -610,38 +614,46 @@ static void mv3310_update_interface(struct phy_device *phydev)
 	case MV_V2_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH:
 		phydev->interface = PHY_INTERFACE_MODE_RXAUI;
 		return;
-	default:
+	case MV_V2_PORT_CTRL_MACTYPE_USXGMII:
+		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
+		return;
+	case MV_V2_PORT_CTRL_MACTYPE_10GBASER:
+	case MV_V2_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN:
+		interface10g = PHY_INTERFACE_MODE_10GBASER;
 		break;
+	case MV_V2_PORT_CTRL_MACTYPE_XAUI:
+		interface10g = PHY_INTERFACE_MODE_XAUI;
+		break;
+	case MV_V2_PORT_CTRL_MACTYPE_RXAUI:
+		interface10g = PHY_INTERFACE_MODE_RXAUI;
+		break;
+	default:
+		unreachable();
 	}
 
-	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
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
+	/* The PHY automatically switches its serdes interface (and active PHYXS
+	 * instance) between Cisco SGMII, 2500BaseX, 5GBase-R and 10GBase-R /
+	 * xaui / rxaui modes according to the speed.
+	 * Florian suggests setting phydev->interface to communicate this to the
+	 * MAC. Only do this if we are already in one of the above modes.
+	 */
+	switch (phydev->speed) {
+	case SPEED_10000:
+		phydev->interface = interface10g;
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

