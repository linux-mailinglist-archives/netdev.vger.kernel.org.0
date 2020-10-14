Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9DB28E46B
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388476AbgJNQ1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:27:51 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43672 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbgJNQ1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 12:27:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09EGRW7o012950;
        Wed, 14 Oct 2020 18:27:32 +0200
Date:   Wed, 14 Oct 2020 18:27:32 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Claudiu.Beznea@microchip.com
Cc:     Nicolas.Ferre@microchip.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, daniel@0x0f.com
Subject: Re: [PATCH net-next 3/3] macb: support the two tx descriptors on
 at91rm9200
Message-ID: <20201014162732.GA12944@1wt.eu>
References: <20201011090944.10607-1-w@1wt.eu>
 <20201011090944.10607-4-w@1wt.eu>
 <29603cfa-db00-f088-3dbe-0781ee5a99ed@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29603cfa-db00-f088-3dbe-0781ee5a99ed@microchip.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claudiu,

first, thanks for your feedback!

On Wed, Oct 14, 2020 at 04:08:00PM +0000, Claudiu.Beznea@microchip.com wrote:
> > @@ -3994,11 +3996,10 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
> >                                         struct net_device *dev)
> >  {
> >         struct macb *lp = netdev_priv(dev);
> > +       unsigned long flags;
> > 
> > -       if (macb_readl(lp, TSR) & MACB_BIT(RM9200_BNQ)) {
> > -               int desc = 0;
> > -
> > -               netif_stop_queue(dev);
> > +       if (lp->rm9200_tx_len < 2) {
> > +               int desc = lp->rm9200_tx_tail;
> 
> I think you also want to protect these reads with spin_lock() to avoid
> concurrency with the interrupt handler.

I don't think it's needed because the condition doesn't change below
us as the interrupt handler only decrements. However I could use a
READ_ONCE to make things cleaner. And in practice this test was kept
to keep some sanity checks but it never fails, as if the queue length
reaches 2, the queue is stopped (and I never got the device busy message
either before nor after the patch).

> >                 /* Store packet information (to free when Tx completed) */
> >                 lp->rm9200_txq[desc].skb = skb;
> > @@ -4012,6 +4013,15 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
> >                         return NETDEV_TX_OK;
> >                 }
> > 
> > +               spin_lock_irqsave(&lp->lock, flags);
> > +
> > +               lp->rm9200_tx_tail = (desc + 1) & 1;
> > +               lp->rm9200_tx_len++;
> > +               if (lp->rm9200_tx_len > 1)
> > +                       netif_stop_queue(dev);

This is where we guarantee that we won't call start_xmit() again with
rm9200_tx_len >= 2.

> > @@ -4088,21 +4100,39 @@ static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
> >                 at91ether_rx(dev);
> > 
> >         /* Transmit complete */
> > -       if (intstatus & MACB_BIT(TCOMP)) {
> > +       if (intstatus & (MACB_BIT(TCOMP) | MACB_BIT(RM9200_TBRE))) {
> >                 /* The TCOM bit is set even if the transmission failed */
> >                 if (intstatus & (MACB_BIT(ISR_TUND) | MACB_BIT(ISR_RLE)))
> >                         dev->stats.tx_errors++;
> > 
> > -               desc = 0;
> > -               if (lp->rm9200_txq[desc].skb) {
> > +               spin_lock(&lp->lock);
> 
> Also, this lock could be moved before while, below, as you want to protect
> the rm9200_tx_len and rm9200_tx_tails members of lp as I understand.

Sure, but it actually *is* before the while(). I'm sorry if that was not
visible from the context of the diff. The while is just a few lins below,
thus rm9200_tx_len and rm9200_tx_tail are properly protected. Do not
hesitate to tell me if something is not clear or if I'm wrong!

Thanks!
Willy
