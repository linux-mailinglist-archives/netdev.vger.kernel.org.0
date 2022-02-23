Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32DA4C05B5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbiBWADu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiBWADq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:03:46 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED41DF5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:03:19 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id i1so3297927plr.2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5eKlG+olR+v1Jore0DzdJd7X6rmX2142orNhGJ9AaEI=;
        b=VaG8gYXljchP0k/RIXaORjvcWCc73VUUqAF5d4mEc1ph30B7QNGwgBWfEpt48HD0u/
         mXIzPtHcJulp2Lr+riwLNJpTGZXtJKkcjlYshfp1NsVdSVPhFliWwyBAIy1NsUqlaV4B
         bR8VrPwCQwlxyh9l9GT8wQWHDOqQ0ZqahZ+Yw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5eKlG+olR+v1Jore0DzdJd7X6rmX2142orNhGJ9AaEI=;
        b=pYNOWGDXgTfpZ63v+DhMkRn8DvzE8C3Rt1tOP+ufq3gUeQrPUUfJh8EJUvz9VxdTKm
         ga3RxyvlywlHt1LbCQV/u1b9nTd+p+dVgb+CI0fquPb3XOrzoxPkJxoeP4p5kFQ3cWnJ
         c787gChg16S3e7nRDEsQpuMNYv3ec0Je6WDZNdpT/n1QA6p5YHKvfigoBCiJgZBOrzId
         9GFtjKX+51hWR9bHD5UgBmqrG/rt5hBqG4X33W8EZ3QqWUT24pWupkb+c0kKP03YtpAE
         F2LyEhk2SUbU9RU+aVwWp1X9YFN8AyCeBm1iH9CsRflQy5UQ1gW0mj5ouJGPfjVfc/JO
         dEgQ==
X-Gm-Message-State: AOAM5325a9H1u+aVdaLvhj7yVTqAW1ng0ZcVt2XvDSqR5qSb/YKh5Shv
        bu1/0/aieU64TADldolcdu9H5eccLjfTx1yV3xiEq/vzBHh3mby40ptwpLQaSMXzgA/pnKomM/v
        v32OzakISO9shwN7vKMKe2x7iU+1AImO98SVIpQEqS9wfnUAIiBmPl8/oVyYU82fzCp71
X-Google-Smtp-Source: ABdhPJzBRdMwyZHA6s2uj66yH6l+ev3J6+EGu2Qqgeqt5KRSYoGoP+QIukfNqd7UAT/xTnt/laiWJQ==
X-Received: by 2002:a17:902:cccb:b0:14d:ae35:1a81 with SMTP id z11-20020a170902cccb00b0014dae351a81mr25519251ple.137.1645574598778;
        Tue, 22 Feb 2022 16:03:18 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id i3sm22460027pgq.65.2022.02.22.16.03.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 16:03:18 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v6 1/2] page_pool: Add page_pool stats
Date:   Tue, 22 Feb 2022 16:00:23 -0800
Message-Id: <1645574424-60857-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
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
index 97c3c19..bedc82f 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -135,7 +135,25 @@ struct page_pool {
 	refcount_t user_cnt;
 
 	u64 destroy_cnt;
+#ifdef CONFIG_PAGE_POOL_STATS
+	struct page_pool_stats __percpu *stats ____cacheline_aligned_in_smp;
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

