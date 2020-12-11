Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B57F2D7113
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 08:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436820AbgLKHsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 02:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387673AbgLKHsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 02:48:22 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992EDC0613CF;
        Thu, 10 Dec 2020 23:47:42 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w4so6541181pgg.13;
        Thu, 10 Dec 2020 23:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jzaewMeL4n0XYd6qCTy+8Fdf9ipvRWhwc5onQpdAWPQ=;
        b=XILTh/GdMh7MQ7Yh7QNV6KvFEMaqzSgnhBV3BVwCyjBb4N+u1FQFFcDZsnHul2asGm
         C3xW8/VqEZwoaBlr7NiNidlYBvXWQyCzcS+2J3xwsHR7zNgX8Tx5pIuuNDfZk3Nk35cm
         nu5y4AX1PTY60Rj8DqCY2Xm3l731sPmhQf6W/mNjV7SfeDJxbDqMp8XpuIFhxffAdBjo
         IwICm/PaYzl1E/UV9Ribx8SviBi09xGxptMsknP0WcwWjLrwoK/+/9cZds5684/AQGFo
         ihT0//hkfn89ALK2pJS08XLKW7zTfmWO5CkDXWC6alkImd0wCtb15D6MFe9JL/1/X9kf
         RZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jzaewMeL4n0XYd6qCTy+8Fdf9ipvRWhwc5onQpdAWPQ=;
        b=TZsutXWg3CBAxhFuVWdmYBlV95m70qwTRXxp1GjZWmaV7gEJT9Qwv0JpVJ4ia3KH4r
         ry8PjaWdXBOSxaXEifRQ8ZTNV1u4BjilXXiQCAxKGqT3MbyaX/yPoofo9oNfhralTAOo
         3+5/AMUIhuJMTUho5HjEka56Zbf1sXSBDQOuZsyCC32f3jNWaNXIJoFYzTEN22+S0YAW
         N72ZFAW40OLNG+fRnA3WrcK4mNx8HcNX+btRcMvA5QoiTS07FnJ1tDFeB0JV8KRTd5c3
         P7K11IiIyF08X3M3Cknu4wZQsMxgtNkkxJUo+gjuXT48XRh8Tlyx/Ppguw6MDrAPAav6
         Fiqg==
X-Gm-Message-State: AOAM530QnqSmegM/z639Y3L6TXs3NLgQuVDMvl101ZsLE+ZVb7VSlU/K
        qyPDVXBYfbutXFB8G0Foe5dgCxcTrsCF9bRJbAZAtiwIveNkqE3g
X-Google-Smtp-Source: ABdhPJwWqtisF3FFxCnt8734z6JyCFuEFutoIs+H46cXg2TSLenQIiSL2U55/GXHTedL/zLUdl4H/k+/8Ql/MlNu9qM=
X-Received: by 2002:a62:8895:0:b029:19e:92ec:6886 with SMTP id
 l143-20020a6288950000b029019e92ec6886mr10327934pfd.12.1607672862147; Thu, 10
 Dec 2020 23:47:42 -0800 (PST)
