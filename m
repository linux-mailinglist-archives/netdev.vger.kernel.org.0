Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6293E42938A
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbhJKPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242833AbhJKPjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:39:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D079CC061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:01 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j12-20020aa783cc000000b0044b702424b7so7639479pfn.6
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sKHNXPZkAHz9ntbu1HD5pE+BXuKXxMUQa+JKWhdPjkA=;
        b=JvT+Sd2IRA5Oj6URdobLnrY55vs4SksDZwcoSw9ylrUowoPM17zghT/19M0V00Gvsc
         hBj2Jd+hFGYUTBjOC4jGOtWs/aO60YWc8RvXywXf6GptO7I5jnDY2x2Ya+znsKDGeKcv
         EkzEvYL28OI6FkA/0iZ6Bdu8pv0QTAH57XftnBanRlyx0SumlmdmYlhh8a4flh8GZVnU
         11FC9LLrKfZ298L4CmfB4zRR37S5DKhIL2KjGfIlzSOmUrEpKCqpksdb86tGAdliev1U
         4NuOnpuQ0fu13JIRvPdWKputl2BvgAfrhMjKeDV/RTmL/hfuz2pj0NxhnP+NO2aiXQ+R
         8p0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sKHNXPZkAHz9ntbu1HD5pE+BXuKXxMUQa+JKWhdPjkA=;
        b=crYMhuJ1E/PD49Tu0NUii8Yiyd8nlHI2Ag5/Nu2JMIWELNojaorfcVAfAeI4zQ877s
         dixYTqB8f0B6lqYTrECabPz+0uf4LvmA9UTzbR9VBo5MIX1FSDXqb2K9PALuI5Zo1qto
         TdBRkhtc9NOJIfF3F/2xb8P3GooYu0VUqYZTRAXPrfNoUfqxakvQedfH8PrWgXFZlvES
         ERWkp4KTNZPH4I9vL0P3c2TlA7f4/xcHS4Rc4qEk2ISoQ6Eo0Z5LleabdYISEDoHRWwM
         TIZBYAUTbn5W0JFPGx/kLgYLFZAWgV/zAONjuKXHRH8YoPH857QchMw9RsoxvPFJEbWZ
         xGog==
X-Gm-Message-State: AOAM530kBDN7I3WX9znVP4diGEfda88NbJPN/EBwDAgdTgnhvcJDIOBT
        fSwd+/3dGqQTMy3YC8yXE2/eL767MTlpBKAU7GQnP4YmTLx4NgONNymvpwIU4s/AjI2Luev5GN9
        tsoPy/4FFw2qTQF0ZaDrzr9v0f/eqmMu0ogZ7wkFx36vaY7hW30zbhmql0jK6drd6vO4=
X-Google-Smtp-Source: ABdhPJwkqpVW442BsvalDdK2YwdGuG04zuQDKuXjf/YjgE/w3JRL6v+uXl/XkKccCpE0SMuNZPuICiUMPOhM0A==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:94b6:8af3:6cef:e277])
 (user=jeroendb job=sendgmr) by 2002:a62:6541:0:b0:44c:2988:7d9d with SMTP id
 z62-20020a626541000000b0044c29887d9dmr26217432pfb.50.1633966621268; Mon, 11
 Oct 2021 08:37:01 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:36:47 -0700
In-Reply-To: <20211011153650.1982904-1-jeroendb@google.com>
Message-Id: <20211011153650.1982904-5-jeroendb@google.com>
Mime-Version: 1.0
References: <20211011153650.1982904-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH net-next v2 4/7] gve: Recover from queue stall due to missed IRQ
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
index 3de561e22659..51ed8fe71d2d 100644
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
index b6805ad2011b..7647cd05b1d2 100644
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
 
@@ -1121,9 +1124,47 @@ static void gve_turnup(struct gve_priv *priv)
 
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
 
@@ -1252,6 +1293,11 @@ void gve_handle_report_stats(struct gve_priv *priv)
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
2.33.0.882.g93a45727a2-goog

v2: Unchanged
