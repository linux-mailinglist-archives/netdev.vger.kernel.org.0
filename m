Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84416CCBB9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjC1U6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjC1U6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:58:38 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452FE272B
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:58:18 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phGOG-0002ks-0g;
        Tue, 28 Mar 2023 22:58:02 +0200
Date:   Tue, 28 Mar 2023 21:56:14 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
Message-ID: <ZCNUborFRGwySBQv@makrotopia.org>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org>
 <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
 <ZB8Upcgv8EIovPCl@makrotopia.org>
 <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
 <ZCMDgqBSvHigTcbb@shell.armlinux.org.uk>
 <ZCMx5UBUaycq8+O/@makrotopia.org>
 <ZCM8+dsOo8c6TRJT@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCM8+dsOo8c6TRJT@shell.armlinux.org.uk>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 08:16:09PM +0100, Russell King (Oracle) wrote:
> On Tue, Mar 28, 2023 at 07:28:53PM +0100, Daniel Golle wrote:
> > Hi Russell,
> > 
> > On Tue, Mar 28, 2023 at 04:10:58PM +0100, Russell King (Oracle) wrote:
> > > Hi Daniel,
> > > 
> > > Any feedback with this patch applied? Can't move forward without that.
> > 
> > Sorry for the delay, I only got back to it today.
> > I've tried your patch and do not see any additional output on the
> > kernel log, just like it is the case for Frank's 2.5G SFP module as
> > well. I conclude that the PHY is inaccessible.
> > 
> > I've tried with and without the sfp_quirk_oem_2_5g.
> > 
> > With the quirk:
> > [   55.111856] mt7530 mdio-bus:1f sfp2: Link is Up - Unknown/Unknown - flow control off
> > 
> > Without the quirk:
> > [   44.603495] mt7530 mdio-bus:1f sfp2: unsupported SFP module: no common interface modes
> 
> This is all getting really very messy, and I have no idea what's going
> on and which modules you're testing from report to report.
> 
> The patch was to be used with the module which you previously reported
> earlier in this thread:
> 
> [   17.344155] sfp sfp2: module TP-LINK          TL-SM410U        rev 1.0  sn    12154J6000864    dc 210606
> ...
> [   21.653812] mt7530 mdio-bus:1f sfp2: selection of interface failed, advertisement 00,00000000,00000000,00006440
> 
> That second message - "selection of interface failed" only appears in
> two places:
> 
> 1) in phylink_ethtool_ksettings_set() which will be called in response
> to ethtool being used, but you've said it isn't, so this can't be it.
> 2) in phylink_sfp_config_phy(), which will be called when we have
> detected a PHY on the SFP module and we're trying to set it up.
> This means we must have discovered a PHY on the TL-SM410U module.
> 
> This new message you report:
> 
> 	"unsupported SFP module: no common interface modes"
> 
> is produced by phylink_sfp_config_optical(), which is called when we
> think we have an optical module (in other words when sfp_may_have_phy()
> returns false) or it returns true but we start the module without
> having discovered a PHY.
> 
> So we can only get to this message if we think the module does not
> have a PHY detected.
> 
> If it's the exact same module, that would suggest that the module does
> have an accessible PHY, but there could be a hardware race between the
> PHY becoming accessible and our probing for it. However, we do retry
> probing for the PHY up to 12 times at 50ms intervals.
> 
> Maybe you could shed some light on what's going on? Is it the exact
> same module? Maybe enable debugging in both sfp.c

Yes, this is all TL-SM410U. Just one time with the qurik added and one
time without. It can be that OpenWrt's netifd issues some ethtool
ioctls...

> 
> At the moment I'm rather confused.
> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
