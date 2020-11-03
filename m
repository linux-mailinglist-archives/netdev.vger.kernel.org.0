Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351B82A54F8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbgKCVPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388939AbgKCVPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:15:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4713EC0613D1;
        Tue,  3 Nov 2020 13:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2X3HWGtDj6jlwOT1IXppfSWqMfcMufTcQQ331/qkGHg=; b=l3BDfU3xmA76C+Sb3uNQqcqBkm
        FBLKthRSdsmvCo1MxCjwB7Z0Hw4P5e+J1a7/sLF+QLu0NDg658nwRVRjlZtbS5qkdTO5wV0lSjnGS
        9S2OyopuZladNzjreUI4SoV7s1ujZkkJxv55dfedwubyYdelDVieRej+I0JLhw9dsHIRA6lCDdK4Q
        zdTSoYDVFUhgJNsFJrLvPOc1RQWIXeTHILtjBMaHRgQNqP2oF1RAKrhgsUInxg2B8O2/7e27g+tZ9
        LMCz5QB2t3iNt1E44wL57MEqWyY7oGKrd3WZnXN+KSLHbLgZp919CEGz4g+RuXpvDVVZTML/r6FIR
        9J4dhvDA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ka3eX-0000C4-V4; Tue, 03 Nov 2020 21:15:42 +0000
Date:   Tue, 3 Nov 2020 21:15:41 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, aruna.ramakrishna@oracle.com,
        bert.barbe@oracle.com, rama.nichanamatlu@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
Message-ID: <20201103211541.GH27442@casper.infradead.org>
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
 <20201103203500.GG27442@casper.infradead.org>
 <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 12:57:33PM -0800, Dongli Zhang wrote:
> On 11/3/20 12:35 PM, Matthew Wilcox wrote:
> > On Tue, Nov 03, 2020 at 11:32:39AM -0800, Dongli Zhang wrote:
> >> However, once kernel is not under memory pressure any longer (suppose large
> >> amount of memory pages are just reclaimed), the page_frag_alloc() may still
> >> re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
> >> result, the skb->pfmemalloc is always true unless page_frag_cache->va is
> >> re-allocated, even the kernel is not under memory pressure any longer.
> >> +	/*
> >> +	 * Try to avoid re-using pfmemalloc page because kernel may already
> >> +	 * run out of the memory pressure situation at any time.
> >> +	 */
> >> +	if (unlikely(nc->va && nc->pfmemalloc)) {
> >> +		page = virt_to_page(nc->va);
> >> +		__page_frag_cache_drain(page, nc->pagecnt_bias);
> >> +		nc->va = NULL;
> >> +	}
> > 
> > I think this is the wrong way to solve this problem.  Instead, we should
> > use up this page, but refuse to recycle it.  How about something like this (not even compile tested):
> 
> Thank you very much for the feedback. Yes, the option is to use the same page
> until it is used up (offset < 0). Instead of recycling it, the kernel free it
> and allocate new one.
> 
> This depends on whether we will tolerate the packet drop until this page is used up.
> 
> For virtio-net, the payload (skb->data) is of size 128-byte. The padding and
> alignment will finally make it as 512-byte.
> 
> Therefore, for virtio-net, we will have at most 4096/512-1=7 packets dropped
> before the page is used up.

My thinking is that if the kernel is under memory pressure then freeing
the page and allocating a new one is likely to put even more strain
on the memory allocator, so we want to do this "soon", rather than at
each allocation.

Thanks for providing the numbers.  Do you think that dropping (up to)
7 packets is acceptable?

We could also do something like ...

        if (unlikely(nc->pfmemalloc)) {
                page = alloc_page(GFP_NOWAIT | __GFP_NOWARN);
                if (page)
                        nc->pfmemalloc = 0;
                put_page(page);
        }

to test if the memory allocator has free pages at the moment.  Not sure
whether that's a good idea or not -- hopefully you have a test environment
set up where you can reproduce this condition on demand and determine
which of these three approaches is best!
