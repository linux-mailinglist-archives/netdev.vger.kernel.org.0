Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02341C960
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344497AbhI2QEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27915 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345632AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX46NkJzbmw1;
        Wed, 29 Sep 2021 23:53:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:13 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 122/167] net: amd: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:49 +0800
Message-ID: <20210929155334.12454-123-shenjian15@huawei.com>
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
 drivers/net/ethernet/amd/amd8111e.c       |  8 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c  | 20 ++++---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 72 +++++++++++++++--------
 drivers/net/ethernet/amd/xgbe/xgbe-main.c | 68 +++++++++++----------
 4 files changed, 103 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 92e4246dc359..1757eac19822 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1790,7 +1790,9 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 #if AMD8111E_VLAN_TAG_USED
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&dev->features);
 #endif
 
 	lp = netdev_priv(dev);
@@ -1829,7 +1831,9 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	netif_napi_add(dev, &lp->napi, amd8111e_rx_poll, 32);
 
 #if AMD8111E_VLAN_TAG_USED
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&dev->features);
 #endif
 	/* Probe the external PHY */
 	amd8111e_probe_ext_phy(dev);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index d5fd49dd25f3..6e1a5fbe2ff9 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -449,7 +449,8 @@ static void xgbe_config_rss(struct xgbe_prv_data *pdata)
 	if (!pdata->hw_feat.rss)
 		return;
 
-	if (pdata->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    pdata->netdev->features))
 		ret = xgbe_enable_rss(pdata);
 	else
 		ret = xgbe_disable_rss(pdata);
@@ -948,7 +949,8 @@ static int xgbe_set_promiscuous_mode(struct xgbe_prv_data *pdata,
 	if (enable) {
 		xgbe_disable_rx_vlan_filtering(pdata);
 	} else {
-		if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    pdata->netdev->features))
 			xgbe_enable_rx_vlan_filtering(pdata);
 	}
 
@@ -1990,7 +1992,7 @@ static int xgbe_dev_read(struct xgbe_channel *channel)
 	rdata->rx.len = XGMAC_GET_BITS_LE(rdesc->desc3, RX_NORMAL_DESC3, PL);
 
 	/* Set checksum done indicator as appropriate */
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features)) {
 		XGMAC_SET_BITS(packet->attributes, RX_PACKET_ATTRIBUTES,
 			       CSUM_DONE, 1);
 		XGMAC_SET_BITS(packet->attributes, RX_PACKET_ATTRIBUTES,
@@ -2021,7 +2023,8 @@ static int xgbe_dev_read(struct xgbe_channel *channel)
 	if (!err || !etlt) {
 		/* No error if err is 0 or etlt is 0 */
 		if ((etlt == 0x09) &&
-		    (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
+		    (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					     netdev->features))) {
 			XGMAC_SET_BITS(packet->attributes, RX_PACKET_ATTRIBUTES,
 				       VLAN_CTAG, 1);
 			packet->vlan_ctag = XGMAC_GET_BITS_LE(rdesc->desc0,
@@ -2823,7 +2826,8 @@ static void xgbe_config_mac_speed(struct xgbe_prv_data *pdata)
 
 static void xgbe_config_checksum_offload(struct xgbe_prv_data *pdata)
 {
-	if (pdata->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    pdata->netdev->features))
 		xgbe_enable_rx_csum(pdata);
 	else
 		xgbe_disable_rx_csum(pdata);
@@ -2838,12 +2842,14 @@ static void xgbe_config_vlan_support(struct xgbe_prv_data *pdata)
 	/* Set the current VLAN Hash Table register value */
 	xgbe_update_vlan_hash_table(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    pdata->netdev->features))
 		xgbe_enable_rx_vlan_filtering(pdata);
 	else
 		xgbe_disable_rx_vlan_filtering(pdata);
 
-	if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    pdata->netdev->features))
 		xgbe_enable_rx_vlan_stripping(pdata);
 	else
 		xgbe_disable_rx_vlan_stripping(pdata);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index dff9eecac6e9..2c29fa3a0bee 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2188,37 +2188,46 @@ static void xgbe_fix_features(struct net_device *netdev,
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	netdev_features_t vxlan_base;
 
-	vxlan_base = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_RX_UDP_TUNNEL_PORT;
+	netdev_feature_zero(&vxlan_base);
+	netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+				NETIF_F_RX_UDP_TUNNEL_PORT,
+				&vxlan_base);
 
 	if (!pdata->hw_feat.vxn)
 		return;
 
 	/* VXLAN CSUM requires VXLAN base */
-	if ((*features & NETIF_F_GSO_UDP_TUNNEL_CSUM) &&
-	    !(*features & NETIF_F_GSO_UDP_TUNNEL)) {
+	if (netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				    *features) &&
+	    !netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_BIT, *features)) {
 		netdev_notice(netdev,
 			      "forcing tx udp tunnel support\n");
-		*features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT, features);
 	}
 
 	/* Can't do one without doing the other */
