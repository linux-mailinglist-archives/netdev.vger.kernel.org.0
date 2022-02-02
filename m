Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67394A6984
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbiBBBNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243618AbiBBBNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:13 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038EEC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:13 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j16so16871604plx.4
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=daCp29CfHqba5AzFqLjgXp71o/Cmax20BodJH4eahfI=;
        b=rCfcL+1/Iefyd2FrXdrcQsQIzJ+47YUFjUB1ORbXt19QFY+Hi8Vq689uM9TB+fyZtc
         mcXR1zGpVrNlUUsMMwyeh0C9UrSxPCrFbFp4tRnJcv5aE7y+8sl1scePmp2KYFEOknEG
         n3FgEbQ+sGHXhZD3QIh3rc6Bl8hR6/Gh+zlZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=daCp29CfHqba5AzFqLjgXp71o/Cmax20BodJH4eahfI=;
        b=Dw88/wId3d5yl4sqQAXocPhqHpK+fvaaiVDcsiAgEs/78AlRgxnxzJqv/3VicM0D33
         pisgYkq/jVhrh6wjhm7JLRmRb4lIW6lY7OSwwZ8Ihcr3O0fioWdSIG+C38pEJvun6WHm
         EXB5AnmUBeYl9zBZdqxUABIypcjtP84pklAAHeTtPejtjea9XXh5/5KGE6/uEfqlVQbw
         8b2C4QdhnZw6p+h7oDkgf2wauJ1s32oOYZhDs16VO585m7XmIa6p+SiMac1bOGxOAyA9
         2NkXE/ITgWXLOQmssIZzvUihLOk7dKR54/U/ubNGkWJQc2n8w1IoWeTuZOARZF29a0SG
         yONA==
X-Gm-Message-State: AOAM531RsPz8u29WF/OR0kYIHHlelUtbrc95iN1I2fHqlkLUl/1uvubL
        zar6/QeQ5FXJlkx7EP0l1keUOrf5NYChpLDIgIYLxBMMsFODF/Bg2y+bDVo4KQYPdeIM53nSZTE
        O57XyChmntslONDwG/r+WXAZnORJUsMwKPhiQ4yHBVi894JgNKIfUySaPcLVmYpuZkHwP
X-Google-Smtp-Source: ABdhPJxYIc/L5PcsCZEH5mMcEf/+DqTB1uM6RrRc/tuGJm4oL8UoJPloCuGX2Bz7JL3YZffOB2Ffgg==
X-Received: by 2002:a17:902:aa90:: with SMTP id d16mr28355867plr.89.1643764392117;
        Tue, 01 Feb 2022 17:13:12 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:11 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 03/10] page_pool: Add a macro for incrementing stats
Date:   Tue,  1 Feb 2022 17:12:09 -0800
Message-Id: <1643764336-63864-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
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

