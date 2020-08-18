Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE39248EE6
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHRToy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgHRToo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173A7C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:44 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f5so13565073pfe.2
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XZG0JA7ZRFTjsgNdlNTfqcyA+Qv0tFwkUGb7wF2VxeA=;
        b=JQIIcymHYkg+/DSqMixhLvXtFwsQT15xlqGJNEHXkkcCI3ospDQwuZTyIgv7sosTl9
         JVyfiCtw1JkXG16NP5y21r1Cmf0No5c0VWtTe8wPusfotGHGO0qLN7bBPmLynlPOvoUN
         zPINYdPK9FU5ONV8niwKKkGKV+Fb8oxm5BGqxX5KgXFSSXLhOnvktyz+EQcN6b3cEl7/
         TFnjtYazbPzA17qfm0kAifPLKcRg9W2sVBeQ31nKZ3MfbrcDunF3binvY90wgIwjgQ8A
         RYppl5EMpmjhD2JQtbvFJdYYG8CTh1AcSHncJ53zTZoSQFSP6nbU8i+H5oDqRe3KNJZU
         wAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XZG0JA7ZRFTjsgNdlNTfqcyA+Qv0tFwkUGb7wF2VxeA=;
        b=sUjt1Qu7VYSt+2yxUWmROLDGPphyt2C22+ZTWlJ7o1N3MU/EniWQrkmx3Nf0yXtY+c
         3vPpzQbnAnoKFigdDVsvt0hxVsxMKW627MoHVtRXtq6T+gMepIbQf84KgMKU2QXRoUIP
         xqqA1CpULQ3kv0tlIIRWBZvHmQE4kOovfDXtViU7hN3ascwNJms5Sm/ZqdScTNIos0fT
         BhB7PCv4T94H/dxxfelFlhxTlX2+kWY/q8uNAcfWUQADwWMIwWtP6Ugv3mJhnNWCBzk8
         6AftGC8FMeF844BW1BDOn/UxV60J2X1YTP23chmUpruyUoe9wxf1MKV65GCFbc4nNf6n
         ixAA==
X-Gm-Message-State: AOAM531hpfiDRdZluPYxOepkSmJUgI1mpMf/jPpigs/GBD661z9vAKVY
        qvFsK76ovjKML7orNTHsYocIgrCNduVBhtIK+Dzd//wHesfSPJJJcmWiPbIOSgUZ5dwhU13L10d
        A1tC1ylZ8cXUWXSf8W212BXJRlL2hzBPbYPghSnMD29RMbpUPqgG3H8Ipvs8x3WrVa4qsnBLl
X-Google-Smtp-Source: ABdhPJxgBvRaBdCBv4rYlXQdc1MvcfVFuO3IzwTWNm0gE7n/zmgmf0AmJEpm21xZPlwewdIzT3qP7rxhhto+jd+z
X-Received: by 2002:a63:4723:: with SMTP id u35mr13905848pga.409.1597779881905;
 Tue, 18 Aug 2020 12:44:41 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:05 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-7-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 06/18] gve: Batch AQ commands for creating and
 destroying queues.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Sagi Shahar <sagis@google.com>, Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sagi Shahar <sagis@google.com>

Adds support for batching AQ commands and uses it for creating and
destroying queues.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 188 ++++++++++++++++---
 drivers/net/ethernet/google/gve/gve_adminq.h |  10 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  94 +++++-----
 3 files changed, 211 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 38e0c3066035..023e6f804972 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -135,20 +135,71 @@ static int gve_adminq_parse_err(struct gve_priv *priv, u32 status)
 	}
 }
 
+/* Flushes all AQ commands currently queued and waits for them to complete.
+ * If there are failures, it will return the first error.
+ */
+static int gve_adminq_kick_and_wait(struct gve_priv *priv)
+{
+	u32 tail, head;
+	int i;
+
+	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
+	head = priv->adminq_prod_cnt;
+
+	gve_adminq_kick_cmd(priv, head);
+	if (!gve_adminq_wait_for_cmd(priv, head)) {
+		dev_err(&priv->pdev->dev, "AQ commands timed out, need to reset AQ\n");
+		priv->adminq_timeouts++;
+		return -ENOTRECOVERABLE;
+	}
+
+	for (i = tail; i < head; i++) {
+		union gve_adminq_command *cmd;
+		u32 status, err;
+
+		cmd = &priv->adminq[i & priv->adminq_mask];
+		status = be32_to_cpu(READ_ONCE(cmd->status));
+		err = gve_adminq_parse_err(priv, status);
+		if (err)
+			// Return the first error if we failed.
+			return err;
+	}
+
+	return 0;
+}
+
 /* This function is not threadsafe - the caller is responsible for any
  * necessary locks.
  */
