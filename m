Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B11650621B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344692AbiDSCbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344639AbiDSCai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C9F2E6AA
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kj74h6M3wzhXZx;
        Tue, 19 Apr 2022 10:27:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 08/19] net: use netdev_features_or helpers
Date:   Tue, 19 Apr 2022 10:21:55 +0800
Message-ID: <20220419022206.36381-9-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419022206.36381-1-shenjian15@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

Replace the '|' and '|=' operations of features by
netdev_features_or helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c    | 10 +++++-----
 drivers/net/ethernet/sfc/ef10.c                |  6 +++---
 drivers/net/ethernet/sfc/ef100_nic.c           | 14 +++++++-------
 drivers/net/ethernet/sfc/efx.c                 |  8 ++++----
 drivers/net/ethernet/sfc/efx_common.c          |  4 ++--
 drivers/net/ethernet/sfc/falcon/efx.c          |  8 ++++----
 drivers/net/ethernet/sfc/falcon/net_driver.h   |  2 +-
 drivers/net/ethernet/sfc/net_driver.h          |  2 +-
 include/linux/netdev_features_helper.h         |  6 +++---
 net/core/dev.c                                 | 18 +++++++++---------
 net/ethtool/features.c                         |  5 +++--
 net/ethtool/ioctl.c                            | 12 +++++++-----
 12 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a368fe002295..e43b3e8c4f84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3295,7 +3295,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev_features_zero(&features);
 	netdev_features_set_array(&hns3_default_feature_set, &features);
