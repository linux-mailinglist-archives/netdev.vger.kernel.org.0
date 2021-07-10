Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145863C3403
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 11:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhGJJrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 05:47:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6907 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhGJJrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 05:47:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GMQ4x07Klz72FR;
        Sat, 10 Jul 2021 17:40:49 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Jul 2021 17:44:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Jul 2021 17:44:18 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFC net-next] net: extend netdev features
Date:   Sat, 10 Jul 2021 17:40:47 +0800
Message-ID: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t is u64, and the number
of netdevice feature bits is 64 now. So there is no space to
introduce new feature bit.

I did a small change for this. Keep the prototype of
netdev_feature_t, and extend the feature members in struct
net_device to an array of netdev_features_t. So more features
bits can be used.

As this change, some functions which use netdev_features_t as
parameter or returen value will be affected.
I did below changes:
a. parameter: "netdev_features_t" to "netdev_features_t *"
b. return value: "netdev_feature_t" to "void", and add
"netdev_feature_t *" as output parameter.

I kept some functions no change, which are surely useing the
first 64 bit of net device features now, such as function
nedev_add_tso_features(). In order to minimize to changes.

For the features are array now, so it's unable to do logical
operation directly. I introduce a inline function set for
them, including "netdev_features_and/andnot/or/xor/equal/empty".

For NETDEV_FEATURE_COUNT may be more than 64, so the shift
operation for NETDEV_FEATURE_COUNT is illegal. I changed some
macroes and functions, which does shift opertion with it.

I haven't finished all the changes, for it affected all the
drivers which use the feature, need more time and test. I
sent this RFC patch, want to know whether this change is
acceptable, and how to improve it.

Any comments will be helpful.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c   |  34 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  97 ++++-----
 drivers/net/ethernet/huawei/hinic/hinic_main.c  |  71 +++---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c    |   4 +-
 include/linux/if_vlan.h                         |   2 +-
 include/linux/netdev_features.h                 | 105 ++++++++-
 include/linux/netdevice.h                       |  31 +--
 net/8021q/vlan.c                                |   4 +-
 net/8021q/vlan.h                                |   2 +-
 net/8021q/vlan_dev.c                            |  49 +++--
 net/core/dev.c                                  | 276 ++++++++++++------------
 net/core/netpoll.c                              |   6 +-
 net/ethtool/features.c                          |  56 +++--
 net/ethtool/ioctl.c                             |  93 +++++---
 14 files changed, 493 insertions(+), 337 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index ad534f9..4f245cf 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -479,7 +479,7 @@ static void hns_nic_rx_checksum(struct hns_nic_ring_data *ring_data,
 	u32 l4id;
 
 	/* check if RX checksum offload is enabled */
-	if (unlikely(!(netdev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!(netdev->features[0] & NETIF_F_RXCSUM)))
 		return;
 
 	/* In hardware, we only support checksum for the following protocols:
@@ -1768,17 +1768,17 @@ static int hns_nic_change_mtu(struct net_device *ndev, int new_mtu)
 }
 
 static int hns_nic_set_features(struct net_device *netdev,
-				netdev_features_t features)
+				netdev_features_t *features)
 {
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6))
+		if (features[0] & (NETIF_F_TSO | NETIF_F_TSO6))
 			netdev_info(netdev, "enet v1 do not support tso!\n");
 		break;
 	default:
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6)) {
+		if (features[0] & (NETIF_F_TSO | NETIF_F_TSO6)) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* The chip only support 7*4096 */
@@ -1789,24 +1789,23 @@ static int hns_nic_set_features(struct net_device *netdev,
 		}
 		break;
 	}
-	netdev->features = features;
+	netdev->features[0] = features[0];
 	return 0;
 }
 
-static netdev_features_t hns_nic_fix_features(
-		struct net_device *netdev, netdev_features_t features)
+static void hns_nic_fix_features(struct net_device *netdev,
+				 netdev_features_t *features)
 {
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6 |
+		features[0] &= ~(NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_HW_VLAN_CTAG_FILTER);
 		break;
 	default:
 		break;
 	}
-	return features;
 }
 
 static int hns_nic_uc_sync(struct net_device *netdev, const unsigned char *addr)
