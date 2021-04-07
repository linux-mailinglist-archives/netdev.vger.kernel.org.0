Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43072357405
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhDGSNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355084AbhDGSN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A6861353;
        Wed,  7 Apr 2021 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617819199;
        bh=hqVfx+VvcV/EV/sPliVFqVqCeZInpURK8EpZbjjbuuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VhS6Lv/Eqf142Srw7lTFGJARZgsYILUcLB/n5fmYI37mjdNCz55fCCRA+m0vcULfF
         GyiwKixIILQgWG96DTto28H4l5oEYwpxEzyhLHBaRWDRFY4/Vj7+zDYbS73qAO69Hx
         Ra1fDInHzPT6/mB1VVMnHyL+5MrPn4cmC/rbxLeV5AXt/n4XEWRWb99yTnvM9DIgRQ
         5F8y8SzDZjwUE+PuNKGpODed4zr3xvezd3N/pMSPczWDm/sotGfKyp0s+jZB4J58QG
         L3AZWe6NywbTdqStPS+rFzrZg3XqP/pBoN0yU7cxjm/eHKThNCc5eKoAX3C/67jHnu
         Ww2ZhW1aO6MEA==
Date:   Wed, 7 Apr 2021 11:13:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
Message-ID: <20210407111318.39c2374d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2254885d747833eaf2b4461cd1233551140f644a.camel@redhat.com>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
        <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
        <20210401164415.6426d19c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2254885d747833eaf2b4461cd1233551140f644a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 07 Apr 2021 16:54:29 +0200 Paolo Abeni wrote:
> > > I think in the above example even the normal processing will be
> > > fooled?!? e.g. even without the napi_disable(), napi_thread_wait() will
> > >  will miss the event/will not understand to it really own the napi and
> > > will call schedule().
> > > 
> > > It looks a different problem to me ?!?
> > > 
> > > I *think* that replacing inside the napi_thread_wait() loop:
> > > 
> > > 	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) 
> > > 
> > > with:
> > > 
> > > 	unsigned long state = READ_ONCE(napi->state);
> > > 
> > > 	if (state & NAPIF_STATE_SCHED &&
> > > 	    !(state & (NAPIF_STATE_IN_BUSY_POLL | NAPIF_STATE_DISABLE)) 
> > > 
> > > should solve it and should also allow removing the
> > > NAPI_STATE_SCHED_THREADED bit. I feel like I'm missing some relevant
> > > point here.  
> > 
> > Heh, that's closer to the proposal Eric put forward.
> > 
> > I strongly dislike   
> 
> I guess that can't be addressed ;)

I'm not _that_ unreasonable, I hope :) if there is multiple people
disagreeing with me then so be it.

> > the idea that every NAPI consumer needs to be aware
> > of all the other consumers to make things work. That's n^2 mental
> > complexity.  
> 
> IMHO the overall complexity is not that bad: both napi_disable() and
> NAPI poll already set their own specific NAPI bit when acquiring the
> NAPI instance, they don't need to be aware of any other NAPI consumer
> internal.
> 
> The only NAPI user that needs to be aware of others is napi threaded,
> and I guess/hope we are not going to add more different kind of NAPI
> users.

I thought we agreed that we should leave the door open for other
pollers as a condition of merging this simplistic thread thing.

> If you have strong opinion against the above, the only other option I
> can think of is patching napi_schedule_prep() to set
> both NAPI_STATE_SCHED and NAPI_STATE_SCHED_THREADED if threaded mode is
> enabled for the running NAPI. That looks more complex and error prone,
> so I really would avoid that.
> 
> Any other better option?
> 
> Side note: regardless of the above, I think we still need something
> similar to the code in this patch, can we address the different issues
> separately?

Not sure what issues you're referring to.

> > > Here I do not follow?!? Modulo the tiny race (which i was unable to
> > > trigger so far) above napi_disable()/napi_enable() loops work correctly
> > > here.
> > > 
> > > Could you please re-phrase?  
> > 
> > After napi_disable() the thread will exit right? (napi_thread_wait()
> > returns -1, the loop in napi_threaded_poll() breaks, and the function
> > returns).
> > 
> > napi_enable() will not re-start the thread.
> > 
> > What driver are you testing with? You driver must always call
> > netif_napi_del() and netif_napi_add().  
> 
> veth + some XDP dummy prog - used just to enable NAPI.
> 
> Yep, it does a full netif_napi_del()/netif_napi_add().
> 
> Looks like plain napi_disable()/napi_enable() is not going to work in
> threaded mode.

Right, I think the problem is disable_pending check is out of place.

How about this:

diff --git a/net/core/dev.c b/net/core/dev.c
index 9d1a8fac793f..e53f8bfed6a1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7041,7 +7041,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 
        set_current_state(TASK_INTERRUPTIBLE);
 
-       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
+       while (!kthread_should_stop()) {
                /* Testing SCHED_THREADED bit here to make sure the current
                 * kthread owns this napi and could poll on this napi.
                 * Testing SCHED bit is not enough because SCHED bit might be
@@ -7049,8 +7049,14 @@ static int napi_thread_wait(struct napi_struct *napi)
                 */
                if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
                        WARN_ON(!list_empty(&napi->poll_list));
-                       __set_current_state(TASK_RUNNING);
-                       return 0;
+                       if (unlikely(napi_disable_pending(napi))) {
+                               clear_bit(NAPI_STATE_SCHED, &napi->state);
+                               clear_bit(NAPI_STATE_SCHED_THREADED,
+                                         &napi->state);
+                       } else {
+                               __set_current_state(TASK_RUNNING);
+                               return 0;
+                       }
                }
 
                schedule();

