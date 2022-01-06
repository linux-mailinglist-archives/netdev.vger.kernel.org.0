Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8D486A85
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbiAFTaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:30:07 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:39927 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243346AbiAFTaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641497406; x=1673033406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TsUgh7mdCIp5w1dFdJZJiyAIBGGoE5ZJNvkLCnQPNB4=;
  b=OTioYSWSdD+LnIneJPay2RRsHYoFWayV15+EbPNEzY1BULLZ3L9aFLik
   OPlcJc7O/7G6ey7ZkZxDLyInBXjCcdGGAvB8SWbY6jtv16PNIdKWM7WtR
   tN8UpZkVuwwCREKQ8zI1QVByNISAri5LwgT++ddMmXN68Hm7eDN2bgvmf
   s=;
X-IronPort-AV: E=Sophos;i="5.88,267,1635206400"; 
   d="scan'208";a="168316239"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 06 Jan 2022 19:29:49 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com (Postfix) with ESMTPS id 50E28A2DD7;
        Thu,  6 Jan 2022 19:29:47 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:47 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:47 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Thu, 6 Jan 2022 19:29:44 +0000
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
Subject: [PATCH V1 net-next 08/10] net: ena: Add debug prints for invalid req_id resets
Date:   Thu, 6 Jan 2022 19:29:13 +0000
Message-ID: <20220106192915.22616-9-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106192915.22616-1-akiyano@amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qid and req_id to error prints when ENA_REGS_RESET_INV_TX_REQ_ID
reset occurs.

Switch from %hu to %u, since u16 should be printed with %u, as
explained in [1].

[1] - https://www.kernel.org/doc/html/latest/core-api/printk-formats.html

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 4ad0c602d76c..33e414dbf7a1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1269,14 +1269,14 @@ static int handle_invalid_req_id(struct ena_ring *ring, u16 req_id,
 		netif_err(ring->adapter,
 			  tx_done,
 			  ring->netdev,
-			  "tx_info doesn't have valid %s",
-			   is_xdp ? "xdp frame" : "skb");
+			  "tx_info doesn't have valid %s. qid %u req_id %u",
+			   is_xdp ? "xdp frame" : "skb", ring->qid, req_id);
 	else
 		netif_err(ring->adapter,
 			  tx_done,
 			  ring->netdev,
-			  "Invalid req_id: %hu\n",
-			  req_id);
+			  "Invalid req_id %u in qid %u\n",
+			  req_id, ring->qid);
 
 	ena_increase_stat(&ring->tx_stats.bad_req_id, 1, &ring->syncp);
 
-- 
2.32.0

