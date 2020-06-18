Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739761FF966
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbgFRQk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728929AbgFRQk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:40:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D679C06174E;
        Thu, 18 Jun 2020 09:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wQ51QMPUtPEJr0c4bhMM9pVdyp44hbpF1rlza5L8bD0=; b=Lu6yjyZ/5efCrXL0CtuLzVu9g
        qPOM+X6SutLQNYojPjT9criSA3ZvjhBsV5sIM5cq2z4dVsCaOR9rz939y5mkw49ER+ii8hPdsMNPE
        EsQ3OEZBJEcSPJm6+Njq2P7o6LBVwpIahOPhqxCC5SHDhtp+0SmFYDYxSClrUBXbIL86LNhD8dLHm
        9PfAr+4pd/CejL30nIxOYuGUh9Ifn2m/YnQxOrfF1tbgimkk2JXuyAOS79MoM4PbHGqaEYTy42D6w
        2SrTzsZF1sToyWYiGoCHY0k8+4ZB91S7+khNH5EdpUaCKlP5jCxNyq/Ao4zjMyUTBD3SabDouPXtk
        kIugdRPFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58792)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlxaN-0005Pg-NF; Thu, 18 Jun 2020 17:40:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlxaJ-0004ra-WC; Thu, 18 Jun 2020 17:40:16 +0100
Date:   Thu, 18 Jun 2020 17:40:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com
Subject: Re: [PATCH v5 3/3] net: phy: mscc: handle the clkout control on some
 phy variants
Message-ID: <20200618164015.GF1551@shell.armlinux.org.uk>
References: <20200618121139.1703762-1-heiko@sntech.de>
 <2277698.LFZWc9m3Y3@diego>
 <20200618154748.GE1551@shell.armlinux.org.uk>
 <1723854.ZAnHLLU950@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1723854.ZAnHLLU950@diego>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 06:01:29PM +0200, Heiko Stübner wrote:
> Am Donnerstag, 18. Juni 2020, 17:47:48 CEST schrieb Russell King - ARM Linux admin:
> > On Thu, Jun 18, 2020 at 05:41:54PM +0200, Heiko Stübner wrote:
> > > Though I'm not sure how this fits in the whole bringup of ethernet phys.
> > > Like the phy is dependent on the underlying ethernet controller to
> > > actually turn it on.
> > > 
> > > I guess we should check the phy-state and if it's not accessible, just
> > > keep the values and if it's in a suitable state do the configuration.
> > > 
> > > Calling a vsc8531_config_clkout() from both the vsc8531_config_init()
> > > as well as the clk_(un-)prepare  and clk_set_rate functions and being
> > > protected by a check against phy_is_started() ?
> > 
> > It sounds like it doesn't actually fit the clk API paradym then.  I
> > see that Rob suggested it, and from the DT point of view, it makes
> > complete sense, but then if the hardware can't actually be used in
> > the way the clk API expects it to be used, then there's a semantic
> > problem.
> > 
> > What is this clock used for?
> 
> It provides a source for the mac-clk for the actual transfers, here to
> provide the 125MHz clock needed for the RGMII interface .
> 
> So right now the old rk3368-lion devicetree just declares a stub
> fixed-clock and instructs the soc's clock controller to use it [0] .
> And in the cover-letter here, I show the update variant with using
> the clock defined here.
> 
> 
> I've added the idea from my previous mail like shown below [1].
> which would take into account the phy-state.
> 
> But I guess I'll wait for more input before spamming people with v6.

Let's get a handle on exactly what this is.

The RGMII bus has two clocks: RXC and TXC, which are clocked at one
of 125MHz, 25MHz or 2.5MHz depending on the RGMII data rate.  Some
PHYs replace TXC with GTX clock, which always runs at 125MHz.  These
clocks are not what you're referring to.

You are referring to another commonly provided clock between the MAC
and the PHY, something which is not unique to your PHY.

We seem to be heading down a path where different PHYs end up doing
different things in DT for what is basically the same hardware setup,
which really isn't good. :(

We have at803x using:

qca,clk-out-frequency
qca,clk-out-strength
qca,keep-pll-enabled

which are used to control the CLK_25M output pin on the device, which
may be used to provide a reference clock for the MAC side, selecting
between 25M, 50M, 62.5M and 125MHz.  This was introduced in November
2019, so not that long ago.

Broadcom PHYs configure their 125MHz clock through the PHY device
flags passed from the MAC at attach/connect time.

There's the dp83867 and dp83869 configuration (I'm not sure I can
make sense of it from reading the code) using ti,clk-output-sel -
but it looks like it's the same kind of thing.  Introduced February
2018 into one driver, and November 2019 in the other.

It seems the Micrel PHYs produce a 125MHz clock irrespective of any
configuration (maybe configured by firmware, or hardware strapping?)

So it seems we have four ways of doing the same thing today, and now
the suggestion is to implement a fifth different way.  I think there
needs to be some consolidation here, maybe choosing one approach and
sticking with it.

Hence, I disagree with Rob - we don't need a fifth approach, we need
to choose one approach and decide that's our policy for this and
apply it evenly across the board, rather than making up something
different each time a new PHY comes along.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
