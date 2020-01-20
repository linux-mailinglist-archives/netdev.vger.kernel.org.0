Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2451433E4
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgATWXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:23:41 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44068 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgATWXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:23:41 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 0FECF27E71;
        Mon, 20 Jan 2020 17:23:36 -0500 (EST)
Date:   Tue, 21 Jan 2020 09:23:34 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 04/19] net/sonic: Add mutual exclusion for accessing
 shared state
In-Reply-To: <CAMuHMdWvJ975X7zz1C=1Sq=Yuf9nYY1zxWaJ=XCXJukfP=nygg@mail.gmail.com>
Message-ID: <alpine.LNX.2.21.1.2001210914150.8@nippy.intranet>
References: <cover.1579474569.git.fthain@telegraphics.com.au> <b47662493a776811d4d457e5a75e18a7169aed23.1579474569.git.fthain@telegraphics.com.au> <CAMuHMdWvJ975X7zz1C=1Sq=Yuf9nYY1zxWaJ=XCXJukfP=nygg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jan 2020, Geert Uytterhoeven wrote:

> Hi Finn,
> 
> On Mon, Jan 20, 2020 at 12:19 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> > The netif_stop_queue() call in sonic_send_packet() races with the
> > netif_wake_queue() call in sonic_interrupt(). This causes issues
> > like "NETDEV WATCHDOG: eth0 (macsonic): transmit queue 0 timed out".
> > Fix this by disabling interrupts when accessing tx_skb[] and next_tx.
> > Update a comment to clarify the synchronization properties.
> >
> > Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
> > Tested-by: Stan Johnson <userm57@yahoo.com>
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> 
> Thanks for your patch!
> 
> > --- a/drivers/net/ethernet/natsemi/sonic.c
> > +++ b/drivers/net/ethernet/natsemi/sonic.c
> > @@ -242,7 +242,7 @@ static void sonic_tx_timeout(struct net_device *dev)
> >   *   wake the tx queue
> >   * Concurrently with all of this, the SONIC is potentially writing to
> >   * the status flags of the TDs.
> > - * Until some mutual exclusion is added, this code will not work with SMP. However,
> > + * A spin lock is needed to make this work on SMP platforms. However,
> >   * MIPS Jazz machines and m68k Macs were all uni-processor machines.
> >   */
> >
> > @@ -252,6 +252,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
> >         dma_addr_t laddr;
> >         int length;
> >         int entry;
> > +       unsigned long flags;
> >
> >         netif_dbg(lp, tx_queued, dev, "%s: skb=%p\n", __func__, skb);
> >
> > @@ -273,6 +274,8 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
> >                 return NETDEV_TX_OK;
> >         }
> >
> > +       local_irq_save(flags);
> > +
> 
> Wouldn't it be better to use a spinlock instead?

Yes, better in the sense of "more portable". And worse in the sense of 
"needless complexity".

> It looks like all currently supported platforms (Mac, Jazz, and XT2000) 
> do no support SMP, but I'm not 100% sure about the latter. And this 
> generic sonic.c core may end up being used on other platforms that do 
> support SMP.
> 

I'm not sure about XT2000 either. It would be surprising if they 
overlooked this. But I'll add the spinlock, just in case.

Thanks for your review.

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> 
