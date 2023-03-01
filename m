Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61036A7288
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCASDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjCASDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:03:32 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1171B77A
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 10:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677693780; x=1709229780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BPoHj7y3TSz4Jyvq/CxtWfo4JlAQU0fLjMnyPT9F+3w=;
  b=CkMxKx15gKb6WWvVGo5Gxw2SVEEQr3LUcqCkKvT2wFoeB+/knisgndow
   CQphg1T7xhKKGGTZ442Xe3JZchDvkq6pjocp9jiw1Rvea7FwuSr9eJSvz
   cukPsai944l/GGEBQOcx5ccnpR/y7HOUeaobWdD2tVQZjfsJgAmbwuhh8
   E=;
X-IronPort-AV: E=Sophos;i="5.98,225,1673913600"; 
   d="scan'208";a="304406455"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 18:02:42 +0000
Received: from EX19D010EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 9449D81083;
        Wed,  1 Mar 2023 18:02:40 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D010EUA002.ant.amazon.com (10.252.50.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 1 Mar 2023 18:02:39 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 1 Mar 2023 18:02:31 +0000
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
Subject: [PATCH RFC v1 net-next 5/5] net: ena: Advertise ETHTOOL_RING_USE_TX_PUSH_BUF_LEN support
Date:   Wed, 1 Mar 2023 20:02:13 +0200
Message-ID: <20230301180213.1828060-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230301175916.1819491-1-shayagr@amazon.com>
References: <20230301175916.1819491-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
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

Advertise support for modifying TX push buffer len using ethtool. This
capability requires the driver to support Low Latency Queue which might
not be the case for some scenarios.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 14 ++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  7 ++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 5e13fbc7b0ab..27fe0e6a5b6e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -939,7 +939,7 @@ static int ena_set_tunable(struct net_device *netdev,
 	return ret;
 }
 
-static const struct ethtool_ops ena_ethtool_ops = {
+static struct ethtool_ops ena_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_link_ksettings	= ena_get_link_ksettings,
@@ -967,8 +967,18 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_ts_info            = ethtool_op_get_ts_info,
 };
 
-void ena_set_ethtool_ops(struct net_device *netdev)
+void ena_set_ethtool_ops(struct ena_adapter *adapter)
 {
+	struct net_device *netdev = adapter->netdev;
+
+	ena_ethtool_ops.supported_ring_params = 0;
+	if (adapter->ena_dev->tx_mem_queue_type ==
+	    ENA_ADMIN_PLACEMENT_POLICY_HOST)
+		goto no_llq_supported;
+
+	ena_ethtool_ops.supported_ring_params |= ETHTOOL_RING_USE_TX_PUSH_BUF_LEN;
+
+no_llq_supported:
 	netdev->ethtool_ops = &ena_ethtool_ops;
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0625be4619a8..22f9786a91e2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3719,6 +3719,11 @@ int ena_restore_device(struct ena_adapter *adapter)
 		}
 	}
 
+	/* Some ethtool advertised capabilities might change after
+	 * destroy/restore calls
+	 */
+	ena_set_ethtool_ops(adapter);
+
 	set_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
 
 	clear_bit(ENA_FLAG_ONGOING_RESET, &adapter->flags);
@@ -4450,7 +4455,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->netdev_ops = &ena_netdev_ops;
 	netdev->watchdog_timeo = TX_TIMEOUT;
-	ena_set_ethtool_ops(netdev);
+	ena_set_ethtool_ops(adapter);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 5a0d4ee76172..f1dedf24cd11 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -388,7 +388,7 @@ struct ena_adapter {
 	u32 xdp_num_queues;
 };
 
-void ena_set_ethtool_ops(struct net_device *netdev);
+void ena_set_ethtool_ops(struct ena_adapter *adapter);
 
 void ena_dump_stats_to_dmesg(struct ena_adapter *adapter);
 
-- 
2.25.1

