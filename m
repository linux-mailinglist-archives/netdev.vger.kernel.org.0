Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A3F4E666C
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351444AbiCXP4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351427AbiCXP4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533C4AC938
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KPVD30GKgzcbT2;
        Thu, 24 Mar 2022 23:54:59 +0800 (CST)
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
Subject: [RFCv5 PATCH net-next 12/20] net: use netdev_features_andnot helpers
Date:   Thu, 24 Mar 2022 23:49:24 +0800
Message-ID: <20220324154932.17557-13-shenjian15@huawei.com>
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

Replace the '& ~' and '&= ~' operations of features by
netdev_features_andnot helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  5 ++--
 drivers/net/ethernet/sfc/efx.c                |  4 +--
 drivers/net/ethernet/sfc/efx_common.c         | 10 ++++---
 drivers/net/ethernet/sfc/falcon/efx.c         |  7 ++---
 include/linux/netdevice.h                     |  2 +-
 net/core/dev.c                                | 26 +++++++++++--------
 net/ethtool/features.c                        |  2 +-
 net/ethtool/ioctl.c                           | 12 ++++-----
 8 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 7d9b72667ddb..435a4adac524 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2467,7 +2467,8 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_direct_andnot(&features,
+					      netdev_csum_gso_features_mask);
 
 	return features;
 }
@@ -3306,7 +3307,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev_features_set_array(hns3_vlan_off_features_array,
 				  ARRAY_SIZE(hns3_vlan_off_features_array),
 				  &vlan_off_features);
-	features = netdev->active_features & ~vlan_off_features;
+	features = netdev_active_features_andnot(netdev, vlan_off_features);
 	netdev_vlan_features_direct_or(netdev, features);
 
 	netdev_hw_enc_features_direct_or(netdev, netdev->vlan_features);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 98f578841580..10b420dc450f 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1028,13 +1028,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 		netdev_active_features_set_bit(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->active_features &= ~NETIF_F_ALL_TSO;
+		netdev_active_features_direct_andnot(net_dev, NETIF_F_ALL_TSO);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_direct_or(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
 				       ARRAY_SIZE(efx_vlan_features_array));
 
-	tmp = net_dev->active_features & ~efx->fixed_features;
+	tmp = netdev_active_features_andnot(net_dev, efx->fixed_features);
 	netdev_hw_features_direct_or(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 771319da0cd4..94a3884f016e 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -216,7 +216,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	tmp = net_dev->active_features & ~data;
+	tmp = netdev_active_features_andnot(net_dev, data);
 	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
@@ -416,7 +416,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	old_features = efx->net_dev->active_features;
 	netdev_hw_features_direct_or(efx->net_dev,
 				     efx->net_dev->active_features);
-	efx->net_dev->hw_features &= ~efx->fixed_features;
+	netdev_hw_features_direct_andnot(efx->net_dev, efx->fixed_features);
 	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->active_features != old_features)
 		netdev_features_change(efx->net_dev);
@@ -1371,10 +1371,12 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				features &= ~(NETIF_F_GSO_MASK);
+				netdev_features_direct_andnot(&features,
+							      NETIF_F_GSO_MASK);
 		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~netdev_csum_gso_features_mask;
+				netdev_features_direct_andnot(&features,
+							      netdev_csum_gso_features_mask);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 143f72575557..b7217aee193f 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -643,7 +643,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	old_features = efx->net_dev->active_features;
 	netdev_hw_features_direct_or(efx->net_dev,
 				     efx->net_dev->active_features);
-	efx->net_dev->hw_features &= ~efx->fixed_features;
+	netdev_hw_features_direct_andnot(efx->net_dev, efx->fixed_features);
 	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->active_features != old_features)
 		netdev_features_change(efx->net_dev);
@@ -2194,7 +2194,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	tmp = net_dev->active_features & ~data;
+	tmp = netdev_active_features_andnot(net_dev, data);
 	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
@@ -2923,7 +2923,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
 				       ARRAY_SIZE(efx_vlan_features_array));
