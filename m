Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE473B354A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhFXSKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhFXSK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC62C0613A2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y2-20020a0569020522b0290553ecd1c09bso495022ybs.10
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gwutKk2MXPqlYF8DRXhMSqy/SwYg9gAm6CUMvPoJ+3s=;
        b=ngE56E4Ao07eBKr5OSBDPt/I9XyR63D2Z+r9NFPORdss38H0Ge+PGopp0/3JDZVmij
         Dlu1NwmxHi9gUVkZRHInOAko18Yib+k9lKsqFfrmp79Ivq6M73OxYJdYUElpe9Tu5m/i
         WC2ylPF8OTOl17OgUcItn8BsFPWSHvAlXWXHsXkyi76pKiKr9cmIZpjW2sofNqbBy5iY
         HwG0vhf4rRefQRbWz58BaJOeXp/n9M973df0gCmjS4Umc27Qxgz4kY9bYZmagnjLDlg1
         dorMMjg0OxDM4y9OozR3TGm6/7B18uTkW+b4g2CsHPpoOjTTv4BWEnqNdUZRkJDIFykj
         t0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gwutKk2MXPqlYF8DRXhMSqy/SwYg9gAm6CUMvPoJ+3s=;
        b=JAUxdoAjlnPQKfkGYlo0tTa6j7vL3vQF+8MIzf05mhSsC7fPpGPLctLcRPaZKDhKvg
         gXPCR+ZIh4pKzyZNu/WdWu26Nj6rlLdwSwBF8nVg1Ji+HGs14kz/oUhwZGH8g0UDZDXd
         ZLEHNyQ3Z0cGJR8X7QqbU4zuj48TTu6AZjoFX5ChLRaOCgE4j+8bi6/5L5EcumE0mJQr
         Up7PEYayk67nNjf6QkRqqqd06Sw3v/kpBSbKvOt8mT5lNLb0EsAwx5FMFKu34dW4f2kR
         WwLTOgafDfu27ihZHfFE7dRdKlwT50lWnTiGW0IXAsiebHUN1VUVhVrcDVaQ5KRHHpDo
         FGoQ==
X-Gm-Message-State: AOAM532Tz9QDsJzOORA4lG9t0jv9zLdASg4EJlcVHhjhEDOi5g+v7cS5
        V55AzsT1o0Vss7VLoMOZJ9qcsgQ=
X-Google-Smtp-Source: ABdhPJyvygmIy4tDKO8/kLy0dsO88vTkXFlFWkPHFNGyU20trMTBoqgHw2VvI5OhITJbdhyugzleqg8=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:cf08:: with SMTP id f8mr6446473ybg.249.1624558078000;
 Thu, 24 Jun 2021 11:07:58 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:28 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-13-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 12/16] gve: DQO: Add core netdev features
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add napi netdev device registration, interrupt handling and initial tx
and rx polling stubs. The stubs will be filled in follow-on patches.

Also:
- LRO feature advertisement and handling
- Also update ethtool logic

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/Makefile      |   2 +-
 drivers/net/ethernet/google/gve/gve.h         |   2 +
 drivers/net/ethernet/google/gve/gve_adminq.c  |   2 +
 drivers/net/ethernet/google/gve/gve_dqo.h     |  32 +++
 drivers/net/ethernet/google/gve/gve_ethtool.c |  12 +-
 drivers/net/ethernet/google/gve/gve_main.c    | 188 ++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  24 +++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  |  23 +++
 8 files changed, 260 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/ethernet/google/gve/gve_dqo.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_rx_dqo.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_tx_dqo.c

diff --git a/drivers/net/ethernet/google/gve/Makefile b/drivers/net/ethernet/google/gve/Makefile
index 0143f4471e42..b9a6be76531b 100644
--- a/drivers/net/ethernet/google/gve/Makefile
+++ b/drivers/net/ethernet/google/gve/Makefile
@@ -1,4 +1,4 @@
 # Makefile for the Google virtual Ethernet (gve) driver
 
 obj-$(CONFIG_GVE) += gve.o
-gve-objs := gve_main.o gve_tx.o gve_rx.o gve_ethtool.o gve_adminq.o gve_utils.o
+gve-objs := gve_main.o gve_tx.o gve_tx_dqo.o gve_rx.o gve_rx_dqo.o gve_ethtool.o gve_adminq.o gve_utils.o
diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 8a2a8d125090..d6bf0466ae8b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -45,6 +45,8 @@
 /* PTYPEs are always 10 bits. */
 #define GVE_NUM_PTYPES	1024
 
