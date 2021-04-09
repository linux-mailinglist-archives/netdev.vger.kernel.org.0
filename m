Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B010359910
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhDIJY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:24:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbhDIJYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 05:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617960252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8B8UoBdcFI7n6i2guDf0hVv1xAqz/oAx69JSlCWnkk=;
        b=BSFN/j5plB0hNyPX7jlNExVRACCk6wRew/w+drMF3Z2BLDAda3CSwsgwPSzebruZ8YTeSo
        c3DItrPtQkKU+IiNFAX+iEMsRR78zJrvS13Nzt1KXAmJTijwjTpAfwf0Hwm5vC8O0ixB0n
        V6XshHd+QMct61UZBi4A7lh0jCPG5HA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-eFlSKI4gPh2MCJpxtiMDxQ-1; Fri, 09 Apr 2021 05:24:11 -0400
X-MC-Unique: eFlSKI4gPh2MCJpxtiMDxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E44F61006C80;
        Fri,  9 Apr 2021 09:24:09 +0000 (UTC)
Received: from ovpn-115-50.ams2.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B39D627DC;
        Fri,  9 Apr 2021 09:24:08 +0000 (UTC)
Message-ID: <7ff0f0e6027c3b84b0d0e1d58096392bfc0fe806.camel@redhat.com>
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 09 Apr 2021 11:24:07 +0200
In-Reply-To: <20210407111318.39c2374d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
         <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
         <20210401164415.6426d19c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <2254885d747833eaf2b4461cd1233551140f644a.camel@redhat.com>
         <20210407111318.39c2374d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-07 at 11:13 -0700, Jakub Kicinski wrote:
> On Wed, 07 Apr 2021 16:54:29 +0200 Paolo Abeni wrote:
> > > > I think in the above example even the normal processing will be
> > > > fooled?!? e.g. even without the napi_disable(), napi_thread_wait() will
> > > >  will miss the event/will not understand to it really own the napi and
> > > > will call schedule().
> > > > 
> > > > It looks a different problem to me ?!?
> > > > 
> > > > I *think* that replacing inside the napi_thread_wait() loop:
> > > > 
> > > > 	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) 
> > > > 
> > > > with:
> > > > 
> > > > 	unsigned long state = READ_ONCE(napi->state);
> > > > 
> > > > 	if (state & NAPIF_STATE_SCHED &&
> > > > 	    !(state & (NAPIF_STATE_IN_BUSY_POLL | NAPIF_STATE_DISABLE)) 
> > > > 
> > > > should solve it and should also allow removing the
> > > > NAPI_STATE_SCHED_THREADED bit. I feel like I'm missing some relevant
> > > > point here.  
> > > 
> > > Heh, that's closer to the proposal Eric put forward.
> > > 
> > > I strongly dislike   
> > 
> > I guess that can't be addressed ;)
> 
> I'm not _that_ unreasonable, I hope :) if there is multiple people
> disagreeing with me then so be it.

I'm sorry, I mean no offence! Just joking about the fact that is
usually hard changing preferences ;)

> > If you have strong opinion against the above, the only other option I
> > can think of is patching napi_schedule_prep() to set
> > both NAPI_STATE_SCHED and NAPI_STATE_SCHED_THREADED if threaded mode is
> > enabled for the running NAPI. That looks more complex and error prone,
> > so I really would avoid that.
> > 
> > Any other better option?
> > 
> > Side note: regardless of the above, I think we still need something
> > similar to the code in this patch, can we address the different issues
> > separately?
> 
> Not sure what issues you're referring to.

The patch that started this thread was ment to address a slightly
different race: napi_disable() hanging because napi_threaded_poll()
don't clear the NAPI_STATE_SCHED even when owning the napi instance.

> Right, I think the problem is disable_pending check is out of place.
> 
> How about this:
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9d1a8fac793f..e53f8bfed6a1 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -7041,7 +7041,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>  
>         set_current_state(TASK_INTERRUPTIBLE);
>  
> -       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> +       while (!kthread_should_stop()) {
>                 /* Testing SCHED_THREADED bit here to make sure the current
>                  * kthread owns this napi and could poll on this napi.
>                  * Testing SCHED bit is not enough because SCHED bit might be
> @@ -7049,8 +7049,14 @@ static int napi_thread_wait(struct napi_struct *napi)
>                  */
>                 if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
>                         WARN_ON(!list_empty(&napi->poll_list));
> -                       __set_current_state(TASK_RUNNING);
> -                       return 0;
> +                       if (unlikely(napi_disable_pending(napi))) {
> +                               clear_bit(NAPI_STATE_SCHED, &napi->state);
> +                               clear_bit(NAPI_STATE_SCHED_THREADED,
> +                                         &napi->state);
> +                       } else {
> +                               __set_current_state(TASK_RUNNING);
> +                               return 0;
> +                       }
>                 }
>  
>                 schedule();

It looks like the above works, and also fixes the problem I originally
reported. 

I think it can be simplified as the following - if NAPIF_STATE_DISABLE
is set, napi_threaded_poll()/__napi_poll() will return clearing the
SCHEDS bits after trying to poll the device:

---
diff --git a/net/core/dev.c b/net/core/dev.c
index d9db02d4e044..5cb6f411043d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6985,7 +6985,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 
        set_current_state(TASK_INTERRUPTIBLE);
 
-       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
+       while (!kthread_should_stop()) {
                /* Testing SCHED_THREADED bit here to make sure the current
                 * kthread owns this napi and could poll on this napi.
                 * Testing SCHED bit is not enough because SCHED bit might be

---

And works as intended here. I'll submit that formally, unless there are
objection.

Thanks!

Paolo
> 

