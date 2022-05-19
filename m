Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997D652D53D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiESN5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239425AbiESNz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:55:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E503FEC301;
        Thu, 19 May 2022 06:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C313B824E8;
        Thu, 19 May 2022 13:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC78C34100;
        Thu, 19 May 2022 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968480;
        bh=AEjrDOCuTo0J9ipWz2zjAYKt3v8uXedR7Qj2Z5UtzVs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=XPAW3DLMEegkQsofWvlwU9+tJ7Q9gUL46IvvEviyqrHc4jIL604ojA8Fzxn2PVW/e
         x4V2YzkGm+kZKAzzSSLk6RWhjECJ7Zu8mbHg/MAieVpiwzflgaz0RUtD8p6ay567D9
         42lTFyoQ8lbk3MDNFsQgvYG7Tjep0XketBpekzikCeLXbN9jN4VRxvjo+5hbYpmugf
         zCtRRouHLTyzNfaZ4BqDXw53ZQKamwCMoOnYv6EV4mwaaYEJnEWP2kSA7vuQwgazg0
         4zerZgZRksDQr996CTSg+CeOAof/eVCkmeEA5tMpkmaFGphXX5q+zmjhZqvLc9+zLA
         IPaJ4WXS50WSg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id C7CD25C051D; Thu, 19 May 2022 06:54:39 -0700 (PDT)
Date:   Thu, 19 May 2022 06:54:39 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next 1/2] cpuidle/rcu: Making arch_cpu_idle and
 rcu_idle_exit noinstr
Message-ID: <20220519135439.GX1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
 <20220516114922.GA349949@lothringen>
 <YoN1WULUoKtMKx8v@krava>
 <20220518162118.GA2661055@paulmck-ThinkPad-P17-Gen-1>
 <YoYq/M6ZSQ+U2sar@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoYq/M6ZSQ+U2sar@krava>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 01:33:16PM +0200, Jiri Olsa wrote:
