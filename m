Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FED532FAD
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 19:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbiEXRdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiEXRdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 13:33:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F383469704;
        Tue, 24 May 2022 10:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FA076152D;
        Tue, 24 May 2022 17:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27D1C34100;
        Tue, 24 May 2022 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653413598;
        bh=yJ7I3snLv5PVDvC3JiMfknwjkJ75ehFQRdtaJK/7je0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=IjUzDgvNPH0/mcP6e8YmZXsOrvq+A8naxYWEyW7qXQRfV6Vk7V0JG3TDaVry1XaKx
         Vc0+zGPyCClpng9+IzF0qvh8sMFpD+wmtJNVBYprQ5AsugCo0ojfZ2HBfi4sq31WUY
         z+j8lfVbAX+Gt5oXRXgWOyEUA6zeCIdc2WwTVmOV4LOa8juhmzyadc294kgqLKv9lX
         taQo12/47LG4XSExqPxWUMTWBqWK2Z+g9f/0W1hIrlhqOcge45C3BVSlyA4UXrMbVC
         F9M7vT4vTmQp+NJll09LfK1d7SV3/Al5KE6jmeK57LxiBw2a0YBlrdo8o9ZSqnB/yS
         hW5vyLAYcnNAQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8D3255C0378; Tue, 24 May 2022 10:33:17 -0700 (PDT)
Date:   Tue, 24 May 2022 10:33:17 -0700
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
Message-ID: <20220524173317.GQ1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
 <20220516114922.GA349949@lothringen>
 <YoN1WULUoKtMKx8v@krava>
 <20220518162118.GA2661055@paulmck-ThinkPad-P17-Gen-1>
 <YoYq/M6ZSQ+U2sar@krava>
 <20220519135439.GX1790663@paulmck-ThinkPad-P17-Gen-1>
 <YouIPHx2l0S3bMLv@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YouIPHx2l0S3bMLv@krava>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 03:12:28PM +0200, Jiri Olsa wrote:
> On Thu, May 19, 2022 at 06:54:39AM -0700, Paul E. McKenney wrote:
> > On Thu, May 19, 2022 at 01:33:16PM +0200, Jiri Olsa wrote:
> > > On Wed, May 18, 2022 at 09:21:18AM -0700, Paul E. McKenney wrote:
> > > > On Tue, May 17, 2022 at 12:13:45PM +0200, Jiri Olsa wrote:
> > > > > On Mon, May 16, 2022 at 01:49:22PM +0200, Frederic Weisbecker wrote:
> > > > > > On Sun, May 15, 2022 at 09:25:35PM -0700, Paul E. McKenney wrote:
> > > > > > > On Sun, May 15, 2022 at 10:36:52PM +0200, Jiri Olsa wrote:
> > > > > > > > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > > > > > > > in rcu 'not watching' context and if there's tracer attached to
> > > > > > > > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > > > > > > > warning like:
> > > > > > > > 
> > > > > > > >   [    3.017540] WARNING: suspicious RCU usage
> > > > > > > >   ...
> > > > > > > >   [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> > > > > > > >   [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> > > > > > > >   [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> > > > > > > >   [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> > > > > > > >   [    3.018371]  fprobe_handler.part.0+0xab/0x150
> > > > > > > >   [    3.018374]  0xffffffffa00080c8
> > > > > > > >   [    3.018393]  ? arch_cpu_idle+0x5/0x10
> > > > > > > >   [    3.018398]  arch_cpu_idle+0x5/0x10
> > > > > > > >   [    3.018399]  default_idle_call+0x59/0x90
> > > > > > > >   [    3.018401]  do_idle+0x1c3/0x1d0
> > > > > > > > 
> > > > > > > > The call path is following:
> > > > > > > > 
> > > > > > > > default_idle_call
> > > > > > > >   rcu_idle_enter
> > > > > > > >   arch_cpu_idle
> > > > > > > >   rcu_idle_exit
> > > > > > > > 
> > > > > > > > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > > > > > > > path that are traceble and cause this problem on my setup.
> > > > > > > > 
> > > > > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > > > 
> > > > > > > From an RCU viewpoint:
> > > > > > > 
> > > > > > > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > > > > > > 
> > > > > > > [ I considered asking for an instrumentation_on() in rcu_idle_exit(),
> > > > > > > but there is no point given that local_irq_restore() isn't something
> > > > > > > you instrument anyway. ]
> > > > > > 
> > > > > > So local_irq_save() in the beginning of rcu_idle_exit() is unsafe because
> > > > > > it is instrumentable by the function (graph)  tracers and the irqsoff tracer.
> > > > > > 
> > > > > > Also it calls into lockdep that might make use of RCU.
> > > > > > 
> > > > > > That's why rcu_idle_exit() is not noinstr yet. See this patch:
> > > > > > 
> > > > > > https://lore.kernel.org/lkml/20220503100051.2799723-4-frederic@kernel.org/
> > > > > 
> > > > > I see, could we mark it at least with notrace meanwhile?
> > > > 
> > > > For the RCU part, how about as follows?
> > > > 
> > > > If this approach is reasonable, my guess would be that Frederic will pull
> > > > it into his context-tracking series, perhaps using a revert of this patch
> > > > to maintain sanity in the near term.
> > > > 
> > > > If this approach is unreasonable, well, that is Murphy for you!
> > > 
> > > I checked and it works in my test ;-)
> > 
> > Whew!!!  One piece of the problem might be solved, then.  ;-)
> > 
> > > > For the x86 idle part, my feeling is still that the rcu_idle_enter()
> > > > and rcu_idle_exit() need to be pushed deeper into the code.  Perhaps
> > > > an ongoing process as the idle loop continues to be dug deeper?
> > > 
> > > for arch_cpu_idle with noinstr I'm getting this W=1 warning:
> > > 
> > > vmlinux.o: warning: objtool: arch_cpu_idle()+0xb: call to {dynamic}() leaves .noinstr.text section
> > > 
> > > we could have it with notrace if that's a problem
> > 
> > I would be happy to queue the arch_cpu_idle() portion of your patch on
> > -rcu, if that would move things forward.  I suspect that additional
> > x86_idle() surgery is required, but maybe I am just getting confused
> > about what the x86_idle() function pointer can point to.  But it looks
> > to me like these need further help:
> > 
> > o	static void amd_e400_idle(void)
> > 	Plus things it calls, like tick_broadcast_enter() and
> > 	tick_broadcast_exit().
> > 
> > o	static __cpuidle void mwait_idle(void)
> > 
> > So it might not be all that much additional work, even if I have avoided
> > confusion about what the x86_idle() function pointer can point to.  But
> > I do not trust my ability to test this accurately.
> 
> same here ;-) you're right, there will be other places based
> on x86_idle function pointer.. I'll check it, but perhaps we
> could address that when someone reports that
> 
> jirka

Any thoughts on the correct approach?  One extreme would be to
mark all sorts of things noinstr.  Another extreme would be to
enclose all sorts of things in RCU_NONIDLE().  Yet another extreme
would be to push the rcu_idle_enter() and rcu_idle_exit() calls
still deeper into the idle loop.

Or does Peter's recent series somehow cover all of this?

https://lore.kernel.org/all/20220519212750.656413111@infradead.org/

							Thanx, Paul
