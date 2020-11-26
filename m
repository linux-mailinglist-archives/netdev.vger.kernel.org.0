Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6805C2C5D78
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387776AbgKZVUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:20:51 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:52491 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgKZVUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:20:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606425651; x=1637961651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=C3JrDT9xS0rE0BUzca9wKEp7kDGK/qpBwfS4rcvUS/Y=;
  b=qU5Wi1QnNIXUDewsHcdGFmlADj/CQs3vp9iFiPh6ndUsJYLIhG42aEeW
   V0ZCqXZABeBh4aI+Q5GM7/Hr4eSMFYIXCLd3SKZi5gapjw7D6YtdYY1Ec
   OfxEPlQ2YoOb8CDbr6Y/npHyV1dhv7KMwUM6LDl16yM/w2nwoyPOqr/uS
   4=;
X-IronPort-AV: E=Sophos;i="5.78,373,1599523200"; 
   d="scan'208";a="66001625"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 26 Nov 2020 21:20:44 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id 72E4BA71AB;
        Thu, 26 Nov 2020 21:20:43 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:42 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:42 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.20) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 26 Nov 2020 21:20:39 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [RFC PATCH V2 net-next 5/9] net: ena: aggregate stats increase into a function
Date:   Thu, 26 Nov 2020 23:20:13 +0200
Message-ID: <1606425617-13112-6-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
References: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Introduce ena_increase_stat() function to increase statistics by a
certain number.
The function includes the
    - lock aquire (on 32bit machines)
    - stat increase
    - lock release (on 32bit machines)

line sequence that is ubiquitous across the driver.

The function increases a single stat at a time and several stats which
are increased together weren't put into a function to avoid
calling the function several times for each stat which looks bad and
might decrease performance.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 167 ++++++++-----------
 1 file changed, 68 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 371593ed0400..9c3e0e3e33b5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -80,6 +80,15 @@ static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
 static int ena_create_io_tx_queues_in_range(struct ena_adapter *adapter,
 					    int first_index, int count);
 
+/* Increase a stat by cnt while holding syncp seqlock on 32bit machines */
+static void ena_increase_stat(u64 *statp, u64 cnt,
+			      struct u64_stats_sync *syncp)
+{
+       u64_stats_update_begin(syncp);
+       (*statp) += cnt;
+       u64_stats_update_end(syncp);
+}
+
 static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
@@ -92,9 +101,7 @@ static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
 		return;
 
 	adapter->reset_reason = ENA_REGS_RESET_OS_NETDEV_WD;
-	u64_stats_update_begin(&adapter->syncp);
-	adapter->dev_stats.tx_timeout++;
-	u64_stats_update_end(&adapter->syncp);
+	ena_increase_stat(&adapter->dev_stats.tx_timeout, 1, &adapter->syncp);
 
 	netif_err(adapter, tx_err, dev, "Transmit time out\n");
 }
