Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6465141C919
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345957AbhI2QBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24135 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345473AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbF53r3z1DHKw;
        Wed, 29 Sep 2021 23:56:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 030/167] bonding: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:17 +0800
Message-ID: <20210929155334.12454-31-shenjian15@huawei.com>
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
 drivers/net/bonding/bond_main.c    | 106 ++++++++++++++++++-----------
 drivers/net/bonding/bond_options.c |  12 ++--
 2 files changed, 76 insertions(+), 42 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b1c13fa3c677..9c6f37589733 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1371,15 +1371,15 @@ static void bond_fix_features(struct net_device *dev,
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		*features |= BOND_TLS_FEATURES;
+		netdev_feature_set_bits(BOND_TLS_FEATURES, features);
 	else
-		*features &= ~BOND_TLS_FEATURES;
+		netdev_feature_clear_bits(BOND_TLS_FEATURES, features);
 #endif
 
-	mask = *features;
+	netdev_feature_copy(&mask, *features);
 
-	*features &= ~NETIF_F_ONE_FOR_ALL;
-	*features |= NETIF_F_ALL_FOR_ALL;
+	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
+	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
 
 	bond_for_each_slave(bond, slave, iter) {
 		netdev_increment_features(features, *features,
@@ -1403,12 +1403,16 @@ static void bond_compute_features(struct bonding *bond)
 {
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
-	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
-	netdev_features_t enc_features  = BOND_ENC_FEATURES;
+	netdev_features_t vlan_features;
+	netdev_features_t enc_features;
+	netdev_features_t vlan_mask;
+	netdev_features_t enc_mask;
 #ifdef CONFIG_XFRM_OFFLOAD
-	netdev_features_t xfrm_features  = BOND_XFRM_FEATURES;
+	netdev_features_t xfrm_features;
+	netdev_features_t xfrm_mask;
 #endif /* CONFIG_XFRM_OFFLOAD */
-	netdev_features_t mpls_features  = BOND_MPLS_FEATURES;
+	netdev_features_t mpls_features;
+	netdev_features_t mpls_mask;
 	struct net_device *bond_dev = bond->dev;
 	struct list_head *iter;
 	struct slave *slave;
@@ -1416,29 +1420,44 @@ static void bond_compute_features(struct bonding *bond)
 	unsigned int gso_max_size = GSO_MAX_SIZE;
 	u16 gso_max_segs = GSO_MAX_SEGS;
 
+	netdev_feature_zero(&vlan_features);
+	netdev_feature_set_bits(BOND_VLAN_FEATURES, &vlan_features);
+	netdev_feature_copy(&vlan_mask, vlan_features);
+	netdev_feature_zero(&enc_features);
+	netdev_feature_set_bits(BOND_ENC_FEATURES, &enc_features);
+	netdev_feature_copy(&enc_mask, enc_features);
+#ifdef CONFIG_XFRM_OFFLOAD
+	netdev_feature_zero(&xfrm_features);
+	netdev_feature_set_bits(BOND_XFRM_FEATURES, &xfrm_features);
+	netdev_feature_copy(&xfrm_mask, xfrm_features);
+#endif /* CONFIG_XFRM_OFFLOAD */
+	netdev_feature_zero(&mpls_features);
+	netdev_feature_set_bits(BOND_MPLS_FEATURES, &mpls_features);
+	netdev_feature_copy(&mpls_mask, mpls_features);
+
 	if (!bond_has_slaves(bond))
 		goto done;
-	vlan_features &= NETIF_F_ALL_FOR_ALL;
-	mpls_features &= NETIF_F_ALL_FOR_ALL;
+	netdev_feature_and_bits(NETIF_F_ALL_FOR_ALL, &vlan_features);
+	netdev_feature_and_bits(NETIF_F_ALL_FOR_ALL, &mpls_features);
 
 	bond_for_each_slave(bond, slave, iter) {
 		netdev_increment_features(&vlan_features, vlan_features,
 					  slave->dev->vlan_features,
-					  BOND_VLAN_FEATURES);
+					  vlan_mask);
 
 		netdev_increment_features(&enc_features, enc_features,
 					  slave->dev->hw_enc_features,
-					  BOND_ENC_FEATURES);
+					  enc_mask);
 
 #ifdef CONFIG_XFRM_OFFLOAD
 		netdev_increment_features(&xfrm_features, xfrm_features,
 					  slave->dev->hw_enc_features,
-					  BOND_XFRM_FEATURES);
+					  xfrm_mask);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 		netdev_increment_features(&mpls_features, mpls_features,
 					  slave->dev->mpls_features,
-					  BOND_MPLS_FEATURES);
+					  mpls_mask);
 
 		dst_release_flag &= slave->dev->priv_flags;
 		if (slave->dev->hard_header_len > max_hard_header_len)
@@ -1450,14 +1469,16 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->hard_header_len = max_hard_header_len;
 
 done:
-	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_STAG_TX;
+	netdev_feature_copy(&bond_dev->vlan_features, vlan_features);
+	netdev_feature_copy(&bond_dev->hw_enc_features, enc_features);
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX, &mpls_features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	bond_dev->hw_enc_features |= xfrm_features;
+	netdev_feature_or(&bond_dev->hw_enc_features, bond_dev->hw_enc_features,
+			  xfrm_features);
 #endif /* CONFIG_XFRM_OFFLOAD */
-	bond_dev->mpls_features = mpls_features;
+	netdev_feature_copy(&bond_dev->mpls_features, mpls_features);
 	bond_dev->gso_max_segs = gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);
 
