Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E334333A4E2
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbhCNMww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:52:52 -0400
Received: from outbound-smtp47.blacknight.com ([46.22.136.64]:58619 "EHLO
        outbound-smtp47.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235029AbhCNMwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:52:35 -0400
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp47.blacknight.com (Postfix) with ESMTPS id 0AF50FA882
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 12:52:34 +0000 (GMT)
Received: (qmail 30256 invoked from network); 14 Mar 2021 12:52:33 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 14 Mar 2021 12:52:33 -0000
Date:   Sun, 14 Mar 2021 12:52:32 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210314125231.GA3697@techsingularity.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210313193343.GJ2577561@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 07:33:43PM +0000, Matthew Wilcox wrote:
> On Sat, Mar 13, 2021 at 04:56:31PM +0000, Chuck Lever III wrote:
> > IME lists are indeed less CPU-efficient, but I wonder if that
> > expense is insignificant compared to serialization primitives like
> > disabling and re-enabling IRQs, which we are avoiding by using
> > bulk page allocation.
> 
> Cache misses are a worse problem than serialisation.  Paul McKenney had
> a neat demonstration where he took a sheet of toilet paper to represent
> an instruction, and then unrolled two rolls of toilet paper around the
> lecture theatre to represent an L3 cache miss.  Obviously a serialising
> instruction is worse than an add instruction, but i'm thinking maybe
> 50-100 sheets of paper, not an entire roll?
> 

I'm well array of the advantages of arrays over lists. The reality is that
the penalty is incurred unconditionally as the pages have to be removed
from the per-cpu or buddy lists and the cache footprint of the allocator
and the data copies are already large. It's also the case that bulk free
interfaces already exist that operate on lists (free_unref_page_list)
so there is existing precedent. The bulk free API in this series was not
used by the callers so I've deleted it.

Obviously the callers would need to be adjusted to use the array
interface. The sunrpc user has an array but it is coded in a way that
expects the array could be partially populated or has holes so the API has
to skip populated elements. The caller is responsible for making sure that
there are enough NULL elements available to store nr_pages or the buffer
overruns. nr_elements could be passed in to avoid the buffer overrun but
then further logic is needed to distinguish between a failed allocation
and a failure to have enough space in the array to store the pointer.
It also means that prep_new_page() should not be deferred outside of
the IRQ disabled section as it does not have the storage to track which
pages were freshly allocated and which ones were already on the array. It
could be tracked using the lower bit of the pointer but that is not free
either. Ideally the callers simply would ensure the array does not have
valid struct page pointers in it already so prepping the new page could
always be deferred.  Obviously the callers are also responsible for
ensuring protecting the array from parallel access if necessary while
calling into the allocator.

> Anyway, I'm not arguing against a bulk allocator, nor even saying this
> is a bad interface.  It just maybe could be better.
> 

I think it puts more responsibility on the caller to use the API correctly
but I also see no value in arguing about it further because there is no
supporting data either way (I don't have routine access to a sufficiently
fast network to generate the data). I can add the following patch and let
callers figure out which interface is preferred. If one of the interfaces
is dead in a year, it can be removed.

As there are a couple of ways the arrays could be used, I'm leaving it
up to Jesper and Chuck which interface they want to use. In particular,
it would be preferred if the array has no valid struct pages in it but
it's up to them to judge how practical that is.

Patch is only lightly tested with a poor conversion of the sunrpc code
to use the array interface.

---8<---
mm/page_alloc: Add an array-based interface to the bulk page allocator

The existing callers for the bulk allocator are storing the pages in
arrays. This patch adds an array-based interface to the API to avoid
multiple list iterations. The page list interface is preserved to
avoid requiring all users of the bulk API to allocate and manage
enough storage to store the pages.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4a304fd39916..fb6234e1fe59 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -520,13 +520,20 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 
 int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
-				struct list_head *list);
+				struct list_head *page_list,
+				struct page **page_array);
 
 /* Bulk allocate order-0 pages */
 static inline unsigned long
-alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
+alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
 {
-	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NULL);
+}
+
+static inline unsigned long
+alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
+{
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3e0c87c588d3..96590f0726c7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4965,13 +4965,20 @@ static inline bool prepare_alloc_pages(gfp_t gfp, unsigned int order,
 
 /*
  * This is a batched version of the page allocator that attempts to
- * allocate nr_pages quickly from the preferred zone and add them to list.
+ * allocate nr_pages quickly from the preferred zone. Pages are added
+ * to page_list if page_list is not NULL, otherwise it is assumed
+ * that the page_array is valid.
+ *
+ * If using page_array, only NULL elements are populated with pages.
+ * The caller must ensure that the array has enough NULL elements
+ * to store nr_pages or the buffer overruns.
  *
  * Returns the number of pages allocated.
  */
 int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			nodemask_t *nodemask, int nr_pages,
-			struct list_head *alloc_list)
+			struct list_head *page_list,
+			struct page **page_array)
 {
 	struct page *page;
 	unsigned long flags;
@@ -4987,6 +4994,9 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	if (WARN_ON_ONCE(nr_pages <= 0))
 		return 0;
 
+	if (WARN_ON_ONCE(!page_list && !page_array))
+		return 0;
+
 	if (nr_pages == 1)
 		goto failed;
 
@@ -5035,7 +5045,24 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			break;
 		}
 
-		list_add(&page->lru, alloc_list);
+		if (page_list) {
+			/* New page prep is deferred */
+			list_add(&page->lru, page_list);
+		} else {
+			/* Skip populated elements */
+			while (*page_array)
+				page_array++;
+
+			/*
+			 * Array pages must be prepped immediately to
+			 * avoid tracking which pages are new and
+			 * which ones were already on the array.
+			 */
+			prep_new_page(page, 0, gfp, 0);
+			*page_array = page;
+			page_array++;
+		}
+
 		allocated++;
 	}
 
@@ -5044,9 +5071,12 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 	local_irq_restore(flags);
 
-	/* Prep page with IRQs enabled to reduce disabled times */
-	list_for_each_entry(page, alloc_list, lru)
-		prep_new_page(page, 0, gfp, 0);
+	/* Prep pages with IRQs enabled if using a list */
+	if (page_list) {
+		list_for_each_entry(page, page_list, lru) {
+			prep_new_page(page, 0, gfp, 0);
+		}
+	}
 
 	return allocated;
 
@@ -5056,7 +5086,10 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 failed:
 	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
 	if (page) {
-		list_add(&page->lru, alloc_list);
+		if (page_list)
+			list_add(&page->lru, page_list);
+		else
+			*page_array = page;
 		allocated = 1;
 	}
 
