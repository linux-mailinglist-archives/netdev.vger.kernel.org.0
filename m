Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4747941C93E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345301AbhI2QC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12991 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345544AbhI2P74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:56 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbS6XcmzWYZw;
        Wed, 29 Sep 2021 23:56:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 110/167] net: nfp: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:37 +0800
Message-ID: <20210929155334.12454-111-shenjian15@huawei.com>
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
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 12 ++-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 96 ++++++++++++-------
 .../net/ethernet/netronome/nfp/nfp_net_repr.c | 64 ++++++++-----
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  3 +-
 4 files changed, 110 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 84d66d138c3d..a5bee5d35d2c 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -587,12 +587,16 @@ int nfp_net_tls_init(struct nfp_net *nn)
 		return err;
 
 	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_RX) {
-		netdev->hw_features |= NETIF_F_HW_TLS_RX;
-		netdev->features |= NETIF_F_HW_TLS_RX;
+		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
+				       &netdev->features);
 	}
 	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_TX) {
-		netdev->hw_features |= NETIF_F_HW_TLS_TX;
-		netdev->features |= NETIF_F_HW_TLS_TX;
+		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
+				       &netdev->features);
 	}
 
 	netdev->tlsdev_ops = &nfp_net_tls_ops;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 6261596cfda6..63aa017804a5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1594,7 +1594,7 @@ static void nfp_net_rx_csum(struct nfp_net_dp *dp,
 {
 	skb_checksum_none_assert(skb);
 
-	if (!(dp->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dp->netdev->features))
 		return;
 
 	if (meta->csum_type) {
@@ -1638,7 +1638,7 @@ static void
 nfp_net_set_hash(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		 unsigned int type, __be32 *hash)
 {
-	if (!(netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		return;
 
 	switch (type) {
@@ -3518,8 +3518,8 @@ static void nfp_net_stat64(struct net_device *netdev,
 static int nfp_net_set_features(struct net_device *netdev,
 				netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct nfp_net *nn = netdev_priv(netdev);
+	netdev_features_t changed;
 	u32 new_ctrl;
 	int err;
 
@@ -3527,51 +3527,60 @@ static int nfp_net_set_features(struct net_device *netdev,
 
 	new_ctrl = nn->dp.ctrl;
 
-	if (changed & NETIF_F_RXCSUM) {
-		if (features & NETIF_F_RXCSUM)
+	netdev_feature_xor(&changed, netdev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 
-	if (changed & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     changed)) {
+		if (netdev_feature_test_bits(NETIF_F_IP_CSUM |
+					     NETIF_F_IPV6_CSUM, features))
 			new_ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXCSUM;
 	}
 
-	if (changed & (NETIF_F_TSO | NETIF_F_TSO6)) {
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6, changed)) {
+		if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					     features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					      NFP_NET_CFG_CTRL_LSO;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_LSO_ANY;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
 			new_ctrl |= NFP_NET_CFG_CTRL_RXVLAN;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXVLAN;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_TX) {
-		if (features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					    features))
 			new_ctrl |= NFP_NET_CFG_CTRL_TXVLAN;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXVLAN;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    changed)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    features))
 			new_ctrl |= NFP_NET_CFG_CTRL_CTAG_FILTER;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
 
-	if (changed & NETIF_F_SG) {
-		if (features & NETIF_F_SG)
+	if (netdev_feature_test_bit(NETIF_F_SG_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_SG_BIT, features))
 			new_ctrl |= NFP_NET_CFG_CTRL_GATHER;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_GATHER;
@@ -3620,7 +3629,7 @@ static void nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		 * metadata prepend - 8B
 		 */
 		if (unlikely(hdrlen > NFP_NET_LSO_MAX_HDR_SZ - 8))
-			*features &= ~NETIF_F_GSO_MASK;
+			netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 	}
 
 	/* VXLAN/GRE check */
@@ -3632,7 +3641,8 @@ static void nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					  features);
 		return;
 	}
 
@@ -3642,7 +3652,8 @@ static void nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	    (l4_hdr == IPPROTO_UDP &&
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)))) {
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					  features);
 		return;
 	}
 }
