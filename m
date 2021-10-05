Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDA042341A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 01:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhJEXIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 19:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236898AbhJEXIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 19:08:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72965611C3;
        Tue,  5 Oct 2021 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633475171;
        bh=pImpjV3oik1V6m7jNP8D4xHxOdiqpF8Fz8EVHZ83rjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OBit6HWictHggCKxYMEgvW8AB6ltmiU6y09bgCzPzu/e9leUnlJ3Qjahs4rPWiNKW
         gwNC1m9UOvXpXnuKgVhA9lIyDqBLTYT9zxtDmJu61whI9e6uAmzGeou2CpbF0C3Ow4
         fPnFM9Z9PcJCDUys6+V4vr61HYpL5F2sX7bpgTNsIwEqdT9rSzAVIn8b6TE53XPznE
         V1xGyF//jXrcOJT7PQoey7zcMjfT8aKaFCKsBWmCx1sRFqmwgBHAlFW8RdlceWooEl
         Q+oAEHzOjDTYld9duW9sfjr856rKVtQRPd0j3qofYLg7a2rt567FZkcqMUJ8ZFwGFZ
         zjtIie5kdPbfw==
Date:   Wed, 6 Oct 2021 01:06:06 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211006010606.15d7370b@thinkpad>
In-Reply-To: <YVzMghbt1+ZSILpQ@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
        <YVn815h7JBtVSfwZ@lunn.ch>
        <20211003212654.30fa43f5@thinkpad>
        <YVsUodiPoiIESrEE@lunn.ch>
        <20211004170847.3f92ef48@thinkpad>
        <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
        <20211005222657.7d1b2a19@thinkpad>
        <YVy9Ho47XeVON+lB@lunn.ch>
        <20211005234342.7334061b@thinkpad>
        <YVzMghbt1+ZSILpQ@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 00:06:58 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > I suggest we start with simple independent LEDs. That gives enough to
> > > support the majority of use cases people actually need. And is enough
> > > to unblock people who i keep NACKing patches and tell them to wait for
> > > this work to get merged.  
> > 
> > Of course, and I plan to do so. Those netdev trigger extensions and
> > multi-color function definitions are for later :)  
> 
> Great.
>  
> > We got side tracked in this discussion, sorry about that.
> > 
> > In this thread I just wanted to settle the LED function property for
> > LEDs indicating network ports.
> > 
> > So would you, Andrew, agree with:
> > - extending function property to be array of strings instead of only
> >   one string, so that we can do
> >     function = "link", "activity";  
> 
> I agree with having a list, and we use the combination. If the
> combination is not possible by the hardware, then -EINVAL, or
> -EOPNOTSUPP.
> 
> > - having separate functions for different link modes
> >     function = "link1000", "link100";  
> 
> I would suggest this, so you can use 
> 
> function = "link1000", "link100", "activity"

The problem here is that LED core uses function to compose LED name:
  devicename:color:function
Should we use the first function? Then this LED will be named:
  ethphy42:green:link1000
but it also indicates link100...

> What could be interesting is how you do this in sysfs?  How do you
> enumerate what the hardware can do? How do you select what you want?

This is again sidetrack from the original discussion, which was only
meant to discuss DT, but okay :)

> Do you need to do
> 
> echo "link1000 link100 activity" > /sys/class/net/eth0/phy/led/function
> 
> And we can have something like
> 
> cat /sys/class/net/eth0/phy/led/function
> activity
> link10 activity
> link100 activity
> link1000 activity
> [link100 link1000 activity]
> link10
> link100
> link1000

No, my current ideas about the netdev trigger extension are as follows
(not yet complete):

$ cd /sys/.../<LED>
$ echo netdev >trigger	# To enable netdev trigger
$ echo eth0 >device_name
$ echo 1 >ext		# To enable extended netdev trigger.
			# This will create directory modes if there is
			# a PHY attached to the interface  
$ ls modes/		
1000baseT_Full 100BaseT_Full 100BaseT_Half 10BaseT_Full 10BaseT_Half

$ cd modes/1000baseT_Full
$ ls
brightness link rx tx interval

So basically if you enable the extended netdev trigger, you will get
all the standard netdev settings for each PHY mode. (With a little
change to support blinking on link.)

With this you can set the LED:
  ON when linked and speed=1000m or 100m, blink on activity
or
  blink with 50ms interval when speed=1000m
  blink with 100ms interval when speed=100m
  blink with 200ms interval when speed=10m

(Note that these don't need to be supported by PHY. We are talking
 about SW control. If the PHY supports some of these in HW, then the
 trigger can be offloaded.)

Marek
