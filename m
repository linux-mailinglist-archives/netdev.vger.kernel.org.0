Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C59527CB6
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiEPEZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiEPEZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:25:03 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AD018374
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j6so12943059pfe.13
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhTvmdEK7HHrLLgEc3IpFQmJ1GuDt+FHbBOgrYC2DyA=;
        b=PQ8All6mHHDAkmrB3gxaMW7sILpS35wMqRRv4JA5Q2ynn2ixEevUUcrj3L9VUpaAy2
         SqlVZYkK9ZO2kTJCX6pAbPx8glNaRiMQQRRoQ+UMUka7VdRrEKZgFt3bmR3lsN947ZNE
         84jxHdNbwXAzEMMCZec23sPJK5FIQ/yqUwEVYQfKlgxaL6qhmgbTgmbmK7MHn/H3wQyv
         c/3zL4yTiAJWd5PNVlBnRUBAumAaJ3UG8p6BroPytBR9rpGHiRS9YvpktggHJGUe2ciY
         P36XXGYMQ2no3Dzn3Uu/RelxQiwLIpFIrtoApqZWSXWRFfoK0KYBaEEomtN89DhWz431
         bybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhTvmdEK7HHrLLgEc3IpFQmJ1GuDt+FHbBOgrYC2DyA=;
        b=IdSn/rdtDkWNRAEkfWfU/479oaTRuNFrpSwjWairX0x3xhx2/DiCdNOSJvEijbnv99
         0NYYdEOvuToZ8ni0SoByKKVHo/perG/iwsmLzU7EF3jPki/KKeCCnR1qLzS9I2e9vo4k
         SzwpzIvAjSxmO7zsImdZmvhHn9kqVfB1eTxKZj5J15ngGDMtHT51tJTkWIAbdakAKygg
         oglRFLEcwzA9SOSK8/8cgl4uPH04ogpByMozjZeOEEzKRCFQzmM+k2cAt7gRPs2Ptk1V
         PATRfWb8G0HaB9IKdEOIlmU4dt7NUoBwodYdHvs4L1G6IjlfjYRg/+A3XRj9VTflnoKG
         89mg==
X-Gm-Message-State: AOAM531QxthB7DT20BkTEj45fJM4A2n6Z9GzA6g09BQZ/kJ3a4I4UoA/
        oybBZOPuqvjyMlQmwe/lV6k=
X-Google-Smtp-Source: ABdhPJyhAAGq0FT2g3iL8unNUN595Lin36Q4bkpXDqxneeFR+pOUgkG3zw9TK/DA6UOpn2ghm6m0Wg==
X-Received: by 2002:a65:48c5:0:b0:3c5:fe30:75dd with SMTP id o5-20020a6548c5000000b003c5fe3075ddmr13517049pgs.269.1652675102198;
        Sun, 15 May 2022 21:25:02 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:983e:a432:c95c:71c2])
        by smtp.gmail.com with ESMTPSA id w16-20020a634910000000b003f27adead72sm308403pga.90.2022.05.15.21.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 21:25:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/4] net: fix possible race in skb_attempt_defer_free()
Date:   Sun, 15 May 2022 21:24:53 -0700
Message-Id: <20220516042456.3014395-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220516042456.3014395-1-eric.dumazet@gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

A cpu can observe sd->defer_count reaching 128,
and call smp_call_function_single_async()

Problem is that the remote CPU can clear sd->defer_count
before the IPI is run/acknowledged.

Other cpus can queue more packets and also decide
to call smp_call_function_single_async() while the pending
IPI was not yet delivered.

This is a common issue with smp_call_function_single_async().
Callers must ensure correct synchronization and serialization.

I triggered this issue while experimenting smaller threshold.
Performing the call to smp_call_function_single_async()
under sd->defer_lock protection did not solve the problem.

Commit 5a18ceca6350 ("smp: Allow smp_call_function_single_async()
to insert locked csd") replaced an informative WARN_ON_ONCE()
with a return of -EBUSY, which is often ignored.
Test of CSD_FLAG_LOCK presence is racy anyway.

Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 1 +
 net/core/dev.c            | 7 +++++--
 net/core/skbuff.c         | 5 ++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 536321691c725ebd311088f4654dd04b9abbaaef..89699a299ba1b0b544b7abb782708d827abe55ac 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3127,6 +3127,7 @@ struct softnet_data {
 	/* Another possibly contended cache line */
 	spinlock_t		defer_lock ____cacheline_aligned_in_smp;
 	int			defer_count;
+	int			defer_ipi_scheduled;
 	struct sk_buff		*defer_list;
 	call_single_data_t	defer_csd;
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index a601da3b4a7c800801f763f097f00f3a3b591107..d708f95356e0b03a61e8211adcf6d272dfa322b5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4581,9 +4581,12 @@ static void rps_trigger_softirq(void *data)
 #endif /* CONFIG_RPS */
 
 /* Called from hardirq (IPI) context */
-static void trigger_rx_softirq(void *data __always_unused)
+static void trigger_rx_softirq(void *data)
 {
+	struct softnet_data *sd = data;
+
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	smp_store_release(&sd->defer_ipi_scheduled, 0);
 }
 
 /*
@@ -11381,7 +11384,7 @@ static int __init net_dev_init(void)
 		INIT_CSD(&sd->csd, rps_trigger_softirq, sd);
 		sd->cpu = i;
 #endif
-		INIT_CSD(&sd->defer_csd, trigger_rx_softirq, NULL);
+		INIT_CSD(&sd->defer_csd, trigger_rx_softirq, sd);
 		spin_lock_init(&sd->defer_lock);
 
 		init_gro_hash(&sd->backlog);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bd16e158b3668f496a9d2c8e8b6f3433a326314c..1e2180682f2e94c45e3f26059af6d18be2d9f9d3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6514,8 +6514,7 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 	sd->defer_count++;
 
 	/* kick every time queue length reaches 128.
-	 * This should avoid blocking in smp_call_function_single_async().
-	 * This condition should hardly be bit under normal conditions,
+	 * This condition should hardly be hit under normal conditions,
 	 * unless cpu suddenly stopped to receive NIC interrupts.
 	 */
 	kick = sd->defer_count == 128;
@@ -6525,6 +6524,6 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 	/* Make sure to trigger NET_RX_SOFTIRQ on the remote CPU
 	 * if we are unlucky enough (this seems very unlikely).
 	 */
-	if (unlikely(kick))
+	if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
 		smp_call_function_single_async(cpu, &sd->defer_csd);
 }
-- 
2.36.0.550.gb090851708-goog

