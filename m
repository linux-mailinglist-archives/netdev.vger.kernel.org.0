Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631E12D974
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE2Ju4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:50:56 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:13400 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfE2Juy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:50:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123453; x=1590659453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3RSRcyqVXDF3Ek4+0h8sKduVljkxIijy1InPJO479b4=;
  b=N/n3y2K2WvmqzBxH7CudYrvH6XvNwHB6Cp/tq9iqgNTwzjUu5XBBcGhV
   hMM5kA8cFCewSKEdJ+eFVJFnn66keUPKWwwjVBpQFhrrcH4K9wG4BH/qy
   m4gMRZBEKfCLZgZIg/Ri3AUu74FGV1IWkzp03hHJ3tzTLFrfVbou3KzOH
   o=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="398482632"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 May 2019 09:50:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 454F7241207;
        Wed, 29 May 2019 09:50:49 +0000 (UTC)
Received: from EX13D02UWB003.ant.amazon.com (10.43.161.48) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB003.ant.amazon.com (10.43.161.48) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:25 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:22 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 03/11] net: ena: replace free_tx/rx_ids union with single free_ids field in ena_ring
Date:   Wed, 29 May 2019 12:49:56 +0300
Message-ID: <20190529095004.13341-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

struct ena_ring holds a union of free_rx_ids and free_tx_ids.
Both of the above fields mean the exact same thing and are used
exactly the same way.
Furthermore, these fields are always used with a prefix of the
type of ring. So for tx it will be tx_ring->free_tx_ids, and for
rx it will be rx_ring->free_rx_ids, which shows how redundant the
"_tx" and "_rx" parts are.
Furthermore still, this may lead to confusing code like where
tx_ring->free_rx_ids which works correctly but looks like a mess.

This commit removes the aforementioned redundancy by replacing the
free_rx/tx_ids union with a single free_ids field.
It also changes a single goto label name from err_free_tx_ids: to
err_tx_free_ids: for consistency with the above new notation.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 48 ++++++++++----------
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 11 ++---
 2 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 33fab4f41..b80b5eddc 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -228,11 +228,11 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	}
 
 	size = sizeof(u16) * tx_ring->ring_size;
