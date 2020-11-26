Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315E72C5D7B
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387906AbgKZVVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:21:01 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:36819 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgKZVVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606425660; x=1637961660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=udjCjM0X9/5RgyUKE8rzA9Xxz2p5jcmIOH9OWm5eDCU=;
  b=E0oUX6+Qz/t8mI2nDtsL8J2iFeSpBcOVyw3uzX3mTodFnax9xWk1kmJ7
   lDrshKOqNYpX8SmZbqEoDN4KfEUXDPfLKj2zGM6dvY0KAr+mkXVR0m5Bv
   ZCHAZBhgx2cynTqiMRs7yqwTeVACmi4rMxEg8dikmknqN3a3ZzIn2Y3tW
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,373,1599523200"; 
   d="scan'208";a="99555507"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Nov 2020 21:20:59 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 13681A49B8;
        Thu, 26 Nov 2020 21:20:58 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:49 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:49 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.20) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 26 Nov 2020 21:20:46 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [RFC PATCH V2 net-next 7/9] net: ena: introduce XDP redirect implementation
Date:   Thu, 26 Nov 2020 23:20:15 +0200
Message-ID: <1606425617-13112-8-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
References: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This patch adds a partial support for the XDP_REDIRECT directive which
instructs the driver to pass the packet to an interface specified by the
program. The directive is passed to the driver by calling bpf_redirect()
or bpf_redirect_map() functions from the eBPF program.

To lay the ground for integration with the existing XDP TX
implementation the patch removes the redundant page ref count increase
in ena_xdp_xmit_frame() and then decrease in ena_clean_rx_irq(). Instead
it only DMA unmaps descriptors for which XDP TX or REDIRECT directive
was received.

