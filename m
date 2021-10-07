Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491C142590A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243217AbhJGRPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243187AbhJGRPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 13:15:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3923961058;
        Thu,  7 Oct 2021 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633626825;
        bh=j0/YGPldZc0aZGMEp6CwCKqMygvHt12m0klDB6ibhNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DpjmVX8k0HHr3JN+8M54mMeTBueA9+ZASt/YCwLQwiqoaYbcBt/WRCyCIHiCk76WM
         THX2gG2M703UyOBtGLDeR7L2jQBNFOu2lAUWaR9cy25g4w5odHhiJQzYLVjSaQnGYa
         Qr0YOduhr/8geMTDTGlLvPWwTEryT3HV7i+U2xKyabwRmhhVhDoxfF1JDXlMuF+T2J
         dCXku49/1TUzI9axIUmMGrLqnYCmnWwm/HG9IBMtigcnpW5mV62HEmMT5bikFk9vA+
         Qn8fU1ZmZBeAPQRyKnBrXq2CG5eoGiIfONyngONqC1FSLfFo1kXCJb8Q0ta/likiv3
         A4EbR7s7xsygw==
Date:   Thu, 7 Oct 2021 19:13:41 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211007191341.0fc65dfc@thinkpad>
In-Reply-To: <YV2dKZIwxcFkU798@lunn.ch>
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
        <YV2dKZIwxcFkU798@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 14:57:13 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > I agree with having a list, and we use the combination. If the
> > > combination is not possible by the hardware, then -EINVAL, or
> > > -EOPNOTSUPP.
> > >   
> > > > - having separate functions for different link modes
> > > >     function = "link1000", "link100";    
> > > 
> > > I would suggest this, so you can use 
> > > 
> > > function = "link1000", "link100", "activity"  
> > 
> > The problem here is that LED core uses function to compose LED name:
> >   devicename:color:function
> > Should we use the first function? Then this LED will be named:
> >   ethphy42:green:link1000
> > but it also indicates link100...  
> 
> This makes no sense. Using function makes no sense, when the whole
> point of using the LED framework is we have a uniform way of
> setting/changing the function at run time.
>
> An LED called ethphy42:green:link1000 which is actually showing
> activity makes no sense.
>
> ethphy42:green:state would be a better name.  The function of the LED
> is to give you some idea of what the state of the PHY is. What state
> it actually indicates is up to the user.

The LED device name is supposed to reflect what the LED was dedicated
for by vendor. So if on the device chassis next to the LED there is an
icon or text indicating that the LED is supposed to show link, then the
function part of the LED name should be "link", no matter what the user
does with the LED during runtime.

In many cases the icon/text by the LED on the chassis says only something
like "wan" or "lanN". On Turris Omnia for example this is so, and the LED
is supposed to show link and blink on activity.

For LEDs on ethernet ports usually the port is dedicated (i.e. it is a
wan port or a lanN port), and the LEDs are also dedicated in some way
(for example green for link1000, blink on activity, yellow for link100).

Currently device tree binding for LEDs allows setting function and
function-enumerator, and there are only macros
  LED_FUNCTION_WAN	(expands to "wan")
  LED_FUNCTION_LAN	(expands to "lan")
So the device tree can specify:
  color = <LED_COLOR_ID_GREEN>;
  function = LED_FUNCTION_WAN;
and the LED will be called
  <devicename>:green:wan (with no devicename just green:wan)
or
  color = <LED_COLOR_ID_GREEN>;
  function = LED_FUNCTION_LAN;
  function-enumerator = <2>;
and the LED will be called
  <devicename>:green:lan-2

We need to somehow keep the function part of the LED name consistent
with what the LED was dedicated for by vendor, but also to be able to
set more specific trigger settings (link1000, link100, link10,
activity).

Maybe it would make sense to keep the first string in the function
property "lan" / "wan", and the other strings to specify more specific
functions?

