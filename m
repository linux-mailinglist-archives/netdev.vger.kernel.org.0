Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2834A9177
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356167AbiBDAKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356147AbiBDAKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:49 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C811C06173E
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id j16so3676515plx.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TtnJ4jV+znpNKtkePPK91XSsmqJA9GMlQm0gfWOolAg=;
        b=QVJCOOIOWjgeZzhP0tPAR7r7SekrUh5rxrKzJvcDzgrvHiXaC+5bFA8e1nrFF5lGoc
         Og48Rs6PC/1pIUXvq9SftaDt6zPaGReM6TtrqNJSwmsQ59ntezwwOJ77fg/+eNcHzqmY
         Oa6KFcpSzte5IQQ4J4Gutm22wrVharqzWLGGs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TtnJ4jV+znpNKtkePPK91XSsmqJA9GMlQm0gfWOolAg=;
        b=KHVX2ZkC1rMITA4qpt1zfI2JY3gtZykpgMP8294aDsqWaUVQuv5wqEEJQB0pAS0czh
         3BKfTIoIk2xXphT/3vF58IEO4sIWa/1goBBGmqGsDaPoGxHYRtuaSMYtWTqThANIEGNA
         zrPCi6QinpUAgbiHba2yGMxBkuSDIT1VpcYymv3/SnHcVNQ1ccb4NOoikWqlxB98Bl7+
         AUnmwensaRpBpOtQDB0w0Dc5/rzMigBraq0zSt4bHZq3YGGWg8ETz9JC0F/8E2+h9zgx
         ydN3cxIVFUbnxWBa1Y+34bPaUAGBayzOQtdSDXHr47ne54ZhHZNTMtZoGyJ87PjeFdLv
         VVHQ==
X-Gm-Message-State: AOAM5312P38uWQbvTsyFusvK0V7o+n4shwP5HwkSWO4SIzeXd73fMZi1
        JxX8suYOeVQVMtxc+ybezcf3phSynqkf+TMo77YXxTWDR/Z5ZE1srONQ2lM0tuGUbfzXAS4iBof
        NH+kh76xKCEJSK3fCcpVcHfBNyBKvwEjM4gIHYet01+CXFrAZPi5jBjInBAeJPfCKWa+u
X-Google-Smtp-Source: ABdhPJwyju0evxGVoRR7TFK9zz/QhkFviXvE63mjjuXEGQaqcUIE+iarBS+6ilCY/keTSD2qJRweMA==
X-Received: by 2002:a17:90a:7c02:: with SMTP id v2mr209505pjf.81.1643933448710;
        Thu, 03 Feb 2022 16:10:48 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:48 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 04/11] page_pool: Add macro for incrementing alloc stats
Date:   Thu,  3 Feb 2022 16:09:26 -0800
Message-Id: <1643933373-6590-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macro incrementing per pool per cpu stats.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/core/page_pool.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5f822b0..180e48b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -26,6 +26,19 @@
 
 #define BIAS_MAX	LONG_MAX
 
+#ifdef CONFIG_PAGE_POOL_STATS
+/*
+ * this_cpu_inc_alloc_stat is intended to be used in softirq context
+ */
+#define this_cpu_inc_alloc_stat(pool, __stat)				\
+	do {								\
+		struct page_pool_stats __percpu *s = pool->stats;	\
+		__this_cpu_inc(s->alloc.__stat);			\
+	} while (0)
+#else
+#define this_cpu_inc_alloc_stat(pool, __stat)
+#endif
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
-- 
2.7.4

