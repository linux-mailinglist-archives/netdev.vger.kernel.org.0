Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFBD578CCC
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbiGRVey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiGRVes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:34:48 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B04629816;
        Mon, 18 Jul 2022 14:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4kJIbH62hRR2GU6oL7niOpMGvgJbkAuiAh8TauODeGM=; b=K9gd2aVQ80EFQckNHQ6cK380ZK
        HVgrEGAtEYMwNDZLuKmmQevAkIDX/Rq1tSG0sLKaWBx7R9CDlGFTrC8APy1nIgyjXqaVFhWJtcVoH
        6yNsLCNGec2r3gXm/c96Py1bHyc31J+alclZLvDbvGMZOIHp/5dOuaI3WVWP2F/aGih0poylZ07aS
        Nzd+bQ7i+rIXOf7cATAI8KFiWUr59wvMA0RfUXCITXgpygi1ngP55PglzHDfN/17HiNwChIFz3w5r
        5DXTj4z7OJuhu2uXxWsdvCVMCNu8MBj2/bTERB/1QqMCaS7vQjsJBG8n759a5rH45OzOSkqX0UrRr
        K9L0Iu0Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYNV-004uET-Nz; Mon, 18 Jul 2022 21:34:10 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id DBCF39802A7; Mon, 18 Jul 2022 23:34:08 +0200 (CEST)
Date:   Mon, 18 Jul 2022 23:34:08 +0200
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
Subject: Re: [PATCH 10/16] sched: optimize __set_cpus_allowed_ptr_locked()
Message-ID: <YtXR0D07MwoKN1ii@worktop.programming.kicks-ass.net>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-11-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-11-yury.norov@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:38PM -0700, Yury Norov wrote:
> ---
>  kernel/sched/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index da0bf6fe9ecd..d6424336ef2d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2874,7 +2874,8 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
>  		cpu_valid_mask = cpu_online_mask;
>  	}
>  
> -	if (!kthread && !cpumask_subset(new_mask, cpu_allowed_mask)) {
> +	if (!kthread && new_mask != cpu_allowed_mask &&
> +			!cpumask_subset(new_mask, cpu_allowed_mask)) {

Optimize cpumask_subset() for src1p == src2p instead?

>  		ret = -EINVAL;
>  		goto out;
>  	}
> -- 
> 2.34.1
> 
