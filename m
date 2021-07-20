Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950793D004B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhGTQv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:51:57 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:32776 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhGTQvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 12:51:43 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 40D5392009C; Tue, 20 Jul 2021 19:32:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 39CE492009B;
        Tue, 20 Jul 2021 19:32:18 +0200 (CEST)
Date:   Tue, 20 Jul 2021 19:32:18 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Zheyu Ma <zheyuma97@gmail.com>
cc:     Shannon Nelson <snelson@pensando.io>, klassert@kernel.org,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: 3com: 3c59x: add a check against null pointer
 dereference
In-Reply-To: <CAMhUBjnmeS5G4CNFhsV7EVFSfLspNNotd5qP-g8o8OsBx7xd5A@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2107201918150.9461@angie.orcam.me.uk>
References: <1623498978-30759-1-git-send-email-zheyuma97@gmail.com> <7ca72971-e072-2489-99cc-3b25e111d333@pensando.io> <CAMhUBjnmeS5G4CNFhsV7EVFSfLspNNotd5qP-g8o8OsBx7xd5A@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021, Zheyu Ma wrote:

> > > When the driver is processing the interrupt, it will read the value of
> > > the register to determine the status of the device. If the device is in
> > > an incorrect state, the driver may mistakenly enter this branch. At this
> > > time, the dma buffer has not been allocated, which will result in a null
> > > pointer dereference.
[...]
> > > diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
> > > index 741c67e546d4..e27901ded7a0 100644
> > > --- a/drivers/net/ethernet/3com/3c59x.c
> > > +++ b/drivers/net/ethernet/3com/3c59x.c
> > > @@ -2300,7 +2300,7 @@ _vortex_interrupt(int irq, struct net_device *dev)
> > >               }
> > >
> > >               if (status & DMADone) {
> > > -                     if (ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) {
> > > +                     if ((ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) && vp->tx_skb_dma) {
> > >                               iowrite16(0x1000, ioaddr + Wn7_MasterStatus); /* Ack the event. */
> > >                               dma_unmap_single(vp->gendev, vp->tx_skb_dma, (vp->tx_skb->len + 3) & ~3, DMA_TO_DEVICE);
> > >                               pkts_compl++;
> >
> > This means you won't be ack'ing the event - is this unacknowledged event
> > going to cause an issue later?
> >
> 
> First, I'm not an expert in networking, but from my perspective, I
> don't think this will cause a problem. Because when the driver enters
> this branch, It means that it thinks that the hardware has already
> performed a DMA operation, and the driver only needs to do some
> follow-up work, but this is not the case. At this time,
> 'vp->tx_skb_dma' is still a null pointer, so there is no need for
> follow-up work at this time, it is meaningless, and it is appropriate
> not to perform any operations at this time.

 What are the circumstances you observe this behaviour under?  The state 
of hardware is supposed to be consistent with the state of the driver.  If 
an inconsistency happens, then there are various possible causes such as:

1. The driver has a bug (in which case you need to track the bug down and 
   fix it).

2. The hardware does not behave as specified, e.g. due to an erratum (in 
   which case you need to track the problem down and work it around in the 
   driver).

3. The hardware may have been disturbed, e.g. due to EMC interference (in 
   which case you may implement a recovery attempt by reinitialising the 
   hardware once an odd state has been discovered).

4. The hardware is broken (throw it away).

For #4 the solution is obvious.  For #3 you might want to implement a 
hardware reset path rather than ignoring the inconsistent state and only 
prevent the driver from crashing.  If you have a way to reproduce the 
issue, which I gather you do, then it's likely not #3 as that would be 
intermittent, and then you'll have to investigate what is causing the 
problem to see if it is #1 or #2 (or maybe #4), and act accordingly.  

 Someone more familiar with this hardware (is there a spec available?) 
might be able to assist you once you have figured out what the exact 
scenario leading to the failure you have observed is.

 HTH,

  Maciej
