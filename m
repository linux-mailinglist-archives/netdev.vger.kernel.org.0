Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46D629A0D7
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409077AbgJZXuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409057AbgJZXuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB2972075B;
        Mon, 26 Oct 2020 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756213;
        bh=jKGGNj5/MR4uKu5TU8nBfgftB5GXaB5s1H1PBcsGnpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPAt3nTFfWbvnDays7fC4PWdEYhOxhKT53XKwBdzGKrVRZN1v3nmPYZHei2XByhPL
         iR+d3melZpMMYzgA370mjSjH3pLfwUiQNG/XR2EoB7IeK2XUcULNY6mK7jW2wSt/n1
         1YmVYspa/eCKdKgFUmZhT0ozH13Aua5KymSi5pko=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 054/147] sfc: add and use efx_tx_send_pending in tx.c
Date:   Mon, 26 Oct 2020 19:47:32 -0400
Message-Id: <20201026234905.1022767-54-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 1c0544d24927e4fad04f858216b8ea767a3bd123 ]

Instead of using efx_tx_queue_partner(), which relies on the assumption
 that tx_queues_per_channel is 2, efx_tx_send_pending() iterates over
 txqs with efx_for_each_channel_tx_queue().
We unconditionally set tx_queue->xmit_pending (renamed from
 xmit_more_available), then condition on xmit_more for the call to
 efx_tx_send_pending(), which will clear xmit_pending.  Thus, after an
 xmit_more TX, the doorbell is un-rung and xmit_pending is true.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c       |  2 +-
 drivers/net/ethernet/sfc/ef100_tx.c   | 14 +++----
 drivers/net/ethernet/sfc/farch.c      |  2 +-
 drivers/net/ethernet/sfc/net_driver.h |  4 +-
 drivers/net/ethernet/sfc/tx.c         | 59 ++++++++++++++-------------
 drivers/net/ethernet/sfc/tx_common.c  |  4 +-
 6 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4b0b2cf026a52..ad05710883f85 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2367,7 +2367,7 @@ static void efx_ef10_tx_write(struct efx_tx_queue *tx_queue)
 	unsigned int write_ptr;
 	efx_qword_t *txd;
 
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	if (unlikely(tx_queue->write_count == tx_queue->insert_count))
 		return;
 
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index a09546e434085..8d478c5e720e1 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -131,7 +131,7 @@ void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue)
 	efx_writed_page(tx_queue->efx, &reg,
 			ER_GZ_TX_RING_DOORBELL, tx_queue->queue);
 	tx_queue->notify_count = tx_queue->write_count;
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 }
 
 static void ef100_tx_push_buffers(struct efx_tx_queue *tx_queue)
@@ -373,14 +373,14 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	}
 
 	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb->len, xmit_more))
-		tx_queue->xmit_more_available = false; /* push doorbell */
+		tx_queue->xmit_pending = false; /* push doorbell */
 	else if (tx_queue->write_count - tx_queue->notify_count > 255)
 		/* Ensure we never push more than 256 packets at once */
-		tx_queue->xmit_more_available = false; /* push */
+		tx_queue->xmit_pending = false; /* push */
 	else
-		tx_queue->xmit_more_available = true; /* don't push yet */
+		tx_queue->xmit_pending = true; /* don't push yet */
 
