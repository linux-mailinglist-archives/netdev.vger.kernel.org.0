Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FC04047C1
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhIIJaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:30:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233080AbhIIJaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 05:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631179752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/18NQOC3C5nIfaP3aKfDzGgqLFzNkkut1m2yMHPqSj0=;
        b=EXqbTM51JznHYcr3PEPGcSoMerlepNcOWBB3qQ7c6hyjk1yxRvLmGnECTrzdZhNFnCvLoo
        kLfdjiDXKBMvpa2l7dfhFHU2azWJy7jGJQoNEOva633GqsDIjjKnKY44Oz9gPtii5KRptP
        uSnyNHzj0HTSTPBRro7a88Fo9QIuzBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-3h9HhrHgOoW6-bQ-m3-zgQ-1; Thu, 09 Sep 2021 05:29:11 -0400
X-MC-Unique: 3h9HhrHgOoW6-bQ-m3-zgQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5B661030C20;
        Thu,  9 Sep 2021 09:29:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3573D5C1D0;
        Thu,  9 Sep 2021 09:29:07 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net 2/2] sfc: last resort fallback for lack of xdp tx queues
Date:   Thu,  9 Sep 2021 11:28:46 +0200
Message-Id: <20210909092846.18217-3-ihuguet@redhat.com>
In-Reply-To: <20210909092846.18217-1-ihuguet@redhat.com>
References: <20210909092846.18217-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous patch addressed the situation of having some free resources for
xdp tx but not enough for one tx queue per CPU. This patch address the
worst case of not having resources at all for xdp tx.

Instead of using queues dedicated to xdp, normal queues used by network
stack are shared for both cases, using __netif_tx_lock for
synchronization. Also queue stop/restart must be considered in the xdp
path to avoid freezing the queue.

This is not the ideal situation we might want to be, and a performance
penalty is expected both for normal and xdp traffic, but at least XDP
will work in all possible situations (with a warning in the logs),
improving a bit the pain of not knowing in what situations we can use it
and in what situations we cannot.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 82 ++++++++++++++-----------
 drivers/net/ethernet/sfc/net_driver.h   |  2 +-
 drivers/net/ethernet/sfc/tx.c           | 14 ++++-
 3 files changed, 58 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index e7849f1260a1..3dbea028b325 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -167,19 +167,19 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	 * This may be more pessimistic than it needs to be.
 	 */
 	if (n_channels >= max_channels) {
-		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_DISABLED;
-		netif_err(efx, drv, efx->net_dev,
-			  "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
-			  n_xdp_ev, n_channels, max_channels);
-		netif_err(efx, drv, efx->net_dev,
-			  "XDP_TX and XDP_REDIRECT will not work on this interface\n");
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
+		netif_warn(efx, drv, efx->net_dev,
+			   "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
+			   n_xdp_ev, n_channels, max_channels);
+		netif_warn(efx, drv, efx->net_dev,
+			   "XDP_TX and XDP_REDIRECT might decrease device's performance\n");
 	} else if (n_channels + n_xdp_tx > efx->max_vis) {
-		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_DISABLED;
-		netif_err(efx, drv, efx->net_dev,
-			  "Insufficient resources for %d XDP TX queues (%d other channels, max VIs %d)\n",
-			  n_xdp_tx, n_channels, efx->max_vis);
-		netif_err(efx, drv, efx->net_dev,
-			  "XDP_TX and XDP_REDIRECT will not work on this interface\n");
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
+		netif_warn(efx, drv, efx->net_dev,
+			   "Insufficient resources for %d XDP TX queues (%d other channels, max VIs %d)\n",
+			   n_xdp_tx, n_channels, efx->max_vis);
+		netif_warn(efx, drv, efx->net_dev,
+			   "XDP_TX and XDP_REDIRECT might decrease device's performance\n");
 	} else if (n_channels + n_xdp_ev > max_channels) {
 		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_SHARED;
 		netif_warn(efx, drv, efx->net_dev,
@@ -194,7 +194,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_DEDICATED;
 	}
 
-	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DISABLED) {
+	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_BORROWED) {
 		efx->n_xdp_channels = n_xdp_ev;
 		efx->xdp_tx_per_channel = tx_per_ev;
 		efx->xdp_tx_queue_count = n_xdp_tx;
@@ -205,7 +205,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	} else {
 		efx->n_xdp_channels = 0;
 		efx->xdp_tx_per_channel = 0;
-		efx->xdp_tx_queue_count = 0;
+		efx->xdp_tx_queue_count = n_xdp_tx;
 	}
 
 	if (vec_count < n_channels) {
@@ -872,6 +872,20 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	goto out;
 }
 
