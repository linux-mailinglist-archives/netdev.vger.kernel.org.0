Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F6D34910D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhCYLoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:44:03 -0400
Received: from outbound-smtp11.blacknight.com ([46.22.139.106]:41975 "EHLO
        outbound-smtp11.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231468AbhCYLnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:43:35 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp11.blacknight.com (Postfix) with ESMTPS id CB3DB1C35B5
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:43:30 +0000 (GMT)
Received: (qmail 17676 invoked from network); 25 Mar 2021 11:43:30 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:43:30 -0000
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
Subject: [PATCH 5/9] mm/page_alloc: inline __rmqueue_pcplist
Date:   Thu, 25 Mar 2021 11:42:24 +0000
Message-Id: <20210325114228.27719-6-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

When __alloc_pages_bulk() got introduced two callers of __rmqueue_pcplist
exist and the compiler chooses to not inline this function.

 ./scripts/bloat-o-meter vmlinux-before vmlinux-inline__rmqueue_pcplist
add/remove: 0/1 grow/shrink: 2/0 up/down: 164/-125 (39)
Function                                     old     new   delta
rmqueue                                     2197    2296     +99
__alloc_pages_bulk                          1921    1986     +65
__rmqueue_pcplist                            125       -    -125
Total: Before=19374127, After=19374166, chg +0.00%

modprobe page_bench04_bulk loops=$((10**7))

Type:time_bulk_page_alloc_free_array
 -  Per elem: 106 cycles(tsc) 29.595 ns (step:64)
 - (measurement period time:0.295955434 sec time_interval:295955434)
 - (invoke count:10000000 tsc_interval:1065447105)

Before:
 - Per elem: 110 cycles(tsc) 30.633 ns (step:64)

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1ec18121268b..d900e92884b2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3415,7 +3415,8 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z)
 }
 
 /* Remove page from the per-cpu list, caller must protect the list */
-static struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
+static inline
+struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
 			struct list_head *list)
-- 
2.26.2

