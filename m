Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B0E265119
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgIJUnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgIJUlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:41:49 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7991CC061757;
        Thu, 10 Sep 2020 13:41:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 81BBB13FD86;
        Thu, 10 Sep 2020 22:41:46 +0200 (CEST)
Date:   Thu, 10 Sep 2020 22:41:46 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25k?= =?UTF-8?B?xZllag==?= Jirman 
        <megous@megous.com>, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910224146.60d21a60@nic.cz>
In-Reply-To: <20200910202345.GA18431@ucw.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-7-marek.behun@nic.cz>
        <20200910122341.GC7907@duo.ucw.cz>
        <20200910131541.GD3316362@lunn.ch>
        <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
        <20200910202345.GA18431@ucw.cz>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 22:23:45 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > Okay, so the netdev trigger offers modes `link`, `rx`, `tx`.
> > You can enable/disable either of these (via separate sysfs files). `rx`
> > and `tx` blink the LED, `link` turns the LED on if the interface is
> > linked.  
> 
> I wonder if people really need separate rx and tx, but... this sounds
> reasonable.
> 
> > The phy_led_trigger subsystem works differently. Instead of registering
> > one trigger (like netdev) it registers one trigger per PHY device and
> > per speed. So for a PHY with name XYZ and supported speeds 1Gbps,
> > 100Mbps, 10Mbps it registers 3 triggers:
> >   XYZ:1Gbps XYZ:100Mbps XYZ:10Mbps  
> 
> That is not reasonable.
> 
> > I propose that at least these HW modes should be available (and
> > documented) for ethernet PHY controlled LEDs:  
> 
> Ok, and which of these will you actually use?
> 
> >   mode to determine link on:
> >     - `link`
> >   mode for activity (these should blink):
> >     - `activity` (both rx and tx), `rx`, `tx`
> >   mode for link (on) and activity (blink)
> >     - `link/activity`, maybe `link/rx` and `link/tx`
> >   mode for every supported speed:
> >     - `1Gbps`, `100Mbps`, `10Mbps`, ...
> >   mode for every supported cable type:
> >     - `copper`, `fiber`, ... (are there others?)  
> 
> That's ... way too many options.
> 
> Can we do it like netdev trigger? link? yes/no. rx? yes/no. tx? yes/no.
> 
> If displaying link only for certain speeds is useful, have link_min
> and link_max, specifying values in Mbps? Default would be link_min ==
> 0, and link_max = 25000, so it would react on any link speed.
> 
> Is mode for cable type really useful? Then we should have link_fiber?
> yes/no. link_copper? yes/no.
> 

I want to put the speed differentiating mode by default on MOX on one
LED, and activity on other LED.

I think there are devices which have written on the case next to the
LED that this LED is on for this specific speed, that LED is on for
other specific speed. So modes for speed are reasonable, I think.

In my opinion the disjunctive modes the Marvell PHYs support are useless
(like ON when 1000Mbps or 10Mbps).

You can't have link_min and link_max setting. The hardware does not
support it this way. You can tell the hardware to light the LED when
linked on a specific speed, and this is actually used on some devices
(as I have written above, some devices have this written on the case).

In my opinion the set `link`, `link/activity`, `activity`, `speed`,
and one mode for each supported speed on the PHY is reasonable. This could
be also compatible with software triggering via the proposed phydev
trigger.

> >   mode that allows the user to determine link speed
> >     - `speed` (or maybe `linkspeed` ?)
> >     - on some Marvell PHYs the speed can be determined by how fast
> >       the LED is blinking (ie. 1Gbps blinks with default blinking
> >       frequency, 100Mbps with half blinking frequeny of 1Gbps, 10Mbps
> >       of half blinking frequency of 100Mbps)
> >     - on other Marvell PHYs this is instead:
> >       1Gpbs blinks 3 times, pause, 3 times, pause, ...
> >       100Mpbs blinks 2 times, pause, 2 times, pause, ...
> >       10Mpbs blinks 1 time, pause, 1 time, pause, ...
> >     - we don't need to differentiate these modes with different names,
> >       because the important thing is just that this mode allows the
> >       user to determine the speed from how the LED blinks  
> 
> I'd be very careful. Userspace should know what they are asking
> for. I'd propose simply ignoring this feature.

As I wrote above, I think this mode is rather useful when you have just
two LEDs for a port. You can tell speed by looking on one LED and
activity by looking at the other LED. And I want to set this as default
on Turris MOX.

> >   mode to just force blinking - `blink`  
> 
> We already have different support for blinking in LED subsystem. Lets use that.
> 
> Best regards,
> 									Pavel

