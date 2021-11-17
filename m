Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20345501A
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240932AbhKQWEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240955AbhKQWEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 17:04:49 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFBDC0613B9;
        Wed, 17 Nov 2021 14:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L3GGIZdD9hoVvIH8EBTTSSEtLrVfUIWllTDZ8pEqguE=; b=Oq9RtqYp++nfD+OUmXGmFF8b5Z
        cauxRRcafZhxgwvgebVpmtVH8kNQOM9239jT675AysaPMtCj68vC+Q6YU0b8oeWkuE7S3T2mmJx48
        cF+CF/0OKxHVYlNiPT5QN5jLqPjGuv2rvXPkudfedTcQCjlGHma+9ZqrLXwpyPxonH6cUjy749GiS
        Sp130h1/OhEUEdpDCQsWbV8EKOmuzNRC51DSjB6Vsa/oJvWZ9HGaTZGEsN3CeXVeo4BUX/lwgeCag
        ReqYR/stRGCwvmZLbIxbTNXiJZoIIPCd/pYyzSzIGtLza1D+lf37JgY9eUMWrLKimB7Wtxj1/AmiO
        XdiTlGxg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnSzl-00GZrB-9U; Wed, 17 Nov 2021 22:01:33 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id E19B1982234; Wed, 17 Nov 2021 23:01:32 +0100 (CET)
Date:   Wed, 17 Nov 2021 23:01:32 +0100
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
Message-ID: <20211117220132.GC174703@worktop.programming.kicks-ass.net>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 09:36:27PM +0000, Song Liu wrote:
> 
> 
> > On Nov 16, 2021, at 12:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > On Mon, Nov 15, 2021 at 11:13:42PM -0800, Song Liu wrote:
> >> These allow setting ro/x for module_alloc() mapping, while leave the
> >> linear mapping rw/nx.
> > 
> > This needs a very strong rationale for *why*. How does this not
> > trivially circumvent W^X ?
> 
> In this case, we want to have multiple BPF programs sharing the 2MB page. 
> When the JIT engine is working on one program, we would rather existing
> BPF programs on the same page stay on RO+X mapping (the module_alloc() 
> address). The solution in this version is to let the JIT engine write to 
> the page via linear address. 
> 
> An alternative is to only use the module_alloc() address, and flip the 
> read-only bit (of the whole 2MB page) back and forth. However, this 
> requires some serialization among different JIT jobs. 

Neither options seem acceptible to me as they both violate W^X.

Please have a close look at arch/x86/kernel/alternative.c:__text_poke()
for how we modify active text. I think that or something very similar is
the only option. By having an alias in a special (user) address space
that is not accessible by any other CPU, only the poking CPU can expoit
this (temporary) hole, which is a much larger ask than any of the
proposed options.

