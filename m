Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324E56C6DEC
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjCWQlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjCWQlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:41:10 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13732392AF
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679589548; x=1711125548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9LQ6zqfWDM2SoZ0nYrUDovkbmR+F3GKeGmLRoDbzFe0=;
  b=Hhr0Qlob0iUwVH9LdDEwWk5PO/fov72QY6IhEzXDZ8LAVQm9I1K7oT7R
   FrhgvdI9Eg34XYDeNQI7pbh4gRSwxVN14sZSUDjcWcVnQF1Uict2yHodm
   bq3ld1URixXjxC1CiLQvKVDuUVIYjB2RgBxu+DAFsplM53QieexNXncka
   o=;
X-IronPort-AV: E=Sophos;i="5.98,285,1673913600"; 
   d="scan'208";a="310600474"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 16:38:52 +0000
Received: from EX19D005EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 799EE427B8;
        Thu, 23 Mar 2023 16:38:47 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D005EUA002.ant.amazon.com (10.252.50.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 16:38:46 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.177) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 16:38:34 +0000
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
Subject: [PATCH v7 net-next 7/7] net: ena: Advertise TX push support
Date:   Thu, 23 Mar 2023 18:36:10 +0200
Message-ID: <20230323163610.1281468-8-shayagr@amazon.com>
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

LLQ is auto enabled by the device and disabling it isn't supported on
new ENA generations while on old ones causes sub-optimal performance.

This patch adds advertisement of push-mode when LLQ mode is used, but
rejects an attempt to modify it.

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index de7ec02d8c09..d671df4b76bc 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -479,12 +479,14 @@ static void ena_get_ringparam(struct net_device *netdev,
 	if (adapter->ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) {
 		bool large_llq_supported = adapter->large_llq_header_supported;
 
+		kernel_ring->tx_push = true;
 		kernel_ring->tx_push_buf_len = adapter->ena_dev->tx_max_header_size;
 		if (large_llq_supported)
 			kernel_ring->tx_push_buf_max_len = ENA_LLQ_LARGE_HEADER;
 		else
 			kernel_ring->tx_push_buf_max_len = ENA_LLQ_HEADER;
 	} else {
+		kernel_ring->tx_push = false;
 		kernel_ring->tx_push_buf_max_len = 0;
 		kernel_ring->tx_push_buf_len = 0;
 	}
@@ -516,6 +518,12 @@ static int ena_set_ringparam(struct net_device *netdev,
 	/* This value is ignored if LLQ is not supported */
 	new_tx_push_buf_len = adapter->ena_dev->tx_max_header_size;
 
+	if ((adapter->ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) !=
+	    kernel_ring->tx_push) {
+		NL_SET_ERR_MSG_MOD(extack, "Push mode state cannot be modified");
+		return -EINVAL;
+	}
+
 	/* Validate that the push buffer is supported on the underlying device */
 	if (kernel_ring->tx_push_buf_len) {
 		enum ena_admin_placement_policy_type placement;
@@ -957,7 +965,8 @@ static int ena_set_tunable(struct net_device *netdev,
 static const struct ethtool_ops ena_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
-	.supported_ring_params	= ETHTOOL_RING_USE_TX_PUSH_BUF_LEN,
+	.supported_ring_params	= ETHTOOL_RING_USE_TX_PUSH_BUF_LEN |
+				  ETHTOOL_RING_USE_TX_PUSH,
 	.get_link_ksettings	= ena_get_link_ksettings,
 	.get_drvinfo		= ena_get_drvinfo,
 	.get_msglevel		= ena_get_msglevel,
-- 
2.25.1

