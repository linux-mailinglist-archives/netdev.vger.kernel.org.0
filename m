Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B565BBD0B
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiIRJvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiIRJuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:23 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D0A17E1E
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjcB0VyYzmV5h;
        Sun, 18 Sep 2022 17:46:02 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:53 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 38/55] net: core: adjust prototype of several functions used in net/core/dev.c
Date:   Sun, 18 Sep 2022 09:43:19 +0000
Message-ID: <20220918094336.28958-39-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several functions in net/core/dev.c using
netdev_features_t as parameters, or returns netdev_features_t
directly, or both. For the prototype of netdev_features_t will
be extended to be larger than 8 bytes, so change the prototype
of the function, change the prototype of input features to
'netdev_features_t *', and return the features pointer as output
parameters.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdev_feature_helpers.h |  11 +-
 include/linux/netdevice.h              |   2 +-
 net/core/dev.c                         | 160 ++++++++++++-------------
 net/openvswitch/datapath.c             |   2 +-
 4 files changed, 81 insertions(+), 94 deletions(-)

diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 31f52db00fa5..60bc021648e4 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -714,14 +714,11 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 	return ret;
 }
 
-static inline netdev_features_t
-netdev_get_wanted_features(struct net_device *dev)
+static inline void
+netdev_get_wanted_features(struct net_device *dev, netdev_features_t *wanted)
 {
-	netdev_features_t tmp;
-
-	netdev_features_andnot(tmp, dev->features, dev->hw_features);
-	netdev_features_set(tmp, dev->wanted_features);
-	return tmp;
+	netdev_features_andnot(*wanted, dev->features, dev->hw_features);
+	netdev_features_set(*wanted, dev->wanted_features);
 }
 
 #endif
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ec9e7cf7efbc..68f950f5a36b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4770,7 +4770,7 @@ void netdev_rss_key_fill(void *buffer, size_t len);
 int skb_checksum_help(struct sk_buff *skb);
 int skb_crc32c_csum_help(struct sk_buff *skb);
 int skb_csum_hwoffload_help(struct sk_buff *skb,
-			    const netdev_features_t features);
+			    const netdev_features_t *features);
 
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				  netdev_features_t features, bool tx_path);
diff --git a/net/core/dev.c b/net/core/dev.c
index 327f99fbae73..ac53e727d88f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3461,41 +3461,33 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
  * instead of standard features for the netdev.
  */
 #if IS_ENABLED(CONFIG_NET_MPLS_GSO)
-static netdev_features_t net_mpls_features(struct sk_buff *skb,
-					   netdev_features_t features,
-					   __be16 type)
+static void net_mpls_features(struct sk_buff *skb, netdev_features_t *features,
+			      __be16 type)
 {
 	if (eth_p_mpls(type))
-		netdev_features_mask(features, skb->dev->mpls_features);
-
-	return features;
+		netdev_features_mask(*features, skb->dev->mpls_features);
 }
 #else
-static netdev_features_t net_mpls_features(struct sk_buff *skb,
-					   netdev_features_t features,
-					   __be16 type)
+static void net_mpls_features(struct sk_buff *skb, netdev_features_t *features,
+			      __be16 type)
 {
-	return features;
 }
 #endif
 
-static netdev_features_t harmonize_features(struct sk_buff *skb,
-	netdev_features_t features)
+static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 {
 	__be16 type;
 
 	type = skb_network_protocol(skb, NULL);
-	features = net_mpls_features(skb, features, type);
+	net_mpls_features(skb, features, type);
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
-	    !can_checksum_protocol(features, type)) {
-		netdev_features_clear(features,
+	    !can_checksum_protocol(*features, type)) {
+		netdev_features_clear(*features,
 				      netdev_csum_gso_features_mask);
 	}
 	if (illegal_highdma(skb->dev, skb))
-		netdev_feature_del(NETIF_F_SG_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_SG_BIT, *features);
 }
 
 netdev_features_t passthru_features_check(struct sk_buff *skb,
@@ -3582,7 +3574,8 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		tmp = dflt_features_check(skb, dev, features);
 	netdev_features_mask(features, tmp);
 
-	return harmonize_features(skb, features);
+	harmonize_features(skb, &features);
+	return features;
 }
 EXPORT_SYMBOL(netif_skb_features);
 
