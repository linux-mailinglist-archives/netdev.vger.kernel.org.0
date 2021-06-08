Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AF139FB9E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhFHQEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:04:48 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:6185 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhFHQEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168175; x=1654704175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wTGYgzjfDfg94AQRif07U8TjwlxZznw/FsFILxQJAKc=;
  b=hB0EsurvRyWUp79mWCbUlLw2bjiVrOgx2V4x4n03/2QilOZ5McWKtDCQ
   lmx3eNzWqTRn7sEHoDdr7SM7Zgi0ZG5TjBUTVgWGzzbKoNVG9zilUohJR
   7Tvbkz4Pi6Yvpo14yLGY75y/PGuMfMP8pG3lsPk/DZnH4du/sOHRbrmD5
   Q=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="112932437"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 08 Jun 2021 16:02:47 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 90726120086;
        Tue,  8 Jun 2021 16:02:46 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.160.137) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:02:38 +0000
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
Subject: [Patch v1 net-next 04/10] net: ena: use build_skb() in RX path
Date:   Tue, 8 Jun 2021 19:01:12 +0300
Message-ID: <20210608160118.3767932-5-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the RX path to use build_skb() for packets larger
than copybreak (set to 256 by default). This function makes the first
descriptor's page to be the linear part of the sk_buff struct buffer.

Also remove the SKB description from the README since most of it no
longer relevant and the parts that are left don't add information.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 66 ++++++++++++--------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b613067a06d8..d7bc4f45e5df 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -529,7 +529,7 @@ static void ena_xdp_exchange_program_rx_in_range(struct ena_adapter *adapter,
 			rx_ring->rx_headroom = XDP_PACKET_HEADROOM;
 		} else {
 			ena_xdp_unregister_rxq_info(rx_ring);
-			rx_ring->rx_headroom = 0;
+			rx_ring->rx_headroom = NET_SKB_PAD;
 		}
 	}
 }
@@ -720,6 +720,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter,
 			rxr->smoothed_interval =
 				ena_com_get_nonadaptive_moderation_interval_rx(ena_dev);
 			rxr->empty_rx_queue = 0;
+			rxr->rx_headroom = NET_SKB_PAD;
 			adapter->ena_napi[i].dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 			rxr->xdp_ring = &adapter->tx_ring[i + adapter->num_io_queues];
 		}
@@ -982,6 +983,7 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	struct ena_com_buf *ena_buf;
 	struct page *page;
 	dma_addr_t dma;
+	int tailroom;
 
 	/* restore page offset value in case it has been changed by device */
 	rx_info->page_offset = headroom;
@@ -1012,10 +1014,12 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 		  "Allocate page %p, rx_info %p\n", page, rx_info);
 
+	tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	rx_info->page = page;
 	ena_buf = &rx_info->ena_buf;
 	ena_buf->paddr = dma + headroom;
-	ena_buf->len = ENA_PAGE_SIZE - headroom;
+	ena_buf->len = ENA_PAGE_SIZE - headroom - tailroom;
 
 	return 0;
 }
@@ -1381,21 +1385,23 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
 	return tx_pkts;
 }
 
-static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, bool frags)
+static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
 {
 	struct sk_buff *skb;
 
-	if (frags)
-		skb = napi_get_frags(rx_ring->napi);
-	else
+	if (!first_frag)
 		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
 						rx_ring->rx_copybreak);
+	else
+		skb = build_skb(first_frag, ENA_PAGE_SIZE);
 
 	if (unlikely(!skb)) {
 		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 1,
 				  &rx_ring->syncp);
+
 		netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
-			  "Failed to allocate skb. frags: %d\n", frags);
+			  "Failed to allocate skb. first_frag %s\n",
+			  first_frag ? "provided" : "not provided");
 		return NULL;
 	}
 
@@ -1410,7 +1416,9 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	struct sk_buff *skb;
 	struct ena_rx_buffer *rx_info;
 	u16 len, req_id, buf = 0;
-	void *va;
+	void *page_addr;
+	u32 page_offset;
+	void *data_addr;
 
 	len = ena_bufs[buf].len;
 	req_id = ena_bufs[buf].req_id;
@@ -1428,12 +1436,14 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		  rx_info, rx_info->page);
 
 	/* save virt address of first buffer */
-	va = page_address(rx_info->page) + rx_info->page_offset;
+	page_addr = page_address(rx_info->page);
+	page_offset = rx_info->page_offset;
+	data_addr = page_addr + page_offset;
 
-	prefetch(va);
+	prefetch(data_addr);
 
 	if (len <= rx_ring->rx_copybreak) {
-		skb = ena_alloc_skb(rx_ring, false);
+		skb = ena_alloc_skb(rx_ring, NULL);
 		if (unlikely(!skb))
 			return NULL;
 
@@ -1446,7 +1456,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 					dma_unmap_addr(&rx_info->ena_buf, paddr),
 					len,
 					DMA_FROM_DEVICE);
-		skb_copy_to_linear_data(skb, va, len);
+		skb_copy_to_linear_data(skb, data_addr, len);
 		dma_sync_single_for_device(rx_ring->dev,
 					   dma_unmap_addr(&rx_info->ena_buf, paddr),
 					   len,
@@ -1460,16 +1470,18 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		return skb;
 	}
 
-	skb = ena_alloc_skb(rx_ring, true);
+	ena_unmap_rx_buff(rx_ring, rx_info);
+
+	skb = ena_alloc_skb(rx_ring, page_addr);
 	if (unlikely(!skb))
 		return NULL;
 
-	do {
-		ena_unmap_rx_buff(rx_ring, rx_info);
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
-				rx_info->page_offset, len, ENA_PAGE_SIZE);
+	/* Populate skb's linear part */
+	skb_reserve(skb, page_offset);
+	skb_put(skb, len);
+	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 
+	do {
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "RX skb updated. len %d. data_len %d\n",
 			  skb->len, skb->data_len);
@@ -1488,6 +1500,12 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		req_id = ena_bufs[buf].req_id;
 
 		rx_info = &rx_ring->rx_buffer_info[req_id];
+
+		ena_unmap_rx_buff(rx_ring, rx_info);
+
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
+				rx_info->page_offset, len, ENA_PAGE_SIZE);
+
 	} while (1);
 
 	return skb;
@@ -1700,14 +1718,12 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
 		skb_record_rx_queue(skb, rx_ring->qid);
 
-		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak) {
-			total_len += rx_ring->ena_bufs[0].len;
+		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak)
 			rx_copybreak_pkt++;
-			napi_gro_receive(napi, skb);
-		} else {
-			total_len += skb->len;
-			napi_gro_frags(napi);
-		}
+
+		total_len += skb->len;
+
+		napi_gro_receive(napi, skb);
 
 		res_budget--;
 	} while (likely(res_budget));
-- 
2.25.1

