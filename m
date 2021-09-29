Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F4941C907
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345542AbhI2QAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:54 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24132 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344205AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbD6sL9z1DHJj;
        Wed, 29 Sep 2021 23:56:40 +0800 (CST)
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
Subject: [RFCv2 net-next 024/167] net: core: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:11 +0800
Message-ID: <20210929155334.12454-25-shenjian15@huawei.com>
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
 include/linux/netdevice.h |  78 ++++++----
 net/core/dev.c            | 315 +++++++++++++++++++++++---------------
 2 files changed, 236 insertions(+), 157 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7e2678a9d769..56e642a72997 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2271,7 +2271,8 @@ struct net_device {
 
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
+	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, dev->features) ||
+	    dev->xdp_prog)
 		return true;
 	return false;
 }
@@ -4515,25 +4516,28 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 	local_bh_enable();
 }
 
-#define HARD_TX_LOCK(dev, txq, cpu) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
-		__netif_tx_lock(txq, cpu);		\
-	} else {					\
-		__netif_tx_acquire(txq);		\
-	}						\
+#define HARD_TX_LOCK(dev, txq, cpu) {				\
+	if (!netdev_feature_test_bit(NETIF_F_LLTX_BIT,		\
+				     dev->features)) {		\
+		__netif_tx_lock(txq, cpu);			\
+	} else {						\
+		__netif_tx_acquire(txq);			\
+	}							\
 }
 
-#define HARD_TX_TRYLOCK(dev, txq)			\
-	(((dev->features & NETIF_F_LLTX) == 0) ?	\
-		__netif_tx_trylock(txq) :		\
+#define HARD_TX_TRYLOCK(dev, txq)				\
+	(!netdev_feature_test_bit(NETIF_F_LLTX_BIT,		\
+				  dev->features) ?		\
+		__netif_tx_trylock(txq) :			\
 		__netif_tx_acquire(txq))
 
-#define HARD_TX_UNLOCK(dev, txq) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
-		__netif_tx_unlock(txq);			\
-	} else {					\
-		__netif_tx_release(txq);		\
-	}						\
+#define HARD_TX_UNLOCK(dev, txq) {				\
+	if (!netdev_feature_test_bit(NETIF_F_LLTX_BIT,		\
+				     dev->features)) {		\
+		__netif_tx_unlock(txq);				\
+	} else {						\
+		__netif_tx_release(txq);			\
+	}							\
 }
 
 static inline void netif_tx_disable(struct net_device *dev)
@@ -4943,20 +4947,20 @@ static inline bool can_checksum_protocol(netdev_features_t features,
 					 __be16 protocol)
 {
 	if (protocol == htons(ETH_P_FCOE))
-		return !!(features & NETIF_F_FCOE_CRC);
+		return netdev_feature_test_bit(NETIF_F_FCOE_CRC_BIT, features);
 
 	/* Assume this is an IP checksum (not SCTP CRC) */
 
-	if (features & NETIF_F_HW_CSUM) {
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features)) {
 		/* Can checksum everything */
 		return true;
 	}
 
 	switch (protocol) {
 	case htons(ETH_P_IP):
-		return !!(features & NETIF_F_IP_CSUM);
+		return netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, features);
 	case htons(ETH_P_IPV6):
-		return !!(features & NETIF_F_IPV6_CSUM);
+		return netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, features);
 	default:
 		return false;
 	}
@@ -5021,21 +5025,26 @@ static inline void netdev_intersect_features(netdev_features_t *ret,
 					     netdev_features_t f1,
 					     netdev_features_t f2)
 {
-	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
-		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, f1) !=
+	    netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, f2)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, f1))
+			netdev_feature_set_bits(NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM, &f1);
 		else
-			f2 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+			netdev_feature_set_bits(NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM, &f2);
 	}
 
