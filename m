Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2222CEDDA
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbgLDMMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:12:47 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11813 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387517AbgLDMMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607083964; x=1638619964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IzbtTzq2kCl9L2LKm3OGk75x5/lh16PkQpQlMfwGHyI=;
  b=lTn0JSaNm0q0oh/j4emJ3Q0FEem9otjDagcfQ/O2ALr82G3r24XNEIIB
   HsJRAzpzVUFrXxktWM5NNzTB2Mpx9LT16KgYUequEN9p5ujqZ21Djej4u
   JMFN0P0lvJ6gGAkdl/eyNb4l8bt0Vr0TpmBP/4COwKVg58N6AjGECrYe/
   M=;
X-IronPort-AV: E=Sophos;i="5.78,392,1599523200"; 
   d="scan'208";a="70566164"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Dec 2020 12:11:57 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 384A7A1C60;
        Fri,  4 Dec 2020 12:11:57 +0000 (UTC)
Received: from EX13D02UWC001.ant.amazon.com (10.43.162.243) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:52 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC001.ant.amazon.com (10.43.162.243) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:51 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.14) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 12:11:47 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V4 net-next 6/9] net: ena: use xdp_frame in XDP TX flow
Date:   Fri, 4 Dec 2020 14:11:12 +0200
Message-ID: <1607083875-32134-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Rename the ena_xdp_xmit_buff() function to ena_xdp_xmit_frame() and pass
it an xdp_frame struct instead of xdp_buff.
This change lays the ground for XDP redirect implementation which uses
xdp_frames when 'xmit'ing packets.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 46 ++++++++++----------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 222bb576e30e..cbb07548409a 100644
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
@@ -354,10 +355,9 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
 	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	if (verdict == XDP_TX) {
-		ena_xdp_xmit_buff(rx_ring->netdev,
-				  xdp,
-				  rx_ring->qid + rx_ring->adapter->num_io_queues,
-				  rx_info);
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
+				   rx_ring->qid + rx_ring->adapter->num_io_queues);
 
 		xdp_stat = &rx_ring->rx_stats.xdp_tx;
 	} else if (unlikely(verdict == XDP_ABORTED)) {
@@ -1521,7 +1521,7 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
 		return XDP_DROP;
 
-	ret = ena_xdp_execute(rx_ring, xdp, rx_info);
+	ret = ena_xdp_execute(rx_ring, xdp);
 
 	/* The xdp program might expand the headers */
 	if (ret == XDP_PASS) {
@@ -1600,7 +1600,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		if (unlikely(!skb)) {
 			/* The page might not actually be freed here since the
 			 * page reference count is incremented in
-			 * ena_xdp_xmit_buff(), and it will be decreased only
+			 * ena_xdp_xmit_frame(), and it will be decreased only
 			 * when send completion was received from the device
 			 */
 			if (xdp_verdict == XDP_TX)
-- 
2.23.3

