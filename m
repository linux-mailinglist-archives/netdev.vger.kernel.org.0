Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD65A25A104
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgIAVw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbgIAVwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F987C061246
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:09 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y4so1480346pff.13
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=MQQluZ3SVhkcO/WV0C9DPGDlzAdlXQlLzeaTji7HUak=;
        b=d79ZzF1vtJwqYf5xZWR5AzSRj8lUjwmbQeh904YVH21w/MbNOZavsWH9moZKRtOyKJ
         bBL9ytmUyHxC24tp7ZrVK1FHdJz3L2xPYZG6L5uDN91ATKQ7VT1qBBg0Sb1YxqIbdWt4
         9fYMstWYpkZMdNzPQPjbYrNceNWhXOuq5P2rJDWuHkflICwDcp+MI/SlWX4Y09V8kjaH
         S6Uc5Rz3M+AWwbWIkku7eDI9clNEJ9XVW+Pus1lGzbY3NVpitTupTuUDofs1qdQQJOOE
         bs6HjMQV4dxa48kNeAa4FyIM3F87fF4ohNFdCnPBtAwxkCIF/3fEVydhRgcjjzzAjQqz
         IbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MQQluZ3SVhkcO/WV0C9DPGDlzAdlXQlLzeaTji7HUak=;
        b=tEFOdgBrrlxAcggobTGEwrgW3GoFaPBmtnIy/wLo21poa8laX9GtTePmQ23+clS5M+
         GOJ+Mam8IRrKXIVxtisIOZWDYRKexuMZuUTLtHzIfkDse3K5mpkAxn2wzbaJRKLWfEi3
         Of+K9g9/g/JIZ2z1fEWenzdSgLFuJ5azce+JwDE5ZWcew1RGMYeJgfKs2UwbNSALSQxz
         SNu04MUS25Yx9pw0pUP81MKeLZgazTYkqpaQxzxohCkoadmTHRGP1y5nGVkAKOszoE7l
         tDCMhgRexvkQigRm6jFzUWeSUhHA4zhfw+ieeTIEnCm2gn+VzYojNk+aKg8nmbe50gvx
         vaMA==
X-Gm-Message-State: AOAM532JnhUbWgTXX6srapovnYO2+seFxC+q8dkeSR/aYtz5KjakLMDP
        6YTuzgzHBjaRF5ABdopC6khwUMT7k4V1C52Tt0BU9HR0aYOLdNug4dlJ0RqnUyKdUxZoud6rxS9
        eFDAW+D0Gj8qIlUi69acaYuoLKHyfoh8i8bxcTsjlyoOUTAOpLGGH7s0ErWPZK1aN0veAAbuE
X-Google-Smtp-Source: ABdhPJyiWcFEMxpT0+4pipdqA0+xSggAtzrRMPtHuQ6nuGXCk2Iy6Yo5h3dS84opcC0g+/0/gz39mdy6MyXG0Spe
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a62:7e4e:0:b029:137:3e8f:c31c with SMTP
 id z75-20020a627e4e0000b02901373e8fc31cmr3762513pfc.0.1598997129005; Tue, 01
 Sep 2020 14:52:09 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:47 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-8-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 7/9] gve: Batch AQ commands for creating and
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
index 69cdf92a2f21..341a17b36f06 100644
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
index 0c94dda67ba4..d5019132874d 100644
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
2.28.0.402.g5ffc5be6b7-goog

