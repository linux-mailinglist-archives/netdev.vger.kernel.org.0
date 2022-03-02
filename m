Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83EB4C9EB9
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239957AbiCBH5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239960AbiCBH5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:57:37 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C387B6D1A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 23:56:49 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso726564pjb.0
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 23:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HPfQh9n09LOH2LrDbaPnNvC5rOCyguVAdFId5ncvNfM=;
        b=W4CLDVLOmgoqdbcTywJ6SiUonL3zYL12YNWK0gAkjkQKpsxPxWfFzCpv8JtcdE55Jf
         GntAgEpd0N8/i79K8/X0lwYUi8bA6A9pEtNJMt1rN6YzRh+PhGZwGXFFYEv9CR9QJlbE
         9aAXQ6E6LedsuOTWHe7ClijpTqCEEjx8OdvK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HPfQh9n09LOH2LrDbaPnNvC5rOCyguVAdFId5ncvNfM=;
        b=rs3pO6X8ajuiYXWCKA9wIvtP7ghDL/3+LzomyVbBurDSTrEsbquYVI9zvOm++GGzIF
         wRd99twZFg9xnCY1UPmuWWU92wxoOr7yoDYF+QIJCsNhKp/UTWz/9vVFskqvTiHUztXf
         L6Jhg7ZAYGqSqVfILUKm0PAy8mq3gRx8i5fQodU7mk5nEUtEHbybA9+wJDJ2bLKEl0oP
         omqFgv2WM4czDUi4r3uM4VOe/DLGijGIGH+JliXcMbXn4sHrveF0I1FuyQ5bGOlP6tEf
         gmJZQV9E0kFxB9rTXsiHr/rps2+HXP/q7sTAkwVSlPkIFIK0XQt7VSisJpxj8fw1ltop
         jzVQ==
X-Gm-Message-State: AOAM532QnqIXeaiBtyEdhxLDrYTSSaHZOg/OzDkqjtfnpk11znVtx7dB
        1QzIp+detaBCLiobLkZheQ1ksmfkhOA75bEVb+B3OTdKBIuNw/E4VVAwbMhyzyW97zL83qrQQ2a
        Vo/vGxBlvojWE6OXqVB8Cro5ZQPc9jGUZkNO9SFzZWfZ0CeKBH1Ennsy3EK9zVZgY6ij7
X-Google-Smtp-Source: ABdhPJz+Eg00dYxOyiEUT1cHkQKs+ewHcDJYqWv0Ke7hxiMGw+pmbDJ83p+PfNPCiRTnRI9XimpeAA==
X-Received: by 2002:a17:902:904a:b0:149:b6f1:3c8b with SMTP id w10-20020a170902904a00b00149b6f13c8bmr29873638plz.83.1646207808293;
        Tue, 01 Mar 2022 23:56:48 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb9-20020a17090b060900b001beecaf986dsm2237780pjb.52.2022.03.01.23.56.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 23:56:47 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com,
        leon@kernel.org, linux-rdma@vger.kernel.org, saeedm@nvidia.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v9 3/5] page_pool: Add function to batch and return stats
Date:   Tue,  1 Mar 2022 23:55:49 -0800
Message-Id: <1646207751-13621-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
References: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a function page_pool_get_stats which can be used by drivers to obtain
stats for a specified page_pool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 include/net/page_pool.h | 17 +++++++++++++++++
 net/core/page_pool.c    | 25 +++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 298af95..ea5fb70 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -107,6 +107,23 @@ struct page_pool_recycle_stats {
 			      * refcnt
 			      */
 };
+
+/* This struct wraps the above stats structs so users of the
+ * page_pool_get_stats API can pass a single argument when requesting the
+ * stats for the page pool.
+ */
+struct page_pool_stats {
+	struct page_pool_alloc_stats alloc_stats;
+	struct page_pool_recycle_stats recycle_stats;
+};
+
+/*
+ * Drivers that wish to harvest page pool stats and report them to users
+ * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
+ * struct page_pool_stats call page_pool_get_stats to get stats for the specified pool.
+ */
+bool page_pool_get_stats(struct page_pool *pool,
+			 struct page_pool_stats *stats);
 #endif
 
 struct page_pool {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3d273cb..1943c0f 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -35,6 +35,31 @@
 		struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;	\
 		this_cpu_inc(s->__stat);						\
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
+	memcpy(&stats->alloc_stats, &pool->alloc_stats, sizeof(pool->alloc_stats));
+
+	for_each_possible_cpu(cpu) {
+		const struct page_pool_recycle_stats *pcpu =
+			per_cpu_ptr(pool->recycle_stats, cpu);
+
+		stats->recycle_stats.cached += pcpu->cached;
+		stats->recycle_stats.cache_full += pcpu->cache_full;
+		stats->recycle_stats.ring += pcpu->ring;
+		stats->recycle_stats.ring_full += pcpu->ring_full;
+		stats->recycle_stats.released_refcnt += pcpu->released_refcnt;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(page_pool_get_stats);
 #else
 #define alloc_stat_inc(pool, __stat)
 #define recycle_stat_inc(pool, __stat)
-- 
2.7.4

