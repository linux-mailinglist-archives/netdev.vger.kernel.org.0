Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF8578CB6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiGRV2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiGRV1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:27:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67832FFC2;
        Mon, 18 Jul 2022 14:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lSkv8nOF7z0qY9Il4gJSah6aT0EynXIpnmz3r7Nd3zY=; b=VzUCoQthtH6+JWXI+qC6/dm9sU
        e9VkL400c12o9AcDiovabduBPJZzKqkLZfdimO/F4yIEr5iP89pOkuBws2+TTwCI0XA9S+ri2MYOH
        iQwsce1cEC0SfvgKLAKdxvzsC4oQZXpxVP2qjS6q2qE5idAMTbIUR+e4XeR2d3HwUE0Gpoffjc7lE
        biZ0mnyUt9Ca8FMMtPr1yyOFp1njQv+GJCg+7ZJwuG3vBAyGq2yL8mza2zXnWaK7WBLHrcW+YwJsX
        yIAjSpKZtSRI5Z6E5VhdDvn34wNl1HtLT3EsgE4NYbyy1OfZK5vxvMygXZvng7SNR4QjP0msQdMtk
        1fMHlWwg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYGQ-004u7h-1o; Mon, 18 Jul 2022 21:26:50 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D5CEA9802A7; Mon, 18 Jul 2022 23:26:48 +0200 (CEST)
Date:   Mon, 18 Jul 2022 23:26:48 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 07/16] smp: optimize smp_call_function_many_cond()
Message-ID: <YtXQGMijINmEoiVi@worktop.programming.kicks-ass.net>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-8-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-8-yury.norov@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:35PM -0700, Yury Norov wrote:

> diff --git a/kernel/smp.c b/kernel/smp.c
> index dd215f439426..7ed2b9b12f74 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -880,6 +880,28 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
>  #define SCF_WAIT	(1U << 0)
>  #define SCF_RUN_LOCAL	(1U << 1)
>  
> +/* Check if we need remote execution, i.e., any CPU excluding this one. */
> +static inline bool __need_remote_exec(const struct cpumask *mask, unsigned int this_cpu)
> +{
> +	unsigned int cpu;
> +
> +	switch (num_online_cpus()) {
> +	case 0:
> +		return false;
> +	case 1:
> +		return cpu_online(this_cpu) ? false : true;
> +	default:
> +		if (mask == cpu_online_mask)
> +			return true;
> +	}
> +
> +	cpu = cpumask_first_and(mask, cpu_online_mask);
> +	if (cpu == this_cpu)
> +		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
> +
> +	return cpu < nr_cpu_ids;
> +}
> +
>  static void smp_call_function_many_cond(const struct cpumask *mask,
>  					smp_call_func_t func, void *info,
>  					unsigned int scf_flags,
> @@ -916,12 +938,7 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
>  	if ((scf_flags & SCF_RUN_LOCAL) && cpumask_test_cpu(this_cpu, mask))
>  		run_local = true;
>  
> -	/* Check if we need remote execution, i.e., any CPU excluding this one. */
> -	cpu = cpumask_first_and(mask, cpu_online_mask);
> -	if (cpu == this_cpu)
> -		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
> -	if (cpu < nr_cpu_ids)
> -		run_remote = true;
> +	run_remote = __need_remote_exec(mask, this_cpu);
>  
>  	if (run_remote) {
>  		cfd = this_cpu_ptr(&cfd_data);

This is more complex code for, very little to no gain. Why ?!
