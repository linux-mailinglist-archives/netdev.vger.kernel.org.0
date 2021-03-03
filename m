Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F20032C409
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379905AbhCDAK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843079AbhCCKZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:25:20 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BF1C08ECAA
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 01:55:24 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id c131so23862418ybf.7
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 01:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jJs8WSaxbltW7zelCuYouwCgd1NXt373c77CDRd0yRQ=;
        b=R24ja8st+zIAskvtvPybPdxRZewWxEfrm7wZh6S1e5YM7Uj55L6NSSN2mHsgeQCT+Z
         WFBRFwQnTbWiGy6TvFg3ufPpsPNEVsVUkTybyoBjrsFwmLiwweWqthCRuD42owt9LimO
         PWwVPh4MPhYYv2yMCGh8VRhSMaySGSIpeU53d332T8vuHCV9bZrppejhJTtCLvjDIDZS
         Wm9mydbkAL5TvRjIpEK1BJqj41kPCxrDeTFTOw6Bb1nw4hY5eGhn+VEHkUeKqXyX5Q03
         hEdwOCk3SVBVPvKmowiQ6ggNYy7huXxL1b5Uvp8AbaPUY9dxgVanj8n8IEMglT+b7IN9
         B8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jJs8WSaxbltW7zelCuYouwCgd1NXt373c77CDRd0yRQ=;
        b=FxgUypMS5ZEirTFqSHETL+uxCYDJ+uCC27FYBItCkoVdntKQtg6sE9zXloc+TaxMLA
         TplRLOCcJY9r2T3pD2FJiO3PoZ4gSDSGy1tWN/t6efEaDw7nxyJcEcGOx1rCjtD0BwI3
         qZIskDpBKF16VQcBHitq/TAP+zhTs2dPm2tcZ7dVZjchhdMy3Uv5Q0nbTUnLW7XVmBAO
         UoFW7zd1behhxUEdzwmNUiEbDW1kEh08mFrUcgHNplp+lYC+La74PhXVgE+YSfFqyUsZ
         rpYp5V8+FBQkIzm1UVOQXjUhrWBSQWYiHutiaZkXBTVDfVJsLuCtWQIaAI5KmRfju80B
         8a8g==
X-Gm-Message-State: AOAM532byrgrmHyjFrqiNfPL0qvfZrdt22cPIi1UnHJddcle6nuf1E7A
        ZY3LQMUsWdBilr4g3ZrKErlZeY2afiSrJ9bcB+eadA==
X-Google-Smtp-Source: ABdhPJwzG8q6JhNuQV0+PcibTQapuNtm7My81HjkvfuR+dxHeEmvd/9oKKoOVB1dDXy7HuRqo5KZwZj6I3JvIpSbRP4=
X-Received: by 2002:a25:1d88:: with SMTP id d130mr37413687ybd.446.1614765323939;
 Wed, 03 Mar 2021 01:55:23 -0800 (PST)
MIME-Version: 1.0
References: <20210302012113.1432412-1-weiwan@google.com> <CANn89iKx141w0c+eQq-vXjJRfrnDD=yo8uBvfBJ11xaiV9kj_w@mail.gmail.com>
In-Reply-To: <CANn89iKx141w0c+eQq-vXjJRfrnDD=yo8uBvfBJ11xaiV9kj_w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 3 Mar 2021 10:55:12 +0100
Message-ID: <CANn89iKd=RAKESnYiZeXPN2Bo-Ta02NsohCPVvSc3z3noKZfmA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: fix race between napi kthread mode and busy poll
To:     Wei Wang <weiwan@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 10:53 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Mar 2, 2021 at 2:21 AM Wei Wang <weiwan@google.com> wrote:
> >
> > Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> > determine if the kthread owns this napi and could call napi->poll() on
> > it. However, if socket busy poll is enabled, it is possible that the
> > busy poll thread grabs this SCHED bit (after the previous napi->poll()
> > invokes napi_complete_done() and clears SCHED bit) and tries to poll
> > on the same napi. napi_disable() could grab the SCHED bit as well.
> > This patch tries to fix this race by adding a new bit
> > NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> > ____napi_schedule() if the threaded mode is enabled, and gets cleared
> > in napi_complete_done(), and we only poll the napi in kthread if this
> > bit is set. This helps distinguish the ownership of the napi between
> > kthread and other scenarios and fixes the race issue.
> >
> > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > Reported-by: Martin Zaharinov <micron10@gmail.com>
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > ---
> >  include/linux/netdevice.h |  2 ++
> >  net/core/dev.c            | 14 +++++++++++++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index ddf4cfc12615..682908707c1a 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -360,6 +360,7 @@ enum {
> >         NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
> >         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softirq processing*/
> >         NAPI_STATE_THREADED,            /* The poll is performed inside its own thread*/
> > +       NAPI_STATE_SCHED_THREADED,      /* Napi is currently scheduled in threaded mode */
> >  };
> >
> >  enum {
> > @@ -372,6 +373,7 @@ enum {
> >         NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
> >         NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
> >         NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
> > +       NAPIF_STATE_SCHED_THREADED      = BIT(NAPI_STATE_SCHED_THREADED),
> >  };
> >
> >  enum gro_result {
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 6c5967e80132..03c4763de351 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet_data *sd,
> >                  */
> >                 thread = READ_ONCE(napi->thread);
> >                 if (thread) {
> > +                       if (thread->state != TASK_INTERRUPTIBLE)
>
> How safe is this read ?
>
> Presumably KMSAN will detect that another cpu/thread is able to change
> thread->state under us,
> so a READ_ONCE() (or data_race()) would be needed.
>

Of course I meant KCSAN here.

> Nowhere else in the kernel can we find a similar construct, I find
> unfortunate to bury
> in net/core/dev.c something that might be incorrect in the future.
>
> > +                               set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
> >                         wake_up_process(thread);
> >                         return;
> >                 }
> > @@ -6486,6 +6488,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
> >                 WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
> >
> >                 new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> > +                             NAPIF_STATE_SCHED_THREADED |
> >                               NAPIF_STATE_PREFER_BUSY_POLL);
> >
> >                 /* If STATE_MISSED was set, leave STATE_SCHED set,
> > @@ -6968,16 +6971,25 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> >
> >  static int napi_thread_wait(struct napi_struct *napi)
> >  {
> > +       bool woken = false;
> > +
> >         set_current_state(TASK_INTERRUPTIBLE);
> >
> >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > +               /* Testing SCHED_THREADED bit here to make sure the current
> > +                * kthread owns this napi and could poll on this napi.
> > +                * Testing SCHED bit is not enough because SCHED bit might be
> > +                * set by some other busy poll thread or by napi_disable().
> > +                */
> > +               if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
> >                         WARN_ON(!list_empty(&napi->poll_list));
> >                         __set_current_state(TASK_RUNNING);
> >                         return 0;
> >                 }
> >
> >                 schedule();
> > +               /* woken being true indicates this thread owns this napi. */
> > +               woken = true;
> >                 set_current_state(TASK_INTERRUPTIBLE);
> >         }
> >         __set_current_state(TASK_RUNNING);
> > --
> > 2.30.1.766.gb4fecdf3b7-goog
> >
