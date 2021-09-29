Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA28F41C8FD
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345764AbhI2QAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27910 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343804AbhI2P7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWr15bJzbmrK;
        Wed, 29 Sep 2021 23:53:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 034/167] hv_netvsc: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:21 +0800
Message-ID: <20210929155334.12454-35-shenjian15@huawei.com>
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
 drivers/net/hyperv/netvsc_bpf.c   |  2 +-
 drivers/net/hyperv/netvsc_drv.c   | 38 ++++++++++++++++++-------------
 drivers/net/hyperv/rndis_filter.c | 30 +++++++++++++++---------
 3 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index aa877da113f8..058a92696cbc 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -114,7 +114,7 @@ int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
 
-	if (prog && (dev->features & NETIF_F_LRO)) {
+	if (prog && netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features)) {
 		netdev_err(dev, "XDP: not support LRO\n");
 		NL_SET_ERR_MSG_MOD(extack, "XDP: not support LRO");
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 5371328422ec..22875a7ef1ff 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -892,13 +892,15 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	}
 
 	/* Do L4 checksum offload if enabled and present. */
-	if ((ppi_flags & NVSC_RSC_CSUM_INFO) && (net->features & NETIF_F_RXCSUM)) {
+	if ((ppi_flags & NVSC_RSC_CSUM_INFO) &&
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, net->features)) {
 		if (csum_info->receive.tcp_checksum_succeeded ||
 		    csum_info->receive.udp_checksum_succeeded)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	if ((ppi_flags & NVSC_RSC_HASH_INFO) && (net->features & NETIF_F_RXHASH))
+	if ((ppi_flags & NVSC_RSC_HASH_INFO) &&
+	    netdev_feature_test_bit(NETIF_F_RXHASH_BIT, net->features))
 		skb_set_hash(skb, *hash_info, PKT_HASH_TYPE_L4);
 
 	if (ppi_flags & NVSC_RSC_VLAN) {
@@ -1205,7 +1207,8 @@ static void netvsc_init_settings(struct net_device *dev)
 	ndc->speed = SPEED_UNKNOWN;
 	ndc->duplex = DUPLEX_FULL;
 
-	dev->features = NETIF_F_LRO;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bit(NETIF_F_LRO_BIT, &dev->features);
 }
 
 static int netvsc_get_link_ksettings(struct net_device *dev,
@@ -1928,8 +1931,9 @@ static void netvsc_fix_features(struct net_device *ndev,
 	if (!nvdev || nvdev->destroy)
 		return;
 
-	if ((*features & NETIF_F_LRO) && netvsc_xdp_get(nvdev)) {
-		*features ^= NETIF_F_LRO;
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *features) &&
+	    netvsc_xdp_get(nvdev)) {
+		netdev_feature_change_bit(NETIF_F_LRO_BIT, features);
 		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
 	}
 }
@@ -1937,22 +1941,24 @@ static void netvsc_fix_features(struct net_device *ndev,
 static int netvsc_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
-	netdev_features_t change = features ^ ndev->features;
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
 	struct net_device *vf_netdev = rtnl_dereference(ndevctx->vf_netdev);
 	struct ndis_offload_params offloads;
+	netdev_features_t change;
 	int ret = 0;
 
 	if (!nvdev || nvdev->destroy)
 		return -ENODEV;
 
-	if (!(change & NETIF_F_LRO))
+	netdev_feature_xor(&change, features, ndev->features);
+
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, change))
 		goto syncvf;
 
 	memset(&offloads, 0, sizeof(struct ndis_offload_params));
 
