Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CDA6E213E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjDNKtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDNKtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:49:32 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769767EC3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:49:16 -0700 (PDT)
X-QQ-mid: bizesmtp74t1681469339tn1jfok4
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 14 Apr 2023 18:48:58 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: 3M0okmaRx3hpytrvhUsUZLmsQIXDRUhAx/W/gne+uPTwqVN1buLDaMqRi6YCn
        xQArqebV3P2C+lTaddrY6ESNoAiymbtxrARs4DJeLPGsKwl6T7dGkiHicNCWewPchhDNWNl
        CrmBgJ4/+1uk8iXqvfjYzLu7IxzM3mqMER4rtGCEgl8xrymT9v4IF01lM3fs6WWdZP6E8N8
        BPEpp1Diwp4ZQGYliD/xLmjdc+3HEBeQT6xHCNPcEoxTZwVIzIdonvZ88R3ggdxGUiNN29+
        4g7YPJDrtIayHdShZnGneYD8iycZcEqJQW9PcRZNxBdftS2mj/1chBsYh5YT5g4TYht7ozW
        ya3odWlXmhsTU7s//y4UM2Yz+7c/MWSR5BvY7mDEcbmN80IHg7mWk1Kya2gSUPUMuZvszai
        kArrr72TjzhWLLFgC9N92A==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 171006680665798607
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 4/5] net: wangxun: ngbe add netdev features support
Date:   Fri, 14 Apr 2023 18:48:32 +0800
Message-Id: <20230414104833.42989-5-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414104833.42989-1-mengyuanlou@net-swift.com>
References: <20230414104833.42989-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ngbe add ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Add features and hw_features that ngbe can support.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 19 ++++++++++++++-----
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index df6b870aa871..7a5f6b00b7d3 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -115,6 +115,7 @@ static int ngbe_sw_init(struct wx *wx)
 	wx->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
 	wx->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
 	wx->mac.mcft_size = NGBE_MC_TBL_SIZE;
+	wx->mac.vft_size = NGBE_SP_VFT_TBL_SIZE;
 	wx->mac.rx_pb_size = NGBE_RX_PB_SIZE;
 	wx->mac.tx_pb_size = NGBE_TDB_PB_SZ;
 
@@ -476,6 +477,8 @@ static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
+	.ndo_vlan_rx_add_vid    = wx_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid   = wx_vlan_rx_kill_vid,
 };
 
 /**
@@ -551,12 +554,18 @@ static int ngbe_probe(struct pci_dev *pdev,
 	ngbe_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &ngbe_netdev_ops;
 
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->features = NETIF_F_SG;
-
+	netdev->features = NETIF_F_SG | NETIF_F_IP_CSUM |
+			   NETIF_F_TSO | NETIF_F_TSO6 |
+			   NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->features |= NETIF_F_IPV6_CSUM | NETIF_F_VLAN_FEATURES;
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_RXALL;
+	netdev->hw_features |= netdev->features | NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->hw_features |= NETIF_F_LRO | NETIF_F_GRO;
+	netdev->features |= NETIF_F_LRO | NETIF_F_GRO;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 373d5af628cd..b70eca397b67 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -136,6 +136,7 @@ enum NGBE_MSCA_CMD_value {
 #define NGBE_RAR_ENTRIES			32
 #define NGBE_RX_PB_SIZE				42
 #define NGBE_MC_TBL_SIZE			128
+#define NGBE_SP_VFT_TBL_SIZE			128
 #define NGBE_TDB_PB_SZ				(20 * 1024) /* 160KB Packet Buffer */
 
 /* TX/RX descriptor defines */
-- 
2.40.0

