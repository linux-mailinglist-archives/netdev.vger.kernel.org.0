Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FDD3006DE
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbhAVPNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:13:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729065AbhAVPCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611327686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pmb5w3rLav37us1XL43BkDMIwzOvI7ua2CZXzDfcqdo=;
        b=RMNia+aWsbZ2a4Uow1vMMsoI1dfC5hik/A4ABjPSW+h7rvN7tUD2HQmzicf9J1bJJvX5fx
        a2A57LcIXNIQLFbhEMwC7faaho3vWa3w8uNOjc3wvYqS8FNHz7o/T5ZR/lNv462IxQJDe2
        tDVWVCPnmJmqGK+Win3qP+3ouaN9etY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-8khLFf0OO4Wy_Qo2eG4Tuw-1; Fri, 22 Jan 2021 10:01:22 -0500
X-MC-Unique: 8khLFf0OO4Wy_Qo2eG4Tuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A28DA190A7A1;
        Fri, 22 Jan 2021 15:01:18 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32EC36F990;
        Fri, 22 Jan 2021 15:01:18 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 02E034178900; Fri, 22 Jan 2021 11:13:20 -0300 (-03)
Date:   Fri, 22 Jan 2021 11:13:20 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Alex Belits <abelits@marvell.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 11/13] task_isolation: net: don't flush backlog on
 CPUs running isolated tasks
Message-ID: <20210122141320.GA66969@fuller.cnet>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <01470cf1f1a2e79e46a87bb5a8a4780a1c3cc740.camel@marvell.com>
 <20201001144731.GC6595@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001144731.GC6595@lothringen>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 04:47:31PM +0200, Frederic Weisbecker wrote:
> On Wed, Jul 22, 2020 at 02:58:24PM +0000, Alex Belits wrote:
> > From: Yuri Norov <ynorov@marvell.com>
> > 

> > so we don't need to flush it.
> 
> What guarantees that we have no backlog on it?

From Paolo's work to use lockless reading of 
per-CPU skb lists

https://www.spinics.net/lists/netdev/msg682693.html

It also exposed skb queue length to userspace

https://www.spinics.net/lists/netdev/msg684939.html

But if i remember correctly waiting for a RCU grace
period was also necessary to ensure no backlog !?! 

Paolo would you please remind us what was the sequence of steps?
(and then also, for the userspace isolation interface, where 
the application informs the kernel that its entering isolated
mode, is just confirming the queues have zero length is
sufficient?).

TIA!

> 
> > Currently flush_all_backlogs()
> > enqueues corresponding work on all CPUs including ones that run
> > isolated tasks. It leads to breaking task isolation for nothing.
> > 
> > In this patch, backlog flushing is enqueued only on non-isolated CPUs.
> > 
> > Signed-off-by: Yuri Norov <ynorov@marvell.com>
> > [abelits@marvell.com: use safe task_isolation_on_cpu() implementation]
> > Signed-off-by: Alex Belits <abelits@marvell.com>
> > ---
> >  net/core/dev.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 90b59fc50dc9..83a282f7453d 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -74,6 +74,7 @@
> >  #include <linux/cpu.h>
> >  #include <linux/types.h>
> >  #include <linux/kernel.h>
> > +#include <linux/isolation.h>
> >  #include <linux/hash.h>
> >  #include <linux/slab.h>
> >  #include <linux/sched.h>
> > @@ -5624,9 +5625,13 @@ static void flush_all_backlogs(void)
> >  
> >  	get_online_cpus();
> >  
> > -	for_each_online_cpu(cpu)
> > +	smp_rmb();
> 
> What is it ordering?
> 
> > +	for_each_online_cpu(cpu) {
> > +		if (task_isolation_on_cpu(cpu))
> > +			continue;
> >  		queue_work_on(cpu, system_highpri_wq,
> >  			      per_cpu_ptr(&flush_works, cpu));
> > +	}
> >  
> >  	for_each_online_cpu(cpu)
> >  		flush_work(per_cpu_ptr(&flush_works, cpu));
> 
> Thanks.

