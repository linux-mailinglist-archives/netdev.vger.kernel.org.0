Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065CC6B6D46
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 03:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCMCGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 22:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCMCGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 22:06:00 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA3E2B9C0;
        Sun, 12 Mar 2023 19:05:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id er25so14652075edb.5;
        Sun, 12 Mar 2023 19:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678673155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TsW3dvHtBacErIgFhlA9bXaiByEkzIAm0g3kJvWL330=;
        b=AvTgFNH5ntUuH4XHlxfqLkR/SCOaFqBxVB9pwoWY3LXiTovQuHfsZGnFfivs+IOynF
         VVN3UJVlSUCj8XQPypnmXVZ4dYbC2nJtvPHzftFvRtG7XxeHJXli4ZFs5JsQdCYQUib8
         DYKz0X91I2/z/wwK/7s8+UFw6x3+KwnhYrowD78rO0OXCNu77I+L5huDXAp2UjeFIyUM
         OXE/HHLM94o8lqFS8+rMUE7cLG7sRQaRHBNQjY/OucgptCZy6jOpyi51d58FpeUWj1O2
         6QVZO9CqIJZmLWC1K8ZDpmBiOhty9zdVyTM7Cegeogu1TSOCAycvzwwmogZuurI/sPhB
         BibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678673155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TsW3dvHtBacErIgFhlA9bXaiByEkzIAm0g3kJvWL330=;
        b=IjIHA0pPtyJ0/Tq9TMSFiV2giZL0RNBoS1s/cVMAPp6ucOq4wEEehAHg5JveKdYIDz
         42EX2mJ8u04h7/QzaIfwWzpQ6OZ0ALp8IokIXlainfQg2YmZNy7Mmrt5ajsDm345qhH9
         0c4tDuCpxws4b/5MJMNWtDQkXWYJxlj88FyvuF0JGEQRRlKcbcDP4pjRG5oubeq4N+P3
         xrBtD/kTxHnLACkISS13zQlJRvqAODz5Iv6qKVNEl3uvx23k11706l1g255wrOVvvNAE
         PtPDiEGTvf9+mZXvkeC7NSratcS9BsM9vBuUf7+V4HkC4Y9AwLTRsM8KqoPHX+N8PpxQ
         XK7A==
X-Gm-Message-State: AO0yUKUXPK9V7pNC9YUQmlWpqMvoASiVMgJtNTIIqa7vSxyPAM4h8laR
        E+mZ9wat2lal5VSf7j9VwWex5rM/7XUCwtdGRl4=
X-Google-Smtp-Source: AK7set8dwZ7chPbJDgI5Wm0jdSvSFA14kZJy9hH1qpnVwcv7EKQhPP2lEUs0hKPTR0ZNojoIgHGCoJFxeSfxI6IY82s=
X-Received: by 2002:a17:906:40a:b0:926:8f9:735d with SMTP id
 d10-20020a170906040a00b0092608f9735dmr1552916eja.3.1678673155199; Sun, 12 Mar
 2023 19:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230311163614.92296-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230311163614.92296-1-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 13 Mar 2023 10:05:18 +0800
Message-ID: <CAL+tcoAwodpnE2NjMLPhBbmHUvmKMgSykqx0EQ4YZaQHjrx0Hw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: introduce budget_squeeze to help us tune rx behavior
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     kuniyu@amazon.com, liuhangbin@gmail.com, xiangxia.m.yue@gmail.com,
        jiri@nvidia.com, andy.ren@getcruise.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 12:36=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.=
com> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> When we encounter some performance issue and then get lost on how
> to tune the budget limit and time limit in net_rx_action() function,
> we can separately counting both of them to avoid the confusion.
>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> note: this commit is based on the link as below:
> https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail=
.com/
> ---
>  include/linux/netdevice.h |  1 +
>  net/core/dev.c            | 12 ++++++++----
>  net/core/net-procfs.c     |  9 ++++++---
>  3 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6a14b7b11766..5736311a2133 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3157,6 +3157,7 @@ struct softnet_data {
>         /* stats */
>         unsigned int            processed;
>         unsigned int            time_squeeze;
> +       unsigned int            budget_squeeze;
>  #ifdef CONFIG_RPS
>         struct softnet_data     *rps_ipi_list;
>  #endif
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 253584777101..bed7a68fdb5d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct s=
oftirq_action *h)
>         unsigned long time_limit =3D jiffies +
>                 usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
>         int budget =3D READ_ONCE(netdev_budget);
> +       bool is_continue =3D true;

I kept thinking during these days, I think it looks not that concise
and elegant and also the name is not that good though the function can
work.

In the next submission, I'm going to choose to use 'while()' instead
of 'for()' suggested by Stephen.

Does anyone else have some advice about this?

Thanks,
Jason

>         LIST_HEAD(list);
>         LIST_HEAD(repoll);
>
> @@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct s=
oftirq_action *h)
>         list_splice_init(&sd->poll_list, &list);
>         local_irq_enable();
>
> -       for (;;) {
> +       for (; is_continue;) {
>                 struct napi_struct *n;
>
>                 skb_defer_free_flush(sd);
> @@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
>                  * Allow this to run for 2 jiffies since which will allow
>                  * an average latency of 1.5/HZ.
>                  */
> -               if (unlikely(budget <=3D 0 ||
> -                            time_after_eq(jiffies, time_limit))) {
> +               if (unlikely(budget <=3D 0)) {
> +                       sd->budget_squeeze++;
> +                       is_continue =3D false;
> +               }
> +               if (unlikely(time_after_eq(jiffies, time_limit))) {
>                         sd->time_squeeze++;
> -                       break;
> +                       is_continue =3D false;
>                 }
>         }
>
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 97a304e1957a..4d1a499d7c43 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -174,14 +174,17 @@ static int softnet_seq_show(struct seq_file *seq, v=
oid *v)
>          */
>         seq_printf(seq,
>                    "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08=
x %08x %08x "
> -                  "%08x %08x\n",
> -                  sd->processed, sd->dropped, sd->time_squeeze, 0,
> +                  "%08x %08x %08x %08x\n",
> +                  sd->processed, sd->dropped,
> +                  0, /* was old way to count time squeeze */
> +                  0,
>                    0, 0, 0, 0, /* was fastroute */
>                    0,   /* was cpu_collision */
>                    sd->received_rps, flow_limit_count,
>                    0,   /* was len of two backlog queues */
>                    (int)seq->index,
> -                  softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd));
> +                  softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd),
> +                  sd->time_squeeze, sd->budget_squeeze);
>         return 0;
>  }
>
> --
> 2.37.3
>
