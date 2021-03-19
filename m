Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906CF342663
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhCSTlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhCSTlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 15:41:16 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DBAC06174A;
        Fri, 19 Mar 2021 12:41:05 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k4so3434796plk.5;
        Fri, 19 Mar 2021 12:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dh1nzjBIr2bRJaiR4CEWujMGTbheJgRq70Upx+kZz1Q=;
        b=s0z09CPqCn5AccsFXJ/30J2EhdbneqRm6xh3bHb8I4QXeMucmVRwqK6cI575XRF8nM
         QFO6mf8BrfSSJdP2f/+iPTLo3/EyUudriU5o/j14s6WByxZOMwCG+1ojDWVNACnssw5O
         f5a5+jMX3tXVQ7X15KOWoOcdLw03KgbkpLQtj6p6xk91s0OkD/lpKBe6uqiGxO/Ka5p5
         i4Nz6keOuRbiLS6DV6tNkIqt0JKu11yZlWFNIYw8F298n67dvq8MfZK24uiYOeqrFxFj
         602WX4eAU49U1lsswYkoDqmKMLwwBGtg8OXDrSRqfd8XxpANiiEqw0bF6otxXJPhFtgf
         fsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dh1nzjBIr2bRJaiR4CEWujMGTbheJgRq70Upx+kZz1Q=;
        b=f6oG4wRV58NJkSlNatLp69fuujHHzsKKcaiJHMrfJqgd9fAQj9lwbnN/VDNrCdbLJa
         AxJlDhRtWsu2PL6lXvYilwMe9RofVUeoj3tsM0/Gb5eciTrmNd5AH3iyllLkr7JPIcBR
         l1sgjPP2EhptYg6cnzpOGpYzdr6akSdzYlvHB9/QowhqP/uSiAt6FqQ0/j4cV6MumSJW
         D5SNpX88FDDYhvUwHfFXWBwkcIKrB899+4IL+aWPA4MioNoZkjTXkTX2U9y/s0kpD7rg
         2smXgeS4jESyNPc72g/i2HjfRcsktDAWGohpwpf1v4DKLRws5xKyAnAAjd4g5Uvxxg+h
         PVXA==
X-Gm-Message-State: AOAM530Rw/80pITd7ctZVid3p5+KiVxRhukvCfJ4khtcSEOF+TfqjkuF
        +nSIgpaReXMsjChIpwQkmrC+fYrY4oVumgWYAS4=
X-Google-Smtp-Source: ABdhPJz422u6ZXPs+Mj0ZbcvaM1gxOsqCKD+JiZ3TGkDpAveC5kfw8xmJsiuTIq91CtbmgxqkyduvdgbrV4PFx/YDks=
X-Received: by 2002:a17:90a:8b16:: with SMTP id y22mr76528pjn.191.1616182864704;
 Fri, 19 Mar 2021 12:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 19 Mar 2021 12:40:53 -0700
