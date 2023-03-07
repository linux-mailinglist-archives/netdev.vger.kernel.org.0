Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E896ADBD8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjCGK1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjCGK0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:26:51 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6139073032
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678184778; x=1709720778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9I9bk5/xMcc+LaSDF1LPR9bct/xXgqP9+q5kisBQESo=;
  b=LmilPdIdi/kbIky7rLgbiFzq4AmsTf+oyTw2a6XrbAaLyx7+eqKY+J9y
   LNgp7cabUMGR9P2LEVjuqMXgSVc2ACC3yYlDifjfo4EQFssm8YhGqThqZ
   /JQGG32X55Piz1FkzaRzbMyg54qbCREHdDCHk6Gn2evybTOBfvSyQwKoS
   s=;
X-IronPort-AV: E=Sophos;i="5.98,240,1673913600"; 
   d="scan'208";a="1110085494"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 10:26:12 +0000
Received: from EX19D003EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id CA34A8111E;
        Tue,  7 Mar 2023 10:26:10 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D003EUA001.ant.amazon.com (10.252.50.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:26:09 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:26:01 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
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
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH RFC v3 net-next 4/5] net: ena: Recalculate TX state variables every device reset
Date:   Tue, 7 Mar 2023 12:24:57 +0200
Message-ID: <20230307102458.2756297-5-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307102458.2756297-1-shayagr@amazon.com>
References: <20230307102458.2756297-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the ability to modify LLQ entry size, the size of packet's
payload that can be written directly to the device changes.
This patch makes the driver recalculate this information every device
negotiation (also called device reset).

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b97ecae439b2..537951ca4d61 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3750,8 +3750,9 @@ static int ena_restore_device(struct ena_adapter *adapter)
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	struct pci_dev *pdev = adapter->pdev;
+	struct ena_ring *txr;
+	int rc, count, i;
 	bool wd_state;
-	int rc;
 
 	set_bit(ENA_FLAG_ONGOING_RESET, &adapter->flags);
 	rc = ena_device_init(adapter, adapter->pdev, &get_feat_ctx, &wd_state);
@@ -3761,6 +3762,13 @@ static int ena_restore_device(struct ena_adapter *adapter)
 	}
 	adapter->wd_state = wd_state;
 
+	count =  adapter->xdp_num_queues + adapter->num_io_queues;
+	for (i = 0 ; i < count; i++) {
+		txr = &adapter->tx_ring[i];
+		txr->tx_mem_queue_type = ena_dev->tx_mem_queue_type;
+		txr->tx_max_header_size = ena_dev->tx_max_header_size;
+	}
+
 	rc = ena_device_validate_params(adapter, &get_feat_ctx);
 	if (rc) {
 		dev_err(&pdev->dev, "Validation of device parameters failed\n");
-- 
2.25.1

