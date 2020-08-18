Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE9248EF8
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHRTpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgHRTpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:45:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AC4C061343
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e12so23335114ybc.18
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PUGVfdOP2aURMexVjMBGkVjvFSRwFZLoF3dG2w9sHRI=;
        b=uc5YjhpHqlRskCvWMVKg+cSiYa/A861L/eoWSaTxGWjGBzijOfDXkRBrw3dFgJzXjh
         g1TtW0WpGdTR8CAIzQd6JiQdwnTjSRglv2+bBTp0uSvN9FwQ9r+Q1S8EPSvXwtjCEjVF
         Is+W6ofuQIY2HVkIs8kVKzmBrYPBY4KnHZSbFdBNoORKW7R6if6d1mdmonRqrV5FHtve
         PpPqO+kH3nlNkoPt97a3y0rfYKNsorULyNfyj+zQyFXEhCwgBpMNgVdzHlwH8Np2Z/se
         dke0BpuTU6/ETobue4wEY3BGpoz5Kc77P6rCL7GJodujDpjo8DqUxpEx5ETsRVG4ATlx
         mzdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PUGVfdOP2aURMexVjMBGkVjvFSRwFZLoF3dG2w9sHRI=;
        b=dzwTlrGLmrisF8M+3foeSzXoj2edz2JRQtD4aNBocGFZo5PA4HgnJ/L179STrtvoSi
         FS8ZatMv6b1/6zIYJzzu2dLO+GLCPTIoeuD+jwZgzyRhFm5p3TSVY0f+KP57NuwW9j9Q
         xjV3OYWJ/vCIwi7a6ZweaMs9368cjOUfEWl4P44LjWN2jSAl6iue2p6jbNBbMTXsjaLa
         txo38YWInjyq8n3QIMy3gPdg8A5C4Ra2W0fYJUtaEvNlQEmxqstcUrvUZ4WCR279Ksh/
         Zz2UPzwA1+RQBBEE8rGGVB5E1nghHl+X7mROBimaXrTq0Z1kk6n2N79RyJjzq2tf30FE
         xWSQ==
X-Gm-Message-State: AOAM530CEDDOFetOiRSVAk45n10ZjbdU743CEbAUZ7fntOfdqsmUvd3b
        xw3LTd/rQUvI46D4U1COAMHy/fy5d/VPYPz0r8KhTp8xrQeEbDIThWfGZ8wofXxisHUEg/WNn7U
        v0u7NqaEY+TyIeYbGPmiX2SqwvmJ9Po3RO1Ao40IR/YKTosglVpyr2naGwEkNLzzTqD4YMOYf
X-Google-Smtp-Source: ABdhPJxI0Y24Xs5bu0F6vVIvgMLjiFvz5KNgR5VCSAf+Ad4Vzz2OwR551qRXGS5W7FnlP812WPJtxyYt1uTA4OuD
X-Received: by 2002:a25:cbd6:: with SMTP id b205mr30726424ybg.137.1597779914436;
 Tue, 18 Aug 2020 12:45:14 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:16 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-18-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 17/18] gve: Switch to use napi_complete_done
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Yangchun Fu <yangchun@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangchun Fu <yangchun@google.com>

Use napi_complete_done to allow for the use of gro_flush_timeout.

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h      |  5 ++---
 drivers/net/ethernet/google/gve/gve_main.c | 23 ++++++++++++++--------
 drivers/net/ethernet/google/gve/gve_rx.c   | 21 ++++++++++----------
 3 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index bacb4070c755..c67bdbb0ce11 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -545,11 +545,10 @@ __be32 gve_tx_load_event_counter(struct gve_priv *priv,
 				 struct gve_tx_ring *tx);
 /* rx handling */
 void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx);
-bool gve_rx_poll(struct gve_notify_block *block, int budget);
+int gve_rx_poll(struct gve_notify_block *block, int budget);
+bool gve_rx_work_pending(struct gve_rx_ring *rx);
 int gve_rx_alloc_rings(struct gve_priv *priv);
 void gve_rx_free_rings(struct gve_priv *priv);
-bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
-		       netdev_features_t feat);
 /* Reset */
 void gve_schedule_reset(struct gve_priv *priv);
 int gve_reset(struct gve_priv *priv, bool attempt_teardown);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index ee434d3ca5e7..088e8517bb2b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -155,34 +155,41 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
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
+	/* Complete processing - don't unmask irq if busy polling is enabled */
+	if (!napi_complete_done(napi, work_done))
+		return work_done;
+
 	irq_doorbell = gve_irq_doorbell(priv, block);
 	iowrite32be(GVE_IRQ_ACK | GVE_IRQ_EVENT, irq_doorbell);
 
-	/* Double check we have no extra work.
-	 * Ensure unmask synchronizes with checking for work.
-	 */
+	/* Double check we have no extra work. Ensure unmask synchronizes with checking */
+	/* for work. */
 	dma_rmb();
+
 	if (block->tx)
 		reschedule |= gve_tx_poll(block, -1);
 	if (block->rx)
-		reschedule |= gve_rx_poll(block, -1);
+		reschedule |= gve_rx_work_pending(block->rx);
+
 	if (reschedule && napi_reschedule(napi))
 		iowrite32be(GVE_IRQ_MASK, irq_doorbell);
 
-	return 0;
+	return work_done;
 }
 
 static int gve_alloc_notify_blocks(struct gve_priv *priv)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 24bd556f488e..dad746cc65ac 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -539,7 +539,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	return true;
 }
 
-static bool gve_rx_work_pending(struct gve_rx_ring *rx)
+bool gve_rx_work_pending(struct gve_rx_ring *rx)
 {
 	struct gve_rx_desc *desc;
 	__be16 flags_seq;
@@ -607,8 +607,8 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 	return true;
 }
 
-bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
-		       netdev_features_t feat)
+static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
+			     netdev_features_t feat)
 {
 	struct gve_priv *priv = rx->gve;
 	u32 work_done = 0, packets = 0;
@@ -645,7 +645,7 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 	}
 
 	if (!work_done)
-		return false;
+		return 0;
 
 	u64_stats_update_begin(&rx->statss);
 	rx->rpackets += packets;
@@ -665,14 +665,14 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
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
 
@@ -681,8 +681,7 @@ bool gve_rx_poll(struct gve_notify_block *block, int budget)
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
2.28.0.220.ged08abb693-goog

