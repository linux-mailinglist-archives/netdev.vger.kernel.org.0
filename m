Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DA94C4CCA
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbiBYRne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243980AbiBYRnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:43:33 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAD95C65C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:42:56 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g1so5299386pfv.1
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rWBfasxeKYhUZL/qJ5mch0juN35OLhEiuC5a6jWhcMg=;
        b=ii8S/clnA8oUpRdvUSLO89YU3F2juAYT3wIROzXp5Z1ExassVfTryLVAcljnNB/EEP
         TIyYQOmL+8Vp1lHVId3/+yJ29KN6cAyaI7gi3kXgHsfCwe97Y+Egq7ms+Pb6f86UQBcK
         msqouxlfR2muQvAnWcl/vLwoQ+4OeCR456dc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rWBfasxeKYhUZL/qJ5mch0juN35OLhEiuC5a6jWhcMg=;
        b=Il02dBB2iVYwe3M18FeyED5Ig/hCAcMkU19etAoX6cpbk4+s62gACjdt1Dl/dZCvz3
         +ER9IoeStTXOk6KyBJM2SQilIZ9lTAUWOtfMJb5X6Py4DgcX7DYdk06gqbzqa/fpPSao
         Kt45m7Z/n743YbfKQqscjgfb3PgwYTjChnV1oPMwfdlNHKMBRTE5QIwtXhFF3rsYYxc6
         tdLDxQSMGWdHrgM+shWMXS8G/wve/fgHUyrMgQLwumNV0k9xmvnxTTLBqas81HMZ0IAx
         AnOTg1xfrgqWVVEoLVcvgTkltRkUf2DFcudsxEIR8BKMkdDBu63Vpa1jHwdTYXDr53qT
         f0/g==
X-Gm-Message-State: AOAM531+kBnI+KFqqo86kn3pBjs5nEX0NNU0ya6zm1u50+X7AXy3WPGB
        XH93TapARthy3kYiGLYyGj2JkgYVGKnY2XX76vP1+yee5Ei2ZLTRoZw/C0WDgmpoSJ2+GZ6Ozld
        zZWCXfLrVatu1T10CDpsSSGWPVWYK9yDb547zuMcSt8H/wQicRFoPiwm7b/of2PLDzruZ
X-Google-Smtp-Source: ABdhPJzgqtw43v45mJXkuxwP+R7F6PJ9NgHb/ICm4vkdR7HBh+oNRA6ay09pFFHDGSpgjOQKsS32hA==
X-Received: by 2002:a63:de55:0:b0:374:2526:3596 with SMTP id y21-20020a63de55000000b0037425263596mr7136050pgi.592.1645810975851;
        Fri, 25 Feb 2022 09:42:55 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id h2-20020a656382000000b00370648d902csm3203805pgv.4.2022.02.25.09.42.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Feb 2022 09:42:55 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v7 1/4] page_pool: Add allocation stats
Date:   Fri, 25 Feb 2022 09:41:51 -0800
Message-Id: <1645810914-35485-2-git-send-email-jdamato@fastly.com>
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

Add per-pool statistics counters for the allocation path of a page pool.
These stats are incremented in softirq context, so no locking or per-cpu
variables are needed.

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
 net/core/page_pool.c    | 24 ++++++++++++++++++++----
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 97c3c19..1f27e8a4 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -84,6 +84,19 @@ struct page_pool_params {
 	void *init_arg;
 };
 
+#ifdef CONFIG_PAGE_POOL_STATS
+struct page_pool_alloc_stats {
+	u64 fast; /* fast path allocations */
+	u64 slow; /* slow-path order 0 allocations */
+	u64 slow_high_order; /* slow-path high order allocations */
+	u64 empty; /* failed refills due to empty ptr ring, forcing
+		    * slow path allocation
+		    */
+	u64 refill; /* allocations via successful refill */
+	u64 waive;  /* failed refills due to numa zone mismatch */
+};
+#endif
+
 struct page_pool {
 	struct page_pool_params p;
 
@@ -96,6 +109,11 @@ struct page_pool {
 	unsigned int frag_offset;
 	struct page *frag_page;
 	long frag_users;
+
+#ifdef CONFIG_PAGE_POOL_STATS
+	/* these stats are incremented while in softirq context */
+	struct page_pool_alloc_stats alloc_stats;
+#endif
 	u32 xdp_mem_id;
 
 	/*
diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0..6b78f69 100644
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
+	  Enable page pool statistics to track page allocation and recycling
+	  in page pools. This option incurs additional CPU cost in allocation
+	  and recycle paths and additional memory cost to store the statistics.
+	  These statistics are only available if this option is enabled and if
+	  the driver using the page pool supports exporting this data.
+
+	  If unsure, say N.
+
 config FAILOVER
 	tristate "Generic failover module"
 	help
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e25d359..0fa4b76 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -26,6 +26,13 @@
 
 #define BIAS_MAX	LONG_MAX
 
+#ifdef CONFIG_PAGE_POOL_STATS
+/* alloc_stat_inc is intended to be used in softirq context */
+#define alloc_stat_inc(pool, __stat)	(pool->alloc_stats.__stat++)
+#else
+#define alloc_stat_inc(pool, __stat)
+#endif
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -117,8 +124,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	int pref_nid; /* preferred NUMA node */
 
 	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
+	if (__ptr_ring_empty(r)) {
+		alloc_stat_inc(pool, empty);
 		return NULL;
+	}
 
 	/* Softirq guarantee CPU and thus NUMA node is stable. This,
 	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
@@ -145,14 +154,17 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			 * This limit stress on page buddy alloactor.
 			 */
 			page_pool_return_page(pool, page);
+			alloc_stat_inc(pool, waive);
 			page = NULL;
 			break;
 		}
 	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
+		alloc_stat_inc(pool, refill);
+	}
 
 	return page;
 }
@@ -166,6 +178,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	if (likely(pool->alloc.count)) {
 		/* Fast-path */
 		page = pool->alloc.cache[--pool->alloc.count];
+		alloc_stat_inc(pool, fast);
 	} else {
 		page = page_pool_refill_alloc_cache(pool);
 	}
@@ -239,6 +252,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	alloc_stat_inc(pool, slow_high_order);
 	page_pool_set_pp_info(pool, page);
 
 	/* Track how many pages are held 'in-flight' */
@@ -293,10 +307,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
-	else
+		alloc_stat_inc(pool, slow);
+	} else {
 		page = NULL;
+	}
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
-- 
2.7.4

