Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D92333B23
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhCJLL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:11:59 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:25486 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhCJLLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615374711; x=1646910711;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=PrqnaKixzRwVMZgF18I7NsnIoh+7m+JQmlYK+RfHK24=;
  b=nAhY4FQqFYdaX0ZiPd+f3Hqoh+poZ5mE+6ap8vQyD4PMKdNlNWBWpZYc
   cWZINpa7Tznp4bmfKjcjF6EgYqSaleG8DKE2naRwYqc/fjEX/qS+PfE56
   hl1lbNCCmXZB/9qBaZnqEz35EmE0Vxa8+JGSDo1I6x1W0Z38XmK0SovxB
   8=;
X-IronPort-AV: E=Sophos;i="5.81,237,1610409600"; 
   d="scan'208";a="91717614"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Mar 2021 11:04:41 +0000
Received: from EX13D28EUB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id EBEC5A057A;
        Wed, 10 Mar 2021 11:04:39 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.67) by
 EX13D28EUB001.ant.amazon.com (10.43.166.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Mar 2021 11:04:34 +0000
References: <20210301161200.18852-1-mgorman@techsingularity.net>
 <20210301161200.18852-3-mgorman@techsingularity.net>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Mel Gorman <mgorman@techsingularity.net>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
In-Reply-To: <20210301161200.18852-3-mgorman@techsingularity.net>
Date:   Wed, 10 Mar 2021 13:04:17 +0200
Message-ID: <pj41zl7dmfnuby.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D03UWC004.ant.amazon.com (10.43.162.49) To
 EX13D28EUB001.ant.amazon.com (10.43.166.50)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Mel Gorman <mgorman@techsingularity.net> writes:

>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 8572a1474e16..4903d1cc48dc 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -515,6 +515,10 @@ static inline int 
> arch_make_page_accessible(struct page *page)
>  }
>  #endif
>  
> +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int 
> preferred_nid,
> +				nodemask_t *nodemask, int 
> nr_pages,
> +				struct list_head *list);
> +
>  struct page *
>  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int 
>  preferred_nid,
>  							nodemask_t 
>  *nodemask);
> @@ -525,6 +529,14 @@ __alloc_pages(gfp_t gfp_mask, unsigned int 
> order, int preferred_nid)
>  	return __alloc_pages_nodemask(gfp_mask, order, 
>  preferred_nid, NULL);
>  }
>  
> +/* Bulk allocate order-0 pages */
> +static inline unsigned long
> +alloc_pages_bulk(gfp_t gfp_mask, unsigned long nr_pages, struct 
> list_head *list)
> +{
> +	return __alloc_pages_bulk_nodemask(gfp_mask, 
> numa_mem_id(), NULL,
> +							nr_pages, 
> list);

Is the second line indentation intentional ? Why not align it to 
the first argument (gfp_mask) ?

> +}
> +
>  /*
>   * Allocate pages, preferring the node given as nid. The node 
>   must be valid and
>   * online. For more general interface, see alloc_pages_node().
> @@ -594,6 +606,7 @@ void * __meminit alloc_pages_exact_nid(int 
> nid, size_t size, gfp_t gfp_mask);
>  
>  extern void __free_pages(struct page *page, unsigned int 
>  order);
>  extern void free_pages(unsigned long addr, unsigned int order);
> +extern void free_pages_bulk(struct list_head *list);
>  
>  struct page_frag_cache;
>  extern void __page_frag_cache_drain(struct page *page, unsigned 
>  int count);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e4b29ee2b1e..ff1e55793786 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4436,6 +4436,21 @@ static void wake_all_kswapds(unsigned int 
> order, gfp_t gfp_mask,
>  	}
>  }
> ...
>  
> +/*
> + * This is a batched version of the page allocator that 
> attempts to
> + * allocate nr_pages quickly from the preferred zone and add 
> them to list.
> + */
> +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int 
> preferred_nid,
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

Does alloced count the number of allocated pages ? Do you mind 
renaming it to 'allocated' ?

> +
> +	if (nr_pages == 1)
> +		goto failed;
> +
> +	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 
> page. */
> +	if (!prepare_alloc_pages(gfp_mask, 0, preferred_nid, 
> nodemask, &ac, &alloc_mask, &alloc_flags))
> +		return 0;
> +	gfp_mask = alloc_mask;
> +
> +	/* Find an allowed local zone that meets the high 
> watermark. */
> +	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, 
> ac.highest_zoneidx, ac.nodemask) {
> +		unsigned long mark;
> +
> +		if (cpusets_enabled() && (alloc_flags & 
> ALLOC_CPUSET) &&
> +		    !__cpuset_zone_allowed(zone, gfp_mask)) {
> +			continue;
> +		}
> +
> +		if (nr_online_nodes > 1 && zone != 
> ac.preferred_zoneref->zone &&
> +		    zone_to_nid(zone) != 
> zone_to_nid(ac.preferred_zoneref->zone)) {
> +			goto failed;
> +		}
> +
> +		mark = wmark_pages(zone, alloc_flags & 
> ALLOC_WMARK_MASK) + nr_pages;
> +		if (zone_watermark_fast(zone, 0,  mark,
> + 
> zonelist_zone_idx(ac.preferred_zoneref),
> +				alloc_flags, gfp_mask)) {
> +			break;
> +		}
> +	}
> +	if (!zone)
> +		return 0;
> +
> +	/* Attempt the batch allocation */
> +	local_irq_save(flags);
> +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> +	pcp_list = &pcp->lists[ac.migratetype];
> +
> +	while (alloced < nr_pages) {
> +		page = __rmqueue_pcplist(zone, ac.migratetype, 
> alloc_flags,
> + 
> pcp, pcp_list);

Same indentation comment as before

> +		if (!page)
> +			break;
> +
> +		prep_new_page(page, 0, gfp_mask, 0);
> +		list_add(&page->lru, alloc_list);
> +		alloced++;
> +	}
> +
> +	if (!alloced)
> +		goto failed_irq;
> +
> +	if (alloced) {
> +		__count_zid_vm_events(PGALLOC, zone_idx(zone), 
> alloced);
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
> +	page = __alloc_pages_nodemask(gfp_mask, 0, preferred_nid, 
> nodemask);
> +	if (page) {
> +		alloced++;
> +		list_add(&page->lru, alloc_list);
> +	}
> +
> +	return alloced;
> +}
> +EXPORT_SYMBOL_GPL(__alloc_pages_bulk_nodemask);
> +
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
>   */
> @@ -4981,8 +5092,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, 
> unsigned int order, int preferred_nid,
>  		return NULL;
>  	}
>  
> -	gfp_mask &= gfp_allowed_mask;
> -	alloc_mask = gfp_mask;
>  	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, 
>  nodemask, &ac, &alloc_mask, &alloc_flags))
>  		return NULL;

