Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B504CCCA1
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbiCDElB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiCDElA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:41:00 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1CF15D390;
        Thu,  3 Mar 2022 20:40:13 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id qt6so14980260ejb.11;
        Thu, 03 Mar 2022 20:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=POVwrXrpJZ5ubY6AO535Yj6HhCtMlU5j67jaEaw4sB4=;
        b=E2xODOv4+P+RsaNqjKYitETpX5eDGC36DnOf16Yr/qCrI7riVGgmYpBX1aJTThr+Sz
         xYTQgYEbJouThVYDu5AFBtES2PkSCdOdz7eyhUaCu2DOAwZ478bjXBbj8dRpkJJnRn+A
         RBNbKi58bHSigdHlanofMYYXjWAmmBMe7xR8KahYn/ClgOaX79hMV6vJnyJtxGtBJAFP
         VFb2ZUAHsN51nkf5CnLD1rBoGF8YofNAXamH/z9M+JlGMOr7ImEEwL2YY/jxy62LU3Ac
         jkdxJagJDserozlUo1pzvHq3WS6cQaxB92D4hRz8m1B249kiXEElGwmoG3EnCl6EH0Ca
         td/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=POVwrXrpJZ5ubY6AO535Yj6HhCtMlU5j67jaEaw4sB4=;
        b=3kLZeQqJbrHsInt2VBz1a1aIPKHuwa15+NwKZmnYQJbFxxYTsiy4iCnQ7gKoN3Feox
         hjkFseJi8soxSRYLSAta7bUUEbkbZ9PSD46FI715dJdl8DB5y7UiSS1sTJAeMy8Ssd0H
         GN0hfwFabswdCst8dgPgOvRhKdC8rw61imToxbIYsAEXKBIqmgq4KKhjMGL1PEVH5KpG
         +W72Sy16HIfGNM97lQnpmPaAQCcSlRfWzoPViKANxT0PNJbjLpZ5Rb2pQs6D/Hcr3t40
         6HVS0UrnWHtWRFCuzp5Apbx/w3de30K9vnady5lI3echA5y8q6h2hpwU5Cd6Wnp13pzI
         y0wQ==
X-Gm-Message-State: AOAM532aq8aLqIK2hVoz+6Y77aTMLDDGHai2RWyn2s/0TPVr/akua9ok
        kF44p8POWnC3vP1p5PLuEbnfL7blTDOkMfzz1jI=
X-Google-Smtp-Source: ABdhPJyaBzwDDHla46ujc/HqYvxCSLCwH4YIhKF1vMGQ3syl64FmDlAZghICVrjAOATj2UFfqnak/oS+kfCoEKf662o=
X-Received: by 2002:a17:906:3144:b0:6ce:de5d:5e3b with SMTP id
 e4-20020a170906314400b006cede5d5e3bmr29669325eje.689.1646368811491; Thu, 03
 Mar 2022 20:40:11 -0800 (PST)
MIME-Version: 1.0
References: <20220303174707.40431-1-imagedong@tencent.com> <20220303174707.40431-5-imagedong@tencent.com>
 <CANn89iLcp96x15SkmPN7d7WyHRXecbswYNhghB3U2+JQxOvvjQ@mail.gmail.com>
In-Reply-To: <CANn89iLcp96x15SkmPN7d7WyHRXecbswYNhghB3U2+JQxOvvjQ@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 4 Mar 2022 12:40:00 +0800
Message-ID: <CADxym3YUT3sdMH_NaSHvgQFTWkdLngM5Zr4g=WDAPSSsQVor0w@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: dev: use kfree_skb_reason() for enqueue_to_backlog()
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>, flyingpeng@tencent.com,
        Mengen Sun <mengensun@tencent.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 1:59 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Mar 3, 2022 at 9:48 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Replace kfree_skb() used in enqueue_to_backlog() with
> > kfree_skb_reason(). The skb rop reason SKB_DROP_REASON_CPU_BACKLOG is
> > introduced for the case of failing to enqueue the skb to the per CPU
> > backlog queue. The further reason can be backlog queue full or RPS
> > flow limition, and I think we meedn't to make further distinctions.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h     | 6 ++++++
> >  include/trace/events/skb.h | 1 +
> >  net/core/dev.c             | 6 +++++-
> >  3 files changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 62f9d15ec6ec..d2cf87ff84c2 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -402,6 +402,12 @@ enum skb_drop_reason {
> >                                          * outputting (failed to enqueue to
> >                                          * current qdisc)
> >                                          */
> > +       SKB_DROP_REASON_CPU_BACKLOG,    /* failed to enqueue the skb to
> > +                                        * the per CPU backlog queue. This
> > +                                        * can be caused by backlog queue
> > +                                        * full (see netdev_max_backlog in
> > +                                        * net.rst) or RPS flow limit
> > +                                        */
> >         SKB_DROP_REASON_MAX,
> >  };
> >
> > diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> > index 80fe15d175e3..29c360b5e114 100644
> > --- a/include/trace/events/skb.h
> > +++ b/include/trace/events/skb.h
> > @@ -47,6 +47,7 @@
> >         EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)              \
> >         EM(SKB_DROP_REASON_QDISC_EGRESS, QDISC_EGRESS)          \
> >         EM(SKB_DROP_REASON_QDISC_DROP, QDISC_DROP)              \
> > +       EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)            \
> >         EMe(SKB_DROP_REASON_MAX, MAX)
> >
> >  #undef EM
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 3280ba2502cd..373fa7a33ffa 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4541,10 +4541,12 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
> >  static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
> >                               unsigned int *qtail)
> >  {
> > +       enum skb_drop_reason reason;
> >         struct softnet_data *sd;
> >         unsigned long flags;
> >         unsigned int qlen;
> >
> > +       reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >         sd = &per_cpu(softnet_data, cpu);
> >
> >         rps_lock_irqsave(sd, &flags);
> > @@ -4566,6 +4568,8 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
> >                 if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state))
> >                         napi_schedule_rps(sd);
> >                 goto enqueue;
> > +       } else {
>
> No need for an else {} after a goto  xxx;
>

Yeah, this 'else' can be omitted :) Thanks!

>
> > +               reason = SKB_DROP_REASON_CPU_BACKLOG;
> >         }
> >
> >  drop:
> > @@ -4573,7 +4577,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
> >         rps_unlock_irq_restore(sd, &flags);
> >
> >         atomic_long_inc(&skb->dev->rx_dropped);
> > -       kfree_skb(skb);
> > +       kfree_skb_reason(skb, reason);
> >         return NET_RX_DROP;
> >  }
> >
> > --
> > 2.35.1
> >
