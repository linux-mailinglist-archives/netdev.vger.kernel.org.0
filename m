Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2A1429387
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242443AbhJKPi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239234AbhJKPi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:38:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A27C061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:36:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b126-20020a251b84000000b005bd8aca71a2so4008507ybb.4
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MzS39mmkdZRlhSNwPWiTmcSGcVFNuo/17rd0/eHH/jw=;
        b=T+B3zaGbOq3ycwvggd9NKZh2hs8iOFF50/QYQhW+/8eLe9fUxzS3D+IuObJGs78TNg
         agRqPzd4I2GxsD+dhdIqV9sCP9uh/hbv+xAjMC49aBHYoVkMWAHLTaZK5n8GWO8KKH/s
         dnc0IF513lCTk9rNYfgm31I9E6PE9eHrVtFa8WmcbUMzvWJDZ+Lzp+0FOQtOijYQaN2J
         qmj185GaqUNtYmPGusjFDelTAyfDOaaJ43BEI9qFtNf4SLeXT8KU8egEqmRszi7TOCrL
         FN5bp2Y8AC2SQy/4JiDJ8U0LPeNJYQYkLkV6lDmld6m9ViVn4GELbrTEbzQBbTnifuip
         ewNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MzS39mmkdZRlhSNwPWiTmcSGcVFNuo/17rd0/eHH/jw=;
        b=MbMuuX6qacR1ApxLCn6+u4NGOom9FyWj0VEQEkAe5jsN7pXevrqaAmuBeGh8+p7vAt
         0qL2A5JOmNUoxqHihvDZsinjBIvvcvDfhRopLb5o7dyCgQylcWDF1OwXVAQc90BCchVt
         nwtHnpzXpeAGJTLvcRKsHsW3/lv89vIteT7In0GzeQxF/UHgGRF/C0KdyMENJruzEPoq
         KmDiQHMFpsrjKQafteeL4FL+kO/8spbGdmXh4pnVZ72hy4FYkJKltHIPwGnW94NECUKY
         PC/DHotnbE/L5zuqwLyAXVS76+Q/NggB/Nk2PfGgsC2WtYXhWNqmuu1cnR10uULOYpBf
         kKDg==
X-Gm-Message-State: AOAM533YT/9/jBb0zvKHQzF7SoybosNpsWD6hwpfqMyVicu4Z9phis2C
        0EMf5dydhvS99UDH3eQelEl6QiTxfHf7aUykEyl2iNgOfK8a/ESBx/cItaKk5lzrHcQ3wbYIRro
        TOsUDtKN3n1xxyiT4z2vSlHxrCeKiR+GzIXOAtNl6XDKBs/cidn0cZFbObahZooSpJhE=
X-Google-Smtp-Source: ABdhPJwgwhjb/LN95uwotpYjApGWZPcl+GP8+dnYCD6ZoaDs5e6pFZcY57lfVEPu9d0nky9K9LgEXDy6UreKhQ==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:94b6:8af3:6cef:e277])
 (user=jeroendb job=sendgmr) by 2002:a05:6902:1246:: with SMTP id
 t6mr23060277ybu.187.1633966616087; Mon, 11 Oct 2021 08:36:56 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:36:44 -0700
In-Reply-To: <20211011153650.1982904-1-jeroendb@google.com>
Message-Id: <20211011153650.1982904-2-jeroendb@google.com>
Mime-Version: 1.0
References: <20211011153650.1982904-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH net-next v2 1/7] gve: Switch to use napi_complete_done
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
index 2f93ed470590..4abd53bdde73 100644
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
index 5b5dcaaeed7f..b41679ab0dbe 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -192,34 +192,40 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
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
index 94941d4e4744..3347879a4a5d 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -456,7 +456,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	return true;
 }
 
-static bool gve_rx_work_pending(struct gve_rx_ring *rx)
+bool gve_rx_work_pending(struct gve_rx_ring *rx)
 {
 	struct gve_rx_desc *desc;
 	__be16 flags_seq;
@@ -524,8 +524,8 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 	return true;
 }
 
-bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
-		       netdev_features_t feat)
+static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
+			     netdev_features_t feat)
 {
 	struct gve_priv *priv = rx->gve;
 	u32 work_done = 0, packets = 0;
@@ -559,13 +559,15 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
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
@@ -576,26 +578,26 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
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
 
@@ -604,8 +606,7 @@ bool gve_rx_poll(struct gve_notify_block *block, int budget)
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
2.33.0.882.g93a45727a2-goog

v2: Fixed compilation warning
