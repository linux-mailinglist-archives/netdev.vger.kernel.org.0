Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FAA32C4A8
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450172AbhCDAPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389813AbhCCVr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 16:47:29 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED3EC061762
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 13:46:42 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id u3so26207677ybk.6
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 13:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNdMdLXBMIvtyxjFY75S4S+AocsB989EbyWt43Kiku0=;
        b=V2mkwkd6bsiOtaL7bsnOArI+9XjGLwtuHtMZciYOSUyQnSAMoxkh3qcNHsTn+FUiuC
         3DXFQ6kaSNfEgiMlOfvgW+VUW2pR+dlk1/xfv/UO8wUKCBfQYyS/VAL+Omf1lO1XNs28
         /Msb/jwkKBJGapYMvXkPLS5JKJHw1pTrZfRtWv9EE1aPRX6rExmiV6oPoUmD+B39YiqO
         keisRvCRCr64bLM8aWGr2iLeQmauTrOTFFYBGxHz+1ThRXwZ6+I+Zf85egi+e56Q/eUh
         5ma7FbjRW/JcQZZ5ukV0vZ7TcVCaLoHvhCwOJqU2deOPxIOrQVcu9EZ7XZMyiHgxpdjf
         UsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNdMdLXBMIvtyxjFY75S4S+AocsB989EbyWt43Kiku0=;
        b=sfdsHbDuiGUgJr/JmDZcotu5FOs+aduAiBul4ha2sHjboWUqfWhX3FZGQsWp4uVEoJ
         4sOOVXpGUJT9f+E50hjie2qi/6p1n5Wk/Yx0ak4xOqvfoyJTZ9ZbJ09j90deA623SSeF
         vglaA0DnqbBJq2Pg5o5S+azoh3afoGDlUDYb5JDzUr5L55FsnKHuZoysT0DjFTRDDWVf
         fnvU1UxuhNfxNXS0L1qsibG2Cn2dJI1ssmQ7HkaGxlwCu4qmOGpXx/STVCqy2B1s/5DX
         HvQwSlQOalDad4jTZgRRBLUKHV8qCyUgx0Wt+hSM3zcc8RYrgxC4ujodFtm3tu9HdYUb
         pL9g==
X-Gm-Message-State: AOAM533x38lrViVsjXj70tXQIabY2fuXPOUtpmneX3Jrw7BJP2J3sVJz
        /qNDyw7uIv6vAtL3CE6Jf1P1InvV3HtHQ3G4DrFBsA==
X-Google-Smtp-Source: ABdhPJzjbZqzou9c4vQLZedb9dOLbUssSn62WLRG1GwzKfWsuzzpt4fMTZH1kQmXw7Be/ObKB1h6LCI5lzjLnWpdqBc=
X-Received: by 2002:a25:2a44:: with SMTP id q65mr2030027ybq.195.1614808001719;
 Wed, 03 Mar 2021 13:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20210302012113.1432412-1-weiwan@google.com> <CANn89iKx141w0c+eQq-vXjJRfrnDD=yo8uBvfBJ11xaiV9kj_w@mail.gmail.com>
 <CANn89iKd=RAKESnYiZeXPN2Bo-Ta02NsohCPVvSc3z3noKZfmA@mail.gmail.com>
In-Reply-To: <CANn89iKd=RAKESnYiZeXPN2Bo-Ta02NsohCPVvSc3z3noKZfmA@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 3 Mar 2021 13:46:29 -0800
Message-ID: <CAEA6p_Dn3-WY_CycwRYD=3O22jVWkOWnHiu8YdtAb1XB7uyDjA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: fix race between napi kthread mode and busy poll
To:     Eric Dumazet <edumazet@google.com>
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

