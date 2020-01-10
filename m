Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3737C136DFC
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgAJN05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:26:57 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59466 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727771AbgAJN05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:26:57 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BA0FF68006F;
        Fri, 10 Jan 2020 13:26:55 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:26:49 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 2/9] sfc: move more tx code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <d3763a84-ad72-57a9-f3a4-99954410a0a0@solarflare.com>
Date:   Fri, 10 Jan 2020 13:26:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-5.134100-8.000000-10
X-TMASE-MatchedRID: OvLUjKtgMfuioKUtUDGXZbsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIVztt14qydouVbXLNvAI4tgliWcplzQBX8Otj0KvfR1lnAst8At+c3Z6fSoF3Lt+Me6i
        wifO6FIxZt5E46LnjwQLlh8LuchNxZ7ukeil+NQjVsW2YGqoUtI2QIlTs17Vz9rtqCyVBZhhdfT
        IQRPpBRVzW/eT3Ah4Kv8okEdzv+3gnLUuBcJS+lYph1hAtvKZN3YSaHlnZL81KDy5+nmfdPvG9Z
        l06nrZsYoko88aFBbYyF2rHH9ixiweLjYCwRCMC8pRHzcG+oi3YcHWTGnsBJKjxqhyDxmYj8eAk
        ec4JmJDvKFMabopawqq6VgyRueDDr1yfhWgiZDbJ1E/nrJFED30tCKdnhB58vqq8s2MNhPAq09C
        cMmQaRyq2rl3dzGQ1DBbGvtcMofzx9XteDhcauWzgJVhqILa/9158vmzvTWiKtweMNpJgm4N3K6
        cG6CjN
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.134100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662816-7R3XRs63gH9q
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code that handles transmission finalization will also be common.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/tx.c        | 77 ----------------------------
 drivers/net/ethernet/sfc/tx_common.c | 76 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tx_common.h |  2 +
 3 files changed, 78 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index c9599fcab0b4..bb666cba3ea0 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -521,41 +521,6 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	return i;
 }
 
-/* Remove packets from the TX queue
- *
- * This removes packets from the TX queue, up to and including the
- * specified index.
- */
-static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
-				unsigned int index,
-				unsigned int *pkts_compl,
-				unsigned int *bytes_compl)
-{
-	struct efx_nic *efx = tx_queue->efx;
-	unsigned int stop_index, read_ptr;
-
-	stop_index = (index + 1) & tx_queue->ptr_mask;
-	read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
-
-	while (read_ptr != stop_index) {
-		struct efx_tx_buffer *buffer = &tx_queue->buffer[read_ptr];
-
-		if (!(buffer->flags & EFX_TX_BUF_OPTION) &&
-		    unlikely(buffer->len == 0)) {
-			netif_err(efx, tx_err, efx->net_dev,
-				  "TX queue %d spurious TX completion id %x\n",
-				  tx_queue->queue, read_ptr);
-			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
-			return;
-		}
-
-		efx_dequeue_buffer(tx_queue, buffer, pkts_compl, bytes_compl);
-
-		++tx_queue->read_count;
-		read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
-	}
-}
-
 /* Initiate a packet transmission.  We use one channel per CPU
  * (sharing when we have more CPUs than channels).  On Falcon, the TX
  * completion events will be directed back to the CPU that transmitted
@@ -668,45 +633,3 @@ int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 	net_dev->num_tc = num_tc;
 	return 0;
 }
-
-void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
-{
-	unsigned fill_level;
-	struct efx_nic *efx = tx_queue->efx;
-	struct efx_tx_queue *txq2;
-	unsigned int pkts_compl = 0, bytes_compl = 0;
-
-	EFX_WARN_ON_ONCE_PARANOID(index > tx_queue->ptr_mask);
-
-	efx_dequeue_buffers(tx_queue, index, &pkts_compl, &bytes_compl);
-	tx_queue->pkts_compl += pkts_compl;
-	tx_queue->bytes_compl += bytes_compl;
-
-	if (pkts_compl > 1)
-		++tx_queue->merge_events;
-
-	/* See if we need to restart the netif queue.  This memory
-	 * barrier ensures that we write read_count (inside
-	 * efx_dequeue_buffers()) before reading the queue status.
-	 */
-	smp_mb();
-	if (unlikely(netif_tx_queue_stopped(tx_queue->core_txq)) &&
-	    likely(efx->port_enabled) &&
-	    likely(netif_device_present(efx->net_dev))) {
-		txq2 = efx_tx_queue_partner(tx_queue);
-		fill_level = max(tx_queue->insert_count - tx_queue->read_count,
-				 txq2->insert_count - txq2->read_count);
-		if (fill_level <= efx->txq_wake_thresh)
-			netif_tx_wake_queue(tx_queue->core_txq);
-	}
-
-	/* Check whether the hardware queue is now empty */
-	if ((int)(tx_queue->read_count - tx_queue->old_write_count) >= 0) {
-		tx_queue->old_write_count = READ_ONCE(tx_queue->write_count);
-		if (tx_queue->read_count == tx_queue->old_write_count) {
-			smp_mb();
-			tx_queue->empty_read_count =
-				tx_queue->read_count | EFX_EMPTY_COUNT_VALID;
-		}
-	}
-}
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index e29ade21c4b9..0ce699ecae5a 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -191,6 +191,82 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 	buffer->flags = 0;
 }
 
