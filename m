Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBA248DC92
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiAMRHR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jan 2022 12:07:17 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:48395 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiAMRHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:07:16 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 0898724000F;
        Thu, 13 Jan 2022 17:07:10 +0000 (UTC)
Date:   Thu, 13 Jan 2022 18:07:09 +0100
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
Message-ID: <20220113180709.0dade123@xps13>
In-Reply-To: <CAB_54W4PL1ty5XsqRoEKwsy-h8KL9gSGMK6N=HiWJDp6NHsb0A@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-19-miquel.raynal@bootlin.com>
        <CAB_54W4PL1ty5XsqRoEKwsy-h8KL9gSGMK6N=HiWJDp6NHsb0A@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:44:02 -0500:

> Hi,
> 
> On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > +       return 0;
> > +}
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index c829e4a75325..40656728c624 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -54,6 +54,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> >         struct net_device *dev = skb->dev;
> >         int ret;
> >
> > +       if (unlikely(mac802154_scan_is_ongoing(local)))
> > +               return NETDEV_TX_BUSY;
> > +  
> 
> Please look into the functions "ieee802154_wake_queue()" and
> "ieee802154_stop_queue()" which prevent this function from being
> called. Call stop before starting scanning and wake after scanning is
> done or stopped.

Mmmh all this is already done, isn't it?
- mac802154_trigger_scan_locked() stops the queue before setting the
  promiscuous mode
- mac802154_end_of_scan() wakes the queue after resetting the
  promiscuous mode to its original state

Should I drop the check which stands for an extra precaution?


But overall I think I don't understand well this part. What is
a bit foggy to me is why the (async) tx implementation does:

*Core*                           *Driver*

stop_queue()
drv_async_xmit() -------
                        \------> do something
                         ------- calls ieee802154_xmit_complete()
wakeup_queue() <--------/

So we actually disable the queue for transmitting. Why??

> Also there exists a race which exists in your way and also the one
> mentioned above. There can still be some transmissions going on... We
> need to wait until "all possible" tx completions are done... to be
> sure there are really no transmissions going on. However we need to be
> sure that a wake cannot be done if a tx completion is done, we need to
> avoid it when the scan operation is ongoing as a workaround for this
> race.
> 
> This race exists and should be fixed in future work?

Yep, this is true, do you have any pointers? Because I looked at the
code and for now it appears quite unpractical to add some kind of
flushing mechanism on that net queue. I believe we cannot use the netif
interface for that so we would have to implement our own mechanism in
the ieee802154 core.

Thanks,
Miquèl
