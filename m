Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86463575E9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356163AbhDGUZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbhDGUYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C4C9611EE;
        Wed,  7 Apr 2021 20:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827030;
        bh=Zs82cGLnxFxhIAtLwCDJSiYDuwBto4zcdT7u/lF7VS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1YNgEbtRWK9sWbfi6mdnAkyOFjHWCCgHTYVlrUdYGjVT7Fa4PBRNelutrmoTNsU7
         GeG/an+NmmjCJfNflNrq5/KTsxGykHdWwMXI/5Kuets5LhSDeVWto9a2VUofqJWchc
         LUQrXkMEYIWLUgle4vmAv3QMxS/pGUTdhYILiFU/f1APKgvGyCdDSV3Ka2MxsShQPi
         Oh8hIXG/IVJrpZ6kOUAOWSEIO7cIFGMYTGYiztAQuZQ4dcldRyEWfnQCoP0lynPRxb
         oh8JFIOZfd53X/SQVSYEnWcp3EBJiDnWg1M7Vqg+A7ONd4CLaJKJkRRJcaudv4Wpeu
         f/o/7g0hwkCPQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 10/16] net: phy: marvell10g: support other MACTYPEs
Date:   Wed,  7 Apr 2021 22:22:48 +0200
Message-Id: <20210407202254.29417-11-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
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
  usxgmii
  xaui / 5gbase-r / 2500base-x / sgmii
  rxaui / 5gbase-r / 2500base-x / sgmii
and also
  5gbase-r / 2500base-x / sgmii
for 88E2110.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 90 +++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 20d3e572c935..2dc1317e601e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -512,10 +512,18 @@ static int mv2110_init_interface(struct phy_device *phydev, int mactype)
 
 	priv->rate_match = false;
 
-	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH) {
+	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH)
 		priv->rate_match = true;
+
+	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_USXGMII)
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
@@ -531,12 +539,20 @@ static int mv3310_init_interface(struct phy_device *phydev, int mactype)
 	    mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH)
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
+		 mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI)
 		priv->const_interface = PHY_INTERFACE_MODE_RXAUI;
-	else if (mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH)
+	else if (mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH ||
+		 mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI)
 		priv->const_interface = PHY_INTERFACE_MODE_XAUI;
+	else
+		return -EINVAL;
 
 	return 0;
 }
@@ -563,8 +579,10 @@ static int mv3310_config_init(struct phy_device *phydev)
 		return mactype;
 
 	err = chip->init_interface(phydev, mactype);
-	if (err)
+	if (err) {
+		phydev_err(phydev, "MACTYPE configuration invalid\n");
 		return err;
+	}
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
@@ -674,44 +692,44 @@ static void mv3310_update_interface(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 
+	if (!phydev->link)
+		return;
+
 	/* In all of the "* with Rate Matching" modes the PHY interface is fixed
 	 * at 10Gb. The PHY adapts the rate to actual wire speed with help of
 	 * internal 16KB buffer.
+	 *
+	 * In USXGMII mode the PHY interface mode is also fixed.
 	 */
-	if (priv->rate_match) {
+	if (priv->rate_match ||
+	    priv->const_interface == PHY_INTERFACE_MODE_USXGMII) {
 		phydev->interface = priv->const_interface;
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