+#define GVE_RX_BUFFER_SIZE_DQO 2048
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index cf017a499119..5bb56b454541 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -714,6 +714,8 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	if (gve_is_gqi(priv)) {
 		err = gve_set_desc_cnt(priv, descriptor);
 	} else {
+		/* DQO supports LRO. */
+		priv->dev->hw_features |= NETIF_F_LRO;
 		err = gve_set_desc_cnt_dqo(priv, descriptor, dev_op_dqo_rda);
 	}
 	if (err)
diff --git a/drivers/net/ethernet/google/gve/gve_dqo.h b/drivers/net/ethernet/google/gve/gve_dqo.h
new file mode 100644
index 000000000000..cff4e6ef7bb6
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_dqo.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2021 Google, Inc.
+ */
+
+#ifndef _GVE_DQO_H_
+#define _GVE_DQO_H_
+
+#include "gve_adminq.h"
+
+#define GVE_ITR_ENABLE_BIT_DQO BIT(0)
+#define GVE_ITR_CLEAR_PBA_BIT_DQO BIT(1)
+#define GVE_ITR_NO_UPDATE_DQO (3 << 3)
+
+#define GVE_TX_IRQ_RATELIMIT_US_DQO 50
+#define GVE_RX_IRQ_RATELIMIT_US_DQO 20
+
+netdev_tx_t gve_tx_dqo(struct sk_buff *skb, struct net_device *dev);
+bool gve_tx_poll_dqo(struct gve_notify_block *block, bool do_clean);
+int gve_rx_poll_dqo(struct gve_notify_block *block, int budget);
+
+static inline void
+gve_write_irq_doorbell_dqo(const struct gve_priv *priv,
+			   const struct gve_notify_block *block, u32 val)
+{
+	u32 index = be32_to_cpu(block->irq_db_index);
+
+	iowrite32(val, &priv->db_bar2[index]);
+}
+
+#endif /* _GVE_DQO_H_ */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index ccaf68562312..716e6240305d 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -311,8 +311,16 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
 			struct gve_tx_ring *tx = &priv->tx[ring];
 
-			data[i++] = tx->req;
-			data[i++] = tx->done;
+			if (gve_is_gqi(priv)) {
+				data[i++] = tx->req;
+				data[i++] = tx->done;
+			} else {
+				/* DQO doesn't currently support
+				 * posted/completed descriptor counts;
+				 */
+				data[i++] = 0;
+				data[i++] = 0;
+			}
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->tx[ring].statss);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 8cc0ac061c93..579f867cf148 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -14,6 +14,7 @@
 #include <linux/workqueue.h>
 #include <net/sch_generic.h>
 #include "gve.h"
+#include "gve_dqo.h"
 #include "gve_adminq.h"
 #include "gve_register.h"
 
@@ -26,6 +27,16 @@
 const char gve_version_str[] = GVE_VERSION;
 static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
+static netdev_tx_t gve_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+
+	if (gve_is_gqi(priv))
+		return gve_tx(skb, dev);
+	else
+		return gve_tx_dqo(skb, dev);
+}
+
 static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 {
 	struct gve_priv *priv = netdev_priv(dev);
@@ -155,6 +166,15 @@ static irqreturn_t gve_intr(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t gve_intr_dqo(int irq, void *arg)
+{
+	struct gve_notify_block *block = arg;
+
+	/* Interrupts are automatically masked */
+	napi_schedule_irqoff(&block->napi);
+	return IRQ_HANDLED;
+}
+
 static int gve_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct gve_notify_block *block;
@@ -191,6 +211,54 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
 	return 0;
 }
 
+static int gve_napi_poll_dqo(struct napi_struct *napi, int budget)
+{
+	struct gve_notify_block *block =
+		container_of(napi, struct gve_notify_block, napi);
+	struct gve_priv *priv = block->priv;
+	bool reschedule = false;
+	int work_done = 0;
+
+	/* Clear PCI MSI-X Pending Bit Array (PBA)
+	 *
+	 * This bit is set if an interrupt event occurs while the vector is
+	 * masked. If this bit is set and we reenable the interrupt, it will
+	 * fire again. Since we're just about to poll the queue state, we don't
+	 * need it to fire again.
+	 *
+	 * Under high softirq load, it's possible that the interrupt condition
+	 * is triggered twice before we got the chance to process it.
+	 */
+	gve_write_irq_doorbell_dqo(priv, block,
+				   GVE_ITR_NO_UPDATE_DQO | GVE_ITR_CLEAR_PBA_BIT_DQO);
+
+	if (block->tx)
+		reschedule |= gve_tx_poll_dqo(block, /*do_clean=*/true);
+
+	if (block->rx) {
+		work_done = gve_rx_poll_dqo(block, budget);
+		reschedule |= work_done == budget;
+	}
+
+	if (reschedule)
+		return budget;
+
+	if (likely(napi_complete_done(napi, work_done))) {
+		/* Enable interrupts again.
+		 *
+		 * We don't need to repoll afterwards because HW supports the
+		 * PCI MSI-X PBA feature.
+		 *
+		 * Another interrupt would be triggered if a new event came in
+		 * since the last one.
+		 */
+		gve_write_irq_doorbell_dqo(priv, block,
+					   GVE_ITR_NO_UPDATE_DQO | GVE_ITR_ENABLE_BIT_DQO);
+	}
+
+	return work_done;
+}
+
 static int gve_alloc_notify_blocks(struct gve_priv *priv)
 {
 	int num_vecs_requested = priv->num_ntfy_blks + 1;
@@ -264,7 +332,8 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 			 name, i);
 		block->priv = priv;
 		err = request_irq(priv->msix_vectors[msix_idx].vector,
-				  gve_intr, 0, block->name, block);
+				  gve_is_gqi(priv) ? gve_intr : gve_intr_dqo,
+				  0, block->name, block);
 		if (err) {
 			dev_err(&priv->pdev->dev,
 				"Failed to receive msix vector %d\n", i);
@@ -417,11 +486,12 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 	gve_clear_device_resources_ok(priv);
 }
 
