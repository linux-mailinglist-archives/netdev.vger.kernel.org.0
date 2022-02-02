Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C2D4A6983
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbiBBBNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiBBBNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4750DC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:12 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so4409027pjb.5
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5MPwYILWWDHRKPtSihChctU6rXVQMQ9CjUeZyzwHNXA=;
        b=qsDBl+ImIGCU5q7Gu7kENCYbyFg5c8Uq5cT+hZqUhVQmZ1UW5kguipJjyGQH4owHJS
         cpLup4UCa7YNFHasPmAlB/JcdXXdErJWWKybNH3XGUUANv/T09bqdlKLD9vygubD1wHj
         RC8j+ASDIMTcuS2J1WfYBrJV7Vi1eKi2GI6E4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5MPwYILWWDHRKPtSihChctU6rXVQMQ9CjUeZyzwHNXA=;
        b=pIAC8kiChOC2bXRu5J5KxT9XBzJoTGFRfivzEyp3vTycyI1IfHl86yyvBNM/Sz7jTF
         AeJgXNYrqw6AcoHKYLv3nsVoF+Gn8NTykpjR7B+lMqr7uh1wFCIyd+lTLx7zHgHDVZxd
         kceBBr+ZXPIWJwtyso+7Rj6IKk8KPt9Ci88T96Km0g80CIUjD1+sFWt3uA9pA9SGozcN
         yE1DDYf1dSjO6FpTiWS+oWeBoppdzb3sPUQclaFHj/GhkazgVoVkIMsC3FnqcBMvJlLH
         ++5tvl58upLpON1Xw2RIkHtZu2zFzvTdVYCbyrEC3gjaSSy9bHjf0y5rXexYGAiwS4Mh
         msMQ==
X-Gm-Message-State: AOAM530w28GLvCsGG4Vnob8MURSPjN9QXjJeWJMmYSHURCEExUt6k/Jp
        3/SGmGnZaWEF1uqzlwLMGw3PaF1edMOwRrI17L6QcqeOo4JOH06om30qC5i387i/dbQGEQ0R4vd
        XnRDMU5H8Skwt9W8q3JAdBBDh0VPbocD0qxWTTEqAl2xyLqR0OGb4DYggUE10PIZB1wXI
X-Google-Smtp-Source: ABdhPJzLTDIGuxBDwuZeeL509TnDm450ROwO5S7iMtZhClC4AdUtZ5Gx1iqX1cFjCUeyIHT0XNlSMQ==
X-Received: by 2002:a17:902:c40e:: with SMTP id k14mr28151740plk.103.1643764390679;
        Tue, 01 Feb 2022 17:13:10 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:10 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 02/10] page_pool: Add per-cpu page_pool_stats struct
Date:   Tue,  1 Feb 2022 17:12:08 -0800
Message-Id: <1643764336-63864-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A per-cpu (empty) page_pool_stats struct has been added as a place holder.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 10 ++++++++++
 net/core/page_pool.c    |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 79a8055..dae65f2 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -137,6 +137,16 @@ struct page_pool {
 	u64 destroy_cnt;
 };
 
+#ifdef CONFIG_PAGE_POOL_STATS
+/*
+ * stats for tracking page_pool events.
+ */
+struct page_pool_stats {
+};
+
+DECLARE_PER_CPU_ALIGNED(struct page_pool_stats, page_pool_stats);
+#endif
+
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
 
 static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bd62c01..7e33590 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -26,6 +26,11 @@
 
 #define BIAS_MAX	LONG_MAX
 
+#ifdef CONFIG_PAGE_POOL_STATS
+DEFINE_PER_CPU_ALIGNED(struct page_pool_stats, page_pool_stats);
+EXPORT_PER_CPU_SYMBOL(page_pool_stats);
+#endif
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
-- 
2.7.4

