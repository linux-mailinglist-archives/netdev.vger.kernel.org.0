Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696BC4A917A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356165AbiBDAK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356147AbiBDAKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:53 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0918DC06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id x3so3683646pll.3
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l7FvHk4E5CURlw1cPp1+JmKn0JT3ZYqq3Gj+nnzO8zg=;
        b=vv+xDFOOL13mJgM6fZWlEuyOj/OEmVWp3roOiXBC6Y2WK6LIfnuhFrElSQRR2Q2D9G
         vv6Ussv/xnAZr0+vjqWTtO9nSPiy2jJerRPYukxTQk7x+W74xCMNt6W6CB+ZX1ZOvfns
         K19zkpHOd0pjPXwU+Fs5PE9NcKxNfXWe8ida4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l7FvHk4E5CURlw1cPp1+JmKn0JT3ZYqq3Gj+nnzO8zg=;
        b=kZqagq1AhDqNgkeGBkKm5LuNhGzFBg8hI2WpL90JbJ/Q6eyGTX2J2FXtS9QBMF52v6
         3M87U8FoQvq+ZF6v8pREczP44WgIOvsUeP1u7jyp32fjwktjtxYhbdzw1t+FumiGKHQZ
         NoIIxBmFpR66gOAyfpV4BQWl8Ph5jdl2LVBBWESjEYi7kKC9s3rUvV8Uim3LpSPodYcs
         6lEfTzmMPlrKSgXGHqeZj86DzMw9olVe+RLBESxG6bk9gV00wdWfU665+fj3SG0ecbYK
         VnEQvV4LNRXPog/DJaz52OnwWPsZODPcZmqjEinZMgryzsGzkLSy3dXJsq2Xb0NPeA6W
         DbAQ==
X-Gm-Message-State: AOAM531s0CoseUSedIO63dHQmbmv25JF5mmzE56R98eq9c414ck1ZsCR
        IZ5Zq//3SRxn5TgeFvqPRhc8Tq3klBdw2xhLCUaDUUAqheWwBlNXH9BqzkfZu0LTrfsLNg70Zbb
        m2jR82NN59DHkJ91jRWbjHpzlH8Bt2DXw9/HTWtkZsghz0t6ILJywZ5C4wBKZZ5K6a/CL
X-Google-Smtp-Source: ABdhPJwyoDJ94E8MpKv7XB8eIxTVX4kMGRmjERkD4G55NVy8rqcEYJeJEChNgwYwIt8eFCZA9mFTcg==
X-Received: by 2002:a17:90a:8c8b:: with SMTP id b11mr194854pjo.197.1643933452136;
        Thu, 03 Feb 2022 16:10:52 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:51 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 06/11] page_pool: Add slow path order-0 stat
Date:   Thu,  3 Feb 2022 16:09:28 -0800
Message-Id: <1643933373-6590-7-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increment slow path order-0 allocation stat when this event occurs.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 1 +
 net/core/page_pool.c    | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 864a480..7d5f202 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -144,6 +144,7 @@ struct page_pool {
 struct page_pool_stats {
 	struct {
 		u64 fast; /* fast path allocations */
+		u64 slow; /* slow-path order 0 allocations */
 	} alloc;
 };
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b5bf41f..264d8c9 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -313,10 +313,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
-	else
+		this_cpu_inc_alloc_stat(pool, slow);
+	} else {
 		page = NULL;
+	}
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
-- 
2.7.4

