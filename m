Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFBE27EE93
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbgI3QKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbgI3QKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:10:14 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98622C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:10:14 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j13so2247236ilc.4
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1G7143leyoQ6VAX6YFDWqnNnRWuyxhmq8ysNvPJzccc=;
        b=TtiUbk/ZqDm53fHqGnXhuGD3UXP/STzrD1ygOstzdClqsoCPdBAdrxARxsCpCjhlpN
         g/CoV6W9hgIyYMwSOU+EgYppEAB1oUOxan0sUrGug+CseRCqm28t6S4miMFo+mEKGpAQ
         o5I6SeaAe4XfK2BoN/XaU1ztfRUpJg5HpC4CbTOFU3Fjb+lBy87uaxDAd20bAq2YSGQm
         p0Kssgur0OWP5jI7HfJV3l/AnW0mitIG6xPqGwE4ekuLn0Kh3iGe3KNRiSoJ6UsLCI3b
         gJHdvRJJv/6XPLPaFARZr1wJMU0Ae8B2TVa1haCp7rHIZrxeih4q5Rzfzb+MGup2wa8w
         c2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1G7143leyoQ6VAX6YFDWqnNnRWuyxhmq8ysNvPJzccc=;
        b=PNTgHkQK4Pvsi7timJ6NtxvBqSj5RuEBUKWWPcsv4JVZs7DKzcImMM5da9ZhybCkTv
         7HqX36ho+3b3biuIj9yR38xzvLkpDHU6eAzY33gpeNUDGJMS53CjBjUDUto007lWtdmA
         nS6HMzeg+xQSQIFAWKG7cj9yU2diD7fM8v3kklEnUMCb+d7TF4cd9T9+3E/z4/1N+cC4
         zWUoiaW3CueNPgvPdKY/8RhpuTFISEVthdDtO8lEfsDXrFCQTzhNsZgRo0P+M/YzxCeJ
         iyGgBD5KaE/uuXiKOtw2FPts5lGaAw03N3gOEcdW2JGcIKIGmBLqSbqGTtc60XGnhIN9
         aXTg==
X-Gm-Message-State: AOAM533mYF2MxRJx3OtVFoBsaUJqrTWgYjdS4psctBbC/3sZpQeXNi6N
        h3slTY/jnWVhveqfumLZReujZbkloO0UcUtWWHr+SQ==
X-Google-Smtp-Source: ABdhPJyp+73Qi9pBIfW0Y7ku5rrPDYSp69z+uFDbGgi04OdGnc+YP6AXLPfWyPiHgtOgyuWjwMSgIH6cTVa3Ul+OnAI=
X-Received: by 2002:a92:1f5a:: with SMTP id i87mr2531565ile.124.1601482213686;
 Wed, 30 Sep 2020 09:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200924010104.3196839-1-awogbemila@google.com>
 <20200924010104.3196839-4-awogbemila@google.com> <20200924160055.1e7be259@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924160055.1e7be259@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 30 Sep 2020 09:10:02 -0700
