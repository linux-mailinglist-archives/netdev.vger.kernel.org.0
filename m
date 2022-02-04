Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49154A917E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356185AbiBDALK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356188AbiBDALC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:11:02 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4D7C06173E
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:11:01 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so11522108pjj.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9z5HdATxjgMY+JMPfrBqXKsfF1k2bfP5xYyeqVl7niw=;
        b=l7DGs29XIOfURzYhsS2cBfWbnO72hCsc+loVxiUGnMph8nk5q+UCtx3dsOTGUaf/wL
         GLp7RByK672lyNl/H3Tiy3jQ/wai+nTNHndqlyEVCAAp8/bNSsoWJjoFtMhTh0u8NHYP
         9hs6Mrb7m/fmln+2It4fE5Fg1uwWG1TPq7iVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9z5HdATxjgMY+JMPfrBqXKsfF1k2bfP5xYyeqVl7niw=;
        b=zN3c6JE0CqPVB5TDCw3M0GHeSmSiiKbYHIMvQ67x3hRB0TUFV1teFTpRSPppM6sgTh
         Yn7Bxegv1oOVuOGx5fSza4OSUG1oaRvM1UT0E0RtZcLCkp7pa0xSVjLa3fCJ2+yQdgCE
         2EEwgXRF/RHZ0FHud5I3Qjk5qVdNIQOKw5R1nSMztg5yr0R43ZtyjrTDNfBarwLoz5aC
         ZkTHcOD+r0VFvxzB9Eh9B5Ohc7hoHErjGK4Oe1dZh2BQNJR92fHS6C89b9a0CS9y/JVg
         xVu8L949ouvOcOZzlClsPf3iuiOva9SDBecFdwAdzuic41GIDreUfkJn7D0+H60ccvGb
         tHXw==
X-Gm-Message-State: AOAM5320F/jjRCk8rTog7Qnk4sewri6KtayZMgfVwMrKx2eG7azBdH0i
        Ylub/IlhZoUfkSsSF5PjJwbH/iSuMH9+pxWKT80TLzgYBLcvDqRZFiXuVnzhQSW2RtNzolLXfr5
        ABwtQVzLkg15+D0EVkDrHaMQiiMBc/ixTEvYJ+XoA1yNT996AfJRbOE2HXZG3uzkNHGHp
X-Google-Smtp-Source: ABdhPJxAko3gG0AY+cI2+ogIJle/PglcIXB0O97nR/gyd94JadOF5XJmJBgtuggoKgw1QbGJ0/Gi9g==
X-Received: by 2002:a17:902:e5cb:: with SMTP id u11mr657837plf.52.1643933460574;
        Thu, 03 Feb 2022 16:11:00 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:11:00 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 11/11] page_pool: Add function to batch and return stats
Date:   Thu,  3 Feb 2022 16:09:33 -0800
Message-Id: <1643933373-6590-12-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a function page_pool_get_stats which can be used by drivers to obtain
the batched stats for a specified page pool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h |  9 +++++++++
 net/core/page_pool.c    | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index bb87706..5257e46 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -153,6 +153,15 @@ struct page_pool_stats {
 		u64 waive;  /* failed refills due to numa zone mismatch */
 	} alloc;
 };
+
+/*
+ * Drivers that wish to harvest page pool stats and report them to users
+ * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
+ * struct page_pool_stats and call page_pool_get_stats to get the batched pcpu
+ * stats.
+ */
+struct page_pool_stats *page_pool_get_stats(struct page_pool *pool,
+					    struct page_pool_stats *stats);
 #endif
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 0bd084c..076593bb 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -35,6 +35,31 @@
 		struct page_pool_stats __percpu *s = pool->stats;	\
 		__this_cpu_inc(s->alloc.__stat);			\
 	} while (0)
+
+struct page_pool_stats *page_pool_get_stats(struct page_pool *pool,
+					    struct page_pool_stats *stats)
+{
+	int cpu = 0;
+
+	if (!stats)
+		return NULL;
+
+	for_each_possible_cpu(cpu) {
+		const struct page_pool_stats *pcpu =
+			per_cpu_ptr(pool->stats, cpu);
+
+		stats->alloc.fast += pcpu->alloc.fast;
+		stats->alloc.slow += pcpu->alloc.slow;
+		stats->alloc.slow_high_order +=
+			pcpu->alloc.slow_high_order;
+		stats->alloc.empty += pcpu->alloc.empty;
+		stats->alloc.refill += pcpu->alloc.refill;
+		stats->alloc.waive += pcpu->alloc.waive;
+	}
+
+	return stats;
+}
+EXPORT_SYMBOL(page_pool_get_stats);
 #else
 #define this_cpu_inc_alloc_stat(pool, __stat)
 #endif
-- 
2.7.4

