Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9E03512D8
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 11:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhDAJ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 05:56:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234099AbhDAJzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 05:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617270952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKYNcgN/8f0+M2KRHqeGLa5t6Zl9AO9kTcmSU5pvkwM=;
        b=KmP+HXivV9RRnqs+OoAwKjb9p8hQCywm8JaoacVMORFPGjpdcLM6+gR4qGbCo1V++3Ktqz
        Gc+3Tb3lNp8dyOYxqRzFoVADOmscQGt7cFUgIPoBt8L1GKaVEfRgxEp1ZVUNE+gt6uGo4D
        vaube7Mo/Kjd6I7EtzNAyxtx5fF8SiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-aXT89E8IOzeLTMP6E0LLOw-1; Thu, 01 Apr 2021 05:55:49 -0400
X-MC-Unique: aXT89E8IOzeLTMP6E0LLOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E83AC802B40;
        Thu,  1 Apr 2021 09:55:47 +0000 (UTC)
Received: from ovpn-114-240.ams2.redhat.com (ovpn-114-240.ams2.redhat.com [10.36.114.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F0E61B49D;
        Thu,  1 Apr 2021 09:55:46 +0000 (UTC)
Message-ID: <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Thu, 01 Apr 2021 11:55:45 +0200
In-Reply-To: <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
         <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-31 at 18:41 -0700, Jakub Kicinski wrote:
> On Thu,  1 Apr 2021 00:46:18 +0200 Paolo Abeni wrote:
> > I hit an hangup on napi_disable(), when the threaded
> > mode is enabled and the napi is under heavy traffic.
> > 
> > If the relevant napi has been scheduled and the napi_disable()
> > kicks in before the next napi_threaded_wait() completes - so
> > that the latter quits due to the napi_disable_pending() condition,
> > the existing code leaves the NAPI_STATE_SCHED bit set and the
> > napi_disable() loop waiting for such bit will hang.
> > 
> > Address the issue explicitly clearing the SCHED_BIT on napi_thread
> > termination, if the thread is owns the napi.
> > 
> > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/core/dev.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b4c67a5be606d..e2e716ba027b8 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -7059,6 +7059,14 @@ static int napi_thread_wait(struct napi_struct *napi)
> >  		set_current_state(TASK_INTERRUPTIBLE);
> >  	}
> >  	__set_current_state(TASK_RUNNING);
> > +
> > +	/* if the thread owns this napi, and the napi itself has been disabled
> > +	 * in-between napi_schedule() and the above napi_disable_pending()
> > +	 * check, we need to clear the SCHED bit here, or napi_disable
> > +	 * will hang waiting for such bit being cleared
> > +	 */
> > +	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken)
> > +		clear_bit(NAPI_STATE_SCHED, &napi->state);
> 
> Not sure this covers 100% of the cases. We depend on the ability to go
> through schedule() "unnecessarily" when the napi gets scheduled after
> we go into TASK_INTERRUPTIBLE.

Empirically this patch fixes my test case (napi_disable/napi_enable in
a loop with the relevant napi under a lot of UDP traffic).

If I understand correctly, the critical scenario you see is something
alike:

CPU0			CPU1					CPU2
			// napi_threaded_poll() main loop
			napi_complete_done()
			// napi_threaded_poll() loop completes
	
napi_schedule()
// set SCHED bit
// NOT set SCHED_THREAD
// wake_up_process() is
// a no op
								napi_disable()
								// set DISABLE bit
			
			napi_thread_wait()
			set_current_state(TASK_INTERRUPTIBLE);
			// napi_thread_wait() loop completes,
			// SCHED_THREAD bit is cleared and
			// wake is false
	
> If we just check woken outside of the loop it may be false even though
> we got a "wake event".

I think in the above example even the normal processing will be
fooled?!? e.g. even without the napi_disable(), napi_thread_wait() will
 will miss the event/will not understand to it really own the napi and
will call schedule().

It looks a different problem to me ?!?

I *think* that replacing inside the napi_thread_wait() loop:

	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) 

with:

	unsigned long state = READ_ONCE(napi->state);

	if (state & NAPIF_STATE_SCHED &&
	    !(state & (NAPIF_STATE_IN_BUSY_POLL | NAPIF_STATE_DISABLE)) 

should solve it and should also allow removing the
NAPI_STATE_SCHED_THREADED bit. I feel like I'm missing some relevant
point here.

> Looking closer now I don't really understand where we ended up with
> disable handling :S  Seems like the thread exits on napi_disable(),
> but is reaped by netif_napi_del(). Some drivers (*cough* nfp) will
> go napi_disable() -> napi_enable()... and that will break. 
> 
> Am I missing something?
> 
> Should we not stay in the wait loop on napi_disable()?

Here I do not follow?!? Modulo the tiny race (which i was unable to
trigger so far) above napi_disable()/napi_enable() loops work correctly
here.

Could you please re-phrase?

Thanks!

Paolo