-static void gve_add_napi(struct gve_priv *priv, int ntfy_idx)
+static void gve_add_napi(struct gve_priv *priv, int ntfy_idx,
+			 int (*gve_poll)(struct napi_struct *, int))
 {
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
-	netif_napi_add(priv->dev, &block->napi, gve_napi_poll,
+	netif_napi_add(priv->dev, &block->napi, gve_poll,
 		       NAPI_POLL_WEIGHT);
 }
 
@@ -512,11 +582,33 @@ static int gve_create_rings(struct gve_priv *priv)
 	return 0;
 }
 
+static void add_napi_init_sync_stats(struct gve_priv *priv,
+				     int (*napi_poll)(struct napi_struct *napi,
+						      int budget))
+{
+	int i;
+
+	/* Add tx napi & init sync stats*/
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		int ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
+
+		u64_stats_init(&priv->tx[i].statss);
+		priv->tx[i].ntfy_id = ntfy_idx;
+		gve_add_napi(priv, ntfy_idx, napi_poll);
+	}
+	/* Add rx napi  & init sync stats*/
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		int ntfy_idx = gve_rx_idx_to_ntfy(priv, i);
+
+		u64_stats_init(&priv->rx[i].statss);
+		priv->rx[i].ntfy_id = ntfy_idx;
+		gve_add_napi(priv, ntfy_idx, napi_poll);
+	}
+}
+
 static int gve_alloc_rings(struct gve_priv *priv)
 {
-	int ntfy_idx;
 	int err;
-	int i;
 
 	/* Setup tx rings */
 	priv->tx = kvzalloc(priv->tx_cfg.num_queues * sizeof(*priv->tx),
@@ -536,18 +628,11 @@ static int gve_alloc_rings(struct gve_priv *priv)
 	err = gve_rx_alloc_rings(priv);
 	if (err)
 		goto free_rx;
-	/* Add tx napi & init sync stats*/
-	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
-		u64_stats_init(&priv->tx[i].statss);
-		ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
-		gve_add_napi(priv, ntfy_idx);
-	}
-	/* Add rx napi  & init sync stats*/
-	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
-		u64_stats_init(&priv->rx[i].statss);
-		ntfy_idx = gve_rx_idx_to_ntfy(priv, i);
-		gve_add_napi(priv, ntfy_idx);
-	}
+
+	if (gve_is_gqi(priv))
+		add_napi_init_sync_stats(priv, gve_napi_poll);
+	else
+		add_napi_init_sync_stats(priv, gve_napi_poll_dqo);
 
 	return 0;
 
@@ -798,9 +883,17 @@ static int gve_open(struct net_device *dev)
 	err = gve_register_qpls(priv);
 	if (err)
 		goto reset;
+
+	if (!gve_is_gqi(priv)) {
+		/* Hard code this for now. This may be tuned in the future for
+		 * performance.
+		 */
+		priv->data_buffer_size_dqo = GVE_RX_BUFFER_SIZE_DQO;
+	}
 	err = gve_create_rings(priv);
 	if (err)
 		goto reset;
+
 	gve_set_device_rings_ok(priv);
 
 	if (gve_get_report_stats(priv))
@@ -970,12 +1063,49 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	priv->tx_timeo_cnt++;
 }
 
