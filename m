Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955F4456C6A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 10:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhKSJjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 04:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbhKSJjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 04:39:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71FEC061574;
        Fri, 19 Nov 2021 01:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rkun0sbnP7VFSRg/d6zx8cUxlpl7Ei5gC86AdbCjEY0=; b=L4MFt1yY3z1LXSR9jSk5diDnTs
        aZXyN+ewItOQcsIuqJTHyLZsi75LsSpVWrXXpbnSw3iQT6gcMVAmqY3ROfmVqvaLWYL3ZpHdSxFTc
        s4Oce8yyhJAKYU8vXntnR0PrPdTxufCURJsDKfGolQetsXzRkWaEvcPFQnW96pZiRg/lhZVabl+IZ
        82UoynNIFMf/CeroXjC/oNVV2yZP+RdPfRxSVfq/9ce915TqlRNQR1+2ZuXVpoOa/hoU8kbJd8jfv
        CHAa+OqxmvIVPYSjPHoF6+WVbGtjCGKM1aguQ3vMxD7PToK0zv4CbJKlpFV01yuax4yPmP70k63qK
        eAz1o16A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo0JJ-009NGM-7I; Fri, 19 Nov 2021 09:35:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2393A300130;
        Fri, 19 Nov 2021 10:35:56 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CA6B12C74E0CC; Fri, 19 Nov 2021 10:35:56 +0100 (CET)
Date:   Fri, 19 Nov 2021 10:35:56 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Message-ID: <YZdv/NLUU9qLHP2g@hirez.programming.kicks-ass.net>
References: <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
 <20211118075447.GG174703@worktop.programming.kicks-ass.net>
 <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
 <20211118182842.GJ174703@worktop.programming.kicks-ass.net>
 <510E6FAA-0485-4786-87AA-DF2CEE0C4903@fb.com>
 <20211118185854.GL174703@worktop.programming.kicks-ass.net>
 <7DFF8615-6DEF-4CE6-8353-0AF48C204A84@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7DFF8615-6DEF-4CE6-8353-0AF48C204A84@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 04:14:46AM +0000, Song Liu wrote:
> 
> 
> > On Nov 18, 2021, at 10:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > On Thu, Nov 18, 2021 at 06:39:49PM +0000, Song Liu wrote:
> > 
> >>> You're going to have to do that anyway if you're going to write to the
> >>> directmap while executing from the alias.
> >> 
> >> Not really. If you look at current version 7/7, the logic is mostly 
> >> straightforward. We just make all the writes to the directmap, while 
> >> calculate offset from the alias. 
> > 
> > Then you can do the exact same thing but do the writes to a temp buffer,
> > no different.
> 
> There will be some extra work, but I guess I will give it a try. 
> 
> > 
> >>>> The BPF program could have up to 1000000 (BPF_COMPLEXITY_LIMIT_INSNS)
> >>>> instructions (BPF instructions). So it could easily go beyond a few 
> >>>> pages. Mapping the 2MB page all together should make the logic simpler. 
> >>> 
> >>> Then copy it in smaller chunks I suppose.
> >> 
> >> How fast/slow is the __text_poke routine? I guess we cannot do it thousands
> >> of times per BPF program (in chunks of a few bytes)? 
> > 
> > You can copy in at least 4k chunks since any 4k will at most use 2
> > pages, which is what it does. If that's not fast enough we can look at
> > doing bigger chunks.
> 
> If we do JIT in a buffer first, 4kB chunks should be fast enough. 
> 
> Another side of this issue is the split of linear mapping (1GB => 
> many 4kB). If we only split to PMD, but not PTE, we can probably 
> recover most of the regression. I will check this with Johannes. 

__text_poke() shouldn't affect the fragmentation of the kernel
mapping, it's a user-space alias into the same physical memory. For all
it cares we're poking into GB pages.
