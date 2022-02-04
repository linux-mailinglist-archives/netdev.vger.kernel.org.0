Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E348A4A9176
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356163AbiBDAKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356147AbiBDAKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:51 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BE4C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:51 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so11521827pjj.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sBh+Hfll67AeiB+Fr4u+vldCm4Dp1LVrmoQj463LZFg=;
        b=mhjS9i9Mb6Kwp31UnREU2A93sKi7wb6c6ZjMAo4fxZ98qFeH3qKx6YYAXoJCuKqSoO
         vbZHCNmEtZNahTzoWt55qZkQhs/Qx6F3L+w65JladTwftk65du2QbSo378oooG3YXL8o
         kNHGf3cZxDKwLYmfvG6LNvjoDCSvKl0V2WeQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sBh+Hfll67AeiB+Fr4u+vldCm4Dp1LVrmoQj463LZFg=;
        b=ed72c7g5IzXqL72Bd0v5AAyfqdSzpP5q8qHQmgQofCgvrFCMRg1Kcn+JMFSqK55mYx
         vU54+ib92gTIKXJ1G1giAg1RfM+wkdkGTC3ijrPxp21kUbvhPQLB1aHmiF7Y59gh7agk
         U1rDhcW+VGyWNWHW2dvmwm0xC7XYtE48kPZOdeOagSEzsMG+hElbUxpOWOT3HPZKHVpQ
         xONPYvaNFwORcYJSOGp/WP0jCcGozd4NTER5KW7NW9QVJzxKGDROELmqFVvulxYgJzF+
         yHDQhHoBp/uby2pt2XHI8g6wcAsfxDdhbJPCndgB0Cn/TTe0J6FieltrQSc5MFdKo4/P
         CTBg==
X-Gm-Message-State: AOAM533rhe5Jr3n3KEp5+TljrXzHF+p7u02D2BHemY9MoQT1qz9D4GQU
        DaARhCUiBLaHrvNtULNPou8AuQX0EytyUFerAEhoK9GSFJAWFWyrbVCesIamuesistt3+wUzIEN
        rckbUApjfFjqfXcMa53p6IfPNeDtcJq2FXhIDusUmFJGDt6M3dKUuLLN++I4dTT3bVlBk
X-Google-Smtp-Source: ABdhPJzqAx6HTtU1/RZaa3ZLfXsAmAuNwDIqweqiXQ6LXZ9eWza/x5CgtlilQdG25FshCqsicqd3ag==
X-Received: by 2002:a17:90b:68c:: with SMTP id m12mr204744pjz.137.1643933450405;
        Thu, 03 Feb 2022 16:10:50 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:49 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 05/11] page_pool: Add fast path stat
Date:   Thu,  3 Feb 2022 16:09:27 -0800
Message-Id: <1643933373-6590-6-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increment the pool's fast path allocation stat when this event occurs.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 3 +++
 net/core/page_pool.c    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 93e587d..864a480 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -142,6 +142,9 @@ struct page_pool {
 
 #ifdef CONFIG_PAGE_POOL_STATS
 struct page_pool_stats {
+	struct {
+		u64 fast; /* fast path allocations */
+	} alloc;
 };
 #endif
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 180e48b..b5bf41f 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -185,6 +185,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	if (likely(pool->alloc.count)) {
 		/* Fast-path */
 		page = pool->alloc.cache[--pool->alloc.count];
+		this_cpu_inc_alloc_stat(pool, fast);
 	} else {
 		page = page_pool_refill_alloc_cache(pool);
 	}
-- 
2.7.4

