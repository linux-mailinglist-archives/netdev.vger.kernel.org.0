Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D453D1948
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhGUUuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhGUUue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 16:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAA466120A;
        Wed, 21 Jul 2021 21:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626903071;
        bh=kdg91hXD51FJVe4jRiptDDtiSgUu3ibBVXczOFFs+CM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f30pJgdu3q4ZNxICc1ztiq5Ne7+V5qtCFP496bc4wnbnQDpbQdTPkqoL1QRYI9qg2
         7FbpCzGeJV8kgz8hr9zoEL+FtiWRwkPzjl9LtRiZyl95en6Yboyd1YJfs+0qv85Dae
         u/fQ6+F++EoO1lUMi0Qcgiy9zCQEen+/+JWQJyIdpUEkrzZNXCSM6V2B0wuQ4v7Qvh
         pNCPfLtDI7wHeMph2KdWnobN0VPXwpRpmnKLKBgR39NB2pUMiKAvV/6FY1/hNjKy3t
         V1FJk/jxoQwAld+/lRz7RRbOHCyXv5Sq8DRDFrsEy04+ytnQcCvncsjMalJ7Dst9iE
         PRn5vkUod5e1g==
Date:   Wed, 21 Jul 2021 23:31:05 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210721233105.65468fd2@thinkpad>
In-Reply-To: <YPiJjEBV1PZQu0S/@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
        <20210716212427.821834-6-anthony.l.nguyen@intel.com>
        <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
        <YPTKB0HGEtsydf9/@lunn.ch>
        <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
        <YPbu8xOFDRZWMTBe@lunn.ch>
        <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
        <20210721204543.08e79fac@thinkpad>
        <YPh6b+dTZqQNX+Zk@lunn.ch>
        <20210721220716.539f780e@thinkpad>
        <YPiJjEBV1PZQu0S/@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 22:54:36 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > > Basically the LED name is of the format
> > > >   devicename:color:function    
> 
> > Unfortunately there isn't consensus about what the devicename should
> > mean. There are two "schools of thought":
> > 
> > 1. device name of the trigger source for the LED, i.e. if the LED
> >    blinks on activity on mmc0, the devicename should be mmc0. We have
> >    talked about this in the discussions about ethernet PHYs.
> >    In the case of the igc driver if the LEDs are controlled by the MAC,
> >    I guess some PCI identifier would be OK.  
> 
> I guess this is most likely for Ethernet LEDs, some sort of bus
> identifier. But Ethernet makes use of all sorts of busses, so you will
> also see USB, memory mapped for SOCs, MDIO, SPI, etc.

That's why I think we should group them all under a name like ethmac0,
ethmac1, ... We want to do this for PHY controlled LEDs (ethphy0,
ethphy1, ...)

> > 2. device name of the LED controller. For example LEDs controlled by
> >    the maxim,max77650-led controller (leds-max77650.c) define device
> >    name as "max77650"  
> 
> And what happens when the controller is just a tiny bit of silicon in
> the corner of something else, not a standalone device? Would this be
> 'igc', for LEDs controlled by the IGC Ethernet controller? 'mv88e6xxx'
> for Marvell Ethernet switches? 

This is one of the reasons why I prefer the first scheme.

> Also, function is totally unclear. The whole reason we want to use
> Linux LEDs is triggers, and it is the selected trigger which
> determines the function.

As I said there are two "schools of thought" for this as well.
Devicetree deprecated the `linux,default-trigger` DT property and
`function` property should be used instead. Jacek's then defined some
function definition constants in include/dt-bindings/leds/common.h and
sent a proposal for function to trigger mappings
  https://lore.kernel.org/linux-leds/20200920162625.14754-1-jacek.anaszewski@gmail.com/
But this was not implemented, and I together with Pavel do not agree
with this proposal, and I proposed something different:
  https://lore.kernel.org/linux-leds/20200920184422.60c04194@nic.cz/
Since function to trigger mappings is not yet implemented in the code,
we can still decide.

Do you think I should a poll more kernel developers about their
opinions?

> Colour is also an issue. The IGC Ethernet controller has no idea what
> colour the LEDs are in the RG-45 socket. And this is generic to
> Ethernet MAC and PHY chips. The data sheets never mention colour.  You
> might know the colour in DT (and maybe ACPI) systems where you have
> specific information about the board. But in for PCIe card, USB
> dongles, etc, colour is unknown.

The LED core (function led_compose_name in drivers/leds/led-core.c)
skips color and function if they are not present in fwnode, i.e.
  "mmc0::"

I guess in the case of igc, if the color is not known, and if we can
agree on the first scheme for choosing the devicename part, then the
LED names could be, depending on the scheme for function, either
  "ethmac0::lan-0"
  "ethmac0::lan-1"
  "ethmac0::lan-2"
or
  "ethmac0::link"
  "ethmac0::activity"
  "ethmac0::rx"

(If there is color defined in ACPI / DTS though, it should be also
 used.)

So basically we need to decide on these two things:
- scheme for device name
- scheme for function to default trigger mappings

Marek
