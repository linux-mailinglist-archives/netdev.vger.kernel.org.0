Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751213391A9
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhCLPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:44:09 -0500
Received: from outbound-smtp50.blacknight.com ([46.22.136.234]:56419 "EHLO
        outbound-smtp50.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231861AbhCLPnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:43:35 -0500
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp50.blacknight.com (Postfix) with ESMTPS id 1EDD3FB0C0
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 15:43:32 +0000 (GMT)
Received: (qmail 19782 invoked from network); 12 Mar 2021 15:43:31 -0000
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
Subject: [PATCH 2/7] mm/page_alloc: Rename alloced to allocated
Date:   Fri, 12 Mar 2021 15:43:26 +0000
Message-Id: <20210312154331.32229-3-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312154331.32229-1-mgorman@techsingularity.net>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Review feedback of the bulk allocator twice found problems with "alloced"
being a counter for pages allocated. The naming was based on the API name
"alloc" and was based on the idea that verbal communication about malloc
tends to use the fake word "malloced" instead of the fake word mallocated.
To be consistent, this preparation patch renames alloced to allocated
in rmqueue_bulk so the bulk allocator and per-cpu allocator use similar
names when the bulk allocator is introduced.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 mm/page_alloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f0c1d74ead6f..880b1d6368bd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2904,7 +2904,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
 			int migratetype, unsigned int alloc_flags)
 {
-	int i, alloced = 0;
+	int i, allocated = 0;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -2927,7 +2927,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->lru, list);
-		alloced++;
+		allocated++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
@@ -2936,12 +2936,12 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	/*
 	 * i pages were removed from the buddy list even if some leak due
 	 * to check_pcp_refill failing so adjust NR_FREE_PAGES based
-	 * on i. Do not confuse with 'alloced' which is the number of
+	 * on i. Do not confuse with 'allocated' which is the number of
 	 * pages added to the pcp list.
 	 */
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
-	return alloced;
+	return allocated;
 }
 
 #ifdef CONFIG_NUMA
-- 
2.26.2

