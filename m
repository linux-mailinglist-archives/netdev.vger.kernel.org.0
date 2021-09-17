Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF0340F5CC
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242462AbhIQKXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbhIQKXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 06:23:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDCEC061574;
        Fri, 17 Sep 2021 03:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=tXuvGtUhPelbuiVZG2SNVQ8ZT1r2eKoLQS+KhKnonao=; b=PaRI/wYSpd33GMaNUg4dwwwk35
        9S41jv+5rzPsKoTxYZxGlyQAdrm6dO4hDxUUs3Vad29idB67/Eaa2y03aKl3S2n7QNINtwcBBriZl
        Y7eNE5PfDO6bvhKaGheKZDqmNM9fxxFeDHhK/iCv9MOEApKCWxQyFP8zpSBhmXkHJ4CExmJZMsQXA
        RRuyb537witKbV95bH/YRy3CmCGT7md1TknQPBBmZhVC+e9MHT4t2WzLUc8XE2W30BMG4DjknF1aC
        GR+YkplWVrACOzDKH1j7nnHCpYSA1m0rC4bZJQqrD6dhBD5G3n4J2FgqKOE8iBso0MTNh9jRCy7+5
        lLiuUbNw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRAzo-003qSp-Fs; Fri, 17 Sep 2021 10:21:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CD570300260;
        Fri, 17 Sep 2021 12:21:24 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B3FE92133B3D3; Fri, 17 Sep 2021 12:21:24 +0200 (CEST)
Date:   Fri, 17 Sep 2021 12:21:24 +0200
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
Message-ID: <YURsJGaB0vKgPT8x@hirez.programming.kicks-ass.net>
References: <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
 <3fb7c51f-696b-da70-1965-1dda9910cb14@linux.alibaba.com>
 <YUB5VchM3a/MiZpX@hirez.programming.kicks-ass.net>
 <3f26f7a2-0a09-056a-3a7a-4795b6723b60@linux.alibaba.com>
 <YUIOgmOfnOqPrE+z@hirez.programming.kicks-ass.net>
 <76de02b7-4d87-4a3a-e4d4-048829749887@linux.alibaba.com>
 <YUL5j/lY0mtx4NMq@hirez.programming.kicks-ass.net>
 <YUL6R5AH6WNxu5sH@hirez.programming.kicks-ass.net>
 <YUMWLdijs8vSkRjo@hirez.programming.kicks-ass.net>
 <a11f43d2-f12e-18c2-65d4-debd8d085fa8@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a11f43d2-f12e-18c2-65d4-debd8d085fa8@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 11:02:07AM +0800, 王贇 wrote:
> 
> 
> On 2021/9/16 下午6:02, Peter Zijlstra wrote:
> [snip]
> >  
> > +static __always_inline bool in_stack_guard(void *addr, void *begin, void *end)
> > +{
> > +#ifdef CONFIG_VMAP_STACK
> > +	if (addr > (begin - PAGE_SIZE))
> > +		return true;
> 
> After fix this logical as:
> 
>   addr >= (begin - PAGE_SIZE) && addr < begin
> 
> it's working.

Shees, I seem to have a knack for getting it wrong, don't I. Thanks!

Anyway, I'll ammend the commit locally, but I'd really like some
feedback from Andy, who wrote all that VIRT_STACK stuff in the first
place.
