Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C65484F22
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiAEIOs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Jan 2022 03:14:48 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:39521 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiAEIOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:14:47 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 66B3F24000D;
        Wed,  5 Jan 2022 08:14:43 +0000 (UTC)
Date:   Wed, 5 Jan 2022 09:14:41 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 01/18] ieee802154: hwsim: Ensure proper channel
 selection at probe time
Message-ID: <20220105091441.10e96b34@xps13>
In-Reply-To: <CAB_54W6o-wBD2wu7sohCD0ack5PR_wqc2NqOnYC6WEVV5VF8FQ@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-2-miquel.raynal@bootlin.com>
        <CAB_54W7BeSA+2GVzb9Yvz1kj12wkRSqHj9Ybr8cK7oYd7804RQ@mail.gmail.com>
        <20220104164449.1179bfc7@xps13>
        <CAB_54W6LG4SKdS4HDSj1o2A64UiA6BEv_Bh_5e9WCyyJKeAbtg@mail.gmail.com>
        <CAB_54W6o-wBD2wu7sohCD0ack5PR_wqc2NqOnYC6WEVV5VF8FQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Tue, 4 Jan 2022 18:10:44 -0500:

> Hi,
> 
> On Tue, 4 Jan 2022 at 18:08, Alexander Aring <alex.aring@gmail.com> wrote:
> >
> > Hi,
> >
> > On Tue, 4 Jan 2022 at 10:44, Miquel Raynal <miquel.raynal@bootlin.com> wrote:  
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Tue, 28 Dec 2021 16:05:43 -0500:
> > >  
> > > > Hi,
> > > >
> > > > On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:  
> > > > >
> > > > > A default channel is selected by default (13), let's clarify that this
> > > > > is page 0 channel 13. Call the right helper to ensure the necessary
> > > > > configuration for this channel has been applied.
> > > > >
> > > > > So far there is very little configuration done in this helper but we
> > > > > will soon add more information (like the symbol duration which is
> > > > > missing) and having this helper called at probe time will prevent us to
> > > > > this type of initialization at two different locations.
> > > > >  
> > > >
> > > > I see why this patch is necessary because in later patches the symbol
> > > > duration is set at ".set_channel()" callback like the at86rf230 driver
> > > > is doing it.
> > > > However there is an old TODO [0]. I think we should combine it and
> > > > implement it in ieee802154_set_channel() of "net/mac802154/cfg.c".
> > > > Also do the symbol duration setting according to the channel/page when
> > > > we call ieee802154_register_hw(), so we have it for the default
> > > > settings.  
> > >
> > > While I totally agree on the background idea, I don't really see how
> > > this is possible. Every driver internally knows what it supports but
> > > AFAIU the core itself has no easy and standard access to it?
> > >  
> >
> > I am a little bit confused here, because a lot of timing related
> > things in the phy information rate points to "x times symbols". If  
> 
> s/rate/base/

Yes indeed, but I bet it works because the phy drivers set the symbol
duration by themselves. You can see that none of them does something
clever like:

switch (phy.protocol) {
	case XXXXX:
		symbol_duration = y;
		break;
	...

Instead, they all go through the page/channel list in a quite hardcoded
way because the phy driver knows internally that protocol X is used on
{page, channel}, but the protocol id, while not being totally absent
from drivers, is always provided as a comment.

So getting rid of the core TODO you mentioned earlier means:
- Listing properly the PHY protocols in the core (if not already done)
- For each PHY protocol knowing the possible base frequencies
- For each of these base frequencies knowing the symbol duration
- Having the possibility to add more information such as the PRF in
  order to let the core pick the right symbol duration when there is
  more than one possibility for a {protocol, base frequency} couple
- Convert the phy drivers (at least hwsim) to fill these new fields
  correctly and expect the core to set the symbol duration properly.

Two side notes as well:
- I was not able to find all the the corresponding protocol from the
  hwsim driver in the spec (these channels are marked "unknown")
- The symbol duration in a few specific UWB cases is below 1us while
  the core expects a value in us. Should we change the symbol duration
  to ns?

I believe all this is doable in a reasonable time frame provided that
I only focus on the few protocols supported by hwsim which I already
"addressed" and perhaps a couple of simple drivers. On the core side,
the logic might be: "is the driver providing information about the phy
protocols used? if yes, then set the symbol duration if we have enough
data, otherwise let the driver handle it by itself". Such logic would
allow a progressive shift towards the situation where drivers do not
have to bother with symbol duration by themselves.

As this looks like a project on its own and my first goal was to be
able to use hwsim to demonstrate the different scan features, maybe we
can continue to discuss this and consider tackling it as a separate
series whish would apply on top of the current one, what do you think?

Thanks,
Miquèl
