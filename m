Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A90163CF2
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 07:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgBSGOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 01:14:43 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:31339 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgBSGOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 01:14:43 -0500
X-Greylist: delayed 814 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2020 01:14:42 EST
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 01J60Qnp032602;
        Wed, 19 Feb 2020 07:00:26 +0100
Date:   Wed, 19 Feb 2020 07:00:26 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Joel Johnson <mrjoel@lixil.net>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: Re: mvneta: comphy regression with SolidRun ClearFog
Message-ID: <20200219060026.GA32536@1wt.eu>
References: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joel,

On Tue, Feb 18, 2020 at 10:14:48PM -0700, Joel Johnson wrote:
> In updating recently I'm encountering a regression with the mvneta driver on
> SolidRun ClearFog Base devices. I originally filed the bug with Debian
> (https://bugs.debian.org/951409) since I was using distro provided packages,
> but after further investigation I have isolated the issue as related to
> comphy support added during development for kernel version 5.1.
> 
> When booting stock kernels up to 5.0 everything works as expected with three
> ethernet devices identified and functional. However, running any kernel 5.1
> or later, I only have a single ethernet device available. The single device
> available appears to be the one attached to the SoC itself and not connected
> via SerDes lanes using comphy, i.e. the one defined at f1070000.ethernet.

When you say "or later", what most recent version did you try ? My
clearfog works perfectly on 5.4 with the new comphy. I'm having the 2
RJ45 ports working at 1 Gbps and the SFP port working at 1 and 2.5 Gbps.

> I'm not overly Device Tree savvy, but a cursory inspection of f548ced15f90
> at least matches my U-Boot SerDes lane configuration, with comphy1 and
> comphy5 expected to match lane #1 and #5 respectively.

I used to have to modify the device tree in the past, but haven't been
doing so for a while (well in fact I do have a small change there just
in order to enable eMMC which I have on my SOM, and I have just rechecked
that *only* the emmc stuff differs from the regular clearfog-base).

> The only notable difference I can see in /sys/firmware/devicetree is
> expected given the change in dtb, with the following new entries:
> 
>     hexdump -C
> /sys/firmware/devicetree/base/soc/internal-regs/ethernet@30000/phys
>     00000000  00 00 00 0e 00 00 00 01                           |........|
> 
>     hexdump -C
> /sys/firmware/devicetree/base/soc/internal-regs/ethernet@34000/phys
>     00000000  00 00 00 10 00 00 00 02                           |........|

I've just checked and have exactly the same values there.

> Likely unrelated, but a difference that also stood out is that
> armada-388-clearfog.dts contains a managed = "in-band-status" entry for eth1
> but not eth2.

If I remember well it's because with this port being attached to the
switch on the clearfog pro, there's no link status.

I used to have issues in the past with the PHY stuff on this board (up
to 4.9), and *seem* to remember that I once ended up in a similar
situation as yours due to a config issue, though I don't remmeber which
one. Here's what I have matching PHY in my config:

   root@clearfog:~# zgrep ^CONFIG.*PHY /proc/config.gz 
   CONFIG_ARM_PATCH_PHYS_VIRT=y
   CONFIG_ARCH_HAS_PHYS_TO_DMA=y
   CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
   CONFIG_PHYLINK=y
   CONFIG_PHYLIB=y
   CONFIG_SWPHY=y
   CONFIG_FIXED_PHY=y
   CONFIG_MARVELL_PHY=y
   CONFIG_GENERIC_PHY=y
   CONFIG_PHY_MVEBU_A38X_COMPHY=y
   CONFIG_DEBUG_UART_PHYS=0xf1012000
   root@clearfog:~# uname -a
   Linux clearfog 5.4.2-clearfog #10 SMP Sun Dec 8 00:10:40 CET 2019 armv7l GNU/Linux

I'm suspecting it was the FIXED_PHY that I was missing once but I would
be saying crap.

Hoping this helps,
Willy
