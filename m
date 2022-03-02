Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852594C9EB8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiCBH5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiCBH5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:57:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC6DB6D08
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 23:56:47 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso617301pjq.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 23:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mPEJhSUR8LHc4x0Gte5MVbalaCT/VfssAnFg5lsZpL8=;
        b=cKyIctTfVJRKepVFL1BXmsBBZQc7rlza1gR6E67VR5q8anc29gtmyaDkRH04oS77BL
         gf38KDADnkiu+rOWhRISPSIZBYddiQKQyLpPMEElf/LluiUN2gyNwrrnnGTmd/HTtAM4
         vkNhVSPGr9g8wmFzUqx7XuYmOWoFHrA8+IBsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mPEJhSUR8LHc4x0Gte5MVbalaCT/VfssAnFg5lsZpL8=;
        b=j4LgDuSIsxFN2p+lKWKdnuRCPTHjrGZR6ptVs1pQl7H8m7DTlAjiguDV3+QiSPr+/s
         2SjJCIE06XPKumEcsuZQHWZmriF5VSp02qNK6x/E+3uIcmFec5PJnQBRinGmEUF79EDH
         MCzvSmH0iM4lIXpEcfK+XSEivCrSzADrQZRLo1ULVhhQhmwA2ZYYCHvcW9hyH+6KhqIR
         Ag8S5Mha9tfUusMLRhUCQuGWPLJB+OJpvlkbTnJXM3v8kAbrdgUTICgzPXeUJpjuJwDP
         fPpWbuTdmVHnFaKK6FBUwwKfMzzmPrnHYUlAcusbVkfKh5jWAQSzruhTSEI5e0DGROat
         klkg==
X-Gm-Message-State: AOAM531DJi9CVcDoeCl7fEKpBeJSBya0EfVO4iek3VhKdBarmkC9fWhF
        foM4HrRAsYN3yPnhdoP8IPl+1ld70K79dQjXVMUMQshKcgpD6/7aqsPIRrolYhZdZLFYlCPIq2w
        Xt0VhbVhm1YpYk0wuqJGbWeq8jPfjENr1prPiQuHDtpCMuxaq6kjX8S9FVGPNVmJAoEZ+
X-Google-Smtp-Source: ABdhPJyqGMvWavWcduixiFwBh5T3uGN4jLsCwdnqd4qXt4KPg7VSwyo35DXdxRFgGzJtwQwlpDezGw==
X-Received: by 2002:a17:902:f64e:b0:14d:20db:8478 with SMTP id m14-20020a170902f64e00b0014d20db8478mr29140752plg.158.1646207806881;
        Tue, 01 Mar 2022 23:56:46 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb9-20020a17090b060900b001beecaf986dsm2237780pjb.52.2022.03.01.23.56.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 23:56:46 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com,
        leon@kernel.org, linux-rdma@vger.kernel.org, saeedm@nvidia.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v9 2/5] page_pool: Add recycle stats
Date:   Tue,  1 Mar 2022 23:55:48 -0800
Message-Id: <1646207751-13621-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
References: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per-cpu stats tracking page pool recycling events:
	- cached: recycling placed page in the page pool cache
	- cache_full: page pool cache was full
	- ring: page placed into the ptr ring
	- ring_full: page released from page pool because the ptr ring was full
	- released_refcnt: page released (and not recycled) because refcnt > 1

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 include/net/page_pool.h | 16 ++++++++++++++++
 net/core/page_pool.c    | 30 ++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 1f27e8a4..298af95 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -95,6 +95,18 @@ struct page_pool_alloc_stats {
 	u64 refill; /* allocations via successful refill */
 	u64 waive;  /* failed refills due to numa zone mismatch */
 };
+
+struct page_pool_recycle_stats {
+	u64 cached;	/* recycling placed page in the cache. */
+	u64 cache_full; /* cache was full */
+	u64 ring;	/* recycling placed page back into ptr ring */
+	u64 ring_full;	/* page was released from page-pool because
+			 * PTR ring was full.
+			 */
+	u64 released_refcnt; /* page released because of elevated
+			      * refcnt
+			      */
+};
 #endif
 
 struct page_pool {
@@ -144,6 +156,10 @@ struct page_pool {
 	 */
 	struct ptr_ring ring;
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	/* recycle stats are per-cpu to avoid locking */
+	struct page_pool_recycle_stats __percpu *recycle_stats;
+#endif
 	atomic_t pages_state_release_cnt;
 
 	/* A page_pool is strictly tied to a single RX-queue being
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 0fa4b76..3d273cb 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -29,8 +29,15 @@
 #ifdef CONFIG_PAGE_POOL_STATS
 /* alloc_stat_inc is intended to be used in softirq context */
 #define alloc_stat_inc(pool, __stat)	(pool->alloc_stats.__stat++)
+/* recycle_stat_inc is safe to use when preemption is possible. */
+#define recycle_stat_inc(pool, __stat)							\
+	do {										\
+		struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;	\
+		this_cpu_inc(s->__stat);						\
+	} while (0)
 #else
 #define alloc_stat_inc(pool, __stat)
+#define recycle_stat_inc(pool, __stat)
 #endif
 
 static int page_pool_init(struct page_pool *pool,
@@ -80,6 +87,12 @@ static int page_pool_init(struct page_pool *pool,
 	    pool->p.flags & PP_FLAG_PAGE_FRAG)
 		return -EINVAL;
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	pool->recycle_stats = alloc_percpu(struct page_pool_recycle_stats);
+	if (!pool->recycle_stats)
+		return -ENOMEM;
+#endif
+
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
@@ -410,7 +423,12 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
 
-	return (ret == 0) ? true : false;
+	if (!ret) {
+		recycle_stat_inc(pool, ring);
+		return true;
+	}
+
+	return false;
 }
 
 /* Only allow direct recycling in special circumstances, into the
@@ -421,11 +439,14 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 static bool page_pool_recycle_in_cache(struct page *page,
 				       struct page_pool *pool)
 {
-	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE))
+	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE)) {
+		recycle_stat_inc(pool, cache_full);
 		return false;
+	}
 
 	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
 	pool->alloc.cache[pool->alloc.count++] = page;
+	recycle_stat_inc(pool, cached);
 	return true;
 }
 
@@ -475,6 +496,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 	 * doing refcnt based recycle tricks, meaning another process
 	 * will be invoking put_page.
 	 */
+	recycle_stat_inc(pool, released_refcnt);
 	/* Do not replace this with page_pool_return_page() */
 	page_pool_release_page(pool, page);
 	put_page(page);
@@ -488,6 +510,7 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
 	if (page && !page_pool_recycle_in_ring(pool, page)) {
 		/* Cache full, fallback to free pages */
+		recycle_stat_inc(pool, ring_full);
 		page_pool_return_page(pool, page);
 	}
 }
@@ -636,6 +659,9 @@ static void page_pool_free(struct page_pool *pool)
 	if (pool->p.flags & PP_FLAG_DMA_MAP)
 		put_device(pool->p.dev);
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	free_percpu(pool->recycle_stats);
+#endif
 	kfree(pool);
 }
 
-- 
2.7.4

