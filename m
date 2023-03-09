Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A956B250A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCINPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCINPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:15:06 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB3DDF0E
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 05:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678367704; x=1709903704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dq9B7Opwkok8PFNcIWXAYrZOXmHHmY8MR4kC+89XxkY=;
  b=ory2Z85GH/G35Sssvh9Uu6AsVC+X6fhrP3uyL0aittn3OOI5+gSgAwgI
   M3agjG939064cH+1M6dUOSWwtXHmBItlGNrHRDfgchYXWqDxIAXMOAkV2
   K7zi6EyaANAMnD88yg1aCuhrgtbEh6kMqcMaH4mn8sFiwkJQ0Am1TZ0Wc
   M=;
X-IronPort-AV: E=Sophos;i="5.98,246,1673913600"; 
   d="scan'208";a="1110979678"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 13:14:56 +0000
Received: from EX19D009EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id 92DB144D09;
        Thu,  9 Mar 2023 13:14:55 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D009EUA004.ant.amazon.com (10.252.50.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 9 Mar 2023 13:14:54 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 9 Mar 2023 13:14:46 +0000
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
Subject: [PATCH v4 net-next 5/5] net: ena: Add support to changing tx_push_buf_len
Date:   Thu, 9 Mar 2023 15:13:19 +0200
Message-ID: <20230309131319.2531008-6-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230309131319.2531008-1-shayagr@amazon.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
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

The ENA driver allows for two distinct values for the number of bytes
of the packet's payload that can be written directly to the device.

For a value of 224 the driver turns on Large LLQ Header mode in which
the first 224 of the packet's payload are written to the LLQ.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  4 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 57 +++++++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 26 +++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  7 ++-
 4 files changed, 82 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 689313ee25a8..8bec31fa816c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -10,6 +10,10 @@
 
 /* head update threshold in units of (queue size / ENA_COMP_HEAD_THRESH) */
 #define ENA_COMP_HEAD_THRESH 4
+/* we allow 2 DMA descriptors per LLQ entry */
+#define ENA_LLQ_ENTRY_DESC_CHUNK_SIZE	(2 * sizeof(struct ena_eth_io_tx_desc))
+#define ENA_LLQ_HEADER		(128 - ENA_LLQ_ENTRY_DESC_CHUNK_SIZE)
+#define ENA_LLQ_LARGE_HEADER	(256 - ENA_LLQ_ENTRY_DESC_CHUNK_SIZE)
 
 struct ena_com_tx_ctx {
 	struct ena_com_tx_meta ena_meta;
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 8da79eedc057..f71ca72d641b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -476,6 +476,19 @@ static void ena_get_ringparam(struct net_device *netdev,
 
 	ring->tx_max_pending = adapter->max_tx_ring_size;
 	ring->rx_max_pending = adapter->max_rx_ring_size;
+	if (adapter->ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) {
+		bool large_llq_supported = adapter->large_llq_header_supported;
+
+		kernel_ring->tx_push_buf_len = adapter->ena_dev->tx_max_header_size;
+		if (large_llq_supported)
+			kernel_ring->tx_push_buf_max_len = ENA_LLQ_LARGE_HEADER;
+		else
+			kernel_ring->tx_push_buf_max_len = ENA_LLQ_HEADER;
+	} else {
+		kernel_ring->tx_push_buf_max_len = 0;
+		kernel_ring->tx_push_buf_len = 0;
+	}
+
 	ring->tx_pending = adapter->tx_ring[0].ring_size;
 	ring->rx_pending = adapter->rx_ring[0].ring_size;
 }
@@ -486,7 +499,8 @@ static int ena_set_ringparam(struct net_device *netdev,
 			     struct netlink_ext_ack *extack)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
-	u32 new_tx_size, new_rx_size;
+	u32 new_tx_size, new_rx_size, new_tx_push_buf_len;
+	bool changed = false;
 
 	new_tx_size = ring->tx_pending < ENA_MIN_RING_SIZE ?
 			ENA_MIN_RING_SIZE : ring->tx_pending;
@@ -496,11 +510,45 @@ static int ena_set_ringparam(struct net_device *netdev,
 			ENA_MIN_RING_SIZE : ring->rx_pending;
 	new_rx_size = rounddown_pow_of_two(new_rx_size);
 
-	if (new_tx_size == adapter->requested_tx_ring_size &&
-	    new_rx_size == adapter->requested_rx_ring_size)
+	changed |= new_tx_size != adapter->requested_tx_ring_size ||
+		   new_rx_size != adapter->requested_rx_ring_size;
+
+	/* This value is ignored if LLQ is not supported */
+	new_tx_push_buf_len = adapter->ena_dev->tx_max_header_size;
+
+	/* Validate that the push buffer is supported on the underlying device */
+	if (kernel_ring->tx_push_buf_len) {
+		enum ena_admin_placement_policy_type placement;
+
+		new_tx_push_buf_len = kernel_ring->tx_push_buf_len;
+
+		placement = adapter->ena_dev->tx_mem_queue_type;
+		if (placement == ENA_ADMIN_PLACEMENT_POLICY_HOST)
+			return -EOPNOTSUPP;
+
+		if (new_tx_push_buf_len != ENA_LLQ_HEADER &&
+		    new_tx_push_buf_len != ENA_LLQ_LARGE_HEADER) {
+			bool large_llq_sup = adapter->large_llq_header_supported;
+			char large_llq_size_str[40];
+
+			snprintf(large_llq_size_str, 40, ", %lu", ENA_LLQ_LARGE_HEADER);
+
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Supported tx push buff values: [%lu%s]",
+					       ENA_LLQ_HEADER,
+					       large_llq_sup ? large_llq_size_str : "");
+
+			return -EINVAL;
+		}
+
+		changed |= new_tx_push_buf_len != adapter->ena_dev->tx_max_header_size;
+	}
+
+	if (!changed)
 		return 0;
 
-	return ena_update_queue_sizes(adapter, new_tx_size, new_rx_size);
+	return ena_update_queue_params(adapter, new_tx_size, new_rx_size,
+				       new_tx_push_buf_len);
 }
 
 static u32 ena_flow_hash_to_flow_type(u16 hash_fields)
@@ -900,6 +948,7 @@ static int ena_set_tunable(struct net_device *netdev,
 static const struct ethtool_ops ena_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
+	.supported_ring_params	= ETHTOOL_RING_USE_TX_PUSH_BUF_LEN,
 	.get_link_ksettings	= ena_get_link_ksettings,
 	.get_drvinfo		= ena_get_drvinfo,
 	.get_msglevel		= ena_get_msglevel,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 537951ca4d61..776a35c27c53 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2809,11 +2809,13 @@ static int ena_close(struct net_device *netdev)
 	return 0;
 }
 
-int ena_update_queue_sizes(struct ena_adapter *adapter,
-			   u32 new_tx_size,
-			   u32 new_rx_size)
+int ena_update_queue_params(struct ena_adapter *adapter,
+			    u32 new_tx_size,
+			    u32 new_rx_size,
+			    u32 new_llq_header_len)
 {
-	bool dev_was_up;
+	bool dev_was_up, large_llq_changed = false;
+	int rc = 0;
 
 	dev_was_up = test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
 	ena_close(adapter->netdev);
@@ -2823,7 +2825,21 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 			  0,
 			  adapter->xdp_num_queues +
 			  adapter->num_io_queues);
-	return dev_was_up ? ena_up(adapter) : 0;
+
+	large_llq_changed = adapter->ena_dev->tx_mem_queue_type ==
+			    ENA_ADMIN_PLACEMENT_POLICY_DEV;
+	large_llq_changed &=
+		new_llq_header_len != adapter->ena_dev->tx_max_header_size;
+
+	/* a check that the configuration is valid is done by caller */
+	if (large_llq_changed) {
+		adapter->large_llq_header_enabled = !adapter->large_llq_header_enabled;
+
+		ena_destroy_device(adapter, false);
+		rc = ena_restore_device(adapter);
+	}
+
+	return dev_was_up && !rc ? ena_up(adapter) : rc;
 }
 
 int ena_set_rx_copybreak(struct ena_adapter *adapter, u32 rx_copybreak)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 3e8c4a66c7d8..5a0d4ee76172 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -396,9 +396,10 @@ void ena_dump_stats_to_buf(struct ena_adapter *adapter, u8 *buf);
 
 int ena_update_hw_stats(struct ena_adapter *adapter);
 
-int ena_update_queue_sizes(struct ena_adapter *adapter,
-			   u32 new_tx_size,
-			   u32 new_rx_size);
+int ena_update_queue_params(struct ena_adapter *adapter,
+			    u32 new_tx_size,
+			    u32 new_rx_size,
+			    u32 new_llq_header_len);
 
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
-- 
2.25.1

