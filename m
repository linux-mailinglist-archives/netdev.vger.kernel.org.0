Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611D44E6667
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351480AbiCXP5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351459AbiCXP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:53 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FD4AC93D
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KPVD26Jqrz1GD2s;
        Thu, 24 Mar 2022 23:54:58 +0800 (CST)
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
Subject: [RFCv5 PATCH net-next 09/20] net: use netdev_features_or helpers
Date:   Thu, 24 Mar 2022 23:49:21 +0800
Message-ID: <20220324154932.17557-10-shenjian15@huawei.com>
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

Replace the '|' and '|=' operations of features by
netdev_features_or helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c    | 11 ++++++-----
 drivers/net/ethernet/sfc/ef10.c                |  8 +++++---
 drivers/net/ethernet/sfc/ef100_nic.c           | 16 +++++++++-------
 drivers/net/ethernet/sfc/efx.c                 |  9 +++++----
 drivers/net/ethernet/sfc/efx_common.c          |  5 +++--
 drivers/net/ethernet/sfc/falcon/efx.c          | 10 ++++++----
 drivers/net/ethernet/sfc/falcon/net_driver.h   |  2 +-
 drivers/net/ethernet/sfc/net_driver.h          |  2 +-
 include/linux/netdevice.h                      |  6 +++---
 net/core/dev.c                                 | 18 +++++++++---------
 net/ethtool/features.c                         |  5 +++--
 net/ethtool/ioctl.c                            | 12 +++++++-----
 12 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3261a8c8d10e..38ab3692f073 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3271,7 +3271,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 				  ARRAY_SIZE(hns3_default_features_array),
 				  &features);
 
-	netdev->active_features |= features;
+	netdev_active_features_direct_or(netdev, features);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		netdev_active_features_set_bit(netdev, NETIF_F_GRO_HW_BIT);
@@ -3287,7 +3287,8 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev_active_features_set_bit(netdev, NETIF_F_HW_CSUM_BIT);
 	else