On Wed, Mar 3, 2021 at 1:55 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 3, 2021 at 10:53 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Mar 2, 2021 at 2:21 AM Wei Wang <weiwan@google.com> wrote:
> > >
> > > Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> > > determine if the kthread owns this napi and could call napi->poll() on
> > > it. However, if socket busy poll is enabled, it is possible that the
> > > busy poll thread grabs this SCHED bit (after the previous napi->poll()
> > > invokes napi_complete_done() and clears SCHED bit) and tries to poll
> > > on the same napi. napi_disable() could grab the SCHED bit as well.
> > > This patch tries to fix this race by adding a new bit
> > > NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> > > ____napi_schedule() if the threaded mode is enabled, and gets cleared
> > > in napi_complete_done(), and we only poll the napi in kthread if this
> > > bit is set. This helps distinguish the ownership of the napi between
> > > kthread and other scenarios and fixes the race issue.
> > >
> > > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > > Reported-by: Martin Zaharinov <micron10@gmail.com>
> > > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > ---
> > >  include/linux/netdevice.h |  2 ++
> > >  net/core/dev.c            | 14 +++++++++++++-
> > >  2 files changed, 15 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index ddf4cfc12615..682908707c1a 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -360,6 +360,7 @@ enum {
> > >         NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
> > >         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softirq processing*/
> > >         NAPI_STATE_THREADED,            /* The poll is performed inside its own thread*/
> > > +       NAPI_STATE_SCHED_THREADED,      /* Napi is currently scheduled in threaded mode */
> > >  };
> > >
> > >  enum {
> > > @@ -372,6 +373,7 @@ enum {
> > >         NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
> > >         NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
> > >         NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
> > > +       NAPIF_STATE_SCHED_THREADED      = BIT(NAPI_STATE_SCHED_THREADED),
> > >  };
> > >
> > >  enum gro_result {
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 6c5967e80132..03c4763de351 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet_data *sd,
> > >                  */
> > >                 thread = READ_ONCE(napi->thread);
> > >                 if (thread) {
> > > +                       if (thread->state != TASK_INTERRUPTIBLE)
> >
> > How safe is this read ?
> >
> > Presumably KMSAN will detect that another cpu/thread is able to change
> > thread->state under us,
> > so a READ_ONCE() (or data_race()) would be needed.
> >
>
> Of course I meant KCSAN here.
>
> > Nowhere else in the kernel can we find a similar construct, I find
> > unfortunate to bury
> > in net/core/dev.c something that might be incorrect in the future.
> >
Indeed. It seems not much code is reading and checking the thread
state. Not sure if there is any risk involved in doing this.
The reason to check for the state and then set the bit is to try to
avoid some atomic operations here. And the test I ran did show it is
working properly. But the workload I tested does not represent all the
scenarios.
Not sure what to do here. Should we remove the if () check and
unconditionally set SCHED_THREADED bit?


> > > +                               set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
> > >                         wake_up_process(thread);
> > >                         return;
> > >                 }
> > > @@ -6486,6 +6488,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
> > >                 WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
> > >
> > >                 new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> > > +                             NAPIF_STATE_SCHED_THREADED |
> > >                               NAPIF_STATE_PREFER_BUSY_POLL);
> > >
> > >                 /* If STATE_MISSED was set, leave STATE_SCHED set,
> > > @@ -6968,16 +6971,25 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> > >
> > >  static int napi_thread_wait(struct napi_struct *napi)
> > >  {
> > > +       bool woken = false;
> > > +
> > >         set_current_state(TASK_INTERRUPTIBLE);
> > >
> > >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > > +               /* Testing SCHED_THREADED bit here to make sure the current
> > > +                * kthread owns this napi and could poll on this napi.
> > > +                * Testing SCHED bit is not enough because SCHED bit might be
> > > +                * set by some other busy poll thread or by napi_disable().
> > > +                */
> > > +               if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
> > >                         WARN_ON(!list_empty(&napi->poll_list));
> > >                         __set_current_state(TASK_RUNNING);
> > >                         return 0;
> > >                 }
> > >
> > >                 schedule();
> > > +               /* woken being true indicates this thread owns this napi. */
> > > +               woken = true;
> > >                 set_current_state(TASK_INTERRUPTIBLE);
> > >         }
> > >         __set_current_state(TASK_RUNNING);
> > > --
> > > 2.30.1.766.gb4fecdf3b7-goog
> > >
