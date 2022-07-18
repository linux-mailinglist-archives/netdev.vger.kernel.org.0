Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF665578CD5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiGRVga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiGRVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:36:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848422A42C;
        Mon, 18 Jul 2022 14:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b2+fqHm2d7st+up4McCVrJnq2E33gaO/uKbxkL5xitM=; b=FnaaKsRtymCNI9bTlQJE4Yfs7A
        6MmBBm2cnAvkBlHNWOOWv8sIFw018fF0xtnLmlOsf3VqMp3CQduwqgJwrKo1Y0A8R49pg8KR07Biy
        k7PBcOMcA1z6OS+yFTggRDgfQSc4V+k7Yp32yayvWFO18x2hCRJQIct/qBP0XDcyGgmnNqp6/xi3B
        rRpmB8OJJbiQ9o/tQXCQIFDSijX4oUEGwqn51hjy5bY2Mt2HxIVs0JJGPWQUQwuDt6+LmeFgCdoVU
        +2QPjphKTGv/mqSCkKRH7uGC8cN9NBEKcvGD1m9v2GVCznS2lFMFvG+oHCmB5gW+DV8G5a/4lTalj
        rjQ8tanA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYOy-00D3GZ-3i; Mon, 18 Jul 2022 21:35:40 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B85DF9802A7; Mon, 18 Jul 2022 23:35:39 +0200 (CEST)
Date:   Mon, 18 Jul 2022 23:35:39 +0200
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
Subject: Re: [PATCH 13/16] time: optimize tick_setup_device()
Message-ID: <YtXSK7qt+TuTRIbV@worktop.programming.kicks-ass.net>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-14-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-14-yury.norov@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:41PM -0700, Yury Norov wrote:
>  kernel/time/tick-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 7205f76f8d10..7b2da8ef09ef 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -255,7 +255,7 @@ static void tick_setup_device(struct tick_device *td,
>  	 * When the device is not per cpu, pin the interrupt to the
>  	 * current cpu:
>  	 */
> -	if (!cpumask_equal(newdev->cpumask, cpumask))
> +	if (newdev->cpumask != cpumask && !cpumask_equal(newdev->cpumask, cpumask))
>  		irq_set_affinity(newdev->irq, cpumask);

This is again making a slow path harder to read for now benefit.
