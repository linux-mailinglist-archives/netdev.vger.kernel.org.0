Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742B74B5C5F
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiBNVQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 16:16:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiBNVQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 16:16:41 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0996125C90
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:16:28 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x4so11521049plb.4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BV89ljgU4UIc5h+Gnv9lvaL5HFW+SjGbp0EEF0mjr/Q=;
        b=VDAOe3lGNgWGzBb1vAWf53PDeEgapCUAZQvn+bTX3vqNoPawh0UsoTyEylpG2CZgVD
         ghWCsOryTFZ55nxGskZCqUeCyLAFO4xZTT9hSqpofJi7rnsrvLZvApHnRTfIMf8TkPd4
         lUU1im+4j66P9sVCXuxUb+Gl9+4ZjzcRGrehE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BV89ljgU4UIc5h+Gnv9lvaL5HFW+SjGbp0EEF0mjr/Q=;
        b=WMvCs42Pr98hkxo3zXrOOParLRKA1uZXAyQ8tb2wmFPw95JMMsc3sSA6aEexlu5CU8
         ERLPHqeRQSFOHHSEKwC3zyPIuzeO7svzGo7Lcxa78KkwUKiOaG4fka35S2TGIgFu7IvA
         mYrWJ4HGaWmmyE5JAraYY+Tz8OC51Tgvz0cfF1EUEacNu+9GTH/HHYNfV0rrHhp1J1q+
         Q9Y+TvzhchX2Gp7w0EIMo8x5h3cNJOy0FccXRDE+gy/oX9TtlKkNABPBXi0gqHZU6GWy
         EHKLI1mX2n6kHFxtphNXxo6bwS/VBEmY4eBkpZjZYAMFCAHvTt3g5D25KJwOrbot82JS
         eBWQ==
X-Gm-Message-State: AOAM532dIBUW24oUukI30NKF0dmE5zDr6W8DioraAiuIFj3lmLd2Ihx7
        XAKxER7dzW5UUwrlvGtdSa/qH10MBRFKAp4iQavQZSOotOHdTYUlWdnQ4J4g7xPB/moiaZ5Ptx2
        xT0abh4gBkOB1HLg/NxeEi//fQBxnz30QjH/YvV3vLMBDBNScuwRag4v3k/p9+XrSfG7O
X-Google-Smtp-Source: ABdhPJzRH2uaNBIKO7ieyPyVO0q6V9TA2A31H+HNdmr9HsRYZS2vLmX8DZ7PI5Mb0Pm6D/cABnKuFA==
X-Received: by 2002:a17:902:8688:: with SMTP id g8mr657559plo.142.1644869015610;
        Mon, 14 Feb 2022 12:03:35 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a38sm25010916pfx.121.2022.02.14.12.03.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Feb 2022 12:03:35 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v5 1/2] page_pool: Add page_pool stat counters
Date:   Mon, 14 Feb 2022 12:02:28 -0800
Message-Id: <1644868949-24506-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1644868949-24506-1-git-send-email-jdamato@fastly.com>
References: <1644868949-24506-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per-cpu per-pool statistics counters for the allocation path of a page
pool.

This code is disabled by default and a kernel config option is provided for
users who wish to enable them.

The statistics added are:
	- fast: successful fast path allocations
	- slow: slow path order-0 allocations
	- slow_high_order: slow path high order allocations
	- empty: ptr ring is empty, so a slow path allocation was forced.
	- refill: an allocation which triggered a refill of the cache
	- waive: pages obtained from the ptr ring that cannot be added to
	  the cache due to a NUMA mismatch.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 18 ++++++++++++++++++
 net/Kconfig             | 13 +++++++++++++
 net/core/page_pool.c    | 37 +++++++++++++++++++++++++++++++++----
 3 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 97c3c19..d827ab1 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -135,7 +135,25 @@ struct page_pool {
 	refcount_t user_cnt;
 
 	u64 destroy_cnt;
+#ifdef CONFIG_PAGE_POOL_STATS
+	struct page_pool_stats __percpu *stats;
+#endif
+};
+
+#ifdef CONFIG_PAGE_POOL_STATS
+struct page_pool_stats {
+	struct {
+		u64 fast; /* fast path allocations */
+		u64 slow; /* slow-path order 0 allocations */
+		u64 slow_high_order; /* slow-path high order allocations */
+		u64 empty; /* failed refills due to empty ptr ring, forcing
+			    * slow path allocation
+			    */
+		u64 refill; /* allocations via successful refill */
+		u64 waive;  /* failed refills due to numa zone mismatch */
+	} alloc;
 };
