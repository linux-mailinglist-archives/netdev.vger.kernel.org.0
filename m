Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92905333B92
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhCJLkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:40:17 -0500
Received: from outbound-smtp33.blacknight.com ([81.17.249.66]:34204 "EHLO
        outbound-smtp33.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231161AbhCJLjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:39:10 -0500
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp33.blacknight.com (Postfix) with ESMTPS id 9F828BAC45
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:38:38 +0000 (GMT)
Received: (qmail 6934 invoked from network); 10 Mar 2021 11:38:37 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 10 Mar 2021 11:38:37 -0000
Date:   Wed, 10 Mar 2021 11:38:36 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210310113836.GQ3697@techsingularity.net>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
 <20210301161200.18852-3-mgorman@techsingularity.net>
 <pj41zl7dmfnuby.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <pj41zl7dmfnuby.fsf@u570694869fb251.ant.amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:04:17PM +0200, Shay Agroskin wrote:
> 
> Mel Gorman <mgorman@techsingularity.net> writes:
> 
> > 
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index 8572a1474e16..4903d1cc48dc 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -515,6 +515,10 @@ static inline int arch_make_page_accessible(struct
> > page *page)
> >  }
> >  #endif
> >   +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> > +				nodemask_t *nodemask, int nr_pages,
> > +				struct list_head *list);
> > +
> >  struct page *
> >  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int
> > preferred_nid,
> >  							nodemask_t  *nodemask);
> > @@ -525,6 +529,14 @@ __alloc_pages(gfp_t gfp_mask, unsigned int order,
> > int preferred_nid)
> >  	return __alloc_pages_nodemask(gfp_mask, order,  preferred_nid, NULL);
> >  }
> > +/* Bulk allocate order-0 pages */
> > +static inline unsigned long
> > +alloc_pages_bulk(gfp_t gfp_mask, unsigned long nr_pages, struct
> > list_head *list)
> > +{
> > +	return __alloc_pages_bulk_nodemask(gfp_mask, numa_mem_id(), NULL,
> > +							nr_pages, list);
> 
> Is the second line indentation intentional ? Why not align it to the first
> argument (gfp_mask) ?
> 

No particular reason. I usually pick this as it's visually clearer to me
that it's part of the same line when the multi-line is part of an if block.

> > +}
> > +
> >  /*
> >   * Allocate pages, preferring the node given as nid. The node   must be
> > valid and
> >   * online. For more general interface, see alloc_pages_node().
> > @@ -594,6 +606,7 @@ void * __meminit alloc_pages_exact_nid(int nid,
> > size_t size, gfp_t gfp_mask);
> >    extern void __free_pages(struct page *page, unsigned int  order);
> >  extern void free_pages(unsigned long addr, unsigned int order);
> > +extern void free_pages_bulk(struct list_head *list);
> >  struct page_frag_cache;
> >  extern void __page_frag_cache_drain(struct page *page, unsigned  int
> > count);
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 3e4b29ee2b1e..ff1e55793786 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -4436,6 +4436,21 @@ static void wake_all_kswapds(unsigned int order,
> > gfp_t gfp_mask,
> >  	}
> >  }
> > ...
> > +/*
> > + * This is a batched version of the page allocator that attempts to
> > + * allocate nr_pages quickly from the preferred zone and add them to
> > list.
> > + */
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
> 
> Does alloced count the number of allocated pages ?

Yes.

> Do you mind renaming it to 'allocated' ?

I will if there is another version as I do not feel particularly strongly
about alloced vs allocated. alloc was to match the function name and I
don't think the change makes it much clearer.


> > <SNIP>
> > +	/* Attempt the batch allocation */
> > +	local_irq_save(flags);
> > +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> > +	pcp_list = &pcp->lists[ac.migratetype];
> > +
> > +	while (alloced < nr_pages) {
> > +		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> > + pcp, pcp_list);
> 
> Same indentation comment as before
> 

Again, simple personal perference to avoid any possibility it's mixed
up with a later line. There has not been consistent code styling
enforcement of what indentation style should be used for a multi-line
within mm/page_alloc.c

-- 
Mel Gorman
SUSE Labs
