Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FB941C8E7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbhI2P7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:59:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23241 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245118AbhI2P7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbg62bjz8tTR;
        Wed, 29 Sep 2021 23:57:03 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 007/167] net: convert the prototype of vxlan_features_check
Date:   Wed, 29 Sep 2021 23:50:54 +0800
Message-ID: <20210929155334.12454-8-shenjian15@huawei.com>
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
vxlan_features_check for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  3 ++-
 drivers/net/ethernet/cisco/enic/enic_main.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  3 ++-
 drivers/net/usb/lan78xx.c                         |  2 +-
 include/net/vxlan.h                               | 13 ++++++-------
 8 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 3fb15f675ddf..29bca9fabcde 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2272,7 +2272,7 @@ static netdev_features_t xgbe_features_check(struct sk_buff *skb,
 					     netdev_features_t features)
 {
 	vlan_features_check(skb, &features);
-	features = vxlan_features_check(skb, features);
+	vxlan_features_check(skb, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 105aae3e21bf..f444515452a5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12857,7 +12857,8 @@ static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
 		features &= ~NETIF_F_GSO_MASK;
 
 	vlan_features_check(skb, &features);
-	return vxlan_features_check(skb, features);
+	vxlan_features_check(skb, &features);
+	return features;
 }
 
 static int __bnx2x_vlan_configure_vid(struct bnx2x *bp, u16 vid, bool add)
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 13dbdd5d07b4..558a07c5b4bc 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -253,7 +253,7 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	if (!skb->encapsulation)
 		return features;
 
-	features = vxlan_features_check(skb, features);
+	vxlan_features_check(skb, &features);
 
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IPV6):
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index a3c2a3e2d392..dd6a41182446 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2679,7 +2679,7 @@ static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 						netdev_features_t features)
 {
 	vlan_features_check(skb, &features);
-	features = vxlan_features_check(skb, features);
+	vxlan_features_check(skb, &features);
 
 	/* The ConnectX-3 doesn't support outer IPv6 checksums but it does
 	 * support inner IPv6 checksums and segmentation so  we need to
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b6aa5da06776..4518a490cdcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3911,7 +3911,7 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 	vlan_features_check(skb, &features);
-	features = vxlan_features_check(skb, features);
+	vxlan_features_check(skb, &features);
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 8f3a2a021082..d823f2a22472 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -497,7 +497,8 @@ static netdev_features_t qlcnic_features_check(struct sk_buff *skb,
 					       netdev_features_t features)
 {
 	vlan_features_check(skb, &features);
-	return vxlan_features_check(skb, features);
+	vxlan_features_check(skb, &features);
+	return features;
 }
 
 static const struct net_device_ops qlcnic_netdev_ops = {
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index bf477ea4ac26..9bfee75cbaf1 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3984,7 +3984,7 @@ static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
 		features &= ~NETIF_F_GSO_MASK;
 
 	vlan_features_check(skb, &features);
-	features = vxlan_features_check(skb, features);
+	vxlan_features_check(skb, &features);
 
 	return features;
 }
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 08537aa14f7c..a801e59e2313 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -296,13 +296,13 @@ struct vxlan_dev {
 struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
 
-static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
-						     netdev_features_t features)
+static inline void vxlan_features_check(struct sk_buff *skb,
+					netdev_features_t *features)
 {
 	u8 l4_hdr = 0;
 
 	if (!skb->encapsulation)
-		return features;
+		return;
 
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
@@ -312,7 +312,7 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features;
+		return;
 	}
 
 	if ((l4_hdr == IPPROTO_UDP) &&
@@ -321,10 +321,9 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
-	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto))))
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	      !can_checksum_protocol(*features, inner_eth_hdr(skb)->h_proto))))
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 
-	return features;
 }
 
 /* IP header + UDP + VXLAN + Ethernet header */
-- 
2.33.0

