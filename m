Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137EA41C928
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346022AbhI2QCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:01 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24134 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345428AbhI2P7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbF4B1Rz1DHKM;
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
Subject: [RFCv2 net-next 029/167] veth: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:16 +0800
Message-ID: <20210929155334.12454-30-shenjian15@huawei.com>
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
 drivers/net/veth.c | 61 ++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 82c900d7ba7b..39bfa024861c 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -310,9 +310,10 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 					 const struct net_device *rcv,
 					 const struct sk_buff *skb)
 {
-	return !(dev->features & NETIF_F_ALL_TSO) ||
+	return !netdev_feature_test_bits(NETIF_F_ALL_TSO, dev->features) ||
 		(skb->destructor == sock_wfree &&
-		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
+		 netdev_feature_test_bits(NETIF_F_GRO_FRAGLIST |
+					  NETIF_F_GRO_UDP_FWD, rcv->features));
 }
 
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -993,7 +994,7 @@ static void veth_napi_del(struct net_device *dev)
 
 static bool veth_gro_requested(const struct net_device *dev)
 {
-	return !!(dev->wanted_features & NETIF_F_GRO);
+	return netdev_feature_test_bit(NETIF_F_GRO_BIT, dev->wanted_features);
 }
 
 static int veth_enable_xdp_range(struct net_device *dev, int start, int end,
@@ -1075,7 +1076,8 @@ static int veth_enable_xdp(struct net_device *dev)
 				/* user-space did not require GRO, but adding XDP
 				 * is supposed to get GRO working
 				 */
-				dev->features |= NETIF_F_GRO;
+				netdev_feature_set_bit(NETIF_F_GRO_BIT,
+						       &dev->features);
 				netdev_features_change(dev);
 			}
 		}
@@ -1104,7 +1106,8 @@ static void veth_disable_xdp(struct net_device *dev)
 		 * enabled it, clear it now
 		 */
 		if (!veth_gro_requested(dev) && netif_running(dev)) {
-			dev->features &= ~NETIF_F_GRO;
+			netdev_feature_clear_bit(NETIF_F_GRO_BIT,
+						 &dev->features);
 			netdev_features_change(dev);
 		}
 	}
@@ -1393,23 +1396,27 @@ static void veth_fix_features(struct net_device *dev,
 		struct veth_priv *peer_priv = netdev_priv(peer);
 
 		if (peer_priv->_xdp_prog)
-			*features &= ~NETIF_F_GSO_SOFTWARE;
+			netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
+						  features);
 	}
 	if (priv->_xdp_prog)
-		*features |= NETIF_F_GRO;
+		netdev_feature_set_bit(NETIF_F_GRO_BIT, features);
 }
 
 static int veth_set_features(struct net_device *dev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ dev->features;
 	struct veth_priv *priv = netdev_priv(dev);
+	netdev_features_t changed;
 	int err;
 
-	if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_xdp_prog)
+	netdev_feature_xor(&changed, features, dev->features);
+
+	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, changed) ||
+	    !(dev->flags & IFF_UP) || priv->_xdp_prog)
 		return 0;
 
-	if (features & NETIF_F_GRO) {
+	if (netdev_feature_test_bit(NETIF_F_GRO_BIT, features)) {
 		err = veth_napi_enable(dev);
 		if (err)
 			return err;
@@ -1486,7 +1493,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		}
 
 		if (!old_prog) {
-			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+			netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
+						  &peer->hw_features);
 			peer->max_mtu = max_mtu;
 		}
 	}
@@ -1497,7 +1505,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 				veth_disable_xdp(dev);
 
 			if (peer) {
-				peer->hw_features |= NETIF_F_GSO_SOFTWARE;
+				netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
+							&peer->hw_features);
 				peer->max_mtu = ETH_MAX_MTU;
 			}
 		}
@@ -1562,20 +1571,24 @@ static void veth_setup(struct net_device *dev)
 
 	dev->netdev_ops = &veth_netdev_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
-	dev->features |= NETIF_F_LLTX;
-	dev->features |= VETH_FEATURES;
-	dev->vlan_features = dev->features &
-			     ~(NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_HW_VLAN_STAG_TX |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_STAG_RX);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bits(VETH_FEATURES, &dev->features);
+	netdev_feature_copy(&dev->vlan_features, dev->features);
+	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				  NETIF_F_HW_VLAN_STAG_TX |
+				  NETIF_F_HW_VLAN_CTAG_RX |
+				  NETIF_F_HW_VLAN_STAG_RX,
+				  &dev->vlan_features);
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	dev->hw_features = VETH_FEATURES;
-	dev->hw_enc_features = VETH_FEATURES;
-	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(VETH_FEATURES, &dev->hw_features);
+	netdev_feature_copy(&dev->hw_enc_features, dev->hw_features);
+	netdev_feature_zero(&dev->mpls_features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE,
+				&dev->mpls_features);
 }
 
 /*
@@ -1602,8 +1615,8 @@ static struct rtnl_link_ops veth_link_ops;
 
 static void veth_disable_gro(struct net_device *dev)
 {
-	dev->features &= ~NETIF_F_GRO;
-	dev->wanted_features &= ~NETIF_F_GRO;
+	netdev_feature_clear_bit(NETIF_F_GRO_BIT, &dev->features);
+	netdev_feature_clear_bit(NETIF_F_GRO_BIT, &dev->wanted_features);
 	netdev_update_features(dev);
 }
 
-- 
2.33.0

