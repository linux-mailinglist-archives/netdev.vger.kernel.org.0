Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFF7356F5A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhDGOyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:54:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230426AbhDGOyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 10:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617807275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHbgwFpMfeLufvzLh7Y1l3Q1C8RbBxPPP6kzoArAAsY=;
        b=HhPkeqgQi492W94DrdvbhRCeZ+5fI5ewra127qeSx2yC23WEd0wMGYbdXonca/nV/RaaDo
        YQ2v5rsYRakKO9kreAVdeorDh7qrBZJsof9oY5ArE4uDJET6c+WmSm5acJFk9BMSk9suzI
        sLKWdpanQVEKCX3G7MpXX4jbmvbgPvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-_WyJVxcGPVK-7KahjYxLQg-1; Wed, 07 Apr 2021 10:54:33 -0400
X-MC-Unique: _WyJVxcGPVK-7KahjYxLQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 530378030D5;
        Wed,  7 Apr 2021 14:54:31 +0000 (UTC)
Received: from ovpn-112-119.ams2.redhat.com (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 047F85D741;
        Wed,  7 Apr 2021 14:54:29 +0000 (UTC)
Message-ID: <2254885d747833eaf2b4461cd1233551140f644a.camel@redhat.com>
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 07 Apr 2021 16:54:29 +0200
In-Reply-To: <20210401164415.6426d19c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
         <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
         <20210401164415.6426d19c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm sorry for the lag,

On Thu, 2021-04-01 at 16:44 -0700, Jakub Kicinski wrote:
> On Thu, 01 Apr 2021 11:55:45 +0200 Paolo Abeni wrote:
> > On Wed, 2021-03-31 at 18:41 -0700, Jakub Kicinski wrote:
> > > On Thu,  1 Apr 2021 00:46:18 +0200 Paolo Abeni wrote:  
> > > > I hit an hangup on napi_disable(), when the threaded
> > > > mode is enabled and the napi is under heavy traffic.
> > > > 
> > > > If the relevant napi has been scheduled and the napi_disable()
> > > > kicks in before the next napi_threaded_wait() completes - so
> > > > that the latter quits due to the napi_disable_pending() condition,
> > > > the existing code leaves the NAPI_STATE_SCHED bit set and the
> > > > napi_disable() loop waiting for such bit will hang.
> > > > 
> > > > Address the issue explicitly clearing the SCHED_BIT on napi_thread
> > > > termination, if the thread is owns the napi.
> > > > 
> > > > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  net/core/dev.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > > 
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index b4c67a5be606d..e2e716ba027b8 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -7059,6 +7059,14 @@ static int napi_thread_wait(struct napi_struct *napi)
> > > >  		set_current_state(TASK_INTERRUPTIBLE);
> > > >  	}
> > > >  	__set_current_state(TASK_RUNNING);
> > > > +
> > > > +	/* if the thread owns this napi, and the napi itself has been disabled
> > > > +	 * in-between napi_schedule() and the above napi_disable_pending()
> > > > +	 * check, we need to clear the SCHED bit here, or napi_disable
> > > > +	 * will hang waiting for such bit being cleared
> > > > +	 */
> > > > +	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken)
> > > > +		clear_bit(NAPI_STATE_SCHED, &napi->state);  
> > > 
> > > Not sure this covers 100% of the cases. We depend on the ability to go
> > > through schedule() "unnecessarily" when the napi gets scheduled after
> > > we go into TASK_INTERRUPTIBLE.  
> > 
> > Empirically this patch fixes my test case (napi_disable/napi_enable in
> > a loop with the relevant napi under a lot of UDP traffic).
> > 
> > If I understand correctly, the critical scenario you see is something
> > alike:
> > 
> > CPU0			CPU1					CPU2
> > 			// napi_threaded_poll() main loop
> > 			napi_complete_done()
> > 			// napi_threaded_poll() loop completes
> > 	
> > napi_schedule()
> > // set SCHED bit
> > // NOT set SCHED_THREAD
> 
> Why does it not set SCHED_THREAD if task is RUNNING?

