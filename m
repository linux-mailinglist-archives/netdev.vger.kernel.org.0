Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696882D31B2
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgLHSFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:05:45 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:41709 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbgLHSFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:05:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607450743; x=1638986743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/EMqN0sL0Z2X40wdzZby4vk2uH951T07JgeugkMLpHk=;
  b=m3wj61j9okH1bLnJ8LpMINt29b6bS9ebVOTFNc4GuY8HhLBmtP6VrOmr
   SE0jykr4k7510YCdMCTl06pNExa5IeL2GuLnddkmDuum3ImFeV21R48+S
   taCaYfcaCfN1+dHSvSbx21N/Qm/hCLCScXnyfyJGCQJJ3nNW7qNvrTogE
   A=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="901490713"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 08 Dec 2020 18:04:49 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 9BBBBA180D;
        Tue,  8 Dec 2020 18:04:48 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.144) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:04:38 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        David Woodhouse <dwmw@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Bshara Saeed <saeedb@amazon.com>, Matt Wilson <msw@amazon.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Nafea Bshara <nafea@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Netanel Belgazal <netanel@amazon.com>,
        Ali Saidi <alisaidi@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Samih Jubran <sameehj@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next v5 7/9] net: ena: introduce XDP redirect implementation
Date:   Tue, 8 Dec 2020 20:02:06 +0200
Message-ID: <20201208180208.26111-8-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208180208.26111-1-shayagr@amazon.com>
References: <20201208180208.26111-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 83 ++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  1 +
 3 files changed, 53 insertions(+), 32 deletions(-)

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
index 48cbbd44d6c2..d47814b16834 100644
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
 
@@ -354,25 +350,36 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
 
-	if (verdict == XDP_TX) {
+	switch (verdict) {
+	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf)) {
 			trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 			xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-		} else {
-			ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
-					   rx_ring->qid + rx_ring->adapter->num_io_queues);
+			break;
+		}
 
-			xdp_stat = &rx_ring->rx_stats.xdp_tx;
+		ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
+				   rx_ring->qid + rx_ring->adapter->num_io_queues);
+		xdp_stat = &rx_ring->rx_stats.xdp_tx;
+		break;
+	case XDP_REDIRECT:
+		if (likely(!xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog))) {
+			xdp_stat = &rx_ring->rx_stats.xdp_redirect;
+			break;
 		}
-	} else if (unlikely(verdict == XDP_ABORTED)) {
+		fallthrough;
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
@@ -958,11 +965,20 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
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
@@ -970,9 +986,7 @@ static void ena_free_rx_page(struct ena_ring *rx_ring,
 		return;
 	}
 
-	dma_unmap_page(rx_ring->dev, ena_buf->paddr - rx_ring->rx_headroom,
-		       ENA_PAGE_SIZE,
-		       DMA_BIDIRECTIONAL);
+	ena_unmap_rx_buff(rx_ring, rx_info);
 
 	__free_page(page);
 	rx_info->page = NULL;
@@ -1396,9 +1410,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		return NULL;
 
 	do {
-		dma_unmap_page(rx_ring->dev,
-			       dma_unmap_addr(&rx_info->ena_buf, paddr),
-			       ENA_PAGE_SIZE, DMA_BIDIRECTIONAL);
+		ena_unmap_rx_buff(rx_ring, rx_info);
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
 				rx_info->page_offset, len, ENA_PAGE_SIZE);
@@ -1556,6 +1568,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	struct sk_buff *skb;
 	int refill_required;
 	struct xdp_buff xdp;
+	int xdp_flags = 0;
 	int total_len = 0;
 	int xdp_verdict;
 	int rc = 0;
@@ -1603,22 +1616,25 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
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
@@ -1664,6 +1680,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
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
2.17.1