-		netdev->active_features |= netdev_ip_csum_features;
+		netdev_active_features_direct_or(netdev,
+						 netdev_ip_csum_features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev_active_features_set_bit(netdev,
@@ -3296,7 +3297,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
 		netdev_active_features_set_bit(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev->hw_features |= netdev->active_features;
+	netdev_hw_features_direct_or(netdev, netdev->active_features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
@@ -3305,9 +3306,9 @@ static void hns3_set_default_feature(struct net_device *netdev)
 				  ARRAY_SIZE(hns3_vlan_off_features_array),
 				  &vlan_off_features);
 	features = netdev->active_features & ~vlan_off_features;
-	netdev->vlan_features |= features;
+	netdev_vlan_features_direct_or(netdev, features);
 
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_hw_enc_features_direct_or(netdev, netdev->vlan_features);
 	netdev_hw_enc_features_set_bit(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index baad36133e11..cf21be47de1b 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1359,7 +1359,8 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	netdev_features_zero(&hw_enc_features);
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= netdev_ip_csum_features;
+		netdev_features_direct_or(&hw_enc_features,
+					  netdev_ip_csum_features);
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
@@ -1369,9 +1370,10 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 					  ARRAY_SIZE(ef10_tso_features_array),
 					  &encap_tso_features);
 
-		hw_enc_features |= encap_tso_features;
+		netdev_features_direct_or(&hw_enc_features, encap_tso_features);
 		netdev_features_set_bit(NETIF_F_TSO_BIT, &hw_enc_features);
-		efx->net_dev->active_features |= encap_tso_features;
+		netdev_active_features_direct_or(efx->net_dev,
+						 encap_tso_features);
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index ecb4f189b4ef..eb4e884a3f54 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -201,9 +201,9 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 		netdev_features_set_array(ef100_tso_features_array,
 					  ARRAY_SIZE(ef100_tso_features_array),
 					  &tso);
-		net_dev->active_features |= tso;
-		net_dev->hw_features |= tso;
-		net_dev->hw_enc_features |= tso;
+		netdev_active_features_direct_or(net_dev, tso);
+		netdev_hw_features_direct_or(net_dev, tso);
+		netdev_hw_enc_features_direct_or(net_dev, tso);
 		/* EF100 HW can only offload outer checksums if they are UDP,
 		 * so for GRE_CSUM we have to use GSO_PARTIAL.
 		 */
@@ -1137,10 +1137,12 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
-	net_dev->active_features |= *efx->type->offload_features;
-	net_dev->hw_features |= *efx->type->offload_features;
-	net_dev->hw_enc_features |= *efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_active_features_direct_or(net_dev,
+					 *efx->type->offload_features);
+	netdev_hw_features_direct_or(net_dev, *efx->type->offload_features);
+	netdev_hw_enc_features_direct_or(net_dev,
+					 *efx->type->offload_features);
+	netdev_vlan_features_direct_or(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, ef100_vlan_features_array,
 				       ARRAY_SIZE(ef100_vlan_features_array));
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4e96984a7fff..c46e02ee3d14 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1019,7 +1019,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->active_features |= *efx->type->offload_features;
+	netdev_active_features_direct_or(net_dev,
+					 *efx->type->offload_features);
 	netdev_active_features_set_array(net_dev, efx_active_features_array,
 					 ARRAY_SIZE(efx_active_features_array));
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
@@ -1029,12 +1030,12 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->active_features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_direct_or(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
 				       ARRAY_SIZE(efx_vlan_features_array));
 
 	tmp = net_dev->active_features & ~efx->fixed_features;
-	net_dev->hw_features |= tmp;
+	netdev_hw_features_direct_or(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->active_features &= ~NETIF_F_RXALL;
@@ -1044,7 +1045,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->active_features |= efx->fixed_features;
+	netdev_active_features_direct_or(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 306f5cb24273..f9600306813b 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -414,9 +414,10 @@ static void efx_start_datapath(struct efx_nic *efx)
 	 * features which are fixed now
 	 */
 	old_features = efx->net_dev->active_features;
-	efx->net_dev->hw_features |= efx->net_dev->active_features;
+	netdev_hw_features_direct_or(efx->net_dev,
+				     efx->net_dev->active_features);
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->active_features |= efx->fixed_features;
+	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->active_features != old_features)
 		netdev_features_change(efx->net_dev);
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 8f16c2b98fd4..ce558c1a1cbb 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -641,9 +641,10 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	 * features which are fixed now
 	 */
 	old_features = efx->net_dev->active_features;
-	efx->net_dev->hw_features |= efx->net_dev->active_features;
+	netdev_hw_features_direct_or(efx->net_dev,
+				     efx->net_dev->active_features);
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->active_features |= efx->fixed_features;
+	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->active_features != old_features)
 		netdev_features_change(efx->net_dev);
 
@@ -2915,7 +2916,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->active_features |= *efx->type->offload_features;
+	netdev_active_features_direct_or(net_dev,
+					 *efx->type->offload_features);
 	netdev_active_features_set_bit(net_dev, NETIF_F_SG_BIT);
 	netdev_active_features_set_bit(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
@@ -2928,7 +2930,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->active_features |= efx->fixed_features;
+	netdev_active_features_direct_or(net_dev, efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 88d73fd078b9..9c549e89d85e 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1302,7 +1302,7 @@ static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->active_features | net_dev->hw_features;
+	return netdev_active_features_or(net_dev, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 1b6c4f29337b..989f8584718b 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1687,7 +1687,7 @@ static inline netdev_features_t efx_supported_features(const struct efx_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->active_features | net_dev->hw_features;
+	return netdev_active_features_or(net_dev, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44e6c3a02b46..c5b06798641c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5421,9 +5421,9 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 	tmp = f1 ^ f2;
 	if (tmp & NETIF_F_HW_CSUM) {
 		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= netdev_ip_csum_features;
+			netdev_features_direct_or(&f1, netdev_ip_csum_features);
 		else
-			f2 |= netdev_ip_csum_features;
+			netdev_features_direct_or(&f2, netdev_ip_csum_features);
 	}
 
 	return f1 & f2;
@@ -5435,7 +5435,7 @@ static inline netdev_features_t netdev_get_wanted_features(
 	netdev_features_t tmp;
 
 	tmp = dev->active_features & ~dev->hw_features;
-	return dev->wanted_features | tmp;
+	return netdev_wanted_features_or(dev, tmp);
 }
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask);
diff --git a/net/core/dev.c b/net/core/dev.c
index 706960c607e4..a387618f589d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3328,7 +3328,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		partial_features = dev->active_features & dev->gso_partial_features;
 		netdev_features_set_bit(NETIF_F_GSO_ROBUST_BIT,
 					&partial_features);
-		if (!skb_gso_ok(skb, features | partial_features))
+		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
 
@@ -3495,7 +3495,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		features &= dev->hw_enc_features;
 
 	if (skb_vlan_tagged(skb)) {
-		tmp = dev->vlan_features | netdev_tx_vlan_features;
+		tmp = netdev_vlan_features_or(dev, netdev_tx_vlan_features);
 		features = netdev_intersect_features(features, tmp);
 	}
 
@@ -9905,9 +9905,9 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= NETIF_F_SOFT_FEATURES;
-	dev->hw_features |= NETIF_F_SOFT_FEATURES_OFF;
-	dev->active_features |= NETIF_F_SOFT_FEATURES;
+	netdev_hw_features_direct_or(dev, NETIF_F_SOFT_FEATURES);
+	netdev_hw_features_direct_or(dev, NETIF_F_SOFT_FEATURES_OFF);
+	netdev_active_features_direct_or(dev, NETIF_F_SOFT_FEATURES);
 
 	if (dev->udp_tunnel_nic_info) {
 		netdev_active_features_set_bit(dev,
@@ -11032,17 +11032,17 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t tmp;
 
 	if (mask & NETIF_F_HW_CSUM)
-		mask |= NETIF_F_CSUM_MASK;
+		netdev_features_direct_or(&mask, NETIF_F_CSUM_MASK);
 	netdev_features_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
-	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
+	tmp = netdev_features_or(NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
 	tmp &= one;
 	tmp &= mask;
-	all |= tmp;
+	netdev_features_direct_or(&all, tmp);
 
 	netdev_features_fill(&tmp);
 	tmp &= ~NETIF_F_ALL_FOR_ALL;
-	tmp |= one;
+	netdev_features_direct_or(&tmp, one);
 	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index c0950d181b13..4a37ada0dcb2 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -149,7 +149,8 @@ static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
 
 	netdev_features_zero(&ret);
 	for (i = 0; i < words; i++)
-		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
+		netdev_features_direct_or(&ret,
+					  (netdev_features_t)(src[i]) << (i * BITS_PER_LONG));
 	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
 	return ret;
 }
@@ -256,7 +257,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		dev->wanted_features &= ~dev->hw_features;
 		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
-		dev->wanted_features |= tmp;
+		netdev_wanted_features_direct_or(dev, tmp);
 		__netdev_update_features(dev);
 	}
 	ethnl_features_to_bitmap(new_active, dev->active_features);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 77538c5175ec..6943f97fad0e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -142,8 +142,10 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	netdev_features_zero(&wanted);
 	netdev_features_zero(&valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		valid |= (netdev_features_t)features[i].valid << (32 * i);
-		wanted |= (netdev_features_t)features[i].requested << (32 * i);
+		netdev_features_direct_or(&valid,
+					  (netdev_features_t)features[i].valid << (32 * i));
+		netdev_features_direct_or(&wanted,
+					  (netdev_features_t)features[i].requested << (32 * i));
 	}
 
 	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
@@ -158,7 +160,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 
 	dev->wanted_features &= ~valid;
 	tmp = wanted & valid;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_direct_or(dev, tmp);
 	__netdev_update_features(dev);
 
 	tmp = dev->wanted_features ^ dev->active_features;
@@ -296,7 +298,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (edata.data)
-		dev->wanted_features |= mask;
+		netdev_wanted_features_direct_or(dev, mask);
 	else
 		dev->wanted_features &= ~mask;
 
@@ -372,7 +374,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	dev->wanted_features &= ~changed;
 	tmp = features & changed;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_direct_or(dev, tmp);
 
 	__netdev_update_features(dev);
 
-- 
2.33.0

