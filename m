Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FB92AF74E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgKKRUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKKRUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 12:20:49 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8619DC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:20:49 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id t13so2675724ilp.2
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krLIz6BthYBkHg9fDMdohAoXg32HZLw04dplk2NKtFE=;
        b=fKt01Kmn7BWnGwYm967+qe16TLHE6GMd4CZQr94oFbZlGcZ2RLHhzO1Y0Y5SPjQbaU
         27aeLqUMt4S0I9cnRxOn7e/G0THBG0KrouKEtLuwFOJtJQRrwktDzW1ep1jvcxcfUtc4
         BXYTT+mrqUjEve1A8fMHZPxWM8nn4L+61riQkGF8DedHpit4dH6p38YF14d3UxKjagSx
         EHmqiSSGLCBBcmBf+CqTiZYbbkqysQssIvwItkdzjP+Ndf/gsu+Ldvj1WnC/xE02+pZj
         MrhFJU78jNpPgULIvRvMle9qPm7n2QpzVScsqT4WI4ISZyB6YXm6sZOt95cAcHBw0vYw
         43ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krLIz6BthYBkHg9fDMdohAoXg32HZLw04dplk2NKtFE=;
        b=bkgDGkbm+pOJohb7Cf18fP6FXsnBfFfrvMbtqsRxMqWUHChj3z1QyxyIakon7NooAg
         coyPJ4PXTcW3GgsqR6EZtKlKD5APCMiZT0MDR4WxpG7R1WS3ucXu3n1fxjjTkMytvSjh
         LQen1VsdX8gIKwMdZI2sekXyM7+tsSIuALTbs9VvlVZhV5sUM+gCdvhMSdViYib1pCG2
         dx1Yg95+qDl2/HvetlUf6JJsBx9Iku1aOQ0re7Uof2x6OS89Zoqsypzxts8p2gYjuC2v
         r7fbzojIfWmuSRkGQZSzAuqOb461yUjhT22iIA28O3jIRRs0BqeouifpIifFICl8Bpnw
         RV0A==
X-Gm-Message-State: AOAM530g52pmk1bIHL0G1EMOJFgmFxeqGynUes6FMiQxL8I1v/GnC3ba
        Jl1BgO2Zn+yo4hXu6Im8CQ11AJgMxvo95yG5vhWY7lssvR4=
X-Google-Smtp-Source: ABdhPJxBWzF1t6HSvPske72XiFJUkEzrgQOkJPOFEUd6Pin84Hq7U18W4GUEahbouXUf9GThJiL+zRszGN0e+tRsutA=
X-Received: by 2002:a92:cb51:: with SMTP id f17mr18528235ilq.64.1605115248665;
 Wed, 11 Nov 2020 09:20:48 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com> <20201109233659.1953461-4-awogbemila@google.com>
In-Reply-To: <20201109233659.1953461-4-awogbemila@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 11 Nov 2020 09:20:37 -0800
Message-ID: <CAKgT0UcFxqsdWQDxueMA4X90BWM11eDR3Z5f0JhEtbezR226+g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/4] gve: Rx Buffer Recycling
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
>
> This patch lets the driver reuse buffers that have been freed by the
> networking stack.
>
> In the raw addressing case, this allows the driver avoid allocating new
> buffers.
> In the qpl case, the driver can avoid copies.
>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h    |  10 +-
>  drivers/net/ethernet/google/gve/gve_rx.c | 196 +++++++++++++++--------
>  2 files changed, 131 insertions(+), 75 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index a8c589dd14e4..9dcf9fd8d128 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
>         struct page *page;
>         void *page_address;
>         u32 page_offset; /* offset to write to in page */
> +       bool can_flip;

Again avoid putting bool into structures. Preferred approach is to use a u8.

>  };
>
>  /* A list of pages registered with the device during setup and used by a queue
> @@ -500,15 +501,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
>                 return DMA_FROM_DEVICE;
>  }
>
> -/* Returns true if the max mtu allows page recycling */
> -static inline bool gve_can_recycle_pages(struct net_device *dev)
> -{
> -       /* We can't recycle the pages if we can't fit a packet into half a
> -        * page.
> -        */
> -       return dev->max_mtu <= PAGE_SIZE / 2;
> -}
> -
>  /* buffers */
>  int gve_alloc_page(struct gve_priv *priv, struct device *dev,
>                    struct page **page, dma_addr_t *dma,
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index 49646caf930c..ff28581f4427 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -287,8 +287,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
>         return PKT_HASH_TYPE_L2;
>  }
>
> -static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
> -                                  struct net_device *dev,
> +static struct sk_buff *gve_rx_copy(struct net_device *dev,
>                                    struct napi_struct *napi,
>                                    struct gve_rx_slot_page_info *page_info,
>                                    u16 len)
> @@ -306,10 +305,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
>
>         skb->protocol = eth_type_trans(skb, dev);
>
> -       u64_stats_update_begin(&rx->statss);
> -       rx->rx_copied_pkt++;
> -       u64_stats_update_end(&rx->statss);
> -
>         return skb;
>  }
>
> @@ -334,22 +329,90 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
>  {
>         u64 addr = be64_to_cpu(data_ring->addr);
>
> +       /* "flip" to other packet buffer on this page */
>         page_info->page_offset ^= PAGE_SIZE / 2;
>         addr ^= PAGE_SIZE / 2;
>         data_ring->addr = cpu_to_be64(addr);
>  }

