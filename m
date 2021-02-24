Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB44324788
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhBXXaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:30:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhBXXaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:30:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4754064F03;
        Wed, 24 Feb 2021 23:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614209362;
        bh=OHpNCI2gtmusfmXCfYveBI5iZ4/bC4MgWISwY+pIx6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bIFQwK/wC8dN0Pjzsk05/6Swkk14A2DlfnQMG5VvB2soILl4ruRWK3NKzTUUp6TV3
         D1TCR5IvmrdMsfekdwdrmpRncOoiCnABiaZGxf1xufz9Wk0SDnemetyue6Twz87Ci5
         6QMJxKV0bhB6nf1DJYmrWvUxGA/vBhPownyOsdCxIDKHWeD6AlgK7LnYdXACZtKEqA
         yDwJAZt+0ngJm/CKu8kM3k5RSzjMm1823tQMGLF7xYDIonXg86wcDZjcrFX69gGA8G
         nTJhWk3zKBgXlgKso8IP1FthrkxTpWhcUzp4S3yidnR2JF/4mtzPOkTZFUDo0ngE1I
         F8WXQOFmhE4hg==
Date:   Wed, 24 Feb 2021 15:29:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210224152918.783eaae2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_Crfx8_izk+GCE30a-DAwiKbNmxNKJ0=7be1Wtm8AbX8Q@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_Crfx8_izk+GCE30a-DAwiKbNmxNKJ0=7be1Wtm8AbX8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 14:29:21 -0800 Wei Wang wrote:
> On Wed, Feb 24, 2021 at 1:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 24 Feb 2021 21:37:36 +0100 Eric Dumazet wrote:  
> > > On Wed, Feb 24, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > On Tue, 23 Feb 2021 15:41:30 -0800 Wei Wang wrote:  
> > > > > Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> > > > > determine if the kthread owns this napi and could call napi->poll() on
> > > > > it. However, if socket busy poll is enabled, it is possible that the
> > > > > busy poll thread grabs this SCHED bit (after the previous napi->poll()
> > > > > invokes napi_complete_done() and clears SCHED bit) and tries to poll
> > > > > on the same napi.
> > > > > This patch tries to fix this race by adding a new bit
> > > > > NAPI_STATE_SCHED_BUSY_POLL in napi->state. This bit gets set in
> > > > > napi_busy_loop() togther with NAPI_STATE_SCHED, and gets cleared in
> > > > > napi_complete_done() together with NAPI_STATE_SCHED. This helps
> > > > > distinguish the ownership of the napi between kthread and the busy poll
> > > > > thread, and prevents the kthread from polling on the napi when this napi
> > > > > is still owned by the busy poll thread.
> > > > >
> > > > > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > > > > Reported-by: Martin Zaharinov <micron10@gmail.com>
> > > > > Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > > Reviewed-by: Eric Dumazet <edumazet@google.come>  
> > > >
> > > > AFAIU sched bit controls the ownership of the poll_list  
> > >
> > > I disagree. BUSY POLL never inserted the napi into a list,
> > > because the user thread was polling one napi.
> > >
> > > Same for the kthread.  
> >
> > There is no delayed execution in busy_poll. It either got the sched bit
> > and it knows it, or it didn't.
> >  
> > > wake_up_process() should be good enough.  
> >
> > Well, if that's the direction maybe we should depend on the thread
> > state more?  IOW pay less attention to SCHED and have
> > napi_complete_done() set_current_state() if thread is running?
> >
> > I didn't think that through fully but you can't say "wake_up_process()
> > should be good enough" and at the same time add another bit proving
> > it's not enough.
> >  
> > > > Can we pleaseadd a poll_list for the thread and make sure the
> > > > thread polls based on the list?  
> > >
> > > A list ? That would require a spinlock or something ?  
> >
> > Does the softnet list require a spinlock?
> >
> > Obviously with current code the list would only ever have one napi
> > instance per thread but I think it's worth the code simplicity.
> > napi_complete_done() dels from the list / releases that ownership
> > already.
> 
> I think what Jakub proposed here should work. But I have a similar
> concern as Eric. I think the kthread belongs to the NAPI instance, and
> the kthread only polls on that specific NAPI if threaded mode is
> enabled. Adding the NAPI to a list that the kthread polls seems to be
> a reverse of logic. And it is unlike the sd->poll_list, where multiple
> NAPI instances could be added to that list and get polled. But
> functionality-wise, it does seem it will work.

My perspective is that the SCHED bit says "this NAPI has been scheduled
by someone to be processed". It doesn't say processed by who, so if the
ownership needs to be preserved the way to do that is napi->poll_list.

