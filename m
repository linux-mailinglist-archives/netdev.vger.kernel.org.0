Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5B4A9178
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356159AbiBDAKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiBDAKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:48 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EABC06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:48 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so11521710pjj.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fo1he86IgYcWoGX5pibSbapZylx3CuHd2N7i1S0mBEE=;
        b=yPKqIEbbXY/B58kcgAVD4sWBwP6lFKJnwFgqCLRIdCDE8+3msnByzKIRQyQSvv/uz3
         vPu9DZTAMl7CtIhQFPYnJDDvlVYvHd1MBFHdMZyfHApuP1dobWpbK1VhVxEt4fnFW/d1
         Th+aUKaq6j07c0rAHrhvLz1asXWq566RXJS/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fo1he86IgYcWoGX5pibSbapZylx3CuHd2N7i1S0mBEE=;
        b=MwMXLi8kB1oWiWUTm0CIlnrLNPwt04Mau5fLxHkFVH1J2mhZQ0sNYiLQlrmtbXMB/5
         aB9EnZsmjYBIA/oMb1Q6HYWnHSZCVNnxJBcRwuYLltHRqG2Pm2i3+cGyG9uOMYj71cfa
         476IqlGhPIa2MZDMU1tUZ4VkzF859Ghm9gT1gmrLPnKivH/Ahn189yMywlnnsrA2hNAX
         3dlovq8FaI0MaiiHg71VpvndcYRMdiYLlIXnOxF3UV+ApCcI2NIv8y8Nn7L4FGJvk/lG
         NpE3c/pfGipFx1Oc4bOCo9CNhM7Tz4n/3jkMVc4nOtyJz15uDR6f0fF6jskieb10gYtA
         SlsQ==
X-Gm-Message-State: AOAM532aE5Kl4VOrPuonKhMQKEDAFXXYIEYMPNLYOUSVb7t9F98pAlPv
        cvXRg9nQB2kRKK4wVNDkrz4IDL4DwIFuF0uVljlH4+X3bRMuu7H7OU8Zy+WXY789IVFg/fnmHGX
        dqPcPZRby2S/cWBF5njp7Nohxooidjw6/oVa1aJeg4eNam2zGnXzPZYyV14SuP5quw94m
X-Google-Smtp-Source: ABdhPJwGYDDqXLGl6f9/9vrWQcFwerqHkcw94z8D53KjsSBXY4dpiEQz+/PcJGZUdGxZg5lfvjdBmQ==
X-Received: by 2002:a17:90a:b397:: with SMTP id e23mr209719pjr.63.1643933447065;
        Thu, 03 Feb 2022 16:10:47 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:46 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 03/11] page_pool: Allocate and free stats structure
Date:   Thu,  3 Feb 2022 16:09:25 -0800
Message-Id: <1643933373-6590-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit only alloc_percpu and free_percpu for the stats
structure.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/core/page_pool.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bd62c01..5f822b0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -73,6 +73,12 @@ static int page_pool_init(struct page_pool *pool,
 	    pool->p.flags & PP_FLAG_PAGE_FRAG)
 		return -EINVAL;
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	pool->stats = alloc_percpu(struct page_pool_stats);
+	if (!pool->stats)
+		return -ENOMEM;
+#endif
+
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
@@ -623,6 +629,9 @@ static void page_pool_free(struct page_pool *pool)
 	if (pool->p.flags & PP_FLAG_DMA_MAP)
 		put_device(pool->p.dev);
 
+#ifdef CONFIG_PAGE_POOL_STATS
+	free_percpu(pool->stats);
+#endif
 	kfree(pool);
 }
 
-- 
2.7.4