The XDP Redirect support is still missing .ndo_xdp_xmit function
implementation, which allows to redirect packet to an ENA interface,
which would be added in a later patch.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 74 +++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  1 +
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 2ad44ae74cf6..d6cc7aa612b7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -95,6 +95,7 @@ static const struct ena_stats ena_stats_rx_strings[] = {
 	ENA_STAT_RX_ENTRY(xdp_pass),
 	ENA_STAT_RX_ENTRY(xdp_tx),
 	ENA_STAT_RX_ENTRY(xdp_invalid),
+	ENA_STAT_RX_ENTRY(xdp_redirect),
 };
 
 static const struct ena_stats ena_stats_ena_com_strings[] = {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 873964654a57..545b76004fd9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -289,21 +289,17 @@ static int ena_xdp_xmit_frame(struct net_device *dev,
 	struct ena_com_tx_ctx ena_tx_ctx = {};
 	struct ena_tx_buffer *tx_info;
 	struct ena_ring *xdp_ring;
-	struct page *rx_buff_page;
 	u16 next_to_use, req_id;
 	int rc;
 	void *push_hdr;
 	u32 push_len;
 
-	rx_buff_page = virt_to_page(xdpf->data);
-
 	xdp_ring = &adapter->tx_ring[qid];
 	next_to_use = xdp_ring->next_to_use;
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
-	page_ref_inc(rx_buff_page);
-	tx_info->xdp_rx_page = rx_buff_page;
+	tx_info->xdp_rx_page = virt_to_page(xdpf->data);
 
 	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
 	if (unlikely(rc))
@@ -335,7 +331,7 @@ static int ena_xdp_xmit_frame(struct net_device *dev,
 	ena_unmap_tx_buff(xdp_ring, tx_info);
 	tx_info->xdpf = NULL;
 error_drop_packet:
-	__free_page(tx_info->xdp_rx_page);
+	xdp_return_frame(xdpf);
 	return NETDEV_TX_OK;
 }
 
@@ -354,20 +350,28 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
 
-	if (verdict == XDP_TX) {
+	switch (verdict) {
+	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
 				   rx_ring->qid + rx_ring->adapter->num_io_queues);
-
 		xdp_stat = &rx_ring->rx_stats.xdp_tx;
-	} else if (unlikely(verdict == XDP_ABORTED)) {
+		break;
+	case XDP_REDIRECT:
+		xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		xdp_stat = &rx_ring->rx_stats.xdp_redirect;
+		break;
+	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-	} else if (unlikely(verdict == XDP_DROP)) {
+		break;
+	case XDP_DROP:
 		xdp_stat = &rx_ring->rx_stats.xdp_drop;
-	} else if (unlikely(verdict == XDP_PASS)) {
+		break;
+	case XDP_PASS:
 		xdp_stat = &rx_ring->rx_stats.xdp_pass;
-	} else {
+		break;
+	default:
 		bpf_warn_invalid_xdp_action(verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
 	}
@@ -953,11 +957,20 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	return 0;
 }
 
+static void ena_unmap_rx_buff(struct ena_ring *rx_ring,
+			      struct ena_rx_buffer *rx_info)
+{
+	struct ena_com_buf *ena_buf = &rx_info->ena_buf;
+
+	dma_unmap_page(rx_ring->dev, ena_buf->paddr - rx_ring->rx_headroom,
+		       ENA_PAGE_SIZE,
+		       DMA_BIDIRECTIONAL);
+}
+
 static void ena_free_rx_page(struct ena_ring *rx_ring,
 			     struct ena_rx_buffer *rx_info)
 {
 	struct page *page = rx_info->page;
-	struct ena_com_buf *ena_buf = &rx_info->ena_buf;
 
 	if (unlikely(!page)) {
 		netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
@@ -965,9 +978,7 @@ static void ena_free_rx_page(struct ena_ring *rx_ring,
 		return;
 	}
 
-	dma_unmap_page(rx_ring->dev, ena_buf->paddr - rx_ring->rx_headroom,
-		       ENA_PAGE_SIZE,
-		       DMA_BIDIRECTIONAL);
+	ena_unmap_rx_buff(rx_ring, rx_info);
 
 	__free_page(page);
 	rx_info->page = NULL;
@@ -1391,9 +1402,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		return NULL;
 
 	do {
-		dma_unmap_page(rx_ring->dev,
-			       dma_unmap_addr(&rx_info->ena_buf, paddr),
-			       ENA_PAGE_SIZE, DMA_BIDIRECTIONAL);
+		ena_unmap_rx_buff(rx_ring, rx_info);
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
 				rx_info->page_offset, len, ENA_PAGE_SIZE);
@@ -1551,6 +1560,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	struct sk_buff *skb;
 	int refill_required;
 	struct xdp_buff xdp;
+	int xdp_flags = 0;
 	int total_len = 0;
 	int xdp_verdict;
 	int rc = 0;
@@ -1598,22 +1608,25 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					 &next_to_clean);
 
 		if (unlikely(!skb)) {
-			/* The page might not actually be freed here since the
-			 * page reference count is incremented in
-			 * ena_xdp_xmit_frame(), and it will be decreased only
-			 * when send completion was received from the device
-			 */
-			if (xdp_verdict == XDP_TX)
-				ena_free_rx_page(rx_ring,
-						 &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id]);
 			for (i = 0; i < ena_rx_ctx.descs; i++) {
-				rx_ring->free_ids[next_to_clean] =
-					rx_ring->ena_bufs[i].req_id;
+				int req_id = rx_ring->ena_bufs[i].req_id;
+
+				rx_ring->free_ids[next_to_clean] = req_id;
 				next_to_clean =
 					ENA_RX_RING_IDX_NEXT(next_to_clean,
 							     rx_ring->ring_size);
+
+				/* Packets was passed for transmission, unmap it
+				 * from RX side.
+				 */
+				if (xdp_verdict == XDP_TX || xdp_verdict == XDP_REDIRECT) {
+					ena_unmap_rx_buff(rx_ring,
+							  &rx_ring->rx_buffer_info[req_id]);
+					rx_ring->rx_buffer_info[req_id].page = NULL;
+				}
 			}
 			if (xdp_verdict != XDP_PASS) {
+				xdp_flags |= xdp_verdict;
 				res_budget--;
 				continue;
 			}
@@ -1659,6 +1672,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		ena_refill_rx_bufs(rx_ring, refill_required);
 	}
 
+	if (xdp_flags & XDP_REDIRECT)
+		xdp_do_flush_map();
+
 	return work_done;
 
 error:
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index c39f41711c31..0fef876c23eb 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -239,6 +239,7 @@ struct ena_stats_rx {
 	u64 xdp_pass;
 	u64 xdp_tx;
 	u64 xdp_invalid;
+	u64 xdp_redirect;
 };
 
 struct ena_ring {
-- 
2.23.3

