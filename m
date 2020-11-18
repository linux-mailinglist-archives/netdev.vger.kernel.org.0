Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A098D2B87F2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKRWu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRWu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:50:26 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E0CC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:50:26 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y4so3778901edy.5
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Cr/xl5KHXU8U2cm13iCLdwydR9VULdoGrjIWA9tVGU=;
        b=ZNokYxH+H64cxlDB8ppkxRklEqgY1xvmjaUITIzn2GC2Zt1FGnSFVT1J/3KlUiQdpZ
         2o4GB89mZE/Tsv17oy7XPQrPMImX6WrUNlQwfe6s2rZtQjhBk8C8cedvdA/nqL11RUau
         yq9lu+AdYw1XNcKZ2EsRE0oSxlXrNRPbKyHg+CjgI58Gtt0mDRFiOePaZvm25msBPIT3
         9ACW7EWBK/bMhAswzKD5aPPoEUzZzuBIvbUFfZ4gZwD9a8Za6k6lmdCyy3lX+ah8Iwnh
         F5nqZhAQYFNjoaMDte0CMqqTtlHvwaAIFRR2ucndIf1FEiCOxXdBcVBSYC1EndE159a/
         A91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Cr/xl5KHXU8U2cm13iCLdwydR9VULdoGrjIWA9tVGU=;
        b=CcS+TUjDeoysFspth1CdYRPZtnxngE/7+aftwC1kE8/ZVJqTvJJrbXV1gfrsgXSchU
         yQ49ZaNSndd+MfuXpGeudQIlYQg1QgWracrMZjik6STp9vWzx5YnuErATtSpIgy40W2G
         wNPk9D+zsl8bbgLfcnztLETJE5IutFBP+IEStjmuOlj7R/BjsutvORj7hDDseSsItFJl
         Cf3UrD5ZSVJWIbExDkWF6rsA8g6IRhSua41o0OomlpRCYPw4y2UCP2bREmwdpZ/9h3TI
         ESzz41D4nRZVr6Rn7lnRrgXczAUvy1ajenJD71ZeAL98ANe6FmBse3LrCyTYRZswt1X+
         gNxw==
X-Gm-Message-State: AOAM532g/8n1GfzT3OUT0jNRFxlA6AzOd6bcwkE0u7+H10ku7Ungnhw0
        CFMA+PPQXEwaPw+AbHEHFPZshqyf2ORHheFPLOLagXIFAX0=
X-Google-Smtp-Source: ABdhPJzyxckZj/Fh8zfhEkP312cXB6xLL4e7MKBmpc5jlohr8h36QtisyqbA/FEKiVMxPx9RJDG0zF8VCJTWeTxvMR4=
X-Received: by 2002:a50:b761:: with SMTP id g88mr28215628ede.387.1605739824573;
 Wed, 18 Nov 2020 14:50:24 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-4-awogbemila@google.com> <CAKgT0UcFxqsdWQDxueMA4X90BWM11eDR3Z5f0JhEtbezR226+g@mail.gmail.com>
In-Reply-To: <CAKgT0UcFxqsdWQDxueMA4X90BWM11eDR3Z5f0JhEtbezR226+g@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 18 Nov 2020 14:50:13 -0800
Message-ID: <CAL9ddJfa3dpie_zjFG+6jyJ0H9wXGWXWs_TTaL540kQbGO4U+Q@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/4] gve: Rx Buffer Recycling
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 9:20 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
> >
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
> >  drivers/net/ethernet/google/gve/gve_rx.c | 196 +++++++++++++++--------
> >  2 files changed, 131 insertions(+), 75 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> > index a8c589dd14e4..9dcf9fd8d128 100644
> > --- a/drivers/net/ethernet/google/gve/gve.h
> > +++ b/drivers/net/ethernet/google/gve/gve.h
> > @@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
> >         struct page *page;
> >         void *page_address;
> >         u32 page_offset; /* offset to write to in page */
> > +       bool can_flip;
>
> Again avoid putting bool into structures. Preferred approach is to use a u8.

Ok.

