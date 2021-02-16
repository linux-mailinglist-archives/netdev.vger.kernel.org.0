Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0061231CB92
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhBPOJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBPOJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 09:09:19 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5224DC061574;
        Tue, 16 Feb 2021 06:08:38 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id d2so5996858pjs.4;
        Tue, 16 Feb 2021 06:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OgRH2QvT55resuzZcjaVbYIuOjjhvKh/QAEvJ9R6nGQ=;
        b=gL/5jjOb8YOhYJ0bd/DdgdvoFPDkLLVLOjPEwrBrH1qe6vR5cWMDfnNE4MLYrGsfTt
         n0WXxRTyioW7yNRv9RI4vt4F18xZOgOK391zZvBeBRZgPbTALmYDLSBLBdtEve8ePQPZ
         qjTbUCLuso+BhK5kCKDH6CqPeHqyRB+mtoE1itjOWOJKCVqxsHTJ0fPgcKktX3SNIIw2
         czoredUeEEJvxFjTgBXUreotGd75lf9zgnq0JBGD6BrOlCgPiNViykS/DDo+VSoEOTFT
         DDvmFHgtSqiP/8rMaDxuEwtD1AyRdb5yrwMVq5CPpUsw/DmJ5m+wpFVdjA300aGOfszY
         h7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OgRH2QvT55resuzZcjaVbYIuOjjhvKh/QAEvJ9R6nGQ=;
        b=DkSxrmhF+tmMo2LY+CCxT2lHnSKcMTvf0i8x+XJQhNjCugV9Ykz5zzUlhxqeuzC6Lu
         ZxVrZWXwn+ABH6Ld+01IySmIGN6vg6HM1N55YbO/4pcnX/tNM2m/obZR1fyRF8EIz5+k
         mDga8m4CLBW4wb1joH9Jxu0dVljafw7SefXFAOmlxt6mb5mKTpxnyZn4hmRmnkSPTH22
         Yb6PsA/9tLHMiJ0bfSe0ox/Eh6gJbOXJQySgGUATWpBnSJjG5uTbPQUAUcYdAJZMldoq
         kiniStk8IRlO0nSZAQOMSTd3syrQ6yDVBlTED/r93nnXI1dPucon/4aQv+laQzdcXYxI
         Hfaw==
X-Gm-Message-State: AOAM531RW57QpKyxdsj8c16RL6J1hvadN5C/InOJaRO3MLnHsyMmMtjj
        5HKQXMe6VGVgADcNojYcK3BE7UODPPmtyRnD1fI=
X-Google-Smtp-Source: ABdhPJxu+oQb/9/N5gLffIC8HYgsK7EHA20Uj2aXGh8/1wT7WQPOroV7eP461eferbZ8t5Woz9Zy/21qiiUie2ihF2c=
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr4515137pjs.117.1613484517788;
 Tue, 16 Feb 2021 06:08:37 -0800 (PST)
