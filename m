Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEF052C843
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiESAAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiESAA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BECBA443;
        Wed, 18 May 2022 17:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E6BDB821A0;
        Thu, 19 May 2022 00:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35ADC385A9;
        Thu, 19 May 2022 00:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652918426;
        bh=UJDjyjdzJqFlsW+gZGyIlrnGpTTEXVykogO9NpO8GSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZDyT9+VweRaKpvQzDQcdDwZvvGOP9AJ/iYyLTzBQYbYX4thh2d9uTI/Z+SLGY5L/n
         qsPsewTWZI9TvWUgzSL7Ev5t2s12Bc/c8P4VbHBNgf2PIfrprC710OCCSLk0e/FMxF
         IAWC/4Y+q85nKQlyLA5/8j3aXJUrFg6jduAQUAVT62cEf3JtsxgZMKXyaP3SHu/az8
         P3x/MTOrPi9BUlcZjmwS78UQoK17ALBH47vL1mUwTSx0trXghcJrqmqe0zzetF07AT
         jzB2uavtwPyMhP8VEMHT2u9E1qfonCneVuFnJNZNRVVsWd6+9MoJpAL27ahfyLn8Xn
         hndLL75AC6BFQ==
Date:   Thu, 19 May 2022 09:00:20 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf-next 1/2] cpuidle/rcu: Making arch_cpu_idle and
 rcu_idle_exit noinstr
Message-Id: <20220519090020.828c697fcf4767722d02bc1a@kernel.org>
In-Reply-To: <YoNTjXBDLQe9xj27@krava>
References: <20220515203653.4039075-1-jolsa@kernel.org>
        <5b4bd044-ba88-649b-9b85-e08e175691f9@fb.com>
        <YoNTjXBDLQe9xj27@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 09:49:33 +0200
Jiri Olsa <olsajiri@gmail.com> wrote:

> On Mon, May 16, 2022 at 07:54:37PM -0700, Yonghong Song wrote:
> > 
> > 
> > On 5/15/22 1:36 PM, Jiri Olsa wrote:
> > > Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> > > in rcu 'not watching' context and if there's tracer attached to
> > > them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> > > warning like:
> > > 
> > >    [    3.017540] WARNING: suspicious RCU usage
> > >    ...
> > >    [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
> > >    [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
> > >    [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
> > >    [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
> > >    [    3.018371]  fprobe_handler.part.0+0xab/0x150
> > >    [    3.018374]  0xffffffffa00080c8
> > >    [    3.018393]  ? arch_cpu_idle+0x5/0x10
> > >    [    3.018398]  arch_cpu_idle+0x5/0x10
> > >    [    3.018399]  default_idle_call+0x59/0x90
> > >    [    3.018401]  do_idle+0x1c3/0x1d0
> > > 
> > > The call path is following:
> > > 
> > > default_idle_call
> > >    rcu_idle_enter
> > >    arch_cpu_idle
> > >    rcu_idle_exit
> > > 
> > > The arch_cpu_idle and rcu_idle_exit are the only ones from above
> > > path that are traceble and cause this problem on my setup.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >   arch/x86/kernel/process.c | 2 +-
> > >   kernel/rcu/tree.c         | 2 +-
> > >   2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> > > index b370767f5b19..1345cb0124a6 100644
> > > --- a/arch/x86/kernel/process.c
> > > +++ b/arch/x86/kernel/process.c
> > > @@ -720,7 +720,7 @@ void arch_cpu_idle_dead(void)
> > >   /*
> > >    * Called from the generic idle code.
> > >    */
> > > -void arch_cpu_idle(void)
> > > +void noinstr arch_cpu_idle(void)
> > 
> > noinstr includes a lot of attributes:
> > 
> > #define noinstr                                                         \
> >         noinline notrace __attribute((__section__(".noinstr.text")))    \
> >         __no_kcsan __no_sanitize_address __no_profile __no_sanitize_coverage
> > 
> > should we use notrace here?
> 
> hm right, so notrace should be enough for our case (kprobe_multi)
> which is based on ftrace/fprobe jump
> 
> noinstr (among other things) adds the function also the kprobes
> blacklist, which will prevent standard kprobes to attach
> 
> ASAICS standard kprobes use rcu in probe path as well, like in
> opt_pre_handler function
> 
> so I think we should go with noinstr

Yes, I agree that noinstr is preferrable for these functions.

Thank you!

> 
> jirka
> 
> > 
> > >   {
> > >   	x86_idle();
> > >   }
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index a4b8189455d5..20d529722f51 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -896,7 +896,7 @@ static void noinstr rcu_eqs_exit(bool user)
> > >    * If you add or remove a call to rcu_idle_exit(), be sure to test with
> > >    * CONFIG_RCU_EQS_DEBUG=y.
> > >    */
> > > -void rcu_idle_exit(void)
> > > +void noinstr rcu_idle_exit(void)
> > >   {
> > >   	unsigned long flags;


-- 
Masami Hiramatsu <mhiramat@kernel.org>
