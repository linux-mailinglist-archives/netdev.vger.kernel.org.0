Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F6F187A2C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgCQHHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:07:34 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:44431 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgCQHHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584428854; x=1615964854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8P+B2VJM4OLmYm9gijh/amXrtVGsJEut1IzEUcf+1bg=;
  b=voiTk6cofuQc36XI2uVs9vDvw+Q0BsSu4KTP5kTyEcDfmUrgZQon9CIt
   GE8jWdvlhuuYknxBGIMJCadTiTCjuZHm78uV2DJcksvKC7H1jR8sMj1Ww
   7DN6ePeNaJVqnqHWqICyvAtry+tNNB+x1eRp3TgkMtzp/VdhU3d6fHRmr
   c=;
IronPort-SDR: LHfbGRxjhVFeinouJy1GkbEEe5/rVyrDYf2I+oZZ7MGdrfMMMVuS/ao+mTnhV+tf23/NoNcDr9
 x6bIzfGXgyPQ==
X-IronPort-AV: E=Sophos;i="5.70,563,1574121600"; 
   d="scan'208";a="21791261"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 17 Mar 2020 07:07:22 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 82204A26B0;
        Tue, 17 Mar 2020 07:07:21 +0000 (UTC)
Received: from EX13d09UWA002.ant.amazon.com (10.43.160.186) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Mar 2020 07:07:04 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA002.ant.amazon.com (10.43.160.186) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Mar 2020 07:07:03 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.76.85) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Mar 2020 07:06:59 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net 3/4] net: ena: avoid memory access violation by validating req_id properly
Date:   Tue, 17 Mar 2020 09:06:41 +0200
Message-ID: <1584428802-440-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584428802-440-1-git-send-email-akiyano@amazon.com>
References: <1584428802-440-1-git-send-email-akiyano@amazon.com>
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