+#endif
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
 
diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0..8c07308 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -434,6 +434,19 @@ config NET_DEVLINK
 config PAGE_POOL
 	bool
 
+config PAGE_POOL_STATS
+	default n
+	bool "Page pool stats"
+	depends on PAGE_POOL
+	help
+	  Enable page pool statistics to track allocations. This option
+	  incurs additional CPU cost in allocation paths and additional
+	  memory cost to store the statistics. These statistics are only
+	  available if this option is enabled and if the driver using
+	  the page pool supports exporting this data.
+
+	  If unsure, say N.
+
 config FAILOVER
 	tristate "Generic failover module"
 	help
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e25d359..f29dff9 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -26,6 +26,17 @@
 
 #define BIAS_MAX	LONG_MAX
 
+#ifdef CONFIG_PAGE_POOL_STATS
+/* this_cpu_inc_alloc_stat is intended to be used in softirq context */
+#define this_cpu_inc_alloc_stat(pool, __stat)				\
+	do {								\
+		struct page_pool_stats __percpu *s = pool->stats;	\
+		__this_cpu_inc(s->alloc.__stat);			\
+	} while (0)
+#else
+#define this_cpu_inc_alloc_stat(pool, __stat)
+#endif
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -73,6 +84,12 @@ static int page_pool_init(struct page_pool *pool,
 	    pool->p.flags & PP_FLAG_PAGE_FRAG)
 		return -EINVAL;
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	pool->stats = alloc_percpu(struct page_pool_stats);
+	if (!pool->stats)
+		return -ENOMEM;
+#endif
+
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
@@ -117,8 +134,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	int pref_nid; /* preferred NUMA node */
 
 	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
+	if (__ptr_ring_empty(r)) {
+		this_cpu_inc_alloc_stat(pool, empty);
 		return NULL;
+	}
 
 	/* Softirq guarantee CPU and thus NUMA node is stable. This,
 	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
@@ -145,14 +164,17 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			 * This limit stress on page buddy alloactor.
 			 */
 			page_pool_return_page(pool, page);
+			this_cpu_inc_alloc_stat(pool, waive);
 			page = NULL;
 			break;
 		}
 	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
+		this_cpu_inc_alloc_stat(pool, refill);
+	}
 
 	return page;
 }
@@ -166,6 +188,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	if (likely(pool->alloc.count)) {
 		/* Fast-path */
 		page = pool->alloc.cache[--pool->alloc.count];
+		this_cpu_inc_alloc_stat(pool, fast);
 	} else {
 		page = page_pool_refill_alloc_cache(pool);
 	}
@@ -239,6 +262,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	this_cpu_inc_alloc_stat(pool, slow_high_order);
 	page_pool_set_pp_info(pool, page);
 
 	/* Track how many pages are held 'in-flight' */
@@ -293,10 +317,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
-	else
+		this_cpu_inc_alloc_stat(pool, slow);
+	} else {
 		page = NULL;
+	}
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
@@ -620,6 +646,9 @@ static void page_pool_free(struct page_pool *pool)
 	if (pool->p.flags & PP_FLAG_DMA_MAP)
 		put_device(pool->p.dev);
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	free_percpu(pool->stats);
+#endif
 	kfree(pool);
 }
 
-- 
2.7.4

