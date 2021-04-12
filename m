Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5359335C48A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbhDLLAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 07:00:00 -0400
Received: from outbound-smtp14.blacknight.com ([46.22.139.231]:50957 "EHLO
        outbound-smtp14.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239697AbhDLK76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:59:58 -0400
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp14.blacknight.com (Postfix) with ESMTPS id C594B1C522A
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 11:59:39 +0100 (IST)
Received: (qmail 8089 invoked from network); 12 Apr 2021 10:59:39 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 12 Apr 2021 10:59:39 -0000
Date:   Mon, 12 Apr 2021 11:59:38 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210412105938.GU3697@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-3-mgorman@techsingularity.net>
 <28729c76-4e09-f860-0db1-9c79c8220683@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <28729c76-4e09-f860-0db1-9c79c8220683@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 12:21:42PM +0200, Vlastimil Babka wrote:
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 8a3e13277e22..eb547470a7e4 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -4965,6 +4965,124 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
> >  	return true;
> >  }
> >  
> > +/*
> > + * __alloc_pages_bulk - Allocate a number of order-0 pages to a list
> > + * @gfp: GFP flags for the allocation
> > + * @preferred_nid: The preferred NUMA node ID to allocate from
> > + * @nodemask: Set of nodes to allocate from, may be NULL
> > + * @nr_pages: The number of pages desired on the list
> > + * @page_list: List to store the allocated pages
> > + *
> > + * This is a batched version of the page allocator that attempts to
> > + * allocate nr_pages quickly and add them to a list.
> > + *
> > + * Returns the number of pages on the list.
> > + */
> > +int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> > +			nodemask_t *nodemask, int nr_pages,
> > +			struct list_head *page_list)
> > +{
> > +	struct page *page;
> > +	unsigned long flags;
> > +	struct zone *zone;
> > +	struct zoneref *z;
> > +	struct per_cpu_pages *pcp;
> > +	struct list_head *pcp_list;
> > +	struct alloc_context ac;
> > +	gfp_t alloc_gfp;
> > +	unsigned int alloc_flags;
> 
> Was going to complain that this is not set to ALLOC_WMARK_LOW. Must be faster
> next time...
> 

Good that you caught it anyway!

> > +	int allocated = 0;
> > +
> > +	if (WARN_ON_ONCE(nr_pages <= 0))
> > +		return 0;
> > +
> > +	/* Use the single page allocator for one page. */
> > +	if (nr_pages == 1)
> > +		goto failed;
> > +
> > +	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> 
> I don't understand this comment. Only alloc_flags_nofragment() sets this flag
> and we don't use it here?
> 

It's there as a reminder that there are non-obvious consequences
to ALLOC_NOFRAGMENT that may affect the bulk allocation success
rate. __rmqueue_fallback will only select pageblock_order pages and if that
fails, we fall into the slow path that allocates a single page. I didn't
deal with it because it was not obvious that it's even relevant but I bet
in 6 months time, I'll forget that ALLOC_NOFRAGMENT may affect success
rates without the comment. I'm waiting for a bug that can trivially trigger
a case with a meaningful workload where the success rate is poor enough to
affect latency before adding complexity. Ideally by then, the allocation
paths would be unified a bit better.

> > +	gfp &= gfp_allowed_mask;
> > +	alloc_gfp = gfp;
> > +	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
> > +		return 0;
> > +	gfp = alloc_gfp;
> > +
> > +	/* Find an allowed local zone that meets the high watermark. */
> 
> Should it say "low watermark"?
> 

Yeah, that's leftover from an earlier prototype :(

-- 
Mel Gorman
SUSE Labs
