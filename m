Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49CD4A32A5
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353449AbiA2XkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353443AbiA2XkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:07 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC015C06173B
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:06 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p125so8661258pga.2
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5MPwYILWWDHRKPtSihChctU6rXVQMQ9CjUeZyzwHNXA=;
        b=FF74KuP08CXjsoy+nwd8IuDTjtAzGz2lcfDLbKkYLXFTjUQnWS3XZNt7xtEO0nhJme
         JktM6RLqT3qJhrdEp4JD8BPCSK1eNNUJGlk2bRBi+7Bu+8HPgoznnNynsdppWzWgYN3V
         MSo8Tc+/AkLhXkOQ2XdrUeZjPwKyjmU5t8OYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5MPwYILWWDHRKPtSihChctU6rXVQMQ9CjUeZyzwHNXA=;
        b=OJM12PwDfdlvTlpBQRKrd9I+jtKn3xKdkdcFr0HxrpmQ5I32TJj/yHDDDsSVAyylFp
         +Gjh16LUUw6UQqOU1q3E48W/CSmqBouE16+C/DVFw2ttWc61pS2OPk9ukX9TjYRizmuv
         I72x30VBwiCL2Nf+LTMUzqwr0LoaIL2nnvg8Vye6B65VaCyXmaEV1bRGGUOh8HN7aanh
         WaGzUPXSr99Yq0LcXHYgWML2lmGpjt3VA4ouS3f9GssspMA5ELEZgJQ5DgSVklhjGFdF
         59LIhUaT4kYWpjsQ5xpQI3K29ftBFcov6dh/2iCH469Ymp0GoWBYlJ0yeCiQF2WgDci+
         GD4Q==
X-Gm-Message-State: AOAM531hukZcRceBQoHCNOOUsR7yKWZy2o/dSqaSYIDkZrEUwYO09xz1
        IVo/B/f3vJyx0aJdz4RlTk9qKSh/8ZEc4X6jlSwHbTlZQphiTnIniGQa2DsmKZ79SeCylAdgMwS
        ohSlYR1r4iDGNZAxcUOj84mme5jUDrbDgMbPR4xZnMA5Ulnzm/g7kDGu48+JjvaJIFzMD
X-Google-Smtp-Source: ABdhPJwB3ft/EOwfj8qKzPdlMmZVcrfY+NK0gI9R9YloOj8NDKlepveymhxqeONPKpx2Jh+j4l4GBw==
X-Received: by 2002:a63:512:: with SMTP id 18mr11807111pgf.432.1643499605845;
        Sat, 29 Jan 2022 15:40:05 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:05 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 02/10] page_pool: Add per-cpu page_pool_stats struct
Date:   Sat, 29 Jan 2022 15:38:52 -0800
Message-Id: <1643499540-8351-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A per-cpu (empty) page_pool_stats struct has been added as a place holder.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 10 ++++++++++
 net/core/page_pool.c    |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 79a8055..dae65f2 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -137,6 +137,16 @@ struct page_pool {
 	u64 destroy_cnt;
 };
 
+#ifdef CONFIG_PAGE_POOL_STATS
+/*
+ * stats for tracking page_pool events.
+ */
+struct page_pool_stats {
+};
+
+DECLARE_PER_CPU_ALIGNED(struct page_pool_stats, page_pool_stats);
+#endif
+
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
 
 static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bd62c01..7e33590 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -26,6 +26,11 @@
 
 #define BIAS_MAX	LONG_MAX
 
+#ifdef CONFIG_PAGE_POOL_STATS
+DEFINE_PER_CPU_ALIGNED(struct page_pool_stats, page_pool_stats);
+EXPORT_PER_CPU_SYMBOL(page_pool_stats);
+#endif
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
-- 
2.7.4