@@ -1781,7 +1802,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	/* vlan challenged mutual exclusion */
 	/* no need to lock since we're protected by rtnl_lock */
-	if (slave_dev->features & NETIF_F_VLAN_CHALLENGED) {
+	if (netdev_feature_test_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				    slave_dev->features)) {
 		slave_dbg(bond_dev, slave_dev, "is NETIF_F_VLAN_CHALLENGED\n");
 		if (vlan_uses_dev(bond_dev)) {
 			SLAVE_NL_ERR(bond_dev, slave_dev, extack,
@@ -1794,7 +1816,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		slave_dbg(bond_dev, slave_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
 	}
 
-	if (slave_dev->features & NETIF_F_HW_ESP)
+	if (netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, slave_dev->features))
 		slave_dbg(bond_dev, slave_dev, "is esp-hw-offload capable\n");
 
 	/* Old ifenslave binaries are no longer supported.  These can
@@ -2087,7 +2109,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	}
 #endif
 
-	if (!(bond_dev->features & NETIF_F_LRO))
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, bond_dev->features))
 		dev_disable_lro(slave_dev);
 
 	res = netdev_rx_handler_register(slave_dev, bond_handle_frame,
@@ -2285,8 +2307,9 @@ static int __bond_release_one(struct net_device *bond_dev,
 	struct slave *slave, *oldcurrent;
 	struct sockaddr_storage ss;
 	int old_flags = bond_dev->flags;
-	netdev_features_t old_features = bond_dev->features;
+	netdev_features_t old_features;
 
+	netdev_feature_copy(&old_features, bond_dev->features);
 	/* slave is not a slave or master is not master of this slave */
 	if (!(slave_dev->flags & IFF_SLAVE) ||
 	    !netdev_has_upper_dev(slave_dev, bond_dev)) {
@@ -2390,8 +2413,9 @@ static int __bond_release_one(struct net_device *bond_dev,
 	}
 
 	bond_compute_features(bond);
-	if (!(bond_dev->features & NETIF_F_VLAN_CHALLENGED) &&
-	    (old_features & NETIF_F_VLAN_CHALLENGED))
+	if (!netdev_feature_test_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				     bond_dev->features) &&
+	    netdev_feature_test_bit(NETIF_F_VLAN_CHALLENGED_BIT, old_features))
 		slave_info(bond_dev, slave_dev, "last VLAN challenged slave left bond - VLAN blocking is removed\n");
 
 	vlan_vids_del_by_dev(slave_dev, bond_dev);
@@ -5406,7 +5430,7 @@ void bond_setup(struct net_device *bond_dev)
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't acquire bond device's netif_tx_lock when transmitting */
-	bond_dev->features |= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &bond_dev->features);
 
 	/* By default, we declare the bond to be fully
 	 * VLAN hardware accelerated capable. Special
@@ -5416,24 +5440,30 @@ void bond_setup(struct net_device *bond_dev)
 	 */
 
 	/* Don't allow bond devices to change network namespaces. */
-	bond_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &bond_dev->features);
 
-	bond_dev->hw_features = BOND_VLAN_FEATURES |
+	netdev_feature_zero(&bond_dev->hw_features);
+	netdev_feature_set_bits(BOND_VLAN_FEATURES |
 				NETIF_F_HW_VLAN_CTAG_RX |
-				NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-	bond_dev->features |= bond_dev->hw_features;
-	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&bond_dev->hw_features);
+
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &bond_dev->hw_features);
+	netdev_feature_or(&bond_dev->features, bond_dev->features,
+			  bond_dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX,
+				&bond_dev->features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	bond_dev->hw_features |= BOND_XFRM_FEATURES;
+	netdev_feature_set_bits(BOND_XFRM_FEATURES, &bond_dev->hw_features);
 	/* Only enable XFRM features if this is an active-backup config */
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
-		bond_dev->features |= BOND_XFRM_FEATURES;
+		netdev_feature_set_bits(BOND_XFRM_FEATURES,
+					&bond_dev->features);
 #endif /* CONFIG_XFRM_OFFLOAD */
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		bond_dev->features |= BOND_TLS_FEATURES;
+		netdev_feature_set_bits(BOND_TLS_FEATURES, &bond_dev->features);
 #endif
 }
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a8fde3bc458f..b0c3a28c2448 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -778,9 +778,11 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 		return false;
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
-		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
+		netdev_feature_set_bits(BOND_XFRM_FEATURES,
+					&bond->dev->wanted_features);
 	else
-		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
+		netdev_feature_clear_bits(BOND_XFRM_FEATURES,
+					  &bond->dev->wanted_features);
 
 	return true;
 }
@@ -791,9 +793,11 @@ static bool bond_set_tls_features(struct bonding *bond)
 		return false;
 
 	if (bond_sk_check(bond))
-		bond->dev->wanted_features |= BOND_TLS_FEATURES;
+		netdev_feature_set_bits(BOND_TLS_FEATURES,
+					&bond->dev->wanted_features);
 	else
-		bond->dev->wanted_features &= ~BOND_TLS_FEATURES;
+		netdev_feature_clear_bits(BOND_TLS_FEATURES,
+					  &bond->dev->wanted_features);
 
 	return true;
 }
-- 
2.33.0

