Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29530492D23
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347639AbiARSUY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 13:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347553AbiARSUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:20:20 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1FEC061574;
        Tue, 18 Jan 2022 10:20:18 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3EA05FF807;
        Tue, 18 Jan 2022 18:20:15 +0000 (UTC)
Date:   Tue, 18 Jan 2022 19:20:13 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v3 07/41] net: ieee802154: mcr20a: Fix lifs/sifs periods
Message-ID: <20220118192013.46c42f82@xps13>
In-Reply-To: <CAB_54W5_XoTk=DzMmm33csrEKe3m97KnNWnktRiyJsk7vfxO6w@mail.gmail.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
        <20220117115440.60296-8-miquel.raynal@bootlin.com>
        <CAB_54W5_XoTk=DzMmm33csrEKe3m97KnNWnktRiyJsk7vfxO6w@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Mon, 17 Jan 2022 17:52:10 -0500:

> Hi,
> 
> On Mon, 17 Jan 2022 at 06:54, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > These periods are expressed in time units (microseconds) while 40 and 12
> > are the number of symbol durations these periods will last. We need to
> > multiply them both with phy->symbol_duration in order to get these
> > values in microseconds.
> >
> > Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/mcr20a.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> > index f0eb2d3b1c4e..e2c249aef430 100644
> > --- a/drivers/net/ieee802154/mcr20a.c
> > +++ b/drivers/net/ieee802154/mcr20a.c
> > @@ -976,8 +976,8 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> >         dev_dbg(printdev(lp), "%s\n", __func__);
> >
> >         phy->symbol_duration = 16;
> > -       phy->lifs_period = 40;
> > -       phy->sifs_period = 12;
> > +       phy->lifs_period = 40 * phy->symbol_duration;
> > +       phy->sifs_period = 12 * phy->symbol_duration;  
> 
> I thought we do that now in register_hw(). Why does this patch exist?

The lifs and sifs period are wrong.

Fixing this silently by generalizing the calculation is simply wrong. I
feel we need to do this in order:
1- Fix the period because it is wrong.
2- Now that the period is set to a valid value and the core is able to
   do the same operation and set the variables to an identical content,
   we can drop these lines from the driver. 

#2 being a mechanical change, doing it without #1 means that something
that appears harmless actually changes the behavior of the driver. We
generally try to avoid that, no?

Thanks,
Miquèl
