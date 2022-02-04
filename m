Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E49C4A917D
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356174AbiBDAK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356182AbiBDAK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8E6C061748
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:56 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m7so3969600pjk.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xoRYY0Fze8sf08kdJpIVjLOV4w2PmmkJcjWTrqHlPVA=;
        b=Cey/2Pxb5cUgz9VbX2Z9hBXXIlUnagj00fGDHagFKuNpndwEJF1axrNn7Ikpt/VLDO
         b4Np1IdAk//WScNuKgg52lN0YMaFu7vZLcEP8Du1+nrbgBYAnCIuS5BgJhbUn9380gjL
         zk2IQlnN5XBa8H4fAqqpe8iMXuWE+NGymVInk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xoRYY0Fze8sf08kdJpIVjLOV4w2PmmkJcjWTrqHlPVA=;
        b=Gs400GsaJizujyuTbopsizZdG7llnIP5NT4a7Aof0fA/OW7wTe0JaWKZUSTiNFxpWv
         lK5CNsX7kTpalrbEcquyBV4B87aF+PZS9JlN9KikSv6gKKAauaWmJE99hhDR0WOQ9yTR
         w5TXwGfypg4Dshks8DbMh7RjDVo45rgfMPsASnMZB3hqjKl0d+DTbARFQpc9HYYZuTOF
         Cl8vE1/nhY5jISVLMaQAxsvlVBGBmijdhDgq8vIxnp9YgXPkzO0CX8kcF/BRLo+rZhuG
         KxxKffNmHuemF3AL7EPCUVyhF0R7B1AnkBu9vGJgMnZ1UaozGDq7wdGxCllEeZBKglmF
         4mcg==
X-Gm-Message-State: AOAM530gBbYTFBAEMJLVTrzI075a7Y8rdoDxNw7Mm8cr++CJu0AqeWYA
        fQA/wPEoofIlSS9N1fp0xiTsxFN15r+D5e9QovKi7QgBPpV+Ycq1S9/LP249mLz/3/u4tvRETdp
        bA8aRXADeoThQqCIChyapW7AQxmAX46lya6bzgCwd6O6J8ZG+eX3NMplr/Sy/aGtaW0aE
X-Google-Smtp-Source: ABdhPJxN0+tuDEGndl7c2y/um1FzSus+Gdh8crliiLIkIZa4jcEOyFG0L2rm+f5NLRHzatVIrmwZ8w==
X-Received: by 2002:a17:90a:290b:: with SMTP id g11mr252134pjd.8.1643933455521;
        Thu, 03 Feb 2022 16:10:55 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:55 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 08/11] page_pool: Add stat tracking empty ring
Date:   Thu,  3 Feb 2022 16:09:30 -0800
Message-Id: <1643933373-6590-9-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
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
index 0c4cb49..b243480 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -146,6 +146,9 @@ struct page_pool_stats {
 		u64 fast; /* fast path allocations */
 		u64 slow; /* slow-path order 0 allocations */
 		u64 slow_high_order; /* slow-path high order allocations */
+		u64 empty; /* failed refills due to empty ptr ring, forcing
+			    * slow path allocation
+			    */
 	} alloc;
 };
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b7d0995..b25ded1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -136,8 +136,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	int pref_nid; /* preferred NUMA node */
 
 	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
+	if (__ptr_ring_empty(r)) {
+		this_cpu_inc_alloc_stat(pool, empty);
 		return NULL;
+	}
 
 	/* Softirq guarantee CPU and thus NUMA node is stable. This,
 	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
-- 
2.7.4

