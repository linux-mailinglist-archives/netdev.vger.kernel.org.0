Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F253246E0
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 23:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhBXWaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 17:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhBXWaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 17:30:13 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA814C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 14:29:33 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id m188so3431661yba.13
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 14:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+j61WT+MkSi3NBtgOtyS/S7OCqyIsr4HbhlARvBDEtc=;
        b=Hg7fI/p1FSGHm5yvA1NRu4JQLnK5AVULUfQjVPrkrHYK6Wyu4ApDeNg24UgrLrBcTU
         Pid9mmvKCu5pfDNSrQSIPrQcftLRkHQP9U45Kc9vMoWtBqfu9BdCpVIj2xud02/3AUqG
         7YdIsT0WX0M9xuNzEcK9XzuxgPLBrivI8O7vdSTNT8Cv4EN7vq9sale6Bu32yZoaQD8b
         KnnVyQS4vReKGpUJMxD6qOd9KmW2V0Fs7BJo/IyR0U1GN4HLjONGqrw1Ls+hsJdVj7YT
         hLQkYsfV+ckrIBOVYOziE+7F0VauZie6PaCfJ8ikGugwTfo97gbJkOQKe2AlmZbtWTHr
         NnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+j61WT+MkSi3NBtgOtyS/S7OCqyIsr4HbhlARvBDEtc=;
        b=kvC+46iRtrGdY7PGllerb/4Jx95ZSvl9gUiQiFQ10Pht7UaVRP9w6Agkuz72oGMX7R
         5K+Sk9DJXSWWwruPGDn+FBOaC9wT5zFO3t2RKG0JARiYEiR7BS1V4CAM2DwD6Ek3x/Ju
         qo7uQkVkra144fVzKvjg+VzlJJ6+pvOYsO/d9eB5OdgVJTywt/PVH9wpgtl+3ByNswJu
         IgjZ4Q+XDhOvDKAwSV8j5uIHCH8x6/eSZKA5V/9X+UwJzpgeHe3k1yZXHM2OkyPmQVYI
         eLKTu5D8aSrhZWQbWk81bJ3Fltk3Xwf3S9nwdWFv13dKLYRMwb3GVRGntAxqsBPedReY
         pV5Q==
X-Gm-Message-State: AOAM531S4j2gZ/FcGauKRIHeVKkA27pUAcsjJHyvfP+3agDnKmjKeZq7
        Ti2o6sDjyRHWnMQ0MV4iiWkWBK5snYOq84YjejVaPA==
X-Google-Smtp-Source: ABdhPJyhdWbByRtwCGutuyaLP7/XkllIxPaOVUpIP1Vkf48XttUBqAomESBdswc9uKaik+AV+9AjfJNxK+4aTlnqIqs=
X-Received: by 2002:a25:4981:: with SMTP id w123mr50221810yba.123.1614205772656;
 Wed, 24 Feb 2021 14:29:32 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com> <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 24 Feb 2021 14:29:21 -0800
Message-ID: <CAEA6p_Crfx8_izk+GCE30a-DAwiKbNmxNKJ0=7be1Wtm8AbX8Q@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 1:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Feb 2021 21:37:36 +0100 Eric Dumazet wrote:
> > On Wed, Feb 24, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue, 23 Feb 2021 15:41:30 -0800 Wei Wang wrote:
> > > > Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> > > > determine if the kthread owns this napi and could call napi->poll() on
> > > > it. However, if socket busy poll is enabled, it is possible that the
> > > > busy poll thread grabs this SCHED bit (after the previous napi->poll()
> > > > invokes napi_complete_done() and clears SCHED bit) and tries to poll
> > > > on the same napi.
> > > > This patch tries to fix this race by adding a new bit
> > > > NAPI_STATE_SCHED_BUSY_POLL in napi->state. This bit gets set in
> > > > napi_busy_loop() togther with NAPI_STATE_SCHED, and gets cleared in
> > > > napi_complete_done() together with NAPI_STATE_SCHED. This helps
> > > > distinguish the ownership of the napi between kthread and the busy poll
> > > > thread, and prevents the kthread from polling on the napi when this napi
> > > > is still owned by the busy poll thread.
> > > >
> > > > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > > > Reported-by: Martin Zaharinov <micron10@gmail.com>
> > > > Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > Reviewed-by: Eric Dumazet <edumazet@google.come>
> > >
> > > AFAIU sched bit controls the ownership of the poll_list
> >
> > I disagree. BUSY POLL never inserted the napi into a list,
> > because the user thread was polling one napi.
> >
> > Same for the kthread.
>
> There is no delayed execution in busy_poll. It either got the sched bit
> and it knows it, or it didn't.
>
> > wake_up_process() should be good enough.
>
> Well, if that's the direction maybe we should depend on the thread
> state more?  IOW pay less attention to SCHED and have
> napi_complete_done() set_current_state() if thread is running?
>
> I didn't think that through fully but you can't say "wake_up_process()
> should be good enough" and at the same time add another bit proving
> it's not enough.
>
> > > Can we pleaseadd a poll_list for the thread and make sure the
> > > thread polls based on the list?
> >
> > A list ? That would require a spinlock or something ?
>
> Does the softnet list require a spinlock?
>
> Obviously with current code the list would only ever have one napi
> instance per thread but I think it's worth the code simplicity.
> napi_complete_done() dels from the list / releases that ownership
> already.
>

