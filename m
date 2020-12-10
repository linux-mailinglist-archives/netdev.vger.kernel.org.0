Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2290A2D6B32
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbgLJW4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392429AbgLJWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 17:55:40 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642D2C0619DB;
        Thu, 10 Dec 2020 14:53:49 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id i9so7151567wrc.4;
        Thu, 10 Dec 2020 14:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FOnvm6Baf3m5bMLWZg3kDehjBG8A7+9YWYoLpgMMYBE=;
        b=UR01bWqSSrZnOmF0qD11GNEz54al4WVSIasPXhrmHQf+k7UcyeWv4R6OkrPOv79SgE
         k1rW8h56PkskL8REzVYqP1I5kNut/XyF8eINYH4j1yIgnd+t0J9YBMj2QsmyAXf2DTnL
         /ZupnS0KyyqwcTj9kJF9DmzpdvXoP+ynTn6ODOJP7juL672IaqvChhBqQPYr4V+roMIt
         vy43s40wFE1grh0IJzZqWM/wmLZl2DkbUc+2cVedFW98SoikXYh6PqHaW3fytmNq1TXx
         TGyHHTJ6ZcDozpNFSQCJruR9rc8OxKEep1QyXskcw14M1assuJ1Xhljrx5alqdRzW0EO
         9nDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FOnvm6Baf3m5bMLWZg3kDehjBG8A7+9YWYoLpgMMYBE=;
        b=X/CPuZD/fVXkuN/orCrJ/emiKt0akoPzMklAojZuICU/zJHZ0WwUYgxYyvGNi76DRb
         Ux5ExJ3UE7wKT8NeBXe7QlawAqSiQvU5yNp7XBa/rMKx0GknyCFooOEJjackn9ENn+pG
         oXI8hPzYccJM1Boz8IqcDdpUWFYmWYz9W1gSMFKuK5l8rzK3X3kel0FoWarhXxGmQ1iZ
         yVKa9HgYB4kSbTekO/FH8f1fKRYHoz+z5ZCMjHA+emYS12X5tuj4dzFBMSlsSeGe9K2B
         4AhV/1xU/g48tANjNx5j1dkIK557tzH5WMLrp3GTf/zcmQGeI0ZM8L5O89VxdPNdmEW1
         P4YQ==
X-Gm-Message-State: AOAM533sABcm2lpU8lPrUaFGKVw2g8mSK86xjI1okKluojeOj2UXv2Y4
        DCBZIHKnAydM/WIFxye6q59JbIpXExYhBSFqhWfTci22
X-Google-Smtp-Source: ABdhPJyBTgsANO8Ewc4TwqyNo9GTDY6eu+IbCLiC49Dn/sqblGhomWDdVkJ5HIaRoleZLzVf6V8ycYIBIlW/mnVMFCY=
X-Received: by 2002:a19:8b83:: with SMTP id n125mr3848216lfd.75.1607637184027;
 Thu, 10 Dec 2020 13:53:04 -0800 (PST)
MIME-Version: 1.0
References: <20201210153618.21226-1-magnus.karlsson@gmail.com>
In-Reply-To: <20201210153618.21226-1-magnus.karlsson@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Dec 2020 13:52:52 -0800
Message-ID: <CAADnVQKOjetBFuCVRWPEzephJTeZ7AYaHv+pKfJKia0F8vk=ww@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix race in SKB mode transmit with shared cq
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 7:36 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a race when multiple sockets are simultaneously calling sendto()
> when the completion ring is shared in the SKB case. This is the case
> when you share the same netdev and queue id through the
> XDP_SHARED_UMEM bind flag. The problem is that multiple processes can
> be in xsk_generic_xmit() and call the backpressure mechanism in
> xskq_prod_reserve(xs->pool->cq). As this is a shared resource in this
> specific scenario, a race might occur since the rings are
> single-producer single-consumer.
>
> Fix this by moving the tx_completion_lock from the socket to the pool
> as the pool is shared between the sockets that share the completion
> ring. (The pool is not shared when this is not the case.) And then
> protect the accesses to xskq_prod_reserve() with this lock. The
> tx_completion_lock is renamed cq_lock to better reflect that it
> protects accesses to the potentially shared completion ring.
>
> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Fixes: a9744f7ca200 ("xsk: fix potential race in SKB TX completion code")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  include/net/xdp_sock.h      | 4 ----
>  include/net/xsk_buff_pool.h | 5 +++++
>  net/xdp/xsk.c               | 9 ++++++---
>  net/xdp/xsk_buff_pool.c     | 1 +
>  4 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 4f4e93bf814c..cc17bc957548 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -58,10 +58,6 @@ struct xdp_sock {
>
>         struct xsk_queue *tx ____cacheline_aligned_in_smp;
>         struct list_head tx_list;
> -       /* Mutual exclusion of NAPI TX thread and sendmsg error paths
> -        * in the SKB destructor callback.
> -        */
> -       spinlock_t tx_completion_lock;
>         /* Protects generic receive. */
>         spinlock_t rx_lock;
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 01755b838c74..eaa8386dbc63 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -73,6 +73,11 @@ struct xsk_buff_pool {
>         bool dma_need_sync;
>         bool unaligned;
>         void *addrs;
> +       /* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
> +        * NAPI TX thread and sendmsg error paths in the SKB destructor callback and when
> +        * sockets share a single cq when the same netdev and queue id is shared.
> +        */
> +       spinlock_t cq_lock;
>         struct xdp_buff_xsk *free_heads[];
>  };
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 62504471fd20..42cb5f94d49e 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -364,9 +364,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>         struct xdp_sock *xs = xdp_sk(skb->sk);
>         unsigned long flags;
>
> -       spin_lock_irqsave(&xs->tx_completion_lock, flags);
> +       spin_lock_irqsave(&xs->pool->cq_lock, flags);
>         xskq_prod_submit_addr(xs->pool->cq, addr);
> -       spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
> +       spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>
>         sock_wfree(skb);
>  }
> @@ -378,6 +378,7 @@ static int xsk_generic_xmit(struct sock *sk)
>         bool sent_frame = false;
>         struct xdp_desc desc;
>         struct sk_buff *skb;
> +       unsigned long flags;
>         int err = 0;
>
>         mutex_lock(&xs->mutex);
> @@ -409,10 +410,13 @@ static int xsk_generic_xmit(struct sock *sk)
>                  * if there is space in it. This avoids having to implement
>                  * any buffering in the Tx path.
>                  */
> +               spin_lock_irqsave(&xs->pool->cq_lock, flags);
>                 if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> +                       spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>                         kfree_skb(skb);
>                         goto out;
>                 }
> +               spin_unlock_irqrestore(&xs->pool->cq_lock, flags);

Lock/unlock for every packet?
Do you have any performance concerns?
