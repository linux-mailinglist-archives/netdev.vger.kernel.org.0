Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8344E2D31B0
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgLHSFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:05:25 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:46750 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730921AbgLHSFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607450723; x=1638986723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eKtDvqTqsK8ibnqpnXMfA+ZkvTqroF1qaHZkbvJ0UVw=;
  b=QHxkHXPZKLSGVeqMyapZjkamummR1Cvj8HKwDPpg+zHZ0dykF414x+dj
   VoTJxaL8ZtLjFGoXgM8lT5u+K7V2f4ZMONik52EV+8VpD6OYOz9ajsewQ
   m8+LRRHsjhHOTLxqmehQyUU/yW3uX80d6q1/8wTwmah/TgZKQWoaoHweY
   g=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="69859862"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 08 Dec 2020 18:04:35 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id 23B4BA1819;
        Tue,  8 Dec 2020 18:04:35 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.144) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:04:24 +0000
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
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next v5 6/9] net: ena: use xdp_frame in XDP TX flow
Date:   Tue, 8 Dec 2020 20:02:05 +0200
Message-ID: <20201208180208.26111-7-shayagr@amazon.com>
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

Rename the ena_xdp_xmit_buff() function to ena_xdp_xmit_frame() and pass
it an xdp_frame struct instead of xdp_buff.
This change lays the ground for XDP redirect implementation which uses
xdp_frames when 'xmit'ing packets.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 53 +++++++++++---------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0c17e5b37fc4..48cbbd44d6c2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -233,18 +233,18 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
 	return ret;
 }
 
-static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
-			       struct ena_tx_buffer *tx_info,
-			       struct xdp_buff *xdp,
-			       void **push_hdr,
-			       u32 *push_len)
+static int ena_xdp_tx_map_frame(struct ena_ring *xdp_ring,
+				struct ena_tx_buffer *tx_info,
+				struct xdp_frame *xdpf,
+				void **push_hdr,
+				u32 *push_len)
 {
 	struct ena_adapter *adapter = xdp_ring->adapter;
 	struct ena_com_buf *ena_buf;
 	dma_addr_t dma = 0;
 	u32 size;
 
-	tx_info->xdpf = xdp_convert_buff_to_frame(xdp);
+	tx_info->xdpf = xdpf;
 	size = tx_info->xdpf->len;
 	ena_buf = tx_info->bufs;
 
@@ -281,29 +281,31 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
 	return -EINVAL;
 }
 
-static int ena_xdp_xmit_buff(struct net_device *dev,
-			     struct xdp_buff *xdp,
-			     int qid,
-			     struct ena_rx_buffer *rx_info)
+static int ena_xdp_xmit_frame(struct net_device *dev,
+			      struct xdp_frame *xdpf,
+			      int qid)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
 	struct ena_com_tx_ctx ena_tx_ctx = {};
 	struct ena_tx_buffer *tx_info;
 	struct ena_ring *xdp_ring;
+	struct page *rx_buff_page;
 	u16 next_to_use, req_id;
 	int rc;
 	void *push_hdr;
 	u32 push_len;
 
+	rx_buff_page = virt_to_page(xdpf->data);
+
 	xdp_ring = &adapter->tx_ring[qid];
 	next_to_use = xdp_ring->next_to_use;
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
-	page_ref_inc(rx_info->page);
-	tx_info->xdp_rx_page = rx_info->page;
+	page_ref_inc(rx_buff_page);
+	tx_info->xdp_rx_page = rx_buff_page;
 
-	rc = ena_xdp_tx_map_buff(xdp_ring, tx_info, xdp, &push_hdr, &push_len);
+	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
 	if (unlikely(rc))
 		goto error_drop_packet;
 
@@ -318,7 +320,7 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 			     tx_info,
 			     &ena_tx_ctx,
 			     next_to_use,
-			     xdp->data_end - xdp->data);
+			     xdpf->len);
 	if (rc)
 		goto error_unmap_dma;
 	/* trigger the dma engine. ena_com_write_sq_doorbell()
@@ -337,12 +339,11 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	return NETDEV_TX_OK;
 }
 
-static int ena_xdp_execute(struct ena_ring *rx_ring,
-			   struct xdp_buff *xdp,
-			   struct ena_rx_buffer *rx_info)
+static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 {
 	struct bpf_prog *xdp_prog;
 	u32 verdict = XDP_PASS;
+	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
 
 	rcu_read_lock();
@@ -354,12 +355,16 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
 	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	if (verdict == XDP_TX) {
-		ena_xdp_xmit_buff(rx_ring->netdev,
-				  xdp,
-				  rx_ring->qid + rx_ring->adapter->num_io_queues,
-				  rx_info);
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (unlikely(!xdpf)) {
+			trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
+			xdp_stat = &rx_ring->rx_stats.xdp_aborted;
+		} else {
+			ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
+					   rx_ring->qid + rx_ring->adapter->num_io_queues);
 
-		xdp_stat = &rx_ring->rx_stats.xdp_tx;
+			xdp_stat = &rx_ring->rx_stats.xdp_tx;
+		}
 	} else if (unlikely(verdict == XDP_ABORTED)) {
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
@@ -1521,7 +1526,7 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
 		return XDP_DROP;
 
-	ret = ena_xdp_execute(rx_ring, xdp, rx_info);
+	ret = ena_xdp_execute(rx_ring, xdp);
 
 	/* The xdp program might expand the headers */
 	if (ret == XDP_PASS) {
@@ -1600,7 +1605,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		if (unlikely(!skb)) {
 			/* The page might not actually be freed here since the
 			 * page reference count is incremented in
-			 * ena_xdp_xmit_buff(), and it will be decreased only
+			 * ena_xdp_xmit_frame(), and it will be decreased only
 			 * when send completion was received from the device
 			 */
 			if (xdp_verdict == XDP_TX)
-- 
2.17.1