I think what Jakub proposed here should work. But I have a similar
concern as Eric. I think the kthread belongs to the NAPI instance, and
the kthread only polls on that specific NAPI if threaded mode is
enabled. Adding the NAPI to a list that the kthread polls seems to be
a reverse of logic. And it is unlike the sd->poll_list, where multiple
NAPI instances could be added to that list and get polled. But
functionality-wise, it does seem it will work.

> > > IMO that's far clearer than defining a forest of ownership state
> > > bits.
> >
> > Adding a bit seems simpler than adding a list.
>
> In terms of what? LoC?
>
> Just to find out what the LoC is I sketched this out:
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ddf4cfc12615..77f09ced9ee4 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -348,6 +348,7 @@ struct napi_struct {
>         struct hlist_node       napi_hash_node;
>         unsigned int            napi_id;
>         struct task_struct      *thread;
> +       struct list_head        thread_poll_list;
>  };
>
>  enum {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6c5967e80132..99ff083232e9 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>                  */
>                 thread = READ_ONCE(napi->thread);
>                 if (thread) {
> +                       list_add_tail(&napi->poll_list,
> +                                     &napi->thread_poll_list);
>                         wake_up_process(thread);
>                         return;
>                 }
> @@ -6777,6 +6779,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>                 return;
>
>         INIT_LIST_HEAD(&napi->poll_list);
> +       INIT_LIST_HEAD(&napi->thread_poll_list);
>         INIT_HLIST_NODE(&napi->napi_hash_node);
>         hrtimer_init(&napi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
>         napi->timer.function = napi_watchdog;
> @@ -6971,8 +6974,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>         set_current_state(TASK_INTERRUPTIBLE);
>
>         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> -                       WARN_ON(!list_empty(&napi->poll_list));
> +               if (!list_emtpy(&napi->thread_poll_list)) {
>                         __set_current_state(TASK_RUNNING);
>                         return 0;
>                 }
>
> $ git diff --stat
>  include/linux/netdevice.h | 1 +
>  net/core/dev.c            | 6 ++++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> > > I think with just the right (wrong?) timing this patch will still
> > > not protect against disabling the NAPI.
> >
> > Maybe, but this patch is solving one issue that was easy to trigger.
> >
> > disabling the NAPI is handled already.
>
> The thread checks if NAPI is getting disabled, then time passes, then
> it checks if it's scheduled. If napi gets disabled in the "time passes"
> period thread will think that it got scheduled again.
>

Not sure if I understand it correctly, when you say "then it checks if
it's scheduled", do you mean the schedule() call in napi_thread_wait()
that re-enters this function? If so, it still checks to make sure
!napi_disable_pending(napi) before it goes to poll on the napi
instance. I think that is sufficient to make sure we don't poll on a
NAPI that is in DISABLE state?


> Sure, we can go and make special annotations in all other parts of NAPI
> infra, but isn't that an obvious sign of a bad design?
>
>
> I wanted to add that I have spent quite a bit of time hacking around
> the threaded NAPI thing before I had to maintain, and (admittedly my
> brain is not very capable but) I had a hard time getting things working
> reliably with netpoll, busy polling, disabling etc. IOW I'm not just
> claiming that "more bits" is not a good solution on a whim.
