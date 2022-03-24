Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6B4E665F
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351486AbiCXP5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351454AbiCXP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:53 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95272AD117
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:12 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KPVD444fTz1GD3S;
        Thu, 24 Mar 2022 23:55:00 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 19/20] net: use netdev_xxx_features helpers
Date:   Thu, 24 Mar 2022 23:49:31 +0800
Message-ID: <20220324154932.17557-20-shenjian15@huawei.com>
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

Replace the direct using for features members of netdev
with netdev_xxx_features helpers, for the nic drivers are
not supposed to modify netdev_features directly.

I'mo not sure for this patch is necessary, just keep the
same rule with others.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 ++--
 drivers/net/ethernet/sfc/efx_common.c         |  4 ++--
 drivers/net/ethernet/sfc/falcon/efx.c         |  4 ++--
 drivers/net/ethernet/sfc/falcon/net_driver.h  |  2 +-
 drivers/net/ethernet/sfc/net_driver.h         |  2 +-
 net/core/dev.c                                | 22 ++++++++++---------
 net/ethtool/features.c                        | 15 +++++++------
 net/ethtool/ioctl.c                           | 17 +++++++-------
 8 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1a98e08f0a67..99582611ab54 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3304,7 +3304,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
 		netdev_active_features_set_bit(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev_hw_features_direct_or(netdev, netdev->active_features);
+	netdev_hw_features_direct_or(netdev, netdev_active_features(netdev));
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev_hw_features_clear_bit(netdev,
 					     NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
@@ -3316,7 +3316,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	features = netdev_active_features_andnot(netdev, vlan_off_features);
 	netdev_vlan_features_direct_or(netdev, features);
 
-	netdev_hw_enc_features_direct_or(netdev, netdev->vlan_features);
+	netdev_hw_enc_features_direct_or(netdev, netdev_vlan_features(netdev));
 	netdev_hw_enc_features_set_bit(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index fd6eb74b4fa6..fc7ab298a4db 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -413,9 +413,9 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	old_features = efx->net_dev->active_features;
+	old_features = netdev_active_features(efx->net_dev);
 	netdev_hw_features_direct_or(efx->net_dev,
-				     efx->net_dev->active_features);
+				     netdev_active_features(efx->net_dev));
 	netdev_hw_features_direct_andnot(efx->net_dev, efx->fixed_features);
 	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
 	if (!netdev_active_features_equal(efx->net_dev, old_features))
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 24993c979312..aca275f0e989 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -640,9 +640,9 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	old_features = efx->net_dev->active_features;
+	old_features = netdev_active_features(efx->net_dev);
 	netdev_hw_features_direct_or(efx->net_dev,
-				     efx->net_dev->active_features);
+				     netdev_active_features(efx->net_dev));
 	netdev_hw_features_direct_andnot(efx->net_dev, efx->fixed_features);
 	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
 	if (!netdev_active_features_equal(efx->net_dev, old_features))
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 9c549e89d85e..662162b32429 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1302,7 +1302,7 @@ static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return netdev_active_features_or(net_dev, net_dev->hw_features);
+	return netdev_active_features_or(net_dev, netdev_hw_features(net_dev));
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 989f8584718b..ca0975ad0d13 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1687,7 +1687,7 @@ static inline netdev_features_t efx_supported_features(const struct efx_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return netdev_active_features_or(net_dev, net_dev->hw_features);
+	return netdev_active_features_or(net_dev, netdev_hw_features(net_dev));
 }
 
 /* Get the current TX queue insert index. */
diff --git a/net/core/dev.c b/net/core/dev.c
index 62bfe12b69d9..c7f95ff8cf10 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3172,7 +3172,7 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
 	}
 	skb_dump(KERN_WARNING, skb, false);
 	WARN(1, "%s: caps=(%pNF, %pNF)\n",
-	     name, dev ? &dev->active_features : &null_features,
+	     name, dev ? &netdev_active_features(dev) : &null_features,
 	     skb->sk ? &skb->sk->sk_route_caps : &null_features);
 }
 
@@ -3325,7 +3325,8 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features = netdev_active_features_and(dev, dev->gso_partial_features);
+		partial_features = netdev_active_features_and(dev,
+							      netdev_gso_partial_features(dev));
 		netdev_features_set_bit(NETIF_F_GSO_ROBUST_BIT,
 					&partial_features);
 		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
@@ -3394,7 +3395,8 @@ static netdev_features_t net_mpls_features(struct sk_buff *skb,
 					   __be16 type)
 {
 	if (eth_p_mpls(type))
-		netdev_features_direct_and(&features, skb->dev->mpls_features);
+		netdev_features_direct_and(&features,
+					   netdev_mpls_features(skb->dev));
 
 	return features;
 }
@@ -3463,7 +3465,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
 		netdev_features_direct_andnot(&features,
-					      dev->gso_partial_features);
+					      netdev_gso_partial_features(dev));
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -3486,7 +3488,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	netdev_features_t features;
 	netdev_features_t tmp;
 