> On Wed, May 18, 2022 at 09:21:18AM -0700, Paul E. McKenney wrote:
> > On Tue, May 17, 2022 at 12:13:45PM +0200, Jiri Olsa wrote:
> > > On Mon, May 16, 2022 at 01:49:22PM +0200, Frederic Weisbecker wrote:
> > > > On Sun, May 15, 2022 at 09:25:35PM -0700, Paul E. McKenney wrote:
> > > > > On Sun, May 15, 2022 at 10:36:52PM +0200, Jiri Olsa wrote:
> > > > > > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > > > > > in rcu 'not watching' context and if there's tracer attached to
> > > > > > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > > > > > warning like:
> > > > > > 
> > > > > >   [    3.017540] WARNING: suspicious RCU usage
> > > > > >   ...
> > > > > >   [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> > > > > >   [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> > > > > >   [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> > > > > >   [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> > > > > >   [    3.018371]  fprobe_handler.part.0+0xab/0x150
> > > > > >   [    3.018374]  0xffffffffa00080c8
> > > > > >   [    3.018393]  ? arch_cpu_idle+0x5/0x10
> > > > > >   [    3.018398]  arch_cpu_idle+0x5/0x10
> > > > > >   [    3.018399]  default_idle_call+0x59/0x90
> > > > > >   [    3.018401]  do_idle+0x1c3/0x1d0
> > > > > > 
> > > > > > The call path is following:
> > > > > > 
> > > > > > default_idle_call
> > > > > >   rcu_idle_enter
> > > > > >   arch_cpu_idle
> > > > > >   rcu_idle_exit
> > > > > > 
> > > > > > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > > > > > path that are traceble and cause this problem on my setup.
> > > > > > 
> > > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > 
> > > > > From an RCU viewpoint:
> > > > > 
> > > > > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > > > > 
> > > > > [ I considered asking for an instrumentation_on() in rcu_idle_exit(),
> > > > > but there is no point given that local_irq_restore() isn't something
> > > > > you instrument anyway. ]
> > > > 
> > > > So local_irq_save() in the beginning of rcu_idle_exit() is unsafe because
> > > > it is instrumentable by the function (graph)  tracers and the irqsoff tracer.
> > > > 
> > > > Also it calls into lockdep that might make use of RCU.
> > > > 
> > > > That's why rcu_idle_exit() is not noinstr yet. See this patch:
> > > > 
> > > > https://lore.kernel.org/lkml/20220503100051.2799723-4-frederic@kernel.org/
> > > 
> > > I see, could we mark it at least with notrace meanwhile?
> > 
> > For the RCU part, how about as follows?
> > 
> > If this approach is reasonable, my guess would be that Frederic will pull
> > it into his context-tracking series, perhaps using a revert of this patch
> > to maintain sanity in the near term.
> > 
> > If this approach is unreasonable, well, that is Murphy for you!
> 
> I checked and it works in my test ;-)

Whew!!!  One piece of the problem might be solved, then.  ;-)

> > For the x86 idle part, my feeling is still that the rcu_idle_enter()
> > and rcu_idle_exit() need to be pushed deeper into the code.  Perhaps
> > an ongoing process as the idle loop continues to be dug deeper?
> 
> for arch_cpu_idle with noinstr I'm getting this W=1 warning:
> 
> vmlinux.o: warning: objtool: arch_cpu_idle()+0xb: call to {dynamic}() leaves .noinstr.text section
> 
> we could have it with notrace if that's a problem

I would be happy to queue the arch_cpu_idle() portion of your patch on
-rcu, if that would move things forward.  I suspect that additional
x86_idle() surgery is required, but maybe I am just getting confused
about what the x86_idle() function pointer can point to.  But it looks
to me like these need further help:

o	static void amd_e400_idle(void)
	Plus things it calls, like tick_broadcast_enter() and
	tick_broadcast_exit().

o	static __cpuidle void mwait_idle(void)

So it might not be all that much additional work, even if I have avoided
confusion about what the x86_idle() function pointer can point to.  But
I do not trust my ability to test this accurately.

Thoughts?

							Thanx, Paul

> thanks,
> jirka
> 
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > commit cd338be719a0a692e0d50e1a8438e1f6c7165d9c
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Tue May 17 21:00:04 2022 -0700
> > 
> >     rcu: Apply noinstr to rcu_idle_enter() and rcu_idle_exit()
> >     
> >     This commit applies the "noinstr" tag to the rcu_idle_enter() and
> >     rcu_idle_exit() functions, which are invoked from portions of the idle
> >     loop that cannot be instrumented.  These tags require reworking the
> >     rcu_eqs_enter() and rcu_eqs_exit() functions that these two functions
> >     invoke in order to cause them to use normal assertions rather than
> >     lockdep.  In addition, within rcu_idle_exit(), the raw versions of
> >     local_irq_save() and local_irq_restore() are used, again to avoid issues
> >     with lockdep in uninstrumented code.
> >     
> >     This patch is based in part on an earlier patch by Jiri Olsa, discussions
> >     with Peter Zijlstra and Frederic Weisbecker, earlier changes by Thomas
> >     Gleixner, and off-list discussions with Yonghong Song.
> >     
> >     Link: https://lore.kernel.org/lkml/20220515203653.4039075-1-jolsa@kernel.org/
> >     Reported-by: Jiri Olsa <jolsa@kernel.org>
> >     Reported-by: Alexei Starovoitov <ast@kernel.org>
> >     Reported-by: Andrii Nakryiko <andrii@kernel.org>
> >     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> >     Reviewed-by: Yonghong Song <yhs@fb.com>
> > 
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index 222d59299a2af..02233b17cce0e 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -635,8 +635,8 @@ static noinstr void rcu_eqs_enter(bool user)
> >  		return;
> >  	}
> >  
> > -	lockdep_assert_irqs_disabled();
> >  	instrumentation_begin();
> > +	lockdep_assert_irqs_disabled();
> >  	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
> >  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
> >  	rcu_preempt_deferred_qs(current);
> > @@ -663,9 +663,9 @@ static noinstr void rcu_eqs_enter(bool user)
> >   * If you add or remove a call to rcu_idle_enter(), be sure to test with
> >   * CONFIG_RCU_EQS_DEBUG=y.
> >   */
> > -void rcu_idle_enter(void)
> > +void noinstr rcu_idle_enter(void)
> >  {
> > -	lockdep_assert_irqs_disabled();
> > +	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !raw_irqs_disabled());
> >  	rcu_eqs_enter(false);
> >  }
> >  EXPORT_SYMBOL_GPL(rcu_idle_enter);
> > @@ -865,7 +865,7 @@ static void noinstr rcu_eqs_exit(bool user)
> >  	struct rcu_data *rdp;
> >  	long oldval;
> >  
> > -	lockdep_assert_irqs_disabled();
> > +	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !raw_irqs_disabled());
> >  	rdp = this_cpu_ptr(&rcu_data);
> >  	oldval = rdp->dynticks_nesting;
> >  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && oldval < 0);
> > @@ -900,13 +900,13 @@ static void noinstr rcu_eqs_exit(bool user)
> >   * If you add or remove a call to rcu_idle_exit(), be sure to test with
> >   * CONFIG_RCU_EQS_DEBUG=y.
> >   */
> > -void rcu_idle_exit(void)
> > +void noinstr rcu_idle_exit(void)
> >  {
> >  	unsigned long flags;
> >  
> > -	local_irq_save(flags);
> > +	raw_local_irq_save(flags);
> >  	rcu_eqs_exit(false);
> > -	local_irq_restore(flags);
> > +	raw_local_irq_restore(flags);
> >  }
> >  EXPORT_SYMBOL_GPL(rcu_idle_exit);
> >  
