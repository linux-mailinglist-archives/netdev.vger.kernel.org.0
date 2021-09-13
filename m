Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A64088F7
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbhIMK0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbhIMK0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:26:01 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7277BC061574;
        Mon, 13 Sep 2021 03:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=aTrEWPTgm+dIL/hGTC+DhKVRcNbUKDY/ngJtAI2gUPw=; b=HLuLa0Js2fe4rdc8ZDDfvF3dq3
        1VKI/tNmJlHv93Ku/PQwXaw/scNiXiGteqOOakxoEiSnqI507iMpxRkxPjmqmWNKynVHnJcQuNlTt
        qZgvtwSqjmHTYEin8jK1epP74aoQ4abDhWTBn7Jj3JHn9AnHNE5xGwv/7OI9rC02qUN8baaP5kl3W
        XbbaBsiRuTQbtbVaukpArL3JX5grPuFD2wWG2v2Q53cMjt/OfnZG+SQIbSsjGLaeAa8apMn5qgF+9
        hYQpZ/0Y0uCBCkGgy4gOwAVjWueS2qCHbQKWOK3rSsFh/27VNf4O//wPN2uSLGu5DUHv8y23ZBV3y
        3PPm7KsA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPj8U-002nk6-08; Mon, 13 Sep 2021 10:24:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BCE9E300047;
        Mon, 13 Sep 2021 12:24:24 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9842E2098BD0E; Mon, 13 Sep 2021 12:24:24 +0200 (CEST)
Date:   Mon, 13 Sep 2021 12:24:24 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
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
        <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: fix panic by mark recursion inside
 perf_log_throttle
Message-ID: <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 11:00:47AM +0800, 王贇 wrote:
> 
> 
> On 2021/9/10 下午11:38, Peter Zijlstra wrote:
> > On Thu, Sep 09, 2021 at 11:13:21AM +0800, 王贇 wrote:
> >> When running with ftrace function enabled, we observed panic
> >> as below:
> >>
> >>   traps: PANIC: double fault, error_code: 0x0
> >>   [snip]
> >>   RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
> >>   [snip]
> >>   Call Trace:
> >>    <NMI>
> >>    perf_trace_buf_alloc+0x26/0xd0
> >>    perf_ftrace_function_call+0x18f/0x2e0
> >>    kernelmode_fixup_or_oops+0x5/0x120
> >>    __bad_area_nosemaphore+0x1b8/0x280
> >>    do_user_addr_fault+0x410/0x920
> >>    exc_page_fault+0x92/0x300
> >>    asm_exc_page_fault+0x1e/0x30
> >>   RIP: 0010:__get_user_nocheck_8+0x6/0x13
> >>    perf_callchain_user+0x266/0x2f0
> >>    get_perf_callchain+0x194/0x210
> >>    perf_callchain+0xa3/0xc0
> >>    perf_prepare_sample+0xa5/0xa60
> >>    perf_event_output_forward+0x7b/0x1b0
> >>    __perf_event_overflow+0x67/0x120
> >>    perf_swevent_overflow+0xcb/0x110
> >>    perf_swevent_event+0xb0/0xf0
> >>    perf_tp_event+0x292/0x410
> >>    perf_trace_run_bpf_submit+0x87/0xc0
> >>    perf_trace_lock_acquire+0x12b/0x170
> >>    lock_acquire+0x1bf/0x2e0
> >>    perf_output_begin+0x70/0x4b0
> >>    perf_log_throttle+0xe2/0x1a0
> >>    perf_event_nmi_handler+0x30/0x50
> >>    nmi_handle+0xba/0x2a0
> >>    default_do_nmi+0x45/0xf0
> >>    exc_nmi+0x155/0x170
> >>    end_repeat_nmi+0x16/0x55
> > 
> > kernel/events/Makefile has:
> > 
> > ifdef CONFIG_FUNCTION_TRACER
> > CFLAGS_REMOVE_core.o = $(CC_FLAGS_FTRACE)
> > endif
> > 
> > Which, afaict, should avoid the above, no?
> 
> I'm afraid it's not working for this case, the
> start point of tracing is at lock_acquire() which
> is not from 'kernel/events/core', the following PF
> related function are also not from 'core', prevent
> ftrace on 'core' can't prevent this from happen...

I'm confused tho; where does the #DF come from? Because taking a #PF
from NMI should be perfectly fine.

AFAICT that callchain is something like:

	NMI
	  perf_event_nmi_handler()
	    (part of the chain is missing here)
	      perf_log_throttle()
	        perf_output_begin() /* events/ring_buffer.c */
		  rcu_read_lock()
		    rcu_lock_acquire()
		      lock_acquire()
		        trace_lock_acquire() --> perf_trace_foo

			  ...
			    perf_callchain()
			      perf_callchain_user()
			        #PF (fully expected during a userspace callchain)
				  (some stuff, until the first __fentry)
				    perf_trace_function_call
				      perf_trace_buf_alloc()
				        perf_swevent_get_recursion_context()
					  *BOOM*

Now, supposedly we then take another #PF from get_recursion_context() or
something, but that doesn't make sense. That should just work...

Can you figure out what's going wrong there? going with the RIP, this
almost looks like 'swhash->recursion' goes splat, but again that makes
no sense, that's a per-cpu variable.


