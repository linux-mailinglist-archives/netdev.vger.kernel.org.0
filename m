Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E52439FCB9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhFHQpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:45:23 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:32422 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFHQpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:45:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623170609; x=1654706609;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IOYovHM7b0ckof5PuRDblrfv5foJlMZ9E/iWYhhMUZA=;
  b=SqtR30ZVGjLtmzNDujB+ShVNsk1Xm8I/Bz2z40n8CJRm1NMpNSXXQ6db
   vCvAeUJ/tGiz1bx1l50DkihA8+tYV1QS8A9TluWU4zNkEYHGryOTRfIeF
   V2k/iIkGTaBF1+y4WLd73NM8fSeRLpDnep3TNhGK2/gZfwBihgKsaRGLw
   Q=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="5550963"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 08 Jun 2021 16:43:22 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id A3E4EA184A;
        Tue,  8 Jun 2021 16:43:21 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.161.57) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:43:14 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [Patch v1 net] net: ena: fix DMA mapping function issues in XDP
Date:   Tue, 8 Jun 2021 19:42:54 +0300
Message-ID: <20210608164254.4081294-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.57]
X-ClientProxiedBy: EX13D10UWA003.ant.amazon.com (10.43.160.248) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes several bugs found when (DMA/LLQ) mapping a packet for
transmission. The mapping procedure makes the transmitted packet
accessible by the device.
When using LLQ, this requires copying the packet's header to push header
(which would be passed to LLQ) and creating DMA mapping for the payload
(if the packet doesn't fit the maximum push length).
When not using LLQ, we map the whole packet with DMA.

The following bugs are fixed in the code:
    1. Add support for non-LLQ machines:
       The ena_xdp_tx_map_frame() function assumed that LLQ is
       supported, and never mapped the whole packet using DMA. On some
       instances, which don't support LLQ, this causes loss of traffic.

    2. Wrong DMA buffer length passed to device:
       When using LLQ, the first 'tx_max_header_size' bytes of the
       packet would be copied to push header. The rest of the packet
       would be copied to a DMA'd buffer.

    3. Freeing the XDP buffer twice in case of a mapping error:
       In case a buffer DMA mapping fails, the function uses
       xdp_return_frame_rx_napi() to free the RX buffer and returns from
       the function with an error. XDP frames that fail to xmit get
       freed by the kernel and so there is no need for this call.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 54 ++++++++++----------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 881f88754bf6..52571486705e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -236,36 +236,48 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
 static int ena_xdp_tx_map_frame(struct ena_ring *xdp_ring,
 				struct ena_tx_buffer *tx_info,
 				struct xdp_frame *xdpf,
-				void **push_hdr,
-				u32 *push_len)
+				struct ena_com_tx_ctx *ena_tx_ctx)
 {
 	struct ena_adapter *adapter = xdp_ring->adapter;
 	struct ena_com_buf *ena_buf;
-	dma_addr_t dma = 0;
+	int push_len = 0;
+	dma_addr_t dma;
+	void *data;
 	u32 size;
 
 	tx_info->xdpf = xdpf;
+	data = tx_info->xdpf->data;
 	size = tx_info->xdpf->len;
-	ena_buf = tx_info->bufs;
 
-	/* llq push buffer */
-	*push_len = min_t(u32, size, xdp_ring->tx_max_header_size);
-	*push_hdr = tx_info->xdpf->data;
+	if (xdp_ring->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) {
+		/* Designate part of the packet for LLQ */
+		push_len = min_t(u32, size, xdp_ring->tx_max_header_size);
+
+		ena_tx_ctx->push_header = data;
+
+		size -= push_len;
+		data += push_len;
+	}
+
+	ena_tx_ctx->header_len = push_len;
 
-	if (size - *push_len > 0) {
+	if (size > 0) {
 		dma = dma_map_single(xdp_ring->dev,
-				     *push_hdr + *push_len,
-				     size - *push_len,
+				     data,
+				     size,
 				     DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(xdp_ring->dev, dma)))
 			goto error_report_dma_error;
 
-		tx_info->map_linear_data = 1;
-		tx_info->num_of_bufs = 1;
-	}
+		tx_info->map_linear_data = 0;
 
-	ena_buf->paddr = dma;
-	ena_buf->len = size;
+		ena_buf = tx_info->bufs;
+		ena_buf->paddr = dma;
+		ena_buf->len = size;
+
+		ena_tx_ctx->ena_bufs = ena_buf;
+		ena_tx_ctx->num_bufs = tx_info->num_of_bufs = 1;
+	}
 
 	return 0;
 
@@ -274,10 +286,6 @@ static int ena_xdp_tx_map_frame(struct ena_ring *xdp_ring,
 			  &xdp_ring->syncp);
 	netif_warn(adapter, tx_queued, adapter->netdev, "Failed to map xdp buff\n");
 
-	xdp_return_frame_rx_napi(tx_info->xdpf);
-	tx_info->xdpf = NULL;
-	tx_info->num_of_bufs = 0;
-
 	return -EINVAL;
 }
 
@@ -289,8 +297,6 @@ static int ena_xdp_xmit_frame(struct ena_ring *xdp_ring,
 	struct ena_com_tx_ctx ena_tx_ctx = {};
 	struct ena_tx_buffer *tx_info;
 	u16 next_to_use, req_id;
-	void *push_hdr;
-	u32 push_len;
 	int rc;
 
 	next_to_use = xdp_ring->next_to_use;
@@ -298,15 +304,11 @@ static int ena_xdp_xmit_frame(struct ena_ring *xdp_ring,
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
 
-	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
+	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &ena_tx_ctx);
 	if (unlikely(rc))
 		return rc;
 
-	ena_tx_ctx.ena_bufs = tx_info->bufs;
-	ena_tx_ctx.push_header = push_hdr;
-	ena_tx_ctx.num_bufs = tx_info->num_of_bufs;
 	ena_tx_ctx.req_id = req_id;
-	ena_tx_ctx.header_len = push_len;
 
 	rc = ena_xmit_common(dev,
 			     xdp_ring,
-- 
2.25.1

