Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3463F4A6985
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbiBBBNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243618AbiBBBNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:14 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A14C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:14 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h125so29885pgc.3
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5DfdEyld7StyWrFrpQh0H8+Y2uMglsDtEWNNoHSX1Uo=;
        b=ZEhyiEoV/fR+sTr6984edWTDMi2uhk43lxKsyNeXBxMz08Yd05wndjzxr97k316uFP
         XeydJTa86Tjg88VszGOl2rGSHgq6MM6bHFGDw47ox7nWch5l4jKyzJzQp9/KlEfl0bx8
         OE3lWvxQfAm5RcBeNPWFWwZln5GDFqCM7hjY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5DfdEyld7StyWrFrpQh0H8+Y2uMglsDtEWNNoHSX1Uo=;
        b=cGIz1vOJMJzGP/As9Jlrk8DuloQRkX7bOtFHLrawjby2u851SeWpt019jz5lLOGWUn
         hHqn1yoz0qbpQ8WQhAzRye9JKNLyNs+V28/OUQs4bSJZWxtjbRGHIIEu+WdZ9kuCN7lk
         MjzomkiVQLtJYTAUNu/kz4tVAOw0yk2n5JD+i+IXY+q7iyrNEWB8/Q7NpexDgSC7/8pB
         KAPM+5Sak3ZGC8i6N/b3S0FKBsEpowy7VakKrVXzC2rfoPOByCKJcbETeEFAMZiP0Nbi
         MyNpYhyua+VeVMCJVyDP68Y/xueMsNv4liUdb8AM0CZsOrftybAHG5uI/a7AlNboVGyP
         xGEg==
X-Gm-Message-State: AOAM533fdf1v88FxwYjGJgj4XSigM5XT2rO6u7ocXLVEj7BqZN9egCQl
        oaPcVglw8JTHKoveJHBFftZhWVqgAu5vy1YS6Rv6tDQTGs7S1oJHzMQCfPTY3BHly5CIRzIWyr5
        wd7733i+bZZIn2WiV89hior9p22nrDBRpQbalHRlkq05Iz3Za+yayeZzXZLzSO46iWbb7
X-Google-Smtp-Source: ABdhPJxK68SehvkETpaUFSob1E0Yg9F8bw8eTKsPtsy+F1i4zzEy4dUQSrD45Lk8RBebM0jzRWY3YQ==
X-Received: by 2002:a63:451f:: with SMTP id s31mr23324271pga.114.1643764393553;
        Tue, 01 Feb 2022 17:13:13 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:13 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 04/10] page_pool: Add stat tracking fast path allocations
Date:   Tue,  1 Feb 2022 17:12:10 -0800
Message-Id: <1643764336-63864-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
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

