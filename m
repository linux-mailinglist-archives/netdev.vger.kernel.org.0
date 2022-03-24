Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2F4E666D
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351484AbiCXP5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351441AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C726AD105
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KPVBR50HmzfZMH;
        Thu, 24 Mar 2022 23:53:35 +0800 (CST)
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
Subject: [RFCv5 PATCH net-next 15/20] net: use netdev_features_and helpers
Date:   Thu, 24 Mar 2022 23:49:27 +0800
Message-ID: <20220324154932.17557-16-shenjian15@huawei.com>
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

Replace the '&' and '&=' operations of features by
netdev_features_and helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdevice.h |  2 +-
 net/core/dev.c            | 16 ++++++++--------
 net/ethtool/features.c    |  3 ++-
 net/ethtool/ioctl.c       | 10 +++++-----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 294e902c6077..ad24bd0c69a3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5426,7 +5426,7 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 			netdev_features_direct_or(&f2, netdev_ip_csum_features);
 	}
 
-	return f1 & f2;
+	return netdev_features_and(f1, f2);
 }
 
 static inline netdev_features_t netdev_get_wanted_features(
diff --git a/net/core/dev.c b/net/core/dev.c
index 5e92261a047a..a540784c69be 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3325,7 +3325,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features = dev->active_features & dev->gso_partial_features;
+		partial_features = netdev_active_features_and(dev, dev->gso_partial_features);
 		netdev_features_set_bit(NETIF_F_GSO_ROBUST_BIT,
 					&partial_features);
 		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
@@ -3394,7 +3394,7 @@ static netdev_features_t net_mpls_features(struct sk_buff *skb,
 					   __be16 type)
 {
 	if (eth_p_mpls(type))
-		features &= skb->dev->mpls_features;
+		netdev_features_direct_and(&features, skb->dev->mpls_features);
 
 	return features;
 }
@@ -3496,7 +3496,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		features &= dev->hw_enc_features;
+		netdev_features_direct_and(&features, dev->hw_enc_features);
 
 	if (skb_vlan_tagged(skb)) {
 		tmp = netdev_vlan_features_or(dev, netdev_tx_vlan_features);
@@ -3507,7 +3507,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		tmp = dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
 		tmp = dflt_features_check(skb, dev, features);
-	features &= tmp;
+	netdev_features_direct_and(&features, tmp);
 
 	return harmonize_features(skb, features);
 }
@@ -9935,7 +9935,7 @@ int register_netdevice(struct net_device *dev)
 					   NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
-	dev->wanted_features = dev->active_features & dev->hw_features;
+	dev->wanted_features = netdev_active_features_and(dev, dev->hw_enc_features);
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		netdev_hw_features_set_bit(dev, NETIF_F_NOCACHE_COPY_BIT);
@@ -11055,14 +11055,14 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
 	tmp = netdev_features_or(NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
-	tmp &= one;
-	tmp &= mask;
+	netdev_features_direct_and(&tmp, one);
+	netdev_features_direct_and(&tmp, mask);
 	netdev_features_direct_or(&all, tmp);
 
 	netdev_features_fill(&tmp);
 	netdev_features_direct_andnot(&tmp, NETIF_F_ALL_FOR_ALL);
 	netdev_features_direct_or(&tmp, one);
-	all &= tmp;
+	netdev_features_direct_and(&all, tmp);
 
 	/* If one device supports hw checksumming, set for all. */
 	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, all)) {
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 5d54f45d1bfd..24b7a217f835 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -256,7 +256,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		netdev_wanted_features_direct_andnot(dev, dev->hw_features);
-		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		tmp = netdev_hw_features_and(dev,
+					     ethnl_bitmap_to_features(req_wanted));
 		netdev_wanted_features_direct_or(dev, tmp);
 		__netdev_update_features(dev);
 	}
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 2190209b2a0c..578b8be4f03f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -154,12 +154,12 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 
 	tmp = netdev_hw_features_andnot_r(dev, valid);
 	if (tmp) {
-		valid &= dev->hw_features;
+		netdev_features_direct_and(&valid, dev->hw_enc_features);
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
 	netdev_wanted_features_direct_andnot(dev, valid);
-	tmp = wanted & valid;
+	tmp = netdev_features_and(wanted, valid);
 	netdev_wanted_features_direct_or(dev, tmp);
 	__netdev_update_features(dev);
 
@@ -293,7 +293,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EFAULT;
 
 	mask = ethtool_get_feature_mask(ethcmd);
-	mask &= dev->hw_features;
+	netdev_features_direct_and(&mask, dev->hw_enc_features);
 	if (!mask)
 		return -EOPNOTSUPP;
 
@@ -367,13 +367,13 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	/* allow changing only bits set in hw_features */
 	changed = netdev_active_features_xor(dev, features);
-	changed &= eth_all_features;
+	netdev_features_direct_and(&changed, eth_all_features);
 	tmp = netdev_hw_features_andnot_r(dev, changed);
 	if (tmp)
 		return netdev_hw_features_intersects(dev, changed) ? -EINVAL : -EOPNOTSUPP;
 
 	netdev_wanted_features_direct_andnot(dev, changed);
-	tmp = features & changed;
+	tmp = netdev_features_and(features, changed);
 	netdev_wanted_features_direct_or(dev, tmp);
 
 	__netdev_update_features(dev);
-- 
2.33.0

