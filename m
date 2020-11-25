Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F852C4B15
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgKYWwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:52:35 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:33080 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbgKYWwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:52:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606344754; x=1637880754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=JFtPsjSvFUbIlmncs6EGO0GzGCxV51fYZd49TaUBbEc=;
  b=kS9aM5lYtFBKdP4SjxvBugzL9qPYr5oh6Yjcf58XAsSSfadJmAdA7n+h
   /Ij+SWp69uSb84wGN0ly3N4eJQET2yeHgrzXamqLyyPnei/9UpzDyjdCa
   /s8ZmtaQOrQdpnRJgy7ptGNt5j0+vivCCbnxA9oYC0EzYHC2cbIaziKsZ
   0=;
X-IronPort-AV: E=Sophos;i="5.78,370,1599523200"; 
   d="scan'208";a="91017896"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 25 Nov 2020 22:52:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 43BFAA0451;
        Wed, 25 Nov 2020 22:52:31 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:25 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:25 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.33) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 25 Nov 2020 22:52:20 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 6/9] net: ena: use xdp_frame in XDP TX flow
Date:   Thu, 26 Nov 2020 00:51:45 +0200
Message-ID: <1606344708-11100-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
References: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
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
index 2b7ba2e24e3a..1b394ff42251 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -234,18 +234,18 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
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
 
@@ -282,29 +282,31 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
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
 
@@ -319,7 +321,7 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 			     tx_info,
 			     &ena_tx_ctx,
 			     next_to_use,
-			     xdp->data_end - xdp->data);
+			     xdpf->len);
 	if (rc)
 		goto error_unmap_dma;
 	/* trigger the dma engine. ena_com_write_sq_doorbell()
@@ -339,12 +341,11 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
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
@@ -356,10 +357,9 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
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
@@ -1523,7 +1523,7 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
 		return XDP_DROP;
 
-	ret = ena_xdp_execute(rx_ring, xdp, rx_info);
+	ret = ena_xdp_execute(rx_ring, xdp);
 
 	/* The xdp program might expand the headers */
 	if (ret == XDP_PASS) {
@@ -1602,7 +1602,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
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

