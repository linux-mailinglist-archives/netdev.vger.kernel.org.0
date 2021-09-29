Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4912F41C952
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346453AbhI2QEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:20 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24134 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345600AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbR1LYSz1DHMW;
        Wed, 29 Sep 2021 23:56:51 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 097/167] net: faraday: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:24 +0800
Message-ID: <20210929155334.12454-98-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 38 ++++++++++++++++--------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index ff76e401a014..0ca939eb2921 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -333,7 +333,8 @@ static void ftgmac100_start_hw(struct ftgmac100 *priv)
 		maccr |= FTGMAC100_MACCR_HT_MULTI_EN;
 
 	/* Vlan filtering enabled */
-	if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    priv->netdev->features))
 		maccr |= FTGMAC100_MACCR_RM_VLAN;
 
 	/* Hit the HW */
@@ -517,7 +518,8 @@ static bool ftgmac100_rx_packet(struct ftgmac100 *priv, int *processed)
 	 * by HW as one of the supported checksummed protocols before
 	 * we accept the HW test results.
 	 */
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    netdev->features)) {
 		u32 err_bits = FTGMAC100_RXDES1_TCP_CHKSUM_ERR |
 			FTGMAC100_RXDES1_UDP_CHKSUM_ERR |
 			FTGMAC100_RXDES1_IP_CHKSUM_ERR;
@@ -532,7 +534,8 @@ static bool ftgmac100_rx_packet(struct ftgmac100 *priv, int *processed)
 	skb_put(skb, size);
 
 	/* Extract vlan tag */
-	if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    netdev->features) &&
 	    (csum_vlan & FTGMAC100_RXDES1_VLANTAG_AVAIL))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       csum_vlan & 0xffff);
@@ -1579,17 +1582,19 @@ static int ftgmac100_set_features(struct net_device *netdev,
 				  netdev_features_t features)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
 	if (!netif_running(netdev))
 		return 0;
 
+	netdev_feature_xor(&changed, netdev->features, features);
 	/* Update the vlan filtering bit */
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		u32 maccr;
 
 		maccr = ioread32(priv->base + FTGMAC100_OFFSET_MACCR);
-		if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    priv->netdev->features))
 			maccr |= FTGMAC100_MACCR_RM_VLAN;
 		else
 			maccr &= ~FTGMAC100_MACCR_RM_VLAN;
@@ -1900,19 +1905,26 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	priv->tx_q_entries = priv->new_tx_q_entries = DEF_TX_QUEUE_ENTRIES;
 
 	/* Base feature set */
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
-		NETIF_F_GRO | NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
+				NETIF_F_GRO | NETIF_F_SG |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&netdev->hw_features);
 
 	if (priv->use_ncsi)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->hw_features);
 
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
-		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT,
+					 &netdev->hw_features);
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
-		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
-	netdev->features |= netdev->hw_features;
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM,
+					  &netdev->hw_features);
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
 
 	/* register network device */
 	err = register_netdev(netdev);
-- 
2.33.0

