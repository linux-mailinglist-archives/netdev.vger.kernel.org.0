Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150D64B5B65
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiBNUqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:46:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiBNUp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:45:58 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE7D1B4005
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:44:00 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z17so11445010plb.9
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tXzV6UfdgK2bFqeHo+R7QexQELCVo82Dje9rkGsbYQI=;
        b=jP2QNd6ym1cA44N4Z4M2eAlHfETlLaPmWkBpDrEyOpnRPWZQljUHC6rZg8rbQpe8H4
         zH/1dkaFslDcSQbIJvrG2JwWKWqfKIMatpBI8p5zBpaB+qfHWfVgJViE01Wx9I6BWo/t
         6A8I1z1fp+L43jra0eshS5jiVYCCCxGsYoPzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tXzV6UfdgK2bFqeHo+R7QexQELCVo82Dje9rkGsbYQI=;
        b=T7ONfeKIUiLK2+qJj8dIZRPJWxfTJW6sQyVKbMkX78yvULPbYDXqAOMh6yrwprPxi1
         sE3VeTM6fMSQq9BXiFqERmBeXegeLhH+OXwcR20ueVCA25wmM36JpDvznwPfxMAW9/dw
         zrnqQFUo1NrqeKFUL4AQ/DWYl4AdL2+N9UQ8E71IGjb3K4Q16ShJPoEyIrQOfGFbar3w
         iJQSfdm4ctPjfplQnkdit0pGJRnJA+/1c022YBl4DFX4UIBuj79QpyjJ4W1WcDopHAky
         vaM5ily8z5vzP2CYMJs+tCoac5VkaR+qWDUssQ4wGAj6knaqpgGfHEQScpAKPEk4X4PX
         tMrg==
X-Gm-Message-State: AOAM530yB6btYhcMmXfEDOFtGG6S/7gb1WWJ3vo2g3kxYiriQwng0ccg
        yMHcEIcbDuyqMKxIyt/kx2Bh5cZIeGSs5Z/M76ALxD0bDBC7fLtigR9KSD/36e2oN4yAnKy0mLj
        TGfn2g6gvdGs+fw+WG4n74dj24V4oCXI2mZNfKAdT9viIjt5EE8xtCVv4rE8ShSWqXxjb
X-Google-Smtp-Source: ABdhPJyQMJnRt89r/SDWDxWYCyjJYmJoDAgBo+dNDJkSw3t/uGFZROKgmAvjBgUj1smOVbwo7oUDbA==
X-Received: by 2002:a17:902:c40b:: with SMTP id k11mr494510plk.121.1644869017216;
        Mon, 14 Feb 2022 12:03:37 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a38sm25010916pfx.121.2022.02.14.12.03.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Feb 2022 12:03:36 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v5 2/2] page_pool: Add function to batch and return stats
Date:   Mon, 14 Feb 2022 12:02:29 -0800
Message-Id: <1644868949-24506-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1644868949-24506-1-git-send-email-jdamato@fastly.com>
References: <1644868949-24506-1-git-send-email-jdamato@fastly.com>
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
index d827ab1..6016c0c 100644
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

