Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B724257EB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242704AbhJGQ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242660AbhJGQ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:27:39 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D90C061768
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:25:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w4-20020a1709029a8400b00138e222b06aso3462387plp.12
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 09:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zHxeeZD1jZwO/Usfb2NsWkAnbNZnwg7n8Dn9pOEtrEk=;
        b=lxM1eWtkvZZt6Mqczx7qeWa1aKJY2GpgnCFsyxJ0nycAY0ZlWcvjUu6LJzXvfDjRc0
         +GBMxCbmD01f0Nz5gkQ2u2QXRN3vuThx2ijGFBc1Qspx6nzmm26gJY+TeNSKncvvKTd6
         ID75ZHX68Lnj3Sl23Yt2RrdyNv13UsEYxRJYrjW05cIINAUPcDk/PZX+irXs9LEAv3Dn
         4zqFTN6WzlZ9FLdYvPottm4Y7Hy7K9JKms83e00jlTasOPUkv2srzmHdfjxwJTYWmzls
         CfOT8bcASDqN6prpsjVbT8qLJcgwZ3RlMhlxS0vDZKD/BvM0vEtYhpiDoCvZRUz/BmTt
         Gd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zHxeeZD1jZwO/Usfb2NsWkAnbNZnwg7n8Dn9pOEtrEk=;
        b=u/u3YsH92YpirnXgDdTpHtNhbnA8Eydqv7podraM3exmQRuVgvTs/1DmlrMgf3F4rq
         t4JuzHySTDubOQNB+IMhziLZV+tZP/Uxv5u+N8ZVhVqcZ4+JBIhrfi8B7pzH9axzGwHP
         xjtTQTf8kO9pFb6PRMWLy6jI8H8S5wvBBgCw9FsWMgMbOoxyPC4UTl81SSRJl4wSrfsb
         OkTFZdJUZIm5DVK+CIgxZyrlyOiiORFrAtJfvt1pnDaMpUcK26+QLBDkUnwUJrWsuPP+
         HGj26DHps6Ee+PAZThllewnQd7ljen1ONdA2dTdlXlwzsLLCRxJwXdRg3iDbA3GMwzFu
         UYug==
X-Gm-Message-State: AOAM530zYGHXchBCbZNshDbBxmyQK/6hJ0x31ms0jCA1gKoveivvKdt7
        FWFREuofw/VakETnDukADt1z+NLZOKJlANHmLI9lIsQJ22Qkm1teca4AL4LWN173MgEx9zQ3u8p
        GK6NN1LwdnboUZlexmz5LaH8P//+Zu02Kvik18IxrRpGRxVh05htKmeM+4BmV/gMJZgE=
X-Google-Smtp-Source: ABdhPJxQqIEOxPfYTHSkpp3Mk4beyZrLznIRiSKrykAYD4sVCacDp69hifydVBECan3gdZ33+yspeWXMiEUqVg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:fe55:7411:11ac:c2a7])
 (user=jeroendb job=sendgmr) by 2002:a17:902:a414:b0:13e:45cd:1939 with SMTP
 id p20-20020a170902a41400b0013e45cd1939mr4924319plq.54.1633623943851; Thu, 07
 Oct 2021 09:25:43 -0700 (PDT)
Date:   Thu,  7 Oct 2021 09:25:31 -0700
In-Reply-To: <20211007162534.1502578-1-jeroendb@google.com>
Message-Id: <20211007162534.1502578-4-jeroendb@google.com>
Mime-Version: 1.0
References: <20211007162534.1502578-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net-next 4/7] gve: Recover from queue stall due to missed IRQ
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        John Fraker <jfraker@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fraker <jfraker@google.com>

Don't always reset the driver on a TX timeout. Attempt to
recover by kicking the queue in case an IRQ was missed.

Fixes: 9e5f7d26a4c08 ("gve: Add workqueue and reset support")
Signed-off-by: John Fraker <jfraker@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  4 +-
 drivers/net/ethernet/google/gve/gve_adminq.h |  1 +
 drivers/net/ethernet/google/gve/gve_main.c   | 48 +++++++++++++++++++-
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 003b30b91c6d..b8d46adb9c1a 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -30,7 +30,7 @@
 #define GVE_MIN_MSIX 3
 
 /* Numbers of gve tx/rx stats in stats report. */
