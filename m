Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1CB423E4C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbhJFM7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 08:59:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhJFM7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 08:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mcQKLrjxCFxhK+ZZr+q0udiWKjAsG60P9AaYB0vD6PY=; b=ghpvyJtYH7nKsEt5feHpqAgL3+
        8hmCPGjgQHGSpL5sgNi2Ky8NfmymY097jVa+XQeyg6049zngTmPcSvPiJSYnjYFxUHhO7qGCEy3Wz
        eSwHaQVnb0STOM77Ha5Iubk/eFyLZt2YhdJ1PLIOgTIUDp7Hy8jRrKjNVKKy4KK0GFAk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mY6Tx-009prV-VH; Wed, 06 Oct 2021 14:57:13 +0200
Date:   Wed, 6 Oct 2021 14:57:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YV2dKZIwxcFkU798@lunn.ch>
References: <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad>
 <YVsUodiPoiIESrEE@lunn.ch>
 <20211004170847.3f92ef48@thinkpad>
 <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
 <20211005222657.7d1b2a19@thinkpad>
 <YVy9Ho47XeVON+lB@lunn.ch>
 <20211005234342.7334061b@thinkpad>
 <YVzMghbt1+ZSILpQ@lunn.ch>
 <20211006010606.15d7370b@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006010606.15d7370b@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I agree with having a list, and we use the combination. If the
> > combination is not possible by the hardware, then -EINVAL, or
> > -EOPNOTSUPP.
> > 
> > > - having separate functions for different link modes
> > >     function = "link1000", "link100";  
> > 
> > I would suggest this, so you can use 
> > 
> > function = "link1000", "link100", "activity"
> 
> The problem here is that LED core uses function to compose LED name:
>   devicename:color:function
> Should we use the first function? Then this LED will be named:
>   ethphy42:green:link1000
> but it also indicates link100...

This makes no sense. Using function makes no sense, when the whole
point of using the LED framework is we have a uniform way of
setting/changing the function at run time.

An LED called ethphy42:green:link1000 which is actually showing
activity makes no sense.

ethphy42:green:state would be a better name.  The function of the LED
is to give you some idea of what the state of the PHY is. What state
it actually indicates is up to the user.

> > What could be interesting is how you do this in sysfs?  How do you
> > enumerate what the hardware can do? How do you select what you want?
> 
> This is again sidetrack from the original discussion, which was only
> meant to discuss DT, but okay :)
> 
> > Do you need to do
> > 
> > echo "link1000 link100 activity" > /sys/class/net/eth0/phy/led/function
> > 
> > And we can have something like
> > 
> > cat /sys/class/net/eth0/phy/led/function
> > activity
> > link10 activity
> > link100 activity
> > link1000 activity
> > [link100 link1000 activity]
> > link10
> > link100
> > link1000
> 
> No, my current ideas about the netdev trigger extension are as follows
> (not yet complete):
> 
> $ cd /sys/.../<LED>
> $ echo netdev >trigger	# To enable netdev trigger
> $ echo eth0 >device_name
> $ echo 1 >ext		# To enable extended netdev trigger.
> 			# This will create directory modes if there is
> 			# a PHY attached to the interface  
> $ ls modes/		
> 1000baseT_Full 100BaseT_Full 100BaseT_Half 10BaseT_Full 10BaseT_Half
>
> $ cd modes/1000baseT_Full
> $ ls
> brightness link rx tx interval
> 
> So basically if you enable the extended netdev trigger, you will get
> all the standard netdev settings for each PHY mode. (With a little
> change to support blinking on link.)
> 
> With this you can set the LED:
>   ON when linked and speed=1000m or 100m, blink on activity
> or
>   blink with 50ms interval when speed=1000m
>   blink with 100ms interval when speed=100m
>   blink with 200ms interval when speed=10m
> 
> (Note that these don't need to be supported by PHY. We are talking
>  about SW control. If the PHY supports some of these in HW, then the
>  trigger can be offloaded.)

I see a number of problems with this

1) Not all PHYs support software control of the LEDs. i.e. software
on/off. But they do support different blink modes. Just looking at the
data sheets i have lying around like this:

LAN8740 
KSZ8041

and i'm sure there are more. So these PHYs LEDs will always be in
offloaded mode, you cannot do software blinking. But they do support
multiple blinking modes, so we want to be able to control that.

2) Marvell PHY i have the datasheet open for at the moment has no way
to indicate duplex. So you cannot actually offload 100baseT_Full. You
need to user to configure the same blink mode for both 100baseT_Full
and then 100baseT_Half, so duplex is irrelevant, then you can offload
it, which is not very obvious.

3) phylib does not actually tell you what link mode the PHY is
operating in. All you get is the resolved speed and duplex. And
mapping speed an duplex back to a link mode is not obvious. Take for
example 100baseT_Full & 100baseT1_Full. Both are 100Mbps, both full
duplex. Currently there is no PHY which actually implements both, so
currently you can work it out, but in general, you cannot. But this is
very true for higher speeds, where the MAC is providing the PHY LED
control, but ideally we want the same /sysfs interface:

        ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT = 23,
        ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT = 24,
        ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT = 25,
        ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT = 26,

Are you suggesting 4 different directories for the same speed?

I think you need duplex, KR4/CR4/SR4/LR4, T1/T2 as separate
attributes, which the LED might support, but are not required.

4) Software blinking can add quite a lot of overhead. Getting the
counters from the device can be expensive, particularly for Ethernet
switches on slow busses. If anybody sets the interval to 5ms, they
could saturate the MDIO bus. And blinking the LEDs is not for free.
So either we need to indicate if software or hardware is used, or we
should limit the choices to those which the hardware can actually do,
so we guarantee offload.

   Andrew
