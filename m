Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1A265FDA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 14:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgIKMyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 08:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgIKMwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 08:52:17 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C4C061756;
        Fri, 11 Sep 2020 05:52:15 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 16469140854;
        Fri, 11 Sep 2020 14:52:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599828732; bh=FQBrLZyjtqOWsYrOkoBZhbIGm6CcKwNST13WWl6Abic=;
        h=Date:From:To;
        b=xzKaYk8B+ogEJa3dLTY0z2qVUOhw/JO4fnzug+rzs2yfm0mNkvc+yDY9WZDdyu7/4
         S0DvbTsSvc/U6qPT3PeGjxcEAw5lnYnmGpo6IFjF0uwdJVA10cHCzyGeMBnoYurSCY
         2CLx5hMeVePD6dbE22AYRpHH8KKV1sFCh0rt2HlM=
Date:   Fri, 11 Sep 2020 14:52:11 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200911145211.0bc3942b@dellmb.labs.office.nic.cz>
In-Reply-To: <3d4dd05f2597c66fb429580095eed91c2b3be76a.camel@ew.tq-group.com>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-7-marek.behun@nic.cz>
        <20200910122341.GC7907@duo.ucw.cz>
        <20200910131541.GD3316362@lunn.ch>
        <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
        <20200910150040.GB3354160@lunn.ch>
        <3d4dd05f2597c66fb429580095eed91c2b3be76a.camel@ew.tq-group.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 09:12:01 +0200
Matthias Schiffer <matthias.schiffer@ew.tq-group.com> wrote:

> On Thu, 2020-09-10 at 17:00 +0200, Andrew Lunn wrote:
> > > I propose that at least these HW modes should be available (and
> > > documented) for ethernet PHY controlled LEDs:
> > >   mode to determine link on:
> > >     - `link`
> > >   mode for activity (these should blink):
> > >     - `activity` (both rx and tx), `rx`, `tx`
> > >   mode for link (on) and activity (blink)
> > >     - `link/activity`, maybe `link/rx` and `link/tx`
> > >   mode for every supported speed:
> > >     - `1Gbps`, `100Mbps`, `10Mbps`, ...
> > >   mode for every supported cable type:
> > >     - `copper`, `fiber`, ... (are there others?)  
> > 
> > In theory, there is AUI and BNC, but no modern device will have
> > these.
> >   
> > >   mode that allows the user to determine link speed
> > >     - `speed` (or maybe `linkspeed` ?)
> > >     - on some Marvell PHYs the speed can be determined by how fast
> > >       the LED is blinking (ie. 1Gbps blinks with default blinking
> > >       frequency, 100Mbps with half blinking frequeny of 1Gbps,
> > > 10Mbps
> > >       of half blinking frequency of 100Mbps)
> > >     - on other Marvell PHYs this is instead:
> > >       1Gpbs blinks 3 times, pause, 3 times, pause, ...
> > >       100Mpbs blinks 2 times, pause, 2 times, pause, ...
> > >       10Mpbs blinks 1 time, pause, 1 time, pause, ...
> > >     - we don't need to differentiate these modes with different
> > > names,
> > >       because the important thing is just that this mode allows
> > > the user to determine the speed from how the LED blinks
> > >   mode to just force blinking
> > >     - `blink`
> > > The nice thing is that all this can be documented and done in
> > > software
> > > as well.  
> > 
> > Have you checked include/dt-bindings/net/microchip-lan78xx.h and
> > mscc-phy-vsc8531.h ? If you are defining something generic, we need
> > to
> > make sure the majority of PHYs can actually do it. There is no
> > standardization in this area. I'm sure there is some similarity,
> > there
> > is only so many ways you can blink an LED, but i suspect we need a
> > mixture of standardized modes which we hope most PHYs implement, and
> > the option to support hardware specific modes.
> > 
> >     Andrew  
> 
> 
> FWIW, these are the LED HW trigger modes supported by the TI DP83867
> PHY:
> 
> - Receive Error
> - Receive Error or Transmit Error

Does somebody use this? I would just omit these.

> - Link established, blink for transmit or receive activity

`link/activity`

> - Full duplex

Not needed for now, I think.

> - 100/1000BT link established
> - 10/100BT link established

Disjunctive modes can go f*** themselves :)

> - 10BT link established
> - 100BT link established
> - 1000BT link established

`10Mbps`, `100Mbps`, `1Gbps`

> - Collision detected

Not needed for now.

> - Receive activity
> - Transmit activity

`rx/tx`

> - Receive or Transmit activity

`activity`

> - Link established

`link`

> 
> AFAIK, the "Link established, blink for transmit or receive activity"
> is the only trigger that involves blinking; all other modes simply
> make the LED light up when the condition is met. Setting the output
> level in software is also possible.
> 
> Regarding the option to emulate unsupported HW triggers in software,
> two questions come to my mind:
> 
> - Do all PHYs support manual setting of the LED level, or are the PHYs
> that can only work with HW triggers?
> - Is setting PHY registers always efficiently possible, or should SW
> triggers be avoided in certain cases? I'm thinking about setups like
> mdio-gpio. I guess this can only become an issue for triggers that
> blink.

The software trigger do not have to work with the LED connected to the
PHY. Any other LED on the system can be used. Only the information
about link and speed must come from the PHY, and kernel does have this
information already, either by polling or from interrupt.

> 
> 
> Kind regards,
> Matthias
> 