@@ -3641,16 +3634,16 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
 }
 
 int skb_csum_hwoffload_help(struct sk_buff *skb,
-			    const netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	if (unlikely(skb_csum_is_sctp(skb)))
-		return netdev_feature_test(NETIF_F_SCTP_CRC_BIT, features) ? 0 :
+		return netdev_feature_test(NETIF_F_SCTP_CRC_BIT, *features) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *features))
 		return 0;
 
-	if (netdev_features_intersects(features, netdev_ip_csum_features)) {
+	if (netdev_features_intersects(*features, netdev_ip_csum_features)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -3701,7 +3694,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 			else
 				skb_set_transport_header(skb,
 							 skb_checksum_start_offset(skb));
-			if (skb_csum_hwoffload_help(skb, features))
+			if (skb_csum_hwoffload_help(skb, &features))
 				goto out_kfree_skb;
 		}
 	}
@@ -9567,32 +9560,31 @@ static void net_set_todo(struct net_device *dev)
 	atomic_inc(&dev_net(dev)->dev_unreg_count);
 }
 
-static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
-	struct net_device *upper, netdev_features_t features)
+static void netdev_sync_upper_features(struct net_device *lower,
+				       struct net_device *upper,
+				       netdev_features_t *features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
 	int feature_bit;
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		if (!netdev_wanted_feature_test(upper, feature_bit) &&
-		    netdev_feature_test(feature_bit, features)) {
+		    netdev_feature_test(feature_bit, *features)) {
 			netdev_dbg(lower, "Dropping feature bit %d, upper dev %s has it off.\n",
 				   feature_bit, upper->name);
-			netdev_feature_del(feature_bit, features);
+			netdev_feature_del(feature_bit, *features);
 		}
 	}
-
-	return features;
 }
 
 static void netdev_sync_lower_features(struct net_device *upper,
-	struct net_device *lower, netdev_features_t features)
+	struct net_device *lower, netdev_features_t *features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
 	int feature_bit;
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		if (!netdev_feature_test(feature_bit, features) &&
+		if (!netdev_feature_test(feature_bit, *features) &&
 		    netdev_active_feature_test(lower, feature_bit)) {
 			netdev_dbg(upper, "Disabling feature bit %d on lower dev %s.\n",
 				   feature_bit, lower->name);
@@ -9608,116 +9600,114 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	}
 }
 
