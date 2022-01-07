Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16D4487DAD
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiAGUYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:24:34 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:36179 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiAGUYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641587074; x=1673123074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TsUgh7mdCIp5w1dFdJZJiyAIBGGoE5ZJNvkLCnQPNB4=;
  b=rPWyibFAffF4/bbRHa9rCjvakX5Y9EwISOj9faV6d371lOpwLC3hopV+
   OumKm/juGE5+vop4dPY5eP9XNd+9qxFI7/bxsnrwA22XjUEf9ZpYGKvnp
   79uyAkpZHiVOD1J9e7UvrWSNzgcw8VEJe2m+JHWl6HhtMyidL0S5arlrF
   Q=;
X-IronPort-AV: E=Sophos;i="5.88,270,1635206400"; 
   d="scan'208";a="168602180"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 07 Jan 2022 20:24:23 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com (Postfix) with ESMTPS id 8BD2CC097D;
        Fri,  7 Jan 2022 20:24:22 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:15 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:15 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Fri, 7 Jan 2022 20:24:14 +0000
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
Subject: [PATCH V2 net-next 08/10] net: ena: Add debug prints for invalid req_id resets
Date:   Fri, 7 Jan 2022 20:23:44 +0000
Message-ID: <20220107202346.3522-9-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107202346.3522-1-akiyano@amazon.com>
References: <20220107202346.3522-1-akiyano@amazon.com>
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

