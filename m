Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F13D2CC7D4
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgLBUcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:32:20 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:32248 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLBUcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606941139; x=1638477139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=F4oFME3h4fjlYXxiGgVtJpyl3RtsG1ktV5+8TFQwtqU=;
  b=ft9VPToUhoL41bP6VZY9nFJ5y0YoKO+8GDV2RjhykCxojJlZJ81Xw85q
   BK8Y8IwGKLfSA5N9SNTuKg2JBRGF339ohAqd7U2fqX6I61ZPJ1f5AOrOd
   LR2z8R5ifS8OTMLnt5KVg5JwzURue0EQpJ5JtTew0o29KGISuZgQb4HSz
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,387,1599523200"; 
   d="scan'208";a="66997064"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 02 Dec 2020 20:04:07 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 011BA100F47;
        Wed,  2 Dec 2020 20:04:06 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:04:05 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:04:04 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.23) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Dec 2020 20:04:02 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 8/9] net: ena: use xdp_return_frame() to free xdp frames
Date:   Wed, 2 Dec 2020 22:03:29 +0200
Message-ID: <1606939410-26718-9-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
References: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

XDP subsystem has a function to free XDP frames and their associated
pages. Using this function would help the driver's XDP implementation to
adjust to new changes in the XDP subsystem in the kernel (e.g.
introduction of XDP MB).

Also, remove 'xdp_rx_page' field from ena_tx_buffer struct since it is
no longer used.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 6 ------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 25e2e2369f45..0d077a626604 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -299,7 +299,6 @@ static int ena_xdp_xmit_frame(struct net_device *dev,
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
-	tx_info->xdp_rx_page = virt_to_page(xdpf->data);
 
 	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
 	if (unlikely(rc))
@@ -1828,7 +1827,7 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
 		tx_pkts++;
 		total_done += tx_info->tx_descs;
 
-		__free_page(tx_info->xdp_rx_page);
+		xdp_return_frame(xdpf);
 		xdp_ring->free_ids[next_to_clean] = req_id;
 		next_to_clean = ENA_TX_RING_IDX_NEXT(next_to_clean,
 						     xdp_ring->ring_size);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 0fef876c23eb..fed79c50a870 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -170,12 +170,6 @@ struct ena_tx_buffer {
 	 * the xdp queues
 	 */
 	struct xdp_frame *xdpf;
-	/* The rx page for the rx buffer that was received in rx and
-	 * re transmitted on xdp tx queues as a result of XDP_TX action.
-	 * We need to free the page once we finished cleaning the buffer in
-	 * clean_xdp_irq()
-	 */
-	struct page *xdp_rx_page;
 
 	/* Indicate if bufs[0] map the linear data of the skb. */
 	u8 map_linear_data;
-- 
2.23.3