>
> >  };
> >
> >  /* A list of pages registered with the device during setup and used by a queue
> > @@ -500,15 +501,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
> >                 return DMA_FROM_DEVICE;
> >  }
> >
> > -/* Returns true if the max mtu allows page recycling */
> > -static inline bool gve_can_recycle_pages(struct net_device *dev)
> > -{
> > -       /* We can't recycle the pages if we can't fit a packet into half a
> > -        * page.
> > -        */
> > -       return dev->max_mtu <= PAGE_SIZE / 2;
> > -}
> > -
> >  /* buffers */
> >  int gve_alloc_page(struct gve_priv *priv, struct device *dev,
> >                    struct page **page, dma_addr_t *dma,
> > diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> > index 49646caf930c..ff28581f4427 100644
> > --- a/drivers/net/ethernet/google/gve/gve_rx.c
> > +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> > @@ -287,8 +287,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
> >         return PKT_HASH_TYPE_L2;
> >  }
> >
> > -static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
> > -                                  struct net_device *dev,
> > +static struct sk_buff *gve_rx_copy(struct net_device *dev,
> >                                    struct napi_struct *napi,
> >                                    struct gve_rx_slot_page_info *page_info,
> >                                    u16 len)
> > @@ -306,10 +305,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
> >
> >         skb->protocol = eth_type_trans(skb, dev);
> >
> > -       u64_stats_update_begin(&rx->statss);
> > -       rx->rx_copied_pkt++;
> > -       u64_stats_update_end(&rx->statss);
> > -
> >         return skb;
> >  }
> >
> > @@ -334,22 +329,90 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
> >  {
> >         u64 addr = be64_to_cpu(data_ring->addr);
> >
> > +       /* "flip" to other packet buffer on this page */
> >         page_info->page_offset ^= PAGE_SIZE / 2;
> >         addr ^= PAGE_SIZE / 2;
> >         data_ring->addr = cpu_to_be64(addr);
> >  }
>
> So this is just adding a comment to existing code that was added in
> patch 2. Perhaps it should have been added in that patch.

Ok, I'll put it in the earlier patch.

>
> > +static bool gve_rx_can_flip_buffers(struct net_device *netdev)
> > +{
> > +#if PAGE_SIZE == 4096
> > +       /* We can't flip a buffer if we can't fit a packet
> > +        * into half a page.
> > +        */
>
> Seems like this comment is unnecessarily wrapped.

Ok, I'll adjust this.

>
> > +       return netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2;
> > +#else
> > +       /* PAGE_SIZE != 4096 - don't try to reuse */
> > +       return false;
> > +#endif
> > +}
> > +
>
> You may look at converting this over to a ternary statement just to save space.

Ok, I'll do that, thanks.

>
> > +static int gve_rx_can_recycle_buffer(struct page *page)
> > +{
> > +       int pagecount = page_count(page);
> > +
> > +       /* This page is not being used by any SKBs - reuse */
> > +       if (pagecount == 1)
> > +               return 1;
> > +       /* This page is still being used by an SKB - we can't reuse */
> > +       else if (pagecount >= 2)
> > +               return 0;
> > +       WARN(pagecount < 1, "Pagecount should never be < 1");
> > +       return -1;
> > +}
> > +
>
> So using a page count of 1 is expensive. Really if you are going to do
> this you should probably look at how we do it currently in ixgbe.
> Basically you want to batch the count updates to avoid expensive
> atomic operations per skb.

A separate patch will be coming along to change the way the driver
tracks page count.
I thought it would be better to have that reviewed separately since
it's a different issue from what this patch addresses.

