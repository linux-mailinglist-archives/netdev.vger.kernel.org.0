Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AFA20332A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgFVJTV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 05:19:21 -0400
Received: from gloria.sntech.de ([185.11.138.130]:48852 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgFVJTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 05:19:21 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jnIbd-0004j2-S3; Mon, 22 Jun 2020 11:19:09 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net
Cc:     kuba@kernel.org, robh+dt@kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v5 3/3] net: phy: mscc: handle the clkout control on some phy variants
Date:   Mon, 22 Jun 2020 11:19:08 +0200
Message-ID: <12647360.rPbPzDV4QW@diego>
In-Reply-To: <20200618164015.GF1551@shell.armlinux.org.uk>
References: <20200618121139.1703762-1-heiko@sntech.de> <1723854.ZAnHLLU950@diego> <20200618164015.GF1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, 18. Juni 2020, 18:40:15 CEST schrieb Russell King - ARM Linux admin:
> On Thu, Jun 18, 2020 at 06:01:29PM +0200, Heiko Stübner wrote:
> > Am Donnerstag, 18. Juni 2020, 17:47:48 CEST schrieb Russell King - ARM Linux admin:
> > > On Thu, Jun 18, 2020 at 05:41:54PM +0200, Heiko Stübner wrote:
> > > > Though I'm not sure how this fits in the whole bringup of ethernet phys.
> > > > Like the phy is dependent on the underlying ethernet controller to
> > > > actually turn it on.
> > > > 
> > > > I guess we should check the phy-state and if it's not accessible, just
> > > > keep the values and if it's in a suitable state do the configuration.
> > > > 
> > > > Calling a vsc8531_config_clkout() from both the vsc8531_config_init()
> > > > as well as the clk_(un-)prepare  and clk_set_rate functions and being
> > > > protected by a check against phy_is_started() ?
> > > 
> > > It sounds like it doesn't actually fit the clk API paradym then.  I
> > > see that Rob suggested it, and from the DT point of view, it makes
> > > complete sense, but then if the hardware can't actually be used in
> > > the way the clk API expects it to be used, then there's a semantic
> > > problem.
> > > 
> > > What is this clock used for?
> > 
> > It provides a source for the mac-clk for the actual transfers, here to
> > provide the 125MHz clock needed for the RGMII interface .
> > 
> > So right now the old rk3368-lion devicetree just declares a stub
> > fixed-clock and instructs the soc's clock controller to use it [0] .
> > And in the cover-letter here, I show the update variant with using
> > the clock defined here.
> > 
> > 
> > I've added the idea from my previous mail like shown below [1].
> > which would take into account the phy-state.
> > 
> > But I guess I'll wait for more input before spamming people with v6.
> 
> Let's get a handle on exactly what this is.
> 
> The RGMII bus has two clocks: RXC and TXC, which are clocked at one
> of 125MHz, 25MHz or 2.5MHz depending on the RGMII data rate.  Some
> PHYs replace TXC with GTX clock, which always runs at 125MHz.  These
> clocks are not what you're referring to.
> 
> You are referring to another commonly provided clock between the MAC
> and the PHY, something which is not unique to your PHY.
> 
> We seem to be heading down a path where different PHYs end up doing
> different things in DT for what is basically the same hardware setup,
> which really isn't good. :(
> 
> We have at803x using:
> 
> qca,clk-out-frequency
> qca,clk-out-strength
> qca,keep-pll-enabled
> 
> which are used to control the CLK_25M output pin on the device, which
> may be used to provide a reference clock for the MAC side, selecting
> between 25M, 50M, 62.5M and 125MHz.  This was introduced in November
> 2019, so not that long ago.

Because it was not that old, was the reason I followed that example in
my v1 :-) 

And Andrew then suggested to at least try to use a common property
for the target frequency that other phys could migrate to.


> Broadcom PHYs configure their 125MHz clock through the PHY device
> flags passed from the MAC at attach/connect time.
> 
> There's the dp83867 and dp83869 configuration (I'm not sure I can
> make sense of it from reading the code) using ti,clk-output-sel -
> but it looks like it's the same kind of thing.  Introduced February
> 2018 into one driver, and November 2019 in the other.
> 
> It seems the Micrel PHYs produce a 125MHz clock irrespective of any
> configuration (maybe configured by firmware, or hardware strapping?)
> 
> So it seems we have four ways of doing the same thing today, and now
> the suggestion is to implement a fifth different way.  I think there
> needs to be some consolidation here, maybe choosing one approach and
> sticking with it.
> 
> Hence, I disagree with Rob - we don't need a fifth approach, we need
> to choose one approach and decide that's our policy for this and
> apply it evenly across the board, rather than making up something
> different each time a new PHY comes along.

@Dave, @Andrew: what's you opinion here?

As Russell above (and Florian in the binding patch) pointed out,
integrating this into the clock-framework may prove difficult not only
for consistency but also for dependency reasons.

Personally I'm fine with either solution, I just want to achieve a working
ethernet on my board :-D .


Thanks
Heiko