@@ -4030,67 +4041,80 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	if (nn->cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev->hw_features = NETIF_F_HIGHDMA;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->hw_features);
+
 	if (nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY) {
-		netdev->hw_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &netdev->hw_features);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXCSUM) {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+					&netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_GATHER) {
-		netdev->hw_features |= NETIF_F_SG;
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_GATHER;
 	}
 	if ((nn->cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    nn->cap & NFP_NET_CFG_CTRL_LSO2) {
-		netdev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&netdev->hw_features);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					 NFP_NET_CFG_CTRL_LSO;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_RSS_ANY)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
+				       &netdev->hw_features);
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       &netdev->hw_features);
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_NVGRE) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_GRE;
+			netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
+					       &netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_NVGRE;
 	}
 	if (nn->cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
-		netdev->hw_enc_features = netdev->hw_features;
+		netdev_feature_copy(&netdev->hw_enc_features,
+				    netdev->hw_features);
 
-	netdev->vlan_features = netdev->hw_features;
+	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
 
 	if (nn->cap & NFP_NET_CFG_CTRL_RXVLAN) {
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       &netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_RXVLAN;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXVLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO2) {
 			nn_warn(nn, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		} else {
-			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					       &netdev->hw_features);
 			nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXVLAN;
 		}
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_CTAG_FILTER) {
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
 
-	netdev->features = netdev->hw_features;
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 
 	if (nfp_app_has_tc(nn->app) && nn->port)
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
 
 	/* Advertise but disable TSO by default. */
-	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+	netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
+				  &netdev->features);
 	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_LSO_ANY;
 
 	/* Finalise the netdev setup */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index fcb2e30e8ac7..a9afa3bf8c56 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -236,19 +236,23 @@ static void nfp_repr_fix_features(struct net_device *netdev,
 				  netdev_features_t *features)
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
-	netdev_features_t old_features = *features;
 	netdev_features_t lower_features;
+	netdev_features_t old_features;
 	struct net_device *lower_dev;
 
 	lower_dev = repr->dst->u.port_info.lower_dev;
 
-	lower_features = lower_dev->features;
-	if (lower_features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
-		lower_features |= NETIF_F_HW_CSUM;
+	netdev_feature_copy(&old_features, *features);
+	netdev_feature_copy(&lower_features, lower_dev->features);
+	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     lower_features))
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &lower_features);
 
 	netdev_intersect_features(features, *features, lower_features);
-	*features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_HW_TC);
-	*features |= NETIF_F_LLTX;
+	netdev_feature_and_bits(NETIF_F_SOFT_FEATURES | NETIF_F_HW_TC,
+				&old_features);
+	netdev_feature_or(features, *features, old_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, features);
 }
 
 const struct net_device_ops nfp_repr_netdev_ops = {
@@ -339,54 +343,66 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	if (repr_cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev->hw_features = NETIF_F_HIGHDMA;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_RXCSUM_ANY)
-		netdev->hw_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_TXCSUM)
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+					&netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_GATHER)
-		netdev->hw_features |= NETIF_F_SG;
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
 	if ((repr_cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    repr_cap & NFP_NET_CFG_CTRL_LSO2)
-		netdev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_RSS_ANY)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
+				       &netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+					       &netdev->hw_features);
 	}
 	if (repr_cap & NFP_NET_CFG_CTRL_NVGRE) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_GRE;
+			netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
+					       &netdev->hw_features);
 	}
 	if (repr_cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
-		netdev->hw_enc_features = netdev->hw_features;
+		netdev_feature_copy(&netdev->hw_enc_features,
+				    netdev->hw_features);
 
-	netdev->vlan_features = netdev->hw_features;
+	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
 
 	if (repr_cap & NFP_NET_CFG_CTRL_RXVLAN)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       &netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_TXVLAN) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO2)
 			netdev_warn(netdev, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		else
-			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					       &netdev->hw_features);
 	}
 	if (repr_cap & NFP_NET_CFG_CTRL_CTAG_FILTER)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->hw_features);
 
-	netdev->features = netdev->hw_features;
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 
 	/* Advertise but disable TSO by default. */
-	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+	netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
+				  &netdev->features);
 	netdev->gso_max_segs = NFP_NET_LSO_MAX_SEGS;
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
-	netdev->features |= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &netdev->features);
 
 	if (nfp_app_has_tc(app)) {
-		netdev->features |= NETIF_F_HW_TC;
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
 	}
 
 	err = nfp_app_repr_init(app, netdev);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 93c5bfc0510b..67ba30ff6f42 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -66,7 +66,8 @@ int nfp_port_set_features(struct net_device *netdev, netdev_features_t features)
 	if (!port)
 		return 0;
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, netdev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features) &&
 	    port->tc_offload_cnt) {
 		netdev_err(netdev, "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
-- 
2.33.0