-#define GVE_TX_STATS_REPORT_NUM	5
+#define GVE_TX_STATS_REPORT_NUM	6
 #define GVE_RX_STATS_REPORT_NUM	2
 
 /* Interval to schedule a stats report update, 20000ms. */
@@ -413,7 +413,9 @@ struct gve_tx_ring {
 	u32 q_num ____cacheline_aligned; /* queue idx */
 	u32 stop_queue; /* count of queue stops */
 	u32 wake_queue; /* count of queue wakes */
+	u32 queue_timeout; /* count of queue timeouts */
 	u32 ntfy_id; /* notification block index */
+	u32 last_kick_msec; /* Last time the queue was kicked */
 	dma_addr_t bus; /* dma address of the descr ring */
 	dma_addr_t q_resources_bus; /* dma address of the queue resources */
 	dma_addr_t complq_bus_dqo; /* dma address of the dqo.compl_ring */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 47c3d8f313fc..3953f6f7a427 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -270,6 +270,7 @@ enum gve_stat_names {
 	TX_LAST_COMPLETION_PROCESSED	= 5,
 	RX_NEXT_EXPECTED_SEQUENCE	= 6,
 	RX_BUFFERS_POSTED		= 7,
+	TX_TIMEOUT_CNT			= 8,
 	// stats from NIC
 	RX_QUEUE_DROP_CNT		= 65,
 	RX_NO_BUFFERS_POSTED		= 66,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 74e35a87ec38..d969040deab6 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -24,6 +24,9 @@
 #define GVE_VERSION		"1.0.0"
 #define GVE_VERSION_PREFIX	"GVE-"
 
+// Minimum amount of time between queue kicks in msec (10 seconds)
+#define MIN_TX_TIMEOUT_GAP (1000 * 10)
+
 const char gve_version_str[] = GVE_VERSION;
 static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
@@ -1109,9 +1112,47 @@ static void gve_turnup(struct gve_priv *priv)
 
 static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
-	struct gve_priv *priv = netdev_priv(dev);
+	struct gve_notify_block *block;
+	struct gve_tx_ring *tx = NULL;
+	struct gve_priv *priv;
+	u32 last_nic_done;
+	u32 current_time;
+	u32 ntfy_idx;
+
+	netdev_info(dev, "Timeout on tx queue, %d", txqueue);
+	priv = netdev_priv(dev);
+	if (txqueue > priv->tx_cfg.num_queues)
+		goto reset;
+
+	ntfy_idx = gve_tx_idx_to_ntfy(priv, txqueue);
+	if (ntfy_idx > priv->num_ntfy_blks)
+		goto reset;
+
+	block = &priv->ntfy_blocks[ntfy_idx];
+	tx = block->tx;
 
+	current_time = jiffies_to_msecs(jiffies);
+	if (tx->last_kick_msec + MIN_TX_TIMEOUT_GAP > current_time)
+		goto reset;
+
+	/* Check to see if there are missed completions, which will allow us to
+	 * kick the queue.
+	 */
+	last_nic_done = gve_tx_load_event_counter(priv, tx);
+	if (last_nic_done - tx->done) {
+		netdev_info(dev, "Kicking queue %d", txqueue);
+		iowrite32be(GVE_IRQ_MASK, gve_irq_doorbell(priv, block));
+		napi_schedule(&block->napi);
+		tx->last_kick_msec = current_time;
+		goto out;
+	} // Else reset.
+
+reset:
 	gve_schedule_reset(priv);
+
+out:
+	if (tx)
+		tx->queue_timeout++;
 	priv->tx_timeo_cnt++;
 }
 
@@ -1239,6 +1280,11 @@ void gve_handle_report_stats(struct gve_priv *priv)
 				.value = cpu_to_be64(last_completion),
 				.queue_id = cpu_to_be32(idx),
 			};
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(TX_TIMEOUT_CNT),
+				.value = cpu_to_be64(priv->tx[idx].queue_timeout),
+				.queue_id = cpu_to_be32(idx),
+			};
 		}
 	}
 	/* rx stats */
-- 
2.33.0.800.g4c38ced690-goog