Message-ID: <CAM_iQpXU_jAbE4TC3ezZbfbYmYeViVgea+xyqPAxc5XTL9+cVw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix packet stuck problem for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        bpf <bpf@vger.kernel.org>, Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>, Jike Song <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 11:52 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Lockless qdisc has below concurrent problem:
>         cpu0                  cpu1
>           .                     .
>      q->enqueue                 .
>           .                     .
>    qdisc_run_begin()            .
>           .                     .
>      dequeue_skb()              .
>           .                     .
>    sch_direct_xmit()            .
>           .                     .
>           .                q->enqueue
>           .             qdisc_run_begin()
>           .            return and do nothing
>           .                     .
> qdisc_run_end()                 .
>
> cpu1 enqueue a skb without calling __qdisc_run() because cpu0
> has not released the lock yet and spin_trylock() return false
> for cpu1 in qdisc_run_begin(), and cpu0 do not see the skb
> enqueued by cpu1 when calling dequeue_skb() because cpu1 may
> enqueue the skb after cpu0 calling dequeue_skb() and before
> cpu0 calling qdisc_run_end().
>
> Lockless qdisc has another concurrent problem when tx_action
> is involved:
>
> cpu0(serving tx_action)     cpu1             cpu2
>           .                   .                .
>           .              q->enqueue            .
>           .            qdisc_run_begin()       .
>           .              dequeue_skb()         .
>           .                   .            q->enqueue
>           .                   .                .
>           .             sch_direct_xmit()      .
>           .                   .         qdisc_run_begin()
>           .                   .       return and do nothing
>           .                   .                .
> clear __QDISC_STATE_SCHED     .                .
>     qdisc_run_begin()         .                .
> return and do nothing         .                .
>           .                   .                .
>           .          qdisc_run_begin()         .
>
> This patch fixes the above data race by:
> 1. Set a flag after spin_trylock() return false.
> 2. Retry a spin_trylock() in case other CPU may not see the
>    new flag after it releases the lock.
> 3. reschedule if the flag is set after the lock is released
>    at the end of qdisc_run_end().
>
> For tx_action case, the flags is also set when cpu1 is at the
> end if qdisc_run_begin(), so tx_action will be rescheduled
> again to dequeue the skb enqueued by cpu2.
>
> Also clear the flag before dequeuing in order to reduce the
> overhead of the above process, and aviod doing the heavy
> test_and_clear_bit() at the end of qdisc_run_end().
>
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> For those who has not been following the qdsic scheduling
> discussion, there is packet stuck problem for lockless qdisc,
> see [1], and I has done some cleanup and added some enhanced
> features too, see [2] [3].
> While I was doing the optimization for lockless qdisc, it
> accurred to me that these optimization is useless if there is
> still basic bug in lockless qdisc, even the bug is not easily
> reproducible. So look through [1] again, I found that the data
> race for tx action mentioned by Michael, and thought deep about
> it and came up with this patch trying to fix it.
>
> So I am really appreciated some who still has the reproducer
> can try this patch and report back.
>
> 1. https://lore.kernel.org/netdev/d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com/t/#ma7013a79b8c4d8e7c49015c724e481e6d5325b32
> 2. https://patchwork.kernel.org/project/netdevbpf/patch/1615777818-13969-1-git-send-email-linyunsheng@huawei.com/
> 3. https://patchwork.kernel.org/project/netdevbpf/patch/1615800610-34700-1-git-send-email-linyunsheng@huawei.com/
> ---
>  include/net/sch_generic.h | 23 ++++++++++++++++++++---
>  net/sched/sch_generic.c   |  1 +
>  2 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index f7a6e14..4220eab 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -36,6 +36,7 @@ struct qdisc_rate_table {
>  enum qdisc_state_t {
>         __QDISC_STATE_SCHED,
>         __QDISC_STATE_DEACTIVATED,
> +       __QDISC_STATE_NEED_RESCHEDULE,
>  };
>
>  struct qdisc_size_table {
> @@ -159,8 +160,17 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  {
>         if (qdisc->flags & TCQ_F_NOLOCK) {
> -               if (!spin_trylock(&qdisc->seqlock))
> -                       return false;
> +               if (!spin_trylock(&qdisc->seqlock)) {
> +                       set_bit(__QDISC_STATE_NEED_RESCHEDULE,
> +                               &qdisc->state);

Why do we need another bit? I mean why not just call __netif_schedule()?

> +
> +                       /* Retry again in case other CPU may not see the
> +                        * new flags after it releases the lock at the
> +                        * end of qdisc_run_end().
> +                        */
> +                       if (!spin_trylock(&qdisc->seqlock))
> +                               return false;
> +               }
>                 WRITE_ONCE(qdisc->empty, false);
>         } else if (qdisc_is_running(qdisc)) {
>                 return false;
> @@ -176,8 +186,15 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>  {
>         write_seqcount_end(&qdisc->running);
> -       if (qdisc->flags & TCQ_F_NOLOCK)
> +       if (qdisc->flags & TCQ_F_NOLOCK) {
>                 spin_unlock(&qdisc->seqlock);
> +
> +               if (unlikely(test_bit(__QDISC_STATE_NEED_RESCHEDULE,
> +                                     &qdisc->state) &&
> +                            !test_bit(__QDISC_STATE_DEACTIVATED,
> +                                      &qdisc->state)))

Testing two bits one by one is not atomic...


> +                       __netif_schedule(qdisc);
> +       }
>  }
>
>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 44991ea..25d75d8 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -205,6 +205,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
>         const struct netdev_queue *txq = q->dev_queue;
>         struct sk_buff *skb = NULL;
>
> +       clear_bit(__QDISC_STATE_NEED_RESCHEDULE, &q->state);
>         *packets = 1;
>         if (unlikely(!skb_queue_empty(&q->gso_skb))) {
>                 spinlock_t *lock = NULL;
> --
> 2.7.4
>
