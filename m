Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D3B2C1435
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgKWTJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:09:55 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:21596 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgKWTJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:09:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606158594; x=1637694594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VYn/BO4X0I7PeuwDJ22wzY+p/Q95/OARbHVrzaLnSG0=;
  b=WH0HJ5SgBjZ1ypM4KAe9IyBclUJVDjrMJDvzGoZUG/M+SZsl8xLfxXsZ
   EVVFN/1USxvD5qvHANofGyE4vrTrvwWXz7GvanZgsEQ64foCakTMF8g6z
   4wwT7pxN3Vu4/Ku4BTKUzGn0Lu2VZKYnDVcYHT6Zb0oHC2wrSkncE0ci1
   o=;
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="68266907"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Nov 2020 19:09:48 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id AECCCA1D3A;
        Mon, 23 Nov 2020 19:09:47 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Nov 2020 19:09:37 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Ido Segev <idose@amazon.com>
Subject: [PATCH V3 net 1/3] net: ena: handle bad request id in ena_netdev
Date:   Mon, 23 Nov 2020 21:08:57 +0200
Message-ID: <20201123190859.21298-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123190859.21298-1-shayagr@amazon.com>
References: <20201123190859.21298-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D17UWC003.ant.amazon.com (10.43.162.206) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After request id is checked in validate_rx_req_id() its value is still
used in the line
	rx_ring->free_ids[next_to_clean] =
					rx_ring->ena_bufs[i].req_id;
even if it was found to be out-of-bound for the array free_ids.

The patch moves the request id to an earlier stage in the napi routine and
makes sure its value isn't used if it's found out-of-bounds.

Fixes: 30623e1ed116 ("net: ena: avoid memory access violation by validating req_id properly")
Signed-off-by: Ido Segev <idose@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  3 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 43 +++++--------------
 2 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index ad30cacc1622..032ab9f20438 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -516,6 +516,7 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 {
 	struct ena_com_rx_buf_info *ena_buf = &ena_rx_ctx->ena_bufs[0];
 	struct ena_eth_io_rx_cdesc_base *cdesc = NULL;
+	u16 q_depth = io_cq->q_depth;
 	u16 cdesc_idx = 0;
 	u16 nb_hw_desc;
 	u16 i = 0;
@@ -543,6 +544,8 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 	do {
 		ena_buf[i].len = cdesc->length;
 		ena_buf[i].req_id = cdesc->req_id;
+		if (unlikely(ena_buf[i].req_id >= q_depth))
+			return -EIO;
 
 		if (++i >= nb_hw_desc)
 			break;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index e8131dadc22c..574c2b5ba21e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -789,24 +789,6 @@ static void ena_free_all_io_tx_resources(struct ena_adapter *adapter)
 					      adapter->num_io_queues);
 }
 
-static int validate_rx_req_id(struct ena_ring *rx_ring, u16 req_id)
-{
-	if (likely(req_id < rx_ring->ring_size))
-		return 0;
-
-	netif_err(rx_ring->adapter, rx_err, rx_ring->netdev,
-		  "Invalid rx req_id: %hu\n", req_id);
-
-	u64_stats_update_begin(&rx_ring->syncp);
-	rx_ring->rx_stats.bad_req_id++;
-	u64_stats_update_end(&rx_ring->syncp);
-
-	/* Trigger device reset */
-	rx_ring->adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
-	set_bit(ENA_FLAG_TRIGGER_RESET, &rx_ring->adapter->flags);
-	return -EFAULT;
-}
-
 /* ena_setup_rx_resources - allocate I/O Rx resources (Descriptors)
  * @adapter: network interface device structure
  * @qid: queue index
@@ -1356,15 +1338,10 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	struct ena_rx_buffer *rx_info;
 	u16 len, req_id, buf = 0;
 	void *va;
-	int rc;
 
 	len = ena_bufs[buf].len;
 	req_id = ena_bufs[buf].req_id;
 
-	rc = validate_rx_req_id(rx_ring, req_id);
-	if (unlikely(rc < 0))
-		return NULL;
-
 	rx_info = &rx_ring->rx_buffer_info[req_id];
 
 	if (unlikely(!rx_info->page)) {
@@ -1440,10 +1417,6 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		len = ena_bufs[buf].len;
 		req_id = ena_bufs[buf].req_id;
 
-		rc = validate_rx_req_id(rx_ring, req_id);
-		if (unlikely(rc < 0))
-			return NULL;
-
 		rx_info = &rx_ring->rx_buffer_info[req_id];
 	} while (1);
 
@@ -1697,12 +1670,18 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 error:
 	adapter = netdev_priv(rx_ring->netdev);
 
-	u64_stats_update_begin(&rx_ring->syncp);
-	rx_ring->rx_stats.bad_desc_num++;
-	u64_stats_update_end(&rx_ring->syncp);
+	if (rc == -ENOSPC) {
+		u64_stats_update_begin(&rx_ring->syncp);
+		rx_ring->rx_stats.bad_desc_num++;
+		u64_stats_update_end(&rx_ring->syncp);
+		adapter->reset_reason = ENA_REGS_RESET_TOO_MANY_RX_DESCS;
+	} else {
+		u64_stats_update_begin(&rx_ring->syncp);
+		rx_ring->rx_stats.bad_req_id++;
+		u64_stats_update_end(&rx_ring->syncp);
+		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
+	}
 
-	/* Too many desc from the device. Trigger reset */
-	adapter->reset_reason = ENA_REGS_RESET_TOO_MANY_RX_DESCS;
 	set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 
 	return 0;
-- 
2.17.1

