Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29B03D1874
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhGUUOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:14:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhGUUOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 16:14:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fpusfhLNwWR4XZzzRKY6uqd8YsP1C+k/KaALJHdJWz4=; b=y/X0I0JkkoqvHEjjZ5YIS+kCvX
        D37DUJnErBTjTomhchTMlj39n8fs9u15my9fw8rdemfGfg2pl+xiAtpVTx+tNCRaRRkWh0kV+bAH7
        By0QnSsW0HVVRgvs+zvmJPpL22bzQXqsNP45olvZTQH5enzedS+O6RVeevxPFsECZr30=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6JEi-00EFeY-Vi; Wed, 21 Jul 2021 22:54:36 +0200
Date:   Wed, 21 Jul 2021 22:54:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
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
Message-ID: <YPiJjEBV1PZQu0S/@lunn.ch>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721220716.539f780e@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Basically the LED name is of the format
> > >   devicename:color:function  

> Unfortunately there isn't consensus about what the devicename should
> mean. There are two "schools of thought":
> 
> 1. device name of the trigger source for the LED, i.e. if the LED
>    blinks on activity on mmc0, the devicename should be mmc0. We have
>    talked about this in the discussions about ethernet PHYs.
>    In the case of the igc driver if the LEDs are controlled by the MAC,
>    I guess some PCI identifier would be OK.

I guess this is most likely for Ethernet LEDs, some sort of bus
identifier. But Ethernet makes use of all sorts of busses, so you will
also see USB, memory mapped for SOCs, MDIO, SPI, etc.

> 2. device name of the LED controller. For example LEDs controlled by
>    the maxim,max77650-led controller (leds-max77650.c) define device
>    name as "max77650"

And what happens when the controller is just a tiny bit of silicon in
the corner of something else, not a standalone device? Would this be
'igc', for LEDs controlled by the IGC Ethernet controller? 'mv88e6xxx'
for Marvell Ethernet switches? 

Also, function is totally unclear. The whole reason we want to use
Linux LEDs is triggers, and it is the selected trigger which
determines the function.

Colour is also an issue. The IGC Ethernet controller has no idea what
colour the LEDs are in the RG-45 socket. And this is generic to
Ethernet MAC and PHY chips. The data sheets never mention colour.  You
might know the colour in DT (and maybe ACPI) systems where you have
specific information about the board. But in for PCIe card, USB
dongles, etc, colour is unknown.

So very little of the naming scheme actually makes sense in this
context.

	 Andrew

