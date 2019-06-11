Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9793CA96
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404379AbfFKL6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:58:55 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:12286 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404358AbfFKL6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560254332; x=1591790332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DroH6e/jBY4k8hXuVgW9279YlBoX22/O2aHhD8gCVJ8=;
  b=Mg4bthKQcbUuG9cvD9HqVFrlO3096GotLYAQQaFJ1AQedyLur969QO40
   zcihLrUnEdAUEt4tn0hnoQdyOM2Rf99wKs2b/a/uTaiDVjjIg6bzChnH6
   ZgLATBK+tf+MDRW9BKOqeMSiDIPhmbV51Po0jTamlNJdsWATMmZKaGC7e
   g=;
X-IronPort-AV: E=Sophos;i="5.60,579,1549929600"; 
   d="scan'208";a="809734461"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 11 Jun 2019 11:58:52 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id ED85DA278B;
        Tue, 11 Jun 2019 11:58:51 +0000 (UTC)
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:34 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:33 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Jun 2019 11:58:30 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net 4/7] net: ena: allow queue allocation backoff when low on memory
Date:   Tue, 11 Jun 2019 14:58:08 +0300
Message-ID: <20190611115811.2819-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611115811.2819-1-sameehj@amazon.com>
References: <20190611115811.2819-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

If there is not enough memory to allocate io queues the driver will
try to allocate smaller queues.

The backoff algorithm is as follows:

1. Try to allocate TX and RX and if successful.
1.1. return success

2. Divide by 2 the size of the larger of RX and TX queues (or both if their size is the same).

3. If TX or RX is smaller than 256
3.1. return failure.
4. else
4.1. go back to 1.

Also change the tx_queue_size, rx_queue_size field names in struct
adapter to requested_tx_queue_size and requested_rx_queue_size, and
use RX and TX queue 0 for actual queue sizes.
Explanation:
The original fields were useless as they were simply used to assign
values once from them to each of the queues in the adapter in ena_probe().
They could simply be deleted. However now that we have a backoff
feature, we have use for them. In case of backoff there is a difference
between the requested queue sizes and the actual sizes. Therefore there
is a need to save the requested queue size for future retries of queue
allocation (for example if allocation failed and then ifdown + ifup was
called we want to start the allocation from the original requested size of
the queues).

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 159 +++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   6 +-
 3 files changed, 127 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index f9152dfc9..d34eca8a3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -489,8 +489,8 @@ static void ena_get_ringparam(struct net_device *netdev,
 
 	ring->tx_max_pending = adapter->max_tx_ring_size;
 	ring->rx_max_pending = adapter->max_rx_ring_size;
-	ring->tx_pending = adapter->tx_ring_size;
-	ring->rx_pending = adapter->rx_ring_size;
+	ring->tx_pending = adapter->tx_ring[0].ring_size;
+	ring->rx_pending = adapter->rx_ring[0].ring_size;
 }
 
 static u32 ena_flow_hash_to_flow_type(u16 hash_fields)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 3fe4a9217..1fb0fbd1f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -182,7 +182,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter)
 		ena_init_io_rings_common(adapter, rxr, i);
 
 		/* TX specific ring state */
-		txr->ring_size = adapter->tx_ring_size;
+		txr->ring_size = adapter->requested_tx_ring_size;
 		txr->tx_max_header_size = ena_dev->tx_max_header_size;
 		txr->tx_mem_queue_type = ena_dev->tx_mem_queue_type;
 		txr->sgl_size = adapter->max_tx_sgl_size;
@@ -190,7 +190,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter)
 			ena_com_get_nonadaptive_moderation_interval_tx(ena_dev);
 
 		/* RX specific ring state */
-		rxr->ring_size = adapter->rx_ring_size;
+		rxr->ring_size = adapter->requested_rx_ring_size;
 		rxr->rx_copybreak = adapter->rx_copybreak;
 		rxr->sgl_size = adapter->max_rx_sgl_size;
 		rxr->smoothed_interval =