@@ -2163,8 +2162,8 @@ static void hns_nic_set_priv_ops(struct net_device *netdev)
 		priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
 	} else {
 		priv->ops.get_rxd_bnum = get_v2rx_desc_bnum;
-		if ((netdev->features & NETIF_F_TSO) ||
-		    (netdev->features & NETIF_F_TSO6)) {
+		if ((netdev->features[0] & NETIF_F_TSO) ||
+		    (netdev->features[0] & NETIF_F_TSO6)) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* This chip only support 7*4096 */
@@ -2325,22 +2324,23 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &hns_nic_netdev_ops;
 	hns_ethtool_set_ops(ndev);
 
-	ndev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+	ndev->features[0] |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO;
-	ndev->vlan_features |=
+	ndev->vlan_features[0] |=
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
-	ndev->vlan_features |= NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+	ndev->vlan_features[0] |= NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
 
 	/* MTU range: 68 - 9578 (v1) or 9706 (v2) */
 	ndev->min_mtu = MAC_MIN_MTU;
 	switch (priv->enet_ver) {
 	case AE_VERSION_2:
-		ndev->features |= NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_NTUPLE;
-		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+		ndev->features[0] |=
+				NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_NTUPLE;
+		ndev->hw_features[0] |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 			NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6;
-		ndev->vlan_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		ndev->vlan_features[0] |= NETIF_F_TSO | NETIF_F_TSO6;
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 		break;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cdb5f14..ba56907 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1481,7 +1481,7 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 		return -EINVAL;
 
 	if (skb->protocol == htons(ETH_P_8021Q) &&
-	    !(handle->kinfo.netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !(handle->kinfo.netdev->features[0] & NETIF_F_HW_VLAN_CTAG_TX)) {
 		/* When HW VLAN acceleration is turned off, and the stack
 		 * sets the protocol to 802.1q, the driver just need to
 		 * set the protocol to the encapsulated ethertype.
@@ -2300,56 +2300,57 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 }
 
 static int hns3_nic_set_features(struct net_device *netdev,
-				 netdev_features_t features)
+				 netdev_features_t *features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed[NETDEV_FEATURE_DWORDS];
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
 	bool enable;
 	int ret;
 
-	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
-		enable = !!(features & NETIF_F_GRO_HW);
+	netdev_features_xor(changed, netdev->features, features);
+	if (changed[0] & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
+		enable = !!(features[0] & NETIF_F_GRO_HW);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if ((changed[0] & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    h->ae_algo->ops->enable_hw_strip_rxvtag) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+		enable = !!(features[0] & NETIF_F_HW_VLAN_CTAG_RX);
 		ret = h->ae_algo->ops->enable_hw_strip_rxvtag(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_NTUPLE) && h->ae_algo->ops->enable_fd) {
-		enable = !!(features & NETIF_F_NTUPLE);
+	if ((changed[0] & NETIF_F_NTUPLE) && h->ae_algo->ops->enable_fd) {
+		enable = !!(features[0] & NETIF_F_NTUPLE);
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if ((netdev->features[0] & NETIF_F_HW_TC) >
+	     (features[0] & NETIF_F_HW_TC) &&
 	    h->ae_algo->ops->cls_flower_active(h)) {
 		netdev_err(netdev,
 			   "there are offloaded TC filters active, cannot disable HW TC offload");
 		return -EINVAL;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((changed[0] & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    h->ae_algo->ops->enable_vlan_filter) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		enable = !!(features[0] & NETIF_F_HW_VLAN_CTAG_FILTER);
 		ret = h->ae_algo->ops->enable_vlan_filter(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	netdev->features = features;
+	netdev_features_copy(netdev->features, features);
 	return 0;
 }
 
-static netdev_features_t hns3_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void hns3_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 #define HNS3_MAX_HDR_LEN	480U
 #define HNS3_MAX_L4_HDR_LEN	60U
@@ -2373,9 +2374,7 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
-
-	return features;
+		features[0] &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 static void hns3_nic_get_stats64(struct net_device *netdev,
@@ -3127,27 +3126,28 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->hw_enc_features |= NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
+	netdev->hw_enc_features[0] |=
+		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 		NETIF_F_SCTP_CRC | NETIF_F_TSO_MANGLEID | NETIF_F_FRAGLIST;
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+	netdev->features[0] |= NETIF_F_HW_VLAN_CTAG_FILTER |
 		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
-	netdev->vlan_features |= NETIF_F_RXCSUM |
+	netdev->vlan_features[0] |= NETIF_F_RXCSUM |
 		NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO |
 		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
+	netdev->hw_features[0] |= NETIF_F_HW_VLAN_CTAG_TX |
 		NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
@@ -3155,48 +3155,49 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->hw_features |= NETIF_F_GRO_HW;
-		netdev->features |= NETIF_F_GRO_HW;
+		netdev->hw_features[0] |= NETIF_F_GRO_HW;
+		netdev->features[0] |= NETIF_F_GRO_HW;
 
 		if (!(h->flags & HNAE3_SUPPORT_VF)) {
-			netdev->hw_features |= NETIF_F_NTUPLE;
-			netdev->features |= NETIF_F_NTUPLE;
+			netdev->hw_features[0] |= NETIF_F_NTUPLE;
+			netdev->features[0] |= NETIF_F_NTUPLE;
 		}
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_L4;
-		netdev->features |= NETIF_F_GSO_UDP_L4;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_L4;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_L4;
+		netdev->hw_features[0] |= NETIF_F_GSO_UDP_L4;
+		netdev->features[0] |= NETIF_F_GSO_UDP_L4;
+		netdev->vlan_features[0] |= NETIF_F_GSO_UDP_L4;
+		netdev->hw_enc_features[0] |= NETIF_F_GSO_UDP_L4;
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_HW_CSUM;
-		netdev->features |= NETIF_F_HW_CSUM;
-		netdev->vlan_features |= NETIF_F_HW_CSUM;
-		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
+		netdev->hw_features[0] |= NETIF_F_HW_CSUM;
+		netdev->features[0] |= NETIF_F_HW_CSUM;
+		netdev->vlan_features[0] |= NETIF_F_HW_CSUM;
+		netdev->hw_enc_features[0] |= NETIF_F_HW_CSUM;
 	} else {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		netdev->vlan_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->hw_features[0] |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->features[0] |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->vlan_features[0] |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->hw_enc_features[0] |=
+					NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_features[0] |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->features[0] |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features[0] |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_enc_features[0] |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_HW_TC;
-		netdev->features |= NETIF_F_HW_TC;
+		netdev->hw_features[0] |= NETIF_F_HW_TC;
+		netdev->features[0] |= NETIF_F_HW_TC;
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev->hw_features[0] |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
@@ -3727,7 +3728,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 
 	skb_checksum_none_assert(skb);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!(netdev->features[0] & NETIF_F_RXCSUM))
 		return;
 
 	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state))
@@ -4024,7 +4025,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
 	 * in one layer tag case.
 	 */
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev->features[0] & NETIF_F_HW_VLAN_CTAG_RX) {
 		u16 vlan_tag;
 
 		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 405ee4d..b193ee4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -79,8 +79,8 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 static int change_mac_addr(struct net_device *netdev, const u8 *addr);
 
 static int set_features(struct hinic_dev *nic_dev,
-			netdev_features_t pre_features,
-			netdev_features_t features, bool force_change);
+			netdev_features_t *pre_features,
+			netdev_features_t *features, bool force_change);
 
 static void update_rx_stats(struct hinic_dev *nic_dev, struct hinic_rxq *rxq)
 {
@@ -880,7 +880,7 @@ static void hinic_get_stats64(struct net_device *netdev,
 }
 
 static int hinic_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+			      netdev_features_t *features)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
@@ -888,18 +888,16 @@ static int hinic_set_features(struct net_device *netdev,
 			    features, false);
 }
 
-static netdev_features_t hinic_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void hinic_fix_features(struct net_device *netdev,
+			       netdev_features_t features)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!(features[0] & NETIF_F_RXCSUM)) {
 		netif_info(nic_dev, drv, netdev, "disabling LRO as RXCSUM is off\n");
-		features &= ~NETIF_F_LRO;
+		features[0] &= ~NETIF_F_LRO;
 	}
-
-	return features;
 }
 
 static const struct net_device_ops hinic_netdev_ops = {
@@ -943,19 +941,22 @@ static const struct net_device_ops hinicvf_netdev_ops = {
 
 static void netdev_features_init(struct net_device *netdev)
 {
-	netdev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM | NETIF_F_LRO |
-			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
-
-	netdev->vlan_features = netdev->hw_features;
-
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	netdev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
-				  NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
-				  NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL;
+	netdev->hw_features[0] =
+			NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
+			NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
+			NETIF_F_RXCSUM | NETIF_F_LRO |
+			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
+			NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
+
+	netdev_features_copy(netdev->vlan_features, netdev->hw_features);
+
+	netdev->features[0] =
+			netdev->hw_features[0] | NETIF_F_HW_VLAN_CTAG_FILTER;
+
+	netdev->hw_enc_features[0] =
+		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
+		NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
+		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL;
 }
 
 static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
@@ -1072,21 +1073,22 @@ static void link_err_event(void *handle,
 }
 
 static int set_features(struct hinic_dev *nic_dev,
-			netdev_features_t pre_features,
-			netdev_features_t features, bool force_change)
+			netdev_features_t *pre_features,
+			netdev_features_t *features, bool force_change)
 {
-	netdev_features_t changed = force_change ? ~0 : pre_features ^ features;
+	netdev_features_t failed_features[NETDEV_FEATURE_DWORDS] = {0};
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
-	netdev_features_t failed_features = 0;
+	netdev_features_t changed;
 	int ret = 0;
 	int err = 0;
 
+	changed = force_change ? ~0 : pre_features[0] ^ features[0];
 	if (changed & NETIF_F_TSO) {
-		ret = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
+		ret = hinic_port_set_tso(nic_dev, (features[0] & NETIF_F_TSO) ?
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_TSO;
+			failed_features[0] |= NETIF_F_TSO;
 		}
 	}
 
@@ -1094,33 +1096,34 @@ static int set_features(struct hinic_dev *nic_dev,
 		ret = hinic_set_rx_csum_offload(nic_dev, csum_en);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_RXCSUM;
+			failed_features[0] |= NETIF_F_RXCSUM;
 		}
 	}
 
 	if (changed & NETIF_F_LRO) {
 		ret = hinic_set_rx_lro_state(nic_dev,
-					     !!(features & NETIF_F_LRO),
+					     !!(features[0] & NETIF_F_LRO),
 					     HINIC_LRO_RX_TIMER_DEFAULT,
 					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_LRO;
+			failed_features[0] |= NETIF_F_LRO;
 		}
 	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
 		ret = hinic_set_rx_vlan_offload(nic_dev,
-						!!(features &
+						!!(features[0] &
 						   NETIF_F_HW_VLAN_CTAG_RX));
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_HW_VLAN_CTAG_RX;
+			failed_features[0] |= NETIF_F_HW_VLAN_CTAG_RX;
 		}
 	}
 
 	if (err) {
-		nic_dev->netdev->features = features ^ failed_features;
+		netdev_features_xor(nic_dev->netdev->features, features,
+				    failed_features)
 		return -EIO;
 	}
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index fed3b6b..452a91b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -106,7 +106,7 @@ static void rx_csum(struct hinic_rxq *rxq, u32 status,
 
 	csum_err = HINIC_RQ_CQE_STATUS_GET(status, CSUM_ERR);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!(netdev->features[0] & NETIF_F_RXCSUM))
 		return;
 
 	if (!csum_err) {
@@ -411,7 +411,7 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 
 		offload_type = be32_to_cpu(cqe->offload_type);
 		vlan_len = be32_to_cpu(cqe->len);
-		if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if ((netdev->features[0] & NETIF_F_HW_VLAN_CTAG_RX) &&
 		    HINIC_GET_RX_VLAN_OFFLOAD_EN(offload_type)) {
 			vid = HINIC_GET_RX_VLAN_TAG(vlan_len);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 41a5183..4173464 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -563,7 +563,7 @@ static inline int __vlan_hwaccel_get_tag(const struct sk_buff *skb,
  */
 static inline int vlan_get_tag(const struct sk_buff *skb, u16 *vlan_tci)
 {
-	if (skb->dev->features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (skb->dev->features[0] & NETIF_F_HW_VLAN_CTAG_TX) {
 		return __vlan_hwaccel_get_tag(skb, vlan_tci);
 	} else {
 		return __vlan_get_tag(skb, vlan_tci);
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e4..9184963 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -102,7 +102,8 @@ enum {
 };
 
 /* copy'n'paste compression ;) */
-#define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
+#define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit & 0x3F))
+
 #define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
 
 #define NETIF_F_FCOE_CRC	__NETIF_F(FCOE_CRC)
@@ -169,6 +170,8 @@ enum {
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
 
+#define NETDEV_FEATURE_DWORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 64)
+
 /* Finds the next feature with the highest number of the range of start till 0.
  */
 static inline int find_next_netdev_feature(u64 feature, unsigned long start)
@@ -185,8 +188,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
  * mask_addr should be a u64 and bit an int
  */
 #define for_each_netdev_feature(mask_addr, bit)				\
-	for ((bit) = find_next_netdev_feature((mask_addr),		\
-					      NETDEV_FEATURE_COUNT);	\
+	for ((bit) = find_next_netdev_feature((mask_addr), 64);		\
 	     (bit) >= 0;						\
 	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
 
@@ -195,11 +197,6 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 #define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
 				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
 
-/* remember that ((t)1 << t_BITS) is undefined in C99 */
-#define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
-		(__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) - 1)) & \
-		~NETIF_F_NEVER_CHANGE)
-
 /* Segmentation offload feature mask */
 #define NETIF_F_GSO_MASK	(__NETIF_F_BIT(NETIF_F_GSO_LAST + 1) - \
 		__NETIF_F_BIT(NETIF_F_GSO_SHIFT))
@@ -261,4 +258,96 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
+static inline void netdev_features_copy(netdev_features_t *dst,
+					const netdev_features_t *src)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		dst[i] = src[i];
+}
+
+static inline void netdev_features_and(netdev_features_t *dst,
+				       const netdev_features_t *a,
+				       const netdev_features_t *b)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		dst[i] = a[i] & b[i];
+}
+
+static inline void netdev_features_andnot(netdev_features_t *dst,
+					  const netdev_features_t *a,
+					  const netdev_features_t *b)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		dst[i] = a[i] & ~b[i];
+}
+
+static inline void netdev_features_or(netdev_features_t *dst,
+				      const netdev_features_t *a,
+				      const netdev_features_t *b)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		dst[i] = a[i] | b[i];
+}
+
+static inline void netdev_features_xor(netdev_features_t *dst,
+				       const netdev_features_t *a,
+				       const netdev_features_t *b)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		dst[i] = a[i] ^ b[i];
+}
+
+static inline void netdev_features_set(netdev_features_t *dst,
+				       unsigned int bit)
+{
+	dst[bit / 64] |= __NETIF_F_BIT(bit);
+}
+
+static inline bool netdev_features_equal(const netdev_features_t *a,
+					 const netdev_features_t *b)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		if (a[i] != b[i])
+			return false;
+
+	return true;
+}
+
+static inline void netdev_features_empty(netdev_features_t *src)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		if (src[i])
+			return false;
+
+	return true;
+}
+
+static inline void netdev_features_ethtool_bits(netdev_features_t *dst)
+{
+	unsigned int i;
+
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++) {
+		if (NETDEV_FEATURE_COUNT >= (i + 1) * 64)
+			dst[i] = GENMASK_ULL(63, 0);
+		else
+			dst[i] = GENMASK_ULL(NETDEV_FEATURE_COUNT - i * 64,
+						  0);
+	}
+	dst[0] &= ~NETIF_F_NEVER_CHANGE;
+}
+
 #endif	/* _LINUX_NETDEV_FEATURES_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb0..4a29487 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1347,9 +1347,9 @@ struct net_device_ops {
 	int			(*ndo_stop)(struct net_device *dev);
 	netdev_tx_t		(*ndo_start_xmit)(struct sk_buff *skb,
 						  struct net_device *dev);
