Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5A841C96D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346556AbhI2QEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:31 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27922 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345620AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX06hzBzbmvm;
        Wed, 29 Sep 2021 23:53:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 093/167] net: synopsys: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:20 +0800
Message-ID: <20210929155334.12454-94-shenjian15@huawei.com>
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
 .../net/ethernet/synopsys/dwc-xlgmac-common.c | 45 ++++++++++++-------
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c | 20 ++++++---
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    | 41 ++++++++++-------
 3 files changed, 68 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index df26cea45904..4e61f92c6512 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -179,34 +179,47 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 
 	/* Set device features */
 	if (pdata->hw_feat.tso) {
-		netdev->hw_features = NETIF_F_TSO;
-		netdev->hw_features |= NETIF_F_TSO6;
-		netdev->hw_features |= NETIF_F_SG;
-		netdev->hw_features |= NETIF_F_IP_CSUM;
-		netdev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+				       &netdev->hw_features);
 	} else if (pdata->hw_feat.tx_coe) {
-		netdev->hw_features = NETIF_F_IP_CSUM;
-		netdev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+				       &netdev->hw_features);
 	}
 
 	if (pdata->hw_feat.rx_coe) {
-		netdev->hw_features |= NETIF_F_RXCSUM;
-		netdev->hw_features |= NETIF_F_GRO;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->hw_features);
 	}
 
 	if (pdata->hw_feat.rss)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
+				       &netdev->hw_features);
 
-	netdev->vlan_features |= netdev->hw_features;
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->hw_features);
 
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			       &netdev->hw_features);
 	if (pdata->hw_feat.sa_vlan_ins)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       &netdev->hw_features);
 	if (pdata->hw_feat.vlhash)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->hw_features);
 
-	netdev->features |= netdev->hw_features;
-	pdata->netdev_features = netdev->features;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_copy(&pdata->netdev_features, netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
index bf6c1c6779ff..c7d60130f24a 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
@@ -263,7 +263,8 @@ static int xlgmac_set_promiscuous_mode(struct xlgmac_pdata *pdata,
 	if (enable) {
 		xlgmac_disable_rx_vlan_filtering(pdata);
 	} else {
-		if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    pdata->netdev->features))
 			xlgmac_enable_rx_vlan_filtering(pdata);
 	}
 
@@ -404,7 +405,8 @@ static void xlgmac_config_jumbo_enable(struct xlgmac_pdata *pdata)
 
 static void xlgmac_config_checksum_offload(struct xlgmac_pdata *pdata)
 {
-	if (pdata->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    pdata->netdev->features))
 		xlgmac_enable_rx_csum(pdata);
 	else
 		xlgmac_disable_rx_csum(pdata);
@@ -425,12 +427,14 @@ static void xlgmac_config_vlan_support(struct xlgmac_pdata *pdata)
 	/* Set the current VLAN Hash Table register value */
 	xlgmac_update_vlan_hash_table(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    pdata->netdev->features))
 		xlgmac_enable_rx_vlan_filtering(pdata);
 	else
 		xlgmac_disable_rx_vlan_filtering(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    pdata->netdev->features))
 		xlgmac_enable_rx_vlan_stripping(pdata);
 	else
 		xlgmac_disable_rx_vlan_stripping(pdata);
@@ -2433,7 +2437,8 @@ static void xlgmac_config_rss(struct xlgmac_pdata *pdata)
 	if (!pdata->hw_feat.rss)
 		return;
 
-	if (pdata->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    pdata->netdev->features))
 		ret = xlgmac_enable_rss(pdata);
 	else
 		ret = xlgmac_disable_rss(pdata);
@@ -2760,7 +2765,7 @@ static int xlgmac_dev_read(struct xlgmac_channel *channel)
 			0);
 
 	/* Set checksum done indicator as appropriate */
-	if (netdev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features))
 		pkt_info->attributes = XLGMAC_SET_REG_BITS(
 				pkt_info->attributes,
 				RX_PACKET_ATTRIBUTES_CSUM_DONE_POS,
@@ -2779,7 +2784,8 @@ static int xlgmac_dev_read(struct xlgmac_channel *channel)
 	if (!err || !etlt) {
 		/* No error if err is 0 or etlt is 0 */
 		if ((etlt == 0x09) &&
-		    (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
+		    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    netdev->features)) {
 			pkt_info->attributes = XLGMAC_SET_REG_BITS(
 					pkt_info->attributes,
 					RX_PACKET_ATTRIBUTES_VLAN_CTAG_POS,
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 1db7104fef3a..927915547311 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -879,39 +879,49 @@ static void xlgmac_poll_controller(struct net_device *netdev)
 static int xlgmac_set_features(struct net_device *netdev,
 			       netdev_features_t features)
 {
-	netdev_features_t rxhash, rxcsum, rxvlan, rxvlan_filter;
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 	struct xlgmac_hw_ops *hw_ops = &pdata->hw_ops;
+	bool rxhash, rxcsum, rxvlan, rxvlan_filter;
 	int ret = 0;
 
-	rxhash = pdata->netdev_features & NETIF_F_RXHASH;
-	rxcsum = pdata->netdev_features & NETIF_F_RXCSUM;
-	rxvlan = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_RX;
-	rxvlan_filter = pdata->netdev_features & NETIF_F_HW_VLAN_CTAG_FILTER;
+	rxhash = netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+					 pdata->netdev_features);
+	rxcsum = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					 pdata->netdev_features);
+	rxvlan = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					 pdata->netdev_features);
+	rxvlan_filter = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						pdata->netdev_features);
 
-	if ((features & NETIF_F_RXHASH) && !rxhash)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) && !rxhash)
 		ret = hw_ops->enable_rss(pdata);
-	else if (!(features & NETIF_F_RXHASH) && rxhash)
+	else if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) &&
+		 rxhash)
 		ret = hw_ops->disable_rss(pdata);
 	if (ret)
 		return ret;
 
-	if ((features & NETIF_F_RXCSUM) && !rxcsum)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) && !rxcsum)
 		hw_ops->enable_rx_csum(pdata);
-	else if (!(features & NETIF_F_RXCSUM) && rxcsum)
+	else if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
+		 rxcsum)
 		hw_ops->disable_rx_csum(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) && !rxvlan)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
+	    !rxvlan)
 		hw_ops->enable_rx_vlan_stripping(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) && rxvlan)
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					  features) && rxvlan)
 		hw_ops->disable_rx_vlan_stripping(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) && !rxvlan_filter)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    features) && !rxvlan_filter)
 		hw_ops->enable_rx_vlan_filtering(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) && rxvlan_filter)
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					  features) && rxvlan_filter)
 		hw_ops->disable_rx_vlan_filtering(pdata);
 
-	pdata->netdev_features = features;
+	netdev_feature_copy(&pdata->netdev_features, features);
 
 	return 0;
 }
@@ -1219,7 +1229,8 @@ static int xlgmac_rx_poll(struct xlgmac_channel *channel, int budget)
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
-		if (!(netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					     netdev->features) &&
 		    (skb->protocol == htons(ETH_P_8021Q)))
 			max_len += VLAN_HLEN;
 
-- 
2.33.0

