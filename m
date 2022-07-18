Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED055578CF9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiGRVik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236370AbiGRVid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:38:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED33732DA0;
        Mon, 18 Jul 2022 14:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rVLafi1o5Yx4dEmDVl1W6TD+Wq81qe2gQS1q1eagFNg=; b=XNXz2eylmoKJZEcMgJYBDtZRWQ
        UgCNyujXA2CvqsLeKDNjCvm4l+VaJDREh5d21Sc6wixC5dZpvC+1I3/oOgK0earWPP0OdeHz5xLYl
        z4NZCeSNOuJq3k5DC8gpEa8gxFEx0weg8h1gAsSAY1Hsn7LtwY7FcmlgubkjJ5LEVI5fTGojrl89w
        gBR9kyMnPnVD4nOeqL+n9KMaHjEN4LgzSwYM6oSG/FDwLCYbWryCvl7pfi2yiIV14qRFPSQv9U0kA
        C4rDHWyeDBG9qtCG4IR4fF+qPLt4N5hUyIPfFJVl/MJaaoOB0/e/4qRFvObFXcMzqIW6vTA/E4ySz
        +Bbon1JQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYR1-00D3Lw-Va; Mon, 18 Jul 2022 21:37:48 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6DF1B9802A7; Mon, 18 Jul 2022 23:37:47 +0200 (CEST)
Date:   Mon, 18 Jul 2022 23:37:47 +0200
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
Subject: Re: [PATCH 15/16] sched/topology: optimize topology_span_sane()
Message-ID: <YtXSq3JyGLE4i8Gb@worktop.programming.kicks-ass.net>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-16-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-16-yury.norov@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:43PM -0700, Yury Norov wrote:

>  kernel/sched/topology.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 05b6c2ad90b9..ad32d0a43424 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2211,6 +2211,8 @@ static struct sched_domain *build_sched_domain(struct sched_domain_topology_leve
>  static bool topology_span_sane(struct sched_domain_topology_level *tl,
>  			      const struct cpumask *cpu_map, int cpu)
>  {
> +	const struct cpumask *mc = tl->mask(cpu);
> +	const struct cpumask *mi;
>  	int i;
>  
>  	/* NUMA levels are allowed to overlap */
> @@ -2226,14 +2228,18 @@ static bool topology_span_sane(struct sched_domain_topology_level *tl,
>  	for_each_cpu(i, cpu_map) {
>  		if (i == cpu)
>  			continue;
> +
> +		mi = tl->mask(i);
> +		if (mi == mc)
> +			continue;
> +
>  		/*
>  		 * We should 'and' all those masks with 'cpu_map' to exactly
>  		 * match the topology we're about to build, but that can only
>  		 * remove CPUs, which only lessens our ability to detect
>  		 * overlaps
>  		 */
> -		if (!cpumask_equal(tl->mask(cpu), tl->mask(i)) &&
> -		    cpumask_intersects(tl->mask(cpu), tl->mask(i)))
> +		if (!cpumask_equal(mc, mi) && cpumask_intersects(mc, mi))
>  			return false;
>  	}

This is once again a super slow path; but I don't suppose you're making
the code worse in this case.