-int gve_adminq_execute_cmd(struct gve_priv *priv,
-			   union gve_adminq_command *cmd_orig)
+static int gve_adminq_issue_cmd(struct gve_priv *priv,
+				union gve_adminq_command *cmd_orig)
 {
 	union gve_adminq_command *cmd;
+	u32 tail;
 	u32 opcode;
-	u32 status = 0;
-	u32 prod_cnt;
+
+	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
+
+	// Check if next command will overflow the buffer.
+	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+		int err;
+
+		// Flush existing commands to make room.
+		err = gve_adminq_kick_and_wait(priv);
+		if (err)
+			return err;
+
+		// Retry.
+		tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
+		if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+			// This should never happen. We just flushed the
+			// command queue so there should be enough space.
+			return -ENOMEM;
+		}
+	}
 
 	cmd = &priv->adminq[priv->adminq_prod_cnt & priv->adminq_mask];
 	priv->adminq_prod_cnt++;
-	prod_cnt = priv->adminq_prod_cnt;
 
 	memcpy(cmd, cmd_orig, sizeof(*cmd_orig));
 	opcode = be32_to_cpu(READ_ONCE(cmd->opcode));
@@ -191,16 +242,30 @@ int gve_adminq_execute_cmd(struct gve_priv *priv,
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
 	}
 
