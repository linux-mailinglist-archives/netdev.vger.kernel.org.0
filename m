Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FA140F019
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 05:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243339AbhIQDDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 23:03:45 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:62115 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231556AbhIQDDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 23:03:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0UodiUsp_1631847727;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UodiUsp_1631847727)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 17 Sep 2021 11:02:08 +0800
Subject: Re: [PATCH] x86/dumpstack/64: Add guard pages to stack_info
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-perf-users@vger.kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, jroedel@suse.de, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
 <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
 <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
 <76de02b7-4d87-4a3a-e4d4-048829749887@linux.alibaba.com>
 <YUL5j/lY0mtx4NMq@hirez.programming.kicks-ass.net>
 <YUL6R5AH6WNxu5sH@hirez.programming.kicks-ass.net>
 <YUMWLdijs8vSkRjo@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <a11f43d2-f12e-18c2-65d4-debd8d085fa8@linux.alibaba.com>
Date:   Fri, 17 Sep 2021 11:02:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUMWLdijs8vSkRjo@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/16 下午6:02, Peter Zijlstra wrote:
[snip]
>  
> +static __always_inline bool in_stack_guard(void *addr, void *begin, void *end)
> +{
> +#ifdef CONFIG_VMAP_STACK
> +	if (addr > (begin - PAGE_SIZE))
> +		return true;

After fix this logical as:

  addr >= (begin - PAGE_SIZE) && addr < begin

it's working.

Regards,
Michael Wang

> +#endif
> +	return false;
> +}
[snip]
>  
>  #ifdef CONFIG_X86_ESPFIX64
> @@ -455,9 +456,11 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
>  	 * stack even if the actual trigger for the double fault was
>  	 * something else.
>  	 */
> -	if ((unsigned long)task_stack_page(tsk) - 1 - address < PAGE_SIZE) {
> -		handle_stack_overflow("kernel stack overflow (double-fault)",
> -				      regs, address);
> +	if (get_stack_info_noinstr((void *)address, current, &info) &&
> +	    info.type & STACK_TYPE_GUARD) {
> +		const char *name = stack_type_name(info.type & ~STACK_TYPE_GUARD);
> +		pr_emerg("BUG: %s stack guard hit at %p (stack is %p..%p)\n",
> +			 name, (void *)address, info.begin, info.end);
>  	}
>  #endif
>  
> @@ -708,7 +711,9 @@ asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *r
>  	sp    = regs->sp;
>  	stack = (unsigned long *)sp;
>  
> -	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
> +	if (!get_stack_info_noinstr(stack, current, &info) ||
> +	    info.type & STACK_TYPE_GUARD ||
> +	    info.type == STACK_TYPE_ENTRY ||
>  	    info.type >= STACK_TYPE_EXCEPTION_LAST)
>  		sp = __this_cpu_ist_top_va(VC2);
>  
> 
