Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BC92785D1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 13:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgIYL3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 07:29:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728042AbgIYL3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 07:29:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601033350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a+xXYhaz3xJWD2NJ87xvS9BgiZ1yx0Uuztf4SpTLz3M=;
        b=FWXrLG0eo2rTa0ymrZR5ZopX6Uf+isIVBuvjp//1DDIRJuh9nGAIrGE1KeWC261R7Iv9+O
        bEFwGI0+u5JdrcSlkKPExWp/EbZO2BiOmx9Bc0k487rovljMGcS89GHJrIJYXfdvrcrrMK
        e72btdqE2Kr5D1K+yQlgPyzyrqxcCtI=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-JupkV1AZOEGxRLgKE8eoFQ-1; Fri, 25 Sep 2020 07:29:07 -0400
X-MC-Unique: JupkV1AZOEGxRLgKE8eoFQ-1
Received: by mail-vs1-f72.google.com with SMTP id s68so592509vss.3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 04:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a+xXYhaz3xJWD2NJ87xvS9BgiZ1yx0Uuztf4SpTLz3M=;
        b=EIY82hRUFwO1YuGXJKnMAFFf0tYvWlQtUQwNpy8EaTOZeWIW3Tmnqnlq4Ebzqx5wMd
         UrM0vd1J/gXmMfHtwMFKQca70THMWB/zKHpyhKz2quPC/8ckikJxflvngHu/HzQBO+D7
         Ia8oLZOu+0nmZs2+nBsklcXCuYhnnV5gZvmZ4felIt8N5Ef4h8yovVo4RfP4NJ934R5B
         vGfWGhpXfHQydfgXG0+1m83okJE8zNzW0TU9rqMCfyiL9VM89z3YIWGKAxg9Hpq/8EDm
         qqDHaseeHr6TCbd1ackfcDwqze7FguzU2KtPWHQ6e3QKM0KN3h+MDIEGRXi4xD17/xQy
         scxQ==
X-Gm-Message-State: AOAM530Ij7vZPKkku5Ta+PzPCIQ+dRgq3ydk2kO4ddt0WE6t+tHDUfYR
        26z5GF21RacpIk5yLChGuD3qx/Nl9K33Rq8xPSUIKk56ya0Lwi2pgP7Z5qY53FXu8XBs1HDUwth
        +5D9Yxp3ldXZL8syUHjs0PmxWeUu0KrKG
X-Received: by 2002:a1f:2508:: with SMTP id l8mr2265581vkl.20.1601033346876;
        Fri, 25 Sep 2020 04:29:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPkKiRWHQ4PB/IdF1x7g6G+M7Gyb9ARITIqMUZkNWh3Qz54zK8XTm/ONdoSgk8HeMRJIxcARiPBzmx5KHKNsE=
X-Received: by 2002:a1f:2508:: with SMTP id l8mr2265568vkl.20.1601033346546;
 Fri, 25 Sep 2020 04:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <4f6602e98fdaef1610e948acec19a5de51fb136e.1601027617.git.lorenzo@kernel.org>
 <20200925125213.4981cff8@carbon>
In-Reply-To: <20200925125213.4981cff8@carbon>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 25 Sep 2020 13:29:00 +0200
Message-ID: <CAJ0CqmV8OJoERhYktLNP7gYDwURs97JAmbsXq2jqKHhMoHk-pg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mvneta: try to use in-irq pp cache in mvneta_txq_bufs_free
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On Fri, 25 Sep 2020 12:01:32 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > Try to recycle the xdp tx buffer into the in-irq page_pool cache if
> > mvneta_txq_bufs_free is executed in the NAPI context.
>
> NACK - I don't think this is safe.  That is also why I named the
> function postfix rx_napi.  The page pool->alloc.cache is associated
> with the drivers RX-queue.  The xdp_frame's that gets freed could be
> coming from a remote driver that use page_pool. This remote drivers
> RX-queue processing can run concurrently on a different CPU, than this
> drivers TXQ-cleanup.

ack, right. What about if we do it just XDP_TX use case? Like:

if (napi && buf->type == MVNETA_TYPE_XDP_TX)
   xdp_return_frame_rx_napi(buf->xdpf);
else
   xdp_return_frame(buf->xdpf);

In this way we are sure the packet is coming from local page_pool.

>
> If you want to speedup this, I instead suggest that you add a
> xdp_return_frame_bulk API.

I will look at it

Regards,
Lorenzo


>
>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 14df3aec285d..646fbf4ed638 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -1831,7 +1831,7 @@ static struct mvneta_tx_queue *mvneta_tx_done_policy(struct mvneta_port *pp,
> >  /* Free tx queue skbuffs */
> >  static void mvneta_txq_bufs_free(struct mvneta_port *pp,
> >                                struct mvneta_tx_queue *txq, int num,
> > -                              struct netdev_queue *nq)
> > +                              struct netdev_queue *nq, bool napi)
> >  {
> >       unsigned int bytes_compl = 0, pkts_compl = 0;
> >       int i;
> > @@ -1854,7 +1854,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
> >                       dev_kfree_skb_any(buf->skb);
> >               } else if (buf->type == MVNETA_TYPE_XDP_TX ||
> >                          buf->type == MVNETA_TYPE_XDP_NDO) {
> > -                     xdp_return_frame(buf->xdpf);
> > +                     if (napi)
> > +                             xdp_return_frame_rx_napi(buf->xdpf);
> > +                     else
> > +                             xdp_return_frame(buf->xdpf);
> >               }
> >       }
> >
> > @@ -1872,7 +1875,7 @@ static void mvneta_txq_done(struct mvneta_port *pp,
> >       if (!tx_done)
> >               return;
> >
> > -     mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> > +     mvneta_txq_bufs_free(pp, txq, tx_done, nq, true);
> >
> >       txq->count -= tx_done;
> >
> > @@ -2859,7 +2862,7 @@ static void mvneta_txq_done_force(struct mvneta_port *pp,
> >       struct netdev_queue *nq = netdev_get_tx_queue(pp->dev, txq->id);
> >       int tx_done = txq->count;
> >
> > -     mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> > +     mvneta_txq_bufs_free(pp, txq, tx_done, nq, false);
> >
> >       /* reset txq */
> >       txq->count = 0;
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>

