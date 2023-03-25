Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85006C8F05
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 16:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjCYPhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 11:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCYPhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 11:37:09 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BE712044
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 08:37:05 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pg5wp-0008Ic-27;
        Sat, 25 Mar 2023 16:36:51 +0100
Date:   Sat, 25 Mar 2023 15:35:01 +0000
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
Message-ID: <ZB8Upcgv8EIovPCl@makrotopia.org>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org>
 <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 02:05:51PM +0000, Russell King (Oracle) wrote:
> On Sat, Mar 25, 2023 at 02:12:16AM +0000, Daniel Golle wrote:
> > Hi Russell,
> > 
> > On Tue, Mar 21, 2023 at 04:58:51PM +0000, Russell King (Oracle) wrote:
> > > Add a quirk for a copper SFP that identifies itself as "OEM"
> > > "SFP-2.5G-T". This module's PHY is inaccessible, and can only run
> > > at 2500base-X with the host without negotiation. Add a quirk to
> > > enable the 2500base-X interface mode with 2500base-T support, and
> > > disable autonegotiation.
> > > 
> > > Reported-by: Frank Wunderlich <frank-w@public-files.de>
> > > Tested-by: Frank Wunderlich <frank-w@public-files.de>
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > 
> > I've tried the same fix also with my 2500Base-T SFP module:
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 4223c9fa6902..c7a18a72d2c5 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -424,6 +424,7 @@ static const struct sfp_quirk sfp_quirks[] = {
> >         SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
> >         SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
> >         SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
> > +       SFP_QUIRK_M("TP-LINK", "TL-SM410U", sfp_quirk_oem_2_5g),
> >  };
> > 
> >  static size_t sfp_strlen(const char *str, size_t maxlen)
> 
> Thanks for testing.
> 
> > However, the results are a bit of a mixed bag. The link now does come up
> > without having to manually disable autonegotiation. However, I see this
> > new warning in the bootlog:
> > [   17.344155] sfp sfp2: module TP-LINK          TL-SM410U        rev 1.0  sn 12154J6000864    dc 210606  
> > ...
> > [   21.653812] mt7530 mdio-bus:1f sfp2: selection of interface failed, advertisement 00,00000000,00000000,00006440
> 
> This will be the result of issuing an ethtool command, and phylink
> doesn't know what to do with the advertising mask - which is saying:
> 
>    Autoneg, Fibre, Pause, AsymPause
> 
> In other words, there are no capabilities to be advertised, which is
> invalid, and suggests user error. What ethtool command was being
> issued?

This was simply adding the interface to a bridge and bringing it up.
No ethtool involved afaik.

> 
> > Also link speed and status appears unknown, though we do know at least
> > that the speed is 2500M, and also full duplex will always be true for
> > 2500Base-T:
> > [   56.004937] mt7530 mdio-bus:1f sfp2: Link is Up - Unknown/Unknown - flow control off
> 
> I would guess this is because we set the advertising mask to be 2.5bT
> FD, and the PCS resolution (being all that we have) reports that we
> got 2.5bX FD - and when we try to convert those to a speed/duplex we
> fail because there appears to be no mutual ethtool capabilities that
> can be agreed.
> 
> However, given that the media may be doing 2.5G, 1G or 100M with this
> module, and we have no idea what the media may be doing because we
> can't access the PHY, it seems to me that reporting "Unknown" speed
> and "Unknown" duplex is entirely appropriate and correct, if a little
> odd.
> 
> The solution... obviously is to have access to the PHY so we know
> what the media is doing.

In the case of this SFP the internal PHY *only* supports 2500Base-T.
Slower links (1000M/100M/10M) simply don't come up.

I don't know the situation with the 2.5G module Frank was testing, ie.
which modes it supports on the RJ-45 interface, it could be that in his
case you are right.
