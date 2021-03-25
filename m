Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8857F349225
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhCYMhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:37:40 -0400
Received: from outbound-smtp55.blacknight.com ([46.22.136.239]:59539 "EHLO
        outbound-smtp55.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230273AbhCYMhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:37:16 -0400
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp55.blacknight.com (Postfix) with ESMTPS id 3C7F4FA863
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 12:37:15 +0000 (GMT)
Received: (qmail 32076 invoked from network); 25 Mar 2021 12:37:15 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 25 Mar 2021 12:37:14 -0000
Date:   Thu, 25 Mar 2021 12:37:13 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210325123713.GQ3697@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-3-mgorman@techsingularity.net>
 <20210325120525.GU1719932@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210325120525.GU1719932@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:05:25PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 25, 2021 at 11:42:21AM +0000, Mel Gorman wrote:
> > +int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> > +				nodemask_t *nodemask, int nr_pages,
> > +				struct list_head *list);
> > +
> > +/* Bulk allocate order-0 pages */
> > +static inline unsigned long
> > +alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
> > +{
> > +	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
> 
> Discrepancy in the two return types here.  Suspect they should both
> be 'unsigned int' so there's no question about "can it return an errno".
> 

I'll make it unsigned long as the nr_pages parameter is unsigned long.
It's a silly range to have for pages but it matches alloc_contig_range
even though free_contig_range takes unsigned int *sigh*

> >  
> > +/*
> 
> If you could make that "/**" instead ...
> 

I decided not to until we're reasonably sure the semantics are not going
to change.

---8<---
mm/page_alloc: Add a bulk page allocator -fix

Matthew Wilcox pointed out that the return type for alloc_pages_bulk()
and __alloc_pages_bulk() is inconsistent. Fix it.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 include/linux/gfp.h | 2 +-
 mm/page_alloc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4a304fd39916..a2be8f4174a9 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -518,7 +518,7 @@ static inline int arch_make_page_accessible(struct page *page)
 struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 
-int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct list_head *list);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eb547470a7e4..92d55f80c289 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4978,7 +4978,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  *
  * Returns the number of pages on the list.
  */
-int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			nodemask_t *nodemask, int nr_pages,
 			struct list_head *page_list)
 {
