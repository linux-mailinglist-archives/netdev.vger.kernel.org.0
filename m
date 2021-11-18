Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE8456309
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhKRTCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhKRTCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 14:02:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2903DC061574;
        Thu, 18 Nov 2021 10:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ozx0+akoKQViR2Ug2+K47AlO2+aCNb2jFENfu5xXIrA=; b=q9T18QEVGPIhU0x5hFoPcA6cBS
        zx3vkuMNbyBZkWZ2+8qY+cYcSGeLuwYS9opQ3gbcRw8Ork68QV9acD9fvzXN6l0GWl3haFd4JEdEI
        KGsg1JcDzGYxCeNbfZWtkS0YJ5cI+rQvrPyee/ytoTH0Q+LJ7vrF4K0fQHAHWdx8S5q3k20b2yeN8
        1cfeQtWluw87gFcsGdYYyf7s8gAyGwcyJx+KkjPA+nesqtlvA4kWsoK3YuV6yN4RbFOIBvPTMTm3m
        1xpAtWTHRxmsqV5Jt6JPHhngdwARzHOs+gmWkkc8+6R0pmIwdaCrIzz12c5tAygj+EM+uGzyJc3mW
        nxcaVxNA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnmcY-008jLD-EA; Thu, 18 Nov 2021 18:58:55 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6800D9863CD; Thu, 18 Nov 2021 19:58:54 +0100 (CET)
Date:   Thu, 18 Nov 2021 19:58:54 +0100
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
Message-ID: <20211118185854.GL174703@worktop.programming.kicks-ass.net>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
 <20211118075447.GG174703@worktop.programming.kicks-ass.net>
 <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
 <20211118182842.GJ174703@worktop.programming.kicks-ass.net>
 <510E6FAA-0485-4786-87AA-DF2CEE0C4903@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510E6FAA-0485-4786-87AA-DF2CEE0C4903@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 06:39:49PM +0000, Song Liu wrote:

> > You're going to have to do that anyway if you're going to write to the
> > directmap while executing from the alias.
> 
> Not really. If you look at current version 7/7, the logic is mostly 
> straightforward. We just make all the writes to the directmap, while 
> calculate offset from the alias. 

Then you can do the exact same thing but do the writes to a temp buffer,
no different.

> >> The BPF program could have up to 1000000 (BPF_COMPLEXITY_LIMIT_INSNS)
> >> instructions (BPF instructions). So it could easily go beyond a few 
> >> pages. Mapping the 2MB page all together should make the logic simpler. 
> > 
> > Then copy it in smaller chunks I suppose.
> 
> How fast/slow is the __text_poke routine? I guess we cannot do it thousands
> of times per BPF program (in chunks of a few bytes)? 

You can copy in at least 4k chunks since any 4k will at most use 2
pages, which is what it does. If that's not fast enough we can look at
doing bigger chunks.
