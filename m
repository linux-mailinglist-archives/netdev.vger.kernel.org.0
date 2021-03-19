Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6650F342308
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 18:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCSRKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 13:10:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231255AbhCSRKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 13:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616173842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/sa6iUivUj5f5FAzpisaekSjGBttiH0wPbrlUaQrAw=;
        b=aOyShYVG60ewrYC/iSJ/aMTl5+lOuNWZCfz4C3SVhdsMdMYwhD4K+8pDXMqV7QAXQk7jQQ
        aBnIqyQ2MwOs9T9gOQO0dwNDrMxJHTnEAfI/LOQ01yEUDQiQe6olTrHFSyIqZfMpUtrCA7
        b7M6/cETxuCwAA0zT3LXW8mWdV58jr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-o_vPnAStNH6yxplw1u0oNA-1; Fri, 19 Mar 2021 13:10:39 -0400
X-MC-Unique: o_vPnAStNH6yxplw1u0oNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0901B180FCB3;
        Fri, 19 Mar 2021 17:10:38 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 706455D9E3;
        Fri, 19 Mar 2021 17:10:32 +0000 (UTC)
Date:   Fri, 19 Mar 2021 18:10:31 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210319181031.44dd3113@carbon>
In-Reply-To: <20210314125231.GA3697@techsingularity.net>
References: <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
        <20210311084200.GR3697@techsingularity.net>
        <20210312124609.33d4d4ba@carbon>
        <20210312145814.GA2577561@casper.infradead.org>
        <20210312160350.GW3697@techsingularity.net>
        <20210312210823.GE2577561@casper.infradead.org>
        <20210313131648.GY3697@techsingularity.net>
        <20210313163949.GI2577561@casper.infradead.org>
        <7D8C62E1-77FD-4B41-90D7-253D13715A6F@oracle.com>
        <20210313193343.GJ2577561@casper.infradead.org>
        <20210314125231.GA3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Mar 2021 12:52:32 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> mm/page_alloc: Add an array-based interface to the bulk page allocator
> 
> The existing callers for the bulk allocator are storing the pages in
> arrays. This patch adds an array-based interface to the API to avoid
> multiple list iterations. The page list interface is preserved to
> avoid requiring all users of the bulk API to allocate and manage
> enough storage to store the pages.

I'm testing this patch, see results below and in commit[1].  The array
variant is clearly faster in these micro-benchmarks.
(Some comment inlined about code)

The change to my page_bench04_bulk is here[1]:
 [1] https://github.com/netoptimizer/prototype-kernel/commit/4c41fe0d4107f514

Notice these "per elem" measurements are alloc+free cost for order-0 pages.

BASELINE
 single_page alloc+put: 207 cycles(tsc) 57.773 ns

LIST variant: time_bulk_page_alloc_free_list: step=bulk size

 Per elem: 294 cycles(tsc) 81.866 ns (step:1)
 Per elem: 214 cycles(tsc) 59.477 ns (step:2)
 Per elem: 199 cycles(tsc) 55.504 ns (step:3)
 Per elem: 192 cycles(tsc) 53.489 ns (step:4)
 Per elem: 188 cycles(tsc) 52.456 ns (step:8)
 Per elem: 184 cycles(tsc) 51.346 ns (step:16)
 Per elem: 183 cycles(tsc) 50.883 ns (step:32)
 Per elem: 184 cycles(tsc) 51.236 ns (step:64)
 Per elem: 189 cycles(tsc) 52.620 ns (step:128)

ARRAY variant: time_bulk_page_alloc_free_array: step=bulk size

 Per elem: 195 cycles(tsc) 54.174 ns (step:1)
 Per elem: 123 cycles(tsc) 34.224 ns (step:2)
 Per elem: 113 cycles(tsc) 31.430 ns (step:3)
 Per elem: 108 cycles(tsc) 30.003 ns (step:4)
 Per elem: 102 cycles(tsc) 28.417 ns (step:8)
 Per elem:  98 cycles(tsc) 27.475 ns (step:16)
 Per elem:  96 cycles(tsc) 26.901 ns (step:32)
 Per elem:  95 cycles(tsc) 26.487 ns (step:64)
 Per elem:  94 cycles(tsc) 26.170 ns (step:128)