+/* Remove packets from the TX queue
+ *
+ * This removes packets from the TX queue, up to and including the
+ * specified index.
+ */
+static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
+				unsigned int index,
+				unsigned int *pkts_compl,
+				unsigned int *bytes_compl)
+{
+	struct efx_nic *efx = tx_queue->efx;
+	unsigned int stop_index, read_ptr;
+
+	stop_index = (index + 1) & tx_queue->ptr_mask;
+	read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
+
+	while (read_ptr != stop_index) {
+		struct efx_tx_buffer *buffer = &tx_queue->buffer[read_ptr];
+
+		if (!(buffer->flags & EFX_TX_BUF_OPTION) &&
+		    unlikely(buffer->len == 0)) {
+			netif_err(efx, tx_err, efx->net_dev,
+				  "TX queue %d spurious TX completion id %x\n",
+				  tx_queue->queue, read_ptr);
+			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
+			return;
+		}
+
+		efx_dequeue_buffer(tx_queue, buffer, pkts_compl, bytes_compl);
+
+		++tx_queue->read_count;
+		read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
+	}
+}
+
+void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
+{
+	unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
+	struct efx_nic *efx = tx_queue->efx;
+	struct efx_tx_queue *txq2;
+
+	EFX_WARN_ON_ONCE_PARANOID(index > tx_queue->ptr_mask);
+
+	efx_dequeue_buffers(tx_queue, index, &pkts_compl, &bytes_compl);
+	tx_queue->pkts_compl += pkts_compl;
+	tx_queue->bytes_compl += bytes_compl;
+
+	if (pkts_compl > 1)
+		++tx_queue->merge_events;
+
+	/* See if we need to restart the netif queue.  This memory
+	 * barrier ensures that we write read_count (inside
+	 * efx_dequeue_buffers()) before reading the queue status.
+	 */
+	smp_mb();
+	if (unlikely(netif_tx_queue_stopped(tx_queue->core_txq)) &&
+	    likely(efx->port_enabled) &&
+	    likely(netif_device_present(efx->net_dev))) {
+		txq2 = efx_tx_queue_partner(tx_queue);
+		fill_level = max(tx_queue->insert_count - tx_queue->read_count,
+				 txq2->insert_count - txq2->read_count);
+		if (fill_level <= efx->txq_wake_thresh)
+			netif_tx_wake_queue(tx_queue->core_txq);
+	}
+
+	/* Check whether the hardware queue is now empty */
+	if ((int)(tx_queue->read_count - tx_queue->old_write_count) >= 0) {
+		tx_queue->old_write_count = READ_ONCE(tx_queue->write_count);
+		if (tx_queue->read_count == tx_queue->old_write_count) {
+			smp_mb();
+			tx_queue->empty_read_count =
+				tx_queue->read_count | EFX_EMPTY_COUNT_VALID;
+		}
+	}
+}
+
 struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 				       dma_addr_t dma_addr, size_t len)
 {
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
index afdfc79a8ea0..58add94ab500 100644
--- a/drivers/net/ethernet/sfc/tx_common.h
+++ b/drivers/net/ethernet/sfc/tx_common.h
@@ -21,6 +21,8 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 			unsigned int *pkts_compl,
 			unsigned int *bytes_compl);
 
+void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
+
 struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 				       dma_addr_t dma_addr, size_t len);
 int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-- 
2.20.1


