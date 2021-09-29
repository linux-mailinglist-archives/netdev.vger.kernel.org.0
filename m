Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008A841C92F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344206AbhI2QCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:18 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24131 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245539AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbC6vtLz1DHJY;
        Wed, 29 Sep 2021 23:56:39 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:57 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 016/167] net: convert the prototype of netdev_increment_features
Date:   Wed, 29 Sep 2021 23:51:03 +0800
Message-ID: <20210929155334.12454-17-shenjian15@huawei.com>
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

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
netdev_increment_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c  | 28 ++++++++++++++--------------
 drivers/net/ipvlan/ipvlan_main.c |  4 ++--
 drivers/net/macvlan.c            |  2 +-
 drivers/net/net_failover.c       | 28 ++++++++++++----------------
 drivers/net/team/team.c          | 19 ++++++++-----------
 include/linux/netdevice.h        |  6 +++---
 net/bridge/br_if.c               |  4 ++--
 net/core/dev.c                   |  7 ++++---
 net/hsr/hsr_device.c             |  5 ++---
 9 files changed, 48 insertions(+), 55 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 878c92746ada..b1c13fa3c677 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1382,9 +1382,8 @@ static void bond_fix_features(struct net_device *dev,
 	*features |= NETIF_F_ALL_FOR_ALL;
 
 	bond_for_each_slave(bond, slave, iter) {
-		*features = netdev_increment_features(*features,
-						      slave->dev->features,
-						      mask);
+		netdev_increment_features(features, *features,
+					  slave->dev->features, mask);
 	}
 	netdev_add_tso_features(features, mask);
 }
