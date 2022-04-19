Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4001550621D
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344748AbiDSCbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344578AbiDSCa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223092C12C
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kj71x5dl2zFq31;
        Tue, 19 Apr 2022 10:25:25 +0800 (CST)
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
Subject: [RFCv6 PATCH net-next 11/19] net: use netdev_features_andnot helpers
Date:   Tue, 19 Apr 2022 10:21:58 +0800
Message-ID: <20220419022206.36381-12-shenjian15@huawei.com>
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

Replace the '& ~' and '&= ~' operations of features by
netdev_features_andnot helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  5 ++--
 drivers/net/ethernet/sfc/efx.c                |  4 ++--
 drivers/net/ethernet/sfc/efx_common.c         |  9 ++++----
 drivers/net/ethernet/sfc/falcon/efx.c         |  7 +++---
 include/linux/netdev_features_helper.h        |  2 +-
 net/core/dev.c                                | 23 ++++++++++---------
 net/ethtool/features.c                        |  2 +-
 net/ethtool/ioctl.c                           | 12 +++++-----
 8 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fca355329040..38706313aa6c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2478,7 +2478,8 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(&features,
+				      netdev_csum_gso_features_mask);
 
 	return features;
 }
@@ -3326,7 +3327,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev_features_zero(&vlan_off_features);
 	netdev_features_set_array(&hns3_vlan_off_feature_set,
 				  &vlan_off_features);
-	features = netdev->features & ~vlan_off_features;
+	features = netdev_active_features_andnot(netdev, vlan_off_features);
 	netdev_vlan_features_set(netdev, features);
 
 	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index e37007839e2f..89c62304b5c3 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1024,12 +1024,12 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+		netdev_active_features_clear(net_dev, NETIF_F_ALL_TSO);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
-	tmp = net_dev->features & ~efx->fixed_features;
+	tmp = netdev_active_features_andnot(net_dev, efx->fixed_features);
 	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 5d3be6c4df54..8b95525aad20 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -216,7 +216,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	tmp = net_dev->features & ~data;
+	tmp = netdev_active_features_andnot(net_dev, data);
 	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
@@ -415,7 +415,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	 */
 	old_features = efx->net_dev->features;
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
-	efx->net_dev->hw_features &= ~efx->fixed_features;
+	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
@@ -1370,10 +1370,11 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				features &= ~(NETIF_F_GSO_MASK);
+				netdev_features_clear(&features, NETIF_F_GSO_MASK);
 		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~netdev_csum_gso_features_mask;
+				netdev_features_clear(&features,
+						      netdev_csum_gso_features_mask);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index d2056fbaa3d1..921617de3638 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -642,7 +642,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	 */
 	old_features = efx->net_dev->features;
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
-	efx->net_dev->hw_features &= ~efx->fixed_features;
+	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
@@ -2193,7 +2193,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	tmp = net_dev->features & ~data;
+	tmp = netdev_active_features_andnot(net_dev, data);
 	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
@@ -2919,7 +2919,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
-	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
+	net_dev->hw_features = netdev_active_features_andnot(net_dev,
+							     efx->fixed_features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index 7e2d66a5b803..067b90ca3084 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -603,7 +603,7 @@ netdev_get_wanted_features(struct net_device *dev)
 {
 	netdev_features_t tmp;
 
-	tmp = dev->features & ~dev->hw_features;
+	tmp = netdev_active_features_andnot(dev, dev->hw_features);
 	return netdev_wanted_features_or(dev, tmp);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 4ea8231ecdee..124d48b5d61a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3433,7 +3433,8 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(&features,
+				      netdev_csum_gso_features_mask);
 	}
 	if (illegal_highdma(skb->dev, skb))
 		netdev_feature_del(NETIF_F_SG_BIT, &features);
@@ -3463,11 +3464,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
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
@@ -3477,7 +3478,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		features &= ~dev->gso_partial_features;
+		netdev_features_clear(&features, dev->gso_partial_features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -9464,7 +9465,7 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 		    && (features & feature)) {
 			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
 				   &feature, upper->name);
-			features &= ~feature;
+			netdev_features_clear(&features, feature);
 		}
 	}
 
@@ -9484,7 +9485,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
 		if (!(features & feature) && (lower->features & feature)) {
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
-			lower->wanted_features &= ~feature;
+			netdev_wanted_features_clear(lower, feature);
 			__netdev_update_features(lower);
 
 			if (unlikely(lower->features & feature))
@@ -9505,13 +9506,13 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_HW_CSUM) &&
 	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~netdev_ip_csum_features;
+		netdev_features_clear(&features, netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
 	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 	}
 
 	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
@@ -9548,7 +9549,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	    !(features & NETIF_F_GSO_PARTIAL)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		features &= ~dev->gso_partial_features;
+		netdev_features_clear(&features, dev->gso_partial_features);
 	}
 
 	if (!(features & NETIF_F_RXCSUM)) {
@@ -11066,7 +11067,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_set(&all, tmp);
 
 	netdev_features_fill(&tmp);
-	tmp &= ~NETIF_F_ALL_FOR_ALL;
+	netdev_features_clear(&tmp, NETIF_F_ALL_FOR_ALL);
 	netdev_features_set(&tmp, one);
 	all &= tmp;
 
@@ -11074,7 +11075,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	if (all & NETIF_F_HW_CSUM) {
 		tmp = NETIF_F_CSUM_MASK;
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, &tmp);
-		all &= ~tmp;
+		netdev_features_clear(&all, tmp);
 	}
 
 	return all;
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 8e753afc0824..2de4cabf41e0 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -256,7 +256,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		dev->wanted_features &= ~dev->hw_features;
+		netdev_wanted_features_clear(dev, dev->hw_features);
 		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
 		netdev_wanted_features_set(dev, tmp);
 		__netdev_update_features(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 4a685224fba9..3c951a883076 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -149,17 +149,17 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 				    (netdev_features_t)features[i].requested << (32 * i));
 	}
 
-	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
+	tmp = netdev_features_andnot(valid, NETIF_F_ETHTOOL_BITS);
 	if (tmp)
 		return -EINVAL;
 
-	tmp = valid & ~dev->hw_features;
+	netdev_hw_features_andnot_r(dev, valid);
 	if (tmp) {
 		valid &= dev->hw_features;
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
-	dev->wanted_features &= ~valid;
+	netdev_wanted_features_clear(dev, valid);
 	tmp = wanted & valid;
 	netdev_wanted_features_set(dev, tmp);
 	__netdev_update_features(dev);
@@ -301,7 +301,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 	if (edata.data)
 		netdev_wanted_features_set(dev, mask);
 	else
-		dev->wanted_features &= ~mask;
+		netdev_wanted_features_clear(dev, mask);
 
 	__netdev_update_features(dev);
 
@@ -364,11 +364,11 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	/* allow changing only bits set in hw_features */
 	changed = netdev_active_features_xor(dev, features);
 	changed &= eth_all_features;
-	tmp = changed & ~dev->hw_features;
+	tmp = netdev_hw_features_andnot_r(dev, changed);
 	if (tmp)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-	dev->wanted_features &= ~changed;
+	netdev_wanted_features_clear(dev, changed);
 	tmp = features & changed;
 	netdev_wanted_features_set(dev, tmp);
 
-- 
2.33.0

