Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168E8528382
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbiEPLtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiEPLt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B2FDF8D;
        Mon, 16 May 2022 04:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A1660FFC;
        Mon, 16 May 2022 11:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5281AC385B8;
        Mon, 16 May 2022 11:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652701765;
        bh=1UjUf9qgR8mCHZ9pO5ibdXOTkA+2CnwKyYDerjjSjGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMkYxYwaD2K0qgkQWrvFjMbEes4kia98EUUVJ/06WXfRTmnyYFI3+clNVoLAQu0/F
         x+63icf6hFCM/xsO/+YqetIoB4x1gBd+Q0z+jkU58s/KBV5u+gOj1DguI8HjQPFHZJ
         vvpflzD8mQqRkZEtvS5uJxpZqREmSgXWpzXkSehLhvHWGXMoA0snQrvlWtBU+MRVd8
         Io7mXMB4rZKJVMePun91CFyq/qLWre8LzQ/Tr8EnQ5HwsN8K0vwCBskWRAyJi2LT75
         IWBDOZ/t+kz0pTa6dUeW24jK/LLmqV9hPJLuMxUa4YMiCFSYw1elIzxapFohDrxy+r
         75pBVqDXWPFjg==
Date:   Mon, 16 May 2022 13:49:22 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20220516114922.GA349949@lothringen>
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 09:25:35PM -0700, Paul E. McKenney wrote:
> On Sun, May 15, 2022 at 10:36:52PM +0200, Jiri Olsa wrote:
> > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > in rcu 'not watching' context and if there's tracer attached to
> > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > warning like:
> > 
> >   [    3.017540] WARNING: suspicious RCU usage
> >   ...
> >   [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> >   [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> >   [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> >   [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> >   [    3.018371]  fprobe_handler.part.0+0xab/0x150
> >   [    3.018374]  0xffffffffa00080c8
> >   [    3.018393]  ? arch_cpu_idle+0x5/0x10
> >   [    3.018398]  arch_cpu_idle+0x5/0x10
> >   [    3.018399]  default_idle_call+0x59/0x90
> >   [    3.018401]  do_idle+0x1c3/0x1d0
> > 
> > The call path is following:
> > 
> > default_idle_call
> >   rcu_idle_enter
> >   arch_cpu_idle
> >   rcu_idle_exit
> > 
> > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > path that are traceble and cause this problem on my setup.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> From an RCU viewpoint:
> 
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> 
> [ I considered asking for an instrumentation_on() in rcu_idle_exit(),
> but there is no point given that local_irq_restore() isn't something
> you instrument anyway. ]

So local_irq_save() in the beginning of rcu_idle_exit() is unsafe because
it is instrumentable by the function (graph)  tracers and the irqsoff tracer.

Also it calls into lockdep that might make use of RCU.

That's why rcu_idle_exit() is not noinstr yet. See this patch:

https://lore.kernel.org/lkml/20220503100051.2799723-4-frederic@kernel.org/

Thanks.

> 
> > ---
> >  arch/x86/kernel/process.c | 2 +-
> >  kernel/rcu/tree.c         | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> > index b370767f5b19..1345cb0124a6 100644
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -720,7 +720,7 @@ void arch_cpu_idle_dead(void)
> >  /*
> >   * Called from the generic idle code.
> >   */
> > -void arch_cpu_idle(void)
> > +void noinstr arch_cpu_idle(void)
> >  {
> >  	x86_idle();
> >  }
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index a4b8189455d5..20d529722f51 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -896,7 +896,7 @@ static void noinstr rcu_eqs_exit(bool user)
> >   * If you add or remove a call to rcu_idle_exit(), be sure to test with
> >   * CONFIG_RCU_EQS_DEBUG=y.
> >   */
> > -void rcu_idle_exit(void)
> > +void noinstr rcu_idle_exit(void)
> >  {
> >  	unsigned long flags;
> >  
> > -- 
> > 2.35.3
> > 
