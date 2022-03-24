Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0E14E6664
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351464AbiCXP46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351424AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6E4AD104
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPV9m6pn4zCrHg;
        Thu, 24 Mar 2022 23:53:00 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:09 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 11/20] net: use netdev_features_clear_bit helpers
Date:   Thu, 24 Mar 2022 23:49:23 +0800
Message-ID: <20220324154932.17557-12-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324154932.17557-1-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
netdev_features_clear_bit helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  3 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |  3 +-
 drivers/net/ethernet/sfc/efx.c                |  5 ++-
 drivers/net/ethernet/sfc/falcon/efx.c         |  3 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  9 ++--
 net/core/dev.c                                | 43 +++++++++++--------
 6 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index bdb430ba15de..7d9b72667ddb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3299,7 +3299,8 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev_hw_features_direct_or(netdev, netdev->active_features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_features_clear_bit(netdev,
+					     NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev_features_zero(&vlan_off_features);
 	netdev_features_set_array(hns3_vlan_off_features_array,
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 215a84981cbc..6693d59321dd 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -246,7 +246,8 @@ static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 		netdev_features_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 					&efx->fixed_features);
 	else
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_features_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					  &efx->fixed_features);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c46e02ee3d14..98f578841580 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1038,13 +1038,14 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_hw_features_direct_or(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
-	net_dev->active_features &= ~NETIF_F_RXALL;
+	netdev_active_features_clear_bit(net_dev, NETIF_F_RXALL_BIT);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_features_clear_bit(net_dev,
+					 NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_active_features_direct_or(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 9f745263766d..143f72575557 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2929,7 +2929,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_features_clear_bit(net_dev,
+					 NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_active_features_direct_or(net_dev, efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 2ff62bc67e03..10a78925c09d 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1326,9 +1326,12 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC_IG)))) {
 		netif_info(efx, probe, net_dev,
 			   "VLAN filters are not supported in this firmware variant\n");
-		net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		net_dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_features_clear_bit(net_dev,
+						 NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+		netdev_features_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					  &efx->fixed_features);
+		netdev_hw_features_clear_bit(net_dev,
+					     NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 
 	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
diff --git a/net/core/dev.c b/net/core/dev.c
index af09e138475a..3e7f5ac4d34a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1577,7 +1577,7 @@ void dev_disable_lro(struct net_device *dev)
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	dev->wanted_features &= ~NETIF_F_LRO;
+	netdev_wanted_features_clear_bit(dev, NETIF_F_LRO_BIT);
 	netdev_update_features(dev);
 
 	if (unlikely(dev->active_features & NETIF_F_LRO))
@@ -1598,7 +1598,7 @@ EXPORT_SYMBOL(dev_disable_lro);
  */
 static void dev_disable_gro_hw(struct net_device *dev)
 {
-	dev->wanted_features &= ~NETIF_F_GRO_HW;
+	netdev_wanted_features_clear_bit(dev, NETIF_F_GRO_HW_BIT);
 	netdev_update_features(dev);
 
 	if (unlikely(dev->active_features & NETIF_F_GRO_HW))
@@ -3329,7 +3329,8 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		netdev_features_set_bit(NETIF_F_GSO_ROBUST_BIT,
 					&partial_features);
 		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
-			features &= ~NETIF_F_GSO_PARTIAL;
+			netdev_features_clear_bit(NETIF_F_GSO_PARTIAL_BIT,
+						  &features);
 	}
 
 	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
@@ -3419,7 +3420,7 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 		features &= ~netdev_csum_gso_features_mask;
 	}
 	if (illegal_highdma(skb->dev, skb))
-		features &= ~NETIF_F_SG;
+		netdev_features_clear_bit(NETIF_F_SG_BIT, &features);
 
 	return features;
 }
@@ -3470,7 +3471,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			netdev_features_clear_bit(NETIF_F_TSO_MANGLEID_BIT,
+						  &features);
 	}
 
 	return features;
@@ -9490,30 +9492,30 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
 					!(features & NETIF_F_IP_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO;
-		features &= ~NETIF_F_TSO_ECN;
+		netdev_features_clear_bit(NETIF_F_TSO_BIT, &features);
+		netdev_features_clear_bit(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
 	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
 					 !(features & NETIF_F_IPV6_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO6;
+		netdev_features_clear_bit(NETIF_F_TSO6_BIT, &features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
 	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
-		features &= ~NETIF_F_TSO_MANGLEID;
+		netdev_features_clear_bit(NETIF_F_TSO_MANGLEID_BIT, &features);
 
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
-	tmp &= ~NETIF_F_TSO_ECN;
+	netdev_features_clear_bit(NETIF_F_TSO_ECN_BIT, &tmp);
 	if (!(features & tmp) && (features & NETIF_F_TSO_ECN))
-		features &= ~NETIF_F_TSO_ECN;
+		netdev_features_clear_bit(NETIF_F_TSO_ECN_BIT, &features);
 
 	/* Software GSO depends on SG. */
 	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		features &= ~NETIF_F_GSO;
+		netdev_features_clear_bit(NETIF_F_GSO_BIT, &features);
 	}
 
 	/* GSO partial features require GSO partial be set */
@@ -9532,7 +9534,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		 */
 		if (features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_features_clear_bit(NETIF_F_GRO_HW_BIT,
+						  &features);
 		}
 	}
 
@@ -9540,18 +9543,19 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if (features & NETIF_F_RXFCS) {
 		if (features & NETIF_F_LRO) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_LRO;
+			netdev_features_clear_bit(NETIF_F_LRO_BIT, &features);
 		}
 
 		if (features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_features_clear_bit(NETIF_F_GRO_HW_BIT,
+						  &features);
 		}
 	}
 
 	if ((features & NETIF_F_GRO_HW) && (features & NETIF_F_LRO)) {
 		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
-		features &= ~NETIF_F_LRO;
+		netdev_features_clear_bit(NETIF_F_LRO_BIT, &features);
 	}
 
 	if (features & NETIF_F_HW_TLS_TX) {
@@ -9561,13 +9565,14 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			features &= ~NETIF_F_HW_TLS_TX;
+			netdev_features_clear_bit(NETIF_F_HW_TLS_TX_BIT,
+						  &features);
 		}
 	}
 
 	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		features &= ~NETIF_F_HW_TLS_RX;
+		netdev_features_clear_bit(NETIF_F_HW_TLS_RX_BIT, &features);
 	}
 
 	return features;
@@ -11048,7 +11053,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	/* If one device supports hw checksumming, set for all. */
 	if (all & NETIF_F_HW_CSUM) {
 		tmp = NETIF_F_CSUM_MASK;
-		tmp &= ~NETIF_F_HW_CSUM;
+		netdev_features_clear_bit(NETIF_F_HW_CSUM_BIT, &tmp);
 		all &= ~tmp;
 	}
 
-- 
2.33.0

