Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3235E32C402
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378852AbhCDAKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843022AbhCCKYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:24:31 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F2C08ECA7
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 01:54:11 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id c131so23859149ybf.7
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 01:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fye25YydbjlJ3GVTAFSWXWYxwS+yMFJWqS03QxTluJE=;
        b=IFeCaMnzNr4ygcc2IP9PB0wFLgoUt2zhcTsPxKpVrOExvp1MLJ6kZ319MurQVA1VVR
         PNOyUGkYo0wozRGHCD+zRg4Hcbe6KFNwWlD9RIeEKHK964tucvteCSwTFDHd6yHyD28y
         MYvwgu8MATTKidJKU7ENx/b480gsLmgTNILLwcmDZ5znBImMwF+8Y3GKtK9gi6p1bp65
         O3aRTapPuHxYM1z/xs9Y4lGPU2eidje0VDAXXbCZ0LnzrpSfEnIoDP+h0zLekKN/Dsvg
         TjGuBOaMdx3O6MDP6n+C98+IWb8PP4nXb/iefuapnAhlpSGHfjgDNLx4mxd/MJLuVK5f
         IjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fye25YydbjlJ3GVTAFSWXWYxwS+yMFJWqS03QxTluJE=;
        b=rPH17NXthIzv/dzNrmNbgOSYRZD08Y6tJl8QOkTaxsc+yYchHIA383eG20FGQp3Pja
         E6u33n61Wu0Rm43jGihC8gFyxLbC+QIXzSMrU3GKyNvBxe72bvbJ9sc2DBcNr18PwxbC
         xsdIL9Uoli5w7kzYHoSo1/tBX6iBzW7DojRH2np2ObaEcBhx4+P+gMVdGi4dP2XcLbYe
         yT/TmGw2vlvWJgZovpbCqc4SO0JMR/GeH78LJfCeoFPW/6N5i68H2O1QF0UC9k2Mavxn
         Og6ndnxVk0R49B4nVrenOvwxjZuyHM8mkICUlWuBDqCp9l1v4TZKLRk9Xin8fwrcPEzw
         FMoA==
X-Gm-Message-State: AOAM533g2oYsFry6+HpAm9R8vME0K6obBVjkRJe1PxP+dMzyO5iQt8K/
        kqNSZIVeO8PeU/7iM+i0zE1aNljLZCpFHVTIkC57ng==
X-Google-Smtp-Source: ABdhPJz6sMOghfMm04mffK6uKUDZouc53I3No0GhqKcF0nwiqggnWIZ3bGKDtKs+kZLShyC6EB9zYB5spoRLibSn8RY=
X-Received: by 2002:a25:7306:: with SMTP id o6mr37888140ybc.132.1614765250462;
 Wed, 03 Mar 2021 01:54:10 -0800 (PST)
MIME-Version: 1.0
References: <20210302012113.1432412-1-weiwan@google.com>
In-Reply-To: <20210302012113.1432412-1-weiwan@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 3 Mar 2021 10:53:59 +0100
Message-ID: <CANn89iKx141w0c+eQq-vXjJRfrnDD=yo8uBvfBJ11xaiV9kj_w@mail.gmail.com>
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

On Tue, Mar 2, 2021 at 2:21 AM Wei Wang <weiwan@google.com> wrote:
>
> Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> determine if the kthread owns this napi and could call napi->poll() on
> it. However, if socket busy poll is enabled, it is possible that the
> busy poll thread grabs this SCHED bit (after the previous napi->poll()
> invokes napi_complete_done() and clears SCHED bit) and tries to poll
> on the same napi. napi_disable() could grab the SCHED bit as well.
> This patch tries to fix this race by adding a new bit
> NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> ____napi_schedule() if the threaded mode is enabled, and gets cleared
> in napi_complete_done(), and we only poll the napi in kthread if this
> bit is set. This helps distinguish the ownership of the napi between
> kthread and other scenarios and fixes the race issue.
>
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> Reported-by: Martin Zaharinov <micron10@gmail.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Cc: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> ---
>  include/linux/netdevice.h |  2 ++
>  net/core/dev.c            | 14 +++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ddf4cfc12615..682908707c1a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -360,6 +360,7 @@ enum {
>         NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
>         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softirq processing*/
>         NAPI_STATE_THREADED,            /* The poll is performed inside its own thread*/
> +       NAPI_STATE_SCHED_THREADED,      /* Napi is currently scheduled in threaded mode */
>  };
>
>  enum {
> @@ -372,6 +373,7 @@ enum {
>         NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
>         NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
>         NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
> +       NAPIF_STATE_SCHED_THREADED      = BIT(NAPI_STATE_SCHED_THREADED),
>  };
>
>  enum gro_result {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6c5967e80132..03c4763de351 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>                  */
>                 thread = READ_ONCE(napi->thread);
>                 if (thread) {
> +                       if (thread->state != TASK_INTERRUPTIBLE)

How safe is this read ?

Presumably KMSAN will detect that another cpu/thread is able to change
thread->state under us,
so a READ_ONCE() (or data_race()) would be needed.

Nowhere else in the kernel can we find a similar construct, I find
unfortunate to bury
in net/core/dev.c something that might be incorrect in the future.

> +                               set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
>                         wake_up_process(thread);
>                         return;
>                 }
> @@ -6486,6 +6488,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
>                 WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
>
>                 new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> +                             NAPIF_STATE_SCHED_THREADED |
>                               NAPIF_STATE_PREFER_BUSY_POLL);
>
>                 /* If STATE_MISSED was set, leave STATE_SCHED set,
> @@ -6968,16 +6971,25 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>
>  static int napi_thread_wait(struct napi_struct *napi)
>  {
> +       bool woken = false;
> +
>         set_current_state(TASK_INTERRUPTIBLE);
>
>         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> +               /* Testing SCHED_THREADED bit here to make sure the current
> +                * kthread owns this napi and could poll on this napi.
> +                * Testing SCHED bit is not enough because SCHED bit might be
> +                * set by some other busy poll thread or by napi_disable().
> +                */
> +               if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
>                         WARN_ON(!list_empty(&napi->poll_list));
>                         __set_current_state(TASK_RUNNING);
>                         return 0;
>                 }
>
>                 schedule();
> +               /* woken being true indicates this thread owns this napi. */
> +               woken = true;
>                 set_current_state(TASK_INTERRUPTIBLE);
>         }
>         __set_current_state(TASK_RUNNING);
> --
> 2.30.1.766.gb4fecdf3b7-goog
>
