Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ADC6BD263
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 15:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjCPO3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 10:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjCPO3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 10:29:15 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE8523135
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678976953; x=1710512953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s2zbeddJORHVIvGR4Ctr557cSv9e0gE/xuv6hBDouL4=;
  b=loUXG0px8PGkzBHNbD8KRiUWltw5Ahq6l7C7WNvDAk5ccesJPoWW//IN
   dKCrZETRCSoUi6sLUhfbdldiJ/wke+Vt2rwsy1MYNc9S6a9N3EoJTbRXy
   mYH6a4/Knnq6vlGMxlVlg7ZqcsJTWTDPoIOLDmsvjz29CDPD19kqbkVjk
   E=;
X-IronPort-AV: E=Sophos;i="5.98,265,1673913600"; 
   d="scan'208";a="319199566"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 14:29:12 +0000
Received: from EX19D001EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id 79B5980F9C;
        Thu, 16 Mar 2023 14:29:10 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D001EUA001.ant.amazon.com (10.252.50.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 16 Mar 2023 14:29:09 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.176) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 16 Mar 2023 14:29:01 +0000
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
Subject: [PATCH v5 net-next 6/6] net: ena: Advertise TX push support
Date:   Thu, 16 Mar 2023 16:27:06 +0200
Message-ID: <20230316142706.4046263-7-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230316142706.4046263-1-shayagr@amazon.com>
References: <20230316142706.4046263-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.176]
X-ClientProxiedBy: EX19D040UWB001.ant.amazon.com (10.13.138.82) To
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

LLQ is auto enabled by the device and disabling it isn't supported on
new ENA generations while on old ones causes sub-optimal performance.

This patch adds advertisement of push-mode when LLQ mode is used, but
rejects an attempt to modify it.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index f71ca72d641b..fc8fb037a686 100644
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
@@ -948,7 +956,8 @@ static int ena_set_tunable(struct net_device *netdev,
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

