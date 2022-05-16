Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1E527CDF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiEPEZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiEPEZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:25:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4948419002;
        Sun, 15 May 2022 21:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C958460EF1;
        Mon, 16 May 2022 04:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EB7C385AA;
        Mon, 16 May 2022 04:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652675136;
        bh=wkoCQQWOI/OVKH1UsJ9YAUTlpusbXlznvf72YaWzN7k=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=CLuSkDkWjDqJUtOB4cZDaMTD7Mb1pLfHh7tcgD9Rxe7Uql/SJYAZFQlBbff7rGA97
         QixQ0PcvXWBOek2r6CW++e2A7pQiAdnF48JwhR5GWROHk3Ti3mfs5kJlio9GO7evcK
         RbFKQXHH1qwaPS9lDtyF2BF+kCl/aCKCxBNW/+64QhMUpZEhNdyHXRzt1cw70f+gkI
         jZQdsupkXvCQ4tQXYeoEKObagASYqa5JPe34jpv5zJ4oYNqylSIchtnHNbwqR/Cxnk
         kPW+A/Zu+qwXM2WBjnKT0eIs1w3w3Mtlqeoav70v1rvy5Ku9khX49opmzcQkbrPw6h
         rjUj4++lTeEdA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id BBD275C0440; Sun, 15 May 2022 21:25:35 -0700 (PDT)
Date:   Sun, 15 May 2022 21:25:35 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20220516042535.GV1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220515203653.4039075-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515203653.4039075-1-jolsa@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 10:36:52PM +0200, Jiri Olsa wrote:
> Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> in rcu 'not watching' context and if there's tracer attached to
> them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> warning like:
> 
>   [    3.017540] WARNING: suspicious RCU usage
>   ...
>   [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
>   [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
>   [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
>   [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
>   [    3.018371]  fprobe_handler.part.0+0xab/0x150
>   [    3.018374]  0xffffffffa00080c8
>   [    3.018393]  ? arch_cpu_idle+0x5/0x10
>   [    3.018398]  arch_cpu_idle+0x5/0x10
>   [    3.018399]  default_idle_call+0x59/0x90
>   [    3.018401]  do_idle+0x1c3/0x1d0
> 
> The call path is following:
> 
> default_idle_call
>   rcu_idle_enter
>   arch_cpu_idle
>   rcu_idle_exit
> 
> The arch_cpu_idle and rcu_idle_exit are the only ones from above
> path that are traceble and cause this problem on my setup.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

From an RCU viewpoint:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

[ I considered asking for an instrumentation_on() in rcu_idle_exit(),
but there is no point given that local_irq_restore() isn't something
you instrument anyway. ]

> ---
>  arch/x86/kernel/process.c | 2 +-
>  kernel/rcu/tree.c         | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index b370767f5b19..1345cb0124a6 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -720,7 +720,7 @@ void arch_cpu_idle_dead(void)
>  /*
>   * Called from the generic idle code.
>   */
> -void arch_cpu_idle(void)
> +void noinstr arch_cpu_idle(void)
>  {
>  	x86_idle();
>  }
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index a4b8189455d5..20d529722f51 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -896,7 +896,7 @@ static void noinstr rcu_eqs_exit(bool user)
>   * If you add or remove a call to rcu_idle_exit(), be sure to test with
>   * CONFIG_RCU_EQS_DEBUG=y.
>   */
> -void rcu_idle_exit(void)
> +void noinstr rcu_idle_exit(void)
>  {
>  	unsigned long flags;
>  
> -- 
> 2.35.3
> 
