Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BBB49B302
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381316AbiAYLhL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jan 2022 06:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350694AbiAYLdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 06:33:03 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5962C061744;
        Tue, 25 Jan 2022 03:33:00 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A601420000A;
        Tue, 25 Jan 2022 11:32:56 +0000 (UTC)
Date:   Tue, 25 Jan 2022 12:32:55 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next v2 8/9] net: mac802154: Explain the use of
 ieee802154_wake/stop_queue()
Message-ID: <20220125123255.05fef400@xps13>
In-Reply-To: <CAB_54W6dCoEinhdq-HAQj0CQ9_wf-xK9ESOfvB6K4JMwHo7Vaw@mail.gmail.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
        <20220120112115.448077-9-miquel.raynal@bootlin.com>
        <CAB_54W6dCoEinhdq-HAQj0CQ9_wf-xK9ESOfvB6K4JMwHo7Vaw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 23 Jan 2022 15:56:22 -0500:

> Hi,
> 
> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > It is not straightforward to the newcomer that a single skb can be sent
> > at a time and that the internal process is to stop the queue when
> > processing a frame before re-enabling it. Make this clear by documenting
> > the ieee802154_wake/stop_queue() helpers.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/mac802154.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> > index d524ffb9eb25..94b2e3008e77 100644
> > --- a/include/net/mac802154.h
> > +++ b/include/net/mac802154.h
> > @@ -464,6 +464,12 @@ void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb,
> >   * ieee802154_wake_queue - wake ieee802154 queue
> >   * @hw: pointer as obtained from ieee802154_alloc_hw().
> >   *
> > + * Tranceivers have either one transmit framebuffer or one framebuffer for both
> > + * transmitting and receiving. Hence, the core only handles one frame at a time  
> 
> this is not a fundamental physical law, they might exist but not supported yet.

I think it's important to explain why we call these helpers
before/after transmissions. I've reworded the beginning of the sentence
to: "Tranceivers usually have..." to reflect that this is the current
state of the support, but is not marble solid either. I've also updated
the second sentence about the core "Hence, the core currently only
handles..."

> > + * for each phy, which means we had to stop the queue to avoid new skb to come
> > + * during the transmission. The queue then needs to be woken up after the
> > + * operation.
> > + *
> >   * Drivers should use this function instead of netif_wake_queue.  
> 
> It's a must.
>
> >   */
> >  void ieee802154_wake_queue(struct ieee802154_hw *hw);
> > @@ -472,6 +478,12 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw);
> >   * ieee802154_stop_queue - stop ieee802154 queue
> >   * @hw: pointer as obtained from ieee802154_alloc_hw().
> >   *
> > + * Tranceivers have either one transmit framebuffer or one framebuffer for both
> > + * transmitting and receiving. Hence, the core only handles one frame at a time
> > + * for each phy, which means we need to tell upper layers to stop giving us new
> > + * skbs while we are busy with the transmitted one. The queue must then be
> > + * stopped before transmitting.
> > + *
> >   * Drivers should use this function instead of netif_stop_queue.
> >   */
> >  void ieee802154_stop_queue(struct ieee802154_hw *hw);  
> 
> Same for stop, stop has something additional here... it is never used
> by any driver because we do that on mac802154 layer. Simply, they
> don't use this function.

That's true, and this is addressed in a later series where we actually
stop exporting these helpers because we want everything to be handled
by the _xmit_complete/error() helpers and keep full control of the
queue. The comments added above will remain because they are useful to
understand why these helpers are called. But the last sentence above
their use from drivers being preferred to the netif_ calls will be
dropped.

Thanks,
Miquèl