So this is just adding a comment to existing code that was added in
patch 2. Perhaps it should have been added in that patch.

> +static bool gve_rx_can_flip_buffers(struct net_device *netdev)
> +{
> +#if PAGE_SIZE == 4096
> +       /* We can't flip a buffer if we can't fit a packet
> +        * into half a page.
> +        */

Seems like this comment is unnecessarily wrapped.

> +       return netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2;
> +#else
> +       /* PAGE_SIZE != 4096 - don't try to reuse */
> +       return false;
> +#endif
> +}
> +

You may look at converting this over to a ternary statement just to save space.

> +static int gve_rx_can_recycle_buffer(struct page *page)
> +{
> +       int pagecount = page_count(page);
> +
> +       /* This page is not being used by any SKBs - reuse */
> +       if (pagecount == 1)
> +               return 1;
> +       /* This page is still being used by an SKB - we can't reuse */
> +       else if (pagecount >= 2)
> +               return 0;
> +       WARN(pagecount < 1, "Pagecount should never be < 1");
> +       return -1;
> +}
> +

So using a page count of 1 is expensive. Really if you are going to do
this you should probably look at how we do it currently in ixgbe.
Basically you want to batch the count updates to avoid expensive
atomic operations per skb.

>  static struct sk_buff *
>  gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
>                       struct gve_rx_slot_page_info *page_info, u16 len,
>                       struct napi_struct *napi,
> -                     struct gve_rx_data_slot *data_slot)
> +                     struct gve_rx_data_slot *data_slot, bool can_flip)
>  {
> -       struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
> +       struct sk_buff *skb;
>
> +       skb = gve_rx_add_frags(napi, page_info, len);

Why split this up?It seemed fine as it was.

>         if (!skb)
>                 return NULL;
>
> +       /* Optimistically stop the kernel from freeing the page by increasing
> +        * the page bias. We will check the refcount in refill to determine if
> +        * we need to alloc a new page.
> +        */
> +       get_page(page_info->page);
> +       page_info->can_flip = can_flip;
> +

Why pass can_flip and page_info only to set it here? Also I don't get
why you are taking an extra reference on the page without checking the
can_flip variable. It seems like this should be set in the page_info
before you call this function and then you call get_page if
page_info->can_flip is true.

> +       return skb;
> +}
> +
> +static struct sk_buff *
> +gve_rx_qpl(struct device *dev, struct net_device *netdev,
> +          struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
> +          u16 len, struct napi_struct *napi,
> +          struct gve_rx_data_slot *data_slot, bool recycle)
> +{
> +       struct sk_buff *skb;
> +
> +       /* if raw_addressing mode is not enabled gvnic can only receive into
> +        * registered segments. If the buffer can't be recycled, our only
> +        * choice is to copy the data out of it so that we can return it to the
> +        * device.
> +        */
> +       if (recycle) {
> +               skb = gve_rx_add_frags(napi, page_info, len);
> +               /* No point in recycling if we didn't get the skb */
> +               if (skb) {
> +                       /* Make sure the networking stack can't free the page */
> +                       get_page(page_info->page);
> +                       gve_rx_flip_buff(page_info, data_slot);

It isn't about the stack freeing the page, it is about letting the
buddy allocator know that when the skb frees the page that we are
still holding a reference to it so it should not free the memory. The
get_page is about what we are doing, not what the stack is doing.

> +               }
> +       } else {
> +               skb = gve_rx_copy(netdev, napi, page_info, len);
> +               if (skb) {
> +                       u64_stats_update_begin(&rx->statss);
> +                       rx->rx_copied_pkt++;
> +                       u64_stats_update_end(&rx->statss);
> +               }
> +       }
>         return skb;
>  }
>
> @@ -363,7 +426,6 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>         struct gve_rx_data_slot *data_slot;
>         struct sk_buff *skb = NULL;
>         dma_addr_t page_bus;
> -       int pagecount;
>         u16 len;
>
>         /* drop this packet */
> @@ -384,64 +446,37 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>         dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
>                                 PAGE_SIZE, DMA_FROM_DEVICE);
>
> -       if (PAGE_SIZE == 4096) {
> -               if (len <= priv->rx_copybreak) {
> -                       /* Just copy small packets */
> -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
> -                       u64_stats_update_begin(&rx->statss);
> -                       rx->rx_copybreak_pkt++;
> -                       u64_stats_update_end(&rx->statss);
> -                       goto have_skb;
> +       if (len <= priv->rx_copybreak) {
> +               /* Just copy small packets */
> +               skb = gve_rx_copy(dev, napi, page_info, len);
> +               u64_stats_update_begin(&rx->statss);
> +               rx->rx_copied_pkt++;
> +               rx->rx_copybreak_pkt++;
> +               u64_stats_update_end(&rx->statss);

I would recommend just storing some local variables in the function
for tracking copied and copybreak packets if possible and only
updating them at the end of the function. Otherwise you are going to
pay a heavy cost on non-64b systems. Also how many threads will be
accessing these stats? If you have mutliple threads all updating the
copied_pkt for small packets it can lead to a heavy amount of cache
thrash.


> +       } else {
> +               bool can_flip = gve_rx_can_flip_buffers(dev);
> +               int recycle = 0;
> +
> +               if (can_flip) {
> +                       recycle = gve_rx_can_recycle_buffer(page_info->page);
> +                       if (recycle < 0) {
> +                               if (!rx->data.raw_addressing)
> +                                       gve_schedule_reset(priv);
> +                               return false;
> +                       }
>                 }
>                 if (rx->data.raw_addressing) {
>                         skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
>                                                     page_info, len, napi,
> -                                                    data_slot);
> -                       goto have_skb;
> -               }
> -               if (unlikely(!gve_can_recycle_pages(dev))) {
> -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
> -                       goto have_skb;
> -               }
> -               pagecount = page_count(page_info->page);
> -               if (pagecount == 1) {
> -                       /* No part of this page is used by any SKBs; we attach
> -                        * the page fragment to a new SKB and pass it up the
> -                        * stack.
> -                        */
> -                       skb = gve_rx_add_frags(napi, page_info, len);
> -                       if (!skb) {
> -                               u64_stats_update_begin(&rx->statss);
> -                               rx->rx_skb_alloc_fail++;
> -                               u64_stats_update_end(&rx->statss);
> -                               return false;
> -                       }
> -                       /* Make sure the kernel stack can't release the page */
> -                       get_page(page_info->page);
> -                       /* "flip" to other packet buffer on this page */
> -                       gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
> -               } else if (pagecount >= 2) {
> -                       /* We have previously passed the other half of this
> -                        * page up the stack, but it has not yet been freed.
> -                        */
> -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
> +                                                   data_slot,
> +                                                   can_flip && recycle);
>                 } else {
> -                       WARN(pagecount < 1, "Pagecount should never be < 1");
> -                       return false;
> +                       skb = gve_rx_qpl(&priv->pdev->dev, dev, rx,
> +                                        page_info, len, napi, data_slot,
> +                                        can_flip && recycle);
>                 }
> -       } else {
> -               if (rx->data.raw_addressing)
> -                       skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
> -                                                   page_info, len, napi,
> -                                                   data_slot);
> -               else
> -                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
>         }
>
> -have_skb:
> -       /* We didn't manage to allocate an skb but we haven't had any
> -        * reset worthy failures.
> -        */
>         if (!skb) {
>                 u64_stats_update_begin(&rx->statss);
>                 rx->rx_skb_alloc_fail++;
> @@ -494,16 +529,45 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
>
>         while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {
>                 struct gve_rx_slot_page_info *page_info;
> -               struct device *dev = &priv->pdev->dev;
> -               struct gve_rx_data_slot *data_slot;
>                 u32 idx = fill_cnt & rx->mask;
>
>                 page_info = &rx->data.page_info[idx];
> -               data_slot = &rx->data.data_ring[idx];
> -               gve_rx_free_buffer(dev, page_info, data_slot);
> -               page_info->page = NULL;
> -               if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
> -                       break;
> +               if (page_info->can_flip) {
> +                       /* The other half of the page is free because it was
> +                        * free when we processed the descriptor. Flip to it.
> +                        */
> +                       struct gve_rx_data_slot *data_slot =
> +                                               &rx->data.data_ring[idx];
> +
> +                       gve_rx_flip_buff(page_info, data_slot);
> +                       page_info->can_flip = false;
> +               } else {
> +                       /* It is possible that the networking stack has already
> +                        * finished processing all outstanding packets in the buffer
> +                        * and it can be reused.
> +                        * Flipping is unnecessary here - if the networking stack still
> +                        * owns half the page it is impossible to tell which half. Either
> +                        * the whole page is free or it needs to be replaced.
> +                        */
> +                       int recycle = gve_rx_can_recycle_buffer(page_info->page);
> +
> +                       if (recycle < 0) {
> +                               if (!rx->data.raw_addressing)
> +                                       gve_schedule_reset(priv);
> +                               return false;
> +                       }
> +                       if (!recycle) {
> +                               /* We can't reuse the buffer - alloc a new one*/
> +                               struct gve_rx_data_slot *data_slot =
> +                                               &rx->data.data_ring[idx];
> +                               struct device *dev = &priv->pdev->dev;
> +
> +                               gve_rx_free_buffer(dev, page_info, data_slot);
> +                               page_info->page = NULL;
> +                               if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
> +                                       break;
> +                       }
> +               }
>                 empty = false;
>                 fill_cnt++;
>         }
> --
> 2.29.2.222.g5d2a92d10f8-goog
>
