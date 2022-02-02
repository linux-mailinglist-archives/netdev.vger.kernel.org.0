Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6EC4A6986
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243628AbiBBBNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243630AbiBBBNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:16 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAA0C06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:15 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id z5so16838192plg.8
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NTd7TBI6abPTmN3I9QjdcpJvF3jv9TVetLryoOk/zcc=;
        b=l/KwjDz1TCEY1XcxLRvSdICPQnUGqRb9sGPDGFUnwfdjegjgVkOGtMF0MkgLwOLfzE
         4mVmvfpD74W32+diIdu8AzuC1/JKsQaSAl6wh05/+6Q4+catorp3+1CGNz2AqMeSi5Lo
         yBPmhel/BaVsxKEwOcMrK6GOQ3s043sqQ0g6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NTd7TBI6abPTmN3I9QjdcpJvF3jv9TVetLryoOk/zcc=;
        b=sASscXQQvwCgHTBTmbJhMd1cnVGtYsraIQxwFgUsn+kgf/njgCgQGcYWQGSLETGs+C
         nhHWI4kRBShhiwk9CY/v3c1xSqVWwmYdk0uTrEKI0Si0IT8N8qNcri6evUNsIe/z1qf4
         g5I00v9nveEnyKzfHsoQ5TZyhZ2NbtkizyGkDLY+OSIU2sraWVC25UoZMhpLPrb57kkB
         tb7fUn+4iNpJl6uIlbT4ZXyOurrXaIVA5znfC1VkG0CZZMsdnYqzftmKZw2yYXImWo4O
         ysmoLSnPSmXUO+ysmLIKzxRSrtr/dX63fI0GdyzDgk1iO6Jy0m6bSjKJAivC7nWqXrTs
         KlEQ==
X-Gm-Message-State: AOAM533ZHYnubdErHC7KU+ff0YJ09ncyqHcBCw899ESTHpSi+i2LMqhu
        GojVHI+U2nqzgi6rFHuKUyD7+Gh9BJJ1iswQbq4IQ6OaexNuoKX1ocN3d6wdT+DIRbGplpknhHc
        0ZFuRqAUpYxWkmhq9U6/uplvQOOMxaWbDh009s5CkZ7tSZ99WROogv+nAKo1PsGoIWgLf
X-Google-Smtp-Source: ABdhPJzcAISH0g4wX6g/wgDoBnlAZqpUod3kQEC4mY1F9tXMkNJ1W4YRip2nknErbYwV7ssdiEn3kA==
X-Received: by 2002:a17:90b:911:: with SMTP id bo17mr5358283pjb.165.1643764395072;
        Tue, 01 Feb 2022 17:13:15 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:14 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 05/10] page_pool: Add slow path order 0 allocation stat
Date:   Tue,  1 Feb 2022 17:12:11 -0800
Message-Id: <1643764336-63864-6-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track order 0 allocations in the slow path which cause an interaction with
the buddy allocator.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 1 +
 net/core/page_pool.c    | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 96949ad..ab67e86 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -144,6 +144,7 @@ struct page_pool {
 struct page_pool_stats {
 	struct {
 		u64 fast; /* fast path allocations */
+		u64 slow; /* slow-path order-0 allocations */
 	} alloc;
 };
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 6f692d9..554a40e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -308,10 +308,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
-	else
+		page_pool_stat_alloc_inc(slow);
+	} else {
 		page = NULL;
+	}
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
-- 
2.7.4