-	*ret = f1 & f2;
+	netdev_feature_and(ret, f1, f2);
 }
 
 static inline void netdev_get_wanted_features(struct net_device *dev,
 					      netdev_features_t *wanted)
 {
-	*wanted = (dev->features & ~dev->hw_features) | dev->wanted_features;
+	netdev_feature_andnot(wanted, dev->features, dev->hw_features);
+	netdev_feature_or(wanted, *wanted, dev->wanted_features);
 }
+
 void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
 			       netdev_features_t one, netdev_features_t mask);
 
@@ -5046,7 +5055,11 @@ void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
 static inline void netdev_add_tso_features(netdev_features_t *features,
 					   netdev_features_t mask)
 {
-	netdev_increment_features(features, *features, NETIF_F_ALL_TSO, mask);
+	netdev_features_t one;
+
+	netdev_feature_zero(&one);
+	netdev_feature_set_bits(NETIF_F_ALL_TSO, &one);
+	netdev_increment_features(features, *features, one, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
@@ -5062,7 +5075,7 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
-	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
+	netdev_features_t feature;
 
 	/* check flags correspondence */
 	BUILD_BUG_ON(SKB_GSO_TCPV4   != (NETIF_F_TSO >> NETIF_F_GSO_SHIFT));
@@ -5085,13 +5098,18 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
 
-	return (features & feature) == feature;
+	netdev_feature_zero(&feature);
+	netdev_feature_set_bits((u64)gso_type << NETIF_F_GSO_SHIFT, &feature);
+
+	return netdev_feature_subset(features, feature);
+
 }
 
 static inline bool skb_gso_ok(struct sk_buff *skb, netdev_features_t features)
 {
 	return net_gso_ok(features, skb_shinfo(skb)->gso_type) &&
-	       (!skb_has_frag_list(skb) || (features & NETIF_F_FRAGLIST));
+	       (!skb_has_frag_list(skb) ||
+	       netdev_feature_test_bit(NETIF_F_FRAGLIST_BIT, features));
 }
 
 static inline bool netif_needs_gso(struct sk_buff *skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 6663dd4ed7ff..17a93ec301b6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1636,10 +1636,10 @@ void dev_disable_lro(struct net_device *dev)
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	dev->wanted_features &= ~NETIF_F_LRO;
+	netdev_feature_clear_bit(NETIF_F_LRO_BIT, &dev->wanted_features);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_LRO))
+	if (unlikely(netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features)))
 		netdev_WARN(dev, "failed to disable LRO!\n");
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
@@ -1657,10 +1657,12 @@ EXPORT_SYMBOL(dev_disable_lro);
  */
 static void dev_disable_gro_hw(struct net_device *dev)
 {
-	dev->wanted_features &= ~NETIF_F_GRO_HW;
+	netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &dev->wanted_features);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_GRO_HW))
+	if (unlikely(netdev_feature_test_bit(NETIF_F_GRO_HW_BIT,
+					     dev->features)))
+
 		netdev_WARN(dev, "failed to disable GRO_HW!\n");
 }
 
@@ -3379,13 +3381,19 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * support segmentation on this frame without needing additional
 	 * work.
 	 */
-	if (features & NETIF_F_GSO_PARTIAL) {
-		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
+	if (netdev_feature_test_bit(NETIF_F_GSO_PARTIAL_BIT, features)) {
+		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->features & dev->gso_partial_features;
-		if (!skb_gso_ok(skb, features | partial_features))
-			features &= ~NETIF_F_GSO_PARTIAL;
+		netdev_feature_and(&partial_features, dev->features,
+				   dev->gso_partial_features);
+		netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT,
+				       &partial_features);
+		netdev_feature_or(&partial_features, partial_features,
+				  features);
+		if (!skb_gso_ok(skb, partial_features))
+			netdev_feature_clear_bit(NETIF_F_GSO_PARTIAL_BIT,
+						 &features);
 	}
 
 	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
@@ -3428,7 +3436,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 #ifdef CONFIG_HIGHMEM
 	int i;
 
