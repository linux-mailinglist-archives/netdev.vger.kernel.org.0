Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FA44C9848
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbiCAWWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238417AbiCAWWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:22:02 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD42996AC
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 14:21:19 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e2so2225540pls.10
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 14:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9NY8qYnFJcmXCCku0qAVwFb/8yP1N9EVWDjmuvqdYhU=;
        b=jGFZTpdrLxtnmJQw3D71tGdJvI9n/Xz/xD9LVhWGhHYsnMFzaCuxCvf9HkStwcGt/0
         hj/M5wjqGoa0RgBOnKXoqP5YoaJ79SDEZa73mC0i/ZUhoA4ZjOmoMAVOlFqndpL3/bdx
         Geuix6/oBcN3Vbq/TvIrRLYhR+PfvSuDYhtrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9NY8qYnFJcmXCCku0qAVwFb/8yP1N9EVWDjmuvqdYhU=;
        b=cif+7Ieeme84dejaaReXMZ62wq2I9dkz5R3xna6yaTFrvhD+u4+FCDDmbmDNxSktcB
         4l3b7PQgaGe7OA/tHMHm3CEx1m81UAH7keV39wPgR0yFAVOjXyF8UDmQUaNjyyoiBe4J
         AtA5yvOshAP7V484eICitCgCM/ME1To6r8vc9P+bLbDRCdyH2S6VBiV3jesY+f98nulH
         42K2GCBquGjhiXTuMS6BZNavll4GJxuwiKin4mA0Llq4jiOLVIVM4M2MRcg3q9si3Of0
         e0XXBvg6k7oTZZZ9FDZitlNy2PzO7399dKKO5xdMLtvvsXy+L5TouiLTwYIEZX78tvVQ
         GOQg==
X-Gm-Message-State: AOAM530P5fub6WiSUVa+gD3NZ6ywthCaUsg+HJjCH+z2tM7dWpFmBSKL
        CtIBglzJcDZVazqcuGfG5rL5M3QlZx57FLgfAv2B94J1UDt1RbVAAtg7dV4NLbdPgyjjEbvc5yz
        MxseqADWO0CbRxr3ZmNyxf90X8ntckVYQE5IY0X5zQv+Oey3KynjUTxh4gX4ZdK/sHx65
X-Google-Smtp-Source: ABdhPJzyqTzmfc4FR8wzWcrldqVUPbo7P578admoKJXINS0IgIKvSeSJKGbqVrOrWkCaoj48k8An8Q==
X-Received: by 2002:a17:902:d706:b0:14d:5b6f:5421 with SMTP id w6-20020a170902d70600b0014d5b6f5421mr27275974ply.96.1646173278728;
        Tue, 01 Mar 2022 14:21:18 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id h22-20020a056a00231600b004e1784925e5sm18819108pfh.97.2022.03.01.14.21.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 14:21:18 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com,
        leon@kernel.org, linux-rdma@vger.kernel.org, saeedm@nvidia.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v8 3/4] page_pool: Add function to batch and return stats
Date:   Tue,  1 Mar 2022 14:10:09 -0800
Message-Id: <1646172610-129397-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
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
index 27233bf..f4f8f5f 100644
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

