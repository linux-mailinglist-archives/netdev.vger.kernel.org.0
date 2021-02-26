Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E72932699F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhBZVgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhBZVgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 16:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4D464E60;
        Fri, 26 Feb 2021 21:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614375330;
        bh=7NzoA9A2UELn7BwmQUFN7BXpJpRWYbPUyE9BvkcS94E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DSNdUXmPeIlJ5CV3j4VPtrelXiAsLczQRpYvMmCr7yGLZxtMRvqgA4UD/urEFYqgN
         2teLn+AZyNnx3er7Ws/OAsqKZQyDoMJXwKHbJV8TOZGwSPT47mYYBS/GWBtYXm4kbv
         EKaUs25yst542EFsvU51F98IrvRzHLctM5Eb9UkVnyYPH93ARZpqlSEKGjCOJXr8X5
         yAkH3W8bgBAWdW2erS6uGf+zuCz0C3SLrNcLn2mYI8c57hdUP+u47BH20a4waEFZkK
         AXI1h3aRB6Qak2RMMMgs/kLyGiRvpTz2sCh6wZp5kEaNXaN+R9Ir60vXlfgqxDmzbh
         93Qnzn8rlT15A==
Date:   Fri, 26 Feb 2021 13:35:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210226133528.66882be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_AJYBPMQY2DEy_vhRwrq5fnZR3z0A_-_HN0+S4yc45enQ@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
        <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com>
        <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com>
        <20210225171857.798e6c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0Ucip_cDs0juYN06xoDxFOrzo83JdhSOUEtRLugresQ2fw@mail.gmail.com>
        <CAEA6p_AJYBPMQY2DEy_vhRwrq5fnZR3z0A_-_HN0+S4yc45enQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 10:28:00 -0800 Wei Wang wrote:
> Hi Martin,
> Could you help try the following new patch on your setup and let me
> know if there are still issues?

FWIW your email got line wrapped for me.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ddf4cfc12615..9ed0f89ccdd5 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -357,9 +357,10 @@ enum {
>         NAPI_STATE_NPSVC,               /* Netpoll - don't dequeue
> from poll_list */
>         NAPI_STATE_LISTED,              /* NAPI added to system lists */
>         NAPI_STATE_NO_BUSY_POLL,        /* Do not add in napi_hash, no
> busy polling */
> -       NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
> +       NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() grabs SHED

nit: SHED -> SCHED

> bit and could busy poll */
>         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over
> softirq processing*/
>         NAPI_STATE_THREADED,            /* The poll is performed
> inside its own thread*/
> +       NAPI_STATE_SCHED_BUSY_POLL,     /* Napi is currently scheduled
> in busy poll mode */

nit: Napi -> NAPI ?

>  };
> 
>  enum {
> @@ -372,6 +373,7 @@ enum {
>         NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
>         NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
>         NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
> +       NAPIF_STATE_SCHED_BUSY_POLL     = BIT(NAPI_STATE_SCHED_BUSY_POLL),
>  };
> 
>  enum gro_result {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6c5967e80132..c717b67ce137 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1501,15 +1501,14 @@ static int napi_kthread_create(struct napi_struct *n)
>  {
>         int err = 0;
> 
> -       /* Create and wake up the kthread once to put it in
> -        * TASK_INTERRUPTIBLE mode to avoid the blocked task
> -        * warning and work with loadavg.
> +       /* Avoid using  kthread_run() here to prevent race
> +        * between softirq and kthread polling.
>          */
> -       n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
> -                               n->dev->name, n->napi_id);
> +       n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> +                                  n->dev->name, n->napi_id);

I'm not sure this takes care of rapid:

dev_set_threaded(0)
 # NAPI gets sent to sirq
dev_set_threaded(1)

since subsequent set_threaded(1) doesn't spawn the thread "afresh".

>         if (IS_ERR(n->thread)) {
>                 err = PTR_ERR(n->thread);
> -               pr_err("kthread_run failed with err %d\n", err);
> +               pr_err("kthread_create failed with err %d\n", err);
>                 n->thread = NULL;
>         }
> 
> @@ -6486,6 +6485,7 @@ bool napi_complete_done(struct napi_struct *n,
> int work_done)
>                 WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
> 
>                 new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> +                             NAPIF_STATE_SCHED_BUSY_POLL |
>                               NAPIF_STATE_PREFER_BUSY_POLL);
> 
>                 /* If STATE_MISSED was set, leave STATE_SCHED set,
> @@ -6525,6 +6525,7 @@ static struct napi_struct *napi_by_id(unsigned
> int napi_id)
> 
>  static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
>  {
> +       clear_bit(NAPI_STATE_SCHED_BUSY_POLL, &napi->state);
>         if (!skip_schedule) {
>                 gro_normal_list(napi);
>                 __napi_schedule(napi);
> @@ -6624,7 +6625,8 @@ void napi_busy_loop(unsigned int napi_id,
>                         }
>                         if (cmpxchg(&napi->state, val,
>                                     val | NAPIF_STATE_IN_BUSY_POLL |
> -                                         NAPIF_STATE_SCHED) != val) {
> +                                         NAPIF_STATE_SCHED |
> +                                         NAPIF_STATE_SCHED_BUSY_POLL) != val) {
>                                 if (prefer_busy_poll)
> 
> set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
>                                 goto count;
> @@ -6971,7 +6973,10 @@ static int napi_thread_wait(struct napi_struct *napi)
>         set_current_state(TASK_INTERRUPTIBLE);
> 
>         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> +               unsigned long val = READ_ONCE(napi->state);
> +
> +               if (val & NAPIF_STATE_SCHED &&
> +                   !(val & NAPIF_STATE_SCHED_BUSY_POLL)) {

Again, not protected from the napi_disable() case AFAICT.

>                         WARN_ON(!list_empty(&napi->poll_list));
>                         __set_current_state(TASK_RUNNING);
>                         return 0;
