Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C342CEDE0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbgLDMNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:13:21 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11813 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388120AbgLDMNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607083999; x=1638619999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=02Bi8MBd1rNlKdikT93tk9POZ/gfefstn5txf86tMKs=;
  b=K96hszvEyso2w6k2GhB2JpGRyYXRfMOwN1fK1A/ljb30ZzlzxlyLRI4P
   vHgVXGDncS5O6g5woqjI15vGYv5IzvCpdrH+c/zZwZW+1YsbyOpi70Hd7
   MUL0M0Zcb6tgA7dYyrXPHCpxDCGxQwY8aTov1HGvxF+VHFjOJeV0bNRFy
   s=;
X-IronPort-AV: E=Sophos;i="5.78,392,1599523200"; 
   d="scan'208";a="70566205"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-76e0922c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Dec 2020 12:12:13 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with ESMTPS id BA007A64A3;
        Fri,  4 Dec 2020 12:12:12 +0000 (UTC)
Received: from EX13D02UWC003.ant.amazon.com (10.43.162.199) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:12:06 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC003.ant.amazon.com (10.43.162.199) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:12:05 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.14) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 12:12:01 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V4 net-next 9/9] net: ena: introduce ndo_xdp_xmit() function for XDP_REDIRECT
Date:   Fri, 4 Dec 2020 14:11:15 +0200
Message-ID: <1607083875-32134-10-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This patch implements the ndo_xdp_xmit() net_device function which is
called when a packet is redirected to this driver using an
XDP_REDIRECT directive.

The function receives an array of xdp frames that it needs to xmit.
The TX queues that are used to xmit these frames are the XDP
queues used by the XDP_TX flow. Therefore a lock is added to synchronize
both flows (XDP_TX and XDP_REDIRECT).

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 83 +++++++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  1 +
 2 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0d077a626604..6c5d8b8c4d13 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -281,20 +281,18 @@ static int ena_xdp_tx_map_frame(struct ena_ring *xdp_ring,
 	return -EINVAL;
 }
 
-static int ena_xdp_xmit_frame(struct net_device *dev,
+static int ena_xdp_xmit_frame(struct ena_ring *xdp_ring,
+			      struct net_device *dev,
 			      struct xdp_frame *xdpf,
-			      int qid)
+			      int flags)
 {
-	struct ena_adapter *adapter = netdev_priv(dev);
 	struct ena_com_tx_ctx ena_tx_ctx = {};
 	struct ena_tx_buffer *tx_info;
-	struct ena_ring *xdp_ring;
 	u16 next_to_use, req_id;
-	int rc;
 	void *push_hdr;
 	u32 push_len;
+	int rc;
 
-	xdp_ring = &adapter->tx_ring[qid];
 	next_to_use = xdp_ring->next_to_use;
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
@@ -321,25 +319,76 @@ static int ena_xdp_xmit_frame(struct net_device *dev,
 	/* trigger the dma engine. ena_com_write_sq_doorbell()
 	 * has a mb
 	 */
-	ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
-	ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1, &xdp_ring->syncp);
+	if (flags & XDP_XMIT_FLUSH) {
+		ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
+		ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1,
+				  &xdp_ring->syncp);
+	}
 
-	return NETDEV_TX_OK;
+	return rc;
 
 error_unmap_dma:
 	ena_unmap_tx_buff(xdp_ring, tx_info);
 	tx_info->xdpf = NULL;
 error_drop_packet:
 	xdp_return_frame(xdpf);
-	return NETDEV_TX_OK;
+	return rc;
+}
+
+static int ena_xdp_xmit(struct net_device *dev, int n,
+			struct xdp_frame **frames, u32 flags)
+{
+	struct ena_adapter *adapter = netdev_priv(dev);
+	int qid, i, err, drops = 0;
+	struct ena_ring *xdp_ring;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	if (!test_bit(ENA_FLAG_DEV_UP, &adapter->flags))
+		return -ENETDOWN;
+
+	/* We assume that all rings have the same XDP program */
+	if (!READ_ONCE(adapter->rx_ring->xdp_bpf_prog))
+		return -ENXIO;
+
+	qid = smp_processor_id() % adapter->xdp_num_queues;
+	qid += adapter->xdp_first_ring;
+	xdp_ring = &adapter->tx_ring[qid];
+
+	/* Other CPU ids might try to send thorugh this queue */
+	spin_lock(&xdp_ring->xdp_tx_lock);
+
+	for (i = 0; i < n; i++) {
+		err = ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 0);
+		/* The descriptor is freed by ena_xdp_xmit_frame in case
+		 * of an error.
+		 */
+		if (err)
+			drops++;
+	}
+
+	/* Ring doorbell to make device aware of the packets */
+	if (flags & XDP_XMIT_FLUSH) {
+		ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
+		ena_increase_stat(&xdp_ring->tx_stats.doorbells, 1,
+				  &xdp_ring->syncp);
+	}
+
+	spin_unlock(&xdp_ring->xdp_tx_lock);
+
+	/* Return number of packets sent */
+	return n - drops;
 }
 
 static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 {
 	struct bpf_prog *xdp_prog;
+	struct ena_ring *xdp_ring;
 	u32 verdict = XDP_PASS;
 	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
+	int qid;
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
@@ -352,8 +401,16 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	switch (verdict) {
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		ena_xdp_xmit_frame(rx_ring->netdev, xdpf,
-				   rx_ring->qid + rx_ring->adapter->num_io_queues);
+		/* Find xmit queue */
+		qid = rx_ring->qid + rx_ring->adapter->num_io_queues;
+		xdp_ring = &rx_ring->adapter->tx_ring[qid];
+
+		/* The XDP queues are shared between XDP_TX and XDP_REDIRECT */
+		spin_lock(&xdp_ring->xdp_tx_lock);
+
+		ena_xdp_xmit_frame(xdp_ring, rx_ring->netdev, xdpf, XDP_XMIT_FLUSH);
+
+		spin_unlock(&xdp_ring->xdp_tx_lock);
 		xdp_stat = &rx_ring->rx_stats.xdp_tx;
 		break;
 	case XDP_REDIRECT:
@@ -644,6 +701,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter,
 		txr->smoothed_interval =
 			ena_com_get_nonadaptive_moderation_interval_tx(ena_dev);
 		txr->disable_meta_caching = adapter->disable_meta_caching;
+		spin_lock_init(&txr->xdp_tx_lock);
 
 		/* Don't init RX queues for xdp queues */
 		if (!ENA_IS_XDP_INDEX(adapter, i)) {
@@ -3236,6 +3294,7 @@ static const struct net_device_ops ena_netdev_ops = {
 	.ndo_set_mac_address	= NULL,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_bpf		= ena_xdp,
+	.ndo_xdp_xmit		= ena_xdp_xmit,
 };
 
 static int ena_device_validate_params(struct ena_adapter *adapter,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index fed79c50a870..74af15d62ee1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -258,6 +258,7 @@ struct ena_ring {
 	struct ena_com_io_sq *ena_com_io_sq;
 	struct bpf_prog *xdp_bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
+	spinlock_t xdp_tx_lock;	/* synchronize XDP TX/Redirect traffic */
 
 	u16 next_to_use;
 	u16 next_to_clean;
-- 
2.23.3