>
> >  static struct sk_buff *
> >  gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
> >                       struct gve_rx_slot_page_info *page_info, u16 len,
> >                       struct napi_struct *napi,
> > -                     struct gve_rx_data_slot *data_slot)
> > +                     struct gve_rx_data_slot *data_slot, bool can_flip)
> >  {
> > -       struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
> > +       struct sk_buff *skb;
> >
> > +       skb = gve_rx_add_frags(napi, page_info, len);
>
> Why split this up?It seemed fine as it was.

It was based on a comment from v3 of the patchset.

>
> >         if (!skb)
> >                 return NULL;
> >
> > +       /* Optimistically stop the kernel from freeing the page by increasing
> > +        * the page bias. We will check the refcount in refill to determine if
> > +        * we need to alloc a new page.
> > +        */
> > +       get_page(page_info->page);
> > +       page_info->can_flip = can_flip;
> > +
>
> Why pass can_flip and page_info only to set it here? Also I don't get
> why you are taking an extra reference on the page without checking the
> can_flip variable. It seems like this should be set in the page_info
> before you call this function and then you call get_page if
> page_info->can_flip is true.

I think it's important to call get_page here even for buffers we know
will not be flipped so that if the skb does a put_page twice we would
not run into the WARNing in gve_rx_can_recycle_buffer when trying to
refill buffers.
(Also please note that a future patch changes the way the driver uses
page refcounts)

>
> > +       return skb;
> > +}
> > +
> > +static struct sk_buff *
> > +gve_rx_qpl(struct device *dev, struct net_device *netdev,
> > +          struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
> > +          u16 len, struct napi_struct *napi,
> > +          struct gve_rx_data_slot *data_slot, bool recycle)
> > +{
> > +       struct sk_buff *skb;
> > +
> > +       /* if raw_addressing mode is not enabled gvnic can only receive into
> > +        * registered segments. If the buffer can't be recycled, our only
> > +        * choice is to copy the data out of it so that we can return it to the
> > +        * device.
> > +        */
> > +       if (recycle) {
> > +               skb = gve_rx_add_frags(napi, page_info, len);
> > +               /* No point in recycling if we didn't get the skb */
> > +               if (skb) {
> > +                       /* Make sure the networking stack can't free the page */
> > +                       get_page(page_info->page);
> > +                       gve_rx_flip_buff(page_info, data_slot);
>
> It isn't about the stack freeing the page, it is about letting the
> buddy allocator know that when the skb frees the page that we are
> still holding a reference to it so it should not free the memory. The
> get_page is about what we are doing, not what the stack is doing.

Oh I see, thanks for the explanation. Perhaps a comment like:
/* Make sure that the page isn't freed. */
would be more correct.

>
> > +               }
> > +       } else {
> > +               skb = gve_rx_copy(netdev, napi, page_info, len);
> > +               if (skb) {
> > +                       u64_stats_update_begin(&rx->statss);
> > +                       rx->rx_copied_pkt++;
> > +                       u64_stats_update_end(&rx->statss);
> > +               }
> > +       }
> >         return skb;
> >  }
> >
> > @@ -363,7 +426,6 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
> >         struct gve_rx_data_slot *data_slot;
> >         struct sk_buff *skb = NULL;
> >         dma_addr_t page_bus;
> > -       int pagecount;
> >         u16 len;
> >
> >         /* drop this packet */
> > @@ -384,64 +446,37 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
> >         dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
> >                                 PAGE_SIZE, DMA_FROM_DEVICE);
> >
> > -       if (PAGE_SIZE == 4096) {
> > -               if (len <= priv->rx_copybreak) {
> > -                       /* Just copy small packets */
> > -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
> > -                       u64_stats_update_begin(&rx->statss);
> > -                       rx->rx_copybreak_pkt++;
> > -                       u64_stats_update_end(&rx->statss);
> > -                       goto have_skb;
> > +       if (len <= priv->rx_copybreak) {
> > +               /* Just copy small packets */
> > +               skb = gve_rx_copy(dev, napi, page_info, len);
> > +               u64_stats_update_begin(&rx->statss);
> > +               rx->rx_copied_pkt++;
> > +               rx->rx_copybreak_pkt++;
> > +               u64_stats_update_end(&rx->statss);
>
> I would recommend just storing some local variables in the function
> for tracking copied and copybreak packets if possible and only
> updating them at the end of the function. Otherwise you are going to
> pay a heavy cost on non-64b systems. Also how many threads will be
> accessing these stats? If you have mutliple threads all updating the
> copied_pkt for small packets it can lead to a heavy amount of cache
> thrash.

Thanks for pointing these out. I think the driver will run mostly on
64-bit systems and rarely on 32-bit systems.
Also, the potential cache thrashing issue certainly seems like
something we'd want to look into but we're okay with the driver's
performance presently and this patch doesn't actually change this
aspect of the driver's behavior so perhaps it's best addressed in
another patch. This particular function doesn't loop so we'd probably
need to do more than moving the stats update to the end, which should
probably be done in a different patchset.




>
>
> > +       } else {
> > +               bool can_flip = gve_rx_can_flip_buffers(dev);
> > +               int recycle = 0;
> > +
> > +               if (can_flip) {
> > +                       recycle = gve_rx_can_recycle_buffer(page_info->page);
> > +                       if (recycle < 0) {
> > +                               if (!rx->data.raw_addressing)
> > +                                       gve_schedule_reset(priv);
> > +                               return false;
> > +                       }
> >                 }
> >                 if (rx->data.raw_addressing) {
> >                         skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
> >                                                     page_info, len, napi,
> > -                                                    data_slot);
> > -                       goto have_skb;
> > -               }
> > -               if (unlikely(!gve_can_recycle_pages(dev))) {
> > -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
> > -                       goto have_skb;
> > -               }
> > -               pagecount = page_count(page_info->page);
> > -               if (pagecount == 1) {
> > -                       /* No part of this page is used by any SKBs; we attach
> > -                        * the page fragment to a new SKB and pass it up the
> > -                        * stack.
> > -                        */
> > -                       skb = gve_rx_add_frags(napi, page_info, len);
> > -                       if (!skb) {
> > -                               u64_stats_update_begin(&rx->statss);
> > -                               rx->rx_skb_alloc_fail++;
> > -                               u64_stats_update_end(&rx->statss);
> > -                               return false;
> > -                       }
> > -                       /* Make sure the kernel stack can't release the page */
> > -                       get_page(page_info->page);
> > -                       /* "flip" to other packet buffer on this page */
> > -                       gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
> > -               } else if (pagecount >= 2) {
> > -                       /* We have previously passed the other half of this
> > -                        * page up the stack, but it has not yet been freed.
> > -                        */
> > -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
> > +                                                   data_slot,
> > +                                                   can_flip && recycle);
> >                 } else {
> > -                       WARN(pagecount < 1, "Pagecount should never be < 1");
> > -                       return false;
> > +                       skb = gve_rx_qpl(&priv->pdev->dev, dev, rx,
> > +                                        page_info, len, napi, data_slot,
> > +                                        can_flip && recycle);
> >                 }
> > -       } else {
> > -               if (rx->data.raw_addressing)
> > -                       skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
> > -                                                   page_info, len, napi,
> > -                                                   data_slot);
> > -               else
> > -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
> >         }
> >
> > -have_skb:
> > -       /* We didn't manage to allocate an skb but we haven't had any
> > -        * reset worthy failures.
> > -        */
> >         if (!skb) {
> >                 u64_stats_update_begin(&rx->statss);
> >                 rx->rx_skb_alloc_fail++;
> > @@ -494,16 +529,45 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
> >
> >         while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {
> >                 struct gve_rx_slot_page_info *page_info;
> > -               struct device *dev = &priv->pdev->dev;
> > -               struct gve_rx_data_slot *data_slot;
> >                 u32 idx = fill_cnt & rx->mask;
> >
> >                 page_info = &rx->data.page_info[idx];
> > -               data_slot = &rx->data.data_ring[idx];
> > -               gve_rx_free_buffer(dev, page_info, data_slot);
> > -               page_info->page = NULL;
> > -               if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
> > -                       break;
> > +               if (page_info->can_flip) {
> > +                       /* The other half of the page is free because it was
> > +                        * free when we processed the descriptor. Flip to it.
> > +                        */
> > +                       struct gve_rx_data_slot *data_slot =
> > +                                               &rx->data.data_ring[idx];
> > +
> > +                       gve_rx_flip_buff(page_info, data_slot);
> > +                       page_info->can_flip = false;
> > +               } else {
> > +                       /* It is possible that the networking stack has already
> > +                        * finished processing all outstanding packets in the buffer
> > +                        * and it can be reused.
> > +                        * Flipping is unnecessary here - if the networking stack still
> > +                        * owns half the page it is impossible to tell which half. Either
> > +                        * the whole page is free or it needs to be replaced.
> > +                        */
> > +                       int recycle = gve_rx_can_recycle_buffer(page_info->page);
> > +
> > +                       if (recycle < 0) {
> > +                               if (!rx->data.raw_addressing)
> > +                                       gve_schedule_reset(priv);
> > +                               return false;
> > +                       }
> > +                       if (!recycle) {
> > +                               /* We can't reuse the buffer - alloc a new one*/
> > +                               struct gve_rx_data_slot *data_slot =
> > +                                               &rx->data.data_ring[idx];
> > +                               struct device *dev = &priv->pdev->dev;
> > +
> > +                               gve_rx_free_buffer(dev, page_info, data_slot);
> > +                               page_info->page = NULL;
> > +                               if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
> > +                                       break;
> > +                       }
> > +               }
> >                 empty = false;
> >                 fill_cnt++;
> >         }
> > --
> > 2.29.2.222.g5d2a92d10f8-goog
> >
