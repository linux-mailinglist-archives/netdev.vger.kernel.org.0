Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D1D49D5B5
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiAZWvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiAZWvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:51:52 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26CCC06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:52 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y27so1031693pfa.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iQtOf45R3wZ6d5P0weFxN9wE1JYLlAX2zbCnJw9CZhM=;
        b=uZodQ9s9Q9ttLoSgg4ImwQeMBABj/XtrTosuhH1UzwQ+Xmxr3W6XJc1qN1tQiKF7AH
         JjDVUM1m9xZ207obycYRP3/Ze+Z48zuIdwsPxDzjqh5MU2LlmMworC5iaXOLPGcYx05/
         XdF0XnaaUBmjDnsh1vNXQYHP87X+sUbMiPuTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iQtOf45R3wZ6d5P0weFxN9wE1JYLlAX2zbCnJw9CZhM=;
        b=hWFkvJXN61Ez74MGGh4CnenUXaUtI3n5KtKTI3e7elEJDQxRsqVVx1lWlBRB5t0UsU
         +DtWeHXNb4iVRjr9gQJvYc4bFIoBa6/fQQttevW3zn13UALb+r5iqJYaD1jPNo6WYdw2
         kukrre/pXsABKZ4zL2S/RiGC8Ei5mMJQ8TcbjnHyM99J7lNk54oLJpEb5BKfgepjqjDk
         YK+i+OTGdtoHOx8NPtkzp3VtrMGIo7fz5gGde/alkojUuptJvo+f3Cc2ZGHGIJuLYSuu
         GVedyeobf3U7NEDsVGr6KbbWdcE19wcjOBrE/a1hnM7i1r7ue1kv8d8tIK0Dos42HM8V
         9ZXw==
X-Gm-Message-State: AOAM530FgA110eFtgMEYlJbO+7iTlJrvrooYkK80ZkdCzjaiY1m6AxQI
        mVnuqeqXC2paH8z4JR+BfAydpP0ykAE6Vfk+nxNenvonHA86UjogGhGdZCRhBQsl50JDFpsbqlo
        rjUyrD4MXhDhNkaga5dSabMUFb3ou0c5pTQVHHaLwKyjt9j1dQljJrwklJv4pBbZHslF3NBw=
X-Google-Smtp-Source: ABdhPJw8cP0R8iktyV3pTZTIucneKY3NFslkyEYd8mQwH2ACJ8ZvYZyqR8vymH/y7i+DYspvmQjdiQ==
X-Received: by 2002:a63:50f:: with SMTP id 15mr788419pgf.186.1643237511832;
        Wed, 26 Jan 2022 14:51:51 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q15sm3793941pjj.19.2022.01.26.14.51.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 14:51:51 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, ilias.apalodimas@linaro.org,
        hawk@kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [PATCH 1/6] net: page_pool: Add alloc stats and fast path stat
Date:   Wed, 26 Jan 2022 14:48:15 -0800
Message-Id: <1643237300-44904-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stats structure with a an internal alloc structure for holding
allocation path related stats.

The alloc structure contains the stat 'fast'. This stat tracks fast
path allocations.

A static inline accessor function is exposed for accessing this stat.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 26 ++++++++++++++++++++++++++
 net/core/page_pool.c    |  1 +
 2 files changed, 27 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 79a8055..3ae3dc4 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -71,6 +71,20 @@ struct pp_alloc_cache {
 	struct page *cache[PP_ALLOC_CACHE_SIZE];
 };
 
+/**
+ * stats for tracking page_pool events.
+ *
+ * accessor functions for these stats provided below.
+ *
+ * Note that it is the responsibility of the API consumer to ensure that
+ * the page_pool has not been destroyed while accessing stats fields.
+ */
+struct page_pool_stats {
+	struct {
+		u64 fast; /* fast path allocations */
+	} alloc;
+};
+
 struct page_pool_params {
 	unsigned int	flags;
 	unsigned int	order;
@@ -86,6 +100,7 @@ struct page_pool_params {
 
 struct page_pool {
 	struct page_pool_params p;
+	struct page_pool_stats ps;
 
 	struct delayed_work release_dw;
 	void (*disconnect)(void *);
@@ -180,6 +195,12 @@ void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
 void page_pool_release_page(struct page_pool *pool, struct page *page);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count);
+
+static inline u64 page_pool_stats_get_fast(struct page_pool *pool)
+{
+	return pool->ps.alloc.fast;
+}
+
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -199,6 +220,11 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 					   int count)
 {
 }
+
+static inline u64 page_pool_stats_get_fast(struct page_pool *pool)
+{
+	return 0;
+}
 #endif
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bd62c01..84c9566 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -166,6 +166,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	if (likely(pool->alloc.count)) {
 		/* Fast-path */
 		page = pool->alloc.cache[--pool->alloc.count];
+		pool->ps.alloc.fast++;
 	} else {
 		page = page_pool_refill_alloc_cache(pool);
 	}
-- 
2.7.4

