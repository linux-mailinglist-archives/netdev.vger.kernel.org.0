Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3A654798
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 21:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbiLVU7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 15:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbiLVU7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 15:59:51 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50CEDF7A;
        Thu, 22 Dec 2022 12:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=isp1H2MjBGYeExMIQa379ifSGa8rRrUOUtT3JOLOum8=; b=rf6fdDNmqbzdyKaJHQopu8SuYV
        ZF9vJ2GqCUaHNwbg5dqVV8bJhoE6h2r/JLQr7CkGmFWlVD/2o7WZv88m9cXbegJg1JUkOzZRdZKF4
        LedQdranDq1BO4BSvVhWKvvy1TgyM7IbdtRVelmZwgEzet+O/OHskhUc6988CPlIDlFXJauL3cRgC
        m8sfFhTUrr6QLpfLzS5OPtt6m0XXf5oA0zKZAwQT22cp0uNiuZj/DFI+q4lDi3S38bAlg+1/lQ8T8
        LDX0pc9uiQsX5U0uqO1sUvLZ6PEkBc6SjXRIhfobNORaSwoTe18qoIkfjUbDgp7lSqlZo6/x5E+qz
        JoIxhrfg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p8Sev-00Dy4s-0K;
        Thu, 22 Dec 2022 20:59:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B92453003D2;
        Thu, 22 Dec 2022 21:59:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9039820167A87; Thu, 22 Dec 2022 21:59:21 +0100 (CET)
Date:   Thu, 22 Dec 2022 21:59:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>,
        acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
Message-ID: <Y6TFKdVJ9BY56fkI@hirez.programming.kicks-ass.net>
References: <000000000000a20a2e05f029c577@google.com>
 <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
 <3a5a4738-2868-8f2f-f8b2-a28c10fbe25b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a5a4738-2868-8f2f-f8b2-a28c10fbe25b@linux.dev>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 10:42:39AM +0800, Chengming Zhou wrote:

> > Does this help?
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index e47914ac8732..bbff551783e1 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -12689,7 +12689,8 @@ SYSCALL_DEFINE5(perf_event_open,
> >  	return event_fd;
> >  
> >  err_context:
> > -	/* event->pmu_ctx freed by free_event() */
> > +	put_pmu_ctx(event->pmu_ctx);
> > +	event->pmu_ctx = NULL; /* _free_event() */
> >  err_locked:
> >  	mutex_unlock(&ctx->mutex);
> >  	perf_unpin_context(ctx);
> 
> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
> 
> While reviewing the code, I found perf_event_create_kernel_counter()
> has the similar problem in the "err_pmu_ctx" error handling path:

Right you are, updated the patch, thanks!

> CPU0					CPU1
> perf_event_create_kernel_counter()
>   // inc ctx refcnt
>   find_get_context(task, event) (1)
> 
>   // inc pmu_ctx refcnt
>   pmu_ctx = find_get_pmu_context()
> 
>   event->pmu_ctx = pmu_ctx
>   ...
>   goto err_pmu_ctx:
>     // dec pmu_ctx refcnt
>     put_pmu_ctx(pmu_ctx) (2)
> 
>     mutex_unlock(&ctx->mutex)
>     // dec ctx refcnt
>     put_ctx(ctx)
> 					perf_event_exit_task_context()
> 					  mutex_lock()
> 					  mutex_unlock()
> 					  // last refcnt put
> 					  put_ctx()
>     free_event(event)
>       if (event->pmu_ctx) // True
>         put_pmu_ctx() (3)
>           // will access freed pmu_ctx or ctx
> 
>       if (event->ctx) // False
>         put_ctx()

This doesn't look right; iirc you can hit this without concurrency,
something like so:


	// note that when getting here, we've not passed
	// perf_install_in_context() and event->ctx == NULL.
err_pmu_ctx:
	put_pmu_ctx();
	put_ctx(); // last, actually frees ctx
	..
err_alloc:
	free_event()
	  _free_event()
	    if (event->pmu_ctx) // true, because we forgot to clear
	      put_pmu_ctx() // hits 0 because double put
	        // goes and touch epc->ctx and UaF


