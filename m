Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825275BBCFB
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiIRJup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiIRJuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEB613E97
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjfB4CmWzHnhx;
        Sun, 18 Sep 2022 17:47:46 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:52 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 36/55] net: adjust the prototype of netdev_increment_features()
Date:   Sun, 18 Sep 2022 09:43:17 +0000
Message-ID: <20220918094336.28958-37-shenjian15@huawei.com>
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

The function netdev_increment_features() returns netdev_features_t
directly. For the prototype of netdev_features_t will be extended
to be larger than 8 bytes, so change the prototype of the function,
return the features pointer as output parameters.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c  | 28 +++++++++++-----------
 drivers/net/ipvlan/ipvlan_main.c |  4 ++--
 drivers/net/macvlan.c            |  3 ++-
 drivers/net/net_failover.c       | 28 ++++++++++------------
 drivers/net/team/team.c          | 18 +++++++-------
 include/linux/netdevice.h        |  9 ++++---
 net/bridge/br_if.c               |  4 ++--
 net/core/dev.c                   | 40 +++++++++++++++++++-------------
 net/hsr/hsr_device.c             |  5 ++--
 9 files changed, 72 insertions(+), 67 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 769ae7a6b800..5c76a55392aa 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1417,9 +1417,8 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
-		features = netdev_increment_features(features,
-						     slave->dev->features,
-						     mask);
+		netdev_increment_features(&features, &features,
+					  &slave->dev->features, &mask);
 	}
 	features = netdev_add_tso_features(features, mask);
 
