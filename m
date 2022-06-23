Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905F2557A46
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiFWMZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiFWMZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:25:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912D53614D
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 05:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Y2JrhsegIriC68s9Fw7JCpXfoxurEcMCoQJGXSXzQXw=; b=z/OZYOuP8FBLITxP5vuC3yOifq
        T7jgC2L8gI7sMw1LD9nqPKADISwQ3bB+bUWr/cYF4D2/OMvoDXKYCtEfzwFeIFtuMcehviJNkb2oM
        1oLTw5X/akfH+zAlPQBNr3y5cdnxbHOWBK2ZBfUvYOGQWSNIebshoZhsG9q9/nE5x6q5o6/xTsmnu
        +mhAOTX8RpCNk90pQHc/mWPMyVhgFsHPimOZAhLsDpcA7x2MZLaPONMXBIjcjbxCK9a1MFUoF0z7K
        CmOwEgBMUK46qU1vR0TI07TrhqAEPG53EBIYWVBWkZWa6qckcpH+eA1s9vGbMjWZnnK3ogBWnwHwq
        hfB3LnQg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37562 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o4Ltr-0004qE-Fy; Thu, 23 Jun 2022 13:25:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o4Ltq-003fYG-TO; Thu, 23 Jun 2022 13:25:30 +0100
In-Reply-To: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
References: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/2] net: pcs: lynx: consolidate sgmii and 1000base-x
 config code
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o4Ltq-003fYG-TO@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 23 Jun 2022 13:25:30 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consolidate lynx_pcs_config_1000basex() and lynx_pcs_config_sgmii() into
a single function. The differences between these two are:

- The value that the link timer is set to.
- The value of the IF_MODE register.

Everything else is identical.

This patch depends on "net: phylink: add QSGMII support to
phylink_mii_c22_pcs_encode_advertisement()".

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 56 ++++++++++++++------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index bdad8e283e97..7d5fc7f54b2f 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -122,53 +122,39 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
 		state->link, state->an_enabled, state->an_complete);
 }
 
-static int lynx_pcs_config_1000basex(struct mdio_device *pcs,
-				     unsigned int mode,
-				     const unsigned long *advertising)
+static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
+				phy_interface_t interface,
+				const unsigned long *advertising)
 {
 	u32 link_timer;
-	int err;
-
-	link_timer = LINK_TIMER_VAL(IEEE8023_LINK_TIMER_NS);
-	mdiodev_write(pcs, LINK_TIMER_LO, link_timer & 0xffff);
-	mdiodev_write(pcs, LINK_TIMER_HI, link_timer >> 16);
-
-	err = mdiodev_modify(pcs, IF_MODE,
-			     IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
-			     0);
-	if (err)
-		return err;
-
-	return phylink_mii_c22_pcs_config(pcs, mode,
-					  PHY_INTERFACE_MODE_1000BASEX,
-					  advertising);
-}
-
-static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int mode,
-				 const unsigned long *advertising)
-{
 	u16 if_mode;
 	int err;
 
-	if_mode = IF_MODE_SGMII_EN;
-	if (mode == MLO_AN_INBAND) {
-		u32 link_timer;
-
-		if_mode |= IF_MODE_USE_SGMII_AN;
-
-		/* Adjust link timer for SGMII */
-		link_timer = LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
+	if (interface == PHY_INTERFACE_MODE_1000BASEX) {
+		link_timer = LINK_TIMER_VAL(IEEE8023_LINK_TIMER_NS);
 		mdiodev_write(pcs, LINK_TIMER_LO, link_timer & 0xffff);
 		mdiodev_write(pcs, LINK_TIMER_HI, link_timer >> 16);
+
+		if_mode = 0;
+	} else {
+		if_mode = IF_MODE_SGMII_EN;
+		if (mode == MLO_AN_INBAND) {
+			if_mode |= IF_MODE_USE_SGMII_AN;
+
+			/* Adjust link timer for SGMII */
+			link_timer = LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
+			mdiodev_write(pcs, LINK_TIMER_LO, link_timer & 0xffff);
+			mdiodev_write(pcs, LINK_TIMER_HI, link_timer >> 16);
+		}
 	}
+
 	err = mdiodev_modify(pcs, IF_MODE,
 			     IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
 			     if_mode);
 	if (err)
 		return err;
 
-	return phylink_mii_c22_pcs_config(pcs, mode, PHY_INTERFACE_MODE_SGMII,
-					 advertising);
+	return phylink_mii_c22_pcs_config(pcs, mode, interface, advertising);
 }
 
 static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
@@ -198,10 +184,10 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 
 	switch (ifmode) {
 	case PHY_INTERFACE_MODE_1000BASEX:
-		return lynx_pcs_config_1000basex(lynx->mdio, mode, advertising);
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-		return lynx_pcs_config_sgmii(lynx->mdio, mode, advertising);
+		return lynx_pcs_config_giga(lynx->mdio, mode, ifmode,
+					    advertising);
 	case PHY_INTERFACE_MODE_2500BASEX:
 		if (phylink_autoneg_inband(mode)) {
 			dev_err(&lynx->mdio->dev,
-- 
2.30.2

