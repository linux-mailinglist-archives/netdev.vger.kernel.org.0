Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8EC129A52
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 20:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfLWTS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 14:18:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55028 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfLWTS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 14:18:57 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so416864wmj.4
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 11:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ilyqp8p7Wai1IJck02Dvh2KZjdBoxfvq0LZxUT37UmM=;
        b=gMl/ISF/du+ShiUGgK+uLCFc0JYnFW8n9MBzmjeOM5iWHVxZAuXHItxd4F46pt8ejK
         D7RY2X2KSAHevQahGROHNWCdgS5B4JrKVcV9JtFyvAlgy5tTJsvhKX6qcEaq0j+A37mF
         pZQkQzLzeZR1rQhppwg7GJiGha5dxpIIWiiu7Ydck8Wfc1OeDEUR1QOJe6e0EEPHIbiA
         Ir1iHYXzJK4KtCQd2AuDcZX5oPIPoM1ATTj/KOTYb9xxS6IoYntgDLaRr0tiI+ZHLmHA
         JXx6xPfVVphvJesyp+7hGhUXT1ODAkTAbYMVywu8RSKcwt6BhDOggb+E9Mr7h4YCJe0f
         FK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ilyqp8p7Wai1IJck02Dvh2KZjdBoxfvq0LZxUT37UmM=;
        b=I4yOv+xOo5TcmdzlMMr55vvt8FYi0d1Meuh/+xZyt9w6P/9UTz0wyPStpDFHeb50bj
         wtjs76iFHMuJReWJDUpadD+SUxqvxWAv0BqqLvJQjVkJW7Qm58xoh+FiL/yHuAJa93pi
         PrVBJ5SOrJLKIzZGxLznTVN4dGURYBgUmXrsVRqDd9S0JGAjZ12ypGdtF41PM8/ZAQAp
         CSFifguJwa2xB1a8XBnMlxdceFjt/ZZlhgXtBM2e9rPlGyy0RZdIBp7gN0hl+uy9zojE
         6hV2RTrAWoI5/Fgr2pUIttk9Jx15L86fU8iPd2YVAOQwJF4YH0+D9cuoyHUBeKrT4Xmj
         fQGw==
X-Gm-Message-State: APjAAAX/lFV2Rf4d+o7AyAu6OTskndRl+sfZudtLZmYGrKsb53Lq3eCI
        wKXErrIMz7TsSVLvEhvZ/kTcVGt/yk/MgY3g4XsPiQ==
X-Google-Smtp-Source: APXvYqzsWwFsO5+mgIqoUtciX8Hz/Qe9zWqTIJvo8IwEBRANkllVgzqzMoRkd3gIH27gdNp8OoM89vW503/ycQOsWnE=
X-Received: by 2002:a7b:c851:: with SMTP id c17mr403061wml.71.1577128734478;
 Mon, 23 Dec 2019 11:18:54 -0800 (PST)
MIME-Version: 1.0
References: <20191223191324.49554-1-edumazet@google.com>
In-Reply-To: <20191223191324.49554-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 23 Dec 2019 14:18:17 -0500
Message-ID: <CACSApvYvgiqbvAfSt_LVWGU3_crPO7hfoOd6+=Wh2Tsdnsj0BQ@mail.gmail.com>
Subject: Re: [PATCH net] net_sched: sch_fq: properly set sk->sk_pacing_status
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 2:13 PM Eric Dumazet <edumazet@google.com> wrote:
>
> If fq_classify() recycles a struct fq_flow because
> a socket structure has been reallocated, we do not
> set sk->sk_pacing_status immediately, but later if the
> flow becomes detached.
>
> This means that any flow requiring pacing (BBR, or SO_MAX_PACING_RATE)
> might fallback to TCP internal pacing, which requires a per-socket
> high resolution timer, and therefore more cpu cycles.
>
> Fixes: 218af599fa63 ("tcp: internal implementation for pacing")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice catch! Thanks for the fix!

> ---
>  net/sched/sch_fq.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> index b1c7e726ce5d1ae139f765c5b92dfdaea9bee258..ff4c5e9d0d7778d86f20f4bd67cc627eed0713d9 100644
> --- a/net/sched/sch_fq.c
> +++ b/net/sched/sch_fq.c
> @@ -301,6 +301,9 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
>                                      f->socket_hash != sk->sk_hash)) {
>                                 f->credit = q->initial_quantum;
>                                 f->socket_hash = sk->sk_hash;
> +                               if (q->rate_enable)
> +                                       smp_store_release(&sk->sk_pacing_status,
> +                                                         SK_PACING_FQ);
>                                 if (fq_flow_is_throttled(f))
>                                         fq_flow_unset_throttled(q, f);
>                                 f->time_next_packet = 0ULL;
> @@ -322,8 +325,12 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
>
>         fq_flow_set_detached(f);
>         f->sk = sk;
> -       if (skb->sk == sk)
> +       if (skb->sk == sk) {
>                 f->socket_hash = sk->sk_hash;
> +               if (q->rate_enable)
> +                       smp_store_release(&sk->sk_pacing_status,
> +                                         SK_PACING_FQ);
> +       }
>         f->credit = q->initial_quantum;
>
>         rb_link_node(&f->fq_node, parent, p);
> @@ -428,17 +435,9 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>         f->qlen++;
>         qdisc_qstats_backlog_inc(sch, skb);
>         if (fq_flow_is_detached(f)) {
> -               struct sock *sk = skb->sk;
> -
>                 fq_flow_add_tail(&q->new_flows, f);
>                 if (time_after(jiffies, f->age + q->flow_refill_delay))
>                         f->credit = max_t(u32, f->credit, q->quantum);
> -               if (sk && q->rate_enable) {
> -                       if (unlikely(smp_load_acquire(&sk->sk_pacing_status) !=
> -                                    SK_PACING_FQ))
> -                               smp_store_release(&sk->sk_pacing_status,
> -                                                 SK_PACING_FQ);
> -               }
>                 q->inactive_flows--;
>         }
>
> --
> 2.24.1.735.g03f4e72817-goog
>