-	gve_adminq_kick_cmd(priv, prod_cnt);
-	if (!gve_adminq_wait_for_cmd(priv, prod_cnt)) {
-		dev_err(&priv->pdev->dev, "AQ command timed out, need to reset AQ\n");
-		priv->adminq_timeouts++;
-		return -ENOTRECOVERABLE;
-	}
+	return 0;
+}
+
+/* This function is not threadsafe - the caller is responsible for any
+ * necessary locks.
+ * The caller is also responsible for making sure there are no commands
+ * waiting to be executed.
+ */
+static int gve_adminq_execute_cmd(struct gve_priv *priv, union gve_adminq_command *cmd_orig)
+{
+	u32 tail, head;
+	int err;
+
+	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
+	head = priv->adminq_prod_cnt;
+	if (tail != head)
+		// This is not a valid path
+		return -EINVAL;
 
-	memcpy(cmd_orig, cmd, sizeof(*cmd));
-	status = be32_to_cpu(READ_ONCE(cmd->status));
-	return gve_adminq_parse_err(priv, status);
+	err = gve_adminq_issue_cmd(priv, cmd_orig);
+	if (err)
+		return err;
+
+	return gve_adminq_kick_and_wait(priv);
 }
 
 /* The device specifies that the management vector can either be the first irq
@@ -245,29 +310,50 @@ int gve_adminq_deconfigure_device_resources(struct gve_priv *priv)
 	return gve_adminq_execute_cmd(priv, &cmd);
 }
 
-int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
+static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_tx_ring *tx = &priv->tx[queue_index];
 	union gve_adminq_command cmd;
+	int err;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_TX_QUEUE);
 	cmd.create_tx_queue = (struct gve_adminq_create_tx_queue) {
 		.queue_id = cpu_to_be32(queue_index),
 		.reserved = 0,
-		.queue_resources_addr = cpu_to_be64(tx->q_resources_bus),
+		.queue_resources_addr =
+			cpu_to_be64(tx->q_resources_bus),
 		.tx_ring_addr = cpu_to_be64(tx->bus),
 		.queue_page_list_id = cpu_to_be32(tx->tx_fifo.qpl->id),
 		.ntfy_id = cpu_to_be32(tx->ntfy_id),
 	};
 
-	return gve_adminq_execute_cmd(priv, &cmd);
+	err = gve_adminq_issue_cmd(priv, &cmd);
+	if (err)
+		return err;
+
+	return 0;
 }
 
-int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
+int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < num_queues; i++) {
+		err = gve_adminq_create_tx_queue(priv, i);
+		if (err)
+			return err;
+	}
+
+	return gve_adminq_kick_and_wait(priv);
+}
+
+static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_rx_ring *rx = &priv->rx[queue_index];
 	union gve_adminq_command cmd;
+	int err;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
@@ -282,12 +368,31 @@ int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_page_list_id = cpu_to_be32(rx->data.qpl->id),
 	};
 
-	return gve_adminq_execute_cmd(priv, &cmd);
+	err = gve_adminq_issue_cmd(priv, &cmd);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int gve_adminq_create_rx_queues(struct gve_priv *priv, u32 num_queues)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < num_queues; i++) {
+		err = gve_adminq_create_rx_queue(priv, i);
+		if (err)
+			return err;
+	}
+
+	return gve_adminq_kick_and_wait(priv);
 }
 
-int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
+static int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	union gve_adminq_command cmd;
+	int err;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DESTROY_TX_QUEUE);
@@ -295,12 +400,31 @@ int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_id = cpu_to_be32(queue_index),
 	};
 
-	return gve_adminq_execute_cmd(priv, &cmd);
+	err = gve_adminq_issue_cmd(priv, &cmd);
+	if (err)
+		return err;
+
+	return 0;
 }
 
-int gve_adminq_destroy_rx_queue(struct gve_priv *priv, u32 queue_index)
+int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 num_queues)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < num_queues; i++) {
+		err = gve_adminq_destroy_tx_queue(priv, i);
+		if (err)
+			return err;
+	}
+
+	return gve_adminq_kick_and_wait(priv);
+}
+
+static int gve_adminq_destroy_rx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	union gve_adminq_command cmd;
+	int err;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DESTROY_RX_QUEUE);
@@ -308,7 +432,25 @@ int gve_adminq_destroy_rx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_id = cpu_to_be32(queue_index),
 	};
 
-	return gve_adminq_execute_cmd(priv, &cmd);
+	err = gve_adminq_issue_cmd(priv, &cmd);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < num_queues; i++) {
+		err = gve_adminq_destroy_rx_queue(priv, i);
+		if (err)
+			return err;
+	}
+
+	return gve_adminq_kick_and_wait(priv);
 }
 
 int gve_adminq_describe_device(struct gve_priv *priv)
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index a6c8c29f0d13..784830f75b7c 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -238,8 +238,6 @@ static_assert(sizeof(union gve_adminq_command) == 64);
 int gve_adminq_alloc(struct device *dev, struct gve_priv *priv);
 void gve_adminq_free(struct device *dev, struct gve_priv *priv);
 void gve_adminq_release(struct gve_priv *priv);
-int gve_adminq_execute_cmd(struct gve_priv *priv,
-			   union gve_adminq_command *cmd_orig);
 int gve_adminq_describe_device(struct gve_priv *priv);
 int gve_adminq_configure_device_resources(struct gve_priv *priv,
 					  dma_addr_t counter_array_bus_addr,
@@ -247,10 +245,10 @@ int gve_adminq_configure_device_resources(struct gve_priv *priv,
 					  dma_addr_t db_array_bus_addr,
 					  u32 num_ntfy_blks);
 int gve_adminq_deconfigure_device_resources(struct gve_priv *priv);
-int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_id);
-int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_id);
-int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_id);
-int gve_adminq_destroy_rx_queue(struct gve_priv *priv, u32 queue_id);
+int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues);
+int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 queue_id);
+int gve_adminq_create_rx_queues(struct gve_priv *priv, u32 num_queues);
+int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 queue_id);
 int gve_adminq_register_page_list(struct gve_priv *priv,
 				  struct gve_queue_page_list *qpl);
 int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 099d61f00bf0..885943d745aa 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -443,36 +443,37 @@ static int gve_create_rings(struct gve_priv *priv)
 	int err;
 	int i;
 
-	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
-		err = gve_adminq_create_tx_queue(priv, i);
-		if (err) {
-			netif_err(priv, drv, priv->dev, "failed to create tx queue %d\n",
-				  i);
-			/* This failure will trigger a reset - no need to clean
-			 * up
-			 */
-			return err;
-		}
-		netif_dbg(priv, drv, priv->dev, "created tx queue %d\n", i);
+	err = gve_adminq_create_tx_queues(priv, priv->tx_cfg.num_queues);
+	if (err) {
+		netif_err(priv, drv, priv->dev, "failed to create %d tx queues\n",
+			  priv->tx_cfg.num_queues);
+		/* This failure will trigger a reset - no need to clean
+		 * up
+		 */
+		return err;
 	}
