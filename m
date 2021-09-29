Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A00A41C90B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345869AbhI2QBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:01 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24133 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345433AbhI2P7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbF1Xm1z1DHK7;
        Wed, 29 Sep 2021 23:56:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 026/167] net: vlan: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:13 +0800
Message-ID: <20210929155334.12454-27-shenjian15@huawei.com>
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
 include/linux/if_vlan.h | 16 ++++++++------
 net/8021q/vlan.c        | 11 ++++++----
 net/8021q/vlan.h        | 24 ++++++++++++---------
 net/8021q/vlan_core.c   |  6 ++++--
 net/8021q/vlan_dev.c    | 47 ++++++++++++++++++++++++-----------------
 5 files changed, 63 insertions(+), 41 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 2337538ef015..6565a62db842 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -313,9 +313,11 @@ static inline bool eth_type_vlan(__be16 ethertype)
 static inline bool vlan_hw_offload_capable(netdev_features_t features,
 					   __be16 proto)
 {
-	if (proto == htons(ETH_P_8021Q) && features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (proto == htons(ETH_P_8021Q) &&
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
 		return true;
-	if (proto == htons(ETH_P_8021AD) && features & NETIF_F_HW_VLAN_STAG_TX)
+	if (proto == htons(ETH_P_8021AD) &&
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_TX_BIT, features))
 		return true;
 	return false;
 }
@@ -563,7 +565,8 @@ static inline int __vlan_hwaccel_get_tag(const struct sk_buff *skb,
  */
 static inline int vlan_get_tag(const struct sk_buff *skb, u16 *vlan_tci)
 {
-	if (skb->dev->features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    skb->dev->features)) {
 		return __vlan_hwaccel_get_tag(skb, vlan_tci);
 	} else {
 		return __vlan_get_tag(skb, vlan_tci);
@@ -736,9 +739,10 @@ static inline void vlan_features_check(struct sk_buff *skb,
 		 * sure that only devices supporting NETIF_F_HW_CSUM will
 		 * have checksum offloading support.
 		 */
-		*features &= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			     NETIF_F_FRAGLIST | NETIF_F_HW_VLAN_CTAG_TX |
-			     NETIF_F_HW_VLAN_STAG_TX;
+		netdev_feature_and_bits(NETIF_F_SG | NETIF_F_HIGHDMA |
+					NETIF_F_HW_CSUM | NETIF_F_FRAGLIST |
+					NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_STAG_TX, features);
 	}
 }
 
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 55275ef9a31a..8a50deff286a 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -134,7 +134,8 @@ int vlan_check_real_dev(struct net_device *real_dev,
 {
 	const char *name = real_dev->name;
 
-	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
+	if (netdev_feature_test_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				    real_dev->features)) {
 		pr_info("VLANs not supported on %s\n", name);
 		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
 		return -EOPNOTSUPP;
@@ -339,7 +340,7 @@ static void vlan_transfer_features(struct net_device *dev,
 
 	vlandev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	vlandev->priv_flags |= (vlan->real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
-	vlandev->hw_enc_features = vlan_tnl_features(vlan->real_dev);
+	vlan_tnl_features(vlan->real_dev, &vlandev->hw_enc_features);
 
 	netdev_update_features(vlandev);
 }
@@ -386,13 +387,15 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 	}
 
 	if ((event == NETDEV_UP) &&
-	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    dev->features)) {
 		pr_info("adding VLAN 0 to HW filter on device %s\n",
 			dev->name);
 		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
 	}
 	if (event == NETDEV_DOWN &&
-	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    dev->features))
 		vlan_vid_del(dev, htons(ETH_P_8021Q), 0);
 
 	vlan_info = rtnl_dereference(dev->vlan_info);
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 1a705a4ef7fa..9ed1d1c8f547 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -103,17 +103,21 @@ static inline struct net_device *vlan_find_dev(struct net_device *real_dev,
 	return NULL;
 }
 
-static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
+static inline void vlan_tnl_features(struct net_device *real_dev,
+				     netdev_features_t *tnl)
 {
-	netdev_features_t ret;
-
-	ret = real_dev->hw_enc_features &
-	      (NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE |
-	       NETIF_F_GSO_ENCAP_ALL);
-
-	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK))
-		return (ret & ~NETIF_F_CSUM_MASK) | NETIF_F_HW_CSUM;
-	return 0;
+	netdev_feature_zero(tnl);
+	netdev_feature_set_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE |
+				NETIF_F_GSO_ENCAP_ALL, tnl);
+	netdev_feature_and(tnl, *tnl, real_dev->hw_enc_features);
+
+	if (netdev_feature_test_bits(NETIF_F_GSO_ENCAP_ALL, *tnl) &&
+	    netdev_feature_test_bits(NETIF_F_CSUM_MASK, *tnl)) {
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, tnl);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, tnl);
+		return;
+	}
+	netdev_feature_zero(tnl);
 }
 
 #define vlan_group_for_each_dev(grp, i, dev) \
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 59bc13b5f14f..757b2f18978f 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -169,10 +169,12 @@ struct vlan_vid_info {
 static bool vlan_hw_filter_capable(const struct net_device *dev, __be16 proto)
 {
 	if (proto == htons(ETH_P_8021Q) &&
-	    dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    dev->features))
 		return true;
 	if (proto == htons(ETH_P_8021AD) &&
-	    dev->features & NETIF_F_HW_VLAN_STAG_FILTER)
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				    dev->features))
 		return true;
 	return false;
 }
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 9f90a587d4e5..a010612cf27b 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -566,21 +566,24 @@ static int vlan_dev_init(struct net_device *dev)
 	if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 		dev->state |= (1 << __LINK_STATE_NOCARRIER);
 
