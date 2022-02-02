Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939DB4A6988
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243648AbiBBBNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243640AbiBBBNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:18 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB08FC06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:18 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m7so1777685pjk.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EZpuFdvqL88AwGUcDLPACkayKgEAfVa9VWvyXah0H48=;
        b=QIQzUc6LtwNh+fcBFc5+8IA9tEO5cmzJXKydYi1vKAl6FRLug0ridTNbC7Qms6zcy4
         9h/mPBXdOPsmI3RxDl50UA3ANDilBMI4lOOJL5oCZyw+rnfK/oZOSskNeyNiFrPTj+q8
         A9O2MSVaJq9WXFyCvL1X32rqxYj+Ai4CcpncQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EZpuFdvqL88AwGUcDLPACkayKgEAfVa9VWvyXah0H48=;
        b=vt4+AvuwrD5kGtFM3hxluOK0Jon7NqyPTvwLJB2ZJAnbbWmD9thnFlOePFAPkfxNsh
         A47RLzxpnyGQEFaABsfHcVXY38oKOlclf2MMcxx9WDO3BuigiH5Mjtfx/HYp26Q1gAEH
         f0SqXfXwIsbgXgLADrj9oRQszXvXJncYor7Af7vRf2XB3H/gOC4dlblAoJOz3cuAkhxL
         q4KV5vTh9pKdr1FU0DnjjMeYJb8gR0J0Ula1KVgABNh9ZMxQXPGOsruQQpJmg+xOmcDV
         5IUdBxwHpHMTOGvfGXdgT1akmsT/ws6w2IiQYaU1e5MGrOC2dHWYwoD2FCZdDZzxsAG9
         pFcw==
X-Gm-Message-State: AOAM5311eaFI+c6V20PiAAdyYyuIslRDoeEoWYlvpJyF+mWM5V6Zx5c0
        dsfCNTNw3RnNbv32/G07jjilPbN5cY89mzaT1edVvlx3vAMD6eDvMAR3fbqucZKhUH22ozp0ZYs
        5dkn7lZGGw/cZ1G52vobY/ZjhDedsLqgVt+VpcTYgbKtIl4YhlxOQYKII7bo76RANCKO7
X-Google-Smtp-Source: ABdhPJyZPNeizD5oS7CtGiKdT+Jhk9gCEEIhwdSo4laSIaW6LlWzeEljUfiMzy1i+lO302xfDTisAg==
X-Received: by 2002:a17:90b:1c0e:: with SMTP id oc14mr5533501pjb.2.1643764398006;
        Tue, 01 Feb 2022 17:13:18 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:17 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 07/10] page_pool: Add stat tracking empty ring
Date:   Tue,  1 Feb 2022 17:12:13 -0800
Message-Id: <1643764336-63864-8-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat tracking when the ptr ring is empty. When this occurs, the cache
could not be refilled and a slow path allocation was forced.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 3 +++
 net/core/page_pool.c    | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index f59b8a9..ed2bc73 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -146,6 +146,9 @@ struct page_pool_stats {
 		u64 fast; /* fast path allocations */
 		u64 slow; /* slow-path order-0 allocations */
 		u64 slow_high_order; /* slow-path high order allocations */
+		u64 empty; /* failed refills due to empty ptr ring, forcing
+			    * slow path allocation
+			    */
 	} alloc;
 };
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 24306d6..9d20b12 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -131,8 +131,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	int pref_nid; /* preferred NUMA node */
 
 	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
+	if (__ptr_ring_empty(r)) {
+		page_pool_stat_alloc_inc(empty);
 		return NULL;
+	}
 
 	/* Softirq guarantee CPU and thus NUMA node is stable. This,
 	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
-- 
2.7.4