MIME-Version: 1.0
References: <20210216113740.62041-1-alobakin@pm.me> <20210216113740.62041-7-alobakin@pm.me>
In-Reply-To: <20210216113740.62041-7-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 16 Feb 2021 15:08:26 +0100
Message-ID: <CAJ8uoz0-ge=_jC8EbR371DMKxYSP8USni5OqVf0yk1-4Z=vnOg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 6/6] xsk: build skb by page (aka generic
 zerocopy xmit)
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 12:44 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> This patch is used to construct skb based on page to save memory copy
> overhead.
>
> This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> directly construct skb. If this feature is not supported, it is still
> necessary to copy data to construct skb.
>
> ---------------- Performance Testing ------------
>
> The test environment is Aliyun ECS server.
> Test cmd:
> ```
> xdpsock -i eth0 -t  -S -s <msg size>
> ```
>
> Test result data:
>
> size    64      512     1024    1500
> copy    1916747 1775988 1600203 1440054
> page    1974058 1953655 1945463 1904478
> percent 3.0%    10.0%   21.58%  32.3%
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> [ alobakin:
>  - expand subject to make it clearer;
>  - improve skb->truesize calculation;
>  - reserve some headroom in skb for drivers;
>  - tailroom is not needed as skb is non-linear ]
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Thank you Alexander!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> ---
>  net/xdp/xsk.c | 119 ++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 95 insertions(+), 24 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 143979ea4165..ff7bd06e1241 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -445,6 +445,96 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>         sock_wfree(skb);
>  }
>
> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> +                                             struct xdp_desc *desc)
> +{
> +       struct xsk_buff_pool *pool = xs->pool;
> +       u32 hr, len, offset, copy, copied;
> +       struct sk_buff *skb;
> +       struct page *page;
> +       void *buffer;
> +       int err, i;
> +       u64 addr;
> +
> +       hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
> +
> +       skb = sock_alloc_send_skb(&xs->sk, hr, 1, &err);
> +       if (unlikely(!skb))
> +               return ERR_PTR(err);
> +
> +       skb_reserve(skb, hr);
> +
> +       addr = desc->addr;
> +       len = desc->len;
> +
> +       buffer = xsk_buff_raw_get_data(pool, addr);
> +       offset = offset_in_page(buffer);
> +       addr = buffer - pool->addrs;
> +
> +       for (copied = 0, i = 0; copied < len; i++) {
> +               page = pool->umem->pgs[addr >> PAGE_SHIFT];
> +               get_page(page);
> +
> +               copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> +               skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +               copied += copy;
> +               addr += copy;
> +               offset = 0;
> +       }
> +
> +       skb->len += len;
> +       skb->data_len += len;
> +       skb->truesize += pool->unaligned ? len : pool->chunk_size;
> +
> +       refcount_add(skb->truesize, &xs->sk.sk_wmem_alloc);
> +
> +       return skb;
> +}
> +
> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> +                                    struct xdp_desc *desc)
> +{
> +       struct net_device *dev = xs->dev;
> +       struct sk_buff *skb;
> +
> +       if (dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
> +               skb = xsk_build_skb_zerocopy(xs, desc);
> +               if (IS_ERR(skb))
> +                       return skb;
> +       } else {
> +               u32 hr, tr, len;
> +               void *buffer;
> +               int err;
> +
> +               hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom));
> +               tr = dev->needed_tailroom;
> +               len = desc->len;
> +
> +               skb = sock_alloc_send_skb(&xs->sk, hr + len + tr, 1, &err);
> +               if (unlikely(!skb))
> +                       return ERR_PTR(err);
> +
> +               skb_reserve(skb, hr);
> +               skb_put(skb, len);
> +
> +               buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
> +               err = skb_store_bits(skb, 0, buffer, len);
> +               if (unlikely(err)) {
> +                       kfree_skb(skb);
> +                       return ERR_PTR(err);
> +               }
> +       }
> +
> +       skb->dev = dev;
> +       skb->priority = xs->sk.sk_priority;
> +       skb->mark = xs->sk.sk_mark;
> +       skb_shinfo(skb)->destructor_arg = (void *)(long)desc->addr;
> +       skb->destructor = xsk_destruct_skb;
> +
> +       return skb;
> +}
> +
>  static int xsk_generic_xmit(struct sock *sk)
>  {
>         struct xdp_sock *xs = xdp_sk(sk);
> @@ -454,56 +544,37 @@ static int xsk_generic_xmit(struct sock *sk)
>         struct sk_buff *skb;
>         unsigned long flags;
>         int err = 0;
> -       u32 hr, tr;
>
>         mutex_lock(&xs->mutex);
>
>         if (xs->queue_id >= xs->dev->real_num_tx_queues)
>                 goto out;
>
> -       hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
> -       tr = xs->dev->needed_tailroom;
> -
>         while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
> -               char *buffer;
> -               u64 addr;
> -               u32 len;
> -
>                 if (max_batch-- == 0) {
>                         err = -EAGAIN;
>                         goto out;
>                 }
>
> -               len = desc.len;
> -               skb = sock_alloc_send_skb(sk, hr + len + tr, 1, &err);
> -               if (unlikely(!skb))
> +               skb = xsk_build_skb(xs, &desc);
> +               if (IS_ERR(skb)) {
> +                       err = PTR_ERR(skb);
>                         goto out;
> +               }
>
> -               skb_reserve(skb, hr);
> -               skb_put(skb, len);
> -
> -               addr = desc.addr;
> -               buffer = xsk_buff_raw_get_data(xs->pool, addr);
> -               err = skb_store_bits(skb, 0, buffer, len);
>                 /* This is the backpressure mechanism for the Tx path.
>                  * Reserve space in the completion queue and only proceed
>                  * if there is space in it. This avoids having to implement
>                  * any buffering in the Tx path.
>                  */
>                 spin_lock_irqsave(&xs->pool->cq_lock, flags);
> -               if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> +               if (xskq_prod_reserve(xs->pool->cq)) {
>                         spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>                         kfree_skb(skb);
>                         goto out;
>                 }
>                 spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>
> -               skb->dev = xs->dev;
> -               skb->priority = sk->sk_priority;
> -               skb->mark = sk->sk_mark;
> -               skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
> -               skb->destructor = xsk_destruct_skb;
> -
>                 err = __dev_direct_xmit(skb, xs->queue_id);
>                 if  (err == NETDEV_TX_BUSY) {
>                         /* Tell user-space to retry the send */
> --
> 2.30.1
>
>