@@ -154,9 +161,8 @@ static int ena_xmit_common(struct net_device *dev,
 	if (unlikely(rc)) {
 		netif_err(adapter, tx_queued, dev,
 			  "Failed to prepare tx bufs\n");
-		u64_stats_update_begin(&ring->syncp);
-		ring->tx_stats.prepare_ctx_err++;
-		u64_stats_update_end(&ring->syncp);
+		ena_increase_stat(&ring->tx_stats.prepare_ctx_err, 1,
+			&ring->syncp);
 		if (rc != -ENOMEM) {
 			adapter->reset_reason =
 				ENA_REGS_RESET_DRIVER_INVALID_STATE;
@@ -264,9 +270,8 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
 	return 0;
 
 error_report_dma_error:
-	u64_stats_update_begin(&xdp_ring->syncp);
-	xdp_ring->tx_stats.dma_mapping_err++;
-	u64_stats_update_end(&xdp_ring->syncp);
+	ena_increase_stat(&xdp_ring->tx_stats.dma_mapping_err, 1,
+		&xdp_ring->syncp);
 	netif_warn(adapter, tx_queued, adapter->netdev, "Failed to map xdp buff\n");
 
 	xdp_return_frame_rx_napi(tx_info->xdpf);
@@ -320,9 +325,7 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	 * has a mb
 	 */
 	ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
-	u64_stats_update_begin(&xdp_ring->syncp);
-	xdp_ring->tx_stats.doorbells++;
-	u64_stats_update_end(&xdp_ring->syncp);
+	ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1, &xdp_ring->syncp);
 
 	return NETDEV_TX_OK;
 
@@ -369,9 +372,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
 		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
 	}
 
-	u64_stats_update_begin(&rx_ring->syncp);
-	(*xdp_stat)++;
-	u64_stats_update_end(&rx_ring->syncp);
+	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
 out:
 	rcu_read_unlock();
 
@@ -924,9 +925,8 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 
 	page = alloc_page(gfp);
 	if (unlikely(!page)) {
-		u64_stats_update_begin(&rx_ring->syncp);
-		rx_ring->rx_stats.page_alloc_fail++;
-		u64_stats_update_end(&rx_ring->syncp);
+		ena_increase_stat(&rx_ring->rx_stats.page_alloc_fail, 1,
+			&rx_ring->syncp);
 		return -ENOMEM;
 	}
 
@@ -936,9 +936,8 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	dma = dma_map_page(rx_ring->dev, page, 0, ENA_PAGE_SIZE,
 			   DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(rx_ring->dev, dma))) {
-		u64_stats_update_begin(&rx_ring->syncp);
-		rx_ring->rx_stats.dma_mapping_err++;
-		u64_stats_update_end(&rx_ring->syncp);
+		ena_increase_stat(&rx_ring->rx_stats.dma_mapping_err, 1,
+			&rx_ring->syncp);
 
 		__free_page(page);
 		return -EIO;
@@ -1011,9 +1010,8 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 	}
 
 	if (unlikely(i < num)) {
-		u64_stats_update_begin(&rx_ring->syncp);
-		rx_ring->rx_stats.refil_partial++;
-		u64_stats_update_end(&rx_ring->syncp);
+		ena_increase_stat(&rx_ring->rx_stats.refil_partial, 1,
+			&rx_ring->syncp);
 		netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
 			   "Refilled rx qid %d with only %d buffers (from %d)\n",
 			   rx_ring->qid, i, num);
@@ -1189,9 +1187,7 @@ static int handle_invalid_req_id(struct ena_ring *ring, u16 req_id,
 			  "Invalid req_id: %hu\n",
 			  req_id);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->tx_stats.bad_req_id++;
-	u64_stats_update_end(&ring->syncp);
+	ena_increase_stat(&ring->tx_stats.bad_req_id, 1, &ring->syncp);
 
 	/* Trigger device reset */
 	ring->adapter->reset_reason = ENA_REGS_RESET_INV_TX_REQ_ID;
@@ -1302,9 +1298,8 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
 		if (netif_tx_queue_stopped(txq) && above_thresh &&
 		    test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags)) {
 			netif_tx_wake_queue(txq);
-			u64_stats_update_begin(&tx_ring->syncp);
-			tx_ring->tx_stats.queue_wakeup++;
-			u64_stats_update_end(&tx_ring->syncp);
+			ena_increase_stat(&tx_ring->tx_stats.queue_wakeup, 1,
+				&tx_ring->syncp);
 		}
 		__netif_tx_unlock(txq);
 	}
@@ -1323,9 +1318,8 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, bool frags)
 						rx_ring->rx_copybreak);
 
 	if (unlikely(!skb)) {
-		u64_stats_update_begin(&rx_ring->syncp);
-		rx_ring->rx_stats.skb_alloc_fail++;
-		u64_stats_update_end(&rx_ring->syncp);
+		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 1,
+			&rx_ring->syncp);
 		netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
 			  "Failed to allocate skb. frags: %d\n", frags);
 		return NULL;
