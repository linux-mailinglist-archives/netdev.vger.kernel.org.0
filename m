Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E044A32A7
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353454AbiA2XkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353451AbiA2XkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:10 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4175C061741
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:09 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so8673342pjb.5
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5DfdEyld7StyWrFrpQh0H8+Y2uMglsDtEWNNoHSX1Uo=;
        b=gaESIkclZWnWP67b8XocjXdfrgEqYGcIF2PUxbuovu52gXsAU+ol5/vJg+wA4PBH7s
         QaUxhStioE9ukZgotQndKH1jQnYZ/xxu4W/BhZg2oiBQVhXB+ZKX+ck12Lhe58m5AQcu
         g+Po1IWMOTwGUirdyLm6TDz44oPQlrkXFYPu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5DfdEyld7StyWrFrpQh0H8+Y2uMglsDtEWNNoHSX1Uo=;
        b=kRmY2YP/lk2HHryoxku/i29vSlg/lTHVa0IcZEbdEyeCgE7Ucda1M3bWtWA7Of6UbG
         mIpj62btUjx6fAAweQ/MsfhUtKOSB+o3I1uuDPMpuIwqNDusYkd0yGzJYtptk7YzwQ2e
         r2vw6LaVvozUd+9+2DLFcHQYlr0DaxxExR6+ZhRLmbI3/nHdCN7hSdNI7YPEc/259GzO
         UtzcW0GK4UVHmk38sLjRPARXKerDcsc+sWN59ckPfEdHBId1OUuUv3UmeYI+Z7LCQDX1
         r4KgPxgpYwKEzYA7ZegZvPBw4wK54mT7Ef/tGynUggDyKjSQEi3x6ex8MFNy8hZoz3pE
         mdRA==
X-Gm-Message-State: AOAM530Dr7qAmW6rlJ+RtPJdDMj2eb2+hJZBk6w0f1SNEvkmBq6nsdDD
        U9DMUqvKCKHJZIqnQrOKXVUMf5mFaDy/7C/IJgvVTpJOvS5f44t4XNf/mssBAd5zBsnpaMnUU+q
        TihbGWTZUVOVhFeGVUuQXS34CnwUFLPTiv63pTTejBx+SZtn/nbj1KY2peNfTb7uHIqbO
X-Google-Smtp-Source: ABdhPJz1xIttczSbe4Nq5We3OJoNLXyut6taib8t5UQ+uAKlGeBCVNANLSaXqSaINNAKYO2QQ+Tsnw==
X-Received: by 2002:a17:90a:601:: with SMTP id j1mr27292526pjj.192.1643499608831;
        Sat, 29 Jan 2022 15:40:08 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:08 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 04/10] page_pool: Add stat tracking fast path allocations
Date:   Sat, 29 Jan 2022 15:38:54 -0800
Message-Id: <1643499540-8351-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a counter to track successful fast-path allocations.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 3 +++
 net/core/page_pool.c    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index dae65f2..96949ad 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -142,6 +142,9 @@ struct page_pool {
  * stats for tracking page_pool events.
  */
 struct page_pool_stats {
+	struct {
+		u64 fast; /* fast path allocations */
+	} alloc;
 };
 
 DECLARE_PER_CPU_ALIGNED(struct page_pool_stats, page_pool_stats);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b1a2599..6f692d9 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -180,6 +180,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	if (likely(pool->alloc.count)) {
 		/* Fast-path */
 		page = pool->alloc.cache[--pool->alloc.count];
+		page_pool_stat_alloc_inc(fast);
 	} else {
 		page = page_pool_refill_alloc_cache(pool);
 	}
-- 
2.7.4

