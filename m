Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A4E4047BE
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhIIJaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:30:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232990AbhIIJaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 05:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631179748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Re30m0eHVTiXd22bAPVHwM0wJlKuok/Qkkv1cgXJfGw=;
        b=gJ+EcbTwEQIOA5unulh+s7VWelwm5RH3RSDugD0GEn5OmPIr1O7UUUUcRFETRTbzeCNvad
        qKbpmHYoei5KiZujQ63NJUwmx3RLnDwP9sxMMOCCxOMK470M2OwjTcUIauppr2NedtfmC2
        O6AuR1MhDWmeRbaL/Mp/PAjJYX/Nnck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-i0aqiR6bOAGNAOkAFKWquA-1; Thu, 09 Sep 2021 05:29:07 -0400
X-MC-Unique: i0aqiR6bOAGNAOkAFKWquA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2F2E10059CD;
        Thu,  9 Sep 2021 09:29:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 027C85C1D0;
        Thu,  9 Sep 2021 09:29:02 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net 1/2] sfc: fallback for lack of xdp tx queues
Date:   Thu,  9 Sep 2021 11:28:45 +0200
Message-Id: <20210909092846.18217-2-ihuguet@redhat.com>
In-Reply-To: <20210909092846.18217-1-ihuguet@redhat.com>
References: <20210909092846.18217-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there are not enough resources to allocate one TX queue per core for
XDP TX it was completely disabled.

This patch implements a fallback solution for sharing the available
queues using __netif_tx_lock for synchronization. In the normal case that
there is one TX queue per CPU, no locking is done, as it was before.

With this fallback solution, XDP TX will work in much more cases that
were failing, specially in machines with many CPUs. It's hard for XDP
users to know what features are supported across different NICs and
configurations, so they will benefit on having wider support.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 54 ++++++++++++++++++++-----
 drivers/net/ethernet/sfc/net_driver.h   |  8 ++++
 drivers/net/ethernet/sfc/tx.c           | 21 ++++++----
 3 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index e5b0d795c301..e7849f1260a1 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -166,32 +166,46 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	 * We need a channel per event queue, plus a VI per tx queue.
 	 * This may be more pessimistic than it needs to be.
 	 */
