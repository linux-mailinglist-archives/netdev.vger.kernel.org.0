Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCE949D5B8
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiAZWv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiAZWv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:51:57 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ED2C06174E
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:57 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so5681543pjj.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qPqcIeRdK7gzpY5MRRAybRjZA49mLbpIBffMOLgY4GY=;
        b=K91YmoyfRccw1UBHpYCrzF5VNEwAVJzTObalIy6PirCBPJRnjI69o9fpqV3Jqn8UrE
         Y50JyGxRmb3+Hq9o5A6Lq3BIPBvbBGp/cPLt9M5Z5MrQ64rlUwJIOVju7J4iaVL4L8HJ
         2xH5xWotQ7iRCOVT1v+hK+q7nmwPVktT5WLAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qPqcIeRdK7gzpY5MRRAybRjZA49mLbpIBffMOLgY4GY=;
        b=Rgugh3FjeBXAQLW8uA0WL2/5K4JNZADAVwoBtzuFu2kXVpNx5a5eMJT97ut8RHzvKv
         VrWZgWdoiEpdfT4P59+MpUPx6IXBMRi8X45gLKRwMr5K0DMf2qvdKE15TyOADu0TXP3j
         AMi750YrNYxxoiJw3S9tLi2ozRdZNgI91kUIbrpS1wPWJFa1CtAh28pCOYCrz1t6MK4O
         /uCpJYVwUqm/v6InpGF/XrcTZ93TQEVKKBpDicJznPjOqQK3SnMYq/CklncYhdgDhDHF
         dDpdvj85WsmKvp8yV+nAl2AjfLvC4QxlJSdUEUf5h8xoY5qw48RQfQvaRN0cUH3Nbwl9
         AN4w==
X-Gm-Message-State: AOAM530m/M/VIQUG5ensSp7+EY5OmgdWf1b8P34S9UhToFpNe+Jv6I2w
        XozPzJaE79fokJcTu+Y3DOxsmWdtgjT1jI7K3DS4mWuhw4vf8wVjdh02shcvAnUXaCx0bM7RQVc
        q03BVep8Od1BiVUqnGJV4AZXxTEBI++e6sc9vE2HVSSrmacJwRVziWkydnnZuxCLsUuR/
X-Google-Smtp-Source: ABdhPJzEUwKG6lSvbH62KBukEw+pLylbraJG1AK1iGKdDOolqRiA945M2Kr5f0vL863051UPRsKgdw==
X-Received: by 2002:a17:903:32ce:: with SMTP id i14mr608610plr.66.1643237516340;
        Wed, 26 Jan 2022 14:51:56 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q15sm3793941pjj.19.2022.01.26.14.51.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 14:51:55 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, ilias.apalodimas@linaro.org,
        hawk@kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [PATCH net-next 4/6] net: page_pool: Add stat tracking empty ring
Date:   Wed, 26 Jan 2022 14:48:18 -0800
Message-Id: <1643237300-44904-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat tracking when the ptr ring is empty. A static inline wrapper
function is exposed to access this stat.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 15 +++++++++++++++
 net/core/page_pool.c    |  4 +++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b024197..92edf8e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -84,6 +84,10 @@ struct page_pool_stats {
 		u64 fast; /* fast path allocations */
 		u64 slow; /* slow-path order-0 allocations */
 		u64 slow_high_order; /* slow-path high order allocations */
+		u64 empty; /* failed refills due to empty ptr ring, forcing
+			    * slow path allocation
+			    */
+
 	} alloc;
 };
 
@@ -212,6 +216,12 @@ static inline u64 page_pool_stats_get_slow_high_order(struct page_pool *pool)
 {
 	return pool->ps.alloc.slow_high_order;
 }
+
+static inline u64 page_pool_stats_get_empty(struct page_pool *pool)
+{
+	return pool->ps.alloc.empty;
+}
+
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -246,6 +256,11 @@ static inline u64 page_pool_stats_get_slow_high_order(struct page_pool *pool)
 {
 	return 0;
 }
+
+static inline u64 page_pool_stats_get_empty(struct page_pool *pool)
+{
+	return 0;
+}
 #endif
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3a4b912..0de9d58 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -117,8 +117,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	int pref_nid; /* preferred NUMA node */
 
 	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
+	if (__ptr_ring_empty(r)) {
+		pool->ps.alloc.empty++;
 		return NULL;
+	}
 
 	/* Softirq guarantee CPU and thus NUMA node is stable. This,
 	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
-- 
2.7.4

