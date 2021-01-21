Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59FF2FEE4E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbhAUPSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732786AbhAUPSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:18:17 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C914C06174A;
        Thu, 21 Jan 2021 07:17:37 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id c132so1555168pga.3;
        Thu, 21 Jan 2021 07:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/I1Zhdd/U+jLdwa3STjnnyFZ+KY+ruNgfzMF7rpwK/g=;
        b=R1Xc+JZazzcIW8vfo7gz8dl1xtvXO13s+o35txwIaOh1XpncgwONX8Lk4VjiVVzYpu
         QxmQPhTiWYP5NjRFDcQTyezUpVnAgnZuhmT6S/6ULKzFbJJcCesAZeF1NlfQu+6J8gt5
         oGkkXkSmVihI0TzPrIvuPqPWbUardSEXK52KRFs4JoT6/6epEVhySvDfyu74yAF3VDim
         7HbNgse6iakf40TUr4T6sqrZPG47jXP1NCvnLI8Ymx16Mp/5Mie45eokjzYBO6Ot0BcD
         H8HY6zmLfRZZ5nXYQNpN5CVmLXWHTXkat6DwkPfJR5hY4YDjo5vrkzx82p1UdnkqvwTC
         W+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/I1Zhdd/U+jLdwa3STjnnyFZ+KY+ruNgfzMF7rpwK/g=;
        b=UcERMUlN+XAh8nJxyCjAJX7mjG8muhx0b8hkZ/ulXhXwxyrphVV5O6ZcySae6PBkEy
         1J+j6YwyWvkgMTOnhD1FEftmA/O9JRATwyMA3SPq0NuxrstJF8H9a+KLs5odDq7i9Upd
         hsoMYRu+4aJ1OBTIl9UFtHzHOl+6xX64eyZHbyvpG1oA64HraQ3TvGjxfRcLbBUMDRR5
         xAgyf8dGARui2h0TC31Rvrz7uvemxXDD9/P8GIivwjfPmUS5E/+gC/+3LQ8rLlwPGi6e
         ahpZ2NUtpRaMqDoX4iH6v470UzqQnWjO+DVt7at9/4cN94dIlPSCSIfqH3qg/xkYeWEB
         8DEg==
X-Gm-Message-State: AOAM530aYkEKtaKjpKDgBHcCMIc4VT9GwIXXhg75Zqx6V90Xd7QFwZRb
        PZurCHw0hxJO6JaOuRw6b2ebRU0rtYj2juIn4jk=
X-Google-Smtp-Source: ABdhPJz/hIA8fF9ZvzLcXP+MpzgyDw4ysTB7w+5XA4bVkvGBuFo5ELyO3FEIPw8UjeHavLQwTqNQEKhfr3C11pzy1Ow=
X-Received: by 2002:a63:d917:: with SMTP id r23mr15178280pgg.126.1611242256796;
 Thu, 21 Jan 2021 07:17:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com> <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 21 Jan 2021 16:17:24 +0100
Message-ID: <CAJ8uoz3eOG+Fn8EUe9_f9SxcAj+0vetg3Y=oxtR9nXCc30wA0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     bpf <bpf@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 2:51 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
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
> ---
>  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 86 insertions(+), 18 deletions(-)

Applied, compiled and tried it out on my NIC that does not support
IFF_TX_SKB_NO_LINEAR and it works fine. Thank you Xuan for all your
efforts. Appreciated.

Now it would be nice if we could get some physical NIC drivers to
support this too. Some probably already do and can just set the bit,
while others need some modifications to support this.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 4a83117..38af7f1 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>         sock_wfree(skb);
>  }
>
> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> +                                             struct xdp_desc *desc)
> +{
> +       u32 len, offset, copy, copied;
> +       struct sk_buff *skb;
> +       struct page *page;
> +       void *buffer;
> +       int err, i;
> +       u64 addr;
> +
> +       skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> +       if (unlikely(!skb))
> +               return ERR_PTR(err);
> +
> +       addr = desc->addr;
> +       len = desc->len;
> +
> +       buffer = xsk_buff_raw_get_data(xs->pool, addr);
> +       offset = offset_in_page(buffer);
> +       addr = buffer - xs->pool->addrs;
> +
> +       for (copied = 0, i = 0; copied < len; i++) {
> +               page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> +
> +               get_page(page);
> +
> +               copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> +
> +               skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +               copied += copy;
> +               addr += copy;
> +               offset = 0;
> +       }
> +
> +       skb->len += len;
> +       skb->data_len += len;
> +       skb->truesize += len;
> +
> +       refcount_add(len, &xs->sk.sk_wmem_alloc);
> +
> +       return skb;
> +}
> +
> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> +                                    struct xdp_desc *desc)
> +{
> +       struct sk_buff *skb;
> +
> +       if (xs->dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
> +               skb = xsk_build_skb_zerocopy(xs, desc);
> +               if (IS_ERR(skb))
> +                       return skb;
> +       } else {
> +               void *buffer;
> +               u32 len;
> +               int err;
> +
> +               len = desc->len;
> +               skb = sock_alloc_send_skb(&xs->sk, len, 1, &err);
> +               if (unlikely(!skb))
> +                       return ERR_PTR(err);
> +
> +               skb_put(skb, len);
> +               buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
> +               err = skb_store_bits(skb, 0, buffer, len);
> +               if (unlikely(err)) {
> +                       kfree_skb(skb);
> +                       return ERR_PTR(err);
> +               }
> +       }
> +
> +       skb->dev = xs->dev;
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
> @@ -446,43 +527,30 @@ static int xsk_generic_xmit(struct sock *sk)
>                 goto out;
>
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
> -               skb = sock_alloc_send_skb(sk, len, 1, &err);
> -               if (unlikely(!skb))
> +               skb = xsk_build_skb(xs, &desc);
> +               if (IS_ERR(skb)) {
> +                       err = PTR_ERR(skb);
>                         goto out;
> +               }
>
> -               skb_put(skb, len);
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
> 1.8.3.1
>
