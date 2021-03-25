Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A733D349103
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCYLno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:43:44 -0400
Received: from outbound-smtp21.blacknight.com ([81.17.249.41]:36599 "EHLO
        outbound-smtp21.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232289AbhCYLmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:42:51 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp21.blacknight.com (Postfix) with ESMTPS id C8052CCA82
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:42:49 +0000 (GMT)
Received: (qmail 15475 invoked from network); 25 Mar 2021 11:42:49 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:42:49 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 1/9] mm/page_alloc: Rename alloced to allocated
Date:   Thu, 25 Mar 2021 11:42:20 +0000
Message-Id: <20210325114228.27719-2-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
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
index dfa9af064f74..8a3e13277e22 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2908,7 +2908,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
 			int migratetype, unsigned int alloc_flags)
 {
-	int i, alloced = 0;
+	int i, allocated = 0;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -2931,7 +2931,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->lru, list);
-		alloced++;
+		allocated++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
@@ -2940,12 +2940,12 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
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

