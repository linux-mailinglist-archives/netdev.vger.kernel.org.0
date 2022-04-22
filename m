Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9D50BC65
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344720AbiDVQDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449731AbiDVQCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:02:40 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BC45E166
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:59:46 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2ef5380669cso89955527b3.9
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h9Ub6J7RTOcZPICxVoKAthB27Yz50Z9O3PCV/RKsFZ8=;
        b=bpn4PmE/pH7wZbKp0ZwqLQ9kv+xNdQOMNIMh3W4YAGR22+6pCwtkoU1QnjjebYZ6u7
         mH8REdgz7GvlUASrRvlVZaUV3EMylvBmjdRjMER02nqRKovw2o2z148Ob/AHU4flI4Vh
         fS2RUteTM/2Nt+rSHteq0Y++DUEXKlHYGv5nOqULGMMXGtN9jXa399XQjFi2JxxG/zjn
         qD5ymnLvp52a6SKciCVxe8dCR3ITbOGpOcW22XS35nAv8kanzzu1nNKlD54NVJUNCwYB
         Y0jBEQmT1Of7IZAhXt02cm7lgQwZ4TpSpiwr+es0oHQhtq554I2Aj2026IfZ7ndBOUpD
         TLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h9Ub6J7RTOcZPICxVoKAthB27Yz50Z9O3PCV/RKsFZ8=;
        b=1qzAip/f04CSgJhDqcXYhufJ2ndqMc+EfUyMXeCa8ie1Tw7J3KnuAJ07QCcAp5FJzh
         RTlffdcwPyv5jmEB7TtuMSdqqgrSBFsEJKORxps7xAhQXK5/4Cvf3a3i8w5hPV1gjLWS
         KQZh5yWsDHCTvBuV6RtRmvcq5SyLFg4swEnxCdK87RUPPPy0LwhMC3x+6U/FWzlm+LIv
         mmcHo106DF1WRuUTAb3vSNGkPuMpPA3d5ZpyUG0CXreRj6iLXwbwtORTqb6rvYLhnKiU
         fMcRi5DEQbHLdtjC0laU7QEENCCgXvdjH+aMYf5IohEi3+4Tv9m42pinDukdq4EQthhA
         7oUg==
X-Gm-Message-State: AOAM531iFFSgtK1ptFZmBQLmGjOIdslAdxdV9EkaiB5esunqpZPx0b9w
        OTra/SK7z+DSLiwLf8/pr3+nedLjvvGbyziti65WWjhRSHUPmd9d
X-Google-Smtp-Source: ABdhPJy0k3x3XnRl4OOlK+cM88bpPLSrTy/dLlj17M7o82l2FVJl7XPPvaTZxR1N+dQt6Yx9/nvTwtosm0VaxjX62Ys=
X-Received: by 2002:a81:89c3:0:b0:2f3:227:d5af with SMTP id
 z186-20020a8189c3000000b002f30227d5afmr5434426ywf.47.1650643183210; Fri, 22
 Apr 2022 08:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220421153920.3637792-1-eric.dumazet@gmail.com> <319497a698ba77244aa935c13dc9b93c893dbbc3.camel@redhat.com>
In-Reply-To: <319497a698ba77244aa935c13dc9b93c893dbbc3.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Apr 2022 08:59:31 -0700
Message-ID: <CANn89iLF04mxhCS=C0VdeJ5afeK8CDRRjszAWhey+F_Gf6L+6Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to per-cpu lists
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 2:02 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hi,
>
> Looks great! I have a few questions below mostly to understand better
> how it works...
>

Hi Paolo, thanks for the review :)

> On Thu, 2022-04-21 at 08:39 -0700, Eric Dumazet wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 84d78df60453955a8eaf05847f6e2145176a727a..2fe311447fae5e860eee95f6e8772926d4915e9f 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1080,6 +1080,7 @@ struct sk_buff {
> >               unsigned int    sender_cpu;
> >       };
> >  #endif
> > +     u16                     alloc_cpu;
>
> I *think* we could in theory fetch the CPU that allocated the skb from
> the napi_id - adding a cpu field to napi_struct and implementing an
> helper to fetch it. Have you considered that option? or the napi lookup
> would be just too expensive?

I have considered that, but a NAPI is not guaranteed to be
owned/serviced from a single cpu.

(In fact, I realized recently about the fact that commit
01770a166165 "tcp: fix race condition when creating child sockets from
syncookies"
has not been backported to stable kernels.

This tcp bug would not happen in normal cases, where all packets from
a particular 4-tuple
are handled by a single cpu.

>
> [...]
>
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 4a77ebda4fb155581a5f761a864446a046987f51..4136d9c0ada6870ea0f7689702bdb5f0bbf29145 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4545,6 +4545,12 @@ static void rps_trigger_softirq(void *data)
> >
> >  #endif /* CONFIG_RPS */
> >
> > +/* Called from hardirq (IPI) context */
> > +static void trigger_rx_softirq(void *data)
>
> Perhaps '__always_unused' ? (But the compiler doesn't complain here)

Sure I will add this.

>
> > @@ -6486,3 +6487,46 @@ void __skb_ext_put(struct skb_ext *ext)
> >  }
> >  EXPORT_SYMBOL(__skb_ext_put);
> >  #endif /* CONFIG_SKB_EXTENSIONS */
> > +
> > +/**
> > + * skb_attempt_defer_free - queue skb for remote freeing
> > + * @skb: buffer
> > + *
> > + * Put @skb in a per-cpu list, using the cpu which
> > + * allocated the skb/pages to reduce false sharing
> > + * and memory zone spinlock contention.
> > + */
> > +void skb_attempt_defer_free(struct sk_buff *skb)
> > +{
> > +     int cpu = skb->alloc_cpu;
> > +     struct softnet_data *sd;
> > +     unsigned long flags;
> > +     bool kick;
> > +
> > +     if (WARN_ON_ONCE(cpu >= nr_cpu_ids) || !cpu_online(cpu)) {
> > +             __kfree_skb(skb);
> > +             return;
> > +     }
>
> I'm wondering if we should skip even when cpu == smp_processor_id()?

Yes, although we would have to use the raw_smp_processor_id() form I guess.

>
> > +
> > +     sd = &per_cpu(softnet_data, cpu);
> > +     /* We do not send an IPI or any signal.
> > +      * Remote cpu will eventually call skb_defer_free_flush()
> > +      */
> > +     spin_lock_irqsave(&sd->skb_defer_list.lock, flags);
> > +     __skb_queue_tail(&sd->skb_defer_list, skb);
> > +
> > +     /* kick every time queue length reaches 128.
> > +      * This should avoid blocking in smp_call_function_single_async().
> > +      * This condition should hardly be bit under normal conditions,
> > +      * unless cpu suddenly stopped to receive NIC interrupts.
> > +      */
> > +     kick = skb_queue_len(&sd->skb_defer_list) == 128;
>
> Out of sheer curiosity why 128? I guess it's should be larger then
> NAPI_POLL_WEIGHT, to cope with with maximum theorethical burst len?

Yes, I needed a value there, but was not sure which precise one.
In my tests I had no IPI ever sent with 128.

>
> Thanks!
>
> Paolo
>
