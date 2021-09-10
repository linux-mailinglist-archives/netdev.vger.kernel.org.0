Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58B5406E53
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhIJPkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbhIJPkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 11:40:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DDDC0613C1;
        Fri, 10 Sep 2021 08:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=beG8h/qzme+fTyiQhIuWR7Lf7uWlwUHjpcQJDRpcyHY=; b=RzOxiElj7RvGJsvpuwvBFOJxSH
        JvA723cw93ZhYz4BqLFZ5UiChcpd3271tdgSuwoIHjgjVQac3h0sX9KKijsN3andNdq3r3OKBuWni
        mQoUnbC2CkaUxu2RPKi/KfVvQ3JDNnvIlM3fadP1QGXjtHr3zKvqVzh6B51v3wc1m2l/gBjPyzqXK
        eSpXkntybGl0vmDeU7iQjRyRs0hPpKGio2D7vb0Ib5kGimJvSAgr8A6R0XnLe+BY4y0yz/kXHjgtW
        /DyW6KJpTaEHYFMHXMX5jHhgBdNtDKnKqodXfWo7bHCUreEo29yTheeMuJgsgvv1EBTQoAlQKvRQ2
        x0EOtq0A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOibw-002AHo-S3; Fri, 10 Sep 2021 15:38:41 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id DBA9F98627A; Fri, 10 Sep 2021 17:38:39 +0200 (CEST)
Date:   Fri, 10 Sep 2021 17:38:39 +0200
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
Message-ID: <20210910153839.GH4323@worktop.programming.kicks-ass.net>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 11:13:21AM +0800, 王贇 wrote:
> When running with ftrace function enabled, we observed panic
> as below:
> 
>   traps: PANIC: double fault, error_code: 0x0
>   [snip]
>   RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
>   [snip]
>   Call Trace:
>    <NMI>
>    perf_trace_buf_alloc+0x26/0xd0
>    perf_ftrace_function_call+0x18f/0x2e0
>    kernelmode_fixup_or_oops+0x5/0x120
>    __bad_area_nosemaphore+0x1b8/0x280
>    do_user_addr_fault+0x410/0x920
>    exc_page_fault+0x92/0x300
>    asm_exc_page_fault+0x1e/0x30
>   RIP: 0010:__get_user_nocheck_8+0x6/0x13
>    perf_callchain_user+0x266/0x2f0
>    get_perf_callchain+0x194/0x210
>    perf_callchain+0xa3/0xc0
>    perf_prepare_sample+0xa5/0xa60
>    perf_event_output_forward+0x7b/0x1b0
>    __perf_event_overflow+0x67/0x120
>    perf_swevent_overflow+0xcb/0x110
>    perf_swevent_event+0xb0/0xf0
>    perf_tp_event+0x292/0x410
>    perf_trace_run_bpf_submit+0x87/0xc0
>    perf_trace_lock_acquire+0x12b/0x170
>    lock_acquire+0x1bf/0x2e0
>    perf_output_begin+0x70/0x4b0
>    perf_log_throttle+0xe2/0x1a0
>    perf_event_nmi_handler+0x30/0x50
>    nmi_handle+0xba/0x2a0
>    default_do_nmi+0x45/0xf0
>    exc_nmi+0x155/0x170
>    end_repeat_nmi+0x16/0x55

kernel/events/Makefile has:

ifdef CONFIG_FUNCTION_TRACER
CFLAGS_REMOVE_core.o = $(CC_FLAGS_FTRACE)
endif

Which, afaict, should avoid the above, no?
