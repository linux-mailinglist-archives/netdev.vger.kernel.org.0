Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBD0490481
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiAQJAa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jan 2022 04:00:30 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:59013 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiAQJA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 04:00:29 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B957E2000B;
        Mon, 17 Jan 2022 09:00:08 +0000 (UTC)
Date:   Mon, 17 Jan 2022 10:00:07 +0100
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
Subject: Re: [wpan-next v2 18/27] net: mac802154: Handle scan requests
Message-ID: <20220117094647.3cc5b4de@xps13>
In-Reply-To: <CAB_54W5xJV-3fxOUyvdxBBfUZWYx7JU=BDVhTHFcjJ7SOEdeUw@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-19-miquel.raynal@bootlin.com>
        <CAB_54W4PL1ty5XsqRoEKwsy-h8KL9gSGMK6N=HiWJDp6NHsb0A@mail.gmail.com>
        <20220113180709.0dade123@xps13>
        <CAB_54W4LdzH9=XS7-ZnxfyCMQFCTS-F5JkUmV+6HtWcCpUS-nQ@mail.gmail.com>
        <20220114194425.3df06391@xps13>
        <CAB_54W5xJV-3fxOUyvdxBBfUZWYx7JU=BDVhTHFcjJ7SOEdeUw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 16 Jan 2022 17:44:18 -0500:

> Hi,
> 
> On Fri, 14 Jan 2022 at 13:44, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Thu, 13 Jan 2022 19:01:56 -0500:
> >  
> > > Hi,
> > >
> > > On Thu, 13 Jan 2022 at 12:07, Miquel Raynal <miquel.raynal@bootlin.com> wrote:  
> > > >
> > > > Hi Alexander,
> > > >
> > > > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:44:02 -0500:
> > > >  
> > > > > Hi,
> > > > >
> > > > > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > ...  
> > > > > > +       return 0;
> > > > > > +}
> > > > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > > > index c829e4a75325..40656728c624 100644
> > > > > > --- a/net/mac802154/tx.c
> > > > > > +++ b/net/mac802154/tx.c
> > > > > > @@ -54,6 +54,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > > >         struct net_device *dev = skb->dev;
> > > > > >         int ret;
> > > > > >
> > > > > > +       if (unlikely(mac802154_scan_is_ongoing(local)))
> > > > > > +               return NETDEV_TX_BUSY;
> > > > > > +  
> > > > >
> > > > > Please look into the functions "ieee802154_wake_queue()" and
> > > > > "ieee802154_stop_queue()" which prevent this function from being
> > > > > called. Call stop before starting scanning and wake after scanning is
> > > > > done or stopped.  
> > > >
> > > > Mmmh all this is already done, isn't it?
> > > > - mac802154_trigger_scan_locked() stops the queue before setting the
> > > >   promiscuous mode
> > > > - mac802154_end_of_scan() wakes the queue after resetting the
> > > >   promiscuous mode to its original state
> > > >
> > > > Should I drop the check which stands for an extra precaution?
> > > >  
> > >
> > > no, I think then it should be a WARN_ON() more without any return
> > > (hopefully it will survive). This case should never happen otherwise
> > > we have a bug that we wake the queue when we "took control about
> > > transmissions" only.
> > > Change the name, I think it will be in future not only scan related.
> > > Maybe "mac802154_queue_stopped()". Everything which is queued from
> > > socket/upperlayer(6lowpan) goes this way.  
> >
> > Got it.
> >
> > I've changed the name of the helper, and used an atomic variable there
> > to follow the count.
> >  
> > > > But overall I think I don't understand well this part. What is
> > > > a bit foggy to me is why the (async) tx implementation does:
> > > >
> > > > *Core*                           *Driver*
> > > >
> > > > stop_queue()
> > > > drv_async_xmit() -------
> > > >                         \------> do something
> > > >                          ------- calls ieee802154_xmit_complete()
> > > > wakeup_queue() <--------/
> > > >
> > > > So we actually disable the queue for transmitting. Why??
> > > >  
> > >
> > > Because all transceivers have either _one_ transmit framebuffer or one
> > > framebuffer for transmit and receive one time. We need to report to
> > > stop giving us more skb's while we are busy with one to transmit.
> > > This all will/must be changed in future if there is hardware outside
> > > which is more powerful and the driver needs to control the flow here.
> > >
> > > That ieee802154_xmit_complete() calls wakeup_queue need to be
> > > forbidden when we are in "synchronous transmit mode"/the queue is
> > > stopped. The synchronous transmit mode is not for any hotpath, it's
> > > for MLME and I think we also need a per phy lock to avoid multiple
> > > synchronous transmissions at one time. Please note that I don't think
> > > here only about scan operation, also for other possible MLME-ops.
> > >  
> >
> > First, thank you very much for all your guidance and reviews, I think I
> > have a much clearer understanding now.
> >
> > I've tried to follow your advices, creating:
> > - a way of tracking ongoing transmissions
> > - a synchronous API for MLME transfers
> >  
> 
> Please note that I think we cannot use netif_stop_queue() from context
> outside of netif xmit() callback. It's because the atomic counter
> itself is racy in xmit(), we need to be sure xmit() can't occur while
> stopping the queue.

In my current implementation I don't see this as a real problem because
for me, there is no real difference between:

- a transfer is started
- we call stop_queue()
* right here a transfer is ongoing *

and 

- we call stop_queue()
- the counter is racy hence a last transfer is started
* right here a transfer is ongoing *

because stopping the queue and "flushing" it are two different things.
In the code I don't only rely on the queue being stopped but if I don't
want any more transfer to happen after that, so I also sync the queue
thanks to the new helpers introduced.

Please check v3 (which is coming very soon) and tell me what you think.
Maybe I missed something.

> I think maybe "netif_tx_disable()" is the right
> call to stop from another context, because it holds the tx_lock, which
> I believe is held while xmit().
> Where the wake queue call should be fine to call..., maybe we can
> remove some EXPORT_SYMBOL() then?
> 
> I saw that some drivers call "ieee802154_wake_queue()" in error cases,
> may we introduce a new helper "?ieee802154_xmit_error?" for error
> cases so you can also catch error cases in your sync tx. See `grep -r
> "ieee802154_wake_queue" drivers/net/ieee802154`, if we have more
> information we might add more meaning into the error cases (e.g.
> proper errno).

Most of the time the calling functions are void functions. In fact they
all simply hardcode the xmit_done helper and even worse, sometimes they
simply leak the skb. I've handled that already by updating all these
callers to be sure the only way out is to call xmit_done, which helps a
lot tracking transfers.

Also, you are right, we can certainly drop a couple of EXPORT_SYMBOLS
:-)

> > I've decided to use the wait_queue + atomic combo which looks nice.
> > Everything seems to work, I just need a bit of time to clean and rework
> > a bit the series before sending a v3.
> >  
> 
> Okay, sounds good to implement both requirements.
> 
> - Alex

Thanks,
Miquèl
