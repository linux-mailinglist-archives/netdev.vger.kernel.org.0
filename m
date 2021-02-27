Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FBA326B1C
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 03:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhB0CJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 21:09:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhB0CJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 21:09:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D36A64EE7;
        Sat, 27 Feb 2021 02:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614391714;
        bh=gZnHN+1eiHWiNbIoqxpmwKKciTm8LX0/ROaWLpafE/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DCWvrqE5a7rnecK+xmyAj4G0q/OAidrNriEG+NpCkzCFPC2/U9FucMeZ4HI1go4sU
         2opl5aNA6XeRdcWJvwzz/ndX2r+hciqpGHMLqzrUy2p9MLpZzFrxCGdR4LMZno8S0i
         bDfh+OYhLLMfKbZk/4AiqNnOJeD0dQeGejwHk428+HESem0gRvIEgOiVZmcZK2e8wl
         iJpmJRVnqfmbSnt7D7CmqDYfGaXx0Ei8ISrabHtwl62lzQSV7lY84JV5eVWSu/toK5
         gf9jWGwYE0/pVHgCpViFvtTWaY5CcvDrUpK2W7N1zTwRHBV608g8qSZndKjNJ4VKBK
         mPCg25i+Nx+cQ==
Date:   Fri, 26 Feb 2021 18:08:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210226180833.09c98110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_B6baYFZnEOMS=Nmvg0kA_qB=7ip4S96ys9ZoJWfOiOCA@mail.gmail.com>
References: <20210227003047.1051347-1-weiwan@google.com>
        <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
        <20210226172240.24d626e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_B6baYFZnEOMS=Nmvg0kA_qB=7ip4S96ys9ZoJWfOiOCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 17:35:21 -0800 Wei Wang wrote:
> On Fri, Feb 26, 2021 at 5:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 26 Feb 2021 17:02:17 -0800 Wei Wang wrote:  
> > >  static int napi_thread_wait(struct napi_struct *napi)
> > >  {
> > > +       bool woken = false;
> > > +
> > >         set_current_state(TASK_INTERRUPTIBLE);
> > >
> > >         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > > -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > > +               unsigned long state = READ_ONCE(napi->state);
> > > +
> > > +               if ((state & NAPIF_STATE_SCHED) &&
> > > +                   ((state & NAPIF_STATE_SCHED_THREAD) || woken)) {
> > >                         WARN_ON(!list_empty(&napi->poll_list));
> > >                         __set_current_state(TASK_RUNNING);
> > >                         return 0;
> > > +               } else {
> > > +                       WARN_ON(woken);
> > >                 }
> > >
> > >                 schedule();
> > > +               woken = true;
> > >                 set_current_state(TASK_INTERRUPTIBLE);
> > >         }
> > >         __set_current_state(TASK_RUNNING);
> > >
> > > I don't think it is sufficient to only set SCHED_THREADED bit when the
> > > thread is in RUNNING state.
> > > In fact, the thread is most likely NOT in RUNNING mode before we call
> > > wake_up_process() in ____napi_schedule(), because it has finished the
> > > previous round of napi->poll() and SCHED bit was cleared, so
> > > napi_thread_wait() sets the state to INTERRUPTIBLE and schedule() call
> > > should already put it in sleep.  
> >
> > That's why the check says "|| woken":
> >
> >         ((state & NAPIF_STATE_SCHED_THREAD) ||  woken))
> >
> > thread knows it owns the NAPI if:
> >
> >   (a) the NAPI has the explicit flag set
> > or
> >   (b) it was just worken up and !kthread_should_stop(), since only
> >       someone who just claimed the normal SCHED on thread's behalf
> >       will wake it up  
> 
> The 'woken' is set after schedule(). If it is the first time
> napi_threaded_wait() is called, and SCHED_THREADED is not set, and
> woken is not set either, this thread will be put to sleep when it
> reaches schedule(), even though there is work waiting to be done on
> that napi. And I think this kthread will not be woken up again
> afterwards, since the SCHED bit is already grabbed.

Indeed, looks like the task will be in WAKING state until it runs?
We can switch the check in ____napi_schedule() from

	if (thread->state == TASK_RUNNING)

to

	if (!(thread->state & TASK_INTERRUPTIBLE))

?
