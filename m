Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02066578CBA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbiGRVaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiGRV3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:29:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660A929C85;
        Mon, 18 Jul 2022 14:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MAAgRXyGRUBm6HRgIN7nuvuw3aye3x5SdOQNP5jLmJs=; b=PAablPLLkltxvc9MCZh8AxhzJo
        96EgOIXX0Qr+GdNNwNtvi3qZ8/kAJaYXV27egcjzp4r6GUBxJ1SDanbq/Y/LuWaGkIRLxJ6uA7eNs
        eipDG7QRQS+zlV/x3Kp+ROrBIouY/vp/QCuwsthr69l1EFd9Jogq0tfS2VepaKg3qz7+tNsKNEWqR
        aIFouCVfb9fx84FGmKbo9yr23x4byXfrBHp9qH2wO4Ld3q4Zh6nI0IJ4T/IKIanZNVI97z2KKtfCB
        3bVL2y4Dl7lI0ZIVmG1EqVm5a+zBbGkuKTFIYk3tdchaVDNhUFVbFmNPeDVacoK/kWXJtxZcYX4Fe
        fvJoMeeA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYId-00D2zy-6h; Mon, 18 Jul 2022 21:29:07 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id C42009802A7; Mon, 18 Jul 2022 23:29:06 +0200 (CEST)
Date:   Mon, 18 Jul 2022 23:29:06 +0200
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
Subject: Re: [PATCH 08/16] smp: optimize smp_call_function_many_cond() for
 more
Message-ID: <YtXQom+a5C+iXSvm@worktop.programming.kicks-ass.net>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-9-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-9-yury.norov@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:36PM -0700, Yury Norov wrote:

> ---
>  kernel/smp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 7ed2b9b12f74..f96fdf944b4a 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -942,7 +942,11 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
>  
>  	if (run_remote) {
>  		cfd = this_cpu_ptr(&cfd_data);
> -		cpumask_and(cfd->cpumask, mask, cpu_online_mask);
> +		if (mask == cpu_online_mask)
> +			cpumask_copy(cfd->cpumask, cpu_online_mask);
> +		else
> +			cpumask_and(cfd->cpumask, mask, cpu_online_mask);
> +

Or... you could optimize cpumask_and() to detect the src1p == src2p case?

>  		__cpumask_clear_cpu(this_cpu, cfd->cpumask);
>  
>  		cpumask_clear(cfd->cpumask_ipi);
> -- 
> 2.34.1
> 
