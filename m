Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A516589F2
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 08:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiL2HbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 02:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiL2Haw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 02:30:52 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BFE12AC6
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 23:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672299049; x=1703835049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Soa3Uobxz04Yn+7yXMtyxoQhFWF50D2p6izrNeCG/0c=;
  b=QEcbK5wjKm484QXa2eZ6rO2tNNdA4RkUA+aB/5FxOx0VF+YybwifOCu/
   Py8dX4miA3Wu44KVl9tretwsUUJT9eO7dowYoUqo3GMO/AjRrQ1Z/OeH8
   7mhJKHtvv1C6xgDeNkWQSZSssS4eaaiAx2rovGvO7qV8gk8ChozwKA+Xt
   Y=;
X-IronPort-AV: E=Sophos;i="5.96,283,1665446400"; 
   d="scan'208";a="166074782"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 07:30:47 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com (Postfix) with ESMTPS id 0D90041F85;
        Thu, 29 Dec 2022 07:30:46 +0000 (UTC)
Received: from EX19D002UWA003.ant.amazon.com (10.13.138.235) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 29 Dec 2022 07:30:40 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWA003.ant.amazon.com (10.13.138.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 29 Dec 2022 07:30:40 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 29 Dec 2022 07:30:38
 +0000
From:   <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net 6/7] net: ena: Set default value for RX interrupt moderation
Date:   Thu, 29 Dec 2022 07:30:10 +0000
Message-ID: <20221229073011.19687-7-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221229073011.19687-1-darinzon@amazon.com>
References: <20221229073011.19687-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

RX ring can be NULL in XDP use cases where only TX queues
are configured. In this scenario, the RX interrupt moderation
value sent to the device remains in its default value of 0.

In this change, setting the default value of the RX interrupt
moderation to be the same as of the TX.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 80a726932e81..99f80c2d560a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1823,8 +1823,9 @@ static void ena_adjust_adaptive_rx_intr_moderation(struct ena_napi *ena_napi)
 static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
+	u32 rx_interval = tx_ring->smoothed_interval;
 	struct ena_eth_io_intr_reg intr_reg;
-	u32 rx_interval = 0;
+
 	/* Rx ring can be NULL when for XDP tx queues which don't have an
 	 * accompanying rx_ring pair.
 	 */
-- 
2.38.1

