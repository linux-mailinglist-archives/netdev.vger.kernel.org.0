Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C752858F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243855AbiEPNjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243842AbiEPNjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:39:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A2D2ED60;
        Mon, 16 May 2022 06:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15F5EB81216;
        Mon, 16 May 2022 13:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB8EC341C5;
        Mon, 16 May 2022 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652708377;
        bh=CnGkjps7/dZIHE7FzRA5oAC3vT184hDzmq6duMtMPl4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=aGJSEkgXtPP0cdbxghB7KK1T9LA5HecxFsDwnK+Xe74PmhP3C2gsxturwLx6Ztwux
         KAn1LODgaoNXClcsmN8uVxKlKOG2ReVequ8h0ueoKDGGpoL9B7/tqOibsSGZPyzz8M
         pDagLNoD+z6rgb9YH4U65dtjwO2iqd3k3LTnTNV7tcwS4JJ6MhQ1weQXb83jih3oaI
         qmMXBCFU1Fh+NCBYbU/P1bfADi5Htowk0IHTdpOG8yXdLhFX7RCh1UmCXEaua3UuDY
         73C3JTaDQmIGNdJijhNeEOd+8KLdeDSX0j+8cZhrKAJw++JILQMWXywXRmOfdOAMP0
         x3TgtfWNu/FZw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id C78DA5C0744; Mon, 16 May 2022 06:39:36 -0700 (PDT)
Date:   Mon, 16 May 2022 06:39:36 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
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
Message-ID: <20220516133936.GW1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
 <20220516114922.GA349949@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516114922.GA349949@lothringen>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 01:49:22PM +0200, Frederic Weisbecker wrote:
> On Sun, May 15, 2022 at 09:25:35PM -0700, Paul E. McKenney wrote:
> > On Sun, May 15, 2022 at 10:36:52PM +0200, Jiri Olsa wrote:
> > > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > > in rcu 'not watching' context and if there's tracer attached to
> > > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > > warning like:
> > > 
> > >   [    3.017540] WARNING: suspicious RCU usage
> > >   ...
> > >   [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> > >   [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> > >   [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> > >   [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> > >   [    3.018371]  fprobe_handler.part.0+0xab/0x150
> > >   [    3.018374]  0xffffffffa00080c8
> > >   [    3.018393]  ? arch_cpu_idle+0x5/0x10
> > >   [    3.018398]  arch_cpu_idle+0x5/0x10
> > >   [    3.018399]  default_idle_call+0x59/0x90
> > >   [    3.018401]  do_idle+0x1c3/0x1d0
> > > 
> > > The call path is following:
> > > 
> > > default_idle_call
> > >   rcu_idle_enter
> > >   arch_cpu_idle
> > >   rcu_idle_exit
> > > 
> > > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > > path that are traceble and cause this problem on my setup.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > 
> > From an RCU viewpoint:
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > [ I considered asking for an instrumentation_on() in rcu_idle_exit(),
> > but there is no point given that local_irq_restore() isn't something
> > you instrument anyway. ]
> 
> So local_irq_save() in the beginning of rcu_idle_exit() is unsafe because
> it is instrumentable by the function (graph)  tracers and the irqsoff tracer.
> 
> Also it calls into lockdep that might make use of RCU.
> 
> That's why rcu_idle_exit() is not noinstr yet. See this patch:
> 
> https://lore.kernel.org/lkml/20220503100051.2799723-4-frederic@kernel.org/

Ah, I should have looked at the context-tracking series again!

And I have to ask...  How much debugging capability are we really losing
by continuing to use the raw versions of local_irq_{save,restore}()?

							Thanx, Paul

> Thanks.
> 
> > 
> > > ---
> > >  arch/x86/kernel/process.c | 2 +-
> > >  kernel/rcu/tree.c         | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> > > index b370767f5b19..1345cb0124a6 100644
> > > --- a/arch/x86/kernel/process.c
> > > +++ b/arch/x86/kernel/process.c
> > > @@ -720,7 +720,7 @@ void arch_cpu_idle_dead(void)
> > >  /*
> > >   * Called from the generic idle code.
> > >   */
> > > -void arch_cpu_idle(void)
> > > +void noinstr arch_cpu_idle(void)
> > >  {
> > >  	x86_idle();
> > >  }
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index a4b8189455d5..20d529722f51 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -896,7 +896,7 @@ static void noinstr rcu_eqs_exit(bool user)
> > >   * If you add or remove a call to rcu_idle_exit(), be sure to test with
> > >   * CONFIG_RCU_EQS_DEBUG=y.
> > >   */
> > > -void rcu_idle_exit(void)
> > > +void noinstr rcu_idle_exit(void)
> > >  {
> > >  	unsigned long flags;
> > >  
> > > -- 
> > > 2.35.3
> > > 