@@ -1455,22 +1454,23 @@ static void bond_compute_features(struct bonding *bond)
 	netdev_features_mask(mpls_features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
-		vlan_features = netdev_increment_features(vlan_features,
-			slave->dev->vlan_features, BOND_VLAN_FEATURES);
+		netdev_increment_features(&vlan_features, &vlan_features,
+					  &slave->dev->vlan_features,
+					  &BOND_VLAN_FEATURES);
 
-		enc_features = netdev_increment_features(enc_features,
-							 slave->dev->hw_enc_features,
-							 BOND_ENC_FEATURES);
+		netdev_increment_features(&enc_features, &enc_features,
+					  &slave->dev->hw_enc_features,
+					  &BOND_ENC_FEATURES);
 
 #ifdef CONFIG_XFRM_OFFLOAD
-		xfrm_features = netdev_increment_features(xfrm_features,
-							  slave->dev->hw_enc_features,
-							  BOND_XFRM_FEATURES);
+		netdev_increment_features(&xfrm_features, &xfrm_features,
+					  &slave->dev->hw_enc_features,
+					  &BOND_XFRM_FEATURES);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
-		mpls_features = netdev_increment_features(mpls_features,
-							  slave->dev->mpls_features,
-							  BOND_MPLS_FEATURES);
+		netdev_increment_features(&mpls_features, &mpls_features,
+					  &slave->dev->mpls_features,
+					  &BOND_MPLS_FEATURES);
 
 		dst_release_flag &= slave->dev->priv_flags;
 		if (slave->dev->hard_header_len > max_hard_header_len)
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index d2c56abbaf5c..e7737e7938fd 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -238,8 +238,8 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 	netdev_features_clear(tmp, IPVLAN_FEATURES);
 	netdev_features_set(tmp, ipvlan->sfeatures);
 	netdev_features_mask(features, tmp);
-	features = netdev_increment_features(ipvlan->phy_dev->features,
-					     features, features);
+	netdev_increment_features(&features, &ipvlan->phy_dev->features,
+				  &features, &features);
 	netdev_features_set(features, IPVLAN_ALWAYS_ON);
 	netdev_features_or(tmp, IPVLAN_FEATURES, IPVLAN_ALWAYS_ON);
 	netdev_features_mask(features, tmp);
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 858eb9329945..1e357643fd43 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1091,7 +1091,8 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	tmp = features;
 	netdev_feature_del(NETIF_F_LRO_BIT, tmp);
 	netdev_features_mask(lowerdev_features, tmp);
-	features = netdev_increment_features(lowerdev_features, features, mask);
+	netdev_increment_features(&features, &lowerdev_features, &features,
+				  &mask);
 	netdev_features_set(features, ALWAYS_ON_FEATURES);
 	netdev_features_or(tmp, ALWAYS_ON_FEATURES, MACVLAN_FEATURES);
 	netdev_features_mask(features, tmp);
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index eed4e0ac18be..d0b72fd696d3 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -396,14 +396,12 @@ static void net_failover_compute_features(struct net_device *dev)
 
 	primary_dev = rcu_dereference(nfo_info->primary_dev);
 	if (primary_dev) {
-		vlan_features =
-			netdev_increment_features(vlan_features,
-						  primary_dev->vlan_features,
-						  FAILOVER_VLAN_FEATURES);
-		enc_features =
-			netdev_increment_features(enc_features,
-						  primary_dev->hw_enc_features,
-						  FAILOVER_ENC_FEATURES);
+		netdev_increment_features(&vlan_features, &vlan_features,
+					  &primary_dev->vlan_features,
+					  &FAILOVER_VLAN_FEATURES);
+		netdev_increment_features(&enc_features, &enc_features,
+					  &primary_dev->hw_enc_features,
+					  &FAILOVER_ENC_FEATURES);
 
 		dst_release_flag &= primary_dev->priv_flags;
 		if (primary_dev->hard_header_len > max_hard_header_len)
@@ -412,14 +410,12 @@ static void net_failover_compute_features(struct net_device *dev)
 
 	standby_dev = rcu_dereference(nfo_info->standby_dev);
 	if (standby_dev) {
-		vlan_features =
-			netdev_increment_features(vlan_features,
-						  standby_dev->vlan_features,
-						  FAILOVER_VLAN_FEATURES);
-		enc_features =
-			netdev_increment_features(enc_features,
-						  standby_dev->hw_enc_features,
-						  FAILOVER_ENC_FEATURES);
+		netdev_increment_features(&vlan_features, &vlan_features,
+					  &standby_dev->vlan_features,
+					  &FAILOVER_VLAN_FEATURES);
+		netdev_increment_features(&enc_features, &enc_features,
+					  &standby_dev->hw_enc_features,
+					  &FAILOVER_ENC_FEATURES);
 
 		dst_release_flag &= standby_dev->priv_flags;
 		if (standby_dev->hard_header_len > max_hard_header_len)
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 7c9e16d9e16b..8d3a97d2d1dc 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1000,13 +1000,12 @@ static void __team_compute_features(struct team *team)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		vlan_features = netdev_increment_features(vlan_features,
-					port->dev->vlan_features,
-					TEAM_VLAN_FEATURES);
-		enc_features =
-			netdev_increment_features(enc_features,
-						  port->dev->hw_enc_features,
-						  TEAM_ENC_FEATURES);
+		netdev_increment_features(&vlan_features, &vlan_features,
+					  &port->dev->vlan_features,
+					  &TEAM_VLAN_FEATURES);
+		netdev_increment_features(&enc_features, &enc_features,
+					  &port->dev->hw_enc_features,
+					  &TEAM_ENC_FEATURES);
 
 
 		dst_release_flag &= port->dev->priv_flags;
@@ -2014,9 +2013,8 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		features = netdev_increment_features(features,
-						     port->dev->features,
-						     mask);
+		netdev_increment_features(&features, &features,
+					  &port->dev->features, &mask);
 	}
 	rcu_read_unlock();
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a9e231ea116e..3f451906d62c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4890,8 +4890,10 @@ extern const struct kobj_ns_type_operations net_ns_type_operations;
 
 const char *netdev_drivername(const struct net_device *dev);
 
-netdev_features_t netdev_increment_features(netdev_features_t all,
-	netdev_features_t one, netdev_features_t mask);
+void netdev_increment_features(netdev_features_t *ret,
+			       const netdev_features_t *all,
+			       const netdev_features_t *one,
+			       const netdev_features_t *mask);
 
 /* Allow TSO being used on stacked device :
  * Performing the GSO segmentation before last device
@@ -4900,7 +4902,8 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 static inline netdev_features_t netdev_add_tso_features(netdev_features_t features,
 							netdev_features_t mask)
 {
-	return netdev_increment_features(features, NETIF_F_ALL_TSO, mask);
+	netdev_increment_features(&features, &features, &NETIF_F_ALL_TSO, &mask);
+	return features;
 }
 
 int __netdev_update_features(struct net_device *dev);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index ef8dd8a91164..fa348a984aa9 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -545,8 +545,8 @@ netdev_features_t br_features_recompute(struct net_bridge *br,
 	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
 
 	list_for_each_entry(p, &br->port_list, list) {
-		features = netdev_increment_features(features,
-						     p->dev->features, mask);
+		netdev_increment_features(&features, &features,
+					  &p->dev->features, &mask);
 	}
 	features = netdev_add_tso_features(features, mask);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index f790f1986dd3..327f99fbae73 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11154,41 +11154,49 @@ static int dev_cpu_dead(unsigned int oldcpu)
 
 /**
  *	netdev_increment_features - increment feature set by one
+ *	@ret: result feature set
  *	@all: current feature set
  *	@one: new feature set
  *	@mask: mask feature set
  *
  *	Computes a new feature set after adding a device with feature set
  *	@one to the master device with current feature set @all.  Will not
- *	enable anything that is off in @mask. Returns the new feature set.
+ *	enable anything that is off in @mask. Returns the new feature set by
+ *	@ret.
  */
-netdev_features_t netdev_increment_features(netdev_features_t all,
-	netdev_features_t one, netdev_features_t mask)
+void netdev_increment_features(netdev_features_t *ret,
+			       const netdev_features_t *all,
+			       const netdev_features_t *one,
+			       const netdev_features_t *mask)
 {
+	netdev_features_t local_mask;
+	netdev_features_t local_one;
 	netdev_features_t tmp;
 
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, mask))
-		netdev_features_set(mask, NETIF_F_CSUM_MASK);
-	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, mask);
+	netdev_features_copy(*ret, *all);
+	netdev_features_copy(local_one, *one);
+	netdev_features_copy(local_mask, *mask);
+
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, local_mask))
+		netdev_features_set(local_mask, NETIF_F_CSUM_MASK);
+	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, local_mask);
 
 	netdev_features_or(tmp, NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
-	netdev_features_mask(tmp, one);
-	netdev_features_mask(tmp, mask);
-	netdev_features_set(all, tmp);
+	netdev_features_mask(tmp, local_one);
+	netdev_features_mask(tmp, local_mask);
+	netdev_features_set(*ret, tmp);
 
 	netdev_features_fill(tmp);
 	netdev_features_clear(tmp, NETIF_F_ALL_FOR_ALL);
-	netdev_features_set(tmp, one);
-	netdev_features_mask(all, tmp);
+	netdev_features_set(tmp, local_one);
+	netdev_features_mask(*ret, tmp);
 
 	/* If one device supports hw checksumming, set for all. */
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, all)) {
-		tmp = NETIF_F_CSUM_MASK;
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *ret)) {
+		netdev_features_copy(tmp, NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, tmp);
-		netdev_features_clear(all, tmp);
+		netdev_features_clear(*ret, tmp);
 	}
-
-	return all;
 }
 EXPORT_SYMBOL(netdev_increment_features);
 
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 0e37ba6e1569..ae0261a450e6 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -195,9 +195,8 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 */
 	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
 	hsr_for_each_port(hsr, port)
-		features = netdev_increment_features(features,
-						     port->dev->features,
-						     mask);
+		netdev_increment_features(&features, &features,
+					  &port->dev->features, &mask);
 
 	return features;
 }
-- 
2.33.0

