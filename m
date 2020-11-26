Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2E82C5D79
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbgKZVU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:20:57 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:52491 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387781AbgKZVU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606425656; x=1637961656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=0Gs1uWeXJOpzPlOvZxS0bAwzyonTfQLHT9AmWSBQHVM=;
  b=g0bzeNTBT3Z0b25xstsLHdjcKaZq0Dtz+mtnCU3BAvoS1OfYvxPNcW+0
   BWTC+HE2/TMLyNyHknPnVnHdhNi9HD/MkdCL4EAKmtYxN+e/MFrS8YlgI
   qNJCFvVdiUOwHMq4yBAqsJBZvqhNWywgW9ic2yD8xLmikEE0OODNFyHpH
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,373,1599523200"; 
   d="scan'208";a="66001640"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 26 Nov 2020 21:20:56 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 7B27DA21A6;
        Thu, 26 Nov 2020 21:20:54 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:52 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:52 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.20) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 26 Nov 2020 21:20:49 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [RFC PATCH V2 net-next 8/9] net: ena: use xdp_return_frame() to free xdp frames
Date:   Thu, 26 Nov 2020 23:20:16 +0200
Message-ID: <1606425617-13112-9-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
References: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
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
index 545b76004fd9..6c8767dce400 100644
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