-	if ((*features & vxlan_base) != vxlan_base) {
+	if (!netdev_feature_subset(*features, vxlan_base)) {
 		netdev_notice(netdev,
 			      "forcing both tx and rx udp tunnel support\n");
-		*features |= vxlan_base;
+		netdev_feature_or(features, *features, vxlan_base);
 	}
 
-	if (*features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		if (!(*features & NETIF_F_GSO_UDP_TUNNEL_CSUM)) {
+	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     *features)) {
+		if (!netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					     *features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
-			*features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					       features);
 		}
 	} else {
-		if (*features & NETIF_F_GSO_UDP_TUNNEL_CSUM) {
+		if (netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					    *features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming off\n");
-			*features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_feature_clear_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+						 features);
 		}
 	}
 }
@@ -2228,37 +2237,47 @@ static int xgbe_set_features(struct net_device *netdev,
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	netdev_features_t rxhash, rxcsum, rxvlan, rxvlan_filter;
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
 		ret = hw_if->enable_rss(pdata);
-	else if (!(features & NETIF_F_RXHASH) && rxhash)
+	else if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) &&
+		 rxhash)
 		ret = hw_if->disable_rss(pdata);
 	if (ret)
 		return ret;
 
-	if ((features & NETIF_F_RXCSUM) && !rxcsum)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) && !rxcsum)
 		hw_if->enable_rx_csum(pdata);
-	else if (!(features & NETIF_F_RXCSUM) && rxcsum)
+	else if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
+		 rxcsum)
 		hw_if->disable_rx_csum(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) && !rxvlan)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
+	    !rxvlan)
 		hw_if->enable_rx_vlan_stripping(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) && rxvlan)
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					  features) && rxvlan)
 		hw_if->disable_rx_vlan_stripping(pdata);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) && !rxvlan_filter)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    features) && !rxvlan_filter)
 		hw_if->enable_rx_vlan_filtering(pdata);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) && rxvlan_filter)
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					  features) && rxvlan_filter)
 		hw_if->disable_rx_vlan_filtering(pdata);
 
-	pdata->netdev_features = features;
+	netdev_feature_copy(&pdata->netdev_features, features);
 
 	DBGPR("<--xgbe_set_features\n");
 
@@ -2584,7 +2603,8 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
-		if (!(netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					     netdev->features) &&
 		    (skb->protocol == htons(ETH_P_8021Q)))
 			max_len += VLAN_HLEN;
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index a218dc6f2edd..ace7324fcedf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -342,45 +342,53 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 #endif
 
 	/* Set device features */
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6 |
-			      NETIF_F_GRO |
-			      NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_HW_VLAN_CTAG_TX |
-			      NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_GRO |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&netdev->hw_features);
 
 	if (pdata->hw_feat.rss)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
+				       &netdev->hw_features);
 
 	if (pdata->hw_feat.vxn) {
-		netdev->hw_enc_features = NETIF_F_SG |
-					  NETIF_F_IP_CSUM |
-					  NETIF_F_IPV6_CSUM |
-					  NETIF_F_RXCSUM |
-					  NETIF_F_TSO |
-					  NETIF_F_TSO6 |
-					  NETIF_F_GRO |
-					  NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_GSO_UDP_TUNNEL_CSUM;
-
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_set_bits(NETIF_F_SG |
+					NETIF_F_IP_CSUM |
+					NETIF_F_IPV6_CSUM |
+					NETIF_F_RXCSUM |
+					NETIF_F_TSO |
+					NETIF_F_TSO6 |
+					NETIF_F_GRO |
+					NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&netdev->hw_enc_features);
+
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&netdev->hw_features);
 
 		netdev->udp_tunnel_nic_info = xgbe_get_udp_tunnel_info();
 	}
 
-	netdev->vlan_features |= NETIF_F_SG |
-				 NETIF_F_IP_CSUM |
-				 NETIF_F_IPV6_CSUM |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6;
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO |
+				NETIF_F_TSO6,
+				&netdev->vlan_features);
 
-	netdev->features |= netdev->hw_features;
-	pdata->netdev_features = netdev->features;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_copy(&pdata->netdev_features, netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->min_mtu = 0;
-- 
2.33.0

