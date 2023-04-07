Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B824F6DA6F0
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbjDGB1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239187AbjDGB1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:27:04 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE483C0
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:27:00 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pkasQ-0006j2-21;
        Fri, 07 Apr 2023 03:26:54 +0200
Date:   Fri, 7 Apr 2023 02:26:50 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
Subject: Re: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZC9xWo5dgPcVHtTg@makrotopia.org>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <ZCvu4YpUAUSUBPRd@shell.armlinux.org.uk>
 <ZCwQePDCuvlX3wu5@makrotopia.org>
 <ZCw4UUAiTi1/yjUA@shell.armlinux.org.uk>
 <ZCx0_DLX6t4Y07JN@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCx0_DLX6t4Y07JN@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Apr 04, 2023 at 08:05:32PM +0100, Daniel Golle wrote:
> On Tue, Apr 04, 2023 at 03:46:41PM +0100, Russell King (Oracle) wrote:
> > On Tue, Apr 04, 2023 at 12:56:40PM +0100, Daniel Golle wrote:
> > [...]
> > Why do you think it doesn't re-enable in-band AN?
> > 
> > gpy_update_interface() does this when called at various speeds:
> > 
> > if SPEED_2500, it clears VSPEC1_SGMII_CTRL_ANEN
> > 
> > if SPEED_1000, SPEED_100, or SPEED_10, it sets VSPEC1_SGMII_ANEN_ANRS
> >    and VSPEC1_SGMII_ANEN_ANRS is both the VSPEC1_SGMII_CTRL_ANEN and
> >    VSPEC1_SGMII_CTRL_ANRS bits.
> > 
> > So the situation you talk about, when switching to 2500base-X,
> > VSPEC1_SGMII_CTRL_ANEN will be cleared, but when switching back to
> > SGMII mode, VSPEC1_SGMII_CTRL_ANEN will be set again.
> > 
> > To be honest, when I was reviewing the patch adding this support back
> > in June 2021, that also got me, and I was wondering whether
> > VSPEC1_SGMII_CTRL_ANEN was being set afterwards... it's just the
> > macro naming makes it look like it doesn't. But VSPEC1_SGMII_ANEN_ANRS
> > contains both ANEN and ANRS bits.
> 
> Ok, I see it also now. So at least that works somehow.
> 
> Yet switching on Cisco SGMII in-band-status (which is what
> VSPEC1_SGMII_CTRL_ANEN means) deliberately in a PHY driver which is
> connected to a MAC looks wrong. As we are inside a PHY driver we
> obviously have access to this PHY via MDIO and could just as well use
> out-of-band status.
> 
> And it cannot work in this way with MAC drivers which are expected
> to only use Cisco SGMII in-band-status in case of MLO_AN_INBAND being
> set.
> 
> > [...]
> > > I'm afraid we will need some kind of feature flag to indicate that a
> > > MAC driver is known to behave according to convention with regards to
> > > SGMII in-band-status being switched off and only in that case have the
> > > PHY driver do the same, and otherwhise stick with the existing
> > > codepaths and potentially unknown hardware-default behavior
> > > (ie. another mess like the pre_march2020 situation...)
> > 
> > Yes. Thankfully, it's something that, provided the PCS implementations
> > are all the same, at least phylink users should be consistent and we
> > don't need another flag in pl->config to indicate anything. We just
> > tell phylib that we're phylink and be done with it.
> 
> Ok, so this would work in both realtek and mxl-phy phy driver
> .config_init function (pseudo-code):
> 
> if (phydev->phylink &&
>     !phylink_autoneg_inband(phydev->phylink->cur_link_an_mode))
>         switch_off_inband_status(phydev);
> 

Ok, so obviously that was a bit naive.

phydev->phylink has not yet been populated at the time when
.config_init is called. So using !!phydev->phylink as a flag to
indicate that "we're phylink" may work later on, like in .read_status,
.config_aneg or .link_change_notify. But it won't work for .soft_reset
and .config_init because both are called before phydev->phylink has
been set.

Hence going down this path will be sufficient to allow mxl-gpy.c to
switch off SGMII in-band-status in case phylink is being used (see RFC
patch below).

However, it won't be sufficient to decide whether or not to reset an
RTL822x 2.5G PHY or if rate-adaption should be switched off in
.config_init. Unfortunately, without having called genphy_soft_reset
the current .read_status implementation won't work properly in case
vendor bootloader had previously re-programmed the RTL8221B PHY...

Please advise if the patch below would be acceptable:

From 83f55b669300ca641f5f9397f30578a7013b0d7a Mon Sep 17 00:00:00 2001
From: Daniel Golle <daniel@makrotopia.org>
Date: Thu, 6 Apr 2023 23:36:50 +0100
Subject: [PATCH RFC] net: phy: mxl-gpy: don't use SGMII AN if using phylink

MAC drivers using phylink expect SGMII in-band-status to be switched off
when attached to a PHY. Make sure this is the case also for mxl-gpy which
keeps SGMII in-band-status in case of SGMII interface mode is used.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/mxl-gpy.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 8e6bb97b5f85c..0544b0d5b0f75 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -355,8 +355,11 @@ static bool gpy_2500basex_chk(struct phy_device *phydev)
 
 	phydev->speed = SPEED_2500;
 	phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
-	phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
-		       VSPEC1_SGMII_CTRL_ANEN, 0);
+
+	if (!phydev->phylink)
+		phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
+			       VSPEC1_SGMII_CTRL_ANEN, 0);
+
 	return true;
 }
 
@@ -407,6 +410,14 @@ static int gpy_config_aneg(struct phy_device *phydev)
 	u32 adv;
 	int ret;
 
+	/* Disable SGMII auto-negotiation if using phylink */
+	if (phydev->phylink) {
+		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
+				     VSPEC1_SGMII_CTRL_ANEN, 0);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (phydev->autoneg == AUTONEG_DISABLE) {
 		/* Configure half duplex with genphy_setup_forced,
 		 * because genphy_c45_pma_setup_forced does not support.
@@ -529,6 +540,8 @@ static int gpy_update_interface(struct phy_device *phydev)
 	switch (phydev->speed) {
 	case SPEED_2500:
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+		if (phydev->phylink)
+			break;
 		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
 				     VSPEC1_SGMII_CTRL_ANEN, 0);
 		if (ret < 0) {
@@ -542,7 +555,7 @@ static int gpy_update_interface(struct phy_device *phydev)
 	case SPEED_100:
 	case SPEED_10:
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
-		if (gpy_sgmii_aneg_en(phydev))
+		if (phydev->phylink || gpy_sgmii_aneg_en(phydev))
 			break;
 		/* Enable and restart SGMII ANEG for 10/100/1000Mbps link speed
 		 * if ANEG is disabled (in 2500-BaseX mode).
-- 
2.40.0

