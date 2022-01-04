Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33E8484508
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiADPoz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jan 2022 10:44:55 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38821 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbiADPoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:44:54 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id BE972E0005;
        Tue,  4 Jan 2022 15:44:50 +0000 (UTC)
Date:   Tue, 4 Jan 2022 16:44:49 +0100
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
Message-ID: <20220104164449.1179bfc7@xps13>
In-Reply-To: <CAB_54W7BeSA+2GVzb9Yvz1kj12wkRSqHj9Ybr8cK7oYd7804RQ@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-2-miquel.raynal@bootlin.com>
        <CAB_54W7BeSA+2GVzb9Yvz1kj12wkRSqHj9Ybr8cK7oYd7804RQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Tue, 28 Dec 2021 16:05:43 -0500:

> Hi,
> 
> On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > A default channel is selected by default (13), let's clarify that this
> > is page 0 channel 13. Call the right helper to ensure the necessary
> > configuration for this channel has been applied.
> >
> > So far there is very little configuration done in this helper but we
> > will soon add more information (like the symbol duration which is
> > missing) and having this helper called at probe time will prevent us to
> > this type of initialization at two different locations.
> >  
> 
> I see why this patch is necessary because in later patches the symbol
> duration is set at ".set_channel()" callback like the at86rf230 driver
> is doing it.
> However there is an old TODO [0]. I think we should combine it and
> implement it in ieee802154_set_channel() of "net/mac802154/cfg.c".
> Also do the symbol duration setting according to the channel/page when
> we call ieee802154_register_hw(), so we have it for the default
> settings.

While I totally agree on the background idea, I don't really see how
this is possible. Every driver internally knows what it supports but
AFAIU the core itself has no easy and standard access to it?

Another question that I have: is the protocol and center frequency
enough to always derive the symbol rate? I am not sure this is correct,
but I thought not all symbol rates could be derived, like for example
certain UWB PHY protocols which can use different PRF on a single
channel which has an effect on the symbol duration?

> > So far there is very little configuration done in this helper but thanks
> > to this improvement, future enhancements in this area (like setting a
> > symbol duration, which is missing) will be reflected automatically in
> > the default probe state.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/mac802154_hwsim.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> > index 62ced7a30d92..b1a4ee7dceda 100644
> > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > @@ -778,8 +778,6 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
> >
> >         ieee802154_random_extended_addr(&hw->phy->perm_extended_addr);
> >
> > -       /* hwsim phy channel 13 as default */
> > -       hw->phy->current_channel = 13;
> >         pib = kzalloc(sizeof(*pib), GFP_KERNEL);
> >         if (!pib) {
> >                 err = -ENOMEM;
> > @@ -793,6 +791,11 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
> >         hw->flags = IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_RX_DROP_BAD_CKSUM;  
> 
> sadly this patch doesn't apply on current net-next/master because
> IEEE802154_HW_RX_DROP_BAD_CKSUM is not set.
> I agree that it should be set, so we need a patch for it.

Right, I just have a patch aside setting this to enforce beacons
checksum were good. I can certainly set this flag officially.

> 
> - Alex
> 
> [0] https://elixir.bootlin.com/linux/v5.16-rc7/source/drivers/net/ieee802154/at86rf230.c#L1059


Thanks,
Miquèl
