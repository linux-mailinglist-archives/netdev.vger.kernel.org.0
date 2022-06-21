Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E691552D6E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348208AbiFUIxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345003AbiFUIxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:53:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD75FFB
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2c0ipjjgvoK1A74cd+C3gjXfOoenbkVd9a0+TclF9/8=; b=qfAq6g5E64tkHAtVmbikIGHhWL
        EyBLZ49jb9nUw12vYM1mI2dLp5Mf8hQdT81Zn1oQ626LUsIHszBeLGB9UJ/1frEf3XV5faARE/jHh
        +BzOuoJ0CxFaIiirBDwlVlIDyIObk1ObH/ciCkr6DHIA5ZIVTxUoqNnrRqY5JDb4AtlRJEVHQp2O2
        rw63etBEVZqRB5jQXVLmR7glroVDqJQyLZydWCPD1N8UegGn6HspZux/RUyqgtBirlxHkbepUl9SJ
        rtNPW1m9H6LG3dY6fwYT1cSqFy/x3Id3HD39wak56g15NpSuh41yOhqq8NXoXR1sWi1CncRDnRQd8
        5orSY/3g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56616 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o3Zd9-00024u-K4; Tue, 21 Jun 2022 09:53:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o3Zd8-002yHI-G2; Tue, 21 Jun 2022 09:53:02 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: pcs: lynx: use mdiodev accessors
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o3Zd8-002yHI-G2@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Jun 2022 09:53:02 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the recently introduced mdiodev accessors for the lynx PCS.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index fd3445374955..bdad8e283e97 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -71,12 +71,10 @@ static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 static void lynx_pcs_get_state_2500basex(struct mdio_device *pcs,
 					 struct phylink_link_state *state)
 {
-	struct mii_bus *bus = pcs->bus;
-	int addr = pcs->addr;
 	int bmsr, lpa;
 
-	bmsr = mdiobus_read(bus, addr, MII_BMSR);
-	lpa = mdiobus_read(bus, addr, MII_LPA);
+	bmsr = mdiodev_read(pcs, MII_BMSR);
+	lpa = mdiodev_read(pcs, MII_LPA);
 	if (bmsr < 0 || lpa < 0) {
 		state->link = false;
 		return;
@@ -128,16 +126,14 @@ static int lynx_pcs_config_1000basex(struct mdio_device *pcs,
 				     unsigned int mode,
 				     const unsigned long *advertising)
 {
-	struct mii_bus *bus = pcs->bus;
-	int addr = pcs->addr;
 	u32 link_timer;
 	int err;
 
 	link_timer = LINK_TIMER_VAL(IEEE8023_LINK_TIMER_NS);
-	mdiobus_write(bus, addr, LINK_TIMER_LO, link_timer & 0xffff);
-	mdiobus_write(bus, addr, LINK_TIMER_HI, link_timer >> 16);
+	mdiodev_write(pcs, LINK_TIMER_LO, link_timer & 0xffff);
+	mdiodev_write(pcs, LINK_TIMER_HI, link_timer >> 16);
 
-	err = mdiobus_modify(bus, addr, IF_MODE,
+	err = mdiodev_modify(pcs, IF_MODE,
 			     IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
 			     0);
 	if (err)
@@ -151,8 +147,6 @@ static int lynx_pcs_config_1000basex(struct mdio_device *pcs,
 static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int mode,
 				 const unsigned long *advertising)
 {
-	struct mii_bus *bus = pcs->bus;
-	int addr = pcs->addr;
 	u16 if_mode;
 	int err;
 
@@ -164,10 +158,10 @@ static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int mode,
 
 		/* Adjust link timer for SGMII */
 		link_timer = LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
-		mdiobus_write(bus, addr, LINK_TIMER_LO, link_timer & 0xffff);
-		mdiobus_write(bus, addr, LINK_TIMER_HI, link_timer >> 16);
+		mdiodev_write(pcs, LINK_TIMER_LO, link_timer & 0xffff);
+		mdiodev_write(pcs, LINK_TIMER_HI, link_timer >> 16);
 	}
-	err = mdiobus_modify(bus, addr, IF_MODE,
+	err = mdiodev_modify(pcs, IF_MODE,
 			     IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
 			     if_mode);
 	if (err)
@@ -237,9 +231,7 @@ static void lynx_pcs_an_restart(struct phylink_pcs *pcs)
 static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
 				   int speed, int duplex)
 {
-	struct mii_bus *bus = pcs->bus;
 	u16 if_mode = 0, sgmii_speed;
-	int addr = pcs->addr;
 
 	/* The PCS needs to be configured manually only
 	 * when not operating on in-band mode
@@ -269,7 +261,7 @@ static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
 	}
 	if_mode |= IF_MODE_SPEED(sgmii_speed);
 
-	mdiobus_modify(bus, addr, IF_MODE,
+	mdiodev_modify(pcs, IF_MODE,
 		       IF_MODE_HALF_DUPLEX | IF_MODE_SPEED_MSK,
 		       if_mode);
 }
@@ -294,8 +286,6 @@ static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
 				       unsigned int mode,
 				       int speed, int duplex)
 {
-	struct mii_bus *bus = pcs->bus;
-	int addr = pcs->addr;
 	u16 if_mode = 0;
 
 	if (mode == MLO_AN_INBAND) {
@@ -307,7 +297,7 @@ static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
 		if_mode |= IF_MODE_HALF_DUPLEX;
 	if_mode |= IF_MODE_SPEED(SGMII_SPEED_2500);
 
-	mdiobus_modify(bus, addr, IF_MODE,
+	mdiodev_modify(pcs, IF_MODE,
 		       IF_MODE_HALF_DUPLEX | IF_MODE_SPEED_MSK,
 		       if_mode);
 }
-- 
2.30.2

