Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1366589F4
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 08:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiL2HbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 02:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiL2Hay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 02:30:54 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4BD12D26
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 23:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672299053; x=1703835053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PpgSzexvPtSHThDnk/gGCLWgBspgLm32FPG7W9oZ3VA=;
  b=unTdIFbsIaVV0bfhNji1TnlWQh0aRz1TC1MKiANU7hTK0abG7UHiqo+H
   IefqZvqJMydWdQjqKyD4At21ucZAtVJKuDTOCsKbht5Vu+KN0cvLdz+qs
   GKLGDwI97oPW+jULH15s786dBkS7jjBIhaBvFW7dumoHTnUBEUs0eH1dI
   4=;
X-IronPort-AV: E=Sophos;i="5.96,283,1665446400"; 
   d="scan'208";a="166074802"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 07:30:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 3DC1CA2CD3;
        Thu, 29 Dec 2022 07:30:50 +0000 (UTC)
Received: from EX19D002UWA004.ant.amazon.com (10.13.138.230) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 29 Dec 2022 07:30:34 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWA004.ant.amazon.com (10.13.138.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 29 Dec 2022 07:30:34 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 29 Dec 2022 07:30:32
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
Subject: [PATCH V1 net 5/7] net: ena: Fix rx_copybreak value update
Date:   Thu, 29 Dec 2022 07:30:09 +0000
Message-ID: <20221229073011.19687-6-darinzon@amazon.com>
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

Make the upper bound on rx_copybreak tighter, by
making sure it is smaller than the minimum of mtu and
ENA_PAGE_SIZE. With the current upper bound of mtu,
rx_copybreak can be larger than a page. Such large
rx_copybreak will not bring any performance benefit to
the user and therefore makes no sense.

In addition, the value update was only reflected in
the adapter structure, but not applied for each ring,
causing it to not take effect.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Osama Abboud <osamaabb@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  6 +-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 18 ++++++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 ++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 48ae6d810f8f..8da79eedc057 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -887,11 +887,7 @@ static int ena_set_tunable(struct net_device *netdev,
 	switch (tuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
 		len = *(u32 *)data;
-		if (len > adapter->netdev->mtu) {
-			ret = -EINVAL;
-			break;
-		}
-		adapter->rx_copybreak = len;
+		ret = ena_set_rx_copybreak(adapter, len);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a67f55e5f755..80a726932e81 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2814,6 +2814,24 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 	return dev_was_up ? ena_up(adapter) : 0;
 }
 
+int ena_set_rx_copybreak(struct ena_adapter *adapter, u32 rx_copybreak)
+{
+	struct ena_ring *rx_ring;
+	int i;
+
+	if (rx_copybreak > min_t(u16, adapter->netdev->mtu, ENA_PAGE_SIZE))
+		return -EINVAL;
+
+	adapter->rx_copybreak = rx_copybreak;
+
+	for (i = 0; i < adapter->num_io_queues; i++) {
+		rx_ring = &adapter->rx_ring[i];
+		rx_ring->rx_copybreak = rx_copybreak;
+	}
+
+	return 0;
+}
+
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 290ae9bf47ee..f9d862b630fa 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -392,6 +392,8 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
+int ena_set_rx_copybreak(struct ena_adapter *adapter, u32 rx_copybreak);
+
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
 static inline void ena_reset_device(struct ena_adapter *adapter,
-- 
2.38.1