+static int gve_set_features(struct net_device *netdev,
+			    netdev_features_t features)
+{
+	const netdev_features_t orig_features = netdev->features;
+	struct gve_priv *priv = netdev_priv(netdev);
+	int err;
+
+	if ((netdev->features & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
+		netdev->features ^= NETIF_F_LRO;
+		if (netif_carrier_ok(netdev)) {
+			/* To make this process as simple as possible we
+			 * teardown the device, set the new configuration,
+			 * and then bring the device up again.
+			 */
+			err = gve_close(netdev);
+			/* We have already tried to reset in close, just fail
+			 * at this point.
+			 */
+			if (err)
+				goto err;
+
+			err = gve_open(netdev);
+			if (err)
+				goto err;
+		}
+	}
+
+	return 0;
+err:
+	/* Reverts the change on error. */
+	netdev->features = orig_features;
+	netif_err(priv, drv, netdev,
+		  "Set features failed! !!! DISABLING ALL QUEUES !!!\n");
+	return err;
+}
+
 static const struct net_device_ops gve_netdev_ops = {
-	.ndo_start_xmit		=	gve_tx,
+	.ndo_start_xmit		=	gve_start_xmit,
 	.ndo_open		=	gve_open,
 	.ndo_stop		=	gve_close,
 	.ndo_get_stats64	=	gve_get_stats,
 	.ndo_tx_timeout         =       gve_tx_timeout,
+	.ndo_set_features	=	gve_set_features,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
@@ -1019,6 +1149,15 @@ void gve_handle_report_stats(struct gve_priv *priv)
 	/* tx stats */
 	if (priv->tx) {
 		for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+			u32 last_completion = 0;
+			u32 tx_frames = 0;
+
+			/* DQO doesn't currently support these metrics. */
+			if (gve_is_gqi(priv)) {
+				last_completion = priv->tx[idx].done;
+				tx_frames = priv->tx[idx].req;
+			}
+
 			do {
 				start = u64_stats_fetch_begin(&priv->tx[idx].statss);
 				tx_bytes = priv->tx[idx].bytes_done;
@@ -1035,7 +1174,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			};
 			stats[stats_idx++] = (struct stats) {
 				.stat_name = cpu_to_be32(TX_FRAMES_SENT),
-				.value = cpu_to_be64(priv->tx[idx].req),
+				.value = cpu_to_be64(tx_frames),
 				.queue_id = cpu_to_be32(idx),
 			};
 			stats[stats_idx++] = (struct stats) {
@@ -1045,7 +1184,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			};
 			stats[stats_idx++] = (struct stats) {
 				.stat_name = cpu_to_be32(TX_LAST_COMPLETION_PROCESSED),
-				.value = cpu_to_be64(priv->tx[idx].done),
+				.value = cpu_to_be64(last_completion),
 				.queue_id = cpu_to_be32(idx),
 			};
 		}
@@ -1121,7 +1260,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 			"Could not get device information: err=%d\n", err);
 		goto err;
 	}
-	if (priv->dev->max_mtu > PAGE_SIZE) {
+	if (gve_is_gqi(priv) && priv->dev->max_mtu > PAGE_SIZE) {
 		priv->dev->max_mtu = PAGE_SIZE;
 		err = gve_adminq_set_mtu(priv, priv->dev->mtu);
 		if (err) {
@@ -1332,7 +1471,12 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, dev);
 	dev->ethtool_ops = &gve_ethtool_ops;
 	dev->netdev_ops = &gve_netdev_ops;
-	/* advertise features */
+
+	/* Set default and supported features.
+	 *
+	 * Features might be set in other locations as well (such as
+	 * `gve_adminq_describe_device`).
+	 */
 	dev->hw_features = NETIF_F_HIGHDMA;
 	dev->hw_features |= NETIF_F_SG;
 	dev->hw_features |= NETIF_F_HW_CSUM;
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
new file mode 100644
index 000000000000..808e09741ecc
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2021 Google, Inc.
+ */
+
+#include "gve.h"
+#include "gve_dqo.h"
+#include "gve_adminq.h"
+#include "gve_utils.h"
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <net/ip6_checksum.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+
+int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
+{
+	u32 work_done = 0;
+
+	return work_done;
+}
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
new file mode 100644
index 000000000000..4b3319a1b299
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2021 Google, Inc.
+ */
+
+#include "gve.h"
+#include "gve_adminq.h"
+#include "gve_utils.h"
+#include "gve_dqo.h"
+#include <linux/tcp.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+
+netdev_tx_t gve_tx_dqo(struct sk_buff *skb, struct net_device *dev)
+{
+	return NETDEV_TX_OK;
+}
+
+bool gve_tx_poll_dqo(struct gve_notify_block *block, bool do_clean)
+{
+	return false;
+}
-- 
2.32.0.288.g62a8d224e6-goog

