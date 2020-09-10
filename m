Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469592650AB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIJUYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:24:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35842 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgIJUYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:24:15 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C628D1C0B76; Thu, 10 Sep 2020 22:23:45 +0200 (CEST)
Date:   Thu, 10 Sep 2020 22:23:45 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-2?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        =?iso-8859-2?Q?Ond=F8ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910202345.GA18431@ucw.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

> Okay, so the netdev trigger offers modes `link`, `rx`, `tx`.
> You can enable/disable either of these (via separate sysfs files). `rx`
> and `tx` blink the LED, `link` turns the LED on if the interface is
> linked.

I wonder if people really need separate rx and tx, but... this sounds
reasonable.

> The phy_led_trigger subsystem works differently. Instead of registering
> one trigger (like netdev) it registers one trigger per PHY device and
> per speed. So for a PHY with name XYZ and supported speeds 1Gbps,
> 100Mbps, 10Mbps it registers 3 triggers:
>   XYZ:1Gbps XYZ:100Mbps XYZ:10Mbps

That is not reasonable.

> I propose that at least these HW modes should be available (and
> documented) for ethernet PHY controlled LEDs:

Ok, and which of these will you actually use?

>   mode to determine link on:
>     - `link`
>   mode for activity (these should blink):
>     - `activity` (both rx and tx), `rx`, `tx`
>   mode for link (on) and activity (blink)
>     - `link/activity`, maybe `link/rx` and `link/tx`
>   mode for every supported speed:
>     - `1Gbps`, `100Mbps`, `10Mbps`, ...
>   mode for every supported cable type:
>     - `copper`, `fiber`, ... (are there others?)

That's ... way too many options.

Can we do it like netdev trigger? link? yes/no. rx? yes/no. tx? yes/no.

If displaying link only for certain speeds is useful, have link_min
and link_max, specifying values in Mbps? Default would be link_min ==
0, and link_max = 25000, so it would react on any link speed.

Is mode for cable type really useful? Then we should have link_fiber?
yes/no. link_copper? yes/no.

>   mode that allows the user to determine link speed
>     - `speed` (or maybe `linkspeed` ?)
>     - on some Marvell PHYs the speed can be determined by how fast
>       the LED is blinking (ie. 1Gbps blinks with default blinking
>       frequency, 100Mbps with half blinking frequeny of 1Gbps, 10Mbps
>       of half blinking frequency of 100Mbps)
>     - on other Marvell PHYs this is instead:
>       1Gpbs blinks 3 times, pause, 3 times, pause, ...
>       100Mpbs blinks 2 times, pause, 2 times, pause, ...
>       10Mpbs blinks 1 time, pause, 1 time, pause, ...
>     - we don't need to differentiate these modes with different names,
>       because the important thing is just that this mode allows the
>       user to determine the speed from how the LED blinks

I'd be very careful. Userspace should know what they are asking
for. I'd propose simply ignoring this feature.

>   mode to just force blinking - `blink`

We already have different support for blinking in LED subsystem. Lets use that.

Best regards,
									Pavel
