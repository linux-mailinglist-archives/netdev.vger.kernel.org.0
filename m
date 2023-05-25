Return-Path: <netdev+bounces-5246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 732E171064C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 702FD28145D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B16BE4C;
	Thu, 25 May 2023 07:33:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4B38F53
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:33:45 +0000 (UTC)
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AA4183;
	Thu, 25 May 2023 00:33:40 -0700 (PDT)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id 6314720B20;
	Thu, 25 May 2023 09:33:36 +0200 (CEST)
Date: Thu, 25 May 2023 09:33:31 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Johannes Pointner <h4nn35.work@gmail.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Bagas Sanjaya <bagasdotme@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Dan Murphy <dmurphy@ti.com>
Subject: Re: DP83867 ethernet PHY regression
Message-ID: <ZG8PS/CSpHXIA6wt@francesco-nb.int.toradex.com>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
 <ZG4ISE3WXlTM3H54@debian.me>
 <CAHvQdo0gucr-GcWc9YFxsP4WwPUdK9GQ6w-5t9CuqqvPTv+VcA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHvQdo0gucr-GcWc9YFxsP4WwPUdK9GQ6w-5t9CuqqvPTv+VcA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Johannes,

On Thu, May 25, 2023 at 08:31:00AM +0200, Johannes Pointner wrote:
> On Wed, May 24, 2023 at 3:22 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> >
> > On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> > > Hello all,
> > > commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
> > > established link") introduces a regression on my TI AM62 based board.
> > >
> > > I have a working DTS with Linux TI 5.10 downstream kernel branch, while
> > > testing the DTS with v6.4-rc in preparation of sending it to the mailing
> > > list I noticed that ethernet is working only on a cold poweron.
> > >
> > > With da9ef50f545f reverted it always works.
> > >
> > > Here the DTS snippet for reference:
> > >
> > > &cpsw_port1 {
> > >       phy-handle = <&cpsw3g_phy0>;
> > >       phy-mode = "rgmii-rxid";
> > > };
> > >
> > > &cpsw3g_mdio {
> > >       assigned-clocks = <&k3_clks 157 20>;
> > >       assigned-clock-parents = <&k3_clks 157 22>;
> > >       assigned-clock-rates = <25000000>;
> > >
> > >       cpsw3g_phy0: ethernet-phy@0 {
> > >               compatible = "ethernet-phy-id2000.a231";
> > >               reg = <0>;
> > >               interrupt-parent = <&main_gpio0>;
> > >               interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
> > >               reset-gpios = <&main_gpio0 17 GPIO_ACTIVE_LOW>;
> > >               reset-assert-us = <10>;
> > >               reset-deassert-us = <1000>;
> > >               ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
> > >               ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
> > >       };
> > > };
> > >
> >
> > Thanks for the regression report. I'm adding it to regzbot:
> >
> > #regzbot ^introduced: da9ef50f545f86
> > #regzbot title: TI AM62 DTS regression due to dp83867 soft reset
> 
> Hello Francesco,
> 
> I had a similar issue with a patch like this, but in my case it was the DP83822.
> https://lore.kernel.org/netdev/CAHvQdo2yzJC89K74c_CZFjPydDQ5i22w36XPR5tKVv_W8a2vcg@mail.gmail.com/
> I also raised the question for the commit da9ef50f545f.
> https://lore.kernel.org/lkml/CAHvQdo1U_L=pETmTJXjdzO+k7vNTxMyujn99Y3Ot9xAyQu=atQ@mail.gmail.com/
> 
> The problem was/is for me that the phy gets the clock from the CPU and
> the phy is already initialized in the u-boot.
> During the Linux kernel boot up there is a short amount of time where
> no clock is delivered to the phy.
> The phy didn't like this and was most of the time not usable anymore.
> The only thing that brought the phy/link back was resetting the phy
> using the phytool.

I had a look and it seems that is a different issue here, but I cannot
exclude that this is related.

First the link up/down, negotiation and mdio and related communication
is perfectly fine, what it looks like is not working is that no data is
flowing over RGMII.

Second, also in our case the clock is coming from the SoC, however this
clock is enabled way earlier in the boot, and at that time the phy is
even in reset.

 phy reset asserted
 . SPL on TI AM62 R5
   . enable clock
 . SPL on TI AM62 A
 . U-Boot proper on TI AM62 A
   .release phy reset

The phy reset is also configured in the DTS and used by the Linux driver.

In addition to that, as I already clarified in my second email, the
issue is happening also on a cold poweron. It happens most of the time,
but not always.

Francesco



