Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50F4C4CCB
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbiBYRng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243977AbiBYRnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:43:33 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392231480F9
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:42:58 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bx5so5388719pjb.3
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5OUr2Rp4zMezR7mBfMQ6FNqQTtpBOzvPMjwGBZOVKdk=;
        b=b3qHilancj/+h9o3L2VVQpeExfUaQ5rNw10L01L4WahJGctvD0nmJsklqR5VkLGA2G
         Tp7gHizRZhExluo80r251JZZHbIQZmeDMTcZHzRcX+8cA+fu1wz0msUZNpW4Ri3d7Cqi
         mNwYJHpT3S/SEX0aQDl0nv1TxjlJJDfThSHyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5OUr2Rp4zMezR7mBfMQ6FNqQTtpBOzvPMjwGBZOVKdk=;
        b=545kHxDuD/CL7Eq7F375rLJ2vC+ZbID5Y4ESXyVUBU5g7jxCPgKTQ+grF1dg/kjUC7
         9tihqWk0S0P7Q8kEWPuxStq4+Jj13VmCnxS388HceGT88N0QBXdEvo+mNYR3FEz2xV+D
         UGHv8BaUazRjRQqZNjGUQi/44eBHutpKvXbwTPTWvI8AuSGecfQjFgVHRl7qNLrXRQ4W
         RY+xUzVpnePWoo1r/CJRiKkWLFNyRT5HlGxWmcldxNviLP0X/ufVej91pzlMa1WZw1Wc
         viy7FmWwopVdcyb+goUXxpZ8uoI2OvABJCgJZy4BovhbydJNNhSyiGOY67IOzT6jqz9O
         Ghtg==
X-Gm-Message-State: AOAM5335ds7Fz2lWAdIz76esVCUK+HCf96ziaXuddNcsap9ZobYbSara
        Wr9gxNdlKkhdGeVUWk7OQJY40FCAJ3gstXQfXj97pZ/JMCPcSl/SmdZ+kc+rlLmRgs2O8a6x9L2
        FMNTHrgnMccQh/gjjmYqvvx98icUnvuJamZQkGeUwP1DUPR8yEXA8Bo0X66f9ou9Bp6i9
X-Google-Smtp-Source: ABdhPJzkbWZNRLZfV58dCd43OZ/Y6Ypp3iSw68TnnELytk64F0iJCWFP6xukuoGRcl4gSrjNiH114Q==
X-Received: by 2002:a17:903:1249:b0:14e:e053:c8b6 with SMTP id u9-20020a170903124900b0014ee053c8b6mr8580076plh.132.1645810977583;
        Fri, 25 Feb 2022 09:42:57 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id h2-20020a656382000000b00370648d902csm3203805pgv.4.2022.02.25.09.42.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Feb 2022 09:42:57 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v7 2/4] page_pool: Add recycle stats
Date:   Fri, 25 Feb 2022 09:41:52 -0800
Message-Id: <1645810914-35485-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
---
 include/net/page_pool.h | 16 ++++++++++++++++
 net/core/page_pool.c    | 28 +++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

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
index 0fa4b76..27233bf 100644
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
 
@@ -410,6 +423,11 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	if (ret == 0)
+		recycle_stat_inc(pool, ring);
+#endif
+
 	return (ret == 0) ? true : false;
 }
 
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

