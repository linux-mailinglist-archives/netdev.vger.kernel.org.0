Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADDB2CEDDC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388034AbgLDMNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:13:04 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11813 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgLDMNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:13:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607083982; x=1638619982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=AL24PdxlkohyzPSsGCBZw0BYlnysJJJheqfByRbRO5A=;
  b=DKL5aCjVXRlF2k37xWtGRA1nKTnckEmTHYEHHOjVVJq7Urq2BC0n2cqq
   7Rbb3BgThaIdvHVw5jabfj14Vw4wMkmwnNb2HHI2ouTFjRT/nq8FnOPUb
   e1S043n33bnebWlFQYSFF+Kr2YeC5UULkq2wTSaslDrblZ2LXZHSCwo3c
   c=;
X-IronPort-AV: E=Sophos;i="5.78,392,1599523200"; 
   d="scan'208";a="70566176"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Dec 2020 12:12:02 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id CEC77A1789;
        Fri,  4 Dec 2020 12:12:01 +0000 (UTC)
Received: from EX13D02UWC004.ant.amazon.com (10.43.162.236) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:57 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC004.ant.amazon.com (10.43.162.236) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:56 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.14) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 12:11:52 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V4 net-next 7/9] net: ena: introduce XDP redirect implementation
Date:   Fri, 4 Dec 2020 14:11:13 +0200
Message-ID: <1607083875-32134-8-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
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
index cbb07548409a..25e2e2369f45 100644
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