-	netdev_features_t	(*ndo_features_check)(struct sk_buff *skb,
+	void			(*ndo_features_check)(struct sk_buff *skb,
 						      struct net_device *dev,
-						      netdev_features_t features);
+						      netdev_features_t *features);
 	u16			(*ndo_select_queue)(struct net_device *dev,
 						    struct sk_buff *skb,
 						    struct net_device *sb_dev);
@@ -1467,10 +1467,10 @@ struct net_device_ops {
 						      bool all_slaves);
 	struct net_device*	(*ndo_sk_get_lower_dev)(struct net_device *dev,
 							struct sock *sk);
-	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
-						    netdev_features_t features);
+	void			(*ndo_fix_features)(struct net_device *dev,
+						    netdev_features_t *features);
 	int			(*ndo_set_features)(struct net_device *dev,
-						    netdev_features_t features);
+						    netdev_features_t *features);
 	int			(*ndo_neigh_construct)(struct net_device *dev,
 						       struct neighbour *n);
 	void			(*ndo_neigh_destroy)(struct net_device *dev,
@@ -1978,12 +1978,12 @@ struct net_device {
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
 
-	netdev_features_t	features;
-	netdev_features_t	hw_features;
-	netdev_features_t	wanted_features;
-	netdev_features_t	vlan_features;
-	netdev_features_t	hw_enc_features;
-	netdev_features_t	mpls_features;
+	netdev_features_t	features[NETDEV_FEATURE_DWORDS];
+	netdev_features_t	hw_features[NETDEV_FEATURE_DWORDS];
+	netdev_features_t	wanted_features[NETDEV_FEATURE_DWORDS];
+	netdev_features_t	vlan_features[NETDEV_FEATURE_DWORDS];
+	netdev_features_t	hw_enc_features[NETDEV_FEATURE_DWORDS];
+	netdev_features_t	mpls_features[NETDEV_FEATURE_DWORDS];
 	netdev_features_t	gso_partial_features;
 
 	unsigned int		min_mtu;
@@ -4986,10 +4986,11 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 	return f1 & f2;
 }
 
-static inline netdev_features_t netdev_get_wanted_features(
-	struct net_device *dev)
+static inline void netdev_get_wanted_features(struct net_device *dev,
+					      netdev_features_t *wanted)
 {
-	return (dev->features & ~dev->hw_features) | dev->wanted_features;
+	netdev_features_andnot(wanted, dev->features, dev->hw_features);
+	netdev_features_or(wanted, wanted, dev->wanted_features);
 }
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask);
@@ -5014,7 +5015,7 @@ void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 netdev_features_t passthru_features_check(struct sk_buff *skb,
 					  struct net_device *dev,
 					  netdev_features_t features);