@@ -1453,9 +1447,8 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
 		     (ena_rx_ctx->l3_csum_err))) {
 		/* ipv4 checksum error */
 		skb->ip_summed = CHECKSUM_NONE;
-		u64_stats_update_begin(&rx_ring->syncp);
-		rx_ring->rx_stats.bad_csum++;
-		u64_stats_update_end(&rx_ring->syncp);
+		ena_increase_stat(&rx_ring->rx_stats.bad_csum, 1,
+			&rx_ring->syncp);
 		netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
 			  "RX IPv4 header checksum error\n");
 		return;
@@ -1466,9 +1459,8 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
 		   (ena_rx_ctx->l4_proto == ENA_ETH_IO_L4_PROTO_UDP))) {
 		if (unlikely(ena_rx_ctx->l4_csum_err)) {
 			/* TCP/UDP checksum error */
-			u64_stats_update_begin(&rx_ring->syncp);
-			rx_ring->rx_stats.bad_csum++;
-			u64_stats_update_end(&rx_ring->syncp);
+			ena_increase_stat(&rx_ring->rx_stats.bad_csum, 1,
+				&rx_ring->syncp);
 			netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
 				  "RX L4 checksum error\n");
 			skb->ip_summed = CHECKSUM_NONE;
@@ -1477,13 +1469,11 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
 
 		if (likely(ena_rx_ctx->l4_csum_checked)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			u64_stats_update_begin(&rx_ring->syncp);
-			rx_ring->rx_stats.csum_good++;
-			u64_stats_update_end(&rx_ring->syncp);
+			ena_increase_stat(&rx_ring->rx_stats.csum_good, 1,
+				&rx_ring->syncp);
 		} else {
-			u64_stats_update_begin(&rx_ring->syncp);
-			rx_ring->rx_stats.csum_unchecked++;
-			u64_stats_update_end(&rx_ring->syncp);
+			ena_increase_stat(&rx_ring->rx_stats.csum_unchecked, 1,
+				&rx_ring->syncp);
 			skb->ip_summed = CHECKSUM_NONE;
 		}
 	} else {
@@ -1675,14 +1665,12 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	adapter = netdev_priv(rx_ring->netdev);
 
 	if (rc == -ENOSPC) {
-		u64_stats_update_begin(&rx_ring->syncp);
-		rx_ring->rx_stats.bad_desc_num++;
-		u64_stats_update_end(&rx_ring->syncp);
+		ena_increase_stat(&rx_ring->rx_stats.bad_desc_num, 1,
+					 &rx_ring->syncp);
 		adapter->reset_reason = ENA_REGS_RESET_TOO_MANY_RX_DESCS;
 	} else {
-		u64_stats_update_begin(&rx_ring->syncp);
-		rx_ring->rx_stats.bad_req_id++;
-		u64_stats_update_end(&rx_ring->syncp);
+		ena_increase_stat(&rx_ring->rx_stats.bad_req_id, 1,
+					 &rx_ring->syncp);
 		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
 	}
 
@@ -1743,9 +1731,8 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 				tx_ring->smoothed_interval,
 				true);
 
