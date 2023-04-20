Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5199C6E9078
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbjDTKke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbjDTKj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:39:57 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A93893CA
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:38:22 -0700 (PDT)
X-QQ-mid: bizesmtp63t1681987095t8sg9if7
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 20 Apr 2023 18:38:13 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: mRz6/7wsmIj5IYC7bX2fYsPXdrM8sNIpsnu2jdLXlK8cLxF8WxIOVxhMkwJiJ
        iIKZVV+G4yxgENs26dzrErfuj0MqnqIRALq3uIGvvCbweCyAs4nXUauTop5MsQMEDBXcALz
        JDMSby9bRu2cgyYNOhHSZx5Z6zvyk8rdaW6zswxKBJ1ArwzOtujrolW08RGvnIZDu74KW0g
        TCReQtsFHQUaLj6UKpqQtmxueMH37oHXjTz+4Yh3Ivx9xmq1f8VSTOmjPBotKphlxMEUYV5
        PC5lPlW4y1NHIqOpXJ7E1eaNk9kNjavTu55XPtR/L07njUmziVs/5SwwYvaaFw6WzD2m9J7
        Tkt1nppZCDU8n3TCn5BRDzDdHcvVlx0n6ki+TtuAly5IklfzXb6asxnocLkHj8R5gFNGJOx
        5R8nBrL6vZxBjHadLMvmOA==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 1942013337511737151
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, linyunsheng@huawei.com,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v3 5/5] net: wangxun: txgbe add netdev features support
Date:   Thu, 20 Apr 2023 18:37:42 +0800
Message-Id: <20230420103742.43168-6-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230420103742.43168-1-mengyuanlou@net-swift.com>
References: <20230420103742.43168-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

txgbe add ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Add features and hw_features that ngbe can support.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 24 ++++++++++++++++---
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 5b8a121fb496..00b8a43a87e1 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -258,6 +258,7 @@ static void txgbe_reset(struct wx *wx)
 	if (err != 0)
 		wx_err(wx, "Hardware Error: %d\n", err);
 
+	wx_start_hw(wx);
 	/* do not flush user set addresses */
 	memcpy(old_addr, &wx->mac_table[0].addr, netdev->addr_len);
 	wx_flush_sw_mac_table(wx);
@@ -330,6 +331,7 @@ static int txgbe_sw_init(struct wx *wx)
 	wx->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
 	wx->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
 	wx->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
+	wx->mac.vft_size = TXGBE_SP_VFT_TBL_SIZE;
 	wx->mac.rx_pb_size = TXGBE_SP_RX_PB_SIZE;
 	wx->mac.tx_pb_size = TXGBE_SP_TDB_PB_SZ;
 
@@ -494,6 +496,8 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
+	.ndo_vlan_rx_add_vid    = wx_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid   = wx_vlan_rx_kill_vid,
 };
 
 /**
@@ -596,11 +600,25 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->features = NETIF_F_SG;
-
+	netdev->features = NETIF_F_SG |
+			   NETIF_F_TSO |
+			   NETIF_F_TSO6 |
+			   NETIF_F_RXHASH |
+			   NETIF_F_RXCSUM |
+			   NETIF_F_HW_CSUM;
+
+	netdev->gso_partial_features =  NETIF_F_GSO_ENCAP_ALL;
+	netdev->features |= netdev->gso_partial_features;
+	netdev->features |= NETIF_F_SCTP_CRC;
+	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->features |= NETIF_F_VLAN_FEATURES;
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= netdev->features | NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->hw_features |= NETIF_F_GRO;
+	netdev->features |= NETIF_F_GRO;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 63a1c733718d..032972369965 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -77,6 +77,7 @@
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
+#define TXGBE_SP_VFT_TBL_SIZE   128
 #define TXGBE_SP_RX_PB_SIZE     512
 #define TXGBE_SP_TDB_PB_SZ      (160 * 1024) /* 160KB Packet Buffer */
 
-- 
2.40.0