-netdev_features_t netif_skb_features(struct sk_buff *skb);
+void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 4cdf841..7d77692 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -328,7 +328,7 @@ static void vlan_transfer_features(struct net_device *dev,
 	vlandev->gso_max_size = dev->gso_max_size;
 	vlandev->gso_max_segs = dev->gso_max_segs;
 
-	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
+	if (vlan_hw_offload_capable(dev->features[0], vlan->vlan_proto))
 		vlandev->hard_header_len = dev->hard_header_len;
 	else
 		vlandev->hard_header_len = dev->hard_header_len + VLAN_HLEN;
@@ -339,7 +339,7 @@ static void vlan_transfer_features(struct net_device *dev,
 
 	vlandev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	vlandev->priv_flags |= (vlan->real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
-	vlandev->hw_enc_features = vlan_tnl_features(vlan->real_dev);
+	vlandev->hw_enc_features[0] = vlan_tnl_features(vlan->real_dev);
 
 	netdev_update_features(vlandev);
 }
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 1a705a4..4e784a1 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -107,7 +107,7 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 {
 	netdev_features_t ret;
 
-	ret = real_dev->hw_enc_features &
+	ret = real_dev->hw_enc_features[0] &
 	      (NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE |
 	       NETIF_F_GSO_ENCAP_ALL);
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index a0367b3..6d49761 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -566,21 +566,21 @@ static int vlan_dev_init(struct net_device *dev)
 	if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 		dev->state |= (1 << __LINK_STATE_NOCARRIER);
 
-	dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG |
-			   NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
-			   NETIF_F_GSO_ENCAP_ALL |
-			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
-			   NETIF_F_ALL_FCOE;
+	dev->hw_features[0] = NETIF_F_HW_CSUM | NETIF_F_SG |
+			      NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
+			      NETIF_F_GSO_ENCAP_ALL |
+			      NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
+			      NETIF_F_ALL_FCOE;
 
-	dev->features |= dev->hw_features | NETIF_F_LLTX;
+	dev->features[0] |= dev->hw_features[0] | NETIF_F_LLTX;
 	dev->gso_max_size = real_dev->gso_max_size;
 	dev->gso_max_segs = real_dev->gso_max_segs;
-	if (dev->features & NETIF_F_VLAN_FEATURES)
+	if (dev->features[0] & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
-	dev->vlan_features = real_dev->vlan_features & ~NETIF_F_ALL_FCOE;
-	dev->hw_enc_features = vlan_tnl_features(real_dev);
-	dev->mpls_features = real_dev->mpls_features;
+	dev->vlan_features[0] = real_dev->vlan_features[0] & ~NETIF_F_ALL_FCOE;
+	dev->hw_enc_features[0] = vlan_tnl_features(real_dev);
+	netdev_features_copy(dev->mpls_features, real_dev->mpls_features);
 
 	/* ipv6 shared card related stuff */
 	dev->dev_id = real_dev->dev_id;
@@ -633,27 +633,30 @@ void vlan_dev_uninit(struct net_device *dev)
 	}
 }
 
-static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void vlan_dev_fix_features(struct net_device *dev,
+				  netdev_features_t *features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	netdev_features_t old_features = features;
-	netdev_features_t lower_features;
+	netdev_features_t lower_features[NETDEV_FEATURE_DWORDS];
+	netdev_features_t old_features[NETDEV_FEATURE_DWORDS];
 
-	lower_features = netdev_intersect_features((real_dev->vlan_features |
-						    NETIF_F_RXCSUM),
-						   real_dev->features);
+	netdev_features_copy(lower_features, features);
+
+	lower_features[0] =
+		netdev_intersect_features((real_dev->vlan_features[0] |
+					   NETIF_F_RXCSUM),
+					  real_dev->features[0]);
 
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
-	if (lower_features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))
-		lower_features |= NETIF_F_HW_CSUM;
-	features = netdev_intersect_features(features, lower_features);
-	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
-	features |= NETIF_F_LLTX;
+	if (lower_features[0] & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+		lower_features[0] |= NETIF_F_HW_CSUM;
 
-	return features;
+	features[0] = netdev_intersect_features(features[0], lower_features[0]);
+	features[0] |= old_features[0] &
+			(NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
+	features[0] |= NETIF_F_LLTX;
 }
 
 static int vlan_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2a..7066bf3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1765,7 +1765,7 @@ void dev_disable_lro(struct net_device *dev)
 	dev->wanted_features &= ~NETIF_F_LRO;
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_LRO))
+	if (unlikely(dev->features[0] & NETIF_F_LRO))
 		netdev_WARN(dev, "failed to disable LRO!\n");
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
@@ -1786,7 +1786,7 @@ static void dev_disable_gro_hw(struct net_device *dev)
 	dev->wanted_features &= ~NETIF_F_GRO_HW;
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_GRO_HW))
+	if (unlikely(dev->features[0] & NETIF_F_GRO_HW))
 		netdev_WARN(dev, "failed to disable GRO_HW!\n");
 }
 
@@ -3276,7 +3276,7 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
 	}
 	skb_dump(KERN_WARNING, skb, false);
 	WARN(1, "%s: caps=(%pNF, %pNF)\n",
-	     name, dev ? &dev->features : &null_features,
+	     name, dev ? &dev->features[0] : &null_features,
 	     skb->sk ? &skb->sk->sk_route_caps : &null_features);
 }
 