@@ -1423,22 +1422,23 @@ static void bond_compute_features(struct bonding *bond)
 	mpls_features &= NETIF_F_ALL_FOR_ALL;
 
 	bond_for_each_slave(bond, slave, iter) {
-		vlan_features = netdev_increment_features(vlan_features,
-			slave->dev->vlan_features, BOND_VLAN_FEATURES);
+		netdev_increment_features(&vlan_features, vlan_features,
+					  slave->dev->vlan_features,
+					  BOND_VLAN_FEATURES);
 
-		enc_features = netdev_increment_features(enc_features,
-							 slave->dev->hw_enc_features,
-							 BOND_ENC_FEATURES);
+		netdev_increment_features(&enc_features, enc_features,
+					  slave->dev->hw_enc_features,
+					  BOND_ENC_FEATURES);
 
 #ifdef CONFIG_XFRM_OFFLOAD
-		xfrm_features = netdev_increment_features(xfrm_features,
-							  slave->dev->hw_enc_features,
-							  BOND_XFRM_FEATURES);
+		netdev_increment_features(&xfrm_features, xfrm_features,
+					  slave->dev->hw_enc_features,
+					  BOND_XFRM_FEATURES);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
-		mpls_features = netdev_increment_features(mpls_features,
-							  slave->dev->mpls_features,
-							  BOND_MPLS_FEATURES);
+		netdev_increment_features(&mpls_features, mpls_features,
+					  slave->dev->mpls_features,
+					  BOND_MPLS_FEATURES);
 
 		dst_release_flag &= slave->dev->priv_flags;
 		if (slave->dev->hard_header_len > max_hard_header_len)
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 8fcc91c0b0f4..6a0b7bd2d3ae 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -242,8 +242,8 @@ static void ipvlan_fix_features(struct net_device *dev,
 
 	*features |= NETIF_F_ALL_FOR_ALL;
 	*features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
-	*features = netdev_increment_features(ipvlan->phy_dev->features,
-					      *features, *features);
+	netdev_increment_features(features, ipvlan->phy_dev->features,
+				  *features, *features);
 	*features |= IPVLAN_ALWAYS_ON;
 	*features &= (IPVLAN_FEATURES | IPVLAN_ALWAYS_ON);
 }
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 27cd9c08bb1e..3c408653e864 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1079,7 +1079,7 @@ static void macvlan_fix_features(struct net_device *dev,
 	mask = *features;
 
 	lowerdev_features &= (*features | ~NETIF_F_LRO);
-	*features = netdev_increment_features(lowerdev_features, *features, mask);
+	netdev_increment_features(features, lowerdev_features, *features, mask);
 	*features |= ALWAYS_ON_FEATURES;
 	*features &= (ALWAYS_ON_FEATURES | MACVLAN_FEATURES);
 }
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 2a4892402ed8..878cad216aaf 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -390,14 +390,12 @@ static void net_failover_compute_features(struct net_device *dev)
 
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
+		netdev_increment_features(&vlan_features, vlan_features,
+					  primary_dev->vlan_features,
+					  FAILOVER_VLAN_FEATURES);
+		netdev_increment_features(&enc_features, enc_features,
+					  primary_dev->hw_enc_features,
+					  FAILOVER_ENC_FEATURES);
 
 		dst_release_flag &= primary_dev->priv_flags;
 		if (primary_dev->hard_header_len > max_hard_header_len)
@@ -406,14 +404,12 @@ static void net_failover_compute_features(struct net_device *dev)
 
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
+		netdev_increment_features(&vlan_features, vlan_features,
+					  standby_dev->vlan_features,
+					  FAILOVER_VLAN_FEATURES);
+		netdev_increment_features(&enc_features, enc_features,
+					  standby_dev->hw_enc_features,
+					  FAILOVER_ENC_FEATURES);
 
 		dst_release_flag &= standby_dev->priv_flags;
 		if (standby_dev->hard_header_len > max_hard_header_len)
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 706572b7a313..fa96ee62c91a 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -994,14 +994,12 @@ static void __team_compute_features(struct team *team)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		vlan_features = netdev_increment_features(vlan_features,
-					port->dev->vlan_features,
-					TEAM_VLAN_FEATURES);
-		enc_features =
-			netdev_increment_features(enc_features,
-						  port->dev->hw_enc_features,
-						  TEAM_ENC_FEATURES);
-
+		netdev_increment_features(&vlan_features, vlan_features,
+					  port->dev->vlan_features,
+					  TEAM_VLAN_FEATURES);
+		netdev_increment_features(&enc_features, enc_features,
+					  port->dev->hw_enc_features,
+					  TEAM_ENC_FEATURES);
 
 		dst_release_flag &= port->dev->priv_flags;
 		if (port->dev->hard_header_len > max_hard_header_len)
@@ -2008,9 +2006,8 @@ static void team_fix_features(struct net_device *dev,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		*features = netdev_increment_features(*features,
-						      port->dev->features,
-						      mask);
+		netdev_increment_features(features, *features,
+					  port->dev->features, mask);
 	}
 	rcu_read_unlock();
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e826435ab847..7e2678a9d769 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5036,8 +5036,8 @@ static inline void netdev_get_wanted_features(struct net_device *dev,
 {
 	*wanted = (dev->features & ~dev->hw_features) | dev->wanted_features;
 }
-netdev_features_t netdev_increment_features(netdev_features_t all,
-	netdev_features_t one, netdev_features_t mask);
+void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
+			       netdev_features_t one, netdev_features_t mask);
 
 /* Allow TSO being used on stacked device :
  * Performing the GSO segmentation before last device
@@ -5046,7 +5046,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 static inline void netdev_add_tso_features(netdev_features_t *features,
 					   netdev_features_t mask)
 {
-	*features = netdev_increment_features(*features, NETIF_F_ALL_TSO, mask);
+	netdev_increment_features(features, *features, NETIF_F_ALL_TSO, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 749971ab1088..914ca4b2d07c 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -544,8 +544,8 @@ void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
 	*features &= ~NETIF_F_ONE_FOR_ALL;
 
 	list_for_each_entry(p, &br->port_list, list) {
-		*features = netdev_increment_features(*features,
-						      p->dev->features, mask);
+		netdev_increment_features(features, *features, p->dev->features,
+					  mask);
 	}
 	netdev_add_tso_features(features, mask);
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 58c46131126b..6663dd4ed7ff 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11311,6 +11311,7 @@ static int dev_cpu_dead(unsigned int oldcpu)
 
 /**
  *	netdev_increment_features - increment feature set by one
+ *	@ret: result feature set
  *	@all: current feature set
  *	@one: new feature set
  *	@mask: mask feature set
@@ -11319,8 +11320,8 @@ static int dev_cpu_dead(unsigned int oldcpu)
  *	@one to the master device with current feature set @all.  Will not
  *	enable anything that is off in @mask. Returns the new feature set.
  */
-netdev_features_t netdev_increment_features(netdev_features_t all,
-	netdev_features_t one, netdev_features_t mask)
+void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
+			       netdev_features_t one, netdev_features_t mask)
 {
 	if (mask & NETIF_F_HW_CSUM)
 		mask |= NETIF_F_CSUM_MASK;
@@ -11333,7 +11334,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	if (all & NETIF_F_HW_CSUM)
 		all &= ~(NETIF_F_CSUM_MASK & ~NETIF_F_HW_CSUM);
 
-	return all;
+	*ret = all;
 }
 EXPORT_SYMBOL(netdev_increment_features);
 
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index acaf48a1e136..16e0efd8b528 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -194,9 +194,8 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 */
 	features &= ~NETIF_F_ONE_FOR_ALL;
 	hsr_for_each_port(hsr, port)
-		features = netdev_increment_features(features,
-						     port->dev->features,
-						     mask);
+		netdev_increment_features(&features, features,
+					  port->dev->features, mask);
 
 	return features;
 }
-- 
2.33.0

