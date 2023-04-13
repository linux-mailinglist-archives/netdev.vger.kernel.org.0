Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5702D6E16A4
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDMVqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDMVqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:46:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3402940E8
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:46:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC92C641CE
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 21:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CD6C433D2;
        Thu, 13 Apr 2023 21:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681422374;
        bh=lCyoFlrEWee1wgrn3sz478/Fl0ZgR7rPxSx24/os5YM=;
        h=From:To:Cc:Subject:Date:From;
        b=hqz1HLw0x3vpfHiRDlKGnhWuGgxIKq9sKrKW6jT2AljXO5OYKd8ko2Vo0TCUD3obM
         QJSIbyDEUe4yrcmIrJKKU6ttbQ85PM7PcBUwKDEA7Q+ns+oEL7kKmAn7tPJG5hPUIp
         /UvnUXlxb486iRXb51L2Nv+JGtZsgWRq7ejonmssypB1ObcNKHcJUYm1vS/oM/os3u
         NZC+wkEQ+UF1YXKH+75u92YSI//A25A7KkOsMuTPSG5OGJ6cua9j7f90iqbC4wT8Mx
         wL8zt5WltEqR5QnFEepKehUxZGnUkAVL6gKn1IjoWKqtdK7STBSSkxo602FAyQL51H
         HwVW82MKCMNPw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, jdamato@fastly.com
Subject: [PATCH net-next] net: page_pool: add pages and released_pages counters
Date:   Thu, 13 Apr 2023 23:46:03 +0200
Message-Id: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce pages and released_pages counters to page_pool ethtool stats
in order to track the number of allocated and released pages from the
pool.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/networking/page_pool.rst | 2 ++
 include/net/page_pool.h                | 2 ++
 net/core/page_pool.c                   | 8 ++++++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 30f1344e7cca..71b3eb4555f1 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -138,6 +138,7 @@ The ``struct page_pool_alloc_stats`` has the following fields:
   * ``refill``: an allocation which triggered a refill of the cache
   * ``waive``: pages obtained from the ptr ring that cannot be added to
     the cache due to a NUMA mismatch.
+  * ``pages``: number of allocated pages to the pool
 
 The ``struct page_pool_recycle_stats`` has the following fields:
   * ``cached``: recycling placed page in the page pool cache
@@ -145,6 +146,7 @@ The ``struct page_pool_recycle_stats`` has the following fields:
   * ``ring``: page placed into the ptr ring
   * ``ring_full``: page released from page pool because the ptr ring was full
   * ``released_refcnt``: page released (and not recycled) because refcnt > 1
+  * ``released_pages``: number of released pages from the pool
 
 Coding examples
 ===============
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ddfa0b328677..b16d5320d963 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -94,6 +94,7 @@ struct page_pool_alloc_stats {
 		    */
 	u64 refill; /* allocations via successful refill */
 	u64 waive;  /* failed refills due to numa zone mismatch */
+	u64 pages; /* number of allocated pages to the pool */
 };
 
 struct page_pool_recycle_stats {
@@ -106,6 +107,7 @@ struct page_pool_recycle_stats {
 	u64 released_refcnt; /* page released because of elevated
 			      * refcnt
 			      */
+	u64 released_pages; /* number of released pages from the pool */
 };
 
 /* This struct wraps the above stats structs so users of the
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 193c18799865..418d443d7e7c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -50,11 +50,13 @@ static const char pp_stats[][ETH_GSTRING_LEN] = {
 	"rx_pp_alloc_empty",
 	"rx_pp_alloc_refill",
 	"rx_pp_alloc_waive",
+	"rx_pp_alloc_pages",
 	"rx_pp_recycle_cached",
 	"rx_pp_recycle_cache_full",
 	"rx_pp_recycle_ring",
 	"rx_pp_recycle_ring_full",
 	"rx_pp_recycle_released_ref",
+	"rx_pp_released_pages",
 };
 
 bool page_pool_get_stats(struct page_pool *pool,
@@ -72,6 +74,7 @@ bool page_pool_get_stats(struct page_pool *pool,
 	stats->alloc_stats.empty += pool->alloc_stats.empty;
 	stats->alloc_stats.refill += pool->alloc_stats.refill;
 	stats->alloc_stats.waive += pool->alloc_stats.waive;
+	stats->alloc_stats.pages += pool->alloc_stats.pages;
 
 	for_each_possible_cpu(cpu) {
 		const struct page_pool_recycle_stats *pcpu =
@@ -82,6 +85,7 @@ bool page_pool_get_stats(struct page_pool *pool,
 		stats->recycle_stats.ring += pcpu->ring;
 		stats->recycle_stats.ring_full += pcpu->ring_full;
 		stats->recycle_stats.released_refcnt += pcpu->released_refcnt;
+		stats->recycle_stats.released_pages += pcpu->released_pages;
 	}
 
 	return true;
@@ -117,11 +121,13 @@ u64 *page_pool_ethtool_stats_get(u64 *data, void *stats)
 	*data++ = pool_stats->alloc_stats.empty;
 	*data++ = pool_stats->alloc_stats.refill;
 	*data++ = pool_stats->alloc_stats.waive;
+	*data++ = pool_stats->alloc_stats.pages;
 	*data++ = pool_stats->recycle_stats.cached;
 	*data++ = pool_stats->recycle_stats.cache_full;
 	*data++ = pool_stats->recycle_stats.ring;
 	*data++ = pool_stats->recycle_stats.ring_full;
 	*data++ = pool_stats->recycle_stats.released_refcnt;
+	*data++ = pool_stats->recycle_stats.released_pages;
 
 	return data;
 }
@@ -411,6 +417,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		pool->pages_state_hold_cnt++;
 		trace_page_pool_state_hold(pool, page,
 					   pool->pages_state_hold_cnt);
+		alloc_stat_inc(pool, pages);
 	}
 
 	/* Return last page */
@@ -493,6 +500,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 	 */
 	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
 	trace_page_pool_state_release(pool, page, count);
+	recycle_stat_inc(pool, released_pages);
 }
 EXPORT_SYMBOL(page_pool_release_page);
 
-- 
2.39.2

