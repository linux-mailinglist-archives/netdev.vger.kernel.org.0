Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A473C2C4B19
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgKYWwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:52:42 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2238 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgKYWwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:52:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606344761; x=1637880761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=z63ow0fVny4wJc8yAoqfDfONKOqWoYZfDzMdCfGzRMw=;
  b=kAbsbHI7LKHEk3A2paHx2lDiiSYrDRqlLA2tIslAF8yx1UevGyJm8G5e
   ouTojbYPKkdOryEPPvphkMnf7IKGOPjte9EcbCY2Z4qGTLGenniM3s2HS
   pwNV9g+IIjEmLK+7tF42OCo8Jegur5+XaO927jQcRPnfOZL1S1mcuXkx2
   w=;
X-IronPort-AV: E=Sophos;i="5.78,370,1599523200"; 
   d="scan'208";a="99281314"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 Nov 2020 22:52:40 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 9C16AA2409;
        Wed, 25 Nov 2020 22:52:39 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:35 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:35 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.33) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 25 Nov 2020 22:52:30 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 8/9] net: ena: use xdp_return_frame() to free xdp frames
Date:   Thu, 26 Nov 2020 00:51:47 +0200
Message-ID: <1606344708-11100-9-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
References: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
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
index aac432a963ed..f110f9dbf955 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -300,7 +300,6 @@ static int ena_xdp_xmit_frame(struct net_device *dev,
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
-	tx_info->xdp_rx_page = virt_to_page(xdpf->data);
 
 	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
 	if (unlikely(rc))
@@ -1830,7 +1829,7 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
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

