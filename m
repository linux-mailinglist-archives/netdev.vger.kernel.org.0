Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14F012A064
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 12:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfLXLTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 06:19:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfLXLTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 06:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WY2gnoqDrSyAKgHvd1xb/SE3SkiPqF9d6gmJrwDoPmE=; b=DtGVfu+Rkxk5l3Nh9cu6Tec1nz
        pB6kE0yK6HfCLU0ILveZtkVY5zLk69LJn04C60W9ZvRZtyBkpesgbItUfnWIAeut7ixCGJpkCxlbH
        IIWA1tIVgc45O12rwK81NwMLqSXUDpmiYyh+oDPPx/4IVqW/R8zX2ohBAJTw7y8e9yoE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijiDp-0002DD-J2; Tue, 24 Dec 2019 12:19:29 +0100
Date:   Tue, 24 Dec 2019 12:19:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?J=FCrgen?= Lambrecht <j.lambrecht@televic.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
Message-ID: <20191224111929.GD3395@lunn.ch>
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
 <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
 <20191204171336.GF21904@lunn.ch>
 <c03b1cc5-d5a9-980c-e615-af5b821b500d@televic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c03b1cc5-d5a9-980c-e615-af5b821b500d@televic.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 11:28:27AM +0100, Jürgen Lambrecht wrote:
> On 12/4/19 6:13 PM, Andrew Lunn wrote:
> > But returning 0x0000 is odd. Normally, if an MDIO device does not
> > respond, you read 0xffff, because of the pull up resistor on the bus.
> >
> > The fact you find it ones means it is something like this, some minor
> > configuration problem, power management, etc.
> 
> Hi Adrew,
> 
> to close this issue: you were right: the Marvell clock, that comes from the iMX clocking block ENET1_REF_CLK_25M suddenly stops running:
> 
> an oscilloscope showed that the Marvell main clock stops shortly after the first probe, and only comes back 5s later at the end of booting when the fixed-phy is configured.
> It is not the fec that stops the clock, because if fec1 is "disabled" also the clock stops, but then does not come back.
> 
> We did not found yet how to keep the clock enabled (independent of the fec), so if you have any hints - more than welcome.

Let me make sure i understand your design correct.

I think you are saying your switch does not have a crystal connected
to XTAL_OUT/XTAL_IN. Instead you want the iMX to generate a 25MHz
clock, which you are feeding to the switch?

All the designs i've used have the crystal connected to the
switch. The FEC clock line is used as an input, either driven from a
PHY connected to the other FEC port, or the clock output from the
switch.

So for your design, you need to ensure the 25MHz clock output is
always ticking. Looking at the FEC driver, you see the optional clock
fep->clk_enet_out. This clock is enabled when the FEC interface is
opened, i.e. configured up. It is disabled when the FEC is closed. It
is enabled during probe, but turned off at the end of the probe to
save power. The FEC also has runtime suspend/resume support. This
actually does not touch the clk_enet_out, but it does enable/disable
clocks needed for MDIO to work. I had to fix this many years ago.

It appears this clock is just a plain SOC clock.

In imx7d.dtsi we see:

                clocks = <&clks IMX7D_ENET2_IPG_ROOT_CLK>,
                        <&clks IMX7D_ENET_AXI_ROOT_CLK>,
                        <&clks IMX7D_ENET2_TIME_ROOT_CLK>,
                        <&clks IMX7D_PLL_ENET_MAIN_125M_CLK>,
                        <&clks IMX7D_ENET_PHY_REF_ROOT_CLK>;
                clock-names = "ipg", "ahb", "ptp",
                        "enet_clk_ref", "enet_out";

The mapping between clock-names and clocks seem a bit odd. But there
is some room for error here, since the FEC driver mostly just enables
them all or disables them all. But you need one specific clock.

What i suggest you do is add clock support to DSA. Allow DSA to look
up a clock in DT, and call clk_prepare_enable() and
clk_disable_unprepare(). The clock framework uses reference
counting. So if DSA turns a clock on, it does not matter what the FEC
does, it will stay on. It will only go off when all users of the clock
turn it off.

I'm not sure if this can be done in a generic way for all DSA drivers,
or if you need to add it to the mv88e6xxx driver. The DSA core only
gets involved once the probe of the switch is over. And you probably
need the clock reliably ticking during probe. So maybe it needs to be
in the mv88e6xxx driver.

   Andrew
