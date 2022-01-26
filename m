Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7794349D5B6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiAZWvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiAZWvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:51:54 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5396FC06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:54 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id q75so641435pgq.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nMhyZuz5FFHXx6SDIWuWD353Ivk0f2F3J9m8oxhLKhE=;
        b=gFacH/DvGsMLVHix1oTy7Hmcnj6Vq+NTq8Ao+Ul1QiTURmSY31geJXe5C3LxzkJigh
         AwyT/X9otwhOvh7eqghURSEDQmTYdbG8PTSfNMaAX7pVSYw9tFpo+J6AoBP4F51LelrF
         EyfwrU3i+5u9/TFHgcPz1cWdsyOuvcwmvP0is=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nMhyZuz5FFHXx6SDIWuWD353Ivk0f2F3J9m8oxhLKhE=;
        b=1rux8G7iMmsXvsmMy+uU/IXLF7e4k74T4s+3jH92+lvzdj28Nc+x2CQ+XJgROUfV4T
         1zBw/H2y6N4w7faqHvzH3BfOMyZWkfe2hmOecwN8MTJkdwx2fEL7PLVnxSK2++tS35/S
         W1T93DTmCEIKIL5cSd/2e2FwVe/Zn2mqdXrhNea68XZ6JAJfXHOl4zQsq9a3dzKWtEq4
         g83+Q+QM9wqESKSZkCM9JG61gEEpUhevdTvVExbE4ruF3hBHu7J2/rtYULSgL0o8xbDH
         W34CEXtEbm59/iePEWluZ1aJsxtb8ewuqArWdKM63bJC+RxQORFklIBHm5GON/ifMLIN
         tDpQ==
X-Gm-Message-State: AOAM5320PkzyDzyfYmvMdnIpAyMUNwnFBQiZq/Fozqk7WJMMNR3Gxj4b
        qJwM0sacMNZRFLZ7VP/Ujq/rYRDeCFVM7YFDB9GcPrZZB2KocdWWs7fFJ3nmeNM2ovWI7t4Xsgi
        T+eXWPK9ra7y5zfwSNGYpLUKLuFxBik7Mx20Qdm6+ZYjBB+bXMJ8eenTIYuJoxiZ2Pu/8
X-Google-Smtp-Source: ABdhPJze0ZxXHOjMTsRUtq4X/VQGhmFqHLmTsaROLnTdEqmfo7g8ivgM7DlJXGTYCUjMDpY/lHWuMw==
X-Received: by 2002:a05:6a00:244b:: with SMTP id d11mr429376pfj.49.1643237513424;
        Wed, 26 Jan 2022 14:51:53 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q15sm3793941pjj.19.2022.01.26.14.51.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 14:51:52 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, ilias.apalodimas@linaro.org,
        hawk@kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [PATCH net-next 2/6] net: page_pool: Add a stat for the slow alloc path
Date:   Wed, 26 Jan 2022 14:48:16 -0800
Message-Id: <1643237300-44904-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat, 'slow', for the slow allocation path. A static inline accessor
function is exposed for accessing this stat.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 10 ++++++++++
 net/core/page_pool.c    |  6 ++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3ae3dc4..b5691ee 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -82,6 +82,7 @@ struct pp_alloc_cache {
 struct page_pool_stats {
 	struct {
 		u64 fast; /* fast path allocations */
+		u64 slow; /* slow-path order-0 allocations */
 	} alloc;
 };
 
@@ -201,6 +202,10 @@ static inline u64 page_pool_stats_get_fast(struct page_pool *pool)
 	return pool->ps.alloc.fast;
 }
 
+static inline u64 page_pool_stats_get_slow(struct page_pool *pool)
+{
+	return pool->ps.alloc.slow;
+}
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -225,6 +230,11 @@ static inline u64 page_pool_stats_get_fast(struct page_pool *pool)
 {
 	return 0;
 }
+
+static inline u64 page_pool_stats_get_slow(struct page_pool *pool)
+{
+	return 0;
+}
 #endif
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 84c9566..9dbe721 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -294,10 +294,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
-	else
+		pool->ps.alloc.slow++;
+	} else {
 		page = NULL;
+	}
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
-- 
2.7.4