-static netdev_features_t netdev_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void netdev_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	netdev_features_t tmp;
 
 	/* Fix illegal checksum combinations */
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
-	    netdev_features_intersects(features, netdev_ip_csum_features)) {
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *features) &&
+	    netdev_features_intersects(*features, netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		netdev_features_clear(features, netdev_ip_csum_features);
+		netdev_features_clear(*features, netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if (netdev_features_intersects(features, NETIF_F_ALL_TSO) &&
-	    !netdev_feature_test(NETIF_F_SG_BIT, features)) {
+	if (netdev_features_intersects(*features, NETIF_F_ALL_TSO) &&
+	    !netdev_feature_test(NETIF_F_SG_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 	}
 
-	if (netdev_feature_test(NETIF_F_TSO_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_IP_CSUM_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_TSO_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_IP_CSUM_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
-		netdev_feature_del(NETIF_F_TSO_ECN_BIT, features);
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
+		netdev_feature_del(NETIF_F_TSO_ECN_BIT, *features);
 	}
 
-	if (netdev_feature_test(NETIF_F_TSO6_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		netdev_feature_del(NETIF_F_TSO6_BIT, features);
+		netdev_feature_del(NETIF_F_TSO6_BIT, *features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if (netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_TSO_BIT, features))
-		netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT, features);
+	if (netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_TSO_BIT, *features))
+		netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT, *features);
 
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
 	netdev_feature_del(NETIF_F_TSO_ECN_BIT, tmp);
-	if (!netdev_features_intersects(features, tmp) &&
-	    netdev_feature_test(NETIF_F_TSO_ECN_BIT, features))
-		netdev_feature_del(NETIF_F_TSO_ECN_BIT, features);
+	if (!netdev_features_intersects(*features, tmp) &&
+	    netdev_feature_test(NETIF_F_TSO_ECN_BIT, *features))
+		netdev_feature_del(NETIF_F_TSO_ECN_BIT, *features);
 
 	/* Software GSO depends on SG. */
-	if (netdev_feature_test(NETIF_F_GSO_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_SG_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_GSO_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_SG_BIT, *features)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		netdev_feature_del(NETIF_F_GSO_BIT, features);
+		netdev_feature_del(NETIF_F_GSO_BIT, *features);
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if (netdev_gso_partial_features_intersects(dev, features) &&
-	    !netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
+	if (netdev_gso_partial_features_intersects(dev, *features) &&
+	    !netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, *features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		netdev_features_clear(features, dev->gso_partial_features);
+		netdev_features_clear(*features, dev->gso_partial_features);
 	}
 
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (netdev_feature_test(NETIF_F_RXFCS_BIT, features)) {
-		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_RXFCS_BIT, *features)) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			netdev_feature_del(NETIF_F_LRO_BIT, features);
+			netdev_feature_del(NETIF_F_LRO_BIT, *features);
 		}
 
-		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 		}
 	}
 
-	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features) &&
-	    netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features) &&
+	    netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 	}
 
-	if (netdev_feature_test(NETIF_F_HW_TLS_TX_BIT, features)) {
-		bool ip_csum = netdev_features_subset(netdev_ip_csum_features, features);
+	if (netdev_feature_test(NETIF_F_HW_TLS_TX_BIT, *features)) {
+		bool ip_csum = netdev_features_subset(netdev_ip_csum_features, *features);
 		bool hw_csum = netdev_feature_test(NETIF_F_HW_CSUM_BIT,
-						   features);
+						   *features);
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, features);
+			netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, *features);
 		}
 	}
 
-	if (netdev_feature_test(NETIF_F_HW_TLS_RX_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_TLS_RX_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, features);
+		netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, *features);
 	}
-
-	return features;
 }
 
 int __netdev_update_features(struct net_device *dev)
@@ -9729,17 +9719,17 @@ int __netdev_update_features(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	features = netdev_get_wanted_features(dev);
+	netdev_get_wanted_features(dev, &features);
 
 	if (dev->netdev_ops->ndo_fix_features)
 		features = dev->netdev_ops->ndo_fix_features(dev, features);
 
 	/* driver might be less strict about feature dependencies */
-	features = netdev_fix_features(dev, features);
+	netdev_fix_features(dev, &features);
 
 	/* some features can't be enabled if they're off on an upper device */
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
-		features = netdev_sync_upper_features(dev, upper, features);
+		netdev_sync_upper_features(dev, upper, &features);
 
 	if (netdev_active_features_equal(dev, features))
 		goto sync_lower;
@@ -9767,7 +9757,7 @@ int __netdev_update_features(struct net_device *dev)
 	 * on an upper device (think: bonding master or bridge)
 	 */
 	netdev_for_each_lower_dev(dev, lower, iter)
-		netdev_sync_lower_features(dev, lower, features);
+		netdev_sync_lower_features(dev, lower, &features);
 
 	if (!err) {
 		netdev_features_t diff;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index f349f13c8029..8885188e8e19 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -448,7 +448,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	netdev_features_zero(feats);
 	/* Complete checksum if needed */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_csum_hwoffload_help(skb, feats)))
+	    (err = skb_csum_hwoffload_help(skb, &feats)))
 		goto out;
 
 	/* Older versions of OVS user space enforce alignment of the last
-- 
2.33.0

