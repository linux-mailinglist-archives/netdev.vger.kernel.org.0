Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A64049D5B9
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiAZWwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiAZWv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:51:58 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD587C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:58 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p125so657662pga.2
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kXjN8WFwgBGK9vxvsU06qWyzmb8YpuggPizN+CnYy/s=;
        b=nusDvUkuRA8UlDGQyEfEhdBV6QctFDrPVMbzEojRnJQuG6ffW/DxBWYYP3psxKREhH
         AxvUlIeKtg8UgmrtJWUFMCEbZ5LUEl3ukqoT6EYP0ujn8EYHuFKCFjoOpIbp3SL/EUyX
         qStPIIXCmmrwnZ4Jtn3ysTa3Jipph4qsDGFsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kXjN8WFwgBGK9vxvsU06qWyzmb8YpuggPizN+CnYy/s=;
        b=bxh/IuD5WJ0UdkFDzbNqw7jpWvuC2v6Sygg+ya7r8r4EJWbo/6oKFCF5ZGet7XMOs3
         FEDuUmjDTAKC4DrYBK+TAHzJxmsgi+B6zoN7/E+aDga68QUAXwQB4NDMBgJw5LMgogLY
         LIJYsSwtn2EjY/HqX7G7KjGY7r8n2S4txgnOdu9x2LaRkIa9wQzC6EDqFsgpl++sACvO
         pN/Y9llfb7KrE1LfVDBsSScPnWZTjj0nuKMdHkevWUXDjZ84oPsvk+OntRsVSU9Hd5wA
         IWeiSjsrYDHAfjWp0ZW7SrGZFrMMbQIKqBSoQUXUK0D7w6TmwbhDY5kHTXZi7GAtuD2H
         7aLw==
X-Gm-Message-State: AOAM532bq6g9vB4+Zw8SasNT/1pH53cycH9CdqC4qguD3Vfx8nFP+yB5
        E2K5LPq0ixQGMS+xWOKQ5zbETkzhjC/fShq8gop2UKQwlscy0E8IwPHWfetU6DD2CPWueZ79Vut
        O31nDBRXKsvYoTrZk2GqV+jscstfYMDCoqrj7ux0ejmdpBWzsDefCR5oOUWZjvUteNoXb
X-Google-Smtp-Source: ABdhPJzj0C8b2ZLXg2hgDSY/maWIJ3u1ure/4x28nHAcgnPRaut5SaOcpbPrE2ZH+o/WoEnT5UtJbg==
X-Received: by 2002:a63:9044:: with SMTP id a65mr748155pge.594.1643237517895;
        Wed, 26 Jan 2022 14:51:57 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q15sm3793941pjj.19.2022.01.26.14.51.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 14:51:57 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, ilias.apalodimas@linaro.org,
        hawk@kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [PATCH net-next 5/6] net: page_pool: Add stat tracking cache refills.
Date:   Wed, 26 Jan 2022 14:48:19 -0800
Message-Id: <1643237300-44904-6-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat tracking succesfull allocations which triggered a refill. A
static inline wrapper is exposed for accessing this stat.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 11 ++++++++++-
 net/core/page_pool.c    |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 92edf8e..a68d05f 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -87,7 +87,7 @@ struct page_pool_stats {
 		u64 empty; /* failed refills due to empty ptr ring, forcing
 			    * slow path allocation
 			    */
-
+		u64 refill; /* allocations via successful refill */
 	} alloc;
 };
 
@@ -222,6 +222,10 @@ static inline u64 page_pool_stats_get_empty(struct page_pool *pool)
 	return pool->ps.alloc.empty;
 }
 
+static inline u64 page_pool_stats_get_refill(struct page_pool *pool)
+{
+	return pool->ps.alloc.refill;
+}
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -261,6 +265,11 @@ static inline u64 page_pool_stats_get_empty(struct page_pool *pool)
 {
 	return 0;
 }
+
+static inline u64 page_pool_stats_get_refill(struct page_pool *pool)
+{
+	return 0;
+}
 #endif
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 0de9d58..15f4e73 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -171,6 +171,8 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 		pool->ps.alloc.fast++;
 	} else {
 		page = page_pool_refill_alloc_cache(pool);
+		if (likely(page))
+			pool->ps.alloc.refill++;
 	}
 
 	return page;
-- 
2.7.4

