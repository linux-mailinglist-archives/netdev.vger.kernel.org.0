Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD672C1437
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbgKWTKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:10:17 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:33415 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgKWTKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606158616; x=1637694616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iXPdFDva951uSfAcZKMNrRL9l8uIGHcBjq96yboLltM=;
  b=Bs79CklGtyI4Qt90pYkyPueYzizVaB9oYTVrAFComGe/VpTAQkgrviid
   PBPp+LI8Z2RhgX+JzsgZwzXx0ZuzMxkl1YGF+nKdXDLwpzZPAYXzmrTMV
   XjRYNcI6tuFp1Pr6MD6KgDn9ApfJGWp4k4oaKimAd1ITiSMeTCAHDrjPx
   U=;
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="65638594"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Nov 2020 19:10:16 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 11A2AA230E;
        Mon, 23 Nov 2020 19:10:15 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Nov 2020 19:10:05 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V3 net 3/3] net: ena: fix packet's addresses for rx_offset feature
Date:   Mon, 23 Nov 2020 21:08:59 +0200
Message-ID: <20201123190859.21298-4-shayagr@amazon.com>
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

This patch fixes two lines in which the rx_offset received by the device
wasn't taken into account:

- prefetch function:
	In our driver the copied data would reside in
	rx_info->page + rx_headroom + rx_offset

	so the prefetch function is changed accordingly.

- setting page_offset to zero for descriptors > 1:
	for every descriptor but the first, the rx_offset is zero. Hence
	the page_offset value should be set to rx_headroom.

	The previous implementation changed the value of rx_info after
	the descriptor was added to the SKB (essentially providing wrong
	page offset).

Fixes: 68f236df93a9 ("net: ena: add support for the rx offset feature")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index ec0008ba7751..df1884d57d1a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -908,10 +908,14 @@ static void ena_free_all_io_rx_resources(struct ena_adapter *adapter)
 static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 				    struct ena_rx_buffer *rx_info, gfp_t gfp)
 {
+	int headroom = rx_ring->rx_headroom;
 	struct ena_com_buf *ena_buf;
 	struct page *page;
 	dma_addr_t dma;
 
+	/* restore page offset value in case it has been changed by device */
+	rx_info->page_offset = headroom;
+
 	/* if previous allocated page is not used */
 	if (unlikely(rx_info->page))
 		return 0;
@@ -941,10 +945,9 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 		  "Allocate page %p, rx_info %p\n", page, rx_info);
 
 	rx_info->page = page;
-	rx_info->page_offset = 0;
 	ena_buf = &rx_info->ena_buf;
-	ena_buf->paddr = dma + rx_ring->rx_headroom;
-	ena_buf->len = ENA_PAGE_SIZE - rx_ring->rx_headroom;
+	ena_buf->paddr = dma + headroom;
+	ena_buf->len = ENA_PAGE_SIZE - headroom;
 
 	return 0;
 }
@@ -1356,7 +1359,8 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 	/* save virt address of first buffer */
 	va = page_address(rx_info->page) + rx_info->page_offset;
-	prefetch(va + NET_IP_ALIGN);
+
+	prefetch(va);
 
 	if (len <= rx_ring->rx_copybreak) {
 		skb = ena_alloc_skb(rx_ring, false);
@@ -1397,8 +1401,6 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
 				rx_info->page_offset, len, ENA_PAGE_SIZE);
-		/* The offset is non zero only for the first buffer */
-		rx_info->page_offset = 0;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "RX skb updated. len %d. data_len %d\n",
@@ -1517,8 +1519,7 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	int ret;
 
 	rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
-	xdp->data = page_address(rx_info->page) +
-		rx_info->page_offset + rx_ring->rx_headroom;
+	xdp->data = page_address(rx_info->page) + rx_info->page_offset;
 	xdp_set_data_meta_invalid(xdp);
 	xdp->data_hard_start = page_address(rx_info->page);
 	xdp->data_end = xdp->data + rx_ring->ena_bufs[0].len;
@@ -1585,8 +1586,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		if (unlikely(ena_rx_ctx.descs == 0))
 			break;
 
+		/* First descriptor might have an offset set by the device */
 		rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
-		rx_info->page_offset = ena_rx_ctx.pkt_offset;
+		rx_info->page_offset += ena_rx_ctx.pkt_offset;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "rx_poll: q %d got packet from ena. descs #: %d l3 proto %d l4 proto %d hash: %x\n",
-- 
2.17.1

