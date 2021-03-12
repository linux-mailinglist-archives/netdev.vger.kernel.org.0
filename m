Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDD43391B5
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhCLPoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:44:02 -0500
Received: from outbound-smtp54.blacknight.com ([46.22.136.238]:39207 "EHLO
        outbound-smtp54.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231730AbhCLPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:43:32 -0500
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp54.blacknight.com (Postfix) with ESMTPS id DC55EFB0BD
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 15:43:31 +0000 (GMT)
Received: (qmail 19760 invoked from network); 12 Mar 2021 15:43:31 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 12 Mar 2021 15:43:31 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 1/7] mm/page_alloc: Move gfp_allowed_mask enforcement to prepare_alloc_pages
Date:   Fri, 12 Mar 2021 15:43:25 +0000
Message-Id: <20210312154331.32229-2-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312154331.32229-1-mgorman@techsingularity.net>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__alloc_pages updates GFP flags to enforce what flags are allowed
during a global context such as booting or suspend. This patch moves the
enforcement from __alloc_pages to prepare_alloc_pages so the code can be
shared between the single page allocator and a new bulk page allocator.

When moving, it is obvious that __alloc_pages() and __alloc_pages
use different names for the same variable. This is an unnecessary
complication so rename gfp_mask to gfp in prepare_alloc_pages() so the
name is consistent.

No functional change.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 mm/page_alloc.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 00b67c47ad87..f0c1d74ead6f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4914,15 +4914,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
-static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
+static inline bool prepare_alloc_pages(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
 		unsigned int *alloc_flags)
 {
-	ac->highest_zoneidx = gfp_zone(gfp_mask);
-	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
+	gfp &= gfp_allowed_mask;
+	*alloc_gfp = gfp;
+
+	ac->highest_zoneidx = gfp_zone(gfp);
+	ac->zonelist = node_zonelist(preferred_nid, gfp);
 	ac->nodemask = nodemask;
-	ac->migratetype = gfp_migratetype(gfp_mask);
+	ac->migratetype = gfp_migratetype(gfp);
 
 	if (cpusets_enabled()) {
 		*alloc_gfp |= __GFP_HARDWALL;
@@ -4936,18 +4939,18 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 			*alloc_flags |= ALLOC_CPUSET;
 	}
 
-	fs_reclaim_acquire(gfp_mask);
-	fs_reclaim_release(gfp_mask);
+	fs_reclaim_acquire(gfp);
+	fs_reclaim_release(gfp);
 
-	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
+	might_sleep_if(gfp & __GFP_DIRECT_RECLAIM);
 
-	if (should_fail_alloc_page(gfp_mask, order))
+	if (should_fail_alloc_page(gfp, order))
 		return false;
 
-	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
+	*alloc_flags = current_alloc_flags(gfp, *alloc_flags);
 
 	/* Dirty zone balancing only done in the fast path */
-	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
+	ac->spread_dirty_pages = (gfp & __GFP_WRITE);
 
 	/*
 	 * The preferred zone is used for statistics but crucially it is
@@ -4980,8 +4983,6 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		return NULL;
 	}
 
-	gfp &= gfp_allowed_mask;
-	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
 			&alloc_gfp, &alloc_flags))
 		return NULL;
-- 
2.26.2

