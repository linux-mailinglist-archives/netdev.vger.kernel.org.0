Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EEB45625D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhKRSb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhKRSb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:31:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA4EC061574;
        Thu, 18 Nov 2021 10:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UCGFAyN0zv7BmvgMbZ8a6NXuqXMpc08vaAuAuuYNZ3E=; b=nAqKwmz1hZoHSImywwtdPT8n4z
        9wDjalsLWPzljDiy1432XFzhNjic7OD/+h7rzPosQITTyZUHl2b5FNY7CH0W87RH1JheEmY1fS7c1
        /qIAZPBqq/msG2s5aNLPHUD091NFO7lRxVujQDRWFzZ+fSnXpgmof2+Uqn1qy0yJ+HVjPT2LyKbH2
        PmvGxdvjyzZTrkuADBYe4vO6Qseaxrkrmit6qUcVhcxn07BmYX3mOhUVZ8pwW75Bn2K8m2SsHHb5h
        x1xtKGyEnWEe9npPW3EckNlxnsK8EvhREIKZBVEZDe7DIGdifb1pDpa/VptF/Xkt7BBIFvGpLD+5S
        vLGxyfww==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnm9K-008hwR-I9; Thu, 18 Nov 2021 18:28:43 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id CD8D99863CD; Thu, 18 Nov 2021 19:28:42 +0100 (CET)
Date:   Thu, 18 Nov 2021 19:28:42 +0100
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
Message-ID: <20211118182842.GJ174703@worktop.programming.kicks-ass.net>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
 <20211118075447.GG174703@worktop.programming.kicks-ass.net>
 <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 05:16:24PM +0000, Song Liu wrote:
> 
> 
> > On Nov 17, 2021, at 11:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > On Wed, Nov 17, 2021 at 11:57:12PM +0000, Song Liu wrote:
> > 
> >> I would agree that __text_poke() is a safer option. But in this case, we 
> >> will need the temporary hole to be 2MB in size. Also, we will probably 
> >> hold the temporary mapping for longer time (the whole JITing process). 
> >> Does this sound reasonable?
> > 
> > No :-)
> > 
> > Jit to a buffer, then copy the buffer into the 2M page using 4k aliases.
> > IIRC each program is still smaller than a single page, right? So at no
> > point do you need more than 2 pages mapped anyway.
> 
> JITing to a separate buffer adds complexity to the JIT process, as we 
> need to redo some offsets before the copy to match the final location of 
> the program. I don't have much experience with the JIT engine, so I am
> not very sure how much work it gonna be. 

You're going to have to do that anyway if you're going to write to the
directmap while executing from the alias.

> The BPF program could have up to 1000000 (BPF_COMPLEXITY_LIMIT_INSNS)
> instructions (BPF instructions). So it could easily go beyond a few 
> pages. Mapping the 2MB page all together should make the logic simpler. 

Then copy it in smaller chunks I suppose.