If NAPI is scheduled for sirq processing it goes on the sd list, if
it's threaded it goes on the thread's list.

Sure - today threads can only poll one NAPI so we could add a state bit
that says "this NAPI has been claimed by its thread". If you prefer
that strongly we can discuss, but IMO poll_list is a good abstraction
of linking the owner to the NAPI, no need for per-poller bits.

My mental model is that NAPI is always claimed or delegated to a poller
each time SCHED gets set. IIUC you're saying that it appears backwards
to give the NAPI to its dedicated thread, since the thread is expected
to own the NAPI. In my experience assuming the thread has the ownership
of the NAPI by the virtue that it was started causes issues around the
hand offs. It's much easier to establish that ownership on each SCHED.

> > > > IMO that's far clearer than defining a forest of ownership state
> > > > bits.  
> > >
> > > Adding a bit seems simpler than adding a list.  
> >
> > In terms of what? LoC?
> >
> > Just to find out what the LoC is I sketched this out:
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index ddf4cfc12615..77f09ced9ee4 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -348,6 +348,7 @@ struct napi_struct {
> >         struct hlist_node       napi_hash_node;
> >         unsigned int            napi_id;
> >         struct task_struct      *thread;
> > +       struct list_head        thread_poll_list;
> >  };
> >
> >  enum {
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 6c5967e80132..99ff083232e9 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet_data *sd,
> >                  */
> >                 thread = READ_ONCE(napi->thread);
> >                 if (thread) {
> > +                       list_add_tail(&napi->poll_list,
> > +                                     &napi->thread_poll_list);
> >                         wake_up_process(thread);
> >                         return;
> >                 }
> > @@ -6777,6 +6779,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
> >                 return;
> >
> >         INIT_LIST_HEAD(&napi->poll_list);
> > +       INIT_LIST_HEAD(&napi->thread_poll_list);
> >         INIT_HLIST_NODE(&napi->napi_hash_node);
> >         hrtimer_init(&napi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
> >         napi->timer.function = napi_watchdog;
> > @@ -6971,8 +6974,7 @@ static int napi_thread_wait(struct napi_struct *napi)
> >         set_current_state(TASK_INTERRUPTIBLE);
> >
> >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > -                       WARN_ON(!list_empty(&napi->poll_list));
> > +               if (!list_emtpy(&napi->thread_poll_list)) {
> >                         __set_current_state(TASK_RUNNING);
> >                         return 0;
> >                 }
> >
> > $ git diff --stat
> >  include/linux/netdevice.h | 1 +
> >  net/core/dev.c            | 6 ++++--
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >  
> > > > I think with just the right (wrong?) timing this patch will still
> > > > not protect against disabling the NAPI.  
> > >
> > > Maybe, but this patch is solving one issue that was easy to trigger.
> > >
> > > disabling the NAPI is handled already.  
> >
> > The thread checks if NAPI is getting disabled, then time passes, then
> > it checks if it's scheduled. If napi gets disabled in the "time passes"
> > period thread will think that it got scheduled again.
> 
> Not sure if I understand it correctly, when you say "then it checks if
> it's scheduled", do you mean the schedule() call in napi_thread_wait()
> that re-enters this function? If so, it still checks to make sure
> !napi_disable_pending(napi) before it goes to poll on the napi
> instance. I think that is sufficient to make sure we don't poll on a
> NAPI that is in DISABLE state?

Let me do a mash up of the code - this is what I'm thinking:
(prefix AA for CPU A, prefix BB for CPU B)

AA	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
AA	// condition true, enter the loop... but that's that? An IRQ comes..

BB	// napi_disable()
BB	set_bit(NAPI_STATE_DISABLE, &n->state);
BB	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
BB	// and CPU B continues on it's marry way..

AA	if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
AA		__set_current_state(TASK_RUNNING);
AA		return 0;

AA	// return to napi_threaded_poll()
AA	local_bh_disable();
AA	have = netpoll_poll_lock(napi);
AA	__napi_poll(napi, &repoll);

AA	// __napi_poll()
AA	weight = n->weight;
AA	work = 0;
AA	if (test_bit(NAPI_STATE_SCHED, &n->state)) {
AA		work = n->poll(n, weight);

> > Sure, we can go and make special annotations in all other parts of NAPI
> > infra, but isn't that an obvious sign of a bad design?
> >
> >
> > I wanted to add that I have spent quite a bit of time hacking around
> > the threaded NAPI thing before I had to maintain, and (admittedly my
> > brain is not very capable but) I had a hard time getting things working
> > reliably with netpoll, busy polling, disabling etc. IOW I'm not just
> > claiming that "more bits" is not a good solution on a whim.  
