Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1290342474
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhCSSSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:18:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:49058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhCSSSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 14:18:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 082F6AC23;
        Fri, 19 Mar 2021 18:18:33 +0000 (UTC)
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
 <20210312154331.32229-4-mgorman@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 3/7] mm/page_alloc: Add a bulk page allocator
Message-ID: <7c520bbb-efd7-7cad-95df-610000832a67@suse.cz>
Date:   Fri, 19 Mar 2021 19:18:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210312154331.32229-4-mgorman@techsingularity.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 4:43 PM, Mel Gorman wrote:
> This patch adds a new page allocator interface via alloc_pages_bulk,
> and __alloc_pages_bulk_nodemask. A caller requests a number of pages
> to be allocated and added to a list. They can be freed in bulk using
> free_pages_bulk().
> 
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
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Although maybe premature, if it changes significantly due to the users'
performance feedback, let's see :)

Some nits below:

...

> @@ -4963,6 +4978,107 @@ static inline bool prepare_alloc_pages(gfp_t gfp, unsigned int order,
>  	return true;
>  }
>  
> +/*
> + * This is a batched version of the page allocator that attempts to
> + * allocate nr_pages quickly from the preferred zone and add them to list.
> + *
> + * Returns the number of pages allocated.
> + */
> +int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
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
> +	gfp_t alloc_gfp;
> +	unsigned int alloc_flags;
> +	int allocated = 0;
> +
> +	if (WARN_ON_ONCE(nr_pages <= 0))
> +		return 0;
> +
> +	if (nr_pages == 1)
> +		goto failed;
> +
> +	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> +	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac,
> +	&alloc_gfp, &alloc_flags))

Unusual identation here.

> +		return 0;
> +	gfp = alloc_gfp;
> +
> +	/* Find an allowed local zone that meets the high watermark. */
> +	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
> +		unsigned long mark;
> +
> +		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> +		    !__cpuset_zone_allowed(zone, gfp)) {
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
> +				alloc_flags, gfp)) {
> +			break;
> +		}
> +	}
> +	if (!zone)
> +		return 0;

Why not also "goto failed;" here?
