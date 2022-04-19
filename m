Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D8E506215
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344839AbiDSCa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344579AbiDSCai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A692E6AC
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kj71x0qGpzFpp5;
        Tue, 19 Apr 2022 10:25:25 +0800 (CST)
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
Subject: [RFCv6 PATCH net-next 07/19] net: use netdev_feature_add helpers
Date:   Tue, 19 Apr 2022 10:21:54 +0800
Message-ID: <20220419022206.36381-8-shenjian15@huawei.com>
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

Replace the '|' and '|=' operations of single feature bit by
netdev_features_add helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 17 ++++++------
 drivers/net/ethernet/sfc/ef10.c               |  4 +--
 drivers/net/ethernet/sfc/ef100_nic.c          |  3 ++-
 drivers/net/ethernet/sfc/ef10_sriov.c         |  3 ++-
 drivers/net/ethernet/sfc/efx.c                |  4 +--
 drivers/net/ethernet/sfc/falcon/efx.c         |  6 ++---
 net/core/dev.c                                | 26 +++++++++----------
 net/ethtool/ioctl.c                           | 24 ++++++++---------
 8 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 34484d599e1b..a368fe002295 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3291,32 +3291,33 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 
 	netdev_features_zero(&features);
 	netdev_features_set_array(&hns3_default_feature_set, &features);
 	netdev->features |= features;
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->features |= NETIF_F_GRO_HW;
+		netdev_active_feature_add(netdev, NETIF_F_GRO_HW_BIT);
 
 		if (!(h->flags & HNAE3_SUPPORT_VF))
-			netdev->features |= NETIF_F_NTUPLE;
+			netdev_active_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev_active_feature_add(netdev, NETIF_F_GSO_UDP_L4_BIT);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_CSUM;
+		netdev_active_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	else
 		netdev->features |= netdev_ip_csum_features;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_active_feature_add(netdev,
+					  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_TC;
+		netdev_active_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	netdev->hw_features |= netdev->features;
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
@@ -3329,7 +3330,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev->vlan_features |= features;
 
 	netdev->hw_enc_features |= netdev->vlan_features;
-	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 42cc17a1d540..9c99a820bad1 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -627,7 +627,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 
 	if (nic_data->datapath_caps &
 	    (1 << MC_CMD_GET_CAPABILITIES_OUT_RX_INCLUDE_FCS_LBN))
-		efx->net_dev->hw_features |= NETIF_F_RXFCS;
+		netdev_hw_feature_add(efx->net_dev, NETIF_F_RXFCS_BIT);
 
 	rc = efx_mcdi_port_get_number(efx);
 	if (rc < 0)
@@ -1368,7 +1368,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 					  &encap_tso_features);
 
 		hw_enc_features |= encap_tso_features;
-		hw_enc_features |= NETIF_F_TSO;
+		netdev_feature_add(NETIF_F_TSO_BIT, &hw_enc_features);
 		efx->net_dev->features |= encap_tso_features;
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 679530f20bd6..b72be20af1b2 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -204,7 +204,8 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 		/* EF100 HW can only offload outer checksums if they are UDP,
 		 * so for GRE_CSUM we have to use GSO_PARTIAL.
 		 */
-		net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev_gso_partial_feature_add(net_dev,
+					       NETIF_F_GSO_GRE_CSUM_BIT);
 	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 7f5aa4a8c451..857e7520461d 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -243,7 +243,8 @@ static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 
 	if (port_flags &
 	    (1 << MC_CMD_VPORT_ALLOC_IN_FLAG_VLAN_RESTRICT_LBN))
-		efx->fixed_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   &efx->fixed_features);
 	else
 		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a44378ae484a..1a7fc9295ba0 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1021,7 +1021,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
 	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
