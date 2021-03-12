Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB523398DC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhCLVIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbhCLVIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 16:08:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AA1C061574;
        Fri, 12 Mar 2021 13:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qeUU8gseO1+9GvKOOhLbMMDeusl5vJ4s6E+Z3Jay+5k=; b=jUk9D/Vgorg6jE/9pkqJ71pR3+
        CQLlU+KoRXWxd0N2u6MfZfpgeA7nODC5qb8MsoittFLBhdeTZYhceNOA2vkq4azcWTzKH8KMmoMdV
        jIYm7xWfCrZ8q/4el4onN9UH00wTIj10T2ajgiBaxDvRzEn/4ZzGH02T3+uuKK/O2Q3ldhauL//Sp
        bpv1veqprczJEXm8bXp64B/dJgqNreyYwKriT9OrtWSZP+8//Z+ZxXJk+0NHhxN1nlr1J92/o20N5
        1Cyu8e+66jB7GK/q0jZt8s/dLFftHoCqSj+63WgezbRRDz2nUmospOvxEZJCR0Vq0cc3f0+F/VMY2
        FRCXFvjw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKp1D-00Bmz5-Om; Fri, 12 Mar 2021 21:08:27 +0000
Date:   Fri, 12 Mar 2021 21:08:23 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312210823.GE2577561@casper.infradead.org>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net>
 <20210312124609.33d4d4ba@carbon>
 <20210312145814.GA2577561@casper.infradead.org>
 <20210312160350.GW3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312160350.GW3697@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 04:03:50PM +0000, Mel Gorman wrote:
> On Fri, Mar 12, 2021 at 02:58:14PM +0000, Matthew Wilcox wrote:
> > On Fri, Mar 12, 2021 at 12:46:09PM +0100, Jesper Dangaard Brouer wrote:
> > > In my page_pool patch I'm bulk allocating 64 pages. I wanted to ask if
> > > this is too much? (PP_ALLOC_CACHE_REFILL=64).
> > > 
> > > The mlx5 driver have a while loop for allocation 64 pages, which it
> > > used in this case, that is why 64 is chosen.  If we choose a lower
> > > bulk number, then the bulk-alloc will just be called more times.
> > 
> > The thing about batching is that smaller batches are often better.
> > Let's suppose you need to allocate 100 pages for something, and the page
> > allocator takes up 90% of your latency budget.  Batching just ten pages
> > at a time is going to reduce the overhead to 9%.  Going to 64 pages
> > reduces the overhead from 9% to 2% -- maybe that's important, but
> > possibly not.
> > 
> 
> I do not think that something like that can be properly accessed in
> advance. It heavily depends on whether the caller is willing to amortise
> the cost of the batch allocation or if the timing of the bulk request is
> critical every single time.
> 
> > > The result of the API is to deliver pages as a double-linked list via
> > > LRU (page->lru member).  If you are planning to use llist, then how to
> > > handle this API change later?
> > > 
> > > Have you notice that the two users store the struct-page pointers in an
> > > array?  We could have the caller provide the array to store struct-page
> > > pointers, like we do with kmem_cache_alloc_bulk API.
> > 
> > My preference would be for a pagevec.  That does limit you to 15 pages
> > per call [1], but I do think that might be enough.  And the overhead of
> > manipulating a linked list isn't free.
> > 
> 
> I'm opposed to a pagevec because it unnecessarily limits the caller.  The
> sunrpc user for example knows how many pages it needs at the time the bulk
> allocator is called but it's not the same value every time.  When tracing,
> I found it sometimes requested 1 page (most common request actually) and
> other times requested 200+ pages. Forcing it to call the batch allocator
> in chunks of 15 means the caller incurs the cost of multiple allocation
> requests which is almost as bad as calling __alloc_pages in a loop.

Well, no.  It reduces the cost by a factor of 15 -- or by 93%.  200 is
an interesting example because putting 200 pages on a list costs 200 *
64 bytes of dirty cachelines, or 12KiB.  That's larger than some CPU L1
caches (mine's 48KB, 12-way set associative), but I think it's safe to say
some of those 200 cache lines are going to force others out into L2 cache.
Compared to a smaller batch of 15 pages in a pagevec, it'll dirty two cache
lines (admittedly the 15 struct pages are also going to get dirtied by being
allocated and then by being set up for whatever use they're getting, but
they should stay in L1 cache while that's happening).

I'm not claiming the pagevec is definitely a win, but it's very
unclear which tradeoff is actually going to lead to better performance.
Hopefully Jesper or Chuck can do some tests and figure out what actually
works better with their hardware & usage patterns.

> I think the first version should have an easy API to start with. Optimise
> the implementation if it is a bottleneck. Only make the API harder to
> use if the callers are really willing to always allocate and size the
> array in advance and it's shown that it really makes a big difference
> performance-wise.

I'm not entirely sure that a pagevec is harder to use than a list_head.
