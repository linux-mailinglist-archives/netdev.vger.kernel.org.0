Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA965F206E
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJAWuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJAWue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:50:34 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97173C8EA
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:50:30 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id o123so9268336yba.0
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 15:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=JCmIxHKjCR3995GmCMItCNibR5qdveN5GNR+wUZMsrE=;
        b=K4/cKkIHoux12uG9ijn6gE7jll6SgKJGy7NZu6LwQl1y/i5QNfz+S6qKxAoBU3TMKv
         /lYKpZoRZR/u3WVq7vOaDwnVh6zjsY5AaeMmOMYE1ca3DLtJTaGMWwsHZaarMUHS6kKt
         PZAIhdR0+vmXfbUmr/Sq/OCPUk/bKZvMg9/eYZCWaWXC1yymyL0V2JJuxS9YqQTbfllh
         TX+vrd8CxDS6wKqWfGJO+cjber768DNpODBy6QwJOGlew/S9mhYHUDhaWh5C02e6zz+3
         rH2wFXUKBnvRVznmgr62oiogDgRltP/oVdFEbrM5YN4LIcgx61lUub/zwh/6heds8BJF
         p51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=JCmIxHKjCR3995GmCMItCNibR5qdveN5GNR+wUZMsrE=;
        b=52XC1ziTeIubPRX1OcnZIzhu4+7oxwMjLzftVZKYpiljCKAnhyE8pxnqPb/VlBnwQj
         FMjLy7pHqU8bmdi7A8yzTsqOpR453NYqMMqbpRhNkiFaT2mlqiRmccZqzpxS2EpnSfPh
         wIKS0y6e521myKkFD+Dg2vSIkGkmVSb7e53WcsK7ki9SRxrm0EV+3YTu5nF8Jf/zDHzN
         5JecYiW/kWiaLFDM3tNcgWLSP1JvL9qsOzH+idNVE78+Hu1SEDMzbqRNGbL/bPF5GgyI
         rvBUznhL01Tj2CQbxtPu+nnT/uOwK2OJEqo0esWYYGx86+BDyiCNaS7ScAd8oUGeKVSz
         N4LQ==
X-Gm-Message-State: ACrzQf2T7hrOvR8zAEte/1AFKT4FVJe0b8r3hRducgLAaxUOKQ9H3R9y
        4gKY8wDPJmLafZlzZHgn0545Spn6FhIk0F3rBMAYQg==
X-Google-Smtp-Source: AMsMyM7rJLtgK4fE4oLQ29tIunfxvbMK2MWHTBmm6PexZ6w/IIKYv50zKIxwXCSeTtkoE74FRGCCrverwj9KPOjwUy4=
X-Received: by 2002:a25:80d0:0:b0:6b3:f287:93a4 with SMTP id
 c16-20020a2580d0000000b006b3f28793a4mr13370057ybm.427.1664664629791; Sat, 01
 Oct 2022 15:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20221001205102.2319658-1-eric.dumazet@gmail.com> <YzjCzGGGE3WUsQr0@zx2c4.com>
In-Reply-To: <YzjCzGGGE3WUsQr0@zx2c4.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 1 Oct 2022 15:50:18 -0700
Message-ID: <CANn89iJS0Lab6iSM0=7+WxAb5dr0TpRDjy+5F_+pVJH1UsTw3A@mail.gmail.com>
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Willy Tarreau <w@1wt.eu>
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

On Sat, Oct 1, 2022 at 3:44 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Sat, Oct 01, 2022 at 01:51:02PM -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Christophe Leroy reported a ~80ms latency spike
> > happening at first TCP connect() time.
> >
> > This is because __inet_hash_connect() uses get_random_once()
> > to populate a perturbation table which became quite big
> > after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> >
> > get_random_once() uses DO_ONCE(), which block hard irqs for the duration
> > of the operation.
> >
> > This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
> > for operations where we prefer to stay in process context.
> >
> > Then __inet_hash_connect() can use get_random_slow_once()
> > to populate its perturbation table.
> >
> > Fixes: 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> > Fixes: 190cc82489f4 ("tcp: change source port randomizarion at connect() time")
> > Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> > Link: https://lore.kernel.org/netdev/CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com/T/#t
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Willy Tarreau <w@1wt.eu>
> > ---
> >  include/linux/once.h       | 28 ++++++++++++++++++++++++++++
> >  lib/once.c                 | 30 ++++++++++++++++++++++++++++++
> >  net/ipv4/inet_hashtables.c |  4 ++--
> >  3 files changed, 60 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/once.h b/include/linux/once.h
> > index b14d8b309d52b198bb144689fe67d9ed235c2b3e..176ab75b42df740a738d04d8480821a0b3b65ba9 100644
> > --- a/include/linux/once.h
> > +++ b/include/linux/once.h
> > @@ -5,10 +5,18 @@
> >  #include <linux/types.h>
> >  #include <linux/jump_label.h>
> >
> > +/* Helpers used from arbitrary contexts.
> > + * Hard irqs are blocked, be cautious.
> > + */
> >  bool __do_once_start(bool *done, unsigned long *flags);
> >  void __do_once_done(bool *done, struct static_key_true *once_key,
> >                   unsigned long *flags, struct module *mod);
> >
> > +/* Variant for process contexts only. */
> > +bool __do_once_slow_start(bool *done);
> > +void __do_once_slow_done(bool *done, struct static_key_true *once_key,
> > +                      struct module *mod);
> > +
> >  /* Call a function exactly once. The idea of DO_ONCE() is to perform
> >   * a function call such as initialization of random seeds, etc, only
> >   * once, where DO_ONCE() can live in the fast-path. After @func has
> > @@ -52,7 +60,27 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
> >               ___ret;                                                      \
> >       })
> >
> > +/* Variant of DO_ONCE() for process/sleepable contexts. */
> > +#define DO_ONCE_SLOW(func, ...)                                                   \
> > +     ({                                                                   \
> > +             bool ___ret = false;                                         \
> > +             static bool __section(".data.once") ___done = false;         \
> > +             static DEFINE_STATIC_KEY_TRUE(___once_key);                  \
> > +             if (static_branch_unlikely(&___once_key)) {                  \
> > +                     ___ret = __do_once_slow_start(&___done);             \
> > +                     if (unlikely(___ret)) {                              \
> > +                             func(__VA_ARGS__);                           \
> > +                             __do_once_slow_done(&___done, &___once_key,  \
> > +                                                 THIS_MODULE);            \
> > +                     }                                                    \
> > +             }                                                            \
> > +             ___ret;                                                      \
> > +     })
> > +
>
> Hmm, I dunno about this macro-choice explosion here. The whole thing
> with DO_ONCE() is that the static branch makes it zero cost most of the
> time while being somewhat expensive the rest of the time, but who cares,
> because "the rest" is just once.
>
> So instead, why not just branch on whether or not we can sleep here, if
> that can be worked out dynamically? If not, and if you really do need
> two sets of macros and functions, at least you can call the new one
> something other than "slow"? Maybe something about being _SLEEPABLE()
> instead?

No idea what you mean. I do not want to over engineer code that yet have to be
adopted by other callers. If you think you want to spend week end time on this,
feel free to take over at this point.

>
> Also, the __do_once_slow_done() function misses a really nice
> optimization, which is that the static branch can be changed
> synchronously instead of having to allocate and fire off that workqueue,
> since by definition we're in sleepable context here.
>

This was deliberate. We already spent a lot of time in the called function,
better just return to the caller as fast as possible.

This really does not matter, the work queue is fired once by definition.