-		net_dev->features |= NETIF_F_TSO6;
+		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
@@ -1073,7 +1073,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct efx_nic_type *) entry->driver_data;
-	efx->fixed_features |= NETIF_F_HIGHDMA;
+	netdev_feature_add(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 352ae87d901c..5d044027e164 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2892,7 +2892,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct ef4_nic_type *) entry->driver_data;
-	efx->fixed_features |= NETIF_F_HIGHDMA;
+	netdev_feature_add(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
@@ -2915,8 +2915,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 		goto fail3;
 
 	net_dev->features |= *efx->type->offload_features;
-	net_dev->features |= NETIF_F_SG;
-	net_dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(net_dev, NETIF_F_SG_BIT);
+	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
diff --git a/net/core/dev.c b/net/core/dev.c
index 48b0a49ebb39..921f10018fbc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3344,7 +3344,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		struct net_device *dev = skb->dev;
 
 		partial_features = dev->features & dev->gso_partial_features;
-		partial_features |= NETIF_F_GSO_ROBUST;
+		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &partial_features);
 		if (!skb_gso_ok(skb, features | partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
@@ -9936,14 +9936,14 @@ int register_netdevice(struct net_device *dev)
 	dev->features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->udp_tunnel_nic_info) {
-		dev->features |= NETIF_F_RX_UDP_TUNNEL_PORT;
-		dev->hw_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
+		netdev_active_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
 	dev->wanted_features = dev->features & dev->hw_features;
 
 	if (!(dev->flags & IFF_LOOPBACK))
-		dev->hw_features |= NETIF_F_NOCACHE_COPY;
+		netdev_hw_feature_add(dev, NETIF_F_NOCACHE_COPY_BIT);
 
 	/* If IPv4 TCP segmentation offload is supported we should also
 	 * allow the device to enable segmenting the frame with the option
@@ -9951,26 +9951,26 @@ int register_netdevice(struct net_device *dev)
 	 * feature itself but allows the user to enable it later.
 	 */
 	if (dev->hw_features & NETIF_F_TSO)
-		dev->hw_features |= NETIF_F_TSO_MANGLEID;
+		netdev_hw_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 	if (dev->vlan_features & NETIF_F_TSO)
-		dev->vlan_features |= NETIF_F_TSO_MANGLEID;
+		netdev_vlan_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 	if (dev->mpls_features & NETIF_F_TSO)
-		dev->mpls_features |= NETIF_F_TSO_MANGLEID;
+		netdev_mpls_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 	if (dev->hw_enc_features & NETIF_F_TSO)
-		dev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+		netdev_hw_enc_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
-	dev->vlan_features |= NETIF_F_HIGHDMA;
+	netdev_vlan_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG;
-	dev->hw_enc_features |= NETIF_F_GSO_PARTIAL;
+	netdev_hw_enc_feature_add(dev, NETIF_F_SG_BIT);
+	netdev_hw_enc_feature_add(dev, NETIF_F_GSO_PARTIAL_BIT);
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
-	dev->mpls_features |= NETIF_F_SG;
+	netdev_mpls_feature_add(dev, NETIF_F_SG_BIT);
 
 	ret = call_netdevice_notifiers(NETDEV_POST_INIT, dev);
 	ret = notifier_to_errno(ret);
@@ -11057,7 +11057,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 
 	if (mask & NETIF_F_HW_CSUM)
 		mask |= NETIF_F_CSUM_MASK;
-	mask |= NETIF_F_VLAN_CHALLENGED;
+	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
 	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
 	tmp &= one;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 28164e990201..b258379006f1 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -239,28 +239,28 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
 		tmp = NETIF_F_CSUM_MASK;
-		tmp |= NETIF_F_FCOE_CRC;
-		tmp |= NETIF_F_SCTP_CRC;
+		netdev_feature_add(NETIF_F_FCOE_CRC_BIT, &tmp);
+		netdev_feature_add(NETIF_F_SCTP_CRC_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
-		tmp |= NETIF_F_RXCSUM;
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GSG:
 	case ETHTOOL_SSG:
-		tmp |= NETIF_F_SG;
-		tmp |= NETIF_F_FRAGLIST;
+		netdev_feature_add(NETIF_F_SG_BIT, &tmp);
+		netdev_feature_add(NETIF_F_FRAGLIST_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GTSO:
 	case ETHTOOL_STSO:
 		return NETIF_F_ALL_TSO;
 	case ETHTOOL_GGSO:
 	case ETHTOOL_SGSO:
-		tmp |= NETIF_F_GSO;
+		netdev_feature_add(NETIF_F_GSO_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GGRO:
 	case ETHTOOL_SGRO:
-		tmp |= NETIF_F_GRO;
+		netdev_feature_add(NETIF_F_GRO_BIT, &tmp);
 		return tmp;
 	default:
 		BUG();
@@ -346,15 +346,15 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	netdev_features_zero(&features);
 	if (data & ETH_FLAG_LRO)
-		features |= NETIF_F_LRO;
+		netdev_feature_add(NETIF_F_LRO_BIT, &features);
 	if (data & ETH_FLAG_RXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT, &features);
 	if (data & ETH_FLAG_TXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	if (data & ETH_FLAG_NTUPLE)
-		features |= NETIF_F_NTUPLE;
+		netdev_feature_add(NETIF_F_NTUPLE_BIT, &features);
 	if (data & ETH_FLAG_RXHASH)
-		features |= NETIF_F_RXHASH;
+		netdev_feature_add(NETIF_F_RXHASH_BIT, &features);
 
 	netdev_features_zero(&eth_all_features);
 	netdev_features_set_array(&ethtool_all_feature_set, &eth_all_features);
-- 
2.33.0

