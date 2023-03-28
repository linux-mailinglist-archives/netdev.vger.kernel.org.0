Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A276CCA02
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 20:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjC1S3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 14:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC1S3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 14:29:16 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8711999
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:29:14 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phE42-0001fH-13;
        Tue, 28 Mar 2023 20:28:58 +0200
Date:   Tue, 28 Mar 2023 19:28:53 +0100
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
Message-ID: <ZCMx5UBUaycq8+O/@makrotopia.org>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org>
 <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
 <ZB8Upcgv8EIovPCl@makrotopia.org>
 <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
 <ZCMDgqBSvHigTcbb@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCMDgqBSvHigTcbb@shell.armlinux.org.uk>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Mar 28, 2023 at 04:10:58PM +0100, Russell King (Oracle) wrote:
> Hi Daniel,
> 
> Any feedback with this patch applied? Can't move forward without that.

Sorry for the delay, I only got back to it today.
I've tried your patch and do not see any additional output on the
kernel log, just like it is the case for Frank's 2.5G SFP module as
well. I conclude that the PHY is inaccessible.

I've tried with and without the sfp_quirk_oem_2_5g.

With the quirk:
[   55.111856] mt7530 mdio-bus:1f sfp2: Link is Up - Unknown/Unknown - flow control off

Without the quirk:
[   44.603495] mt7530 mdio-bus:1f sfp2: unsupported SFP module: no common interface modes

Note that as there are probably also other similar 2500Base-T SFP modules around
I suspect that the introduction of the quirk might have broken them, in
the sense that previously they were working if one manually disabled AN
using ethtool, now they won't work at all :(


> 
> Thanks.
> 
> On Sat, Mar 25, 2023 at 07:36:10PM +0000, Russell King (Oracle) wrote:
> > On Sat, Mar 25, 2023 at 03:35:01PM +0000, Daniel Golle wrote:
> > > On Sat, Mar 25, 2023 at 02:05:51PM +0000, Russell King (Oracle) wrote:
> > > > On Sat, Mar 25, 2023 at 02:12:16AM +0000, Daniel Golle wrote:
> > > > > Hi Russell,
> > > > > 
> > > > > On Tue, Mar 21, 2023 at 04:58:51PM +0000, Russell King (Oracle) wrote:
> > > > > > Add a quirk for a copper SFP that identifies itself as "OEM"
> > > > > > "SFP-2.5G-T". This module's PHY is inaccessible, and can only run
> > > > > > at 2500base-X with the host without negotiation. Add a quirk to
> > > > > > enable the 2500base-X interface mode with 2500base-T support, and
> > > > > > disable autonegotiation.
> > > > > > 
> > > > > > Reported-by: Frank Wunderlich <frank-w@public-files.de>
> > > > > > Tested-by: Frank Wunderlich <frank-w@public-files.de>
> > > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > > 
> > > > > I've tried the same fix also with my 2500Base-T SFP module:
> > > > > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > > > > index 4223c9fa6902..c7a18a72d2c5 100644
> > > > > --- a/drivers/net/phy/sfp.c
> > > > > +++ b/drivers/net/phy/sfp.c
> > > > > @@ -424,6 +424,7 @@ static const struct sfp_quirk sfp_quirks[] = {
> > > > >         SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
> > > > >         SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
> > > > >         SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
> > > > > +       SFP_QUIRK_M("TP-LINK", "TL-SM410U", sfp_quirk_oem_2_5g),
> > > > >  };
> > > > > 
> > > > >  static size_t sfp_strlen(const char *str, size_t maxlen)
> > > > 
> > > > Thanks for testing.
> > > > 
> > > > > However, the results are a bit of a mixed bag. The link now does come up
> > > > > without having to manually disable autonegotiation. However, I see this
> > > > > new warning in the bootlog:
> > > > > [   17.344155] sfp sfp2: module TP-LINK          TL-SM410U        rev 1.0  sn 12154J6000864    dc 210606  
> > > > > ...
> > > > > [   21.653812] mt7530 mdio-bus:1f sfp2: selection of interface failed, advertisement 00,00000000,00000000,00006440
> > > > 
> > > > This will be the result of issuing an ethtool command, and phylink
> > > > doesn't know what to do with the advertising mask - which is saying:
> > > > 
> > > >    Autoneg, Fibre, Pause, AsymPause
> > > > 
> > > > In other words, there are no capabilities to be advertised, which is
> > > > invalid, and suggests user error. What ethtool command was being
> > > > issued?
> > > 
> > > This was simply adding the interface to a bridge and bringing it up.
> > > No ethtool involved afaik.
> > 
> > If its not ethtool, then there is only one other possibility which I
> > thought had already been ruled out - and that is the PHY is actually
> > accessible, but either we don't have a driver for it, or when reading
> > the PHY's "features" we don't know what it is.
> > 
> > Therefore, as the PHY is accessible, we need to identify what it is
> > and have a driver for it.
> > 
> > Please apply the following patch to print some useful information
> > about the PHY:
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index aec8e48bdd4f..6b67262d5706 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -2978,9 +2978,37 @@ static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
> >  
> >  	iface = sfp_select_interface(pl->sfp_bus, config.advertising);
> >  	if (iface == PHY_INTERFACE_MODE_NA) {
> > +		const int num_ids = ARRAY_SIZE(phy->c45_ids.device_ids);
> > +		u32 id;
> > +		int i;
> > +
> > +		if (phy->is_c45) {
> > +			for (i = 0; i < num_ids; i++) {
> > +				id = phy->c45_ids.device_ids[i];
> > +				if (id != 0xffffffff)
> > +					break;
> > +			}
> > +		} else {
> > +			id = phy->phy_id;
> > +		}
> > +		phylink_err(pl,
> > +			    "Clause %s PHY [0x%04x:0x%04x] driver %s found but\n",
> > +			    phy->is_c45 ? "45" : "22",
> > +			    id >> 16, id & 0xffff,
> > +			    phy->drv ? phy->drv->name : "[unbound]");
> >  		phylink_err(pl,
> >  			    "selection of interface failed, advertisement %*pb\n",
> >  			    __ETHTOOL_LINK_MODE_MASK_NBITS, config.advertising);
> > +
> > +		if (phy->is_c45) {
> > +			phylink_err(pl, "Further PHY IDs:\n");
> > +			for (i = 0; i < num_ids; i++) {
> > +				id = phy->c45_ids.device_ids[i];
> > +				if (id != 0xffffffff)
> > +					phylink_err(pl, "  MMD %d [0x%04x:0x%04x]\n",
> > +						    i, id >> 16, id & 0xffff);
> > +			}
> > +		}
> >  		return -EINVAL;
> >  	}
> >  
> > 
> > Thanks.
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
