Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEF760282E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiJRJVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJRJVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:21:03 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAE6ABF03
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:20:41 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2EE1124000B;
        Tue, 18 Oct 2022 09:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666084840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzOP4NXPVRoO4igeLo+1tBKZN1VOfDFYVFZt/e7BYMI=;
        b=PN2KsWqnn0tMqtF6SNY9Gh6GakwT8t1VpRrDUj8Yd7wzZb5E8pkXGU1U8eWQ1ZrjiFiIg6
        1dxciBqxp09IUcu3QMqFCrV5DGlfEiFL6Ac8BzOIkTIaVCbP2E0ZRLJba86q7fx2oYNEHe
        9k/g3pry2CRse+10edaO+rjE5kN6wKYmY9Eyi0wqrZeN67B1Rh2Hpz4ZAZBQyQNt5FsnK7
        5MyQZK7oJgDog35hf9/hDe+5ZALvT/DyIltUI/QWdOUyAFSLhBoLUrDy055VXWfYZn5UlK
        FvfqAKXYjdUoCBiZfgfDur2ZhS3O4dwzQl7sukNvNJySSl7UbK0iH/Ty8ShJww==
Date:   Tue, 18 Oct 2022 11:20:35 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: Multi-PHYs and multiple-ports bonding support
Message-ID: <20221018112035.5c3e14df@pc-8.home>
In-Reply-To: <Y05gGvh1nacoz0YL@shell.armlinux.org.uk>
References: <20221017105100.0cb33490@pc-8.home>
        <Y00fYeZEcG/E3FPV@shell.armlinux.org.uk>
        <20221018100205.000ac57d@pc-8.home>
        <Y05gGvh1nacoz0YL@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 09:13:14 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Oct 18, 2022 at 10:02:05AM +0200, Maxime Chevallier wrote:
> > Hello Russell,
> > 
> > On Mon, 17 Oct 2022 10:24:49 +0100
> > "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> >   
> > > On Mon, Oct 17, 2022 at 10:51:00AM +0200, Maxime Chevallier
> > > wrote:  
> > > > 2) Changes in Phylink
> > > > 
> > > > This might be the tricky part, as we need to track several
> > > > ports, possibly connected to different PHYs, to get their
> > > > state. For now, I haven't prototyped any of this yet.    
> > > 
> > > The problem is _way_ larger than phylink. It's a fundamental
> > > throughout the net layer that there is one-PHY to one-MAC
> > > relationship. Phylink just adopts this because it is the
> > > established norm, and trying to fix it is rather rediculous
> > > without a use case.
> > > 
> > > See code such as the ethtool code, where the MAC and associated
> > > layers are# entirely bypassed with all the PHY-accessing ethtool
> > > commands and the commands are passed directly to phylib for the
> > > PHY registered against the netdev.
> > > 
> > > We do have use cases though - consider a setup such as the mcbin
> > > with the 3310 in SGMII mode on the fibre link and a copper PHY
> > > plugged in with its own PHY - a stacked PHY situation (we don't
> > > support this right now.) Which PHY should the MII ioctls,
> > > ethtool, and possibly the PTP timestamp code be accessing with a
> > > copper SFP module plugged in?
> > > 
> > > This needs to be solved for your multi-PHY case, because you need
> > > to deal with programming e.g. the link advertisement in both
> > > PHYs, not just one - and with the above model, you have no choice
> > > which PHY gets the call, it's always going to be the one
> > > registered with the netdev.
> > > 
> > > The point I'm making is that you're suggesting this is a phylink
> > > issue, but it isn't, it's a generic networking layering bypass
> > > issue. If the net code always forwarded the ethtool etc stuff to
> > > the MAC and let the MAC make appropriate decisions about how
> > > these were handled, then we would have a properly layered
> > > approach where each layer can decide how a particular interface
> > > is implemented - to cope with situations such as the one you
> > > describe.  
> > 
> > I agree with all you say, and indeed this problem is a good
> > opportunity IMO to consider the other use-cases like the one you
> > mention and come up with a nice solution.  
> 
> However, this isn't really "other use-cases" that I'm talking about
> above, but a problem that needs solving for your case.
> 
> > When you mention that ethtool bypasses the MAC layer and talks to
> > phylib, since phylink has the overall view of the link, and
> > abstracts the phy away from the MAC, I would think this is a good
> > place to manage this tree of PHYs/ports, but on the other hand
> > that's adding quite a lot of complexity to phylink.  
> 
> phylink doesn't abstract the PHY from the networking layer. What we
> have are these call paths through the layers:
> 
> net --> mac --> phylink --> phy
>  |                           ^
>  `---------------------------'
>       (bypass call path)
> 
> That bypass call path will be a problem as soon as you start talking
> about having more than one PHY for a MAC.
> 
> Yes, changing phylink fixes some of the issues, but doesn't get away
> from the fundamental issue that both the MAC and phylink are bypassed
> for certain paths.

You're right, that will need to be addressed. With Andrew's proposition
of having an identifier to address each part of the link (end-points or
intermediary PHYs/link-converters/PCSs), that would be a first step
towards fixing this. So, we would have to rewrite that call chain to
make sure we address the proper member, defaulting to the active PHY
for backwards compat as Andrew said.

I'll poke around and try to come-up with what it could look like on the
userspace side, with some ethtool examples maybe, to try to get a
clearer view.

Thanks,

Maxime