-	if (features & NETIF_F_LRO) {
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
 		offloads.rsc_ip_v4 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 		offloads.rsc_ip_v6 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 	} else {
@@ -1963,15 +1969,15 @@ static int netvsc_set_features(struct net_device *ndev,
 	ret = rndis_filter_set_offload_params(ndev, nvdev, &offloads);
 
 	if (ret) {
-		features ^= NETIF_F_LRO;
-		ndev->features = features;
+		netdev_feature_change_bit(NETIF_F_LRO_BIT, &features);
+		netdev_feature_copy(&ndev->features, features);
 	}
 
 syncvf:
 	if (!vf_netdev)
 		return ret;
 
-	vf_netdev->wanted_features = features;
+	netdev_feature_copy(&vf_netdev->wanted_features, features);
 	netdev_update_features(vf_netdev);
 
 	return ret;
@@ -2385,7 +2391,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	if (ndev->needed_headroom < vf_netdev->needed_headroom)
 		ndev->needed_headroom = vf_netdev->needed_headroom;
 
-	vf_netdev->wanted_features = ndev->features;
+	netdev_feature_copy(&vf_netdev->wanted_features, ndev->features);
 	netdev_update_features(vf_netdev);
 
 	prog = netvsc_xdp_get(netvsc_dev);
@@ -2550,10 +2556,10 @@ static int netvsc_probe(struct hv_device *dev,
 		schedule_work(&nvdev->subchan_work);
 
 	/* hw_features computed in rndis_netdev_set_hwcaps() */
-	net->features = net->hw_features |
-		NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
-	net->vlan_features = net->features;
+	netdev_feature_copy(&net->features, net->hw_features);
+	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &net->features);
+	netdev_feature_copy(&net->vlan_features, net->features);
 
 	netdev_lockdep_set_classes(net);
 
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index f6c9c2a670f9..115ebe0b970a 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1348,6 +1348,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	struct ndis_offload hwcaps;
 	struct ndis_offload_params offloads;
 	unsigned int gso_max_size = GSO_MAX_SIZE;
+	netdev_features_t tmp;
 	int ret;
 
 	/* Find HW offload capabilities */
@@ -1362,24 +1363,26 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	offloads.ip_v4_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_DISABLED;
 
 	/* Reset previously set hw_features flags */
-	net->hw_features &= ~NETVSC_SUPPORTED_HW_FEATURES;
+	netdev_feature_clear_bits(NETVSC_SUPPORTED_HW_FEATURES,
+				  &net->hw_features);
 	net_device_ctx->tx_checksum_mask = 0;
 
 	/* Compute tx offload settings based on hw capabilities */
-	net->hw_features |= NETIF_F_RXCSUM;
-	net->hw_features |= NETIF_F_SG;
-	net->hw_features |= NETIF_F_RXHASH;
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &net->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &net->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &net->hw_features);
 
 	if ((hwcaps.csum.ip4_txcsum & NDIS_TXCSUM_ALL_TCP4) == NDIS_TXCSUM_ALL_TCP4) {
 		/* Can checksum TCP */
-		net->hw_features |= NETIF_F_IP_CSUM;
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &net->hw_features);
 		net_device_ctx->tx_checksum_mask |= TRANSPORT_INFO_IPV4_TCP;
 
 		offloads.tcp_ip_v4_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_ENABLED;
 
 		if (hwcaps.lsov2.ip4_encap & NDIS_OFFLOAD_ENCAP_8023) {
 			offloads.lso_v2_ipv4 = NDIS_OFFLOAD_PARAMETERS_LSOV2_ENABLED;
-			net->hw_features |= NETIF_F_TSO;
+			netdev_feature_set_bit(NETIF_F_TSO_BIT,
+					       &net->hw_features);
 
 			if (hwcaps.lsov2.ip4_maxsz < gso_max_size)
 				gso_max_size = hwcaps.lsov2.ip4_maxsz;
@@ -1392,7 +1395,8 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	}
 
 	if ((hwcaps.csum.ip6_txcsum & NDIS_TXCSUM_ALL_TCP6) == NDIS_TXCSUM_ALL_TCP6) {
-		net->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+				       &net->hw_features);
 
 		offloads.tcp_ip_v6_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_ENABLED;
 		net_device_ctx->tx_checksum_mask |= TRANSPORT_INFO_IPV6_TCP;
@@ -1400,7 +1404,8 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 		if ((hwcaps.lsov2.ip6_encap & NDIS_OFFLOAD_ENCAP_8023) &&
 		    (hwcaps.lsov2.ip6_opts & NDIS_LSOV2_CAP_IP6) == NDIS_LSOV2_CAP_IP6) {
 			offloads.lso_v2_ipv6 = NDIS_OFFLOAD_PARAMETERS_LSOV2_ENABLED;
-			net->hw_features |= NETIF_F_TSO6;
+			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+					       &net->hw_features);
 
 			if (hwcaps.lsov2.ip6_maxsz < gso_max_size)
 				gso_max_size = hwcaps.lsov2.ip6_maxsz;
@@ -1413,9 +1418,9 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	}
 
 	if (hwcaps.rsc.ip4 && hwcaps.rsc.ip6) {
-		net->hw_features |= NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, &net->hw_features);
 
-		if (net->features & NETIF_F_LRO) {
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, net->features)) {
 			offloads.rsc_ip_v4 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 			offloads.rsc_ip_v6 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 		} else {
@@ -1427,7 +1432,10 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	/* In case some hw_features disappeared we need to remove them from
 	 * net->features list as they're no longer supported.
 	 */
-	net->features &= ~NETVSC_SUPPORTED_HW_FEATURES | net->hw_features;
+	netdev_feature_fill(&tmp);
+	netdev_feature_clear_bits(NETVSC_SUPPORTED_HW_FEATURES, &tmp);
+	netdev_feature_or(&tmp, tmp, net->hw_features);
+	netdev_feature_and(&net->features, net->features, tmp);
 
 	netif_set_gso_max_size(net, gso_max_size);
 
-- 
2.33.0

