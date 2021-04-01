Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F03352425
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhDAXoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236345AbhDAXoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2025661105;
        Thu,  1 Apr 2021 23:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617320656;
        bh=hb2MUjR36okK6q/CjF/2P7d/DLw2q3MoVwpP7me8mPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uoYgWpB0iV5Ebqk/oCI8noVty4gpn0MT4pr19by5EN2iWgjLEQ3+y8NZkjHSFpgSa
         wm9dPQJLY7X0V/wCFDQakxxMQ/1gxP+JneQLnMhfBzim4podl60VMM/fqMPn5LIOAe
         PewENstlp0BjH263ENicy/A8jOC/Wh1Rr6uoo9pcgXwTotYGtFMb7rQE4Zn8KT/aoH
         OytlslEnHPbBWb+vX+91W8kCLUtWGPGKm9N0wbSs/yL7yydzbhqGagbtNyRuandYUP
         t9M1l/j9eSEVud2edIyyniGEoiabgnAND562dgs7H7/fnfR4UIV0VIK+x0cZ++H+gi
         p4Xrw9C9cgZyA==
Date:   Thu, 1 Apr 2021 16:44:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
Message-ID: <20210401164415.6426d19c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
        <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Apr 2021 11:55:45 +0200 Paolo Abeni wrote:
> On Wed, 2021-03-31 at 18:41 -0700, Jakub Kicinski wrote:
> > On Thu,  1 Apr 2021 00:46:18 +0200 Paolo Abeni wrote:  
> > > I hit an hangup on napi_disable(), when the threaded
> > > mode is enabled and the napi is under heavy traffic.
> > > 
> > > If the relevant napi has been scheduled and the napi_disable()
> > > kicks in before the next napi_threaded_wait() completes - so
> > > that the latter quits due to the napi_disable_pending() condition,
> > > the existing code leaves the NAPI_STATE_SCHED bit set and the
> > > napi_disable() loop waiting for such bit will hang.
> > > 
> > > Address the issue explicitly clearing the SCHED_BIT on napi_thread
> > > termination, if the thread is owns the napi.
> > > 
> > > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  net/core/dev.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index b4c67a5be606d..e2e716ba027b8 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -7059,6 +7059,14 @@ static int napi_thread_wait(struct napi_struct *napi)
> > >  		set_current_state(TASK_INTERRUPTIBLE);
> > >  	}
> > >  	__set_current_state(TASK_RUNNING);
> > > +
> > > +	/* if the thread owns this napi, and the napi itself has been disabled
> > > +	 * in-between napi_schedule() and the above napi_disable_pending()
> > > +	 * check, we need to clear the SCHED bit here, or napi_disable
> > > +	 * will hang waiting for such bit being cleared
> > > +	 */
> > > +	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken)
> > > +		clear_bit(NAPI_STATE_SCHED, &napi->state);  
> > 
> > Not sure this covers 100% of the cases. We depend on the ability to go
> > through schedule() "unnecessarily" when the napi gets scheduled after
> > we go into TASK_INTERRUPTIBLE.  
> 
> Empirically this patch fixes my test case (napi_disable/napi_enable in
> a loop with the relevant napi under a lot of UDP traffic).
> 
> If I understand correctly, the critical scenario you see is something
> alike:
> 
> CPU0			CPU1					CPU2
> 			// napi_threaded_poll() main loop
> 			napi_complete_done()
> 			// napi_threaded_poll() loop completes
> 	
> napi_schedule()
> // set SCHED bit
> // NOT set SCHED_THREAD

Why does it not set SCHED_THREAD if task is RUNNING?

> // wake_up_process() is
> // a no op
> 								napi_disable()
> 								// set DISABLE bit
> 			
> 			napi_thread_wait()
> 			set_current_state(TASK_INTERRUPTIBLE);
> 			// napi_thread_wait() loop completes,
> 			// SCHED_THREAD bit is cleared and
> 			// wake is false

I was thinking of:

CPU0                        CPU1                            CPU2
====                        ====                            ====
napi_complete_done()
set INTERRUPTIBLE
                                                            napi_schedule
                                                            set RUNNING
                            napi_disable()
if (should_stop() || 
    disable_pending())
// does not enter loop
// test from this patch:
if (SCHED_THREADED || woken)
// .. is false


> > If we just check woken outside of the loop it may be false even though
> > we got a "wake event".  
> 
> I think in the above example even the normal processing will be
> fooled?!? e.g. even without the napi_disable(), napi_thread_wait() will
>  will miss the event/will not understand to it really own the napi and
> will call schedule().
> 
> It looks a different problem to me ?!?
> 
> I *think* that replacing inside the napi_thread_wait() loop:
> 
> 	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) 
> 
> with:
> 
> 	unsigned long state = READ_ONCE(napi->state);
> 
> 	if (state & NAPIF_STATE_SCHED &&
> 	    !(state & (NAPIF_STATE_IN_BUSY_POLL | NAPIF_STATE_DISABLE)) 
> 
> should solve it and should also allow removing the
> NAPI_STATE_SCHED_THREADED bit. I feel like I'm missing some relevant
> point here.

Heh, that's closer to the proposal Eric put forward.

I strongly dislike the idea that every NAPI consumer needs to be aware
of all the other consumers to make things work. That's n^2 mental
complexity.

> > Looking closer now I don't really understand where we ended up with
> > disable handling :S  Seems like the thread exits on napi_disable(),
> > but is reaped by netif_napi_del(). Some drivers (*cough* nfp) will
> > go napi_disable() -> napi_enable()... and that will break. 
> > 
> > Am I missing something?
> > 
> > Should we not stay in the wait loop on napi_disable()?  
> 
> Here I do not follow?!? Modulo the tiny race (which i was unable to
> trigger so far) above napi_disable()/napi_enable() loops work correctly
> here.
> 
> Could you please re-phrase?

After napi_disable() the thread will exit right? (napi_thread_wait()
returns -1, the loop in napi_threaded_poll() breaks, and the function
returns).

napi_enable() will not re-start the thread.

What driver are you testing with? You driver must always call
netif_napi_del() and netif_napi_add().
