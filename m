Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AF74CD308
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbiCDLIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbiCDLHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:07:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754501B018C;
        Fri,  4 Mar 2022 03:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646392019; x=1677928019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dgOjENX6l9BVZn567uS9ZeSd/FqmZZeUVUNHkZSQekg=;
  b=O0gNE6uF8V9gLp9SEdaqX/lN5lAZSRDuw+OzGxBN3vhBBwNtcyTJEQkP
   1QQ3TQh0hUy554jhbal64pJrvkjhhgR0+aplAHUyi4Df9PFvRLp0SYLM3
   c4fT2qkizWx0gqTm5XIvTia0P39BWH6Pq40FOr9ogIMpP//XST4+qN4tn
   bNGZF5yWT0/LGh6SOGJ0c7r0yK5Brw6QqdIwi0emjrOvZINwcm/JUQC8M
   dtFeRIn5cerkEJQU+bZCcTFSmylyvYAgYZFnREl+Qgch1FJmK0K61SHHx
   N/BUyhSkvyH6V/95hBZXSTqjlKRasB6edfZ/b3Qi2ROe1YX2egAJObonm
   A==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="148088280"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:54 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 9/9] net: sparx5: Implement get_ts_info
Date:   Fri, 4 Mar 2022 12:09:00 +0100
Message-ID: <20220304110900.3199904-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the function get_ts_info in ethtool_ops which is needed to get
the HW capabilities for timestamping.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/sparx5/sparx5_ethtool.c         | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 10b866e9f726..6b0febcb7fa9 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1183,6 +1183,39 @@ static void sparx5_config_port_stats(struct sparx5 *sparx5, int portno)
 		 sparx5, ANA_AC_PORT_STAT_CFG(portno, SPX5_PORT_POLICER_DROPS));
 }
 
+static int sparx5_get_ts_info(struct net_device *dev,
+			      struct ethtool_ts_info *info)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+	struct sparx5_phc *phc;
+
+	if (!sparx5->ptp)
+		return ethtool_op_get_ts_info(dev, info);
+
+	phc = &sparx5->phc[SPARX5_PHC_PORT];
+
+	info->phc_index = phc->clock ? ptp_clock_index(phc->clock) : -1;
+	if (info->phc_index == -1) {
+		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+					 SOF_TIMESTAMPING_RX_SOFTWARE |
+					 SOF_TIMESTAMPING_SOFTWARE;
+		return 0;
+	}
+	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+				 SOF_TIMESTAMPING_RX_SOFTWARE |
+				 SOF_TIMESTAMPING_SOFTWARE |
+				 SOF_TIMESTAMPING_TX_HARDWARE |
+				 SOF_TIMESTAMPING_RX_HARDWARE |
+				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
+			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
 const struct ethtool_ops sparx5_ethtool_ops = {
 	.get_sset_count         = sparx5_get_sset_count,
 	.get_strings            = sparx5_get_sset_strings,
@@ -1194,6 +1227,7 @@ const struct ethtool_ops sparx5_ethtool_ops = {
 	.get_eth_mac_stats      = sparx5_get_eth_mac_stats,
 	.get_eth_ctrl_stats     = sparx5_get_eth_mac_ctrl_stats,
 	.get_rmon_stats         = sparx5_get_eth_rmon_stats,
+	.get_ts_info            = sparx5_get_ts_info,
 };
 
 int sparx_stats_init(struct sparx5 *sparx5)
-- 
2.33.0

