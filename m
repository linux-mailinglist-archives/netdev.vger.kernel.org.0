Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40436C6DF6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjCWQnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjCWQnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:43:00 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CA961AE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679589639; x=1711125639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rWIIOHVIRSiU24PN0w9KUXSgJFiivZhY3hmuzDnzuL0=;
  b=SjRh1yHNd6sNG24A7ne6h/vwkC83oFapwgQ8eSAX0dU5m65B2yDBaO8Z
   ymkFjy95hdxJvHvoQq/LRMmncc0IRrdgIJf3tqkFN9hYL2rmU+14bSOvJ
   vqlRE7AjfmIafMdviYROQnDLqVDK6c36r6hFFKrnfFVysVk2Za4NLDWke
   k=;
X-IronPort-AV: E=Sophos;i="5.98,285,1673913600"; 
   d="scan'208";a="196781004"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 16:38:20 +0000
Received: from EX19D009EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id BCF3BA0D18;
        Thu, 23 Mar 2023 16:38:18 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D009EUA004.ant.amazon.com (10.252.50.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 23 Mar 2023 16:38:17 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.177) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 16:38:06 +0000
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
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Jie Wang" <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        "Michal Kubiak" <michal.kubiak@intel.com>
Subject: [PATCH v7 net-next 5/7] net: ena: Recalculate TX state variables every device reset
Date:   Thu, 23 Mar 2023 18:36:08 +0200
Message-ID: <20230323163610.1281468-6-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230323163610.1281468-1-shayagr@amazon.com>
References: <20230323163610.1281468-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.177]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the ability to modify LLQ entry size, the size of packet's
payload that can be written directly to the device changes.
This patch makes the driver recalculate this information every device
negotiation (also called device reset).

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 97da4d841df3..ed5b019d27ea 100644
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

