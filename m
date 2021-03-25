Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E83B349108
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhCYLny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:43:54 -0400
Received: from outbound-smtp62.blacknight.com ([46.22.136.251]:45759 "EHLO
        outbound-smtp62.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhCYLnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:43:22 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp62.blacknight.com (Postfix) with ESMTPS id 95A65FA82C
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:43:20 +0000 (GMT)
Received: (qmail 17095 invoked from network); 25 Mar 2021 11:43:20 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:43:20 -0000
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
Subject: [PATCH 4/9] mm/page_alloc: optimize code layout for __alloc_pages_bulk
Date:   Thu, 25 Mar 2021 11:42:23 +0000
Message-Id: <20210325114228.27719-5-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

Looking at perf-report and ASM-code for __alloc_pages_bulk() it is clear
that the code activated is suboptimal. The compiler guesses wrong and
places unlikely code at the beginning. Due to the use of WARN_ON_ONCE()
macro the UD2 asm instruction is added to the code, which confuse the
I-cache prefetcher in the CPU.

[mgorman: Minor changes and rebasing]
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 mm/page_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index be1e33a4df39..1ec18121268b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5001,7 +5001,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	unsigned int alloc_flags;
 	int nr_populated = 0;
 
-	if (WARN_ON_ONCE(nr_pages <= 0))
+	if (unlikely(nr_pages <= 0))
 		return 0;
 
 	/*
@@ -5048,7 +5048,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	 * If there are no allowed local zones that meets the watermarks then
 	 * try to allocate a single page and reclaim if necessary.
 	 */
-	if (!zone)
+	if (unlikely(!zone))
 		goto failed;
 
 	/* Attempt the batch allocation */
@@ -5066,7 +5066,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
-		if (!page) {
+		if (unlikely(!page)) {
 			/* Try and get at least one page */
 			if (!nr_populated)
 				goto failed_irq;
-- 
2.26.2

