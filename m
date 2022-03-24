Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE6E4E665C
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351436AbiCXP5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351438AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16260AD10E
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KPVD20Qzjz1GD2q;
        Thu, 24 Mar 2022 23:54:58 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 04/20] net: replace multiple feature bits with netdev features array
Date:   Thu, 24 Mar 2022 23:49:16 +0800
Message-ID: <20220324154932.17557-5-shenjian15@huawei.com>
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

There are many netdev_features bits group used in drivers, replace them
with netdev features array.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 49 +++++++++++++++----
 drivers/net/ethernet/sfc/ef10.c               | 13 ++++-
 drivers/net/ethernet/sfc/ef100_nic.c          | 29 +++++++++--
 drivers/net/ethernet/sfc/efx.c                | 25 ++++++++--
 drivers/net/ethernet/sfc/falcon/efx.c         | 12 +++--
 net/ethtool/ioctl.c                           | 19 +++++--
 6 files changed, 118 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 24104eaae6d3..58df89f783fb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3225,23 +3225,51 @@ static struct pci_driver hns3_driver = {
 	.err_handler    = &hns3_err_handler,
 };
 
+static const int hns3_default_features_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_RXCSUM_BIT,
+	NETIF_F_SG_BIT,
+	NETIF_F_GSO_BIT,
+	NETIF_F_GRO_BIT,
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_GSO_GRE_BIT,
+	NETIF_F_GSO_GRE_CSUM_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_BIT,
+	NETIF_F_SCTP_CRC_BIT,
+	NETIF_F_FRAGLIST,
+};
+
+static const int hns3_vlan_off_features_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_GRO_HW_BIT,
+	NETIF_F_NTUPLE_BIT,
+	NETIF_F_HW_TC_BIT,
+};
+
 /* set default feature to hns3 */
 static void hns3_set_default_feature(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct pci_dev *pdev = h->pdev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+	netdev_features_t vlan_off_features;
+	netdev_features_t features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
-	netdev->active_features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
+	netdev_features_zero(&features);
+	netdev_features_set_array(hns3_default_features_array,
+				  ARRAY_SIZE(hns3_default_features_array),
+				  &features);
+
+	netdev->active_features |= features;
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		netdev->active_features |= NETIF_F_GRO_HW;
@@ -3268,10 +3296,11 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->vlan_features |= netdev->active_features &
-		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
-		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
-		  NETIF_F_HW_TC);
+	netdev_features_zero(&vlan_off_features);
+	netdev_features_set_array(hns3_vlan_off_features_array,
+				  ARRAY_SIZE(hns3_vlan_off_features_array),
+				  &vlan_off_features);
+	netdev->vlan_features |= netdev->active_features & ~vlan_off_features;
 
 	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
 }
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 56303984d936..3e1876292141 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1301,6 +1301,13 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 	nic_data->mc_stats = NULL;
 }
 
+static const int ef10_tso_features_array[] = {
+	NETIF_F_GSO_UDP_TUNNEL_BIT,
+	NETIF_F_GSO_GRE_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+	NETIF_F_GSO_GRE_CSUM_BIT
+};
+
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
@@ -1356,8 +1363,10 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+		netdev_features_zero(&encap_tso_features);
+		netdev_features_set_array(ef10_tso_features_array,
+					  ARRAY_SIZE(ef10_tso_features_array),
+					  &encap_tso_features);
 
 		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
 		efx->net_dev->active_features |= encap_tso_features;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 0ddd3d69bd5e..50a5f37151f2 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -147,6 +147,16 @@ static int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address)
 	return 0;
 }
 
+static const int ef100_tso_features_array[] = {
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_GSO_PARTIAL_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+	NETIF_F_GSO_GRE_BIT,
+	NETIF_F_GSO_GRE_CSUM_BIT
+};
+
 static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
@@ -185,10 +195,12 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
 		struct net_device *net_dev = efx->net_dev;
-		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
-					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
+		netdev_features_t tso;
 
+		netdev_features_zero(&tso);
+		netdev_features_set_array(ef100_tso_features_array,
+					  ARRAY_SIZE(ef100_tso_features_array),
+					  &tso);
 		net_dev->active_features |= tso;
 		net_dev->hw_features |= tso;
 		net_dev->hw_enc_features |= tso;
