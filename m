Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02761ECBE1
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgFCIun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:50:43 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:46228 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgFCIum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 04:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591174240; x=1622710240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aWg2wHAsXXZWyrc0Q/DrGtgOnINn0Ktk67+M6MRF80Q=;
  b=LWDUPotz1E0Lcwwnq1GcSioZGj87doYRnLCUK9RVfX1KPsyT+nsQRbvM
   DawrZsUVJIM7M+hgqcilXrNhkqTsJ0tX13RdlfoYsxBOfJ2pG9fjqYerX
   SuZo2k3hTaAKfTBk9onqsw1FBZrmr1CIgETPTSURwzGs6ryilHwGlAv8t
   4=;
IronPort-SDR: Te5Q9Jau8wA90/kbZUz9we5ZiEoMazH7zh0S1vEjp6QnjTTFq5yp0xCY+q9tEe2/ZnsVrl40BQ
 qiBMDOEtueHQ==
X-IronPort-AV: E=Sophos;i="5.73,467,1583193600"; 
   d="scan'208";a="34214966"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Jun 2020 08:50:27 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 1E289A277B;
        Wed,  3 Jun 2020 08:50:27 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 08:50:26 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 08:50:26 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 3 Jun 2020 08:50:26 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 200D5816BD; Wed,  3 Jun 2020 08:50:26 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 2/2] net: ena: xdp: update napi budget for DROP and ABORTED
Date:   Wed, 3 Jun 2020 08:50:23 +0000
Message-ID: <20200603085023.24221-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200603085023.24221-1-sameehj@amazon.com>
References: <20200603085023.24221-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patch fixes two issues with XDP:

1. If the XDP verdict is XDP_ABORTED we break the loop, which results in
   us handling one buffer per napi cycle instead of the total budget
   (usually 64). To overcome this simply change the xdp_verdict check to
   != XDP_PASS. When the verdict is XDP_PASS, the skb is not expected to
   be NULL.

2. Update the residual budget for XDP_DROP and XDP_ABORTED, since
   packets are handled in these cases.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index ec115b753..2beccda7e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1638,11 +1638,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					 &next_to_clean);
 
 		if (unlikely(!skb)) {
-			if (xdp_verdict == XDP_TX) {
+			if (xdp_verdict == XDP_TX)
 				ena_free_rx_page(rx_ring,
 						 &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id]);
-				res_budget--;
-			}
 			for (i = 0; i < ena_rx_ctx.descs; i++) {
 				rx_ring->free_ids[next_to_clean] =
 					rx_ring->ena_bufs[i].req_id;
@@ -1650,8 +1648,10 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					ENA_RX_RING_IDX_NEXT(next_to_clean,
 							     rx_ring->ring_size);
 			}
-			if (xdp_verdict == XDP_TX || xdp_verdict == XDP_DROP)
+			if (xdp_verdict != XDP_PASS) {
+				res_budget--;
 				continue;
+			}
 			break;
 		}
 
-- 
2.24.1.AMZN

