Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DB06A7276
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjCASAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCASA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:00:26 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367FE4A1C5
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 10:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677693626; x=1709229626;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cpj1lnXwVLhe5IVcEe8Q8xpkegHUsbBC5nIt5ukYDmM=;
  b=M9MuANZSXpybVSqZ5yD11grG2Z5DP1Y1faLwRfFpG1Ax0dYqnl3ZqoXN
   Qyv8G9ZNyxQvoQKxfO09hXMOUo9gvmJlRWXsTjE4EMciumZj08q+lyNan
   1k2Bu9pL+K8G4YjmAzfsjdZdk6sAZkgwhDTchfxVOQLH70tK1lJtOKVHK
   s=;
X-IronPort-AV: E=Sophos;i="5.98,225,1673913600"; 
   d="scan'208";a="266329580"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 18:00:20 +0000
Received: from EX19D016EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id EF16F614B8;
        Wed,  1 Mar 2023 18:00:17 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 1 Mar 2023 18:00:16 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 1 Mar 2023 18:00:08 +0000
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
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH RFC v1 net-next 3/5] net: ena: Recalculate TX state variables every device reset
Date:   Wed, 1 Mar 2023 19:59:14 +0200
Message-ID: <20230301175916.1819491-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230301175916.1819491-1-shayagr@amazon.com>
References: <20230301175916.1819491-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
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

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 830d5be22aa9..43e3c76bd6ae 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3662,8 +3662,9 @@ int ena_restore_device(struct ena_adapter *adapter)
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	struct pci_dev *pdev = adapter->pdev;
+	struct ena_ring *txr;
+	int rc, count, i;
 	bool wd_state;
-	int rc;
 
 	set_bit(ENA_FLAG_ONGOING_RESET, &adapter->flags);
 	rc = ena_device_init(adapter, adapter->pdev, &get_feat_ctx, &wd_state);
@@ -3673,6 +3674,13 @@ int ena_restore_device(struct ena_adapter *adapter)
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