-	if (!(dev->features & NETIF_F_HIGHDMA)) {
+	if (!netdev_feature_test_bit(NETIF_F_HIGHDMA_BIT, dev->features)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -3448,7 +3456,8 @@ static void net_mpls_features(struct sk_buff *skb, netdev_features_t *features,
 			      __be16 type)
 {
 	if (eth_p_mpls(type))
-		*features &= skb->dev->mpls_features;
+		netdev_feature_and(features, *features,
+				   skb->dev->mpls_features);
 }
 #else
 static void net_mpls_features(struct sk_buff *skb, netdev_features_t *features,
@@ -3466,10 +3475,11 @@ static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(*features, type)) {
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					  features);
 	}
 	if (illegal_highdma(skb->dev, skb))
-		*features &= ~NETIF_F_SG;
+		netdev_feature_clear_bit(NETIF_F_SG_BIT, features);
 }
 
 void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
@@ -3492,13 +3502,13 @@ static void gso_features_check(const struct sk_buff *skb,
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
 	if (gso_segs > dev->gso_max_segs) {
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 		return;
 	}
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 		return;
 	}
 
@@ -3509,7 +3519,8 @@ static void gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		*features &= ~dev->gso_partial_features;
+		netdev_feature_andnot(features, *features,
+				      dev->gso_partial_features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -3519,7 +3530,8 @@ static void gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			*features &= ~NETIF_F_TSO_MANGLEID;
+			netdev_feature_clear_bit(NETIF_F_TSO_MANGLEID_BIT,
+						 features);
 	}
 }
 
@@ -3527,7 +3539,7 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 {
 	struct net_device *dev = skb->dev;
 
-	*features = dev->features;
+	netdev_feature_copy(features, dev->features);
 
 	if (skb_is_gso(skb))
 		gso_features_check(skb, dev, features);
@@ -3537,13 +3549,16 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		*features &= dev->hw_enc_features;
+		netdev_feature_and(features, *features, dev->hw_enc_features);
+
+	if (skb_vlan_tagged(skb)) {
+		netdev_features_t tmp;
 
-	if (skb_vlan_tagged(skb))
-		netdev_intersect_features(features, *features,
-					  dev->vlan_features |
-					  NETIF_F_HW_VLAN_CTAG_TX |
-					  NETIF_F_HW_VLAN_STAG_TX);
+		netdev_feature_copy(&tmp, dev->vlan_features);
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX_BIT |
+					NETIF_F_HW_VLAN_STAG_TX_BIT, &tmp);
+		netdev_intersect_features(features, *features, tmp);
+	}
 
 	if (dev->netdev_ops->ndo_features_check)
 		dev->netdev_ops->ndo_features_check(skb, dev, features);
@@ -3613,13 +3628,14 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features)
 {
 	if (unlikely(skb_csum_is_sctp(skb)))
-		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
-			skb_crc32c_csum_help(skb);
+		return netdev_feature_test_bit(NETIF_F_SCTP_CRC_BIT, features) ?
+			0 : skb_crc32c_csum_help(skb);
 
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features))
 		return 0;
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     features)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -4351,7 +4367,8 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 		/* Should we steer this flow to a different hardware queue? */
 		if (!skb_rx_queue_recorded(skb) || !dev->rx_cpu_rmap ||
-		    !(dev->features & NETIF_F_NTUPLE))
+		    !netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+					     dev->features))
 			goto out;
 		rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap, next_cpu);
 		if (rxq_index == skb_get_rx_queue(skb))
@@ -9786,17 +9803,19 @@ static void netdev_sync_upper_features(struct net_device *lower,
 				       struct net_device *upper,
 				       netdev_features_t *features)
 {
-	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
+	netdev_features_t upper_disables;
 	int feature_bit;
 
+	netdev_feature_zero(&upper_disables);
+	netdev_feature_set_bits(NETIF_F_UPPER_DISABLES, &upper_disables);
+
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(upper->wanted_features & feature) &&
-		    (*features & feature)) {
-			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
-				   &feature, upper->name);
-			*features &= ~feature;
+		if (!netdev_feature_test_bit(feature_bit,
+					     upper->wanted_features) &&
+		    netdev_feature_test_bit(feature_bit, *features)) {
+			netdev_dbg(lower, "Dropping feature bit %d, upper dev %s has it off.\n",
+				   feature_bit, upper->name);
+			netdev_feature_clear_bit(feature_bit, features);
 		}
 	}
 }
