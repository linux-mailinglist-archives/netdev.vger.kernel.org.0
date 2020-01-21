Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9940914485A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 00:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAUXeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 18:34:01 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:46418 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAUXeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 18:34:00 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 9E474272D8;
        Tue, 21 Jan 2020 18:33:54 -0500 (EST)
Date:   Wed, 22 Jan 2020 10:33:53 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 01/12] net/sonic: Add mutual exclusion for accessing
 shared state
In-Reply-To: <0113c00f-3f77-8324-95a8-31dd6f64fa6a@gmail.com>
Message-ID: <alpine.LNX.2.21.1.2001221021590.8@nippy.intranet>
References: <cover.1579641728.git.fthain@telegraphics.com.au> <d7c6081de558e2fe5693a35bb735724411134cb5.1579641728.git.fthain@telegraphics.com.au> <0113c00f-3f77-8324-95a8-31dd6f64fa6a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020, Eric Dumazet wrote:

> On 1/21/20 1:22 PM, Finn Thain wrote:
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
> > @@ -284,9 +287,16 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
> >  	struct net_device *dev = dev_id;
> >  	struct sonic_local *lp = netdev_priv(dev);
> >  	int status;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&lp->lock, flags);
> 
> 
> This is a hard irq handler, no need to block hard irqs.
> 
> spin_lock() here is enough.
> 

Well, yes, assuming we're dealing with SMP [1]. Probably just disabling 
pre-emption is all that will ever be needed.

Anyway, the real problem solved by disabling irqs is that macsonic must 
avoid re-entrance of sonic_interrupt(). [2]

[1]
https://lore.kernel.org/netdev/alpine.LNX.2.21.1.2001211026190.8@nippy.intranet/T/#m0523c8b2a26a410ed56889d9230c37ba1160d40a

[2]
https://lore.kernel.org/netdev/alpine.LNX.2.21.1.2001211026190.8@nippy.intranet/T/#m1c8ca580d2b45e61a628d17839978d0bd5aaf061

