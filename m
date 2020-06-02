Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B101EBD00
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgFBNWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:22:01 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:3034 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgFBNV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591104118; x=1622640118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oDsDX0QdQSpfZ/Q/4sKlLkcixQqCcHNDp/ODQx0BpgQ=;
  b=vgAO+cVbS5AbFIDmhtPe6B9b30FAxcW13I0fNvtbhCLCwglWokzMN23R
   K5i+v3Yj3wTbCAv49svxiXVUw19wybAtfaqjMhrrdcbkD+PkL/dZ1LjGT
   gRGstHQjhP2LU+S4s6DAA+MPM5CmJR+kYg0vemjtcH4ub9dtTDrPsbb7e
   w=;
IronPort-SDR: uAPpbdT5xz9egBfu6d2X5+u9oafCnmOlsFtGTza3OgXfLyyXRpl2VgqqRdaRjLGqWqKhug11VD
 l1rPh7qWJahQ==
X-IronPort-AV: E=Sophos;i="5.73,464,1583193600"; 
   d="scan'208";a="49179651"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 02 Jun 2020 13:21:56 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 03D47A25FF;
        Tue,  2 Jun 2020 13:21:54 +0000 (UTC)
Received: from EX13d09UWA002.ant.amazon.com (10.43.160.186) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Jun 2020 13:21:54 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA002.ant.amazon.com (10.43.160.186) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Jun 2020 13:21:53 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 2 Jun 2020 13:21:53 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 228C481CF4; Tue,  2 Jun 2020 13:21:53 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 2/2] net: ena: xdp: update napi budget for DROP and ABORTED
Date:   Tue, 2 Jun 2020 13:21:51 +0000
Message-ID: <20200602132151.366-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200602132151.366-1-sameehj@amazon.com>
References: <20200602132151.366-1-sameehj@amazon.com>
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

Fixes: cad451dd2427 ("net: ena: Implement XDP_TX action")
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