@@ -1105,6 +1117,12 @@ static int ef100_check_design_params(struct efx_nic *efx)
 	return rc;
 }
 
+static const int ef100_vlan_features_array[] = {
+	NETIF_F_HW_CSUM_BIT,
+	NETIF_F_SG_BIT,
+	NETIF_F_HIGHDMA_BIT
+};
+
 /*	NIC probe and remove
  */
 static int ef100_probe_main(struct efx_nic *efx)
@@ -1126,8 +1144,9 @@ static int ef100_probe_main(struct efx_nic *efx)
 	net_dev->active_features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 	net_dev->hw_enc_features |= efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
-				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_array(net_dev, ef100_vlan_features_array,
+				       ARRAY_SIZE(ef100_vlan_features_array));
 
 	/* Populate design-parameter defaults */
 	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index d7dff27a3e8e..9f4b6e483e72 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -988,6 +988,20 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 	return rc;
 }
 
+static const int efx_active_features_array[] = {
+	NETIF_F_SG_BIT,
+	NETIF_F_TSO_BIT,
+	NETIF_F_RXCSUM_BIT,
+	NETIF_F_RXALL_BIT
+};
+
+static const int efx_vlan_features_array[] = {
+	NETIF_F_HW_CSUM_BIT,
+	NETIF_F_SG_BIT,
+	NETIF_F_HIGHDMA_BIT,
+	NETIF_F_RXCSUM_BIT
+};
+
 static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
@@ -1004,17 +1018,18 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->active_features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
+	net_dev->active_features |= efx->type->offload_features;
+	netdev_active_features_set_array(net_dev, efx_active_features_array,
+					 ARRAY_SIZE(efx_active_features_array));
 	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		net_dev->active_features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->active_features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
-				   NETIF_F_RXCSUM);
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
+				       ARRAY_SIZE(efx_vlan_features_array));
 
 	net_dev->hw_features |= net_dev->active_features & ~efx->fixed_features;
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 807ceda69c01..177ef78fb652 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2859,6 +2859,13 @@ static int ef4_pci_probe_main(struct ef4_nic *efx)
 	return rc;
 }
 
+static const int efx_vlan_features_array[] = {
+	NETIF_F_HW_CSUM_BIT,
+	NETIF_F_SG_BIT,
+	NETIF_F_HIGHDMA_BIT,
+	NETIF_F_RXCSUM_BIT
+};
+
 /* NIC initialisation
  *
  * This is called at module load (or hotplug insertion,
@@ -2907,9 +2914,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	net_dev->active_features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_RXCSUM);
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_RXCSUM);
-
+	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
+				       ARRAY_SIZE(efx_vlan_features_array));
 	net_dev->hw_features = net_dev->active_features & ~efx->fixed_features;
 
 	/* Disable VLAN filtering by default.  It may be enforced if
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 1c7f24316b3d..184ca24263f4 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -288,9 +288,14 @@ static int ethtool_set_one_feature(struct net_device *dev,
 
 #define ETH_ALL_FLAGS    (ETH_FLAG_LRO | ETH_FLAG_RXVLAN | ETH_FLAG_TXVLAN | \
 			  ETH_FLAG_NTUPLE | ETH_FLAG_RXHASH)
-#define ETH_ALL_FEATURES (NETIF_F_LRO | NETIF_F_HW_VLAN_CTAG_RX | \
-			  NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_NTUPLE | \
-			  NETIF_F_RXHASH)
+
+static const int ethtool_all_features_array[] = {
+	NETIF_F_LRO_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_NTUPLE_BIT,
+	NETIF_F_RXHASH_BIT
+};
 
 static u32 __ethtool_get_flags(struct net_device *dev)
 {
@@ -313,6 +318,7 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
 	netdev_features_t features = 0, changed;
+	netdev_features_t eth_all_features;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
@@ -328,8 +334,13 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	if (data & ETH_FLAG_RXHASH)
 		features |= NETIF_F_RXHASH;
 
+	netdev_features_zero(&eth_all_features);
+	netdev_features_set_array(ethtool_all_features_array,
+				  ARRAY_SIZE(ethtool_all_features_array),
+				  &eth_all_features);
+
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->active_features) & ETH_ALL_FEATURES;
+	changed = (features ^ dev->active_features) & eth_all_features;
 	if (changed & ~dev->hw_features)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-- 
2.33.0

