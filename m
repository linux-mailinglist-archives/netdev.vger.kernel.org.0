Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCB1266736
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgIKRkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgIKRjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:39:06 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056CCC061757
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:06 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id h15so7640373pfr.3
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=cr+kOy3VyFe03WhQ1FnLWr641YamZeNjiHfuohG7+Mo=;
        b=flAfNUGZjxqAJPTEl2O5S81nQGPBxlsH2tHrml3G2aaaH4IyL0zu0W7XKQ2DZP84FG
         3BoKmE6CVufht+4KiknobCzUOz9C5LVpV4nxjTDnzULyQgjbaJaxfRZs8staq/WUASKX
         Jm/1BvdXH+iQUMJR0ro3GRCNQCBTFFZ+pfQ8vb6JePaO8gR4QAHhlo3DwlihtB9ZLkgS
         dqvEpc0NOdH5rYHO4/zyy3cDVN4hy0g4nS2HZzw2HwL/W6lmXxpbwcH+0nMDo9O3pU/U
         w9Lq7l1Eocp+9bHWGc+jQiYKezOSlIDU1pawkXj2nCFdHEfrKQ0ZezAqUc1pK2UWDZfL
         0drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cr+kOy3VyFe03WhQ1FnLWr641YamZeNjiHfuohG7+Mo=;
        b=ua+c+YscqDJ+gZi/z3va1/G1DmVhrdEVBJIIIM8YjGbqKWIgFw5q9xmlIwSw70hL7A
         JAeGQThW0VSNjBPCsWUC1xH1PUacYndu1WUj83nR486BZBP3/5ez/z80bJy31dxhLtbp
         S4V+G3O9FT4jeecLWOrVlxHJP2GORXIrYFXFk8kK5URXFe26NMawz9+zwV9VgbQJeC4m
         8Ohkrx/RLWsCqx/8dr49tJodPKYDV/xH7J5Q5lesLUOZK4oAq7i1vgrs+2CSHYGKzais
         3hj9WkoX9VgplkbF9F6+ekWma5Mblr31V1wI1XfXplZdfD15nqrxEOuTrqbuMnHZ2erk
         zjlg==
X-Gm-Message-State: AOAM530PysU061Vml8WuKxuqEDLHLnzAxZNgu1k9MFm12B/dhR3UgOYt
        nDYbYZNQilXHHrdjdYjjlGCcJIR7YMxgVnuO4YUHJZ9SxRrMED6OAC77flo8GgBH2QPRhULzh1Q
        fqkJRniQWIskPTrndkS782e5Pj+3vnuhUAUbY/o0e9dI30QdhIEpUINlZrjpNrE6fSVShDadl
X-Google-Smtp-Source: ABdhPJwRYCYuH5NJoa8hTt7RvzjPhCZqlG7i7N0lD/jdA6i+dCBSOi/yQ+tiNp/gEx49IyWBPMnIl8OhErc6EMkd
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90b:15c6:: with SMTP id
 lh6mr144658pjb.0.1599845944932; Fri, 11 Sep 2020 10:39:04 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:49 -0700
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
Message-Id: <20200911173851.2149095-7-awogbemila@google.com>
Mime-Version: 1.0
References: <20200911173851.2149095-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 6/8] gve: Batch AQ commands for creating and
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
index 078e6e40880d..6f5ccd591c3d 100644
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
-	u32 status = 0;
-	u32 prod_cnt;
 	u32 opcode;
+	u32 tail;
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
 
-	memcpy(cmd_orig, cmd, sizeof(*cmd));
-	status = be32_to_cpu(READ_ONCE(cmd->status));
-	return gve_adminq_parse_err(priv, status);
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
+
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
 }
 
-int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
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
+}
+
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
index 7c5a11356b1c..28e5cc52410e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -450,36 +450,37 @@ static int gve_create_rings(struct gve_priv *priv)
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
@@ -537,34 +538,23 @@ static int gve_alloc_rings(struct gve_priv *priv)
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
2.28.0.618.gf4bc123cb7-goog