-	features = dev->active_features;
+	features = netdev_active_features(dev);
 
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
@@ -3496,7 +3498,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		netdev_features_direct_and(&features, dev->hw_enc_features);
+		netdev_features_direct_and(&features, netdev_hw_enc_features(dev));
 
 	if (skb_vlan_tagged(skb)) {
 		tmp = netdev_vlan_features_or(dev, netdev_tx_vlan_features);
@@ -9534,7 +9536,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
 		netdev_features_direct_andnot(&features,
-					      dev->gso_partial_features);
+					      netdev_gso_partial_features(dev));
 	}
 
 	if (!netdev_features_test_bit(NETIF_F_RXCSUM_BIT, features)) {
@@ -9617,7 +9619,7 @@ int __netdev_update_features(struct net_device *dev)
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
-		&dev->active_features, &features);
+		&netdev_active_features(dev), &features);
 
 	if (dev->netdev_ops->ndo_set_features)
 		err = dev->netdev_ops->ndo_set_features(dev, features);
@@ -9627,7 +9629,7 @@ int __netdev_update_features(struct net_device *dev)
 	if (unlikely(err < 0)) {
 		netdev_err(dev,
 			"set_features() failed (%d); wanted %pNF, left %pNF\n",
-			err, &features, &dev->active_features);
+			err, &features, &netdev_active_features(dev));
 		/* return non-0 since some features might have changed and
 		 * it's better to fire a spurious notification than miss it
 		 */
@@ -9936,7 +9938,7 @@ int register_netdevice(struct net_device *dev)
 	}
 
 	netdev_set_wanted_features(dev,
-				   netdev_active_features_and(dev, dev->hw_enc_features));
+				   netdev_active_features_and(dev, netdev_hw_enc_features(dev)));
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		netdev_hw_features_set_bit(dev, NETIF_F_NOCACHE_COPY_BIT);
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 24b7a217f835..01dd727299ed 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -41,9 +41,9 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 	struct net_device *dev = reply_base->dev;
 	netdev_features_t all_features;
 
-	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
-	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
-	ethnl_features_to_bitmap32(data->active, dev->active_features);
+	ethnl_features_to_bitmap32(data->hw, netdev_hw_features(dev));
+	ethnl_features_to_bitmap32(data->wanted, netdev_wanted_features(dev));
+	ethnl_features_to_bitmap32(data->active, netdev_active_features(dev));
 	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
 	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
 	ethnl_features_to_bitmap32(data->all, all_features);
@@ -237,8 +237,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	dev = req_info.dev;
 
 	rtnl_lock();
-	ethnl_features_to_bitmap(old_active, dev->active_features);
-	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
+	ethnl_features_to_bitmap(old_active, netdev_active_features(dev));
+	ethnl_features_to_bitmap(old_wanted, netdev_wanted_features(dev));
 	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
 				 netdev_features_strings, info->extack);
@@ -255,13 +255,14 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		netdev_wanted_features_direct_andnot(dev, dev->hw_features);
+		netdev_wanted_features_direct_andnot(dev,
+						     netdev_hw_features(dev));
 		tmp = netdev_hw_features_and(dev,
 					     ethnl_bitmap_to_features(req_wanted));
 		netdev_wanted_features_direct_or(dev, tmp);
 		__netdev_update_features(dev);
 	}
-	ethnl_features_to_bitmap(new_active, dev->active_features);
+	ethnl_features_to_bitmap(new_active, netdev_active_features(dev));
 	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
 
 	ret = 0;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 578b8be4f03f..90fb4c2a313d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -96,9 +96,9 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(netdev_features_t));
 
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		features[i].available = (u32)(dev->hw_features >> (32 * i));
-		features[i].requested = (u32)(dev->wanted_features >> (32 * i));
-		features[i].active = (u32)(dev->active_features >> (32 * i));
+		features[i].available = (u32)(netdev_hw_features(dev) >> (32 * i));
+		features[i].requested = (u32)(netdev_wanted_features(dev) >> (32 * i));
+		features[i].active = (u32)(netdev_active_features(dev) >> (32 * i));
 		features[i].never_changed =
 			(u32)(NETIF_F_NEVER_CHANGE >> (32 * i));
 	}
@@ -154,7 +154,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 
 	tmp = netdev_hw_features_andnot_r(dev, valid);
 	if (tmp) {
-		netdev_features_direct_and(&valid, dev->hw_enc_features);
+		netdev_features_direct_and(&valid,
+					   netdev_hw_enc_features(dev));
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
@@ -163,7 +164,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	netdev_wanted_features_direct_or(dev, tmp);
 	__netdev_update_features(dev);
 
-	tmp = netdev_wanted_features_xor(dev, dev->active_features);
+	tmp = netdev_wanted_features_xor(dev, netdev_active_features(dev));
 	if (netdev_features_intersects(tmp, valid))
 		ret |= ETHTOOL_F_WISH;
 
@@ -293,7 +294,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EFAULT;
 
 	mask = ethtool_get_feature_mask(ethcmd);
-	netdev_features_direct_and(&mask, dev->hw_enc_features);
+	netdev_features_direct_and(&mask, netdev_hw_enc_features(dev));
 	if (!mask)
 		return -EOPNOTSUPP;
 
@@ -2840,7 +2841,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 		if (rc < 0)
 			goto out;
 	}
-	old_features = dev->active_features;
+	old_features = netdev_active_features(dev);
 
 	switch (ethcmd) {
 	case ETHTOOL_GSET:
@@ -3055,7 +3056,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	if (dev->ethtool_ops->complete)
 		dev->ethtool_ops->complete(dev);
 
-	if (old_features != dev->active_features)
+	if (old_features != netdev_active_features(dev))
 		netdev_features_change(dev);
 out:
 	if (dev->dev.parent)
-- 
2.33.0