Message-ID: <CAL9ddJeFSg2onpa7O9PXt8rqHS7WUFCnpJYu+scHTiQtHRTQig@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/4] gve: Rx Buffer Recycling
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 4:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Sep 2020 18:01:03 -0700 David Awogbemila wrote:
> > This patch lets the driver reuse buffers that have been freed by the
> > networking stack.
> >
> > In the raw addressing case, this allows the driver avoid allocating new
> > buffers.
> > In the qpl case, the driver can avoid copies.
> >
> > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > ---
> >  drivers/net/ethernet/google/gve/gve.h    |  10 +-
> >  drivers/net/ethernet/google/gve/gve_rx.c | 197 +++++++++++++++--------
> >  2 files changed, 133 insertions(+), 74 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> > index b853efb0b17f..9cce2b356235 100644
> > --- a/drivers/net/ethernet/google/gve/gve.h
> > +++ b/drivers/net/ethernet/google/gve/gve.h
> > @@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
> >       struct page *page;
> >       void *page_address;
> >       u32 page_offset; /* offset to write to in page */
> > +     bool can_flip;
> >  };
> >
> >  /* A list of pages registered with the device during setup and used by a queue
> > @@ -505,15 +506,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
> >               return DMA_FROM_DEVICE;
> >  }
> >
> > -/* Returns true if the max mtu allows page recycling */
> > -static inline bool gve_can_recycle_pages(struct net_device *dev)
> > -{
> > -     /* We can't recycle the pages if we can't fit a packet into half a
> > -      * page.
> > -      */
> > -     return dev->max_mtu <= PAGE_SIZE / 2;
> > -}
> > -
> >  /* buffers */
> >  int gve_alloc_page(struct gve_priv *priv, struct device *dev,
> >                  struct page **page, dma_addr_t *dma,
> > diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> > index ae76d2547d13..bea483db28f5 100644
> > --- a/drivers/net/ethernet/google/gve/gve_rx.c
> > +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> > @@ -263,8 +263,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
> >       return PKT_HASH_TYPE_L2;
> >  }
> >
> > -static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
> > -                                struct net_device *dev,
> > +static struct sk_buff *gve_rx_copy(struct net_device *dev,
> >                                  struct napi_struct *napi,
> >                                  struct gve_rx_slot_page_info *page_info,
> >                                  u16 len)
> > @@ -282,10 +281,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
> >
> >       skb->protocol = eth_type_trans(skb, dev);
> >
> > -     u64_stats_update_begin(&rx->statss);
> > -     rx->rx_copied_pkt++;
> > -     u64_stats_update_end(&rx->statss);
> > -
> >       return skb;
> >  }
> >
> > @@ -331,22 +326,91 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
> >  {
> >       u64 addr = be64_to_cpu(data_ring->addr);
> >
> > +     /* "flip" to other packet buffer on this page */
> >       page_info->page_offset ^= PAGE_SIZE / 2;
> >       addr ^= PAGE_SIZE / 2;
> >       data_ring->addr = cpu_to_be64(addr);
> >  }
> >
> > +static bool gve_rx_can_flip_buffers(struct net_device *netdev)
> > +{
> > +#if PAGE_SIZE == 4096
> > +     /* We can't flip a buffer if we can't fit a packet
> > +      * into half a page.
> > +      */
> > +     if (netdev->max_mtu + GVE_RX_PAD + ETH_HLEN  > PAGE_SIZE / 2)
>
> double space

I'll adjust this.

> > +             return false;
> > +     return true;
>
> Flip the condition and just return it.
>
> return netdev->max_mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2
>
> Also you should probably look at mtu not max_mtu. More likely to be in
> cache.

Ok, I'll adjust this to use mtu instead.

> > +#else
> > +     /* PAGE_SIZE != 4096 - don't try to reuse */
> > +     return false;
> > +#endif
> > +}
> > +
> > +static int gve_rx_can_recycle_buffer(struct page *page)
> > +{
> > +     int pagecount = page_count(page);
> > +
> > +     /* This page is not being used by any SKBs - reuse */
> > +     if (pagecount == 1) {
> > +             return 1;
> > +     /* This page is still being used by an SKB - we can't reuse */
> > +     } else if (pagecount >= 2) {
> > +             return 0;
> > +     }
>
> parenthesis not necessary around single line statements.

I'll adjust this.

> > +     WARN(pagecount < 1, "Pagecount should never be < 1");
> > +     return -1;
> > +}
> > +
> >  static struct sk_buff *
> >  gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
> >                     struct gve_rx_slot_page_info *page_info, u16 len,
> >                     struct napi_struct *napi,
> > -                   struct gve_rx_data_slot *data_slot)
> > +                   struct gve_rx_data_slot *data_slot, bool can_flip)
> >  {
> >       struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
>
> IMHO it looks weird when a function is called on variable init and then
> error checking is done after an empty line.

Ok, I'll declare skb and then initialize it separately.

> >       if (!skb)
> >               return NULL;
> >
> > +     /* Optimistically stop the kernel from freeing the page by increasing
> > +      * the page bias. We will check the refcount in refill to determine if
> > +      * we need to alloc a new page.
> > +      */
> > +     get_page(page_info->page);
> > +     page_info->can_flip = can_flip;
> > +
> > +     return skb;
> > +}
> > +
> > +static struct sk_buff *
> > +gve_rx_qpl(struct device *dev, struct net_device *netdev,
> > +        struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
> > +        u16 len, struct napi_struct *napi,
> > +        struct gve_rx_data_slot *data_slot, bool recycle)
> > +{
> > +     struct sk_buff *skb;
>
> empty line here

I'll adjust this.

> > +     /* if raw_addressing mode is not enabled gvnic can only receive into
> > +      * registered segmens. If the buffer can't be recycled, our only
>
> segments?

I'll correct this.

> > +      * choice is to copy the data out of it so that we can return it to the
> > +      * device.
> > +      */
> > +     if (recycle) {
> > +             skb = gve_rx_add_frags(napi, page_info, len);
> > +             /* No point in recycling if we didn't get the skb */
> > +             if (skb) {
> > +                     /* Make sure the networking stack can't free the page */
> > +                     get_page(page_info->page);
> > +                     gve_rx_flip_buff(page_info, data_slot);
> > +             }
> > +     } else {
> > +             skb = gve_rx_copy(netdev, napi, page_info, len);
> > +             if (skb) {
> > +                     u64_stats_update_begin(&rx->statss);
> > +                     rx->rx_copied_pkt++;
> > +                     u64_stats_update_end(&rx->statss);
> > +             }
> > +     }
> >       return skb;
> >  }
>
> > @@ -490,14 +525,46 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
> >
> >       while ((fill_cnt & rx->mask) != (rx->cnt & rx->mask)) {
> >               u32 idx = fill_cnt & rx->mask;
> > -             struct gve_rx_slot_page_info *page_info = &rx->data.page_info[idx];
> > -             struct gve_rx_data_slot *data_slot = &rx->data.data_ring[idx];
> > -             struct device *dev = &priv->pdev->dev;
> > +             struct gve_rx_slot_page_info *page_info =
> > +                                             &rx->data.page_info[idx];
> >
> > -             gve_rx_free_buffer(dev, page_info, data_slot);
> > -             page_info->page = NULL;
> > -             if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
> > -                     break;
> > +             if (page_info->can_flip) {
> > +                     /* The other half of the page is free because it was
> > +                      * free when we processed the descriptor. Flip to it.
> > +                      */
> > +                     struct gve_rx_data_slot *data_slot =
> > +                                             &rx->data.data_ring[idx];
> > +
> > +                     gve_rx_flip_buff(page_info, data_slot);
> > +                     page_info->can_flip = false;
> > +             } else {
> > +                     /* It is possible that the networking stack has already
> > +                      * finished processing all outstanding packets in the buffer
> > +                      * and it can be reused.
> > +                      * Flipping is unnecessary here - if the networking stack still
> > +                      * owns half the page it is impossible to tell which half. Either
> > +                      * the whole page is free or it needs to be replaced.
> > +                      */
> > +                     int recycle = gve_rx_can_recycle_buffer(page_info->page);
> > +
> > +                     if (recycle < 0) {
> > +                             gve_schedule_reset(priv);
> > +                             return false;
> > +                     }
> > +                     if (!recycle) {
> > +                             /* We can't reuse the buffer - alloc a new one*/
> > +                             struct gve_rx_data_slot *data_slot =
> > +                                             &rx->data.data_ring[idx];
> > +                             struct device *dev = &priv->pdev->dev;
> > +
> > +                             gve_rx_free_buffer(dev, page_info, data_slot);
> > +                             page_info->page = NULL;
> > +                             if (gve_rx_alloc_buffer(priv, dev, page_info,
> > +                                                     data_slot, rx)) {
> > +                                     break;
>
> What if the queue runs completely dry during memory shortage?
> You need some form of delayed work to periodically refill
> the free buffers, right?

Thanks, this looks like it will require modifications that will need
to be well tested.
Just for my own curiosity, how common of an occurrence are such memory
shortages?

>
> > +                             }
>
> parens unnecessary

I'll adjust this.
