Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5994E666A
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351498AbiCXP5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351442AbiCXP4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D5AAD10B
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KPVBQ1T7tzfYwD;
        Thu, 24 Mar 2022 23:53:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 06/20] net: simplify the netdev features expression
Date:   Thu, 24 Mar 2022 23:49:18 +0800
Message-ID: <20220324154932.17557-7-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324154932.17557-1-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make the semantic patches simple, split the complex opreation of
netdev_features to simple ones, and replace some feature macroes with
global netdev features variables.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 10 +--
 drivers/net/ethernet/sfc/ef10.c               |  5 +-
 drivers/net/ethernet/sfc/efx.c                |  7 +-
 drivers/net/ethernet/sfc/efx_common.c         | 14 ++--
 drivers/net/ethernet/sfc/falcon/efx.c         | 12 ++--
 include/linux/netdevice.h                     | 14 ++--
 net/core/dev.c                                | 69 ++++++++++++-------
 net/ethtool/features.c                        |  4 +-
 net/ethtool/ioctl.c                           | 47 +++++++++----
 9 files changed, 120 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 58df89f783fb..87cd9187884c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2465,7 +2465,7 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features &= ~netdev_csum_gso_features_mask;
 
 	return features;
 }
@@ -3284,7 +3284,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev->active_features |= NETIF_F_HW_CSUM;
 	else
-		netdev->active_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->active_features |= netdev_ip_csum_features;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev->active_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
@@ -3300,9 +3300,11 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev_features_set_array(hns3_vlan_off_features_array,
 				  ARRAY_SIZE(hns3_vlan_off_features_array),
 				  &vlan_off_features);
-	netdev->vlan_features |= netdev->active_features & ~vlan_off_features;
+	features = netdev->active_features & ~vlan_off_features;
+	netdev->vlan_features |= features;
 
-	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
+	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 84aaa4259eb7..0d75361f1acb 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1358,7 +1358,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		hw_enc_features |= netdev_ip_csum_features;
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
@@ -1368,7 +1368,8 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 					  ARRAY_SIZE(ef10_tso_features_array),
 					  &encap_tso_features);
 
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
+		hw_enc_features |= encap_tso_features;
+		hw_enc_features |= NETIF_F_TSO;
 		efx->net_dev->active_features |= encap_tso_features;
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 607347332bb8..139f63f93227 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1006,6 +1006,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
 	int rc = efx_pci_probe_main(efx);
+	netdev_features_t tmp;
 
 	if (rc)
 		return rc;
@@ -1021,7 +1022,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	net_dev->active_features |= *efx->type->offload_features;
 	netdev_active_features_set_array(net_dev, efx_active_features_array,
 					 ARRAY_SIZE(efx_active_features_array));
-	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
+	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
 		net_dev->active_features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
@@ -1031,7 +1033,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
 				       ARRAY_SIZE(efx_vlan_features_array));
 
-	net_dev->hw_features |= net_dev->active_features & ~efx->fixed_features;
+	tmp = net_dev->active_features & ~efx->fixed_features;
+	net_dev->hw_features |= tmp;
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->active_features &= ~NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index cee20b4a34e7..d5f8a2b3189a 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -212,10 +212,12 @@ void efx_set_rx_mode(struct net_device *net_dev)
 int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