@@ -3463,7 +3463,8 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->features & dev->gso_partial_features;
+		partial_features |=
+				dev->features[0] & dev->gso_partial_features;
 		if (!skb_gso_ok(skb, features | partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
@@ -3508,7 +3509,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 #ifdef CONFIG_HIGHMEM
 	int i;
 
-	if (!(dev->features & NETIF_F_HIGHDMA)) {
+	if (!(dev->features[0] & NETIF_F_HIGHDMA)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -3612,34 +3613,33 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	return features;
 }
 
-netdev_features_t netif_skb_features(struct sk_buff *skb)
+void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->features;
 
+	netdev_features_copy(features, dev->features);
 	if (skb_is_gso(skb))
-		features = gso_features_check(skb, dev, features);
+		features[0] = gso_features_check(skb, dev, features[0]);
 
 	/* If encapsulation offload request, verify we are testing
 	 * hardware encapsulation features instead of standard
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		features &= dev->hw_enc_features;
+		netdev_features_and(features, dev->hw_enc_features);
 
 	if (skb_vlan_tagged(skb))
-		features = netdev_intersect_features(features,
-						     dev->vlan_features |
-						     NETIF_F_HW_VLAN_CTAG_TX |
-						     NETIF_F_HW_VLAN_STAG_TX);
+		features[0] = netdev_intersect_features(features[0],
+							dev->vlan_features[0] |
+							NETIF_F_HW_VLAN_CTAG_TX |
+							NETIF_F_HW_VLAN_STAG_TX);
 
 	if (dev->netdev_ops->ndo_features_check)
-		features &= dev->netdev_ops->ndo_features_check(skb, dev,
-								features);
+		dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
-		features &= dflt_features_check(skb, dev, features);
+		features[0] &= dflt_features_check(skb, dev, features[0]);
 
-	return harmonize_features(skb, features);
+	features[0] = harmonize_features(skb, features[0]);
 }
 EXPORT_SYMBOL(netif_skb_features);
 
@@ -3722,10 +3722,10 @@ EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
 static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev, bool *again)
 {
-	netdev_features_t features;
+	netdev_features_t features[NETDEV_FEATURE_DWORDS];
 
-	features = netif_skb_features(skb);
-	skb = validate_xmit_vlan(skb, features);
+	netif_skb_features(skb, features);
+	skb = validate_xmit_vlan(skb, features[0]);
 	if (unlikely(!skb))
 		goto out_null;
 
@@ -3733,10 +3733,10 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 	if (unlikely(!skb))
 		goto out_null;
 
-	if (netif_needs_gso(skb, features)) {
+	if (netif_needs_gso(skb, features[0])) {
 		struct sk_buff *segs;
 
-		segs = skb_gso_segment(skb, features);
+		segs = skb_gso_segment(skb, features[0]);
 		if (IS_ERR(segs)) {
 			goto out_kfree_skb;
 		} else if (segs) {
@@ -3744,7 +3744,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 			skb = segs;
 		}
 	} else {
-		if (skb_needs_linearize(skb, features) &&
+		if (skb_needs_linearize(skb, features[0]) &&
 		    __skb_linearize(skb))
 			goto out_kfree_skb;
 
@@ -3759,12 +3759,12 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 			else
 				skb_set_transport_header(skb,
 							 skb_checksum_start_offset(skb));
-			if (skb_csum_hwoffload_help(skb, features))
+			if (skb_csum_hwoffload_help(skb, features[0]))
 				goto out_kfree_skb;
 		}
 	}
 
-	skb = validate_xmit_xfrm(skb, features, again);
+	skb = validate_xmit_xfrm(skb, features[0], again);
 
 	return skb;
 
@@ -4429,7 +4429,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 		/* Should we steer this flow to a different hardware queue? */
 		if (!skb_rx_queue_recorded(skb) || !dev->rx_cpu_rmap ||
-		    !(dev->features & NETIF_F_NTUPLE))
+		    !(dev->features[0] & NETIF_F_NTUPLE))
 			goto out;
 		rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap, next_cpu);
 		if (rxq_index == skb_get_rx_queue(skb))
@@ -9799,171 +9799,179 @@ static void net_set_todo(struct net_device *dev)
 	dev_net(dev)->dev_unreg_count++;
 }
 
-static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
-	struct net_device *upper, netdev_features_t features)
+static void netdev_sync_upper_features(struct net_device *lower,
+				       struct net_device *upper,
+				       netdev_features_t *features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
 	netdev_features_t feature;
 	int feature_bit;
+	unsigned int i;
 
-	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(upper->wanted_features & feature)
-		    && (features & feature)) {
-			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
-				   &feature, upper->name);
-			features &= ~feature;
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++) {
+		for_each_netdev_feature(upper_disables, feature_bit) {
+			feature = __NETIF_F_BIT(feature_bit);
+			if (!(upper->wanted_features[i] & feature) &&
+			    (features[i] & feature)) {
+				netdev_dbg(lower, "Dropping feature[%u] %pNF, upper dev %s has it off.\n",
+					   i, &feature, upper->name);
+				features[i] &= ~feature;
+			}
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
 	netdev_features_t feature;
 	int feature_bit;
+	unsigned int i;
 
-	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(features & feature) && (lower->features & feature)) {
-			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
-				   &feature, lower->name);
-			lower->wanted_features &= ~feature;
-			__netdev_update_features(lower);
-
-			if (unlikely(lower->features & feature))
-				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
-					    &feature, lower->name);
-			else
-				netdev_features_change(lower);
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++) {
+		for_each_netdev_feature(upper_disables, feature_bit) {
+			feature = __NETIF_F_BIT(feature_bit);
+			if (!(features[i] & feature) &&
+			    (lower->features[i] & feature)) {
+				netdev_dbg(upper, "Disabling feature[%u] %pNF on lower dev %s.\n",
+					   i, &feature, lower->name);
+				lower->wanted_features[i] &= ~feature[i];
+				__netdev_update_features(lower);
+
+				if (unlikely(lower->features[i] & feature))
+					netdev_WARN(upper, "failed to disable feature[%u] %pNF on %s!\n",
+						    i, &feature, lower->name);
+				else
+					netdev_features_change(lower);
+			}
 		}
 	}
 }
 
