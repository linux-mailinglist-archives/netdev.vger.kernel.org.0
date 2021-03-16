Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B526533CF7E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhCPIPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbhCPIPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:15:24 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2541C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:15:24 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id h82so35860059ybc.13
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+D2WnhFAGVgH3O4MSj/CMoZhIgKvhDRo7ugLLfyM64I=;
        b=lDHPMwGR/57tFSrpx+Pq8Kbzuq2Dr7Hy66EiVBF6asU3s8d+kzPpaC82hpMZLwDp1w
         Cxnp6S287cUBoN+Gt6UPUMPLeaErcspN2hHYwS+RrHEAGSvLKBqRsUBCv4VeSMOGDaP2
         0ejgvF2XsFdNx3Mn3RALCNBL1fmCMlwagvBer108ZzKBrAhuoWS4TqKPcc6lZ9XuO+pj
         KULcfuSizrtEQhNiwPLfbHw5I3knLrbd438Sdk+iJWCxXpCEmgpKazXV7IsgLGUmWc5S
         Mk9cnbliXEuTD0uOj6v+enYbUZG8GHBLX4j7Hlwr/6lGwhr6Z+hooZ+EKtbsfW+/niQS
         /wtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+D2WnhFAGVgH3O4MSj/CMoZhIgKvhDRo7ugLLfyM64I=;
        b=ek5rnmwcjwK8XoBdjeg94jd7/Y54AqGzTNzbFokk2C1JzGkRO0lWRhe8fppTAE6Se/
         Bc9gu1OB9TWYtTuTmfSJU5AMDCYo3XwJc2JWsdsrkMOmq883YH1X5shsIQtjeHT5+l56
         ihrgrIhez7rY/Id6Q22HihXvnKiZcVjqZUjws0G6GgaoKvBaLVBl+cux1lHUUxEIKoBY
         Uu0UDx2Lhx5HCRTaX+tE2YOtSO/o9U1/pdEECPegiLJHFe74AMA4UcEs8lZJvgU1BN8M
         WgdKyPEs+VIGwLm8WEF4UO75Ojyqtja4V5NJ90ZRwRNoa9HNPqA4BStbDrRTXkI47Xgm
         Vk5w==
X-Gm-Message-State: AOAM5337Ib+DQdZche71VT3J2jFrZoqD0ATLva3p8TAAqdESLxDLsw83
        Wkm4qu7406m18rEJbCtAytxrhOs2jK9kBCgRHJOG4w==
X-Google-Smtp-Source: ABdhPJyZ71zUr7mOXmphdWyGCs2Ih7JkM1ThwGg7bLMZ+bGNFJHhRrWVrFbPwlPRkG2rrKjT8jUHRccZWpHatnKiPrY=
X-Received: by 2002:a25:2307:: with SMTP id j7mr5403907ybj.518.1615882523533;
 Tue, 16 Mar 2021 01:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <3838b7c2-c32f-aeda-702a-5cb8f712ec0c@huawei.com>
In-Reply-To: <3838b7c2-c32f-aeda-702a-5cb8f712ec0c@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Mar 2021 09:15:11 +0100
Message-ID: <CANn89iKQOxvGkr3g37xT1qkcc55gbRGNkFGcGLQmR1PVaq8RjA@mail.gmail.com>
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 1:35 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/3/16 2:53, Jakub Kicinski wrote:
> > On Mon, 15 Mar 2021 11:10:18 +0800 Yunsheng Lin wrote:
> >> @@ -606,6 +623,11 @@ static const u8 prio2band[TC_PRIO_MAX + 1] = {
> >>   */
> >>  struct pfifo_fast_priv {
> >>      struct skb_array q[PFIFO_FAST_BANDS];
> >> +
> >> +    /* protect against data race between enqueue/dequeue and
> >> +     * qdisc->empty setting
> >> +     */
> >> +    spinlock_t lock;
> >>  };
> >>
> >>  static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
> >> @@ -623,7 +645,10 @@ static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
> >>      unsigned int pkt_len = qdisc_pkt_len(skb);
> >>      int err;
> >>
> >> -    err = skb_array_produce(q, skb);
> >> +    spin_lock(&priv->lock);
> >> +    err = __ptr_ring_produce(&q->ring, skb);
> >> +    WRITE_ONCE(qdisc->empty, false);
> >> +    spin_unlock(&priv->lock);
> >>
> >>      if (unlikely(err)) {
> >>              if (qdisc_is_percpu_stats(qdisc))
> >> @@ -642,6 +667,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
> >>      struct sk_buff *skb = NULL;
> >>      int band;
> >>
> >> +    spin_lock(&priv->lock);
> >>      for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
> >>              struct skb_array *q = band2list(priv, band);
> >>
> >> @@ -655,6 +681,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
> >>      } else {
> >>              WRITE_ONCE(qdisc->empty, true);
> >>      }
> >> +    spin_unlock(&priv->lock);
> >>
> >>      return skb;
> >>  }
> >
> > I thought pfifo was supposed to be "lockless" and this change
> > re-introduces a lock between producer and consumer, no?
>
> Yes, the lock breaks the "lockless" of the lockless qdisc for now
> I do not how to solve the below data race locklessly:
>
>         CPU1:                                   CPU2:
>       dequeue skb                                .
>           .                                      .
>           .                                 enqueue skb
>           .                                      .
>           .                      WRITE_ONCE(qdisc->empty, false);
>           .                                      .
>           .                                      .
> WRITE_ONCE(qdisc->empty, true);


Maybe it is time to fully document/explain how this can possibly work.

lockless qdisc used concurrently by multiple cpus, using
WRITE_ONCE() and READ_ONCE() ?

Just say no to this.

>
> If the above happens, the qdisc->empty is true even if the qdisc has some
> skb, which may cuase out of order or packet stuck problem.
>
> It seems we may need to update ptr_ring' status(empty or not) while
> enqueuing/dequeuing atomically in the ptr_ring implementation.
>
> Any better idea?