+	netdev_features_t tmp;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->active_features & ~data & NETIF_F_NTUPLE) {
+	tmp = net_dev->active_features & ~data;
+	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -224,8 +226,9 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	if ((net_dev->active_features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
-						 NETIF_F_RXFCS)) {
+	tmp = net_dev->active_features ^ data;
+	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER ||
+	    tmp & NETIF_F_RXFCS) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -1367,10 +1370,9 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
 				features &= ~(NETIF_F_GSO_MASK);
-		if (features & (NETIF_F_GSO_MASK | NETIF_F_CSUM_MASK))
+		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~(NETIF_F_GSO_MASK |
-					      NETIF_F_CSUM_MASK);
+				features &= ~netdev_csum_gso_features_mask;
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 4631706f157f..2eae365eb7e6 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2188,17 +2188,20 @@ static void ef4_set_rx_mode(struct net_device *net_dev)
 static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
+	netdev_features_t tmp;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->active_features & ~data & NETIF_F_NTUPLE) {
+	tmp = net_dev->active_features & ~data;
+	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	if ((net_dev->active_features ^ data) & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	tmp = net_dev->active_features ^ data;
+	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -2911,8 +2914,9 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->active_features |= (*efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_RXCSUM);
+	net_dev->active_features |= *efx->type->offload_features;
+	net_dev->active_features |= NETIF_F_SG;
+	net_dev->active_features |= NETIF_F_RXCSUM;
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
 				       ARRAY_SIZE(efx_vlan_features_array));
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0af4b26896d6..44e6c3a02b46 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5416,11 +5416,14 @@ void linkwatch_run_queue(void);
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
-	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
+	netdev_features_t tmp;
+
+	tmp = f1 ^ f2;
+	if (tmp & NETIF_F_HW_CSUM) {
 		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+			f1 |= netdev_ip_csum_features;
 		else
-			f2 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+			f2 |= netdev_ip_csum_features;
 	}
 
 	return f1 & f2;
@@ -5429,7 +5432,10 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 static inline netdev_features_t netdev_get_wanted_features(
 	struct net_device *dev)
 {
-	return (dev->active_features & ~dev->hw_features) | dev->wanted_features;
+	netdev_features_t tmp;
+
+	tmp = dev->active_features & ~dev->hw_features;
+	return dev->wanted_features | tmp;
 }
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask);
diff --git a/net/core/dev.c b/net/core/dev.c
index 67e4c67f5064..7d170f307128 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3322,10 +3322,11 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * work.
 	 */
 	if (features & NETIF_F_GSO_PARTIAL) {
-		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
+		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->active_features & dev->gso_partial_features;
+		partial_features = dev->active_features & dev->gso_partial_features;
+		partial_features |= NETIF_F_GSO_ROBUST;
 		if (!skb_gso_ok(skb, features | partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
@@ -3414,7 +3415,7 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features &= ~netdev_csum_gso_features_mask;
 	}
 	if (illegal_highdma(skb->dev, skb))
 		features &= ~NETIF_F_SG;
@@ -3478,6 +3479,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	netdev_features_t features = dev->active_features;
+	netdev_features_t tmp;
 
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
@@ -3489,17 +3491,16 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	if (skb->encapsulation)
 		features &= dev->hw_enc_features;
 
-	if (skb_vlan_tagged(skb))
-		features = netdev_intersect_features(features,
-						     dev->vlan_features |
-						     NETIF_F_HW_VLAN_CTAG_TX |
-						     NETIF_F_HW_VLAN_STAG_TX);
+	if (skb_vlan_tagged(skb)) {
+		tmp = dev->vlan_features | netdev_tx_vlan_features;
+		features = netdev_intersect_features(features, tmp);
+	}
 
 	if (dev->netdev_ops->ndo_features_check)
-		features &= dev->netdev_ops->ndo_features_check(skb, dev,
-								features);
+		tmp = dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
-		features &= dflt_features_check(skb, dev, features);
+		tmp = dflt_features_check(skb, dev, features);
+	features &= tmp;
 
 	return harmonize_features(skb, features);
 }
@@ -3570,7 +3571,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 	if (features & NETIF_F_HW_CSUM)
 		return 0;
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+	if (features & netdev_ip_csum_features) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -9466,11 +9467,13 @@ static void netdev_sync_lower_features(struct net_device *upper,
 static netdev_features_t netdev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
+	netdev_features_t tmp;
+
 	/* Fix illegal checksum combinations */
 	if ((features & NETIF_F_HW_CSUM) &&
-	    (features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))) {
+	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+		features &= ~netdev_ip_csum_features;
 	}
 
 	/* TSO requires that SG is present as well. */
@@ -9497,7 +9500,9 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		features &= ~NETIF_F_TSO_MANGLEID;
 
 	/* TSO ECN requires that TSO is present as well. */
-	if ((features & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
+	tmp = NETIF_F_ALL_TSO;
+	tmp &= ~NETIF_F_TSO_ECN;
+	if (!(features & tmp) && (features & NETIF_F_TSO_ECN))
 		features &= ~NETIF_F_TSO_ECN;
 
 	/* Software GSO depends on SG. */
@@ -9545,8 +9550,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	}
 
 	if (features & NETIF_F_HW_TLS_TX) {
-		bool ip_csum = (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
-			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+		bool ip_csum = (features & netdev_ip_csum_features) ==
+			netdev_ip_csum_features;
 		bool hw_csum = features & NETIF_F_HW_CSUM;
 
 		if (!ip_csum && !hw_csum) {
@@ -9875,8 +9880,8 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if (((dev->hw_features | dev->active_features) &
-	     NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((dev->hw_features & NETIF_F_HW_VLAN_CTAG_FILTER ||
+	     dev->active_features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
 		netdev_WARN(dev, "Buggy VLAN acceleration in driver!\n");
@@ -9893,7 +9898,8 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
+	dev->hw_features |= NETIF_F_SOFT_FEATURES;
+	dev->hw_features |= NETIF_F_SOFT_FEATURES_OFF;
 	dev->active_features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->udp_tunnel_nic_info) {
@@ -9926,7 +9932,8 @@ int register_netdevice(struct net_device *dev)
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG | NETIF_F_GSO_PARTIAL;
+	dev->hw_enc_features |= NETIF_F_SG;
+	dev->hw_enc_features |= NETIF_F_GSO_PARTIAL;
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
@@ -11013,16 +11020,28 @@ static int dev_cpu_dead(unsigned int oldcpu)
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask)
 {
+	netdev_features_t tmp;
+
 	if (mask & NETIF_F_HW_CSUM)
 		mask |= NETIF_F_CSUM_MASK;
 	mask |= NETIF_F_VLAN_CHALLENGED;
 
-	all |= one & (NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK) & mask;
-	all &= one | ~NETIF_F_ALL_FOR_ALL;
+	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
+	tmp &= one;
+	tmp &= mask;
+	all |= tmp;
+
+	netdev_features_fill(&tmp);
+	tmp &= ~NETIF_F_ALL_FOR_ALL;
+	tmp |= one;
+	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
-	if (all & NETIF_F_HW_CSUM)
-		all &= ~(NETIF_F_CSUM_MASK & ~NETIF_F_HW_CSUM);
+	if (all & NETIF_F_HW_CSUM) {
+		tmp = NETIF_F_CSUM_MASK;
+		tmp &= ~NETIF_F_HW_CSUM;
+		all &= ~tmp;
+	}
 
 	return all;
 }
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index a43f82515de8..d327c6032d7b 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -220,6 +220,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
+	netdev_features_t tmp;
 	bool mod;
 	int ret;
 
@@ -253,7 +254,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		dev->wanted_features &= ~dev->hw_features;
-		dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		dev->wanted_features |= tmp;
 		__netdev_update_features(dev);
 	}
 	ethnl_features_to_bitmap(new_active, dev->active_features);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 184ca24263f4..ab003dc2cfd8 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -125,6 +125,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
 	netdev_features_t wanted = 0, valid = 0;
+	netdev_features_t tmp;
 	int i, ret = 0;
 
 	if (copy_from_user(&cmd, useraddr, sizeof(cmd)))
@@ -142,19 +143,23 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 		wanted |= (netdev_features_t)features[i].requested << (32 * i);
 	}
 
-	if (valid & ~NETIF_F_ETHTOOL_BITS)
+	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
+	if (tmp)
 		return -EINVAL;
 
-	if (valid & ~dev->hw_features) {
+	tmp = valid & ~dev->hw_features;
+	if (tmp) {
 		valid &= dev->hw_features;
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
 	dev->wanted_features &= ~valid;
-	dev->wanted_features |= wanted & valid;
+	tmp = wanted & valid;
+	dev->wanted_features |= tmp;
 	__netdev_update_features(dev);
 
-	if ((dev->wanted_features ^ dev->active_features) & valid)
+	tmp = dev->wanted_features ^ dev->active_features;
+	if (tmp & valid)
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
@@ -221,28 +226,38 @@ static void __ethtool_get_strings(struct net_device *dev,
 
 static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 {
+	netdev_features_t tmp;
+
 	/* feature masks of legacy discrete ethtool ops */
 
+	netdev_features_zero(&tmp);
 	switch (eth_cmd) {
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
-		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC |
-		       NETIF_F_SCTP_CRC;
+		tmp = NETIF_F_CSUM_MASK;
+		tmp |= NETIF_F_FCOE_CRC;
+		tmp |= NETIF_F_SCTP_CRC;
+		return tmp;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
-		return NETIF_F_RXCSUM;
+		tmp |= NETIF_F_RXCSUM;
+		return tmp;
 	case ETHTOOL_GSG:
 	case ETHTOOL_SSG:
-		return NETIF_F_SG | NETIF_F_FRAGLIST;
+		tmp |= NETIF_F_SG;
+		tmp |= NETIF_F_FRAGLIST;
+		return tmp;
 	case ETHTOOL_GTSO:
 	case ETHTOOL_STSO:
 		return NETIF_F_ALL_TSO;
 	case ETHTOOL_GGSO:
 	case ETHTOOL_SGSO:
-		return NETIF_F_GSO;
+		tmp |= NETIF_F_GSO;
+		return tmp;
 	case ETHTOOL_GGRO:
 	case ETHTOOL_SGRO:
-		return NETIF_F_GRO;
+		tmp |= NETIF_F_GRO;
+		return tmp;
 	default:
 		BUG();
 	}
@@ -319,6 +334,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
 	netdev_features_t features = 0, changed;
 	netdev_features_t eth_all_features;
+	netdev_features_t tmp;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
@@ -340,12 +356,15 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 				  &eth_all_features);
 
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->active_features) & eth_all_features;
-	if (changed & ~dev->hw_features)
+	changed = dev->active_features ^ features;
+	changed &= eth_all_features;
+	tmp = changed & ~dev->hw_features;
+	if (tmp)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-	dev->wanted_features =
-		(dev->wanted_features & ~changed) | (features & changed);
+	dev->wanted_features &= ~changed;
+	tmp = features & changed;
+	dev->wanted_features |= tmp;
 
 	__netdev_update_features(dev);
 
-- 
2.33.0

