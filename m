Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E974A32A6
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353445AbiA2XkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353443AbiA2XkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:08 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB5DC061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:08 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id h23so8629751pgk.11
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=daCp29CfHqba5AzFqLjgXp71o/Cmax20BodJH4eahfI=;
        b=f15XspafqxG6ESLY/xvakwMwGbcXQLArGWMHhs+0zRzmEqQ+wvYZ60nTQKCxu0b3Yo
         wNwayIyU0GeGzYHV6G1YiGLtSi5xMlc3ciZTFHa7i27XYRyKCXUI8Jzlmt7SXjTN8xBp
         DSw5LpL2ujIf85D0KfePlcqkioeyirbWahiCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=daCp29CfHqba5AzFqLjgXp71o/Cmax20BodJH4eahfI=;
        b=haJsczvC5ZqqefreGzV4GkZRPcpu6aoqJN/rj1bNPfzA0Ocb9l6tsBJonLYwKQ/p43
         dsFpzNGXSPB2dTU8YyBJ2xlZWSSVaoWNNIMyoTl5aZEai1rNxL5w1QpFFE/QewmSeHMT
         fnsEn2t+7sd5GaGKR/X56bu729naIZslMezh7ZAgta5RB/6yirIncWxqm47shHgv+ERn
         aG5GJ92U5o7l0xvn/5ZLuxj0DUYRKgAlvpFwxNtHvmQcNpnyCXekxJKWqXLJ2z1+KFkP
         FOPtlQa+fa7FhTDlbg0gTw0YeMHIj+OaoWAlNWpsEZbfwUz//2KQqKfz9NjSONEaKscm
         gkpg==
X-Gm-Message-State: AOAM533j3W8QIFgG4t4+cEXt/QmXLDNJUTHDF/5twuO6MQZzLi4F6H2C
        Pu4N/txvrUYgrt06oVBz+1nkzP0lNBQB8XCqlOS9pcIp7BVPapKCgZiC6Dzcii1U2kWERNrj9sO
        e7qoJWMshu/2e4hK47pYRg/at/Hbap1Zj+K0cjNRN6UAJnjr4T1pb4PXRRU6f77jUWOlQ
X-Google-Smtp-Source: ABdhPJyb1kC2ExfMUhCrIFjZL0BS6l4hG6Iy9nNY4joqBB+tMMvPQTLn4T5Rv0m6/kXUhLyCs1BAZQ==
X-Received: by 2002:a63:1f12:: with SMTP id f18mr11738293pgf.426.1643499607369;
        Sat, 29 Jan 2022 15:40:07 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:06 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 03/10] page_pool: Add a macro for incrementing stats
Date:   Sat, 29 Jan 2022 15:38:53 -0800
Message-Id: <1643499540-8351-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add simple wrapper macro for incrementing page pool stats. This wrapper is
intended to be used in softirq context.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/core/page_pool.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 7e33590..b1a2599 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -29,6 +29,15 @@
 #ifdef CONFIG_PAGE_POOL_STATS
 DEFINE_PER_CPU_ALIGNED(struct page_pool_stats, page_pool_stats);
 EXPORT_PER_CPU_SYMBOL(page_pool_stats);
+
+#define page_pool_stat_alloc_inc(__stat)					\
+	do {									\
+		struct page_pool_stats *pps = this_cpu_ptr(&page_pool_stats);	\
+		pps->alloc.__stat++;						\
+	} while (0)
+
+#else
+#define page_pool_stat_alloc_inc(stat)
 #endif
 
 static int page_pool_init(struct page_pool *pool,
-- 
2.7.4