@@ -594,7 +594,6 @@ static void ena_free_rx_bufs(struct ena_adapter *adapter,
 
 /* ena_refill_all_rx_bufs - allocate all queues Rx buffers
  * @adapter: board private structure
- *
  */
 static void ena_refill_all_rx_bufs(struct ena_adapter *adapter)
 {
@@ -1638,7 +1637,7 @@ static int ena_create_io_tx_queue(struct ena_adapter *adapter, int qid)
 	ctx.qid = ena_qid;
 	ctx.mem_queue_type = ena_dev->tx_mem_queue_type;
 	ctx.msix_vector = msix_vector;
-	ctx.queue_size = adapter->tx_ring_size;
+	ctx.queue_size = tx_ring->ring_size;
 	ctx.numa_node = cpu_to_node(tx_ring->cpu);
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
@@ -1705,7 +1704,7 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
 	ctx.direction = ENA_COM_IO_QUEUE_DIRECTION_RX;
 	ctx.mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
 	ctx.msix_vector = msix_vector;
-	ctx.queue_size = adapter->rx_ring_size;
+	ctx.queue_size = rx_ring->ring_size;
 	ctx.numa_node = cpu_to_node(rx_ring->cpu);
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
@@ -1752,6 +1751,112 @@ create_err:
 	return rc;
 }
 
+static void set_io_rings_size(struct ena_adapter *adapter,
+				     int new_tx_size, int new_rx_size)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_queues; i++) {
+		adapter->tx_ring[i].ring_size = new_tx_size;
+		adapter->rx_ring[i].ring_size = new_rx_size;
+	}
+}
+
+/* This function allows queue allocation to backoff when the system is
+ * low on memory. If there is not enough memory to allocate io queues
+ * the driver will try to allocate smaller queues.
+ *
+ * The backoff algorithm is as follows:
+ *  1. Try to allocate TX and RX and if successful.
+ *  1.1. return success
+ *
+ *  2. Divide by 2 the size of the larger of RX and TX queues (or both if their size is the same).
+ *
+ *  3. If TX or RX is smaller than 256
+ *  3.1. return failure.
+ *  4. else
+ *  4.1. go back to 1.
+ */
+static int create_queues_with_size_backoff(struct ena_adapter *adapter)
+{
+	int rc, cur_rx_ring_size, cur_tx_ring_size;
+	int new_rx_ring_size, new_tx_ring_size;
+
+	/* current queue sizes might be set to smaller than the requested
+	 * ones due to past queue allocation failures.
+	 */
+	set_io_rings_size(adapter, adapter->requested_tx_ring_size,
+			  adapter->requested_rx_ring_size);
+
+	while (1) {
+		rc = ena_setup_all_tx_resources(adapter);
+		if (rc)
+			goto err_setup_tx;
+
+		rc = ena_create_all_io_tx_queues(adapter);
+		if (rc)
+			goto err_create_tx_queues;
+
+		rc = ena_setup_all_rx_resources(adapter);
+		if (rc)
+			goto err_setup_rx;
+
+		rc = ena_create_all_io_rx_queues(adapter);
+		if (rc)
+			goto err_create_rx_queues;
+
+		return 0;
+
+err_create_rx_queues:
+		ena_free_all_io_rx_resources(adapter);
+err_setup_rx:
+		ena_destroy_all_tx_queues(adapter);
+err_create_tx_queues:
+		ena_free_all_io_tx_resources(adapter);
+err_setup_tx:
+		if (rc != -ENOMEM) {
+			netif_err(adapter, ifup, adapter->netdev,
+				  "Queue creation failed with error code %d\n",
+				  rc);
+			return rc;
+		}
+
+		cur_tx_ring_size = adapter->tx_ring[0].ring_size;
+		cur_rx_ring_size = adapter->rx_ring[0].ring_size;
+
+		netif_err(adapter, ifup, adapter->netdev,
+			  "Not enough memory to create queues with sizes TX=%d, RX=%d\n",
+			  cur_tx_ring_size, cur_rx_ring_size);
+
+		new_tx_ring_size = cur_tx_ring_size;
+		new_rx_ring_size = cur_rx_ring_size;
+
+		/* Decrease the size of the larger queue, or
+		 * decrease both if they are the same size.
+		 */
+		if (cur_rx_ring_size <= cur_tx_ring_size)
+			new_tx_ring_size = cur_tx_ring_size / 2;
+		if (cur_rx_ring_size >= cur_tx_ring_size)
+			new_rx_ring_size = cur_rx_ring_size / 2;
+
+		if (cur_tx_ring_size < ENA_MIN_RING_SIZE ||
+		    cur_rx_ring_size < ENA_MIN_RING_SIZE) {
+			netif_err(adapter, ifup, adapter->netdev,
+				  "Queue creation failed with the smallest possible queue size of %d for both queues. Not retrying with smaller queues\n",
+				  ENA_MIN_RING_SIZE);
+			return rc;
+		}
+
+		netif_err(adapter, ifup, adapter->netdev,
+			  "Retrying queue creation with sizes TX=%d, RX=%d\n",
+			  new_tx_ring_size,
+			  new_rx_ring_size);
+
+		set_io_rings_size(adapter, new_tx_ring_size,
+				  new_rx_ring_size);
+	}
+}
+
 static int ena_up(struct ena_adapter *adapter)
 {
 	int rc, i;
@@ -1771,25 +1876,9 @@ static int ena_up(struct ena_adapter *adapter)
 	if (rc)
 		goto err_req_irq;
 
-	/* allocate transmit descriptors */
-	rc = ena_setup_all_tx_resources(adapter);
+	rc = create_queues_with_size_backoff(adapter);
 	if (rc)
-		goto err_setup_tx;
-
-	/* allocate receive descriptors */
-	rc = ena_setup_all_rx_resources(adapter);
-	if (rc)
-		goto err_setup_rx;
-
-	/* Create TX queues */
-	rc = ena_create_all_io_tx_queues(adapter);
-	if (rc)
-		goto err_create_tx_queues;
-
-	/* Create RX queues */
-	rc = ena_create_all_io_rx_queues(adapter);
-	if (rc)
-		goto err_create_rx_queues;
+		goto err_create_queues_with_backoff;
 
 	rc = ena_up_complete(adapter);
 	if (rc)
@@ -1818,14 +1907,11 @@ static int ena_up(struct ena_adapter *adapter)
 	return rc;
 
 err_up:
-	ena_destroy_all_rx_queues(adapter);
-err_create_rx_queues:
 	ena_destroy_all_tx_queues(adapter);
-err_create_tx_queues:
-	ena_free_all_io_rx_resources(adapter);
-err_setup_rx:
 	ena_free_all_io_tx_resources(adapter);
-err_setup_tx:
+	ena_destroy_all_rx_queues(adapter);
+	ena_free_all_io_rx_resources(adapter);
+err_create_queues_with_backoff:
 	ena_free_io_irq(adapter);
 err_req_irq:
 	ena_del_napi(adapter);
@@ -3296,17 +3382,14 @@ static int ena_calc_queue_size(struct ena_calc_queue_size_ctx *ctx)
 	max_tx_queue_size = rounddown_pow_of_two(max_tx_queue_size);
 	max_rx_queue_size = rounddown_pow_of_two(max_rx_queue_size);
 
-	tx_queue_size = min_t(u32, tx_queue_size, max_tx_queue_size);
-	rx_queue_size = min_t(u32, rx_queue_size, max_rx_queue_size);
+	tx_queue_size = clamp_val(tx_queue_size, ENA_MIN_RING_SIZE,
+				  max_tx_queue_size);
+	rx_queue_size = clamp_val(rx_queue_size, ENA_MIN_RING_SIZE,
+				  max_rx_queue_size);
 
 	tx_queue_size = rounddown_pow_of_two(tx_queue_size);
 	rx_queue_size = rounddown_pow_of_two(rx_queue_size);
 
-	if (unlikely(!rx_queue_size || !tx_queue_size)) {
-		dev_err(&ctx->pdev->dev, "Invalid queue size\n");
-		return -EFAULT;
-	}
-
 	ctx->max_tx_queue_size = max_tx_queue_size;
 	ctx->max_rx_queue_size = max_rx_queue_size;
 	ctx->tx_queue_size = tx_queue_size;
@@ -3436,8 +3519,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 	adapter->reset_reason = ENA_REGS_RESET_NORMAL;
 
-	adapter->tx_ring_size = calc_queue_ctx.tx_queue_size;
-	adapter->rx_ring_size = calc_queue_ctx.rx_queue_size;
+	adapter->requested_tx_ring_size = calc_queue_ctx.tx_queue_size;
+	adapter->requested_rx_ring_size = calc_queue_ctx.rx_queue_size;
 	adapter->max_tx_ring_size = calc_queue_ctx.max_tx_queue_size;
 	adapter->max_rx_ring_size = calc_queue_ctx.max_rx_queue_size;
 	adapter->max_tx_sgl_size = calc_queue_ctx.max_tx_sgl_size;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index afd2769f1..e8fe08cb7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -79,6 +79,8 @@
 #define ENA_BAR_MASK (BIT(ENA_REG_BAR) | BIT(ENA_MEM_BAR))
 
 #define ENA_DEFAULT_RING_SIZE	(1024)
+#define ENA_MIN_RING_SIZE	(256)
+
 
 #define ENA_TX_WAKEUP_THRESH		(MAX_SKB_FRAGS + 2)
 #define ENA_DEFAULT_RX_COPYBREAK	(256 - NET_IP_ALIGN)
@@ -331,8 +333,8 @@ struct ena_adapter {
 	u32 tx_usecs, rx_usecs; /* interrupt moderation */
 	u32 tx_frames, rx_frames; /* interrupt moderation */
 
-	u32 tx_ring_size;
-	u32 rx_ring_size;
+	u32 requested_tx_ring_size;
+	u32 requested_rx_ring_size;
 
 	u32 max_tx_ring_size;
 	u32 max_rx_ring_size;
-- 
2.17.1

