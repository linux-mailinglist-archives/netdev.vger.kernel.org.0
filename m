Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC696D6CF1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjDDTGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbjDDTGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:06:04 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B3C2D61
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 12:05:42 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pjlyK-0007s1-29;
        Tue, 04 Apr 2023 21:05:36 +0200
Date:   Tue, 4 Apr 2023 20:05:32 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
Subject: Re: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZCx0_DLX6t4Y07JN@makrotopia.org>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <ZCvu4YpUAUSUBPRd@shell.armlinux.org.uk>
 <ZCwQePDCuvlX3wu5@makrotopia.org>
 <ZCw4UUAiTi1/yjUA@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCw4UUAiTi1/yjUA@shell.armlinux.org.uk>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 03:46:41PM +0100, Russell King (Oracle) wrote:
> On Tue, Apr 04, 2023 at 12:56:40PM +0100, Daniel Golle wrote:
> [...]
> Why do you think it doesn't re-enable in-band AN?
> 
> gpy_update_interface() does this when called at various speeds:
> 
> if SPEED_2500, it clears VSPEC1_SGMII_CTRL_ANEN
> 
> if SPEED_1000, SPEED_100, or SPEED_10, it sets VSPEC1_SGMII_ANEN_ANRS
>    and VSPEC1_SGMII_ANEN_ANRS is both the VSPEC1_SGMII_CTRL_ANEN and
>    VSPEC1_SGMII_CTRL_ANRS bits.
> 
> So the situation you talk about, when switching to 2500base-X,
> VSPEC1_SGMII_CTRL_ANEN will be cleared, but when switching back to
> SGMII mode, VSPEC1_SGMII_CTRL_ANEN will be set again.
> 
> To be honest, when I was reviewing the patch adding this support back
> in June 2021, that also got me, and I was wondering whether
> VSPEC1_SGMII_CTRL_ANEN was being set afterwards... it's just the
> macro naming makes it look like it doesn't. But VSPEC1_SGMII_ANEN_ANRS
> contains both ANEN and ANRS bits.

Ok, I see it also now. So at least that works somehow.

Yet switching on Cisco SGMII in-band-status (which is what
VSPEC1_SGMII_CTRL_ANEN means) deliberately in a PHY driver which is
connected to a MAC looks wrong. As we are inside a PHY driver we
obviously have access to this PHY via MDIO and could just as well use
out-of-band status.

And it cannot work in this way with MAC drivers which are expected
to only use Cisco SGMII in-band-status in case of MLO_AN_INBAND being
set.

> [...]
> > I'm afraid we will need some kind of feature flag to indicate that a
> > MAC driver is known to behave according to convention with regards to
> > SGMII in-band-status being switched off and only in that case have the
> > PHY driver do the same, and otherwhise stick with the existing
> > codepaths and potentially unknown hardware-default behavior
> > (ie. another mess like the pre_march2020 situation...)
> 
> Yes. Thankfully, it's something that, provided the PCS implementations
> are all the same, at least phylink users should be consistent and we
> don't need another flag in pl->config to indicate anything. We just
> tell phylib that we're phylink and be done with it.

Ok, so this would work in both realtek and mxl-phy phy driver
.config_init function (pseudo-code):

if (phydev->phylink &&
    !phylink_autoneg_inband(phydev->phylink->cur_link_an_mode))
        switch_off_inband_status(phydev);

If that pattern looks good to you, I will start with patches for
mxl-gpy.c and then go on with realtek.c. In case of realtek.c we
probably should also make calling genphy_soft_reset in .soft_reset
conditional on !!phydev->phylink, and that could even become a
generic helper function, as probably many other phy drivers which
currently don't set .soft_reset to genphy_soft_reset would need
that in case phylink is being used.
Anyway, step by step...

> For everything else, I think we just have to assume "let the PHY
> driver do what it does today" as the safest course of action.
> 
> As for the pre_march2020 situation, we're down to just two drivers
> that require that now:
> 
> 1) mtk_eth_soc for its RGMII mode (which, honestly, I'm prepared to
>    break at this point, because I do not believe there are *any* users
>    out there - not only have my pleas for testers for that had no
>    response, I believe the code in mk_eth_soc to be broken.)
> 
>    I am considering removing RGMII support there for implementations
>    which have MTK_GMAC1_TRGMII but _not_ MTK_TRGMII_MT7621_CLK -
>    basically the path that calls mtk_gmac0_rgmii_adjust(). I doubt
>    anyone will complain because no one seems to be using it (or
>    they are and they're ignoring my pleas for testers - in which
>    case, being three years on, they honestly get what's coming, that
>    being a regression or not.)

So that would affect MT7623, I do have this hardware for testing, the
BPi-R2 and also Frank certainly has it flying around and would probably
be available to help testing.

I may have missed your call for help there, I can test anything you
want on the BPi-R2 board with MT7623N + MT7530:
[    2.061063] mt7530 mdio-bus:00: configuring for fixed/trgmii link mode
...
[    4.939408] mtk_soc_eth 1b100000.ethernet eth0: configuring for fixed/trgmii link mode

Is that the kind of board you'd be looking for?

For the fun of it we can of course try to also change the speed of
MT7530 CPU port to something else than 1000M...

Please point me to patches to test, I can get started right away.

> 
> 2) mv88e6xxx DSA support, which needs to be converted to phylink_pcs
>    as previously stated.
> 
> I never thought it would take 3+ years to get drivers converted, but
> sadly this shows how glacially slow progress can be in mainline, and
> the more users phylink gets, the more of a problem this is likely to
> become unless we have really good interfaces into code making use of
> it.

