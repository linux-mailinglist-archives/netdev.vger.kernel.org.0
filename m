Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AE54A32A8
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbiA2XkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353450AbiA2XkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:11 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE25C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so14482226pju.2
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NTd7TBI6abPTmN3I9QjdcpJvF3jv9TVetLryoOk/zcc=;
        b=l6+WAZ1J1v9m0go2oG3ydFUB9vs2JlU+N8bbFq7akudwLtdCKuS4HFcjwrOUFUbUGm
         1d7khlrkm7ok3VivLRe5osmCuMedNF4vYI5xROoly71XiVEwbZnA6Dsw2HFJDvNi07xg
         hsWHE6Tw9EumLJWae+B7Ib59vsUK7w8xzeIc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NTd7TBI6abPTmN3I9QjdcpJvF3jv9TVetLryoOk/zcc=;
        b=eyH92HSNVlSmyzCn2ma84SQy+3YmON/3pgaD4rUjtNi8AZgiU+AACpID5w7zae8g3Y
         7kN5MfJd4FY98GEupK3/sbOEqmzgD35wGfAFcBRRXvuwVv0tmcHQ0HhR0OQ2WIxFxldw
         1HfnLYOTZiz9h6lSEevn5GgNh7BJqC91AY1YamHKtdl/oAU4FKOq8+wfNvnE7GUc1BLA
         wzB8Z0KwPrJAIMdgvIk+pdvjGMHAuboPwux7vrslnGgN77rBIY/eTnwyZuBAdn/3XCFZ
         mZ5FWKD/eFb49eaWthpdS4+h/h3QxOycmElmHLqjLUF8LbfB1o6IvHiR99K9LAHPFGtp
         kb2A==
X-Gm-Message-State: AOAM532b79dDFyl4ulhd1UgtxcBOmx0zZ3u8eRqo0UKBFgyw9fpTTTTZ
        4MBOrbVfCHSKsXDmOThBmM9LrpIhPc6gQ8RuL8DpeO4apQQlwUAplfK/pXkxSuQwKlvJ5l7uW69
        JWxUv/H8YH0ozM9Vl8XScCfxBeGzApRYcbKW6Ckc87DcLzIfO3N+zfhiwh6dyy+f67YsE
X-Google-Smtp-Source: ABdhPJxBS71uCTS/7KDQjnP5KQLaQVhJ8bFMbshYbSP4uMBa84i8924bTYJkDp19EXyWPkWse5CvJQ==
X-Received: by 2002:a17:90b:4b88:: with SMTP id lr8mr27032837pjb.166.1643499610430;
        Sat, 29 Jan 2022 15:40:10 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:09 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 05/10] page_pool: Add slow path order 0 allocation stat
Date:   Sat, 29 Jan 2022 15:38:55 -0800
Message-Id: <1643499540-8351-6-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
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

