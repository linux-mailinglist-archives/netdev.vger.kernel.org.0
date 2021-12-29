Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF04813BC
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbhL2OAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:00:43 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:56611 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236725AbhL2OAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1640786442; x=1672322442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wXvK1RGw4DBzcIT/c36Gcijxx3QwweH7BS8ivJ90DFE=;
  b=M0rfcoPlwzOq5t7P6dKadfVqArgIFievtgvBudtZm1dU0GCmzsp7ncaI
   NjalDloQCz+LbVgJw6FN7wvYDQoTrYFV3RNOZSGwVBVNFnrmrkbP2caNd
   TwllH/nWsIY16me02tkQS/25eClQ2cGsF0GI6xeBmpnEOltL2E9mF7qCS
   U=;
X-IronPort-AV: E=Sophos;i="5.88,245,1635206400"; 
   d="scan'208";a="162035500"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 29 Dec 2021 14:00:31 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id D76E5C3B16;
        Wed, 29 Dec 2021 14:00:30 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 29 Dec 2021 14:00:30 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 29 Dec 2021 14:00:30 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Wed, 29 Dec 2021 14:00:28 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
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
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V1 net 1/3] net: ena: Fix undefined state when tx request id is out of bounds
Date:   Wed, 29 Dec 2021 14:00:19 +0000
Message-ID: <20211229140021.8053-2-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211229140021.8053-1-akiyano@amazon.com>
References: <20211229140021.8053-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ena_com_tx_comp_req_id_get() checks the req_id of a received completion,
and if it is out of bounds returns -EINVAL. This is a sign that
something is wrong with the device and it needs to be reset.

The current code does not reset the device in this case, which leaves
the driver in an undefined state, where this completion is not properly
handled.

This commit adds a call to handle_invalid_req_id() in ena_clean_tx_irq()
and ena_clean_xdp_irq() which resets the device to fix the issue.

This commit also removes unnecessary request id checks from
validate_tx_req_id() and validate_xdp_req_id(). This check is unneeded
because it was already performed in ena_com_tx_comp_req_id_get(), which
is called right before these functions.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 34 ++++++++++++--------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 7d5d885d85d5..2274063e34cc 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1288,26 +1288,22 @@ static int handle_invalid_req_id(struct ena_ring *ring, u16 req_id,
 
 static int validate_tx_req_id(struct ena_ring *tx_ring, u16 req_id)
 {
-	struct ena_tx_buffer *tx_info = NULL;
+	struct ena_tx_buffer *tx_info;
 
-	if (likely(req_id < tx_ring->ring_size)) {
-		tx_info = &tx_ring->tx_buffer_info[req_id];
-		if (likely(tx_info->skb))
-			return 0;
-	}
+	tx_info = &tx_ring->tx_buffer_info[req_id];
+	if (likely(tx_info->skb))
+		return 0;
 
 	return handle_invalid_req_id(tx_ring, req_id, tx_info, false);
 }
 
 static int validate_xdp_req_id(struct ena_ring *xdp_ring, u16 req_id)
 {
-	struct ena_tx_buffer *tx_info = NULL;
+	struct ena_tx_buffer *tx_info;
 
-	if (likely(req_id < xdp_ring->ring_size)) {
-		tx_info = &xdp_ring->tx_buffer_info[req_id];
-		if (likely(tx_info->xdpf))
-			return 0;
-	}
+	tx_info = &xdp_ring->tx_buffer_info[req_id];
+	if (likely(tx_info->xdpf))
+		return 0;
 
 	return handle_invalid_req_id(xdp_ring, req_id, tx_info, true);
 }
@@ -1332,9 +1328,14 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
 
 		rc = ena_com_tx_comp_req_id_get(tx_ring->ena_com_io_cq,
 						&req_id);
-		if (rc)
+		if (rc) {
+			if (unlikely(rc == -EINVAL))
+				handle_invalid_req_id(tx_ring, req_id, NULL,
+						      false);
 			break;
+		}
 
+		/* validate that the request id points to a valid skb */
 		rc = validate_tx_req_id(tx_ring, req_id);
 		if (rc)
 			break;
@@ -1896,9 +1897,14 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
 
 		rc = ena_com_tx_comp_req_id_get(xdp_ring->ena_com_io_cq,
 						&req_id);
-		if (rc)
+		if (rc) {
+			if (unlikely(rc == -EINVAL))
+				handle_invalid_req_id(xdp_ring, req_id, NULL,
+						      true);
 			break;
+		}
 
+		/* validate that the request id points to a valid xdp_frame */
 		rc = validate_xdp_req_id(xdp_ring, req_id);
 		if (rc)
 			break;
-- 
2.32.0

