Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20534681885
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbjA3STC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbjA3STB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:19:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DBC7DAE;
        Mon, 30 Jan 2023 10:18:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17221B815DF;
        Mon, 30 Jan 2023 18:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E1AC433D2;
        Mon, 30 Jan 2023 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675102736;
        bh=PEg0sSTCrY0yNh3mUFBP7zlDy/BwcKXxPNf43sPcBQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=abfDEXHFf7benkYjeTV2uRAGzfKU5LpMpYJ7uS7Kcv7AdaJyQrb9vcQaBWBsnf550
         zZhDZEeqv9yW8uNMbCAhsP8DQUX1dPGHNwDZWqXToEH0bSogjxQKF/I6ImNqyrlkbt
         AwCDmqv0HqKbyeZO+Bb/f01U9qjNr4bWK2LQx5fUdPkJr3vQvzg7QQLCI+xCiRqyuo
         J88BkftT6ClbgAR3h4nEl9jG5/2YZeGkcA1m8/eXk3iMuSZ8X+tcOSHA9w6vU2YraA
         0SjyVQIgZvM+R8+EOXq5kBf76j6GTXExUBflGl2vdG66zWu1PLPsP6yYx8Gnws5led
         U9f+Pu8zRqCZg==
Date:   Mon, 30 Jan 2023 10:18:53 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230130181853.irl3iqs7e23gw2kr@treble>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:40:18PM +0100, Peter Zijlstra wrote:
> On Fri, Jan 27, 2023 at 02:11:31PM -0800, Josh Poimboeuf wrote:
> 
> 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 4df2b3e76b30..fbcd3acca25c 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -36,6 +36,7 @@
> >  #include <linux/seqlock.h>
> >  #include <linux/kcsan.h>
> >  #include <linux/rv.h>
> > +#include <linux/livepatch_sched.h>
> >  #include <asm/kmap_size.h>
> >  
> >  /* task_struct member predeclarations (sorted alphabetically): */
> > @@ -2074,6 +2075,9 @@ DECLARE_STATIC_CALL(cond_resched, __cond_resched);
> >  
> >  static __always_inline int _cond_resched(void)
> >  {
> > +	//FIXME this is a bit redundant with preemption disabled
> > +	klp_sched_try_switch();
> > +
> >  	return static_call_mod(cond_resched)();
> >  }
> 
> Right, I was thinking you'd do something like:
> 
> 	static_call_update(cond_resched, klp_cond_resched);
> 
> With:
> 
> static int klp_cond_resched(void)
> {
> 	klp_try_switch_task(current);
> 	return __cond_resched();
> }
> 
> That would force cond_resched() into doing the transition thing,
> irrespective of the preemption mode at hand. And then, when KLP be done,
> re-run sched_dynamic_update() to reset it to whatever it ought to be.

Ok, makes sense.

> 
> > @@ -401,8 +421,10 @@ void klp_try_complete_transition(void)
> >  	 */
> >  	read_lock(&tasklist_lock);
> >  	for_each_process_thread(g, task)
> > -		if (!klp_try_switch_task(task))
> > +		if (!klp_try_switch_task(task)) {
> > +			set_tsk_need_resched(task);
> >  			complete = false;
> > +		}
> 
> Yeah, no, that's broken -- preemption state live in more than just the
> TIF bit.

Oops.

> >  	read_unlock(&tasklist_lock);
> >  
> >  	/*
> > @@ -413,6 +435,7 @@ void klp_try_complete_transition(void)
> >  		task = idle_task(cpu);
> >  		if (cpu_online(cpu)) {
> >  			if (!klp_try_switch_task(task)) {
> > +				set_tsk_need_resched(task);
> >  				complete = false;
> >  				/* Make idle task go through the main loop. */
> >  				wake_up_if_idle(cpu);
> 
> Idem.
> 
> Also, I don't see the point of this and the __schedule() hook here:

The (poorly executed) idea was to catch kthreads which do

	if (need_resched())
		schedule();

but I guess we can just replace those usages with cond_resched()?

> > @@ -8500,8 +8502,10 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
> >  static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
> >  int __sched dynamic_cond_resched(void)
> >  {
> > -	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
> > +	if (!static_branch_unlikely(&sk_dynamic_cond_resched)) {
> > +		klp_sched_try_switch();
> >  		return 0;
> > +	}
> >  	return __cond_resched();
> >  }
> >  EXPORT_SYMBOL(dynamic_cond_resched);
> 
> I would make the klp_sched_try_switch() not depend on
> sk_dynamic_cond_resched, because __cond_resched() is not a guaranteed
> pass through __schedule().
> 
> But you'll probably want to check with Mark here, this all might
> generate crap code on arm64.
> 
> Both ways this seems to make KLP 'depend' (or at least work lots better)
> when PREEMPT_DYNAMIC=y. Do we want a PREEMPT_DYNAMIC=n fallback for
> _cond_resched() too?

That was the intent but I obviously failed.  Let me go rework it a bit.

-- 
Josh
