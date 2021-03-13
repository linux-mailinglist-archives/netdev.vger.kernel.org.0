Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B10339E26
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 14:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhCMNRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 08:17:34 -0500
Received: from outbound-smtp16.blacknight.com ([46.22.139.233]:34583 "EHLO
        outbound-smtp16.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233643AbhCMNRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 08:17:16 -0500
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp16.blacknight.com (Postfix) with ESMTPS id 2721A1C5695
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:16:50 +0000 (GMT)
Received: (qmail 5083 invoked from network); 13 Mar 2021 13:16:49 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 13 Mar 2021 13:16:49 -0000
Date:   Sat, 13 Mar 2021 13:16:48 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210313131648.GY3697@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net>
 <20210312124609.33d4d4ba@carbon>
 <20210312145814.GA2577561@casper.infradead.org>
 <20210312160350.GW3697@techsingularity.net>
 <20210312210823.GE2577561@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210312210823.GE2577561@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 09:08:23PM +0000, Matthew Wilcox wrote:
> > > > The result of the API is to deliver pages as a double-linked list via
> > > > LRU (page->lru member).  If you are planning to use llist, then how to
> > > > handle this API change later?
> > > > 
> > > > Have you notice that the two users store the struct-page pointers in an
> > > > array?  We could have the caller provide the array to store struct-page
> > > > pointers, like we do with kmem_cache_alloc_bulk API.
> > > 
> > > My preference would be for a pagevec.  That does limit you to 15 pages
> > > per call [1], but I do think that might be enough.  And the overhead of
> > > manipulating a linked list isn't free.
> > > 
> > 
> > I'm opposed to a pagevec because it unnecessarily limits the caller.  The
> > sunrpc user for example knows how many pages it needs at the time the bulk
> > allocator is called but it's not the same value every time.  When tracing,
> > I found it sometimes requested 1 page (most common request actually) and
> > other times requested 200+ pages. Forcing it to call the batch allocator
> > in chunks of 15 means the caller incurs the cost of multiple allocation
> > requests which is almost as bad as calling __alloc_pages in a loop.
> 
> Well, no.  It reduces the cost by a factor of 15 -- or by 93%.  200 is
> an interesting example because putting 200 pages on a list costs 200 *
> 64 bytes of dirty cachelines, or 12KiB. 

That's a somewhat limited view. Yes, the overall cost gets reduced by
some factor but forcing the caller to limit the batch sizes incurs an
unnecessary cost. The SUNRPC user is particularly relevant as it cannot
make progress until it gets all the pages it requests -- it sleeps if
it cannot get the pages it needs. The whole point of the bulk allocator
is to avoid multiple round-trips through the page allocator. Forcing a
limit in the API requiring multiple round trips is just weird.

> That's larger than some CPU L1
> caches (mine's 48KB, 12-way set associative), but I think it's safe to say
> some of those 200 cache lines are going to force others out into L2 cache.
> Compared to a smaller batch of 15 pages in a pagevec, it'll dirty two cache
> lines (admittedly the 15 struct pages are also going to get dirtied by being
> allocated and then by being set up for whatever use they're getting, but
> they should stay in L1 cache while that's happening).
> 

The cache footprint is irrelevant if the caller *requires* the pages. If
the caller has to zero the pages then the cache gets thrashed anyway.
Even if non-temporal zeroing was used, the cache is likely thrashed by the
data copies. The page allocator in general is a cache nightmare because
of the number of cache lines it potentially dirties, particularly if it
has to call into the buddy allocator to split/merge pages for allocations
and frees respectively.

> I'm not claiming the pagevec is definitely a win, but it's very
> unclear which tradeoff is actually going to lead to better performance.
> Hopefully Jesper or Chuck can do some tests and figure out what actually
> works better with their hardware & usage patterns.
> 

The NFS user is often going to need to make round trips to get the pages it
needs. The pagevec would have to be copied into the target array meaning
it's not much better than a list manipulation.

Pagevecs are a bad interface in general simply because it puts hard
constraints on how many pages can be bulk allocatoed. Pagevecs are
primarily there to avoid excessive LRU lock acquisition and they are
bad at the job. These days, the LRU lock protects such a massive amount
of data that the pagevec is barely a band aid. Increasing its size just
shifts the problem slightly. I see very little value in introducing a
fundamental limitation into the bulk allocator by mandating pagevecs.

Now, I can see a case where the API moves to using arrays when there is a
user that is such a common hot path and using arrays that it is justified
but we're not there yet. The two callers are somewhat of corner cases and
both of them are limited by wire speed of networking. Not all users may
require arrays -- SLUB using batched order-0 pages on a high-allocation
failure for example would not need an array. Such an intensively hot user
does not currently exist so it's premature to even consider it.

> > I think the first version should have an easy API to start with. Optimise
> > the implementation if it is a bottleneck. Only make the API harder to
> > use if the callers are really willing to always allocate and size the
> > array in advance and it's shown that it really makes a big difference
> > performance-wise.
> 
> I'm not entirely sure that a pagevec is harder to use than a list_head.

Leaving aside the limitations of pagevecs, arrays get messy if the caller
does not necessarily use all the pages returned by the allocator. The
arrays would need to be tracked and/or preserved for some time. The
order pages are taken out of the array matters potentially. With lists,
the remaining pages can be easily spliced on a private cache or simply
handed back to the free API without having to track exactly how many
pages are on the array or where they are located. With arrays, the
elements have to be copied one at a time.

I think it's easier overall for the callers to deal with a list in
the initial implementation and only switch to arrays when there is an
extremely hot user that benefits heavily if pages are inserted directly
into an array.

-- 
Mel Gorman
SUSE Labs
