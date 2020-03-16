Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54577186B35
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgCPMjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:39:25 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8928 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731058AbgCPMjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584362364; x=1615898364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8P+B2VJM4OLmYm9gijh/amXrtVGsJEut1IzEUcf+1bg=;
  b=pn9cd6ZQY+VvMo3ZUPeYjgbPi2TLuh67auhQsHWACCqy7FulQJfWOj0y
   oyL2DKOAYxuPiaWteA5VhPh6w7uveenm2OJF1dsImZvgpMNhCKOZhx+qT
   2blxrSPBFH3kEA0PTEFbHLvQvB1xjXZw6jWudxIvS4bBWUqaVybotKbv1
   U=;
IronPort-SDR: 0GLpWDykNPooVa44GIbIc0rUesjhxkx1EopaI2rLAGFBbipVkuNqdvDC59EV0DExQ7On3i3m5P
 fC5QQLPGStlw==
X-IronPort-AV: E=Sophos;i="5.70,560,1574121600"; 
   d="scan'208";a="21214151"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 16 Mar 2020 12:39:23 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 88348C1279;
        Mon, 16 Mar 2020 12:39:22 +0000 (UTC)
Received: from EX13D21UWA002.ant.amazon.com (10.43.160.246) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Mar 2020 12:39:03 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA002.ant.amazon.com (10.43.160.246) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 16 Mar 2020 12:39:02 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.27) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Mar 2020 12:38:58 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net 6/7] net: ena: avoid memory access violation by validating req_id properly
Date:   Mon, 16 Mar 2020 14:38:23 +0200
Message-ID: <1584362304-274-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584362304-274-1-git-send-email-akiyano@amazon.com>
References: <1584362304-274-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Rx req_id is an index in struct ena_eth_io_rx_cdesc_base.
The driver should validate that the Rx req_id it received from
the device is in range [0, ring_size -1].  Failure to do so could
yield to potential memory access violoation.
The validation was mistakenly done when refilling
the Rx submission queue and not in Rx completion queue.

Fixes: ad974baef2a1 ("net: ena: add support for out of order rx buffers refill")
Signed-off-by: Noam Dagan <ndagan@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 836fda585391..51333a05c14d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1018,13 +1018,9 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 		struct ena_rx_buffer *rx_info;
 
 		req_id = rx_ring->free_ids[next_to_use];
-		rc = validate_rx_req_id(rx_ring, req_id);
-		if (unlikely(rc < 0))
-			break;
 
 		rx_info = &rx_ring->rx_buffer_info[req_id];
 
-
 		rc = ena_alloc_rx_page(rx_ring, rx_info,
 				       GFP_ATOMIC | __GFP_COMP);
 		if (unlikely(rc < 0)) {
@@ -1379,9 +1375,15 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	struct ena_rx_buffer *rx_info;
 	u16 len, req_id, buf = 0;
 	void *va;
+	int rc;
 
 	len = ena_bufs[buf].len;
 	req_id = ena_bufs[buf].req_id;
+
+	rc = validate_rx_req_id(rx_ring, req_id);
+	if (unlikely(rc < 0))
+		return NULL;
+
 	rx_info = &rx_ring->rx_buffer_info[req_id];
 
 	if (unlikely(!rx_info->page)) {
@@ -1454,6 +1456,11 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		buf++;
 		len = ena_bufs[buf].len;
 		req_id = ena_bufs[buf].req_id;
+
+		rc = validate_rx_req_id(rx_ring, req_id);
+		if (unlikely(rc < 0))
+			return NULL;
+
 		rx_info = &rx_ring->rx_buffer_info[req_id];
 	} while (1);
 
-- 
2.17.1