-	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
-		err = gve_adminq_create_rx_queue(priv, i);
-		if (err) {
-			netif_err(priv, drv, priv->dev, "failed to create rx queue %d\n",
-				  i);
-			/* This failure will trigger a reset - no need to clean
-			 * up
-			 */
-			return err;
-		}
-		/* Rx data ring has been prefilled with packet buffers at
-		 * queue allocation time.
-		 * Write the doorbell to provide descriptor slots and packet
-		 * buffers to the NIC.
+	netif_dbg(priv, drv, priv->dev, "created %d tx queues\n",
+		  priv->tx_cfg.num_queues);
+
+	err = gve_adminq_create_rx_queues(priv, priv->rx_cfg.num_queues);
+	if (err) {
+		netif_err(priv, drv, priv->dev, "failed to create %d rx queues\n",
+			  priv->rx_cfg.num_queues);
+		/* This failure will trigger a reset - no need to clean
+		 * up
 		 */
-		gve_rx_write_doorbell(priv, &priv->rx[i]);
-		netif_dbg(priv, drv, priv->dev, "created rx queue %d\n", i);
+		return err;
 	}
+	netif_dbg(priv, drv, priv->dev, "created %d rx queues\n",
+		  priv->rx_cfg.num_queues);
+
+	/* Rx data ring has been prefilled with packet buffers at queue
+	 * allocation time.
+	 * Write the doorbell to provide descriptor slots and packet buffers
+	 * to the NIC.
+	 */
+	for (i = 0; i < priv->rx_cfg.num_queues; i++)
+		gve_rx_write_doorbell(priv, &priv->rx[i]);
 
 	return 0;
 }
@@ -530,34 +531,23 @@ static int gve_alloc_rings(struct gve_priv *priv)
 static int gve_destroy_rings(struct gve_priv *priv)
 {
 	int err;
-	int i;
 
-	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
-		err = gve_adminq_destroy_tx_queue(priv, i);
-		if (err) {
-			netif_err(priv, drv, priv->dev,
-				  "failed to destroy tx queue %d\n",
-				  i);
-			/* This failure will trigger a reset - no need to clean
-			 * up
-			 */
-			return err;
-		}
-		netif_dbg(priv, drv, priv->dev, "destroyed tx queue %d\n", i);
+	err = gve_adminq_destroy_tx_queues(priv, priv->tx_cfg.num_queues);
+	if (err) {
+		netif_err(priv, drv, priv->dev,
+			  "failed to destroy tx queues\n");
+		/* This failure will trigger a reset - no need to clean up */
+		return err;
 	}
-	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
-		err = gve_adminq_destroy_rx_queue(priv, i);
-		if (err) {
-			netif_err(priv, drv, priv->dev,
-				  "failed to destroy rx queue %d\n",
-				  i);
-			/* This failure will trigger a reset - no need to clean
-			 * up
-			 */
-			return err;
-		}
-		netif_dbg(priv, drv, priv->dev, "destroyed rx queue %d\n", i);
+	netif_dbg(priv, drv, priv->dev, "destroyed tx queues\n");
+	err = gve_adminq_destroy_rx_queues(priv, priv->rx_cfg.num_queues);
+	if (err) {
+		netif_err(priv, drv, priv->dev,
+			  "failed to destroy rx queues\n");
+		/* This failure will trigger a reset - no need to clean up */
+		return err;
 	}
+	netif_dbg(priv, drv, priv->dev, "destroyed rx queues\n");
 	return 0;
 }
 
-- 
2.28.0.220.ged08abb693-goog

