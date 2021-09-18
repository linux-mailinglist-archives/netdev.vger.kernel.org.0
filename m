Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA00A41048A
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 08:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbhIRG6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 02:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239917AbhIRG6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 02:58:35 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA31CC061574;
        Fri, 17 Sep 2021 23:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=zytGosLqW2wfFrKu1mAwI9TGDUzHhR58aTgQdttyjj4=; b=Kp2BSvBYJhKuJ7h7QA0bvkAiHt
        IL20N4owGPJjRZRAZWm9jhjGZU8sQ9M6qeYrO76hCse6aWskcRit9kbjWw05aX9y6Th4lPf6i7XVy
        gc+atN9/uXdLCWJlut//LpLu+VRz8naOutjvScNwNc7n8bqNBZu4KRWyR+85gGaOGSyetpa1p1fjV
        0RK/Arw3UddjT7gOPR65WcYv4ZUjkFuAruS/gqCgbvF78vcvnS33wIh8tH+5qevqHZGR5R5I70VBv
        bz7WPGwldoxoz2n93ojLv86JnowzXFCfLg2qqb16GmmIjSDsyp4v6aPJWxodcTyAqY/oxGmh7VcKz
        Ze/1gLOg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRUHL-0042Er-Ru; Sat, 18 Sep 2021 06:56:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id ED5B3300260;
        Sat, 18 Sep 2021 08:56:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B00082BDA5D63; Sat, 18 Sep 2021 08:56:50 +0200 (CEST)
Date:   Sat, 18 Sep 2021 08:56:50 +0200
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
        <bpf@vger.kernel.org>, jroedel@suse.de, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/dumpstack/64: Add guard pages to stack_info
Message-ID: <YUWNsu4BAFVVAqDo@hirez.programming.kicks-ass.net>
References: <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
 <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
 <76de02b7-4d87-4a3a-e4d4-048829749887@linux.alibaba.com>
 <YUL5j/lY0mtx4NMq@hirez.programming.kicks-ass.net>
 <YUL6R5AH6WNxu5sH@hirez.programming.kicks-ass.net>
 <YUMWLdijs8vSkRjo@hirez.programming.kicks-ass.net>
 <a11f43d2-f12e-18c2-65d4-debd8d085fa8@linux.alibaba.com>
 <YURsJGaB0vKgPT8x@hirez.programming.kicks-ass.net>
 <YUTE/NuqnaWbST8n@hirez.programming.kicks-ass.net>
 <89f8281f-b778-5bf5-13e0-2bda613d963c@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89f8281f-b778-5bf5-13e0-2bda613d963c@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 10:30:42AM +0800, 王贇 wrote:
> > Andy suggested something like this.
> 
> Now it seem like working well :-)

Thanks for sticking with it and testing all that over and over!

> [  193.100475][    C0] BUG: NMI stack guard page was hit at 0000000085fd977b (stack is 000000003a55b09e..00000000d8cce1a5)
> [  193.100493][    C0] stack guard page: 0000 [#1] SMP PTI
> [  193.100499][    C0] CPU: 0 PID: 968 Comm: a.out Not tainted 5.14.0-next-20210913+ #548
> [  193.100506][    C0] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  193.100510][    C0] RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
> [  193.100523][    C0] Code: 48 03 43 28 48 8b 0c 24 bb 01 00 00 00 4c 29 f0 48 39 c8 48 0f 47 c1 49 89 45 08 e9 48 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <55> 53 e8 09 20 f2 ff 48 c7 c2 20 4d 03 00 65 48 03 15 5a 3b d2 7e
> [  193.100529][    C0] RSP: 0018:fffffe000000b000 EFLAGS: 00010046
> [  193.100535][    C0] RAX: 0000000080120006 RBX: fffffe000000b050 RCX: 0000000000000000
> [  193.100540][    C0] RDX: ffff88810de82180 RSI: ffffffff81269031 RDI: 000000000000001c
> [  193.100544][    C0] RBP: 000000000000001c R08: 0000000000000001 R09: 0000000000000000
> [  193.100548][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  193.100551][    C0] R13: fffffe000000b044 R14: 0000000000000001 R15: 0000000000000009
> [  193.100556][    C0] FS:  00007fa18c42d740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> [  193.100562][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  193.100566][    C0] CR2: fffffe000000aff8 CR3: 00000001160ac005 CR4: 00000000003606f0
> [  193.100570][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  193.100574][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  193.100578][    C0] Call Trace:
> [  193.100581][    C0]  <NMI>
> [  193.100584][    C0]  perf_trace_buf_alloc+0x26/0xd0
> [  193.100597][    C0]  ? is_prefetch.isra.25+0x260/0x260
> [  193.100605][    C0]  ? __bad_area_nosemaphore+0x1b8/0x280
> [  193.100611][    C0]  perf_ftrace_function_call+0x18f/0x2e0
> 
> 
> Tested-by: Michael Wang <yun.wang@linux.alibaba.com>
> 
> BTW, would you like to apply the other patch which increasing exception
> stack size after this one?

Yes, I have that queued behind it :-)