-	dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG |
-			   NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
-			   NETIF_F_GSO_ENCAP_ALL |
-			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
-			   NETIF_F_ALL_FCOE;
-
-	dev->features |= dev->hw_features | NETIF_F_LLTX;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
+				NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
+				NETIF_F_GSO_ENCAP_ALL |
+				NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
+				NETIF_F_ALL_FCOE, &dev->hw_features);
+
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 	dev->gso_max_size = real_dev->gso_max_size;
 	dev->gso_max_segs = real_dev->gso_max_segs;
-	if (dev->features & NETIF_F_VLAN_FEATURES)
+	if (netdev_feature_test_bits(NETIF_F_VLAN_FEATURES, dev->features))
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
-	dev->vlan_features = real_dev->vlan_features & ~NETIF_F_ALL_FCOE;
-	dev->hw_enc_features = vlan_tnl_features(real_dev);
-	dev->mpls_features = real_dev->mpls_features;
+	netdev_feature_copy(&dev->vlan_features, real_dev->vlan_features);
+	netdev_feature_clear_bits(NETIF_F_ALL_FCOE, &dev->vlan_features);
+	vlan_tnl_features(real_dev, &dev->hw_enc_features);
+	netdev_feature_copy(&dev->mpls_features, real_dev->mpls_features);
 
 	/* ipv6 shared card related stuff */
 	dev->dev_id = real_dev->dev_id;
@@ -637,21 +640,27 @@ static void vlan_dev_fix_features(struct net_device *dev,
 				  netdev_features_t *features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	netdev_features_t old_features = *features;
 	netdev_features_t lower_features;
+	netdev_features_t old_features;
+	netdev_features_t tmp;
 
-	netdev_intersect_features(&lower_features,
-				  (real_dev->vlan_features | NETIF_F_RXCSUM),
-				  real_dev->features);
+	netdev_feature_copy(&tmp, real_dev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &tmp);
+	netdev_feature_copy(&old_features, *features);
+	netdev_intersect_features(&lower_features, tmp, real_dev->features);
 
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
-	if (lower_features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))
-		lower_features |= NETIF_F_HW_CSUM;
+	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     lower_features))
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &lower_features);
 	netdev_intersect_features(features, *features, lower_features);
-	*features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
-	*features |= NETIF_F_LLTX;
+
+	netdev_feature_and_bits(NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE,
+				&old_features);
+	netdev_feature_or(features, *features, old_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, features);
 }
 
 static int vlan_ethtool_get_link_ksettings(struct net_device *dev,
-- 
2.33.0

