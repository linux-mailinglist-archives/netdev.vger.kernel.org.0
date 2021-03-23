Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07367346442
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhCWQAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:00:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232924AbhCWQAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616515222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ag6revSYuTWYgiFkSHVLZKeNOhSbXqduzMFpfyyQ8KU=;
        b=RUfIiHI7OhXECbxf9eC59a2Y01xW2UvIVgOe2XlsPpUruN1OMJjUHa8CCYjEyXwYq+PW/O
        S7ekSNk8cNz6L3rQcl7/r3+Dw03UY2SAN5wFKqLgN5wLPTwvi8geIxYJ1leUrjTnfrU5Hd
        04xDpDnRc+Wkmo3cBjKjWMsqypibhR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-9STvXw5dMGaqTJ0Ho9AYAg-1; Tue, 23 Mar 2021 12:00:18 -0400
X-MC-Unique: 9STvXw5dMGaqTJ0Ho9AYAg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FECF1013721;
        Tue, 23 Mar 2021 16:00:16 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E4A85D6AD;
        Tue, 23 Mar 2021 16:00:09 +0000 (UTC)
Date:   Tue, 23 Mar 2021 17:00:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 2/3] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210323170008.5d0732be@carbon>
In-Reply-To: <20210322091845.16437-3-mgorman@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
        <20210322091845.16437-3-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 09:18:44 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

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
>  include/linux/gfp.h |  11 ++++
>  mm/page_alloc.c     | 124 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 135 insertions(+)
[...]

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8a3e13277e22..3f4d56854c74 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4965,6 +4965,130 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  	return true;
>  }
>  
> +/*
> + * __alloc_pages_bulk - Allocate a number of order-0 pages to a list
> + * @gfp: GFP flags for the allocation
> + * @preferred_nid: The preferred NUMA node ID to allocate from
> + * @nodemask: Set of nodes to allocate from, may be NULL
> + * @nr_pages: The number of pages requested
> + * @page_list: List to store the allocated pages, must be empty
> + *
> + * This is a batched version of the page allocator that attempts to
> + * allocate nr_pages quickly and add them to a list. The list must be
> + * empty to allow new pages to be prepped with IRQs enabled.
> + *
> + * Returns the number of pages allocated.
> + */
> +int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> +			nodemask_t *nodemask, int nr_pages,
> +			struct list_head *page_list)
> +{
[...]
> +	/*
> +	 * If there are no allowed local zones that meets the watermarks then
> +	 * try to allocate a single page and reclaim if necessary.
> +	 */
> +	if (!zone)
> +		goto failed;
> +
> +	/* Attempt the batch allocation */
> +	local_irq_save(flags);
> +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> +	pcp_list = &pcp->lists[ac.migratetype];
> +
> +	while (allocated < nr_pages) {
> +		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> +								pcp, pcp_list);

The function __rmqueue_pcplist() is now used two places, this cause the
compiler to uninline the static function.

My tests show you should inline __rmqueue_pcplist().  See patch I'm
using below signature, which also have some benchmark notes. (Please
squash it into your patch and drop these notes).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[PATCH] mm: inline __rmqueue_pcplist

From: Jesper Dangaard Brouer <brouer@redhat.com>

When __alloc_pages_bulk() got introduced two callers of
__rmqueue_pcplist exist and the compiler chooses to not inline
this function.

 ./scripts/bloat-o-meter vmlinux-before vmlinux-inline__rmqueue_pcplist
add/remove: 0/1 grow/shrink: 2/0 up/down: 164/-125 (39)
Function                                     old     new   delta
rmqueue                                     2197    2296     +99
__alloc_pages_bulk                          1921    1986     +65
__rmqueue_pcplist                            125       -    -125
Total: Before=19374127, After=19374166, chg +0.00%

modprobe page_bench04_bulk loops=$((10**7))

Type:time_bulk_page_alloc_free_array
 -  Per elem: 106 cycles(tsc) 29.595 ns (step:64)
 - (measurement period time:0.295955434 sec time_interval:295955434)
 - (invoke count:10000000 tsc_interval:1065447105)

Before:
 - Per elem: 110 cycles(tsc) 30.633 ns (step:64)

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2cbb8da811ab..f60f51a97a7b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3415,7 +3415,8 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z)
 }
 
 /* Remove page from the per-cpu list, caller must protect the list */
-static struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
+static inline
+struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
 			struct list_head *list)

