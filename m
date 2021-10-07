Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E39C4257E8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242678AbhJGQ1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242664AbhJGQ1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:27:34 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F0AC061762
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:25:40 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso121249pgv.22
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 09:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MLNq0Ecu/DTuLkV9EQCwfPnAyKraiDA8g5gWng3WZe4=;
        b=LjqHvqT8SH/cHaVN0k7538hp+srgMMgDZqZm6OIzOL0M2hahn+Xbvy3a7Zz/C6Dexi
         /TH0Jo47yObdm67BPV53GJPBgSerB449VkGnMjGA3A/1nu36moiC8aOoBbpYjSXUp2F3
         FcXuK1ROhBgzd03Imsja6F9or23X7VZealSi5TaPRwzR8qrASuubQ+G0N1Esr8GrD0z0
         lKkKL8GcJtloZGQL4jWVMJaQa6vbHQs87j5WXdQEVCRtqz30fJPlZ/1hmUgLsPnW4BxC
         NnoFpGGSdKNeX03eLpJcitFlQbwa8iY6S6SobpmllbBlbU0Usty3pX1ER5c0+03wKvJT
         /hMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MLNq0Ecu/DTuLkV9EQCwfPnAyKraiDA8g5gWng3WZe4=;
        b=eSYLvmkLk7nV5odhWuFpdGYtQ3jvSeXrMyquHedHzXjmmpW+K+0Mfvf6gsqm0dJp/p
         x/V5NNy206kINeVThY9GgcqZbiyUP8Ob1kCW7FJZEf49/upJMmArYE1LxH8XERqZANmV
         BlUf81A3hPlMs9JQPaoQ9vnwUBCGRJTfVPL3iXUf1rCbOTcpbrbucT6X2XEeONgb7kTQ
         zNwLw+z9sp7SBCD0aLsKuKU0/qisa9sXijkGo9EHQnz+9Ov4eK3ZLGTxe8Ip1S9Usdgr
         GKknBU47K7UvHK/qirXsmqfzdCK4hl0MCFNVYasS7NIwzvmIFJJDGNz7BCV5jniRBzif
         +xhw==
X-Gm-Message-State: AOAM5303gN31YAbXSfFvjHTM847+Jbb32m6B5T9le3FImm+fx3MZyHKF
        6B5iphgqo5Ukbwztp07Hw1NuF+jE0sSHHpUP4JleWsU9yqudul+nDVlB0OcDagPdKQ/ULR6AbUl
        L0cpqT3iTccng77FpjOHA1Cge5T524ZKg9ZcHyA5eHjsDghKwp81RyqFiS1VVd2mXjDQ=
X-Google-Smtp-Source: ABdhPJwbXCC+E3iY/Okreuc4VazyysECZJHcFaNP9JMc6HZzxtGTWHPtkcQ4wJIfiDZOMVinUhkawEOq5LPSmg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:fe55:7411:11ac:c2a7])
 (user=jeroendb job=sendgmr) by 2002:aa7:9203:0:b0:44c:aa4f:5496 with SMTP id
 3-20020aa79203000000b0044caa4f5496mr5254454pfo.60.1633623938725; Thu, 07 Oct
 2021 09:25:38 -0700 (PDT)
Date:   Thu,  7 Oct 2021 09:25:28 -0700
Message-Id: <20211007162534.1502578-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net-next 1/7] gve: Switch to use napi_complete_done
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Yangchun Fu <yangchun@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangchun Fu <yangchun@google.com>

Use napi_complete_done to allow for the use of gro_flush_timeout.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h      |  5 ++-
 drivers/net/ethernet/google/gve/gve_main.c | 38 +++++++++++++---------
 drivers/net/ethernet/google/gve/gve_rx.c   | 37 +++++++++++----------
 3 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 85bf825606e8..59c525800e5d 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -825,11 +825,10 @@ __be32 gve_tx_load_event_counter(struct gve_priv *priv,
 				 struct gve_tx_ring *tx);
 /* rx handling */
 void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx);
-bool gve_rx_poll(struct gve_notify_block *block, int budget);
+int gve_rx_poll(struct gve_notify_block *block, int budget);
+bool gve_rx_work_pending(struct gve_rx_ring *rx);
 int gve_rx_alloc_rings(struct gve_priv *priv);
 void gve_rx_free_rings_gqi(struct gve_priv *priv);
-bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
-		       netdev_features_t feat);
 /* Reset */
 void gve_schedule_reset(struct gve_priv *priv);
 int gve_reset(struct gve_priv *priv, bool attempt_teardown);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index cd9df68cc01e..388262c61b8d 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -181,34 +181,40 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
 	__be32 __iomem *irq_doorbell;
 	bool reschedule = false;
 	struct gve_priv *priv;