-	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.unmask_interrupt++;
-	u64_stats_update_end(&tx_ring->syncp);
+	ena_increase_stat(&tx_ring->tx_stats.unmask_interrupt, 1,
+		&tx_ring->syncp);
 
 	/* It is a shared MSI-X.
 	 * Tx and Rx CQ have pointer to it.
@@ -2552,9 +2539,8 @@ static int ena_up(struct ena_adapter *adapter)
 	if (test_bit(ENA_FLAG_LINK_UP, &adapter->flags))
 		netif_carrier_on(adapter->netdev);
 
-	u64_stats_update_begin(&adapter->syncp);
-	adapter->dev_stats.interface_up++;
-	u64_stats_update_end(&adapter->syncp);
+	ena_increase_stat(&adapter->dev_stats.interface_up, 1,
+		&adapter->syncp);
 
 	set_bit(ENA_FLAG_DEV_UP, &adapter->flags);
 
@@ -2592,9 +2578,8 @@ static void ena_down(struct ena_adapter *adapter)
 
 	clear_bit(ENA_FLAG_DEV_UP, &adapter->flags);
 
-	u64_stats_update_begin(&adapter->syncp);
-	adapter->dev_stats.interface_down++;
-	u64_stats_update_end(&adapter->syncp);
+	ena_increase_stat(&adapter->dev_stats.interface_down, 1,
+		&adapter->syncp);
 
 	netif_carrier_off(adapter->netdev);
 	netif_tx_disable(adapter->netdev);
@@ -2822,15 +2807,12 @@ static int ena_check_and_linearize_skb(struct ena_ring *tx_ring,
 	    (header_len < tx_ring->tx_max_header_size))
 		return 0;
 
-	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.linearize++;
-	u64_stats_update_end(&tx_ring->syncp);
+	ena_increase_stat(&tx_ring->tx_stats.linearize, 1, &tx_ring->syncp);
 
 	rc = skb_linearize(skb);
 	if (unlikely(rc)) {
-		u64_stats_update_begin(&tx_ring->syncp);
-		tx_ring->tx_stats.linearize_failed++;
-		u64_stats_update_end(&tx_ring->syncp);
+		ena_increase_stat(&tx_ring->tx_stats.linearize_failed, 1,
+			&tx_ring->syncp);
 	}
 
 	return rc;
@@ -2870,9 +2852,8 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
 					       tx_ring->push_buf_intermediate_buf);
 		*header_len = push_len;
 		if (unlikely(skb->data != *push_hdr)) {
-			u64_stats_update_begin(&tx_ring->syncp);
-			tx_ring->tx_stats.llq_buffer_copy++;
-			u64_stats_update_end(&tx_ring->syncp);
+			ena_increase_stat(&tx_ring->tx_stats.llq_buffer_copy, 1,
+				&tx_ring->syncp);
 
 			delta = push_len - skb_head_len;
 		}
@@ -2929,9 +2910,8 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
 	return 0;
 
 error_report_dma_error:
-	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.dma_mapping_err++;
-	u64_stats_update_end(&tx_ring->syncp);
+	ena_increase_stat(&tx_ring->tx_stats.dma_mapping_err, 1,
+		&tx_ring->syncp);
 	netif_warn(adapter, tx_queued, adapter->netdev, "Failed to map skb\n");
 
 	tx_info->skb = NULL;
@@ -3008,9 +2988,8 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			  __func__, qid);
 
 		netif_tx_stop_queue(txq);
-		u64_stats_update_begin(&tx_ring->syncp);
-		tx_ring->tx_stats.queue_stop++;
-		u64_stats_update_end(&tx_ring->syncp);
+		ena_increase_stat(&tx_ring->tx_stats.queue_stop, 1,
+			&tx_ring->syncp);
 
 		/* There is a rare condition where this function decide to
 		 * stop the queue but meanwhile clean_tx_irq updates
@@ -3025,9 +3004,8 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (ena_com_sq_have_enough_space(tx_ring->ena_com_io_sq,
 						 ENA_TX_WAKEUP_THRESH)) {
 			netif_tx_wake_queue(txq);
-			u64_stats_update_begin(&tx_ring->syncp);
-			tx_ring->tx_stats.queue_wakeup++;
-			u64_stats_update_end(&tx_ring->syncp);
+			ena_increase_stat(&tx_ring->tx_stats.queue_wakeup, 1,
+				&tx_ring->syncp);
 		}
 	}
 
@@ -3036,9 +3014,8 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * has a mb
 		 */
 		ena_com_write_sq_doorbell(tx_ring->ena_com_io_sq);
