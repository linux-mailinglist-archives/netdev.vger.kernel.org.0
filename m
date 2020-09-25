Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDCD2786B3
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgIYMJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:09:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728038AbgIYMJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 08:09:37 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601035775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vKv79pKABb3lcxxJJ/iKHHf7+5qMSzzl2wR9bWa0VUs=;
        b=jVeVlrKcjbgU74cV2EQGKK7ieK6RaBgMN2rE+TKlawY3DjMw7bJOukNQduzp0l8OnQvu4k
        MDlU7wvboZKeoM5cUgp8L6DOsAWTrXTQxblJ/0VORj9Ahfe0/igH8ZPJzHZCgDowlD0KIK
        gJ6FGHqu26dSISjsMREk2MJZHhUtiAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-h9lD5ihNPDe_MeBfT7J50A-1; Fri, 25 Sep 2020 08:09:33 -0400
X-MC-Unique: h9lD5ihNPDe_MeBfT7J50A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A4B58030CD;
        Fri, 25 Sep 2020 12:09:32 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FC4555761;
        Fri, 25 Sep 2020 12:09:22 +0000 (UTC)
Date:   Fri, 25 Sep 2020 14:09:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        thomas.petazzoni@bootlin.com, brouer@redhat.com
Subject: Re: [PATCH net-next] net: mvneta: try to use in-irq pp cache in
 mvneta_txq_bufs_free
Message-ID: <20200925140920.47bec9cf@carbon>
In-Reply-To: <CAJ0CqmV8OJoERhYktLNP7gYDwURs97JAmbsXq2jqKHhMoHk-pg@mail.gmail.com>
References: <4f6602e98fdaef1610e948acec19a5de51fb136e.1601027617.git.lorenzo@kernel.org>
        <20200925125213.4981cff8@carbon>
        <CAJ0CqmV8OJoERhYktLNP7gYDwURs97JAmbsXq2jqKHhMoHk-pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 13:29:00 +0200
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> >
> > On Fri, 25 Sep 2020 12:01:32 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >  
> > > Try to recycle the xdp tx buffer into the in-irq page_pool cache if
> > > mvneta_txq_bufs_free is executed in the NAPI context.  
> >
> > NACK - I don't think this is safe.  That is also why I named the
> > function postfix rx_napi.  The page pool->alloc.cache is associated
> > with the drivers RX-queue.  The xdp_frame's that gets freed could be
> > coming from a remote driver that use page_pool. This remote drivers
> > RX-queue processing can run concurrently on a different CPU, than this
> > drivers TXQ-cleanup.  
> 
> ack, right. What about if we do it just XDP_TX use case? Like:
> 
> if (napi && buf->type == MVNETA_TYPE_XDP_TX)
>    xdp_return_frame_rx_napi(buf->xdpf);
> else
>    xdp_return_frame(buf->xdpf);
> 
> In this way we are sure the packet is coming from local page_pool.

Yes, that case XDP_TX should be safe.

> >
> > If you want to speedup this, I instead suggest that you add a
> > xdp_return_frame_bulk API.  
> 
> I will look at it

Great!

Notice that bulk return should be easy/obvious in most drivers, as they
(like mvneta in mvneta_txq_bufs_free()) have a loop that process
several TXQ completions.

I did a quick tests on mlx5 with xdp_redirect_map and perf report shows
__xdp_return calls at the top#1 overhead.

# Overhead  CPU  Symbol                              
# ........  ...  ....................................
#
     8.46%  003  [k] __xdp_return                    
     6.41%  003  [k] dma_direct_map_page             
     4.65%  003  [k] bpf_xdp_redirect_map            
     4.58%  003  [k] dma_direct_unmap_page           
     4.04%  003  [k] xdp_do_redirect                 
     3.53%  003  [k] __page_pool_put_page            
     3.27%  003  [k] dma_direct_sync_single_for_cpu  
     2.63%  003  [k] dev_map_enqueue                 
     2.28%  003  [k] page_pool_refill_alloc_cache    
     1.69%  003  [k] bq_enqueue.isra.0               
     1.15%  003  [k] _raw_spin_lock                  
     0.92%  003  [k] xdp_return_frame                

Thus, there will be a benefit from implementing a bulk return.  Also
for your XDP_TX case, as the overhead in __xdp_return also exist for
rx_napi variant.


> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > > index 14df3aec285d..646fbf4ed638 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -1831,7 +1831,7 @@ static struct mvneta_tx_queue *mvneta_tx_done_policy(struct mvneta_port *pp,
> > >  /* Free tx queue skbuffs */
> > >  static void mvneta_txq_bufs_free(struct mvneta_port *pp,
> > >                                struct mvneta_tx_queue *txq, int num,
> > > -                              struct netdev_queue *nq)
> > > +                              struct netdev_queue *nq, bool napi)
> > >  {
> > >       unsigned int bytes_compl = 0, pkts_compl = 0;
> > >       int i;
> > > @@ -1854,7 +1854,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
> > >                       dev_kfree_skb_any(buf->skb);
> > >               } else if (buf->type == MVNETA_TYPE_XDP_TX ||
> > >                          buf->type == MVNETA_TYPE_XDP_NDO) {
> > > -                     xdp_return_frame(buf->xdpf);
> > > +                     if (napi)
> > > +                             xdp_return_frame_rx_napi(buf->xdpf);
> > > +                     else
> > > +                             xdp_return_frame(buf->xdpf);
> > >               }
> > >       }
> > >
> > > @@ -1872,7 +1875,7 @@ static void mvneta_txq_done(struct mvneta_port *pp,
> > >       if (!tx_done)
> > >               return;
> > >
> > > -     mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> > > +     mvneta_txq_bufs_free(pp, txq, tx_done, nq, true);
> > >
> > >       txq->count -= tx_done;
> > >
> > > @@ -2859,7 +2862,7 @@ static void mvneta_txq_done_force(struct mvneta_port *pp,
> > >       struct netdev_queue *nq = netdev_get_tx_queue(pp->dev, txq->id);
> > >       int tx_done = txq->count;
> > >
> > > -     mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> > > +     mvneta_txq_bufs_free(pp, txq, tx_done, nq, false);
> > >
> > >       /* reset txq */
> > >       txq->count = 0;  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