-	if (n_channels + n_xdp_ev > max_channels) {
+	if (n_channels >= max_channels) {
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_DISABLED;
 		netif_err(efx, drv, efx->net_dev,
 			  "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
 			  n_xdp_ev, n_channels, max_channels);
 		netif_err(efx, drv, efx->net_dev,
-			  "XDP_TX and XDP_REDIRECT will not work on this interface");
-		efx->n_xdp_channels = 0;
-		efx->xdp_tx_per_channel = 0;
-		efx->xdp_tx_queue_count = 0;
+			  "XDP_TX and XDP_REDIRECT will not work on this interface\n");
 	} else if (n_channels + n_xdp_tx > efx->max_vis) {
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_DISABLED;
 		netif_err(efx, drv, efx->net_dev,
 			  "Insufficient resources for %d XDP TX queues (%d other channels, max VIs %d)\n",
 			  n_xdp_tx, n_channels, efx->max_vis);
 		netif_err(efx, drv, efx->net_dev,
-			  "XDP_TX and XDP_REDIRECT will not work on this interface");
-		efx->n_xdp_channels = 0;
-		efx->xdp_tx_per_channel = 0;
-		efx->xdp_tx_queue_count = 0;
+			  "XDP_TX and XDP_REDIRECT will not work on this interface\n");
+	} else if (n_channels + n_xdp_ev > max_channels) {
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_SHARED;
+		netif_warn(efx, drv, efx->net_dev,
+			   "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
+			   n_xdp_ev, n_channels, max_channels);
+
+		n_xdp_ev = max_channels - n_channels;
+		netif_warn(efx, drv, efx->net_dev,
+			   "XDP_TX and XDP_REDIRECT will work with reduced performance (%d cpus/tx_queue)\n",
+			   DIV_ROUND_UP(n_xdp_tx, tx_per_ev * n_xdp_ev));
 	} else {
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_DEDICATED;
+	}
+
+	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DISABLED) {
 		efx->n_xdp_channels = n_xdp_ev;
 		efx->xdp_tx_per_channel = tx_per_ev;
 		efx->xdp_tx_queue_count = n_xdp_tx;
 		n_channels += n_xdp_ev;
 		netif_dbg(efx, drv, efx->net_dev,
 			  "Allocating %d TX and %d event queues for XDP\n",
-			  n_xdp_tx, n_xdp_ev);
+			  n_xdp_ev * tx_per_ev, n_xdp_ev);
+	} else {
+		efx->n_xdp_channels = 0;
+		efx->xdp_tx_per_channel = 0;
+		efx->xdp_tx_queue_count = 0;
 	}
 
 	if (vec_count < n_channels) {
@@ -921,7 +935,25 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
-	WARN_ON(xdp_queue_number != efx->xdp_tx_queue_count);
+	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number != efx->xdp_tx_queue_count);
+	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number > efx->xdp_tx_queue_count);
+
+	/* If we have less XDP TX queues than CPUs, assign the already existing
+	 * queues to the exceeding CPUs (this means that we will have to use
+	 * locking when transmitting with XDP)
+	 */
+	next_queue = 0;
+	while (xdp_queue_number < efx->xdp_tx_queue_count) {
+		tx_queue = efx->xdp_tx_queues[next_queue++];
+		channel = tx_queue->channel;
+		netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
+			  channel->channel, tx_queue->label,
+			  xdp_queue_number, tx_queue->queue);
+
+		efx->xdp_tx_queues[xdp_queue_number++] = tx_queue;
+	}
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9b4b25704271..e731c766f709 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -782,6 +782,12 @@ struct efx_async_filter_insertion {
 #define EFX_RPS_MAX_IN_FLIGHT	8
 #endif /* CONFIG_RFS_ACCEL */
 
+enum efx_xdp_tx_queues_mode {
+	EFX_XDP_TX_QUEUES_DEDICATED,	/* one queue per core, locking not needed */
+	EFX_XDP_TX_QUEUES_SHARED,	/* each queue used by more than 1 core */
+	EFX_XDP_TX_QUEUES_DISABLED	/* xdp tx not available */
+};
+
 /**
  * struct efx_nic - an Efx NIC
  * @name: Device name (net device name or bus id before net device registered)
@@ -820,6 +826,7 @@ struct efx_async_filter_insertion {
  *	should be allocated for this NIC
  * @xdp_tx_queue_count: Number of entries in %xdp_tx_queues.
  * @xdp_tx_queues: Array of pointers to tx queues used for XDP transmit.
+ * @xdp_txq_queues_mode: XDP TX queues sharing strategy.
  * @rxq_entries: Size of receive queues requested by user.
  * @txq_entries: Size of transmit queues requested by user.
  * @txq_stop_thresh: TX queue fill level at or above which we stop it.
@@ -979,6 +986,7 @@ struct efx_nic {
 
 	unsigned int xdp_tx_queue_count;
 	struct efx_tx_queue **xdp_tx_queues;
+	enum efx_xdp_tx_queues_mode xdp_txq_queues_mode;
 
 	unsigned rxq_entries;
 	unsigned txq_entries;
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 0c6650d2e239..c7afd6cda902 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -430,21 +430,23 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	int cpu;
 	int i;
 
-	cpu = raw_smp_processor_id();
+	if (unlikely(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DISABLED))
+		return -EINVAL;
+	if (unlikely(n && !xdpfs))
+		return -EINVAL;
+	if (unlikely(!n))
+		return 0;
 
-	if (!efx->xdp_tx_queue_count ||
-	    unlikely(cpu >= efx->xdp_tx_queue_count))
+	cpu = raw_smp_processor_id();
+	if (unlikely(cpu >= efx->xdp_tx_queue_count))
 		return -EINVAL;
 
 	tx_queue = efx->xdp_tx_queues[cpu];
 	if (unlikely(!tx_queue))
 		return -EINVAL;
 
-	if (unlikely(n && !xdpfs))
-		return -EINVAL;
-
-	if (!n)
-		return 0;
+	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
+		HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
 
 	/* Check for available space. We should never need multiple
 	 * descriptors per frame.
@@ -484,6 +486,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	if (flush && i > 0)
 		efx_nic_push_buffers(tx_queue);
 
+	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
+		HARD_TX_UNLOCK(efx->net_dev, tx_queue->core_txq);
+
 	return i == 0 ? -EIO : i;
 }
 
-- 
2.31.1

