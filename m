Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27018336E09
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhCKImT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:42:19 -0500
Received: from outbound-smtp27.blacknight.com ([81.17.249.195]:44784 "EHLO
        outbound-smtp27.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231584AbhCKImD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 03:42:03 -0500
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp27.blacknight.com (Postfix) with ESMTPS id 0F83ACB0F7
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:42:02 +0000 (GMT)
Received: (qmail 8019 invoked from network); 11 Mar 2021 08:42:01 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 11 Mar 2021 08:42:01 -0000
Date:   Thu, 11 Mar 2021 08:42:00 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210311084200.GR3697@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 03:46:50PM -0800, Andrew Morton wrote:
> On Wed, 10 Mar 2021 10:46:15 +0000 Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > This patch adds a new page allocator interface via alloc_pages_bulk,
> > and __alloc_pages_bulk_nodemask. A caller requests a number of pages
> > to be allocated and added to a list. They can be freed in bulk using
> > free_pages_bulk().
> 
> Why am I surprised we don't already have this.
> 

It was prototyped a few years ago and discussed at LSF/MM so it's in
the back of your memory somewhere. It never got merged because it lacked
users and I didn't think carrying dead untested code was appropriate.

> > The API is not guaranteed to return the requested number of pages and
> > may fail if the preferred allocation zone has limited free memory, the
> > cpuset changes during the allocation or page debugging decides to fail
> > an allocation. It's up to the caller to request more pages in batch
> > if necessary.
> > 
> > Note that this implementation is not very efficient and could be improved
> > but it would require refactoring. The intent is to make it available early
> > to determine what semantics are required by different callers. Once the
> > full semantics are nailed down, it can be refactored.
> > 
> > ...
> >
> > +/* Drop reference counts and free order-0 pages from a list. */
> > +void free_pages_bulk(struct list_head *list)
> > +{
> > +	struct page *page, *next;
> > +
> > +	list_for_each_entry_safe(page, next, list, lru) {
> > +		trace_mm_page_free_batched(page);
> > +		if (put_page_testzero(page)) {
> > +			list_del(&page->lru);
> > +			__free_pages_ok(page, 0, FPI_NONE);
> > +		}
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(free_pages_bulk);
> 
> I expect that batching games are planned in here as well?
> 

Potentially it could be done but the page allocator would need to be
fundamentally aware of batching to make it tidy or the per-cpu allocator
would need knowledge of how to handle batches in the free path.  Batch
freeing to the buddy allocator is problematic as buddy merging has to
happen. Batch freeing to per-cpu hits pcp->high limitations.

There are a couple of ways it *could* be done. Per-cpu lists could be
allowed to temporarily exceed the high limits and reduce them out-of-band
like what happens with counter updates or remote pcp freeing. Care
would need to be taken when memory is low to avoid premature OOM
and to guarantee draining happens in a timely fashion. There would be
additional benefits to this. For example, release_pages() can hammer the
zone lock when freeing very large batches and would benefit from either
large batching or "plugging" the per-cpu list. I prototyped a series to
allow the batch limits to be temporarily exceeded but it did not actually
improve performance because of errors in the implementation and it needs
a lot of work.

> >  static inline unsigned int
> >  gfp_to_alloc_flags(gfp_t gfp_mask)
> >  {
> > @@ -4919,6 +4934,9 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
> >  		struct alloc_context *ac, gfp_t *alloc_mask,
> >  		unsigned int *alloc_flags)
> >  {
> > +	gfp_mask &= gfp_allowed_mask;
> > +	*alloc_mask = gfp_mask;
> > +
> >  	ac->highest_zoneidx = gfp_zone(gfp_mask);
> >  	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
> >  	ac->nodemask = nodemask;
> > @@ -4960,6 +4978,99 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
> >  	return true;
> >  }
> >  
> > +/*
> > + * This is a batched version of the page allocator that attempts to
> > + * allocate nr_pages quickly from the preferred zone and add them to list.
> > + */
> 
> Documentation is rather lame.  Returns number of pages allocated...
> 

I added a note on the return value. The documentation is lame because at
this point, we do not know what the required semantics for future users
are. We have two examples at the moment in this series but I think it
would be better to add kerneldoc documentation when there is a reasonable
expectation that the API will not change. For example, SLUB could use
this API when it fails to allocate a high-order page and instead allocate
batches of order-0 pages but I did not investigate how feasible that
is. Similarly, it's possible that we really need to deal with high-order
batch allocations in which case, the per-cpu list should be high-order
aware or the core buddy allocator needs to be batch-allocation aware.

> > +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> > +			nodemask_t *nodemask, int nr_pages,
> > +			struct list_head *alloc_list)
> > +{
> > +	struct page *page;
> > +	unsigned long flags;
> > +	struct zone *zone;
> > +	struct zoneref *z;
> > +	struct per_cpu_pages *pcp;
> > +	struct list_head *pcp_list;
> > +	struct alloc_context ac;
> > +	gfp_t alloc_mask;
> > +	unsigned int alloc_flags;
> > +	int alloced = 0;
> > +
> > +	if (nr_pages == 1)
> > +		goto failed;
> > +
> > +	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> > +	if (!prepare_alloc_pages(gfp_mask, 0, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
> > +		return 0;
> > +	gfp_mask = alloc_mask;
> > +
> > +	/* Find an allowed local zone that meets the high watermark. */
> > +	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
> > +		unsigned long mark;
> > +
> > +		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> > +		    !__cpuset_zone_allowed(zone, gfp_mask)) {
> > +			continue;
> > +		}
> > +
> > +		if (nr_online_nodes > 1 && zone != ac.preferred_zoneref->zone &&
> > +		    zone_to_nid(zone) != zone_to_nid(ac.preferred_zoneref->zone)) {
> > +			goto failed;
> > +		}
> > +
> > +		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
> > +		if (zone_watermark_fast(zone, 0,  mark,
> > +				zonelist_zone_idx(ac.preferred_zoneref),
> > +				alloc_flags, gfp_mask)) {
> > +			break;
> > +		}
> > +	}
> 
> I suspect the above was stolen from elsewhere and that some code
> commonification is planned.
> 

It's based on get_page_from_freelist. It would be messy to have them share
common code at this point with a risk that the fast path for the common
path (single page requests) would be impaired. The issue is that the
fast path and slow paths have zonelist iteration, kswapd wakeup, cpuset
enforcement and reclaim actions all mixed together at various different
points. The locking is also mixed up with per-cpu list locking, statistic
locking and buddy locking all having inappropriate overlaps (e.g. IRQ
disabling protects per-cpu list locking, partially and unnecessarily
protects statistics depending on architecture and overlaps with the
IRQ-safe zone lock.

Ironing this out risks hurting the single page allocation path. It would
need to be done incrementally with ultimately the core of the allocator
dealing with batches to avoid false bisections.

> 
> > +	if (!zone)
> > +		return 0;
> > +
> > +	/* Attempt the batch allocation */
> > +	local_irq_save(flags);
> > +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> > +	pcp_list = &pcp->lists[ac.migratetype];
> > +
> > +	while (alloced < nr_pages) {
> > +		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> > +								pcp, pcp_list);
> > +		if (!page)
> > +			break;
> > +
> > +		prep_new_page(page, 0, gfp_mask, 0);
> 
> I wonder if it would be worth running prep_new_page() in a second pass,
> after reenabling interrupts.
> 

Possibly, I could add another patch on top that does this because it's
trading the time that IRQs are disabled for a list iteration.

> Speaking of which, will the realtime people get upset about the
> irqs-off latency?  How many pages are we talking about here?
> 

At the moment, it looks like batches of up to a few hundred at worst. I
don't think realtime sensitive applications are likely to be using the
bulk allocator API at this point.

The realtime people have a worse problem in that the per-cpu list does
not use local_lock and disable IRQs more than it needs to on x86 in
particular. I've a prototype series for this as well which splits the
locking for the per-cpu list and statistic handling and then converts the
per-cpu list to local_lock but I'm getting this off the table first because
I don't want multiple page allocator series in flight at the same time.
Thomas, Peter and Ingo would need to be cc'd on that series to review
the local_lock aspects.

Even with local_lock, it's not clear to me why per-cpu lists need to be
locked at all because potentially it could use a lock-free llist with some
struct page overloading. That one is harder to predict when batches are
taken into account as splicing a batch of free pages with llist would be
unsafe so batch free might exchange IRQ disabling overhead with multiple
atomics. I'd need to recheck things like whether NMI handlers ever call
the page allocator (they shouldn't but it should be checked).  It would
need a lot of review and testing.

> > +		list_add(&page->lru, alloc_list);
> > +		alloced++;
> > +	}
> > +
> > +	if (!alloced)
> > +		goto failed_irq;
> > +
> > +	if (alloced) {
> > +		__count_zid_vm_events(PGALLOC, zone_idx(zone), alloced);
> > +		zone_statistics(zone, zone);
> > +	}
> > +
> > +	local_irq_restore(flags);
> > +
> > +	return alloced;
> > +
> > +failed_irq:
> > +	local_irq_restore(flags);
> > +
> > +failed:
> 
> Might we need some counter to show how often this path happens?
> 

I think that would be overkill at this point. It only gives useful
information to a developer using the API for the first time and that can
be done with a debugging patch (or probes if you're feeling creative).
I'm already unhappy with the counter overhead in the page allocator.
zone_statistics in particular has no business being an accurate statistic.
It should have been a best-effort counter like vm_events that does not need
IRQs to be disabled. If that was a simply counter as opposed to an accurate
statistic then a failure counter at failed_irq would be very cheap to add.

-- 
Mel Gorman
SUSE Labs
