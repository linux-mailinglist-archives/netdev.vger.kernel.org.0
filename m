Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEC735C3B3
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhDLKWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:22:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:48486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238727AbhDLKWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 06:22:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A9E95AFE2;
        Mon, 12 Apr 2021 10:21:42 +0000 (UTC)
Subject: Re: [PATCH 2/9] mm/page_alloc: Add a bulk page allocator
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-3-mgorman@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <28729c76-4e09-f860-0db1-9c79c8220683@suse.cz>
Date:   Mon, 12 Apr 2021 12:21:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325114228.27719-3-mgorman@techsingularity.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/21 12:42 PM, Mel Gorman wrote:
> This patch adds a new page allocator interface via alloc_pages_bulk,
> and __alloc_pages_bulk_nodemask. A caller requests a number of pages
> to be allocated and added to a list.
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
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/gfp.h |  11 +++++
>  mm/page_alloc.c     | 118 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 129 insertions(+)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 0a88f84b08f4..4a304fd39916 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -518,6 +518,17 @@ static inline int arch_make_page_accessible(struct page *page)
>  struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
>  		nodemask_t *nodemask);
>  
> +int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> +				nodemask_t *nodemask, int nr_pages,
> +				struct list_head *list);
> +
> +/* Bulk allocate order-0 pages */
> +static inline unsigned long
> +alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
> +{
> +	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
> +}
> +
>  /*
>   * Allocate pages, preferring the node given as nid. The node must be valid and
>   * online. For more general interface, see alloc_pages_node().
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8a3e13277e22..eb547470a7e4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4965,6 +4965,124 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  	return true;
>  }
>  
> +/*
> + * __alloc_pages_bulk - Allocate a number of order-0 pages to a list
> + * @gfp: GFP flags for the allocation
> + * @preferred_nid: The preferred NUMA node ID to allocate from
> + * @nodemask: Set of nodes to allocate from, may be NULL
> + * @nr_pages: The number of pages desired on the list
> + * @page_list: List to store the allocated pages
> + *
> + * This is a batched version of the page allocator that attempts to
> + * allocate nr_pages quickly and add them to a list.
> + *
> + * Returns the number of pages on the list.
> + */
> +int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> +			nodemask_t *nodemask, int nr_pages,
> +			struct list_head *page_list)
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

Was going to complain that this is not set to ALLOC_WMARK_LOW. Must be faster
next time...

> +	int allocated = 0;
> +
> +	if (WARN_ON_ONCE(nr_pages <= 0))
> +		return 0;
> +
> +	/* Use the single page allocator for one page. */
> +	if (nr_pages == 1)
> +		goto failed;
> +
> +	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */

I don't understand this comment. Only alloc_flags_nofragment() sets this flag
and we don't use it here?

> +	gfp &= gfp_allowed_mask;
> +	alloc_gfp = gfp;
> +	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
> +		return 0;
> +	gfp = alloc_gfp;
> +
> +	/* Find an allowed local zone that meets the high watermark. */

Should it say "low watermark"?

Vlastimil