Because I'm dumb, I saw the race only on paper, and I mismatched the
napi thread status. The actual race I was thinking is what you wrote
below ;)

> > // wake_up_process() is
> > // a no op
> > 								napi_disable()
> > 								// set DISABLE bit
> > 			
> > 			napi_thread_wait()
> > 			set_current_state(TASK_INTERRUPTIBLE);
> > 			// napi_thread_wait() loop completes,
> > 			// SCHED_THREAD bit is cleared and
> > 			// wake is false
> 
> I was thinking of:
> 
> CPU0                        CPU1                            CPU2
> ====                        ====                            ====
> napi_complete_done()
> set INTERRUPTIBLE
>                                                             napi_schedule
>                                                             set RUNNING
>                             napi_disable()
> if (should_stop() || 
>     disable_pending())
> // does not enter loop
> // test from this patch:
> if (SCHED_THREADED || woken)
> // .. is false
> 
> 
> > > If we just check woken outside of the loop it may be false even though
> > > we got a "wake event".  
> > 
> > I think in the above example even the normal processing will be
> > fooled?!? e.g. even without the napi_disable(), napi_thread_wait() will
> >  will miss the event/will not understand to it really own the napi and
> > will call schedule().
> > 
> > It looks a different problem to me ?!?
> > 
> > I *think* that replacing inside the napi_thread_wait() loop:
> > 
> > 	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) 
> > 
> > with:
> > 
> > 	unsigned long state = READ_ONCE(napi->state);
> > 
> > 	if (state & NAPIF_STATE_SCHED &&
> > 	    !(state & (NAPIF_STATE_IN_BUSY_POLL | NAPIF_STATE_DISABLE)) 
> > 
> > should solve it and should also allow removing the
> > NAPI_STATE_SCHED_THREADED bit. I feel like I'm missing some relevant
> > point here.
> 
> Heh, that's closer to the proposal Eric put forward.
> 
> I strongly dislike 

I guess that can't be addressed ;)

> the idea that every NAPI consumer needs to be aware
> of all the other consumers to make things work. That's n^2 mental
> complexity.

IMHO the overall complexity is not that bad: both napi_disable() and
NAPI poll already set their own specific NAPI bit when acquiring the
NAPI instance, they don't need to be aware of any other NAPI consumer
internal.

The only NAPI user that needs to be aware of others is napi threaded,
and I guess/hope we are not going to add more different kind of NAPI
users.

If you have strong opinion against the above, the only other option I
can think of is patching napi_schedule_prep() to set
both NAPI_STATE_SCHED and NAPI_STATE_SCHED_THREADED if threaded mode is
enabled for the running NAPI. That looks more complex and error prone,
so I really would avoid that.

Any other better option?

Side note: regardless of the above, I think we still need something
similar to the code in this patch, can we address the different issues
separately?

> > > Looking closer now I don't really understand where we ended up with
> > > disable handling :S  Seems like the thread exits on napi_disable(),
> > > but is reaped by netif_napi_del(). Some drivers (*cough* nfp) will
> > > go napi_disable() -> napi_enable()... and that will break. 
> > > 
> > > Am I missing something?
> > > 
> > > Should we not stay in the wait loop on napi_disable()?  
> > 
> > Here I do not follow?!? Modulo the tiny race (which i was unable to
> > trigger so far) above napi_disable()/napi_enable() loops work correctly
> > here.
> > 
> > Could you please re-phrase?
> 
> After napi_disable() the thread will exit right? (napi_thread_wait()
> returns -1, the loop in napi_threaded_poll() breaks, and the function
> returns).
> 
> napi_enable() will not re-start the thread.
> 
> What driver are you testing with? You driver must always call
> netif_napi_del() and netif_napi_add().

veth + some XDP dummy prog - used just to enable NAPI.

Yep, it does a full netif_napi_del()/netif_napi_add().

Looks like plain napi_disable()/napi_enable() is not going to work in
threaded mode.

Cheers,

Paolo