The array variant is clearly faster.

It it worth mentioning that bulk=1 result in fallback to normal
single page allocation via __alloc_pages().


> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 4a304fd39916..fb6234e1fe59 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -520,13 +520,20 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
>  
>  int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  				nodemask_t *nodemask, int nr_pages,
> -				struct list_head *list);
> +				struct list_head *page_list,
> +				struct page **page_array);
>  
>  /* Bulk allocate order-0 pages */
>  static inline unsigned long
> -alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
> +alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
>  {
> -	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
> +	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NULL);
> +}
> +
> +static inline unsigned long
> +alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
> +{
> +	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
>  }
>  
>  /*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e0c87c588d3..96590f0726c7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4965,13 +4965,20 @@ static inline bool prepare_alloc_pages(gfp_t gfp, unsigned int order,
>  
>  /*
>   * This is a batched version of the page allocator that attempts to
> - * allocate nr_pages quickly from the preferred zone and add them to list.
> + * allocate nr_pages quickly from the preferred zone. Pages are added
> + * to page_list if page_list is not NULL, otherwise it is assumed
> + * that the page_array is valid.
> + *
> + * If using page_array, only NULL elements are populated with pages.
> + * The caller must ensure that the array has enough NULL elements
> + * to store nr_pages or the buffer overruns.
>   *
>   * Returns the number of pages allocated.
>   */
>  int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  			nodemask_t *nodemask, int nr_pages,
> -			struct list_head *alloc_list)
> +			struct list_head *page_list,
> +			struct page **page_array)
>  {
>  	struct page *page;
>  	unsigned long flags;
> @@ -4987,6 +4994,9 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	if (WARN_ON_ONCE(nr_pages <= 0))
>  		return 0;
>  
> +	if (WARN_ON_ONCE(!page_list && !page_array))
> +		return 0;
> +
>  	if (nr_pages == 1)
>  		goto failed;
>  
> @@ -5035,7 +5045,24 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  			break;
>  		}
>  
> -		list_add(&page->lru, alloc_list);
> +		if (page_list) {
> +			/* New page prep is deferred */
> +			list_add(&page->lru, page_list);
> +		} else {
> +			/* Skip populated elements */
> +			while (*page_array)
> +				page_array++;

I don't like this approach as it is a dangerous construct, that can run
wild through the memory.  I have coded up another approach where I have
an nr_avail counter instead, that will "include" and count existing
elements in the array.

> +
> +			/*
> +			 * Array pages must be prepped immediately to
> +			 * avoid tracking which pages are new and
> +			 * which ones were already on the array.
> +			 */
> +			prep_new_page(page, 0, gfp, 0);
> +			*page_array = page;
> +			page_array++;
> +		}
> +
>  		allocated++;
>  	}
>  
> @@ -5044,9 +5071,12 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  
>  	local_irq_restore(flags);
>  
> -	/* Prep page with IRQs enabled to reduce disabled times */
> -	list_for_each_entry(page, alloc_list, lru)
> -		prep_new_page(page, 0, gfp, 0);
> +	/* Prep pages with IRQs enabled if using a list */
> +	if (page_list) {
> +		list_for_each_entry(page, page_list, lru) {
> +			prep_new_page(page, 0, gfp, 0);
> +		}
> +	}
>  
>  	return allocated;
>  
> @@ -5056,7 +5086,10 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  failed:
>  	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
>  	if (page) {
> -		list_add(&page->lru, alloc_list);
> +		if (page_list)
> +			list_add(&page->lru, page_list);
> +		else
> +			*page_array = page;
>  		allocated = 1;
>  	}
>  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

