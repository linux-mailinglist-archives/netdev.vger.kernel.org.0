Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10726B87EC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjCNB6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjCNB6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:58:43 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81B36A2D8;
        Mon, 13 Mar 2023 18:58:37 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h8so12402324ede.8;
        Mon, 13 Mar 2023 18:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678759116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ln5orvH1KCueqxGfdeaxW69qj9y07fvda5WEi7cdD+M=;
        b=XSBLTuIi8BHYlA+nG0GcLEwQXS4qqjq2ciu7YELNBQr02U6Fk9bvVzpJ7pQuk9b7L4
         svF0P7QGTygpaW5n+Cl2GfyNvwQQM7kOWPsC1pJAyUtYVXZ05KVUAlCOHy56I82/Hut2
         /Y5olSS+IArbk7IODQRzXwu2GHGiUNaoTFiqFbIc2lyYEiw1fFNRJLre22hRtECfuetX
         n3lsCmBv/40HWhOzCmr/A2d21QQG6Uaz3gR7Oy9mmbNZu0X58/zgdlC75UemRWLoUwov
         QU7kDML7T/P23cNlPlUlaPPhIcUf5tZg7lyxBXhKV5LGLxBS43X3owR61uadsJ6hspUC
         /ltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678759116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ln5orvH1KCueqxGfdeaxW69qj9y07fvda5WEi7cdD+M=;
        b=KEq9IEQB08cG3+mPlyUzLKburX14pRZGDv0143wcRNu5/903KY5QxaKQwwEfMw8xqU
         op6YNYh99sam7wnaoseJU2QYPx8l8IxEC4T2CJFP24IaQsUsQnxpta6PisYCCHTlhRIv
         qAaJcjNsv2WELoU0KOk7BcSaQnobFxcsgA4XyAODfGAskKOogkB+AJ6HOOMFVUr6ZvG+
         CjW4UQP6Xr8JSpzWvu/wGQvHImSyJnm3HhRRFNfBsbiADddAgnJINq69pYYNaFAji/j4
         HjU+1w9fFdI1GF7R9zHWUZIEVejwlTznbgiItCKjd5X13LEp5Tz7S6gB8paYYoRB9RPD
         i/Nw==
X-Gm-Message-State: AO0yUKVNiBKExeda5KI0Twx6lP7KlWY4zHiZHfcleD3e/5b00vdOoinY
        yrlXBFwKDxH6n5dPgn88qwofZoKt4tk2FQCs/X4=
X-Google-Smtp-Source: AK7set9odeAwlXyJZKUtbP8QeC/UKw/z4EKe5O4OBZxRh+34m/Lyhg9DzwcTbrsH89Geg+DYS9YYoFReAFXglOBX5yM=
X-Received: by 2002:a17:906:714f:b0:92c:16cc:2dc8 with SMTP id
 z15-20020a170906714f00b0092c16cc2dc8mr311353ejj.11.1678759115853; Mon, 13 Mar
 2023 18:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230311163614.92296-1-kerneljasonxing@gmail.com> <cb09d3eb-8796-b6b8-10cb-35700ea9b532@gmail.com>
In-Reply-To: <cb09d3eb-8796-b6b8-10cb-35700ea9b532@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 09:57:59 +0800
Message-ID: <CAL+tcoB9Gq44dKyZ2yvZdDHXp30=Hc_trbuuWDEeUZiNy9wRAw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: introduce budget_squeeze to help us tune rx behavior
To:     Kui-Feng Lee <sinquersw@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kuniyu@amazon.com,
        liuhangbin@gmail.com, xiangxia.m.yue@gmail.com, jiri@nvidia.com,
        andy.ren@getcruise.com, bpf@vger.kernel.org,
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

On Tue, Mar 14, 2023 at 5:58=E2=80=AFAM Kui-Feng Lee <sinquersw@gmail.com> =
wrote:
>
>
>
> On 3/11/23 08:36, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > When we encounter some performance issue and then get lost on how
> > to tune the budget limit and time limit in net_rx_action() function,
> > we can separately counting both of them to avoid the confusion.
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > note: this commit is based on the link as below:
> > https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gma=
il.com/
> > ---
> >   include/linux/netdevice.h |  1 +
> >   net/core/dev.c            | 12 ++++++++----
> >   net/core/net-procfs.c     |  9 ++++++---
> >   3 files changed, 15 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 6a14b7b11766..5736311a2133 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3157,6 +3157,7 @@ struct softnet_data {
> >       /* stats */
> >       unsigned int            processed;
> >       unsigned int            time_squeeze;
> > +     unsigned int            budget_squeeze;
> >   #ifdef CONFIG_RPS
> >       struct softnet_data     *rps_ipi_list;
> >   #endif
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 253584777101..bed7a68fdb5d 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >       unsigned long time_limit =3D jiffies +
> >               usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
> >       int budget =3D READ_ONCE(netdev_budget);
> > +     bool is_continue =3D true;
> >       LIST_HEAD(list);
> >       LIST_HEAD(repoll);
> >
> > @@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >       list_splice_init(&sd->poll_list, &list);
> >       local_irq_enable();
> >
> > -     for (;;) {
> > +     for (; is_continue;) {
> >               struct napi_struct *n;
> >
> >               skb_defer_free_flush(sd);
> > @@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(stru=
ct softirq_action *h)
> >                * Allow this to run for 2 jiffies since which will allow
> >                * an average latency of 1.5/HZ.
> >                */
> > -             if (unlikely(budget <=3D 0 ||
> > -                          time_after_eq(jiffies, time_limit))) {
> > +             if (unlikely(budget <=3D 0)) {
> > +                     sd->budget_squeeze++;
> > +                     is_continue =3D false;
> > +             }
> > +             if (unlikely(time_after_eq(jiffies, time_limit))) {
> >                       sd->time_squeeze++;
> > -                     break;
> > +                     is_continue =3D false;
> >               }
> >       }
> >
> > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > index 97a304e1957a..4d1a499d7c43 100644
> > --- a/net/core/net-procfs.c
> > +++ b/net/core/net-procfs.c
> > @@ -174,14 +174,17 @@ static int softnet_seq_show(struct seq_file *seq,=
 void *v)
> >        */
> >       seq_printf(seq,
> >                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08=
x %08x %08x "
> > -                "%08x %08x\n",
> > -                sd->processed, sd->dropped, sd->time_squeeze, 0,
> > +                "%08x %08x %08x %08x\n",
> > +                sd->processed, sd->dropped,
> > +                0, /* was old way to count time squeeze */
>
> Should we show a proximate number?  For example,
> sd->time_squeeze + sd->bud_squeeze.

Yeah, It does make sense. Let the old way to display untouched.

>
>
> > +                0,
> >                  0, 0, 0, 0, /* was fastroute */
> >                  0,   /* was cpu_collision */
> >                  sd->received_rps, flow_limit_count,
> >                  0,   /* was len of two backlog queues */
> >                  (int)seq->index,
> > -                softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd));
> > +                softnet_input_pkt_queue_len(sd), softnet_process_queue=
_len(sd),
> > +                sd->time_squeeze, sd->budget_squeeze);
> >       return 0;
> >   }
> >