@@ -9804,21 +9823,25 @@ static void netdev_sync_upper_features(struct net_device *lower,
 static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t features)
 {
-	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
+	netdev_features_t upper_disables;
 	int feature_bit;
 
+	netdev_feature_zero(&upper_disables);
+	netdev_feature_set_bits(NETIF_F_UPPER_DISABLES, &upper_disables);
+
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(features & feature) && (lower->features & feature)) {
-			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
-				   &feature, lower->name);
-			lower->wanted_features &= ~feature;
+		if (!netdev_feature_test_bit(feature_bit, features) &&
+		    netdev_feature_test_bit(feature_bit, lower->features)) {
+			netdev_dbg(upper, "Disabling feature bit %d on lower dev %s.\n",
+				   feature_bit, lower->name);
+			netdev_feature_clear_bit(feature_bit,
+						 &lower->wanted_features);
 			__netdev_update_features(lower);
 
-			if (unlikely(lower->features & feature))
-				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
-					    &feature, lower->name);
+			if (unlikely(netdev_feature_test_bit(feature_bit,
+							     lower->features)))
+				netdev_WARN(upper, "failed to disable feature bit %d on %s!\n",
+					    feature_bit, lower->name);
 			else
 				netdev_features_change(lower);
 		}
@@ -9829,92 +9852,102 @@ static void netdev_fix_features(struct net_device *dev,
 				netdev_features_t *features)
 {
 	/* Fix illegal checksum combinations */
-	if ((*features & NETIF_F_HW_CSUM) &&
-	    (*features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))) {
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features) &&
+	    netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     *features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		*features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+		netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+					  features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((*features & NETIF_F_ALL_TSO) && !(*features & NETIF_F_SG)) {
+	if (netdev_feature_test_bits(NETIF_F_ALL_TSO, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_SG_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		*features &= ~NETIF_F_ALL_TSO;
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 	}
 
-	if ((*features & NETIF_F_TSO) && !(*features & NETIF_F_HW_CSUM) &&
-	    !(*features & NETIF_F_IP_CSUM)) {
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		*features &= ~NETIF_F_TSO;
-		*features &= ~NETIF_F_TSO_ECN;
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
+		netdev_feature_clear_bit(NETIF_F_TSO_ECN_BIT, features);
 	}
 
-	if ((*features & NETIF_F_TSO6) && !(*features & NETIF_F_HW_CSUM) &&
-	    !(*features & NETIF_F_IPV6_CSUM)) {
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		*features &= ~NETIF_F_TSO6;
+		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if ((*features & NETIF_F_TSO_MANGLEID) && !(*features & NETIF_F_TSO))
-		*features &= ~NETIF_F_TSO_MANGLEID;
+	if (netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_TSO_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_TSO_MANGLEID_BIT, features);
 
 	/* TSO ECN requires that TSO is present as well. */
-	if ((*features & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
-		*features &= ~NETIF_F_TSO_ECN;
+	if (netdev_feature_test_bit(NETIF_F_TSO_ECN_BIT, *features) &&
+	    !netdev_feature_test_bits(NETIF_F_ALL_TSO & ~NETIF_F_TSO_ECN,
+				      *features))
+		netdev_feature_clear_bit(NETIF_F_TSO_ECN_BIT, features);
 
 	/* Software GSO depends on SG. */
-	if ((*features & NETIF_F_GSO) && !(*features & NETIF_F_SG)) {
+	if (netdev_feature_test_bit(NETIF_F_GSO_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_SG_BIT, *features)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		*features &= ~NETIF_F_GSO;
+		netdev_feature_clear_bit(NETIF_F_GSO_BIT, features);
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if ((*features & dev->gso_partial_features) &&
-	    !(*features & NETIF_F_GSO_PARTIAL)) {
+	if (netdev_feature_intersects(*features, dev->gso_partial_features) &&
+	    !netdev_feature_test_bit(NETIF_F_GSO_PARTIAL_BIT, *features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		*features &= ~dev->gso_partial_features;
+		netdev_feature_andnot(features, *features,
+				      dev->gso_partial_features);
 	}
 
-	if (!(*features & NETIF_F_RXCSUM)) {
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (*features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			*features &= ~NETIF_F_GRO_HW;
+			netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (*features & NETIF_F_RXFCS) {
-		if (*features & NETIF_F_LRO) {
+	if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT, *features)) {
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			*features &= ~NETIF_F_LRO;
+			netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 		}
 
-		if (*features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			*features &= ~NETIF_F_GRO_HW;
+			netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
-	if (*features & NETIF_F_HW_TLS_TX) {
-		bool ip_csum = (*features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
-			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-		bool hw_csum = *features & NETIF_F_HW_CSUM;
-
-		if (!ip_csum && !hw_csum) {
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_TX_BIT, *features)) {
+		if ((!netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, *features) ||
+		     !netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, *features)) &&
+		    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features)) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			*features &= ~NETIF_F_HW_TLS_TX;
+			netdev_feature_clear_bit(NETIF_F_HW_TLS_TX_BIT,
+						 features);
 		}
 	}
 
-	if ((*features & NETIF_F_HW_TLS_RX) && !(*features & NETIF_F_RXCSUM)) {
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		*features &= ~NETIF_F_HW_TLS_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_TLS_RX_BIT, features);
 	}
 }
 
@@ -9939,7 +9972,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		netdev_sync_upper_features(dev, upper, &features);
 
-	if (dev->features == features)
+	if (netdev_feature_equal(dev->features, features))
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
@@ -9968,9 +10001,11 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->features;
+		netdev_features_t diff;
+
+		netdev_feature_xor(&diff, features, dev->features);
 
-		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
+		if (netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, diff)) {
 			/* udp_tunnel_{get,drop}_rx_info both need
 			 * NETIF_F_RX_UDP_TUNNEL_PORT enabled on the
 			 * device, or they won't do anything.
@@ -9978,33 +10013,36 @@ int __netdev_update_features(struct net_device *dev)
 			 * *before* calling udp_tunnel_get_rx_info,
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
-			if (features & NETIF_F_RX_UDP_TUNNEL_PORT) {
-				dev->features = features;
+			if (netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+						    features)) {
+				netdev_feature_copy(&dev->features, features);
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-				dev->features = features;
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
+			if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						    features)) {
+				netdev_feature_copy(&dev->features, features);
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_STAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_STAG_FILTER) {
-				dev->features = features;
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
+			if (netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+						    features)) {
+				netdev_feature_copy(&dev->features, features);
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		dev->features = features;
+		netdev_feature_copy(&dev->features, features);
 	}
 
 	return err < 0 ? 0 : 1;
@@ -10230,8 +10268,10 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if (((dev->hw_features | dev->features) &
-	     NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				     dev->hw_features) ||
+	     netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				     dev->features)) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
 		netdev_WARN(dev, "Buggy VLAN acceleration in driver!\n");
@@ -10248,44 +10288,54 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
-	dev->features |= NETIF_F_SOFT_FEATURES;
+	netdev_feature_set_bits(NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF,
+				&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SOFT_FEATURES, &dev->features);
 
 	if (dev->udp_tunnel_nic_info) {
-		dev->features |= NETIF_F_RX_UDP_TUNNEL_PORT;
-		dev->hw_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
+		netdev_feature_set_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+				       &dev->features);
+		netdev_feature_set_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+				       &dev->hw_features);
 	}
 
-	dev->wanted_features = dev->features & dev->hw_features;
+	netdev_feature_and(&dev->wanted_features, dev->features,
+			   dev->hw_features);
 
 	if (!(dev->flags & IFF_LOOPBACK))
-		dev->hw_features |= NETIF_F_NOCACHE_COPY;
+		netdev_feature_set_bit(NETIF_F_NOCACHE_COPY_BIT,
+				       &dev->hw_features);
 
 	/* If IPv4 TCP segmentation offload is supported we should also
 	 * allow the device to enable segmenting the frame with the option
 	 * of ignoring a static IP ID value.  This doesn't enable the
 	 * feature itself but allows the user to enable it later.
 	 */
-	if (dev->hw_features & NETIF_F_TSO)
-		dev->hw_features |= NETIF_F_TSO_MANGLEID;
-	if (dev->vlan_features & NETIF_F_TSO)
-		dev->vlan_features |= NETIF_F_TSO_MANGLEID;
-	if (dev->mpls_features & NETIF_F_TSO)
-		dev->mpls_features |= NETIF_F_TSO_MANGLEID;
-	if (dev->hw_enc_features & NETIF_F_TSO)
-		dev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->hw_features))
+		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+				       &dev->hw_features);
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->vlan_features))
+		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+				       &dev->vlan_features);
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->mpls_features))
+		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+				       &dev->mpls_features);
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->hw_enc_features))
+		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+				       &dev->hw_enc_features);
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
-	dev->vlan_features |= NETIF_F_HIGHDMA;
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->vlan_features);
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG | NETIF_F_GSO_PARTIAL;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_GSO_PARTIAL,
+				&dev->hw_enc_features);
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
-	dev->mpls_features |= NETIF_F_SG;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->mpls_features);
 
 	ret = call_netdevice_notifiers(NETDEV_POST_INIT, dev);
 	ret = notifier_to_errno(ret);