+	int work_done = 0;
 
 	block = container_of(napi, struct gve_notify_block, napi);
 	priv = block->priv;
 
 	if (block->tx)
 		reschedule |= gve_tx_poll(block, budget);
-	if (block->rx)
-		reschedule |= gve_rx_poll(block, budget);
+	if (block->rx) {
+		work_done = gve_rx_poll(block, budget);
+		reschedule |= work_done == budget;
+	}
 
 	if (reschedule)
 		return budget;
 
-	napi_complete(napi);
-	irq_doorbell = gve_irq_doorbell(priv, block);
-	iowrite32be(GVE_IRQ_ACK | GVE_IRQ_EVENT, irq_doorbell);
+       /* Complete processing - don't unmask irq if busy polling is enabled */
+	if (likely(napi_complete_done(napi, work_done))) {
+		irq_doorbell = gve_irq_doorbell(priv, block);
+		iowrite32be(GVE_IRQ_ACK | GVE_IRQ_EVENT, irq_doorbell);
 
-	/* Double check we have no extra work.
-	 * Ensure unmask synchronizes with checking for work.
-	 */
-	mb();
-	if (block->tx)
-		reschedule |= gve_tx_poll(block, -1);
-	if (block->rx)
-		reschedule |= gve_rx_poll(block, -1);
-	if (reschedule && napi_reschedule(napi))
-		iowrite32be(GVE_IRQ_MASK, irq_doorbell);
+		/* Double check we have no extra work.
+		 * Ensure unmask synchronizes with checking for work.
+		 */
+		mb();
 
-	return 0;
+		if (block->tx)
+			reschedule |= gve_tx_poll(block, -1);
+		if (block->rx)
+			reschedule |= gve_rx_work_pending(block->rx);
+
+		if (reschedule && napi_reschedule(napi))
+			iowrite32be(GVE_IRQ_MASK, irq_doorbell);
+	}
+	return work_done;
 }
 
 static int gve_napi_poll_dqo(struct napi_struct *napi, int budget)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index bb8261368250..bb9fc456416b 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -450,7 +450,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	return true;
 }
 
-static bool gve_rx_work_pending(struct gve_rx_ring *rx)
+bool gve_rx_work_pending(struct gve_rx_ring *rx)
 {
 	struct gve_rx_desc *desc;
 	__be16 flags_seq;
@@ -518,8 +518,8 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 	return true;
 }
 
-bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
-		       netdev_features_t feat)
+int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
+		      netdev_features_t feat)
 {
 	struct gve_priv *priv = rx->gve;
 	u32 work_done = 0, packets = 0;
@@ -553,13 +553,15 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 	}
 
 	if (!work_done && rx->fill_cnt - cnt > rx->db_threshold)
-		return false;
+		return 0;
 
-	u64_stats_update_begin(&rx->statss);
-	rx->rpackets += packets;
-	rx->rbytes += bytes;
-	u64_stats_update_end(&rx->statss);
-	rx->cnt = cnt;
+	if (work_done) {
+		u64_stats_update_begin(&rx->statss);
+		rx->rpackets += packets;
+		rx->rbytes += bytes;
+		u64_stats_update_end(&rx->statss);
+		rx->cnt = cnt;
+	}
 
 	/* restock ring slots */
 	if (!rx->data.raw_addressing) {
@@ -570,26 +572,26 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		 * falls below a threshold.
 		 */
 		if (!gve_rx_refill_buffers(priv, rx))
-			return false;
+			return 0;
 
 		/* If we were not able to completely refill buffers, we'll want
 		 * to schedule this queue for work again to refill buffers.
 		 */
 		if (rx->fill_cnt - cnt <= rx->db_threshold) {
 			gve_rx_write_doorbell(priv, rx);
-			return true;
+			return budget;
 		}
 	}
 
 	gve_rx_write_doorbell(priv, rx);
-	return gve_rx_work_pending(rx);
+	return work_done;
 }
 
-bool gve_rx_poll(struct gve_notify_block *block, int budget)
+int gve_rx_poll(struct gve_notify_block *block, int budget)
 {
 	struct gve_rx_ring *rx = block->rx;
 	netdev_features_t feat;
-	bool repoll = false;
+	int work_done = 0;
 
 	feat = block->napi.dev->features;
 
@@ -598,8 +600,7 @@ bool gve_rx_poll(struct gve_notify_block *block, int budget)
 		budget = INT_MAX;
 
 	if (budget > 0)
-		repoll |= gve_clean_rx_done(rx, budget, feat);
-	else
-		repoll |= gve_rx_work_pending(rx);
-	return repoll;
+		work_done = gve_clean_rx_done(rx, budget, feat);
+
+	return work_done;
 }
-- 
2.33.0.800.g4c38ced690-goog

