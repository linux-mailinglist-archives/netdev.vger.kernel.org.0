Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048A748D542
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiAMJwp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jan 2022 04:52:45 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:35933 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiAMJwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:52:44 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id D6E90240007;
        Thu, 13 Jan 2022 09:52:32 +0000 (UTC)
Date:   Thu, 13 Jan 2022 10:52:31 +0100
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
Subject: Re: [wpan-next v2 06/27] net: mac802154: Set the symbol duration
 automatically
Message-ID: <20220113105231.4c1728fd@xps13>
In-Reply-To: <CAB_54W68GQmsV70w0uUWvz8-V_Yf+FHfc23k2es53REqWMBY8Q@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-7-miquel.raynal@bootlin.com>
        <CAB_54W68GQmsV70w0uUWvz8-V_Yf+FHfc23k2es53REqWMBY8Q@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:25:01 -0500:

> Hi,
> 
> On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Now that we have access to all the basic information to know which
> > symbol duration should be applied, let's set the symbol duration
> > automatically. The two locations that must call for the symbol duration
> > to be set are:
> > - when manually requesting a channel change though the netlink interface
> > - at PHY creation, ieee802154_alloc_hw() already calls
> >   ieee802154_change_channel() which will now update the symbol duration
> >   accordingly.
> >
> > If an information is missing, the symbol duration is not touched, a
> > debug message is eventually printed. This keeps the compatibility with
> > the unconverted drivers for which it was too complicated for me to find
> > their precise information. If they initially provided a symbol duration,
> > it would be kept. If they don't, the symbol duration value is left
> > untouched.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h |  2 +
> >  net/mac802154/cfg.c     |  1 +
> >  net/mac802154/main.c    | 93 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 96 insertions(+)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 286709a9dd0b..52eefc4b5b4d 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -455,4 +455,6 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
> >         return dev_name(&phy->dev);
> >  }
> >
> > +void ieee802154_set_symbol_duration(struct wpan_phy *phy);
> > +
> >  #endif /* __NET_CFG802154_H */
> > diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> > index 6969f1330ccd..ba57da07c08e 100644
> > --- a/net/mac802154/cfg.c
> > +++ b/net/mac802154/cfg.c
> > @@ -113,6 +113,7 @@ int ieee802154_change_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
> >         if (!ret) {
> >                 wpan_phy->current_page = page;
> >                 wpan_phy->current_channel = channel;
> > +               ieee802154_set_symbol_duration(wpan_phy);
> >         }
> >
> >         return ret;  
> 
> We also need to do it in ieee802154_register_hw()?

As you probably saw, my idea was to call for a channel change during
the registration but you nacked that possibility so I'll indeed have
to set the symbol duration manually there.

> > diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> > index 77a4943f345f..88826c5aa4ba 100644
> > --- a/net/mac802154/main.c
> > +++ b/net/mac802154/main.c
> > @@ -113,6 +113,99 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
> >  }
> >  EXPORT_SYMBOL(ieee802154_alloc_hw);
> >
> > +void ieee802154_set_symbol_duration(struct wpan_phy *phy)
> > +{
> > +       struct phy_page *page = &phy->supported.page[phy->current_page];
> > +       struct phy_channels *chan;
> > +       unsigned int chunk;
> > +       u32 duration = 0;
> > +
> > +       for (chunk = 0; chunk < page->nchunks; chunk++) {
> > +               if (page->chunk[chunk].channels & phy->current_channel)

.channels still being a bitfield, David allegedly reported that the
above line should use "& BIT(phy->current_channel)".

> > +                       break;
> > +       }
> > +
> > +       if (chunk == page->nchunks)
> > +               goto set_duration;
> > +
> > +       chan = &page->chunk[chunk];
> > +       switch (chan->protocol) {
> > +       case IEEE802154_BPSK_PHY:
> > +               switch (chan->band) {
> > +               case IEEE802154_868_MHZ_BAND:
> > +                       /* 868 MHz BPSK 802.15.4-2003: 20 ksym/s */
> > +                       duration = 50 * 1000;  
> 
> * NSEC_PER_USEC?

Oh right, I grepped for USEC_TO_NSEC but the macro was named the other
way around, thanks.

Thanks,
Miquèl