-	if (!tx_queue->xmit_more_available)
+	if (!tx_queue->xmit_pending)
 		ef100_tx_push_buffers(tx_queue);
 
 	if (segments) {
@@ -400,9 +400,9 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	/* If we're not expecting another transmit and we had something to push
 	 * on this queue then we need to push here to get the previous packets
 	 * out.  We only enter this branch from before the 'Update BQL' section
-	 * above, so xmit_more_available still refers to the old state.
+	 * above, so xmit_pending still refers to the old state.
 	 */
-	if (tx_queue->xmit_more_available && !xmit_more)
+	if (tx_queue->xmit_pending && !xmit_more)
 		ef100_tx_push_buffers(tx_queue);
 	return rc;
 }
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 4002f9a3ae909..0cc7a37b63445 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -320,7 +320,7 @@ void efx_farch_tx_write(struct efx_tx_queue *tx_queue)
 	unsigned write_ptr;
 	unsigned old_write_count = tx_queue->write_count;
 
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	if (unlikely(tx_queue->write_count == tx_queue->insert_count))
 		return;
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 062462a138475..fb7290bbb135c 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -244,7 +244,7 @@ struct efx_tx_buffer {
  * @tso_fallbacks: Number of times TSO fallback used
  * @pushes: Number of times the TX push feature has been used
  * @pio_packets: Number of times the TX PIO feature has been used
- * @xmit_more_available: Are any packets waiting to be pushed to the NIC
+ * @xmit_pending: Are any packets waiting to be pushed to the NIC
  * @cb_packets: Number of times the TX copybreak feature has been used
  * @notify_count: Count of notified descriptors to the NIC
  * @empty_read_count: If the completion path has seen the queue as empty
@@ -292,7 +292,7 @@ struct efx_tx_queue {
 	unsigned int tso_fallbacks;
 	unsigned int pushes;
 	unsigned int pio_packets;
-	bool xmit_more_available;
+	bool xmit_pending;
 	unsigned int cb_packets;
 	unsigned int notify_count;
 	/* Statistics to supplement MAC stats */
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 727201d5eb24e..c502d226371a9 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -268,6 +268,19 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
 }
 #endif /* EFX_USE_PIO */
 
+/* Send any pending traffic for a channel. xmit_more is shared across all
+ * queues for a channel, so we must check all of them.
+ */
+static void efx_tx_send_pending(struct efx_channel *channel)
+{
+	struct efx_tx_queue *q;
+
+	efx_for_each_channel_tx_queue(q, channel) {
+		if (q->xmit_pending)
+			efx_nic_push_buffers(q);
+	}
+}
+
 /*
  * Add a socket buffer to a TX queue
  *
@@ -336,21 +349,11 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 
 	efx_tx_maybe_stop_queue(tx_queue);
 
-	/* Pass off to hardware */
-	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb_len, xmit_more)) {
-		struct efx_tx_queue *txq2 = efx_tx_queue_partner(tx_queue);
-
-		/* There could be packets left on the partner queue if
-		 * xmit_more was set. If we do not push those they
-		 * could be left for a long time and cause a netdev watchdog.
-		 */
-		if (txq2->xmit_more_available)
-			efx_nic_push_buffers(txq2);
+	tx_queue->xmit_pending = true;
 
-		efx_nic_push_buffers(tx_queue);
-	} else {
-		tx_queue->xmit_more_available = xmit_more;
-	}
+	/* Pass off to hardware */
+	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb_len, xmit_more))
+		efx_tx_send_pending(tx_queue->channel);
 
 	if (segments) {
 		tx_queue->tso_bursts++;
@@ -371,14 +374,8 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 	 * on this queue or a partner queue then we need to push here to get the
 	 * previous packets out.
 	 */
-	if (!xmit_more) {
-		struct efx_tx_queue *txq2 = efx_tx_queue_partner(tx_queue);
-
-		if (txq2->xmit_more_available)
-			efx_nic_push_buffers(txq2);
-
-		efx_nic_push_buffers(tx_queue);
-	}
+	if (!xmit_more)
+		efx_tx_send_pending(tx_queue->channel);
 
 	return NETDEV_TX_OK;
 }
@@ -489,18 +486,24 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 
 	EFX_WARN_ON_PARANOID(!netif_device_present(net_dev));
 
-	/* PTP "event" packet */
-	if (unlikely(efx_xmit_with_hwtstamp(skb)) &&
-	    unlikely(efx_ptp_is_ptp_tx(efx, skb))) {
-		return efx_ptp_tx(efx, skb);
-	}
-
 	index = skb_get_queue_mapping(skb);
 	type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OFFLOAD : 0;
 	if (index >= efx->n_tx_channels) {
 		index -= efx->n_tx_channels;
 		type |= EFX_TXQ_TYPE_HIGHPRI;
 	}
+
+	/* PTP "event" packet */
+	if (unlikely(efx_xmit_with_hwtstamp(skb)) &&
+	    unlikely(efx_ptp_is_ptp_tx(efx, skb))) {
+		/* There may be existing transmits on the channel that are
+		 * waiting for this packet to trigger the doorbell write.
+		 * We need to send the packets at this point.
+		 */
+		efx_tx_send_pending(efx_get_tx_channel(efx, index));
+		return efx_ptp_tx(efx, skb);
+	}
+
 	tx_queue = efx_get_tx_queue(efx, index, type);
 
 	return __efx_enqueue_skb(tx_queue, skb);
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 793e234819a8c..187d5c379a377 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -78,7 +78,7 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->read_count = 0;
 	tx_queue->old_read_count = 0;
 	tx_queue->empty_read_count = 0 | EFX_EMPTY_COUNT_VALID;
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	tx_queue->timestamping = (efx_ptp_use_mac_tx_timestamps(efx) &&
 				  tx_queue->channel == efx_ptp_channel(efx));
 	tx_queue->completed_timestamp_major = 0;
@@ -116,7 +116,7 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
 
 		++tx_queue->read_count;
 	}
-	tx_queue->xmit_more_available = false;
+	tx_queue->xmit_pending = false;
 	netdev_tx_reset_queue(tx_queue->core_txq);
 }
 
-- 
2.25.1

