Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947D850621E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344777AbiDSCbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344651AbiDSCaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:39 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A5D2E6AF
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kj74k4CxBzhXXx;
        Tue, 19 Apr 2022 10:27:50 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 10/19] net: use netdev_feature_del helpers
Date:   Tue, 19 Apr 2022 10:21:57 +0800
Message-ID: <20220419022206.36381-11-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419022206.36381-1-shenjian15@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the '&~' and '&= ~' operations of single feature bit by
netdev_feature_del helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |  3 +-
 drivers/net/ethernet/sfc/efx.c                |  4 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  9 +++--
 net/core/dev.c                                | 39 ++++++++++---------
 6 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 948317f210a4..fca355329040 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3321,7 +3321,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev_hw_features_set(netdev, netdev->features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev_features_zero(&vlan_off_features);
 	netdev_features_set_array(&hns3_vlan_off_feature_set,
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 857e7520461d..4bea76d0b833 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -246,7 +246,8 @@ static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				   &efx->fixed_features);
 	else
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   &efx->fixed_features);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index e346ad52c9a2..e37007839e2f 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1033,13 +1033,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
-	net_dev->features &= ~NETIF_F_RXALL;
+	netdev_active_feature_del(net_dev, NETIF_F_RXALL_BIT);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_del(net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index b5ce520e8f2f..d2056fbaa3d1 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2925,7 +2925,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_del(net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 1523be77b9db..508549db124b 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1326,9 +1326,12 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC_IG)))) {
 		netif_info(efx, probe, net_dev,
 			   "VLAN filters are not supported in this firmware variant\n");
-		net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		net_dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_del(net_dev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   &efx->fixed_features);
+		netdev_hw_feature_del(net_dev,
+				      NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 
 	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
diff --git a/net/core/dev.c b/net/core/dev.c
index 076305d33a62..4ea8231ecdee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1583,7 +1583,7 @@ void dev_disable_lro(struct net_device *dev)
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	dev->wanted_features &= ~NETIF_F_LRO;
+	netdev_wanted_feature_del(dev, NETIF_F_LRO_BIT);
 	netdev_update_features(dev);
 
 	if (unlikely(dev->features & NETIF_F_LRO))
@@ -1604,7 +1604,7 @@ EXPORT_SYMBOL(dev_disable_lro);
  */
 static void dev_disable_gro_hw(struct net_device *dev)
 {
-	dev->wanted_features &= ~NETIF_F_GRO_HW;
+	netdev_wanted_feature_del(dev, NETIF_F_GRO_HW_BIT);
 	netdev_update_features(dev);
 
 	if (unlikely(dev->features & NETIF_F_GRO_HW))
@@ -3346,7 +3346,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		partial_features = dev->features & dev->gso_partial_features;
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &partial_features);
 		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
-			features &= ~NETIF_F_GSO_PARTIAL;
+			netdev_feature_del(NETIF_F_GSO_PARTIAL_BIT, &features);
 	}
 
 	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
@@ -3436,7 +3436,7 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 		features &= ~netdev_csum_gso_features_mask;
 	}
 	if (illegal_highdma(skb->dev, skb))
-		features &= ~NETIF_F_SG;
+		netdev_feature_del(NETIF_F_SG_BIT, &features);
 
 	return features;
 }
@@ -3487,7 +3487,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT,
+					   &features);
 	}
 
 	return features;
@@ -9516,30 +9517,30 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
 					!(features & NETIF_F_IP_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO;
-		features &= ~NETIF_F_TSO_ECN;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
+		netdev_feature_del(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
 	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
 					 !(features & NETIF_F_IPV6_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO6;
+		netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
 	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
-		features &= ~NETIF_F_TSO_MANGLEID;
+		netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT, &features);
 
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
-	tmp &= ~NETIF_F_TSO_ECN;
+	netdev_feature_del(NETIF_F_TSO_ECN_BIT, &tmp);
 	if (!(features & tmp) && (features & NETIF_F_TSO_ECN))
-		features &= ~NETIF_F_TSO_ECN;
+		netdev_feature_del(NETIF_F_TSO_ECN_BIT, &features);
 
 	/* Software GSO depends on SG. */
 	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		features &= ~NETIF_F_GSO;
+		netdev_feature_del(NETIF_F_GSO_BIT, &features);
 	}
 
 	/* GSO partial features require GSO partial be set */
@@ -9558,7 +9559,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		 */
 		if (features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
@@ -9566,18 +9567,18 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if (features & NETIF_F_RXFCS) {
 		if (features & NETIF_F_LRO) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_LRO;
+			netdev_feature_del(NETIF_F_LRO_BIT, &features);
 		}
 
 		if (features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
 	if ((features & NETIF_F_GRO_HW) && (features & NETIF_F_LRO)) {
 		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 	}
 
 	if (features & NETIF_F_HW_TLS_TX) {
@@ -9587,13 +9588,13 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			features &= ~NETIF_F_HW_TLS_TX;
+			netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, &features);
 		}
 	}
 
 	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		features &= ~NETIF_F_HW_TLS_RX;
+		netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, &features);
 	}
 
 	return features;
@@ -11072,7 +11073,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	/* If one device supports hw checksumming, set for all. */
 	if (all & NETIF_F_HW_CSUM) {
 		tmp = NETIF_F_CSUM_MASK;
-		tmp &= ~NETIF_F_HW_CSUM;
+		netdev_feature_del(NETIF_F_HW_CSUM_BIT, &tmp);
 		all &= ~tmp;
 	}
 
-- 
2.33.0