> > No, my current ideas about the netdev trigger extension are as follows
> > (not yet complete):
> > 
> > $ cd /sys/.../<LED>
> > $ echo netdev >trigger	# To enable netdev trigger
> > $ echo eth0 >device_name
> > $ echo 1 >ext		# To enable extended netdev trigger.
> > 			# This will create directory modes if there is
> > 			# a PHY attached to the interface  
> > $ ls modes/		
> > 1000baseT_Full 100BaseT_Full 100BaseT_Half 10BaseT_Full 10BaseT_Half
> >
> > $ cd modes/1000baseT_Full
> > $ ls
> > brightness link rx tx interval
> > 
> > So basically if you enable the extended netdev trigger, you will get
> > all the standard netdev settings for each PHY mode. (With a little
> > change to support blinking on link.)
> > 
> > With this you can set the LED:
> >   ON when linked and speed=1000m or 100m, blink on activity
> > or
> >   blink with 50ms interval when speed=1000m
> >   blink with 100ms interval when speed=100m
> >   blink with 200ms interval when speed=10m
> > 
> > (Note that these don't need to be supported by PHY. We are talking
> >  about SW control. If the PHY supports some of these in HW, then the
> >  trigger can be offloaded.)  
> 
> I see a number of problems with this
> 
> 1) Not all PHYs support software control of the LEDs. i.e. software
> on/off. But they do support different blink modes. Just looking at the
> data sheets i have lying around like this:
> 
> LAN8740 
> KSZ8041
> 
> and i'm sure there are more. So these PHYs LEDs will always be in
> offloaded mode, you cannot do software blinking. But they do support
> multiple blinking modes, so we want to be able to control that.

I am aware of such LEDs. Currently the LED subsystem does not support
such LEDs. I wanted first to extend the LED API to support offloading,
and wanted to look at LEDs that only can be HW controlled later.

> 2) Marvell PHY i have the datasheet open for at the moment has no way
> to indicate duplex. So you cannot actually offload 100baseT_Full. You
> need to user to configure the same blink mode for both 100baseT_Full
> and then 100baseT_Half, so duplex is irrelevant, then you can offload
> it, which is not very obvious.

This was just a proposal, I have not written code for this yet. We can
do this by speed only, if it makes more sense.

> 3) phylib does not actually tell you what link mode the PHY is
> operating in. All you get is the resolved speed and duplex. And
> mapping speed an duplex back to a link mode is not obvious. Take for
> example 100baseT_Full & 100baseT1_Full. Both are 100Mbps, both full
> duplex. Currently there is no PHY which actually implements both, so
> currently you can work it out, but in general, you cannot. But this is
> very true for higher speeds, where the MAC is providing the PHY LED
> control, but ideally we want the same /sysfs interface:
> 
>         ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT = 23,
>         ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT = 24,
>         ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT = 25,
>         ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT = 26,
> 
> Are you suggesting 4 different directories for the same speed?
> 
> I think you need duplex, KR4/CR4/SR4/LR4, T1/T2 as separate
> attributes, which the LED might support, but are not required.

OK, it would make more sense to do this by speed only at first. And
later if someone needs to do it more specific, it can be extended.

$ cd /sys/class/leds/<LED>
$ echo netdev >trigger
$ echo speed >ext
$ ls modes
1000 100 10

Or maybe the subdirectories can be added by request:

$ cd /sys/class/leds/<LED>
$ echo netdev >trigger
$ cat ext
[none] speed link_mode
$ echo link_mode >ext
$ ls modes
add  delete
$ echo 40000baseKR4_Full >modes/add
$ ls modes
40000baseKR4_Full  add  delete

> 4) Software blinking can add quite a lot of overhead. Getting the
> counters from the device can be expensive, particularly for Ethernet
> switches on slow busses. If anybody sets the interval to 5ms, they
> could saturate the MDIO bus. And blinking the LEDs is not for free.

This is how the netdev trigger works currently. I just wanted first to
extend it to support in SW things that are offloadable to some HW.

You are right that MDIO bus can be slow and saturated by SW blinking,
that is why we need offloading.

Also currently netdev trigger blink on activity does not work for DSA
switch ports (at least not for mv88e6xxx), unless the packet goes to
CPU also, since the trigger looks at CPU interface stats...

> So either we need to indicate if software or hardware is used, or we
> should limit the choices to those which the hardware can actually do,
> so we guarantee offload.

I think we should indicate whether the trigger is offloaded and let the
user control the LED also in SW. An utility (ledtool) can be written
which could then list HW offloadable modes and let the user choose only
between those.

Marek