-	net_dev->hw_features = net_dev->active_features & ~efx->fixed_features;
+	net_dev->hw_features = netdev_active_features_andnot(net_dev,
+							     efx->fixed_features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f1b6cfe87166..4f9022e02906 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5434,7 +5434,7 @@ static inline netdev_features_t netdev_get_wanted_features(
 {
 	netdev_features_t tmp;
 
-	tmp = dev->active_features & ~dev->hw_features;
+	tmp = netdev_active_features_andnot(dev, netdev_hw_features(dev));
 	return netdev_wanted_features_or(dev, tmp);
 }
 netdev_features_t netdev_increment_features(netdev_features_t all,
diff --git a/net/core/dev.c b/net/core/dev.c
index 3e7f5ac4d34a..d7e6f44ce62b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3417,7 +3417,8 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_direct_andnot(&features,
+					      netdev_csum_gso_features_mask);
 	}
 	if (illegal_highdma(skb->dev, skb))
 		netdev_features_clear_bit(NETIF_F_SG_BIT, &features);
@@ -3447,11 +3448,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
 	if (gso_segs > READ_ONCE(dev->gso_max_segs))
-		return features & ~NETIF_F_GSO_MASK;
+		return netdev_features_andnot(features, NETIF_F_GSO_MASK);
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		return features & ~NETIF_F_GSO_MASK;
+		return netdev_features_andnot(features, NETIF_F_GSO_MASK);
 	}
 
 	/* Support for GSO partial features requires software
@@ -3461,7 +3462,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		features &= ~dev->gso_partial_features;
+		netdev_features_direct_andnot(&features,
+					      dev->gso_partial_features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -9439,7 +9441,7 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 		    && (features & feature)) {
 			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
 				   &feature, upper->name);
-			features &= ~feature;
+			netdev_features_direct_andnot(&features, feature);
 		}
 	}
 
@@ -9459,7 +9461,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
 		if (!(features & feature) && (lower->active_features & feature)) {
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
-			lower->wanted_features &= ~feature;
+			netdev_wanted_features_direct_andnot(lower, feature);
 			__netdev_update_features(lower);
 
 			if (unlikely(lower->active_features & feature))
@@ -9480,13 +9482,14 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_HW_CSUM) &&
 	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~netdev_ip_csum_features;
+		netdev_features_direct_andnot(&features,
+					      netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
 	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_direct_andnot(&features, NETIF_F_ALL_TSO);
 	}
 
 	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
@@ -9523,7 +9526,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	    !(features & NETIF_F_GSO_PARTIAL)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		features &= ~dev->gso_partial_features;
+		netdev_features_direct_andnot(&features,
+					      dev->gso_partial_features);
 	}
 
 	if (!(features & NETIF_F_RXCSUM)) {
@@ -11046,7 +11050,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_direct_or(&all, tmp);
 
 	netdev_features_fill(&tmp);
-	tmp &= ~NETIF_F_ALL_FOR_ALL;
+	netdev_features_direct_andnot(&tmp, NETIF_F_ALL_FOR_ALL);
 	netdev_features_direct_or(&tmp, one);
 	all &= tmp;
 
@@ -11054,7 +11058,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	if (all & NETIF_F_HW_CSUM) {
 		tmp = NETIF_F_CSUM_MASK;
 		netdev_features_clear_bit(NETIF_F_HW_CSUM_BIT, &tmp);
-		all &= ~tmp;
+		netdev_features_direct_andnot(&all, tmp);
 	}
 
 	return all;
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 4a37ada0dcb2..5d54f45d1bfd 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -255,7 +255,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		dev->wanted_features &= ~dev->hw_features;
+		netdev_wanted_features_direct_andnot(dev, dev->hw_features);
 		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
 		netdev_wanted_features_direct_or(dev, tmp);
 		__netdev_update_features(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index ef2cde3594ad..2a552e16954e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -148,17 +148,17 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 					  (netdev_features_t)features[i].requested << (32 * i));
 	}
 
-	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
+	tmp = netdev_features_andnot(valid, NETIF_F_ETHTOOL_BITS);
 	if (tmp)
 		return -EINVAL;
 
-	tmp = valid & ~dev->hw_features;
+	tmp = netdev_hw_features_andnot_r(dev, valid);
 	if (tmp) {
 		valid &= dev->hw_features;
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
-	dev->wanted_features &= ~valid;
+	netdev_wanted_features_direct_andnot(dev, valid);
 	tmp = wanted & valid;
 	netdev_wanted_features_direct_or(dev, tmp);
 	__netdev_update_features(dev);
@@ -300,7 +300,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 	if (edata.data)
 		netdev_wanted_features_direct_or(dev, mask);
 	else
-		dev->wanted_features &= ~mask;
+		netdev_wanted_features_direct_andnot(dev, mask);
 
 	__netdev_update_features(dev);
 
@@ -368,11 +368,11 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	/* allow changing only bits set in hw_features */
 	changed = netdev_active_features_xor(dev, features);
 	changed &= eth_all_features;
-	tmp = changed & ~dev->hw_features;
+	tmp = netdev_hw_features_andnot_r(dev, changed);
 	if (tmp)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-	dev->wanted_features &= ~changed;
+	netdev_wanted_features_direct_andnot(dev, changed);
 	tmp = features & changed;
 	netdev_wanted_features_direct_or(dev, tmp);
 
-- 
2.33.0