-static netdev_features_t netdev_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void netdev_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	/* Fix illegal checksum combinations */
-	if ((features & NETIF_F_HW_CSUM) &&
-	    (features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))) {
+	if ((features[0] & NETIF_F_HW_CSUM) &&
+	    (features[0] & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+		features[0] &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
+	if ((features[0] & NETIF_F_ALL_TSO) && !(features[0] & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		features &= ~NETIF_F_ALL_TSO;
+		features[0] &= ~NETIF_F_ALL_TSO;
 	}
 
-	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
-					!(features & NETIF_F_IP_CSUM)) {
+	if ((features[0] & NETIF_F_TSO) && !(features[0] & NETIF_F_HW_CSUM) &&
+	    !(features[0] & NETIF_F_IP_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO;
-		features &= ~NETIF_F_TSO_ECN;
+		features[0] &= ~NETIF_F_TSO;
+		features[0] &= ~NETIF_F_TSO_ECN;
 	}
 
-	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
-					 !(features & NETIF_F_IPV6_CSUM)) {
+	if ((features[0] & NETIF_F_TSO6) && !(features[0] & NETIF_F_HW_CSUM) &&
+	    !(features[0] & NETIF_F_IPV6_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO6;
+		features[0] &= ~NETIF_F_TSO6;
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
-		features &= ~NETIF_F_TSO_MANGLEID;
+	if ((features[0] & NETIF_F_TSO_MANGLEID) &&
+	    !(features[0] & NETIF_F_TSO))
+		features[0] &= ~NETIF_F_TSO_MANGLEID;
 
 	/* TSO ECN requires that TSO is present as well. */
-	if ((features & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
-		features &= ~NETIF_F_TSO_ECN;
+	if ((features[0] & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
+		features[0] &= ~NETIF_F_TSO_ECN;
 
 	/* Software GSO depends on SG. */
-	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
+	if ((features[0] & NETIF_F_GSO) && !(features[0] & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		features &= ~NETIF_F_GSO;
+		features[0] &= ~NETIF_F_GSO;
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if ((features & dev->gso_partial_features) &&
-	    !(features & NETIF_F_GSO_PARTIAL)) {
+	if ((features[0] & dev->gso_partial_features) &&
+	    !(features[0] & NETIF_F_GSO_PARTIAL)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		features &= ~dev->gso_partial_features;
+		features[0] &= ~dev->gso_partial_features;
 	}
 
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!(features[0] & NETIF_F_RXCSUM)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (features & NETIF_F_GRO_HW) {
+		if (features[0] & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			features &= ~NETIF_F_GRO_HW;
+			features[0] &= ~NETIF_F_GRO_HW;
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (features & NETIF_F_RXFCS) {
-		if (features & NETIF_F_LRO) {
+	if (features[0] & NETIF_F_RXFCS) {
+		if (features[0] & NETIF_F_LRO) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_LRO;
+			features[0] &= ~NETIF_F_LRO;
 		}
 
-		if (features & NETIF_F_GRO_HW) {
+		if (features[0] & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_GRO_HW;
+			features[0] &= ~NETIF_F_GRO_HW;
 		}
 	}
 
-	if (features & NETIF_F_HW_TLS_TX) {
-		bool ip_csum = (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
+	if (features[0] & NETIF_F_HW_TLS_TX) {
+		bool ip_csum = (features[0] & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
 			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-		bool hw_csum = features & NETIF_F_HW_CSUM;
+		bool hw_csum = features[0] & NETIF_F_HW_CSUM;
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			features &= ~NETIF_F_HW_TLS_TX;
+			features[0] &= ~NETIF_F_HW_TLS_TX;
 		}
 	}
 
-	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
+	if ((features[0] & NETIF_F_HW_TLS_RX) &&
+	    !(features[0] & NETIF_F_RXCSUM)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		features &= ~NETIF_F_HW_TLS_RX;
+		features[0] &= ~NETIF_F_HW_TLS_RX;
 	}
-
-	return features;
 }
 
 int __netdev_update_features(struct net_device *dev)
 {
+	netdev_features_t features[NETDEV_FEATURE_DWORDS];
 	struct net_device *upper, *lower;
-	netdev_features_t features;
 	struct list_head *iter;
+	unsigned int i;
 	int err = -1;
 
 	ASSERT_RTNL();
 
-	features = netdev_get_wanted_features(dev);
+	netdev_get_wanted_features(dev, features);
 
 	if (dev->netdev_ops->ndo_fix_features)
-		features = dev->netdev_ops->ndo_fix_features(dev, features);
+		dev->netdev_ops->ndo_fix_features(dev, features);
 
 	/* driver might be less strict about feature dependencies */
-	features = netdev_fix_features(dev, features);
+	netdev_fix_features(dev, features);
 
 	/* some features can't be enabled if they're off on an upper device */
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
-		features = netdev_sync_upper_features(dev, upper, features);
+		netdev_sync_upper_features(dev, upper, features);
 
-	if (dev->features == features)
+	if (netdev_features_equal(dev->features, features))
 		goto sync_lower;
 
-	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
-		&dev->features, &features);
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		netdev_dbg(dev, "Features[%u] changed: %pNF -> %pNF\n",
+			   i, &dev->features[i], &features[i]);
 
 	if (dev->netdev_ops->ndo_set_features)
 		err = dev->netdev_ops->ndo_set_features(dev, features);
@@ -9971,9 +9979,10 @@ int __netdev_update_features(struct net_device *dev)
 		err = 0;
 
 	if (unlikely(err < 0)) {
-		netdev_err(dev,
-			"set_features() failed (%d); wanted %pNF, left %pNF\n",
-			err, &features, &dev->features);
+		for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+			netdev_err(dev,
+				   "set_features() failed (%d); wanted[%u] %pNF, left[%u] %pNF\n",
+				   err, i, &features[i], i, &dev->features[i]);
 		/* return non-0 since some features might have changed and
 		 * it's better to fire a spurious notification than miss it
 		 */
@@ -9988,9 +9997,10 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->features;
+		netdev_features_t diff[NETDEV_FEATURE_DWORDS];
 
-		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
+		netdev_features_xor(diff, features, dev->features);
+		if (diff[0] & NETIF_F_RX_UDP_TUNNEL_PORT) {
 			/* udp_tunnel_{get,drop}_rx_info both need
 			 * NETIF_F_RX_UDP_TUNNEL_PORT enabled on the
 			 * device, or they won't do anything.
@@ -9998,33 +10008,33 @@ int __netdev_update_features(struct net_device *dev)
 			 * *before* calling udp_tunnel_get_rx_info,
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
-			if (features & NETIF_F_RX_UDP_TUNNEL_PORT) {
-				dev->features = features;
+			if (features[0] & NETIF_F_RX_UDP_TUNNEL_PORT) {
+				dev->features[0] = features[0];
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-				dev->features = features;
+		if (diff[0] & NETIF_F_HW_VLAN_CTAG_FILTER) {
+			if (features[0] & NETIF_F_HW_VLAN_CTAG_FILTER) {
+				dev->features[0] = features[0];
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_STAG_FILTER) {
+		if (diff[0] & NETIF_F_HW_VLAN_STAG_FILTER) {
 			if (features & NETIF_F_HW_VLAN_STAG_FILTER) {
-				dev->features = features;
+				dev->features[0] = features[0];
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		dev->features = features;
+		netdev_features_copy(dev->features, features);
 	}
 
 	return err < 0 ? 0 : 1;
@@ -10213,7 +10223,7 @@ int register_netdevice(struct net_device *dev)
 	int ret;
 	struct net *net = dev_net(dev);
 
-	BUILD_BUG_ON(sizeof(netdev_features_t) * BITS_PER_BYTE <
+	BUILD_BUG_ON(sizeof(dev->features) * BITS_PER_BYTE <
 		     NETDEV_FEATURE_COUNT);
 	BUG_ON(dev_boot_phase);
 	ASSERT_RTNL();
@@ -10250,7 +10260,7 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if (((dev->hw_features | dev->features) &
+	if (((dev->hw_features[0] | dev->features[0]) &
 	     NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
@@ -10268,44 +10278,46 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
-	dev->features |= NETIF_F_SOFT_FEATURES;
+	dev->hw_features[0] |=
+			(NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
+	dev->features[0] |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->udp_tunnel_nic_info) {
-		dev->features |= NETIF_F_RX_UDP_TUNNEL_PORT;
-		dev->hw_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
+		dev->features[0] |= NETIF_F_RX_UDP_TUNNEL_PORT;
+		dev->hw_features[0] |= NETIF_F_RX_UDP_TUNNEL_PORT;
 	}
 
-	dev->wanted_features = dev->features & dev->hw_features;
+	netdev_features_and(dev->wanted_features, dev->features,
+			    dev->hw_features);
 
 	if (!(dev->flags & IFF_LOOPBACK))
-		dev->hw_features |= NETIF_F_NOCACHE_COPY;
+		dev->hw_features[0] |= NETIF_F_NOCACHE_COPY;
 
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
+	if (dev->hw_features[0] & NETIF_F_TSO)
+		dev->hw_features[0] |= NETIF_F_TSO_MANGLEID;
+	if (dev->vlan_features[0] & NETIF_F_TSO)
+		dev->vlan_features[0] |= NETIF_F_TSO_MANGLEID;
+	if (dev->mpls_features[0] & NETIF_F_TSO)
+		dev->mpls_features[0] |= NETIF_F_TSO_MANGLEID;
+	if (dev->hw_enc_features[0] & NETIF_F_TSO)
+		dev->hw_enc_features[0] |= NETIF_F_TSO_MANGLEID;
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
-	dev->vlan_features |= NETIF_F_HIGHDMA;
+	dev->vlan_features[0] |= NETIF_F_HIGHDMA;
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG | NETIF_F_GSO_PARTIAL;
+	dev->hw_enc_features[0] |= NETIF_F_SG | NETIF_F_GSO_PARTIAL;
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
-	dev->mpls_features |= NETIF_F_SG;
+	dev->mpls_features[0] |= NETIF_F_SG;
 
 	ret = call_netdevice_notifiers(NETDEV_POST_INIT, dev);
 	ret = notifier_to_errno(ret);
@@ -11146,7 +11158,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* Don't allow namespace local devices to be moved. */
 	err = -EINVAL;
-	if (dev->features & NETIF_F_NETNS_LOCAL)
+	if (dev->features[0] & NETIF_F_NETNS_LOCAL)
 		goto out;
 
 	/* Ensure the device has been registrered */
@@ -11506,7 +11518,7 @@ static void __net_exit default_device_exit(struct net *net)
 		char fb_name[IFNAMSIZ];
 
 		/* Ignore unmoveable devices (i.e. loopback) */
-		if (dev->features & NETIF_F_NETNS_LOCAL)
+		if (dev->features[0] & NETIF_F_NETNS_LOCAL)
 			continue;
 
 		/* Leave virtual devices for the generic cleanup */
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 0a6b047..2c0adf4 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -74,13 +74,13 @@ static netdev_tx_t netpoll_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev,
 				      struct netdev_queue *txq)
 {
+	netdev_features_t features[NETDEV_FEATURE_DWORDS];
 	netdev_tx_t status = NETDEV_TX_OK;
-	netdev_features_t features;
 
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, features);
 
 	if (skb_vlan_tag_present(skb) &&
-	    !vlan_hw_offload_capable(features, skb->vlan_proto)) {
+	    !vlan_hw_offload_capable(features[0], skb->vlan_proto)) {
 		skb = __vlan_hwaccel_push_inside(skb);
 		if (unlikely(!skb)) {
 			/* This is actually a packet drop, but we
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 1c9f4df..0eedb17 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -25,12 +25,13 @@ const struct nla_policy ethnl_features_get_policy[] = {
 		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
-static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
+static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t *src)
 {
+	u32 *__src = (u32 *)src;
 	unsigned int i;
 
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
-		dest[i] = src >> (32 * i);
+		dest[i] = __src[i];
 }
 
 static int features_prepare_data(const struct ethnl_req_info *req_base,
@@ -38,15 +39,23 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 				 struct genl_info *info)
 {
 	struct features_reply_data *data = FEATURES_REPDATA(reply_base);
+	netdev_features_t features[NETDEV_FEATURE_DWORDS] = {0};
 	struct net_device *dev = reply_base->dev;
-	netdev_features_t all_features;
+	unsigned int i;
 
 	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
 	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
 	ethnl_features_to_bitmap32(data->active, dev->features);
-	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
-	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
-	ethnl_features_to_bitmap32(data->all, all_features);
+	features[0] = NETIF_F_NEVER_CHANGE;
+	ethnl_features_to_bitmap32(data->nochange, features);
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++) {
+		if (NETDEV_FEATURE_COUNT >= (i + 1) * 64)
+			features[i] = GENMASK_ULL(63, 0);
+		else
+			features[i] = GENMASK_ULL(NETDEV_FEATURE_COUNT - i * 64,
+						  0);
+	}
+	ethnl_features_to_bitmap32(data->all, features);
 
 	return 0;
 }
@@ -131,27 +140,29 @@ const struct nla_policy ethnl_features_set_policy[] = {
 	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
 };
 
-static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
+static void ethnl_features_to_bitmap(unsigned long *dest,
+				     netdev_features_t *val)
 {
 	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
 	unsigned int i;
 
 	bitmap_zero(dest, NETDEV_FEATURE_COUNT);
 	for (i = 0; i < words; i++)
-		dest[i] = (unsigned long)(val >> (i * BITS_PER_LONG));
+		dest[i] =
+			(unsigned long)(val[i / 2] >> (i % 2 * BITS_PER_LONG));
 }
 
-static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
+static void ethnl_bitmap_to_features(netdev_features_t *val, unsigned long *src)
 {
-	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
 	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
-	netdev_features_t ret = 0;
 	unsigned int i;
 
+	for (i = 0; i < NETDEV_FEATURE_DWORDS; i++)
+		val[i] = 0;
+
 	for (i = 0; i < words; i++)
-		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
-	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
-	return ret;
+		val[i / 2] |=
+			(netdev_features_t)(src[i]) << (i % 2 * BITS_PER_LONG);
 }
 
 static int features_send_reply(struct net_device *dev, struct genl_info *info,
@@ -212,12 +223,14 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 {
 	DECLARE_BITMAP(wanted_diff_mask, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(active_diff_mask, NETDEV_FEATURE_COUNT);
+	netdev_features_t features[NETDEV_FEATURE_DWORDS];
 	DECLARE_BITMAP(old_active, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(old_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(new_active, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(new_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
 	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
+	netdev_features_t tmp[NETDEV_FEATURE_DWORDS];
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
@@ -242,7 +255,11 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 				 netdev_features_strings, info->extack);
 	if (ret < 0)
 		goto out_rtnl;
-	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
+
+	ethnl_bitmap_to_features(features, req_mask);
+	netdev_features_ethtool_bits(tmp);
+	netdev_features_andnot(features, features, tmp);
+	if (!netdev_features_empty(features)) {
 		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
 		ret = -EINVAL;
 		goto out_rtnl;
@@ -253,8 +270,13 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		dev->wanted_features &= ~dev->hw_features;
-		dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		netdev_features_andnot(dev->wanted_features,
+				       dev->wanted_features,
+				       dev->hw_features);
+		ethnl_bitmap_to_features(features, req_wanted);
+		netdev_features_and(features, features, dev->hw_features);
+		netdev_features_or(dev->wanted_features, dev->wanted_features,
+				   features);
 		__netdev_update_features(dev);
 	}
 	ethnl_features_to_bitmap(new_active, dev->features);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index baa5d10..f213ec9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -67,12 +67,15 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 	int i;
 
 	/* in case feature bits run out again */
-	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(netdev_features_t));
+	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(dev->features));
 
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		features[i].available = (u32)(dev->hw_features >> (32 * i));
-		features[i].requested = (u32)(dev->wanted_features >> (32 * i));
-		features[i].active = (u32)(dev->features >> (32 * i));
+		features[i].available =
+			(u32)(dev->hw_features[i / 2] >> (i % 2 * 32));
+		features[i].requested =
+			(u32)(dev->wanted_features[i / 2] >> (i % 2 * 32));
+		features[i].active =
+			(u32)(dev->features[i / 2] >> (i % 2 * 32));
 		features[i].never_changed =
 			(u32)(NETIF_F_NEVER_CHANGE >> (32 * i));
 	}
@@ -97,7 +100,9 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
-	netdev_features_t wanted = 0, valid = 0;
+	netdev_features_t wanted[NETDEV_FEATURE_DWORDS] = {0};
+	netdev_features_t valid[NETDEV_FEATURE_DWORDS] = {0};
+	netdev_features_t tmp[NETDEV_FEATURE_DWORDS];
 	int i, ret = 0;
 
 	if (copy_from_user(&cmd, useraddr, sizeof(cmd)))
@@ -111,23 +116,33 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 		return -EFAULT;
 
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		valid |= (netdev_features_t)features[i].valid << (32 * i);
-		wanted |= (netdev_features_t)features[i].requested << (32 * i);
+		valid[i / 2] |=
+			(netdev_features_t)features[i].valid << (32 * i);
+		wanted[i / 2] |=
+			(netdev_features_t)features[i].requested << (32 * i);
 	}
 
-	if (valid & ~NETIF_F_ETHTOOL_BITS)
+	netdev_features_ethtool_bits(tmp);
+	netdev_features_andnot(tmp, features, tmp);
+	if (!netdev_features_empty(tmp))
 		return -EINVAL;
 
-	if (valid & ~dev->hw_features) {
-		valid &= dev->hw_features;
+	netdev_features_andnot(tmp, valid, dev->hw_features);
+
+	if (!netdev_features_empty(tmp)) {
+		netdev_features_and(valid, valid, dev->hw_features);
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
-	dev->wanted_features &= ~valid;
-	dev->wanted_features |= wanted & valid;
+	netdev_features_andnot(dev->wanted_features, dev->wanted_features,
+			       valid);
+	netdev_features_and(wanted, wanted, valid);
+	netdev_features_or(dev->wanted_features, dev->wanted_features, wanted);
 	__netdev_update_features(dev);
 
-	if ((dev->wanted_features ^ dev->features) & valid)
+	netdev_features_xor(tmp, dev->wanted_features, dev->features);
+	netdev_features_and(tmp, tmp, valid);
+	if (!netdev_features_empty(tmp))
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
@@ -227,7 +242,7 @@ static int ethtool_get_one_feature(struct net_device *dev,
 	netdev_features_t mask = ethtool_get_feature_mask(ethcmd);
 	struct ethtool_value edata = {
 		.cmd = ethcmd,
-		.data = !!(dev->features & mask),
+		.data = !!(dev->features[0] & mask),
 	};
 
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
@@ -238,21 +253,23 @@ static int ethtool_get_one_feature(struct net_device *dev,
 static int ethtool_set_one_feature(struct net_device *dev,
 	void __user *useraddr, u32 ethcmd)
 {
+	netdev_features_t mask[NETDEV_FEATURE_DWORDS] = {0};
 	struct ethtool_value edata;
-	netdev_features_t mask;
 
 	if (copy_from_user(&edata, useraddr, sizeof(edata)))
 		return -EFAULT;
 
-	mask = ethtool_get_feature_mask(ethcmd);
-	mask &= dev->hw_features;
-	if (!mask)
+	mask[0] = ethtool_get_feature_mask(ethcmd);
+	netdev_features_and(mask, mask, dev->hw_features);
+	if (netdev_features_empty(mask))
 		return -EOPNOTSUPP;
 
 	if (edata.data)
-		dev->wanted_features |= mask;
+		netdev_features_or(dev->wanted_features, dev->wanted_features,
+				   mask)
 	else
-		dev->wanted_features &= ~mask;
+		netdev_features_andnot(dev->wanted_features,
+				       dev->wanted_features, mask);
 
 	__netdev_update_features(dev);
 
@@ -285,29 +302,37 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
-	netdev_features_t features = 0, changed;
+	netdev_features_t features[NETDEV_FEATURE_DWORDS] = {0};
+	netdev_features_t changed[NETDEV_FEATURE_DWORDS];
+	netdev_features_t tmp[NETDEV_FEATURE_DWORDS];
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
 
 	if (data & ETH_FLAG_LRO)
-		features |= NETIF_F_LRO;
+		features[0] |= NETIF_F_LRO;
 	if (data & ETH_FLAG_RXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_RX;
+		features[0] |= NETIF_F_HW_VLAN_CTAG_RX;
 	if (data & ETH_FLAG_TXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		features[0] |= NETIF_F_HW_VLAN_CTAG_TX;
 	if (data & ETH_FLAG_NTUPLE)
-		features |= NETIF_F_NTUPLE;
+		features[0] |= NETIF_F_NTUPLE;
 	if (data & ETH_FLAG_RXHASH)
-		features |= NETIF_F_RXHASH;
+		features[0] |= NETIF_F_RXHASH;
 
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->features) & ETH_ALL_FEATURES;
-	if (changed & ~dev->hw_features)
-		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
+	netdev_features_xor(changed, features, dev->features);
+	changed[0] &= ETH_ALL_FEATURES;
+
+	netdev_features_andnot(tmp, changed, dev->hw_features);
+	if (!netdev_features_empty(tmp)) {
+		netdev_features_and(tmp, changed, dev->hw_features);
+		return (!netdev_features_empty(tmp)) ? -EINVAL : -EOPNOTSUPP;
+	}
 
-	dev->wanted_features =
-		(dev->wanted_features & ~changed) | (features & changed);
+	netdev_features_andnot(tmp, dev->wanted_features, changed);
+	netdev_features_and(features, features, changed);
+	netdev_features_or(dev->wanted_features, tmp, features);
 
 	__netdev_update_features(dev);
 
@@ -2587,7 +2612,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	void __user *useraddr = ifr->ifr_data;
 	u32 ethcmd, sub_cmd;
 	int rc;
-	netdev_features_t old_features;
+	netdev_features_t old_features[NETDEV_FEATURE_DWORDS];
 
 	if (!dev || !netif_device_present(dev))
 		return -ENODEV;
@@ -2650,7 +2675,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 		if (rc  < 0)
 			return rc;
 	}
-	old_features = dev->features;
+	netdev_features_copy(old_features, dev->features);
 
 	switch (ethcmd) {
 	case ETHTOOL_GSET:
@@ -2865,7 +2890,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	if (dev->ethtool_ops->complete)
 		dev->ethtool_ops->complete(dev);
 
-	if (old_features != dev->features)
+	if (!netdev_features_equal(old_features, dev->features))
 		netdev_features_change(dev);
 
 	return rc;
-- 
2.8.1

