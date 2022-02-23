Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913524C05B6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbiBWADv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbiBWADs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:03:48 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBF03334E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:03:21 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c3so7472123plh.9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FuNiOhdW1F9fUmQ3mperC/gI5SylSossyuv4dVhhWK4=;
        b=C3Rb+lQmDvdBkI2wy1Exyxp+GBWWoqrmi2NXNaXTOD2dqBim370ij2C0CGW8yFtNom
         wgBDU5fpiNbZWH5AB98MA7QMWuBKJ0MqUKkIfJvKHMWuXhz52iPVVoQBF6AGzvhX0MAm
         8dN5NwWT/GTTF5L1lw2E3FimzWVGuadH07rJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FuNiOhdW1F9fUmQ3mperC/gI5SylSossyuv4dVhhWK4=;
        b=cvfBkOhqegoihccKbK/6yhZ1SMHX1uNFF1UHaRSwEcDqHhfMsOVtcKNCbQMcyi7us8
         Saa1ZUPVfMhsjAd4xDjNpJLIb9ucuJ2n8V6hcF/RwEF/11ca/jrRpun1p5g45utbot0g
         zdPRD8jaR3mEJWqB3Dvf9vtgyIrAQ/LAZexu4dhGXU0pLNivY49R/vnXpSsJyUNE+ltK
         ge4gSwYlxA8oT6LgNuxuuAQBXA6Rqo8bmYy+GPhavLFq1xL7WdRQFct5QCcNCGFJLCkS
         4t8Rqyk/9yMpFWR14ZnMRtF8DeiW8bukz6leNZZ9ZJYt6aEvlmojcEoe+LjpsnGuqoZR
         9KqA==
X-Gm-Message-State: AOAM530TT+FP0Kt5dlcIVIGpuYUq71zXNp615D7XIZVpbAFAhJodaMGQ
        EtL13LiXLo3YV7ZwTGiJ1ilgqkLh9L/RcF3BuFck4RZ444cOm88SvBCVqW6zIk/+TZL5/PB0vSp
        KHnYqCt10C4WQGa+fWZnnp0U1/7aPQAxM3a97prlBzobPEjTSe2XqNZa7ovfLVRo/vhLJ
X-Google-Smtp-Source: ABdhPJzUo2rGUfs44b8CzpivlilgT9SGmQNQDXlWAuI2nkdJ5kOQfPC2Hr6KIjZEW1bvOaG2LP5cpw==
X-Received: by 2002:a17:902:9a41:b0:149:a13f:af62 with SMTP id x1-20020a1709029a4100b00149a13faf62mr24981519plv.147.1645574600443;
        Tue, 22 Feb 2022 16:03:20 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id i3sm22460027pgq.65.2022.02.22.16.03.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 16:03:19 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v6 2/2] page_pool: Add function to batch and return stats
Date:   Tue, 22 Feb 2022 16:00:24 -0800
Message-Id: <1645574424-60857-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index bedc82f..66c0634 100644
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
+bool page_pool_get_stats(struct page_pool *pool,
+			 struct page_pool_stats *stats);
 #endif
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f29dff9..9cad108 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -33,6 +33,31 @@
 		struct page_pool_stats __percpu *s = pool->stats;	\
 		__this_cpu_inc(s->alloc.__stat);			\
 	} while (0)
+
+bool page_pool_get_stats(struct page_pool *pool,
+			 struct page_pool_stats *stats)
+{
+	int cpu = 0;
+
+	if (!stats)
+		return false;
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
+	return true;
+}
+EXPORT_SYMBOL(page_pool_get_stats);
 #else
 #define this_cpu_inc_alloc_stat(pool, __stat)
 #endif
-- 
2.7.4