+static inline int
+efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
+		     struct efx_tx_queue *tx_queue)
+{
+	if (xdp_queue_number >= efx->xdp_tx_queue_count)
+		return -EINVAL;
+
+	netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
+		  tx_queue->channel->channel, tx_queue->label,
+		  xdp_queue_number, tx_queue->queue);
+	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+	return 0;
+}
+
 int efx_set_channels(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
@@ -910,20 +924,9 @@ int efx_set_channels(struct efx_nic *efx)
 			if (efx_channel_is_xdp_tx(channel)) {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
 					tx_queue->queue = next_queue++;
-
-					/* We may have a few left-over XDP TX
-					 * queues owing to xdp_tx_queue_count
-					 * not dividing evenly by EFX_MAX_TXQ_PER_CHANNEL.
-					 * We still allocate and probe those
-					 * TXQs, but never use them.
-					 */
-					if (xdp_queue_number < efx->xdp_tx_queue_count) {
-						netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-							  channel->channel, tx_queue->label,
-							  xdp_queue_number, tx_queue->queue);
-						efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
+					if (rc == 0)
 						xdp_queue_number++;
-					}
 				}
 			} else {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
@@ -932,6 +935,17 @@ int efx_set_channels(struct efx_nic *efx)
 						  channel->channel, tx_queue->label,
 						  tx_queue->queue);
 				}
+
+				/* If XDP is borrowing queues from net stack, it must use the queue
+				 * with no csum offload, which is the first one of the channel
+				 * (note: channel->tx_queue_by_type is not initialized yet)
+				 */
+				if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
+					tx_queue = &channel->tx_queue[0];
+					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
+					if (rc == 0)
+						xdp_queue_number++;
+				}
 			}
 		}
 	}
@@ -940,19 +954,15 @@ int efx_set_channels(struct efx_nic *efx)
 	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
 		xdp_queue_number > efx->xdp_tx_queue_count);
 
-	/* If we have less XDP TX queues than CPUs, assign the already existing
-	 * queues to the exceeding CPUs (this means that we will have to use
-	 * locking when transmitting with XDP)
+	/* If we have more CPUs than assigned XDP TX queues, assign the already
+	 * existing queues to the exceeding CPUs
 	 */
 	next_queue = 0;
 	while (xdp_queue_number < efx->xdp_tx_queue_count) {
 		tx_queue = efx->xdp_tx_queues[next_queue++];
-		channel = tx_queue->channel;
-		netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-			  channel->channel, tx_queue->label,
-			  xdp_queue_number, tx_queue->queue);
-
-		efx->xdp_tx_queues[xdp_queue_number++] = tx_queue;
+		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
+		if (rc == 0)
+			xdp_queue_number++;
 	}
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index e731c766f709..f6981810039d 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -785,7 +785,7 @@ struct efx_async_filter_insertion {
 enum efx_xdp_tx_queues_mode {
 	EFX_XDP_TX_QUEUES_DEDICATED,	/* one queue per core, locking not needed */
 	EFX_XDP_TX_QUEUES_SHARED,	/* each queue used by more than 1 core */
-	EFX_XDP_TX_QUEUES_DISABLED	/* xdp tx not available */
+	EFX_XDP_TX_QUEUES_BORROWED	/* queues borrowed from net stack */
 };
 
 /**
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index c7afd6cda902..d16e031e95f4 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -428,10 +428,8 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	unsigned int len;
 	int space;
 	int cpu;
-	int i;
+	int i = 0;
 
-	if (unlikely(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DISABLED))
-		return -EINVAL;
 	if (unlikely(n && !xdpfs))
 		return -EINVAL;
 	if (unlikely(!n))
@@ -448,6 +446,15 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
 		HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
 
+	/* If we're borrowing net stack queues we have to handle stop-restart
+	 * or we might block the queue and it will be considered as frozen
+	 */
+	if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
+		if (netif_tx_queue_stopped(tx_queue->core_txq))
+			goto unlock;
+		efx_tx_maybe_stop_queue(tx_queue);
+	}
+
 	/* Check for available space. We should never need multiple
 	 * descriptors per frame.
 	 */
@@ -486,6 +493,7 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	if (flush && i > 0)
 		efx_nic_push_buffers(tx_queue);
 
+unlock:
 	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
 		HARD_TX_UNLOCK(efx->net_dev, tx_queue->core_txq);
 
-- 
2.31.1

