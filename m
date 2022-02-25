Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA464C4CCE
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243979AbiBYRnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243978AbiBYRnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:43:33 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ED414A057
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:43:00 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z15so5282901pfe.7
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NML1gCRz6Q1qHytm3I5emxxotjmWSXu6xe5DQOPB1bg=;
        b=oR78uVOiJRaez3fuwI8HNLU3GSQW4lAfExenU48StMXtyEq20LZ6ERo/MvLdaM6wyN
         E2GoP87iMEYWwlmiubSTPzgmMyL7q+wwGT/W5M+k9RH7c81ZmaN18dd5gdwYUuO9y30J
         y3wAr03noJE4L+yxTGB9rKVAQ44j8S7e2V338=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NML1gCRz6Q1qHytm3I5emxxotjmWSXu6xe5DQOPB1bg=;
        b=hIaf9bhhDbj4TfoccnwmO1YvD22Ficfs8FgbJ7z+CNNeWtbbnvpweVj7QcF3QGn9yl
         yIertAAj8UKTqWSt3ntWv1mMhg7SCh9KP6PzReZMKsFFkd8OfyPbInwTd6XoDpn9qX1i
         Z8Qi8Dqs6rG8AdeYLx1yunIhJCgfrpdiaHyYCG3nXU/uouc026MQ6QvxCeQenbH/BcsZ
         H4PpDEWZT7JuslR/nOrDI1sVZgttSD6cYI9e2RPyTP8jnhyOwtZKQQUTe1NyLALWN7/P
         CUJJDYOAq3SWNBZnWZf7eOc+Nb9Yo9t1fRrYkbXocjb0mLJGhHeS2QLg0abCWVw01NWJ
         d+MA==
X-Gm-Message-State: AOAM530GCCI1yqfM5tIQe6S6KCc+dJULxzvx2MGdVLSGqpWe0b3SNsyu
        Ms+G0u4Ho1xduTz25qXOqL56MyjA/vk5T5nO1xbRu0Q4VUxbQYBucQirRQ/z5TfPvhfKtWDwb67
        2LQRP8UBahNhwH142UJ13sY9K3aySItUgwPVJozvzcHlBbfbi6psiGDAaJ5dXQxZV9k1k
X-Google-Smtp-Source: ABdhPJx3l5mdnTNW0npz7+KjC5mAyvBjLi7bbORKe2ddSr6ot2PRdVntUJYpIwUnsibZwVf3h2Umbg==
X-Received: by 2002:a63:894a:0:b0:365:8dbf:cd0d with SMTP id v71-20020a63894a000000b003658dbfcd0dmr6922059pgd.5.1645810979292;
        Fri, 25 Feb 2022 09:42:59 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id h2-20020a656382000000b00370648d902csm3203805pgv.4.2022.02.25.09.42.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Feb 2022 09:42:58 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v7 3/4] page_pool: Add function to batch and return stats
Date:   Fri, 25 Feb 2022 09:41:53 -0800
Message-Id: <1645810914-35485-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
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
stats for a specified page_pool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
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