@@ -11126,7 +11176,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* Don't allow namespace local devices to be moved. */
 	err = -EINVAL;
-	if (dev->features & NETIF_F_NETNS_LOCAL)
+	if (netdev_feature_test_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features))
 		goto out;
 
 	/* Ensure the device has been registrered */
@@ -11323,18 +11373,28 @@ static int dev_cpu_dead(unsigned int oldcpu)
 void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
 			       netdev_features_t one, netdev_features_t mask)
 {
-	if (mask & NETIF_F_HW_CSUM)
-		mask |= NETIF_F_CSUM_MASK;
-	mask |= NETIF_F_VLAN_CHALLENGED;
+	netdev_features_t tmp;
 
-	all |= one & (NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK) & mask;
-	all &= one | ~NETIF_F_ALL_FOR_ALL;
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, mask))
+		netdev_feature_set_bits(NETIF_F_CSUM_MASK, &mask);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
-	/* If one device supports hw checksumming, set for all. */
-	if (all & NETIF_F_HW_CSUM)
-		all &= ~(NETIF_F_CSUM_MASK & ~NETIF_F_HW_CSUM);
+	netdev_feature_copy(ret, all);
+	netdev_feature_zero(&tmp);
+	netdev_feature_set_bits(NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK, &tmp);
+	netdev_feature_and(&tmp, tmp, one);
+	netdev_feature_and(&tmp, tmp, mask);
+	netdev_feature_or(ret, *ret, tmp);
 
-	*ret = all;
+	netdev_feature_fill(&tmp);
+	netdev_feature_clear_bits(NETIF_F_ALL_FOR_ALL, &tmp);
+	netdev_feature_or(&tmp, tmp, one);
+	netdev_feature_and(ret, *ret, tmp);
+
+	/* If one device supports hw checksumming, set for all. */
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *ret))
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK & ~NETIF_F_HW_CSUM,
+					  ret);
 }
 EXPORT_SYMBOL(netdev_increment_features);
 
@@ -11487,7 +11547,8 @@ static void __net_exit default_device_exit(struct net *net)
 		char fb_name[IFNAMSIZ];
 
 		/* Ignore unmoveable devices (i.e. loopback) */
-		if (dev->features & NETIF_F_NETNS_LOCAL)
+		if (netdev_feature_test_bit(NETIF_F_NETNS_LOCAL_BIT,
+					    dev->features))
 			continue;
 
 		/* Leave virtual devices for the generic cleanup */
-- 
2.33.0

