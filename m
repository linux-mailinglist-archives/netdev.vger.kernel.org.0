Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107104A917C
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356177AbiBDAK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356170AbiBDAK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:58 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BB4C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:58 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k17so3716994plk.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ScV1ERUG3Ixu+E+3BKVttUnEioUhWPrRv8BPsk+uOyQ=;
        b=usenASrIkXC0PfZh6AkInjk5ZqaHjfvG12Bq4gBloMmI+hbiyvm+T7QnUqn6jYpMo7
         46fZk9zbp4qqXN3aEYEsH8T77ZCA1gv4nJ2rvsAZ8+Iy05o7D3sBMNJW4tfxmE9ruzqG
         41tgfCEoFiAaOCU0nPXN9GbBCJdqMGrwo5RGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ScV1ERUG3Ixu+E+3BKVttUnEioUhWPrRv8BPsk+uOyQ=;
        b=unyMbQXcMahtME9IsDwBmcY2blhfF1c1nJXI0OsMy8mBmjQaL+Ov0CCM82JKlXaBFT
         71cRd67GEcivUrkBpUNQEqwBx/cOICymav1/DcouotRFvAH96+f/T63rIWjfMtgE5nnG
         /sPkSBVngsrvpMNOb7OAO//0SMhBxYzeWYAU3PaWkDov9F2mHDJGkR92y8wCrQbS2sxN
         xtyrpAyt3FXELFQnZzuGZjmk/p4pnfGsG6qKdv/sI2YFoGquFTSIQ0GdZDXu6Lxk8Wzl
         4U4XolTdGXp5T5pnf/EPNBdaeT9/BN4o1ZMD/PD53P6xFYD0B9/dV7HCC6+zep+CbOcO
         Gc6A==
X-Gm-Message-State: AOAM530ufsTwxjcHYej/hDkY0LX/BdZAvJuvroPFUig98C2ZBJH98SFF
        zXk0aBn3qXzZTkW7Ovh1KqmamNMNNnFbDha5D2KDeZA3Kya5NsPMdrTti25B1vtDdT/ZEixWI/D
        g2dfcySKnQCP//EPXKJceUbVIt4nSfY7iGtX6L7E4BjxhBzoSh8pa8Y8BAevMa/PKQ8f9
X-Google-Smtp-Source: ABdhPJyOa8tEPZwlM/ThG+wBmDTaAuGm3iUZn7FcgTF2/Bd8UIJ5KM5oV54IcbpBgNuUlczXrgTglg==
X-Received: by 2002:a17:90b:3698:: with SMTP id mj24mr223195pjb.220.1643933457178;
        Thu, 03 Feb 2022 16:10:57 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:56 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 09/11] page_pool: Add stat tracking cache refill
Date:   Thu,  3 Feb 2022 16:09:31 -0800
Message-Id: <1643933373-6590-10-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat tracking succesfull allocations which triggered a refill.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 1 +
 net/core/page_pool.c    | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b243480..65cd0ca 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -149,6 +149,7 @@ struct page_pool_stats {
 		u64 empty; /* failed refills due to empty ptr ring, forcing
 			    * slow path allocation
 			    */
+		u64 refill; /* allocations via successful refill */
 	} alloc;
 };
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b25ded1..4fe48ec 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -172,8 +172,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
+		this_cpu_inc_alloc_stat(pool, refill);
+	}
 
 	return page;
 }
-- 
2.7.4

