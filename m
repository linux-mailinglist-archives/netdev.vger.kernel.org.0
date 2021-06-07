Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF9D39E354
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhFGQXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:23:05 -0400
Received: from mail-yb1-f169.google.com ([209.85.219.169]:37577 "EHLO
        mail-yb1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhFGQVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 12:21:02 -0400
Received: by mail-yb1-f169.google.com with SMTP id b13so25784741ybk.4
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 09:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MV+9NJq8hSxrs3BluzGqACdFKjLkhEDUmC0/TKvVOIA=;
        b=m/4kFfE29MhEPz43xVR02ET/+M1QFeaxDOT05Vw/mipuCVXVy95G9TS17GFhHEI39F
         LwmeVo+g8hr3Fqr45sB693AfYPsBwggKkgTwJL6c/A7eecR6+4+yuwD7kgsD8JM4uj2S
         q0SM/VnuQy98Qy816RMAE4YlvRAONd+WW7mlDaImUUpX0S1X3uAv9zV4d+THT6iwzCAM
         AZLj+6Jcce74SZoSE980FVV6oAopht9qfgZUYxiFNw2b162O0TJTxfK/Y/mhlGZmCUN+
         qjVNfQPLBrXlhs9OTh1+FWGGEsmB7bMXcrRVfPWX0rupf24SzKCBF0pzq3XYHtSuCzI5
         0twQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MV+9NJq8hSxrs3BluzGqACdFKjLkhEDUmC0/TKvVOIA=;
        b=uaJ/wGViiNbfOKNumUg5TI8IC7h2yeL7jsP0+tjVC6Y4BLPlo5dbnO3tm28ZWgm+PL
         ZTpiWEizhVV0lsmi30dS+Fb7Mfv3n+1w+zuS9LtJWk+DCdiELjkvcKTJ6KrvIDIRsaHm
         n9MhohFH87ewqEQU1/BIfc+9/iHXI9I5b4IlWvc1sYXTAY+6DlINSrXOswWC5hiySAwN
         haMLeWUrK8xC/JoaP2T9h+R9TYh2HFhU23a1Qk86LHL/bnzgz9YGMkTdJsAGT03kyIt3
         hfxegE3+C1knmc0knJm3JsY3bknNqZiGFlps1FZfInJtK1QPbKgk+B1mAQfw/zxttlhI
         lzBA==
X-Gm-Message-State: AOAM532ErroYfQopNG5RX0B3tGyvGZTW7roDchWj/cCABo+feECb8ZhN
        XQtwK+PGhQzdKBcnPpQjjQ4zVyTxyxklqHxYSFIEogsUCqfcTg==
X-Google-Smtp-Source: ABdhPJxWx604ZFyh85gZh+u9i5c7gVfJxtTqZMDtnetR3myleybNU4ksCyQmpSZvH/85qA+yNlPdeQKbwHqOj8ppifQ=
X-Received: by 2002:a05:6902:4b2:: with SMTP id r18mr25188990ybs.446.1623082676985;
 Mon, 07 Jun 2021 09:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210607154534.57034-1-dust.li@linux.alibaba.com>
In-Reply-To: <20210607154534.57034-1-dust.li@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Jun 2021 18:17:45 +0200
Message-ID: <CANn89i+dDy6ev50mBMwoK7f0NN+0xHf8V-Jas8zAmew02hJV4w@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: avoid spurious loopback retransmit
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 5:45 PM Dust Li <dust.li@linux.alibaba.com> wrote:
>
> We found there are pretty much loopback TCP retransmitions
> on our online servers. Most of them are TLP retransmition.
>
> This is because for loopback communication, TLP is usally
> triggered about 2ms after the last packet was sent if no
> ACK was received within that period.
> This condition can be met if there are some kernel tasks
> running on that CPU for more than 2ms, which delays the
> softirq to process the sd->backlog.
>
> We sampled the loopback TLP retransmit on our online servers,
> and found an average 2K+ retransmit per hour. But in some cases,
> this can be much bigger, I found a peak 40 retrans/s on the
> same server.
> Actually, those loopback retransmitions are not a big problem as
> long as they don't happen too frequently. It's just spurious and
> meanless and waste some CPU cycles.

So, why do you send such a patch, adding a lot of code ?

>
> I also write a test module which just busy-loop in the kernel
> for more then 2ms, and the lo retransmition can be triggered
> every time we run the busy-loop on the target CPU.
> With this patch, the retransmition is gone and the throughput
> is not affected.


This makes no sense to me.

Are you running a pristine linux kernel, or some modified version of it ?

Why loopback is magical, compared to veth pair ?

The only case where skb_fclone_busy() might have an issue is when a driver
is very slow to perform tx completion (compared to possible RTX)

But given that the loopback driver does an skb_orphan() in its
ndo_start_xmit (loopback_xmit()),
the skb_fclone_busy() should not be fired at all.

(skb->sk is NULL, before packet is 'looped back')

It seems your diagnosis is wrong.

>
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  include/linux/skbuff.h |  7 +++++--
>  net/ipv4/tcp_output.c  | 31 +++++++++++++++++++++++++++----
>  net/xfrm/xfrm_policy.c |  2 +-
>  3 files changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index dbf820a50a39..290e0a6a3a47 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1131,9 +1131,12 @@ struct sk_buff_fclones {
>   * Returns true if skb is a fast clone, and its clone is not freed.
>   * Some drivers call skb_orphan() in their ndo_start_xmit(),
>   * so we also check that this didnt happen.
> + * For loopback, the skb maybe in the target sock's receive_queue
> + * we need to ignore that case.
>   */
>  static inline bool skb_fclone_busy(const struct sock *sk,
> -                                  const struct sk_buff *skb)
> +                                  const struct sk_buff *skb,
> +                                  bool is_loopback)
>  {
>         const struct sk_buff_fclones *fclones;
>
> @@ -1141,7 +1144,7 @@ static inline bool skb_fclone_busy(const struct sock *sk,
>
>         return skb->fclone == SKB_FCLONE_ORIG &&
>                refcount_read(&fclones->fclone_ref) > 1 &&
> -              READ_ONCE(fclones->skb2.sk) == sk;
> +              is_loopback ? true : READ_ONCE(fclones->skb2.sk) == sk;
>  }
>
>  /**
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index bde781f46b41..f51a6a565678 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2771,6 +2771,20 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
>         return true;
>  }
>
> +static int sock_is_loopback(const struct sock *sk)
> +{
> +       struct dst_entry *dst;
> +       int loopback = 0;
> +
> +       rcu_read_lock();
> +       dst = rcu_dereference(sk->sk_dst_cache);
> +       if (dst && dst->dev &&
> +           (dst->dev->features & NETIF_F_LOOPBACK))
> +               loopback = 1;
> +       rcu_read_unlock();
> +       return loopback;
> +}
> +
>  /* Thanks to skb fast clones, we can detect if a prior transmit of
>   * a packet is still in a qdisc or driver queue.
>   * In this case, there is very little point doing a retransmit !
> @@ -2778,15 +2792,24 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
>  static bool skb_still_in_host_queue(struct sock *sk,
>                                     const struct sk_buff *skb)
>  {
> -       if (unlikely(skb_fclone_busy(sk, skb))) {
> -               set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
> -               smp_mb__after_atomic();
> -               if (skb_fclone_busy(sk, skb)) {
> +       bool is_loopback = sock_is_loopback(sk);
> +
> +       if (unlikely(skb_fclone_busy(sk, skb, is_loopback))) {
> +               if (!is_loopback) {
> +                       set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
> +                       smp_mb__after_atomic();
> +                       if (skb_fclone_busy(sk, skb, is_loopback)) {
> +                               NET_INC_STATS(sock_net(sk),
> +                                             LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
> +                               return true;
> +                       }
> +               } else {
>                         NET_INC_STATS(sock_net(sk),
>                                       LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
>                         return true;
>                 }
>         }
> +
>         return false;
>  }
>
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index ce500f847b99..f8ea62a840e9 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -2846,7 +2846,7 @@ static int xdst_queue_output(struct net *net, struct sock *sk, struct sk_buff *s
>         struct xfrm_policy *pol = xdst->pols[0];
>         struct xfrm_policy_queue *pq = &pol->polq;
>
> -       if (unlikely(skb_fclone_busy(sk, skb))) {
> +       if (unlikely(skb_fclone_busy(sk, skb, false))) {
>                 kfree_skb(skb);
>                 return 0;
>         }
> --
> 2.19.1.3.ge56e4f7
>