MIME-Version: 1.0
References: <20201210153618.21226-1-magnus.karlsson@gmail.com> <CAADnVQKOjetBFuCVRWPEzephJTeZ7AYaHv+pKfJKia0F8vk=ww@mail.gmail.com>
In-Reply-To: <CAADnVQKOjetBFuCVRWPEzephJTeZ7AYaHv+pKfJKia0F8vk=ww@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 11 Dec 2020 08:47:31 +0100
Message-ID: <CAJ8uoz15TKR7Tpx_brUut7XwHcEMCq90xOh7xFHhp-4+7BOMTQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix race in SKB mode transmit with shared cq
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, Dec 10, 2020 at 10:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Dec 10, 2020 at 7:36 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a race when multiple sockets are simultaneously calling sendto()
> > when the completion ring is shared in the SKB case. This is the case
> > when you share the same netdev and queue id through the
> > XDP_SHARED_UMEM bind flag. The problem is that multiple processes can
> > be in xsk_generic_xmit() and call the backpressure mechanism in
> > xskq_prod_reserve(xs->pool->cq). As this is a shared resource in this
> > specific scenario, a race might occur since the rings are
> > single-producer single-consumer.
> >
> > Fix this by moving the tx_completion_lock from the socket to the pool
> > as the pool is shared between the sockets that share the completion
> > ring. (The pool is not shared when this is not the case.) And then
> > protect the accesses to xskq_prod_reserve() with this lock. The
> > tx_completion_lock is renamed cq_lock to better reflect that it
> > protects accesses to the potentially shared completion ring.
> >
> > Fixes: 35fcde7f8deb ("xsk: support for Tx")
> > Fixes: a9744f7ca200 ("xsk: fix potential race in SKB TX completion code")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  include/net/xdp_sock.h      | 4 ----
> >  include/net/xsk_buff_pool.h | 5 +++++
> >  net/xdp/xsk.c               | 9 ++++++---
> >  net/xdp/xsk_buff_pool.c     | 1 +
> >  4 files changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > index 4f4e93bf814c..cc17bc957548 100644
> > --- a/include/net/xdp_sock.h
> > +++ b/include/net/xdp_sock.h
> > @@ -58,10 +58,6 @@ struct xdp_sock {
> >
> >         struct xsk_queue *tx ____cacheline_aligned_in_smp;
> >         struct list_head tx_list;
> > -       /* Mutual exclusion of NAPI TX thread and sendmsg error paths
> > -        * in the SKB destructor callback.
> > -        */
> > -       spinlock_t tx_completion_lock;
> >         /* Protects generic receive. */
> >         spinlock_t rx_lock;
> >
> > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > index 01755b838c74..eaa8386dbc63 100644
> > --- a/include/net/xsk_buff_pool.h
> > +++ b/include/net/xsk_buff_pool.h
> > @@ -73,6 +73,11 @@ struct xsk_buff_pool {
> >         bool dma_need_sync;
> >         bool unaligned;
> >         void *addrs;
> > +       /* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
> > +        * NAPI TX thread and sendmsg error paths in the SKB destructor callback and when
> > +        * sockets share a single cq when the same netdev and queue id is shared.
> > +        */
> > +       spinlock_t cq_lock;
> >         struct xdp_buff_xsk *free_heads[];
> >  };
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 62504471fd20..42cb5f94d49e 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -364,9 +364,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> >         struct xdp_sock *xs = xdp_sk(skb->sk);
> >         unsigned long flags;
> >
> > -       spin_lock_irqsave(&xs->tx_completion_lock, flags);
> > +       spin_lock_irqsave(&xs->pool->cq_lock, flags);
> >         xskq_prod_submit_addr(xs->pool->cq, addr);
> > -       spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
> > +       spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> >
> >         sock_wfree(skb);
> >  }
> > @@ -378,6 +378,7 @@ static int xsk_generic_xmit(struct sock *sk)
> >         bool sent_frame = false;
> >         struct xdp_desc desc;
> >         struct sk_buff *skb;
> > +       unsigned long flags;
> >         int err = 0;
> >
> >         mutex_lock(&xs->mutex);
> > @@ -409,10 +410,13 @@ static int xsk_generic_xmit(struct sock *sk)
> >                  * if there is space in it. This avoids having to implement
> >                  * any buffering in the Tx path.
> >                  */
> > +               spin_lock_irqsave(&xs->pool->cq_lock, flags);
> >                 if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> > +                       spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> >                         kfree_skb(skb);
> >                         goto out;
> >                 }
> > +               spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>
> Lock/unlock for every packet?
> Do you have any performance concerns?

I have measured and the performance impact of this is in the noise.
There is unfortunately already a lot of code being executed per packet
in this path. On the positive side, once this bug fix trickles down to
bpf-next, I will submit a rather simple patch to this function that
improves throughput by 15% for the txpush microbenchmark. This will
more than compensate for any locking introduced.
