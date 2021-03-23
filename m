Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D823461C3
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhCWOqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:46:20 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:59956 "EHLO
        outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232355AbhCWOpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:45:47 -0400
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp01.blacknight.com (Postfix) with ESMTPS id 4DC8FC4A51
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 14:45:43 +0000 (GMT)
Received: (qmail 30414 invoked from network); 23 Mar 2021 14:45:43 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Mar 2021 14:45:43 -0000
Date:   Tue, 23 Mar 2021 14:45:41 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210323144541.GL3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
 <20210322194948.GI3697@techsingularity.net>
 <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
 <20210322205827.GJ3697@techsingularity.net>
 <20210323120851.18d430cf@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210323120851.18d430cf@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 12:08:51PM +0100, Jesper Dangaard Brouer wrote:
> > > <SNIP>
> > > My results show that, because svc_alloc_arg() ends up calling
> > > __alloc_pages_bulk() twice in this case, it ends up being
> > > twice as expensive as the list case, on average, for the same
> > > workload.
> > >   
> > 
> > Ok, so in this case the caller knows that holes are always at the
> > start. If the API returns an index that is a valid index and populated,
> > it can check the next index and if it is valid then the whole array
> > must be populated.
> > 
> > <SNIP>
> 
> I do know that I suggested moving prep_new_page() out of the
> IRQ-disabled loop, but maybe was a bad idea, for several reasons.
> 
> All prep_new_page does is to write into struct page, unless some
> debugging stuff (like kasan) is enabled. This cache-line is hot as
> LRU-list update just wrote into this cache-line.  As the bulk size goes
> up, as Matthew pointed out, this cache-line might be pushed into
> L2-cache, and then need to be accessed again when prep_new_page() is
> called.
> 
> Another observation is that moving prep_new_page() into loop reduced
> function size with 253 bytes (which affect I-cache).
> 
>    ./scripts/bloat-o-meter mm/page_alloc.o-prep_new_page-outside mm/page_alloc.o-prep_new_page-inside
>     add/remove: 18/18 grow/shrink: 0/1 up/down: 144/-397 (-253)
>     Function                                     old     new   delta
>     __alloc_pages_bulk                          1965    1712    -253
>     Total: Before=60799, After=60546, chg -0.42%
> 
> Maybe it is better to keep prep_new_page() inside the loop.  This also
> allows list vs array variant to share the call.  And it should simplify
> the array variant code.
> 

I agree. I did not like the level of complexity it incurred for arrays
or the fact it required that a list to be empty when alloc_pages_bulk()
is called. I thought the concern for calling prep_new_page() with IRQs
disabled was a little overblown but did not feel strongly enough to push
back on it hard given that we've had problems with IRQs being disabled
for long periods before. At worst, at some point in the future we'll have
to cap the number of pages that can be requested or enable/disable IRQs
every X pages.

New candidate

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v6r4

Interface is still the same so a rebase should be trivial. Diff between
v6r2 and v6r4 is as follows. I like the diffstat if nothing else :P


 mm/page_alloc.c | 54 +++++++++++++-----------------------------------------
 1 file changed, 13 insertions(+), 41 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 547a84f11310..be1e33a4df39 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4999,25 +4999,20 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags;
-	int nr_populated = 0, prep_index = 0;
-	bool hole = false;
+	int nr_populated = 0;
 
 	if (WARN_ON_ONCE(nr_pages <= 0))
 		return 0;
 
-	if (WARN_ON_ONCE(page_list && !list_empty(page_list)))
-		return 0;
-
-	/* Skip populated array elements. */
-	if (page_array) {
-		while (nr_populated < nr_pages && page_array[nr_populated])
-			nr_populated++;
-		if (nr_populated == nr_pages)
-			return nr_populated;
-		prep_index = nr_populated;
-	}
+	/*
+	 * Skip populated array elements to determine if any pages need
+	 * to be allocated before disabling IRQs.
+	 */
+	while (page_array && page_array[nr_populated] && nr_populated < nr_pages)
+		nr_populated++;
 
-	if (nr_pages == 1)
+	/* Use the single page allocator for one page. */
+	if (nr_pages - nr_populated == 1)
 		goto failed;
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
@@ -5056,22 +5051,17 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	if (!zone)
 		goto failed;
 
-retry_hole:
 	/* Attempt the batch allocation */
 	local_irq_save(flags);
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	pcp_list = &pcp->lists[ac.migratetype];
 
 	while (nr_populated < nr_pages) {
-		/*
-		 * Stop allocating if the next index has a populated
-		 * page or the page will be prepared a second time when
-		 * IRQs are enabled.
-		 */
+
+		/* Skip existing pages */
 		if (page_array && page_array[nr_populated]) {
-			hole = true;
 			nr_populated++;
-			break;
+			continue;
 		}
 
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
@@ -5092,6 +5082,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		__count_zid_vm_events(PGALLOC, zone_idx(zone), 1);
 		zone_statistics(ac.preferred_zoneref->zone, zone);
 
+		prep_new_page(page, 0, gfp, 0);
 		if (page_list)
 			list_add(&page->lru, page_list);
 		else
@@ -5101,25 +5092,6 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 	local_irq_restore(flags);
 
-	/* Prep pages with IRQs enabled. */
-	if (page_list) {
-		list_for_each_entry(page, page_list, lru)
-			prep_new_page(page, 0, gfp, 0);
-	} else {
-		while (prep_index < nr_populated)
-			prep_new_page(page_array[prep_index++], 0, gfp, 0);
-
-		/*
-		 * If the array is sparse, check whether the array is
-		 * now fully populated. Continue allocations if
-		 * necessary.
-		 */
-		while (nr_populated < nr_pages && page_array[nr_populated])
-			nr_populated++;
-		if (hole && nr_populated < nr_pages)
-			goto retry_hole;
-	}
-
 	return nr_populated;
 
 failed_irq:

-- 
Mel Gorman
SUSE Labs
