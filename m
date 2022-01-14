Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4F48E847
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 11:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbiANKVU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jan 2022 05:21:20 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53955 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbiANKVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 05:21:20 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 5B6D81C0008;
        Fri, 14 Jan 2022 10:21:15 +0000 (UTC)
Date:   Fri, 14 Jan 2022 11:21:13 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
Message-ID: <20220114112113.63661251@xps13>
In-Reply-To: <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-9-miquel.raynal@bootlin.com>
        <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
        <20220113121645.434a6ef6@xps13>
        <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Thu, 13 Jan 2022 18:34:00 -0500:

> Hi,
> 
> On Thu, 13 Jan 2022 at 06:16, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:26:14 -0500:
> >  
> > > Hi,
> > >
> > > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:  
> > > >
> > > > The core now knows how to set the symbol duration in a few cases, when
> > > > drivers correctly advertise the protocols used on each channel. For
> > > > these drivers, there is no more need to bother with symbol duration, so
> > > > just drop the duplicated code.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  drivers/net/ieee802154/ca8210.c | 1 -
> > > >  drivers/net/ieee802154/mcr20a.c | 2 --
> > > >  2 files changed, 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> > > > index 82b2a173bdbd..d3a9e4fe05f4 100644
> > > > --- a/drivers/net/ieee802154/ca8210.c
> > > > +++ b/drivers/net/ieee802154/ca8210.c
> > > > @@ -2977,7 +2977,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
> > > >         ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
> > > >         ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
> > > >         ca8210_hw->phy->cca_ed_level = -9800;
> > > > -       ca8210_hw->phy->symbol_duration = 16 * 1000;
> > > >         ca8210_hw->phy->lifs_period = 40;
> > > >         ca8210_hw->phy->sifs_period = 12;
> > > >         ca8210_hw->flags =
> > > > diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> > > > index 8aa87e9bf92e..da2ab19cb5ee 100644
> > > > --- a/drivers/net/ieee802154/mcr20a.c
> > > > +++ b/drivers/net/ieee802154/mcr20a.c
> > > > @@ -975,7 +975,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > > >
> > > >         dev_dbg(printdev(lp), "%s\n", __func__);
> > > >
> > > > -       phy->symbol_duration = 16 * 1000;
> > > >         phy->lifs_period = 40;
> > > >         phy->sifs_period = 12;
> > > >
> > > > @@ -1010,7 +1009,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > > >         phy->current_page = 0;
> > > >         /* MCR20A default reset value */
> > > >         phy->current_channel = 20;
> > > > -       phy->symbol_duration = 16 * 1000;
> > > >         phy->supported.tx_powers = mcr20a_powers;
> > > >         phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
> > > >         phy->cca_ed_level = phy->supported.cca_ed_levels[75];  
> > >
> > > What's about the atrf86230 driver?  
> >
> > I couldn't find reliable information about what this meant:
> >
> >         /* SUB:0 and BPSK:0 -> BPSK-20 */
> >         /* SUB:1 and BPSK:0 -> BPSK-40 */
> >         /* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
> >         /* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
> >
> > None of these comments match the spec so I don't know what to put
> > there. If you know what these protocols are, I will immediately
> > provide this information into the driver and ensure the core handles
> > these durations properly before dropping the symbol_durations settings
> > from the code.  
> 
> I think those are from the transceiver datasheets (which are free to
> access). Can you not simply merge them or is there a conflict?

Actually I misread the driver, it supports several kind of chips with
different channel settings and this disturbed me. I downloaded the
datasheet and figured that the number after the protocol is the bit
rate. This helped me to make the connection with what I already know,
so both atusb and atrf86230 drivers have been converted too.

Thanks,
Miquèl
