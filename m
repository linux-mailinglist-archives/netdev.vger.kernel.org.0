Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B59340D43E
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 10:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhIPIFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 04:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbhIPIFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 04:05:05 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D206EC061764;
        Thu, 16 Sep 2021 01:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=fpa9ttX7CF1WZpIhVuTpbNvQaQpZawGIXndIWrx5+jI=; b=da246jrz6odDZwWz+BVZfJ4yVr
        kc2G1ZX29712svPo5vvsUWoJLZigW9CJuhX7+ms5NojlbOnq5+ioReV+ThkFGQoEUiN8dZYakN3vq
        ZuVIm6a4pv0BeeUNgMThsJE09igsaVqzNbXmskExLG2bsRAkirGVP1oF6sJvmjGjvKpGIb5fjIfhI
        HaJSE0EjAA7uNnvtbzAGlwnzOrZe+OSSytjVBZ3a5tXmk0HWZtLSfWQ4v582RlMKNMghoht4bUQW7
        0zj9WYRHhfc/6QWWSkx4HGKz4qVGhI5WpcmoaiV4S/vaoxJMyd2z8D+p8/LLITI15kT2+WfIfO0i7
        WEQgbzqQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQmMZ-003bgn-QM; Thu, 16 Sep 2021 08:03:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5C822300093;
        Thu, 16 Sep 2021 10:03:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4348E2CD48C44; Thu, 16 Sep 2021 10:03:19 +0200 (CEST)
Date:   Thu, 16 Sep 2021 10:03:19 +0200
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
        <bpf@vger.kernel.org>, jroedel@suse.de, x86@kernel.org
Subject: Re: [PATCH] x86/dumpstack/64: Add guard pages to stack_info
Message-ID: <YUL6R5AH6WNxu5sH@hirez.programming.kicks-ass.net>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
 <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
 <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
 <76de02b7-4d87-4a3a-e4d4-048829749887@linux.alibaba.com>
 <YUL5j/lY0mtx4NMq@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YUL5j/lY0mtx4NMq@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 10:00:15AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 16, 2021 at 11:47:49AM +0800, 王贇 wrote:
> 
> > I did some debug and found the issue, we are missing:
> > 
> > @@ -122,7 +137,10 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
> >         info->type      = ep->type;
> >         info->begin     = (unsigned long *)begin;
> >         info->end       = (unsigned long *)end;
> > -       info->next_sp   = (unsigned long *)regs->sp;
> > +
> > +       if (!(ep->type & STACK_TYPE_GUARD))
> > +               info->next_sp   = (unsigned long *)regs->sp;
> > +
> >         return true;
> >  }
> > 
> > as the guard page are not working as real stack I guess?
> 
> Correct, but I thought I put if (type & GUARD) terminators in all paths
> that ended up caring about ->next_sp. Clearly I seem to have missed one
> :/
> 
> Let me try and figure out where that happens.

Oh, I'm an idiot... yes it tries to read regs the stack, but clearly
that won't work for the guard page.
