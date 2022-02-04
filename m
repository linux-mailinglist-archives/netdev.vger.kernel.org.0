Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98AB4A9179
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356151AbiBDAKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiBDAKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:46 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5278DC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:46 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m7so3969318pjk.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uaxwzggX7nkIfNzdgxAq8JqDHlXgho20pfn4LcykN+g=;
        b=Il4salgRGjcv9FBDj+LGVcUj/vWO8ezSYKjqmE0HtjkwCIhLY/qbls23/nvNRMlMu/
         S3XmHDGWLkbWd4DiO1rWOuqOvj9xHMew4B5wvIcQVC2YmA+8se5T61K9B0AVVIwmoanH
         3sSAsiFA7yJgl5yqO++Nk8SR+cLhrApH8Gyrg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uaxwzggX7nkIfNzdgxAq8JqDHlXgho20pfn4LcykN+g=;
        b=jIlZKV7W4w80Yb46BvWOReB50akkhJs18Okh5heXv5Os6WDT9NX452hzEghQpHuLGq
         k8VeTOY0Ha8aPLV2sgq9UMkVrPaSe8kpLCo6Wx7dZV0kVgnBBF2UhnEuDZL3lLRPMxRe
         nFkYYFhHhA1P4aCqTY7HWBYFkIGWddNK77GB2dktTyTNFjVsDnNzScv+JZsGwP1V3CnT
         kB7KivLsbAAeVTUB9q2Ab2mD2G7FLleADNu4TuT74AdE6zIYW6DcNkTVAi+I06cJ24t3
         0oxX7fOG8jA/eX/KT7IBeDgxMbD/XzKH5S406QfVNtLllwNkBRQP1svGRpjjut9yAbSP
         1Obw==
X-Gm-Message-State: AOAM5339AOoJfQeTrg3fxJAAsJ6X0uCbktOISY27c0MoDoqOFSP0rTMg
        d8ikTnE1cumIscICENxLPV6L8SJxdEnAB1i3lXPuWxERRXiF+LTnmRSv8PyVcRhFMJ0n9ko1/BZ
        uuv13q3ck1Tp3S4+hCZgfBgRx4xSeGuNIU8loUaKVpEZWesoYs/1l+vy0EPvvsWe7D6eX
X-Google-Smtp-Source: ABdhPJwgNmxQ6ELybSBzb/16N1wtQ2QtftHS0M39wT21GNDzyZ0ApI73afJvDXvwSsPLv6EixmXzOw==
X-Received: by 2002:a17:902:e844:: with SMTP id t4mr635176plg.104.1643933444955;
        Thu, 03 Feb 2022 16:10:44 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:44 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 02/11] page_pool: Add per-pool-per-cpu struct.
Date:   Thu,  3 Feb 2022 16:09:24 -0800
Message-Id: <1643933373-6590-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A per pool per cpu struct is added. Empty for now as members will be added
next.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 79a8055..93e587d 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -135,7 +135,15 @@ struct page_pool {
 	refcount_t user_cnt;
 
 	u64 destroy_cnt;
+#ifdef CONFIG_PAGE_POOL_STATS
+	struct page_pool_stats __percpu *stats;
+#endif
+};
+
+#ifdef CONFIG_PAGE_POOL_STATS
+struct page_pool_stats {
 };
+#endif
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
 
-- 
2.7.4

