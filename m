Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C063549D5B7
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiAZWv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiAZWvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:51:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C84C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:55 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id i1so878038pla.9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pToh2wvYgYPrpKDxpymUchJpPok83K1wHJc2NYkaSuE=;
        b=lGyLwI0Iv8Imyx1xxIMX9LmDAXxbPapefd2E4ssjwVVbN34T93amq/LbgoOdc5TvJq
         AlMYt8EihMMvL60Wp8LaIoZ/hUFcEev0P4X9KLh4W9v+0ERI79/iMBwRdNG3lbGyG5L/
         AW6ZxtrwiKdhHsjpdD70In9PxwQ/3rQmqX/7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pToh2wvYgYPrpKDxpymUchJpPok83K1wHJc2NYkaSuE=;
        b=4zNznP/BVWo5MMg2W5UASbzAYw1SbIgtVIL3tZUqkfhHNoCQ9RN/Hr/37xyQ7BEgbg
         YRgO08Sbhg1WEwFc1iWRpTSzqqhcqW5J4+lJ8nPhTupvv8u7YhsbNoWJR4w/MVOFg/U0
         nmHsdw+wU8V0EfdcsaeeNK9zQbnBTygOx+HRxItnGKkvOh/JRq78svkD+vp8tqObiHz8
         miMSMpdjf7iq/UlosmS1mGPNx4foLi9HPe3juNGyy5b0NtxVH9ksHhXF3kCFACEG1fxG
         4ujmsJHm34yBA+0nEH1kHJ/0Xiy9H3/pkOH76h2IdVqL8oCqBGJNaMip5R6WMak5//O+
         lhag==
X-Gm-Message-State: AOAM531oiwXUw4ePIXqD38dE2fzE7PvgGWywUV1jGltVUTK82UXS0dKP
        DYdwpnvNqQK8y8F1LwhkdTuJF2FEh3z+Nh9Y76x1928t/c9vPmwcLMW/+M2nKBflU51Bk2O6CDe
        4UroPLxd5VwxJ/tpuyzIVmtDEkukUQrV1+ho0QNMkhnmQgU4GoQ5jG/K/owZYEy74hq2P
X-Google-Smtp-Source: ABdhPJyPXupHScrKo6BUjE2ocjfDzLH/c1V80tmF/a+D/iBR1dCRkL5GAOOaHRSEceyabt3w6hEtyg==
X-Received: by 2002:a17:902:7848:: with SMTP id e8mr862292pln.90.1643237514868;
        Wed, 26 Jan 2022 14:51:54 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q15sm3793941pjj.19.2022.01.26.14.51.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 14:51:54 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, ilias.apalodimas@linaro.org,
        hawk@kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [PATCH net-next 3/6] net: page_pool: Add a high order alloc stat
Date:   Wed, 26 Jan 2022 14:48:17 -0800
Message-Id: <1643237300-44904-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat to track high order allocations in the slow path. A static
inline function is exposed for accessing this stat.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 11 +++++++++++
 net/core/page_pool.c    |  1 +
 2 files changed, 12 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b5691ee..b024197 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -83,6 +83,7 @@ struct page_pool_stats {
 	struct {
 		u64 fast; /* fast path allocations */
 		u64 slow; /* slow-path order-0 allocations */
+		u64 slow_high_order; /* slow-path high order allocations */
 	} alloc;
 };
 
@@ -206,6 +207,11 @@ static inline u64 page_pool_stats_get_slow(struct page_pool *pool)
 {
 	return pool->ps.alloc.slow;
 }
+
+static inline u64 page_pool_stats_get_slow_high_order(struct page_pool *pool)
+{
+	return pool->ps.alloc.slow_high_order;
+}
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -235,6 +241,11 @@ static inline u64 page_pool_stats_get_slow(struct page_pool *pool)
 {
 	return 0;
 }
+
+static inline u64 page_pool_stats_get_slow_high_order(struct page_pool *pool)
+{
+	return 0;
+}
 #endif
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9dbe721..3a4b912 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -240,6 +240,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	pool->ps.alloc.slow_high_order++;
 	page_pool_set_pp_info(pool, page);
 
 	/* Track how many pages are held 'in-flight' */
-- 
2.7.4