-	tx_ring->free_tx_ids = vzalloc_node(size, node);
-	if (!tx_ring->free_tx_ids) {
-		tx_ring->free_tx_ids = vzalloc(size);
-		if (!tx_ring->free_tx_ids)
-			goto err_free_tx_ids;
+	tx_ring->free_ids = vzalloc_node(size, node);
+	if (!tx_ring->free_ids) {
+		tx_ring->free_ids = vzalloc(size);
+		if (!tx_ring->free_ids)
+			goto err_tx_free_ids;
 	}
 
 	size = tx_ring->tx_max_header_size;
@@ -245,7 +245,7 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 
 	/* Req id ring for TX out of order completions */
 	for (i = 0; i < tx_ring->ring_size; i++)
-		tx_ring->free_tx_ids[i] = i;
+		tx_ring->free_ids[i] = i;
 
 	/* Reset tx statistics */
 	memset(&tx_ring->tx_stats, 0x0, sizeof(tx_ring->tx_stats));
@@ -256,9 +256,9 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	return 0;
 
 err_push_buf_intermediate_buf:
-	vfree(tx_ring->free_tx_ids);
-	tx_ring->free_tx_ids = NULL;
-err_free_tx_ids:
+	vfree(tx_ring->free_ids);
+	tx_ring->free_ids = NULL;
+err_tx_free_ids:
 	vfree(tx_ring->tx_buffer_info);
 	tx_ring->tx_buffer_info = NULL;
 err_tx_buffer_info:
@@ -278,8 +278,8 @@ static void ena_free_tx_resources(struct ena_adapter *adapter, int qid)
 	vfree(tx_ring->tx_buffer_info);
 	tx_ring->tx_buffer_info = NULL;
 
-	vfree(tx_ring->free_tx_ids);
-	tx_ring->free_tx_ids = NULL;
+	vfree(tx_ring->free_ids);
+	tx_ring->free_ids = NULL;
 
 	vfree(tx_ring->push_buf_intermediate_buf);
 	tx_ring->push_buf_intermediate_buf = NULL;
@@ -377,10 +377,10 @@ static int ena_setup_rx_resources(struct ena_adapter *adapter,
 	}
 
 	size = sizeof(u16) * rx_ring->ring_size;
-	rx_ring->free_rx_ids = vzalloc_node(size, node);
-	if (!rx_ring->free_rx_ids) {
-		rx_ring->free_rx_ids = vzalloc(size);
-		if (!rx_ring->free_rx_ids) {
+	rx_ring->free_ids = vzalloc_node(size, node);
+	if (!rx_ring->free_ids) {
+		rx_ring->free_ids = vzalloc(size);
+		if (!rx_ring->free_ids) {
 			vfree(rx_ring->rx_buffer_info);
 			rx_ring->rx_buffer_info = NULL;
 			return -ENOMEM;
@@ -389,7 +389,7 @@ static int ena_setup_rx_resources(struct ena_adapter *adapter,
 
 	/* Req id ring for receiving RX pkts out of order */
 	for (i = 0; i < rx_ring->ring_size; i++)
-		rx_ring->free_rx_ids[i] = i;
+		rx_ring->free_ids[i] = i;
 
 	/* Reset rx statistics */
 	memset(&rx_ring->rx_stats, 0x0, sizeof(rx_ring->rx_stats));
@@ -415,8 +415,8 @@ static void ena_free_rx_resources(struct ena_adapter *adapter,
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 
-	vfree(rx_ring->free_rx_ids);
-	rx_ring->free_rx_ids = NULL;
+	vfree(rx_ring->free_ids);
+	rx_ring->free_ids = NULL;
 }
 
 /* ena_setup_all_rx_resources - allocate I/O Rx queues resources for all queues
@@ -531,7 +531,7 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 	for (i = 0; i < num; i++) {
 		struct ena_rx_buffer *rx_info;
 
-		req_id = rx_ring->free_rx_ids[next_to_use];
+		req_id = rx_ring->free_ids[next_to_use];
 		rc = validate_rx_req_id(rx_ring, req_id);
 		if (unlikely(rc < 0))
 			break;
@@ -797,7 +797,7 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
 		tx_pkts++;
 		total_done += tx_info->tx_descs;
 
-		tx_ring->free_tx_ids[next_to_clean] = req_id;
+		tx_ring->free_ids[next_to_clean] = req_id;
 		next_to_clean = ENA_TX_RING_IDX_NEXT(next_to_clean,
 						     tx_ring->ring_size);
 	}
@@ -911,7 +911,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 		skb_put(skb, len);
 		skb->protocol = eth_type_trans(skb, rx_ring->netdev);
-		rx_ring->free_rx_ids[*next_to_clean] = req_id;
+		rx_ring->free_ids[*next_to_clean] = req_id;
 		*next_to_clean = ENA_RX_RING_IDX_ADD(*next_to_clean, descs,
 						     rx_ring->ring_size);
 		return skb;
@@ -935,7 +935,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 		rx_info->page = NULL;
 
-		rx_ring->free_rx_ids[*next_to_clean] = req_id;
+		rx_ring->free_ids[*next_to_clean] = req_id;
 		*next_to_clean =
 			ENA_RX_RING_IDX_NEXT(*next_to_clean,
 					     rx_ring->ring_size);
@@ -1088,7 +1088,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		/* exit if we failed to retrieve a buffer */
 		if (unlikely(!skb)) {
 			for (i = 0; i < ena_rx_ctx.descs; i++) {
-				rx_ring->free_tx_ids[next_to_clean] =
+				rx_ring->free_ids[next_to_clean] =
 					rx_ring->ena_bufs[i].req_id;
 				next_to_clean =
 					ENA_RX_RING_IDX_NEXT(next_to_clean,
@@ -2152,7 +2152,7 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_tx_timestamp(skb);
 
 	next_to_use = tx_ring->next_to_use;
-	req_id = tx_ring->free_tx_ids[next_to_use];
+	req_id = tx_ring->free_ids[next_to_use];
 	tx_info = &tx_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 0681e18b0..74c316081 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -221,13 +221,10 @@ struct ena_stats_rx {
 };
 
 struct ena_ring {
-	union {
-		/* Holds the empty requests for TX/RX
-		 * out of order completions
-		 */
-		u16 *free_tx_ids;
-		u16 *free_rx_ids;
-	};
+	/* Holds the empty requests for TX/RX
+	 * out of order completions
+	 */
+	u16 *free_ids;
 
 	union {
 		struct ena_tx_buffer *tx_buffer_info;
-- 
2.17.1

