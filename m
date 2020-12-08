Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09E62D31B1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgLHSFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:05:42 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:46750 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbgLHSFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607450741; x=1638986741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ssie3zDfE8sIjALIu1EqjgV6LQeozctX0vueyQRNyIY=;
  b=d5IsZq6CvB8NKl5FEqjm9PFKL0bbTLwuwDONu3G5LWrQ8OAImfQ6sO3s
   Q5snkBPo9Yvg7a71djmRHgWnNLdCb5GZl+WrCQ2UcJmc51TmR68go4Fr1
   gbxkco8etFgY2diy6f1ep+daVhOo48tzpXeIDiG6n/WtEe4FJtNVlswDP
   I=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="69860068"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 08 Dec 2020 18:05:25 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id C3DDBA1CD1;
        Tue,  8 Dec 2020 18:05:23 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.102) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:05:14 +0000
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
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next v5 8/9] net: ena: use xdp_return_frame() to free xdp frames
Date:   Tue, 8 Dec 2020 20:02:07 +0200
Message-ID: <20201208180208.26111-9-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208180208.26111-1-shayagr@amazon.com>
References: <20201208180208.26111-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D45UWA003.ant.amazon.com (10.43.160.92) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP subsystem has a function to free XDP frames and their associated
pages. Using this function would help the driver's XDP implementation to
adjust to new changes in the XDP subsystem in the kernel (e.g.
introduction of XDP MB).

Also, remove 'xdp_rx_page' field from ena_tx_buffer struct since it is
no longer used.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 6 ------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d47814b16834..a4dc794e7389 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -299,7 +299,6 @@ static int ena_xdp_xmit_frame(struct net_device *dev,
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
-	tx_info->xdp_rx_page = virt_to_page(xdpf->data);
 
 	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
 	if (unlikely(rc))
@@ -1836,7 +1835,7 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
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
2.17.1

