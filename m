Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C167E336807
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhCJXrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:47:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233911AbhCJXqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:46:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DAC64FBB;
        Wed, 10 Mar 2021 23:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615420010;
        bh=9pc0J7Hhnn2zZith2OcK/XuXjN69qorLbN2/lsooTwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fRjAwJgC9wZfjYUpN3+AiDhB9hPFgrzoComfXy6azpu6JME2L5Qbr+z6zYcOdt16v
         ITlQpS0z/EL6JFEg/wjS1Mh4zyimbakXSadnJt/tQyD0nXVXjpWQ9FBrH4vR6Un7D5
         m3qQKleieABhVb5+azfr4u1Y+J8cRriWvYnP4bBs=
Date:   Wed, 10 Mar 2021 15:46:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-Id: <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
In-Reply-To: <20210310104618.22750-3-mgorman@techsingularity.net>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
        <20210310104618.22750-3-mgorman@techsingularity.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Mar 2021 10:46:15 +0000 Mel Gorman <mgorman@techsingularity.net> wrote:

> This patch adds a new page allocator interface via alloc_pages_bulk,
> and __alloc_pages_bulk_nodemask. A caller requests a number of pages
> to be allocated and added to a list. They can be freed in bulk using
> free_pages_bulk().

Why am I surprised we don't already have this.

> The API is not guaranteed to return the requested number of pages and
> may fail if the preferred allocation zone has limited free memory, the
> cpuset changes during the allocation or page debugging decides to fail
> an allocation. It's up to the caller to request more pages in batch
> if necessary.
> 
> Note that this implementation is not very efficient and could be improved
> but it would require refactoring. The intent is to make it available early
> to determine what semantics are required by different callers. Once the
> full semantics are nailed down, it can be refactored.
> 
> ...
>
> +/* Drop reference counts and free order-0 pages from a list. */
> +void free_pages_bulk(struct list_head *list)
> +{
> +	struct page *page, *next;
> +
> +	list_for_each_entry_safe(page, next, list, lru) {
> +		trace_mm_page_free_batched(page);
> +		if (put_page_testzero(page)) {
> +			list_del(&page->lru);
> +			__free_pages_ok(page, 0, FPI_NONE);
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(free_pages_bulk);

I expect that batching games are planned in here as well?

>  static inline unsigned int
>  gfp_to_alloc_flags(gfp_t gfp_mask)
>  {
> @@ -4919,6 +4934,9 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  		struct alloc_context *ac, gfp_t *alloc_mask,
>  		unsigned int *alloc_flags)
>  {
> +	gfp_mask &= gfp_allowed_mask;
> +	*alloc_mask = gfp_mask;
> +
>  	ac->highest_zoneidx = gfp_zone(gfp_mask);
>  	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
>  	ac->nodemask = nodemask;
> @@ -4960,6 +4978,99 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  	return true;
>  }
>  
> +/*
> + * This is a batched version of the page allocator that attempts to
> + * allocate nr_pages quickly from the preferred zone and add them to list.
> + */

Documentation is rather lame.  Returns number of pages allocated...

> +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> +			nodemask_t *nodemask, int nr_pages,
> +			struct list_head *alloc_list)
> +{
> +	struct page *page;
> +	unsigned long flags;
> +	struct zone *zone;
> +	struct zoneref *z;
> +	struct per_cpu_pages *pcp;
> +	struct list_head *pcp_list;
> +	struct alloc_context ac;
> +	gfp_t alloc_mask;
> +	unsigned int alloc_flags;
> +	int alloced = 0;
> +
> +	if (nr_pages == 1)
> +		goto failed;
> +
> +	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> +	if (!prepare_alloc_pages(gfp_mask, 0, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
> +		return 0;
> +	gfp_mask = alloc_mask;
> +
> +	/* Find an allowed local zone that meets the high watermark. */
> +	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
> +		unsigned long mark;
> +
> +		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> +		    !__cpuset_zone_allowed(zone, gfp_mask)) {
> +			continue;
> +		}
> +
> +		if (nr_online_nodes > 1 && zone != ac.preferred_zoneref->zone &&
> +		    zone_to_nid(zone) != zone_to_nid(ac.preferred_zoneref->zone)) {
> +			goto failed;
> +		}
> +
> +		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
> +		if (zone_watermark_fast(zone, 0,  mark,
> +				zonelist_zone_idx(ac.preferred_zoneref),
> +				alloc_flags, gfp_mask)) {
> +			break;
> +		}
> +	}

I suspect the above was stolen from elsewhere and that some code
commonification is planned.


> +	if (!zone)
> +		return 0;
> +
> +	/* Attempt the batch allocation */
> +	local_irq_save(flags);
> +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> +	pcp_list = &pcp->lists[ac.migratetype];
> +
> +	while (alloced < nr_pages) {
> +		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> +								pcp, pcp_list);
> +		if (!page)
> +			break;
> +
> +		prep_new_page(page, 0, gfp_mask, 0);

I wonder if it would be worth running prep_new_page() in a second pass,
after reenabling interrupts.

Speaking of which, will the realtime people get upset about the
irqs-off latency?  How many pages are we talking about here?

> +		list_add(&page->lru, alloc_list);
> +		alloced++;
> +	}
> +
> +	if (!alloced)
> +		goto failed_irq;
> +
> +	if (alloced) {
> +		__count_zid_vm_events(PGALLOC, zone_idx(zone), alloced);
> +		zone_statistics(zone, zone);
> +	}
> +
> +	local_irq_restore(flags);
> +
> +	return alloced;
> +
> +failed_irq:
> +	local_irq_restore(flags);
> +
> +failed:

Might we need some counter to show how often this path happens?

> +	page = __alloc_pages_nodemask(gfp_mask, 0, preferred_nid, nodemask);
> +	if (page) {
> +		alloced++;
> +		list_add(&page->lru, alloc_list);
> +	}
> +
> +	return alloced;
> +}
> +EXPORT_SYMBOL_GPL(__alloc_pages_bulk_nodemask);
> +