-		u64_stats_update_begin(&tx_ring->syncp);
-		tx_ring->tx_stats.doorbells++;
-		u64_stats_update_end(&tx_ring->syncp);
+		ena_increase_stat(&tx_ring->tx_stats.doorbells, 1,
+			&tx_ring->syncp);
 	}
 
 	return NETDEV_TX_OK;
@@ -3673,9 +3650,8 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 		rc = -EIO;
 	}
 
-	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.missed_tx += missed_tx;
-	u64_stats_update_end(&tx_ring->syncp);
+	ena_increase_stat(&tx_ring->tx_stats.missed_tx , missed_tx,
+		&tx_ring->syncp);
 
 	return rc;
 }
@@ -3758,9 +3734,8 @@ static void check_for_empty_rx_ring(struct ena_adapter *adapter)
 			rx_ring->empty_rx_queue++;
 
 			if (rx_ring->empty_rx_queue >= EMPTY_RX_REFILL) {
-				u64_stats_update_begin(&rx_ring->syncp);
-				rx_ring->rx_stats.empty_rx_ring++;
-				u64_stats_update_end(&rx_ring->syncp);
+				ena_increase_stat(&rx_ring->rx_stats.empty_rx_ring, 1,
+					&rx_ring->syncp);
 
 				netif_err(adapter, drv, adapter->netdev,
 					  "Trigger refill for ring %d\n", i);
@@ -3790,9 +3765,8 @@ static void check_for_missing_keep_alive(struct ena_adapter *adapter)
 	if (unlikely(time_is_before_jiffies(keep_alive_expired))) {
 		netif_err(adapter, drv, adapter->netdev,
 			  "Keep alive watchdog timeout.\n");
-		u64_stats_update_begin(&adapter->syncp);
-		adapter->dev_stats.wd_expired++;
-		u64_stats_update_end(&adapter->syncp);
+		ena_increase_stat(&adapter->dev_stats.wd_expired, 1,
+			&adapter->syncp);
 		adapter->reset_reason = ENA_REGS_RESET_KEEP_ALIVE_TO;
 		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 	}
@@ -3803,9 +3777,8 @@ static void check_for_admin_com_state(struct ena_adapter *adapter)
 	if (unlikely(!ena_com_get_admin_running_state(adapter->ena_dev))) {
 		netif_err(adapter, drv, adapter->netdev,
 			  "ENA admin queue is not in running state!\n");
-		u64_stats_update_begin(&adapter->syncp);
-		adapter->dev_stats.admin_q_pause++;
-		u64_stats_update_end(&adapter->syncp);
+		ena_increase_stat(&adapter->dev_stats.admin_q_pause, 1,
+			&adapter->syncp);
 		adapter->reset_reason = ENA_REGS_RESET_ADMIN_TO;
 		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 	}
@@ -4441,9 +4414,7 @@ static int __maybe_unused ena_suspend(struct device *dev_d)
 	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct ena_adapter *adapter = pci_get_drvdata(pdev);
 
-	u64_stats_update_begin(&adapter->syncp);
-	adapter->dev_stats.suspend++;
-	u64_stats_update_end(&adapter->syncp);
+	ena_increase_stat(&adapter->dev_stats.suspend, 1, &adapter->syncp);
 
 	rtnl_lock();
 	if (unlikely(test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
@@ -4464,9 +4435,7 @@ static int __maybe_unused ena_resume(struct device *dev_d)
 	struct ena_adapter *adapter = dev_get_drvdata(dev_d);
 	int rc;
 
-	u64_stats_update_begin(&adapter->syncp);
-	adapter->dev_stats.resume++;
-	u64_stats_update_end(&adapter->syncp);
+	ena_increase_stat(&adapter->dev_stats.resume, 1, &adapter->syncp);
 
 	rtnl_lock();
 	rc = ena_restore_device(adapter);
-- 
2.23.3