-	netdev->features |= features;
+	netdev_active_features_set(netdev, features);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		netdev_active_feature_add(netdev, NETIF_F_GRO_HW_BIT);
@@ -3310,7 +3310,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev_active_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	else
-		netdev->features |= netdev_ip_csum_features;
+		netdev_active_features_set(netdev, netdev_ip_csum_features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev_active_feature_add(netdev,
@@ -3319,7 +3319,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
 		netdev_active_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_set(netdev, netdev->features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
@@ -3327,9 +3327,9 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev_features_set_array(&hns3_vlan_off_feature_set,
 				  &vlan_off_features);
 	features = netdev->features & ~vlan_off_features;
-	netdev->vlan_features |= features;
+	netdev_vlan_features_set(netdev, features);
 
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
 	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 9c99a820bad1..0674565d9ed1 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1358,7 +1358,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	netdev_features_zero(&hw_enc_features);
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= netdev_ip_csum_features;
+		netdev_features_set(&hw_enc_features, netdev_ip_csum_features);
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
@@ -1367,9 +1367,9 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		netdev_features_set_array(&ef10_tso_feature_set,
 					  &encap_tso_features);
 
-		hw_enc_features |= encap_tso_features;
+		netdev_features_set(&hw_enc_features, encap_tso_features);
 		netdev_feature_add(NETIF_F_TSO_BIT, &hw_enc_features);
-		efx->net_dev->features |= encap_tso_features;
+		netdev_active_features_set(efx->net_dev, encap_tso_features);
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index b72be20af1b2..e32012cae55a 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -198,9 +198,9 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 		netdev_features_zero(&tso);
 		netdev_features_set_array(&ef100_tso_feature_set, &tso);
-		net_dev->features |= tso;
-		net_dev->hw_features |= tso;
-		net_dev->hw_enc_features |= tso;
+		netdev_active_features_set(net_dev, tso);
+		netdev_hw_features_set(net_dev, tso);
+		netdev_hw_enc_features_set(net_dev, tso);
 		/* EF100 HW can only offload outer checksums if they are UDP,
 		 * so for GRE_CSUM we have to use GSO_PARTIAL.
 		 */
@@ -1133,10 +1133,10 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
-	net_dev->features |= *efx->type->offload_features;
-	net_dev->hw_features |= *efx->type->offload_features;
-	net_dev->hw_enc_features |= *efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
+	netdev_hw_features_set(net_dev, *efx->type->offload_features);
+	netdev_hw_enc_features_set(net_dev, *efx->type->offload_features);
+	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &ef100_vlan_feature_set);
 
 	/* Populate design-parameter defaults */
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 1a7fc9295ba0..e346ad52c9a2 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1017,7 +1017,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
 	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
@@ -1026,11 +1026,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
 	tmp = net_dev->features & ~efx->fixed_features;
-	net_dev->hw_features |= tmp;
+	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
@@ -1040,7 +1040,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 4b890e68c5de..f5536eb00dfc 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -414,9 +414,9 @@ static void efx_start_datapath(struct efx_nic *efx)
 	 * features which are fixed now
 	 */
 	old_features = efx->net_dev->features;
-	efx->net_dev->hw_features |= efx->net_dev->features;
+	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 5d044027e164..d246c5b805a1 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -641,9 +641,9 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	 * features which are fixed now
 	 */
 	old_features = efx->net_dev->features;
-	efx->net_dev->hw_features |= efx->net_dev->features;
+	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
 
@@ -2914,7 +2914,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= *efx->type->offload_features;
+	netdev_active_features_set(net_dev, *efx->type->offload_features);
 	netdev_active_feature_add(net_dev, NETIF_F_SG_BIT);
 	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
@@ -2926,7 +2926,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 26aff929c6d2..5365e2d8a975 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1303,7 +1303,7 @@ static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	return netdev_active_features_or(net_dev, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 6b52f2924bf7..bcdcec3d61e1 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1688,7 +1688,7 @@ static inline netdev_features_t efx_supported_features(const struct efx_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	return netdev_active_features_or(net_dev, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index b68a85d2b982..0c4363588582 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -590,9 +590,9 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 	tmp = f1 ^ f2;
 	if (tmp & NETIF_F_HW_CSUM) {
 		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= netdev_ip_csum_features;
+			netdev_features_set(&f1, netdev_ip_csum_features);
 		else
-			f2 |= netdev_ip_csum_features;
+			netdev_features_set(&f2, netdev_ip_csum_features);
 	}
 
 	return f1 & f2;
@@ -604,7 +604,7 @@ netdev_get_wanted_features(struct net_device *dev)
 	netdev_features_t tmp;
 
 	tmp = dev->features & ~dev->hw_features;
-	return dev->wanted_features | tmp;
+	return netdev_wanted_features_or(dev, tmp);
 }
 
 #endif
diff --git a/net/core/dev.c b/net/core/dev.c
index 921f10018fbc..13bb2cd8e2af 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3345,7 +3345,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 
 		partial_features = dev->features & dev->gso_partial_features;
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &partial_features);
-		if (!skb_gso_ok(skb, features | partial_features))
+		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
 
@@ -3512,7 +3512,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		features &= dev->hw_enc_features;
 
 	if (skb_vlan_tagged(skb)) {
-		tmp = dev->vlan_features | netdev_tx_vlan_features;
+		tmp = netdev_vlan_features_or(dev, netdev_tx_vlan_features);
 		features = netdev_intersect_features(features, tmp);
 	}
 
@@ -9931,9 +9931,9 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= NETIF_F_SOFT_FEATURES;
-	dev->hw_features |= NETIF_F_SOFT_FEATURES_OFF;
-	dev->features |= NETIF_F_SOFT_FEATURES;
+	netdev_hw_features_set(dev, NETIF_F_SOFT_FEATURES);
+	netdev_hw_features_set(dev, NETIF_F_SOFT_FEATURES_OFF);
+	netdev_active_features_set(dev, NETIF_F_SOFT_FEATURES);
 
 	if (dev->udp_tunnel_nic_info) {
 		netdev_active_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
@@ -11056,17 +11056,17 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t tmp;
 
 	if (mask & NETIF_F_HW_CSUM)
-		mask |= NETIF_F_CSUM_MASK;
+		netdev_features_set(&mask, NETIF_F_CSUM_MASK);
 	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
-	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
+	tmp = netdev_features_or(NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
 	tmp &= one;
 	tmp &= mask;
-	all |= tmp;
+	netdev_features_set(&all, tmp);
 
 	netdev_features_fill(&tmp);
 	tmp &= ~NETIF_F_ALL_FOR_ALL;
-	tmp |= one;
+	netdev_features_set(&tmp, one);
 	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 2c64183012c1..8e753afc0824 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -150,7 +150,8 @@ static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
 
 	netdev_features_zero(&ret);
 	for (i = 0; i < words; i++)
-		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
+		netdev_features_set(&ret,
+				    (netdev_features_t)(src[i]) << (i * BITS_PER_LONG));
 	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
 	return ret;
 }
@@ -257,7 +258,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		dev->wanted_features &= ~dev->hw_features;
 		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
-		dev->wanted_features |= tmp;
+		netdev_wanted_features_set(dev, tmp);
 		__netdev_update_features(dev);
 	}
 	ethnl_features_to_bitmap(new_active, dev->features);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b258379006f1..d18f305ee691 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -143,8 +143,10 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	netdev_features_zero(&wanted);
 	netdev_features_zero(&valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		valid |= (netdev_features_t)features[i].valid << (32 * i);
-		wanted |= (netdev_features_t)features[i].requested << (32 * i);
+		netdev_features_set(&valid,
+				    (netdev_features_t)features[i].valid << (32 * i));
+		netdev_features_set(&wanted,
+				    (netdev_features_t)features[i].requested << (32 * i));
 	}
 
 	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
@@ -159,7 +161,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 
 	dev->wanted_features &= ~valid;
 	tmp = wanted & valid;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_set(dev, tmp);
 	__netdev_update_features(dev);
 
 	tmp = dev->wanted_features ^ dev->features;
@@ -297,7 +299,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (edata.data)
-		dev->wanted_features |= mask;
+		netdev_wanted_features_set(dev, mask);
 	else
 		dev->wanted_features &= ~mask;
 
@@ -368,7 +370,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	dev->wanted_features &= ~changed;
 	tmp = features & changed;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_set(dev, tmp);
 
 	__netdev_update_features(dev);
 
-- 
2.33.0

