Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD19250620F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbiDSCam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238008AbiDSCah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:37 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C752E688
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:55 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kj74h0LFgzhXbH;
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
Subject: [RFCv6 PATCH net-next 03/19] net: replace multiple feature bits with netdev features array
Date:   Tue, 19 Apr 2022 10:21:50 +0800
Message-ID: <20220419022206.36381-4-shenjian15@huawei.com>
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

There are many netdev_features bits group used in drivers, replace them
with netdev features array.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 44 ++++++++++++++-----
 drivers/net/ethernet/sfc/ef10.c               | 11 ++++-
 drivers/net/ethernet/sfc/ef100_nic.c          | 24 +++++++---
 drivers/net/ethernet/sfc/efx.c                | 21 ++++++---
 drivers/net/ethernet/sfc/falcon/efx.c         | 10 +++--
 drivers/net/ethernet/sfc/falcon/net_driver.h  |  1 +
 drivers/net/ethernet/sfc/net_driver.h         |  1 +
 net/ethtool/ioctl.c                           | 17 +++++--
 8 files changed, 100 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 14dc12c2155d..74ebba5b9bc3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -12,6 +12,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/skbuff.h>
@@ -3253,23 +3254,46 @@ static struct pci_driver hns3_driver = {
 	.err_handler    = &hns3_err_handler,
 };
 
+DECLARE_NETDEV_FEATURE_SET(hns3_default_feature_set,
+			   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_GSO_BIT,
+			   NETIF_F_GRO_BIT,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_GSO_GRE_BIT,
+			   NETIF_F_GSO_GRE_CSUM_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_BIT,
+			   NETIF_F_SCTP_CRC_BIT,
+			   NETIF_F_FRAGLIST);
+
+DECLARE_NETDEV_FEATURE_SET(hns3_vlan_off_feature_set,
+			   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_GRO_HW_BIT,
+			   NETIF_F_NTUPLE_BIT,
+			   NETIF_F_HW_TC_BIT);
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
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
+	netdev_features_zero(&features);
+	netdev_features_set_array(&hns3_default_feature_set, &features);
+	netdev->features |= features;
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		netdev->features |= NETIF_F_GRO_HW;
@@ -3296,10 +3320,10 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->vlan_features |= netdev->features &
-		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
-		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
-		  NETIF_F_HW_TC);
+	netdev_features_zero(&vlan_off_features);
+	netdev_features_set_array(&hns3_vlan_off_feature_set,
+				  &vlan_off_features);
+	netdev->vlan_features |= netdev->features & ~vlan_off_features;
 
 	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
 }
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 50d535981a35..bb31043902e4 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1301,6 +1301,12 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 	nic_data->mc_stats = NULL;
 }
 
+DECLARE_NETDEV_FEATURE_SET(ef10_tso_feature_set,
+			   NETIF_F_GSO_UDP_TUNNEL_BIT,
+			   NETIF_F_GSO_GRE_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+			   NETIF_F_GSO_GRE_CSUM_BIT);
+
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
@@ -1356,8 +1362,9 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+		netdev_features_zero(&encap_tso_features);
+		netdev_features_set_array(&ef10_tso_feature_set,
+					  &encap_tso_features);
 
 		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
 		efx->net_dev->features |= encap_tso_features;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index a07cbf45a326..18bf6a33b355 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -147,6 +147,15 @@ static int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address)
 	return 0;
 }
 
+DECLARE_NETDEV_FEATURE_SET(ef100_tso_feature_set,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_GSO_PARTIAL_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+			   NETIF_F_GSO_GRE_BIT,
+			   NETIF_F_GSO_GRE_CSUM_BIT);
+
 static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
@@ -185,10 +194,10 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
 		struct net_device *net_dev = efx->net_dev;
-		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
-					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
+		netdev_features_t tso;
 
+		netdev_features_zero(&tso);
+		netdev_features_set_array(&ef100_tso_feature_set, &tso);
 		net_dev->features |= tso;
 		net_dev->hw_features |= tso;
 		net_dev->hw_enc_features |= tso;
@@ -1105,6 +1114,11 @@ static int ef100_check_design_params(struct efx_nic *efx)
 	return rc;
 }
 
+DECLARE_NETDEV_FEATURE_SET(ef100_vlan_feature_set,
+			   NETIF_F_HW_CSUM_BIT,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_HIGHDMA_BIT);
+
 /*	NIC probe and remove
  */
 static int ef100_probe_main(struct efx_nic *efx)
@@ -1126,8 +1140,8 @@ static int ef100_probe_main(struct efx_nic *efx)
 	net_dev->features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 	net_dev->hw_enc_features |= efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
-				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_array(net_dev, &ef100_vlan_feature_set);
 
 	/* Populate design-parameter defaults */
 	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 302dc835ac3d..bd76e1c5f879 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -988,6 +988,18 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 	return rc;
 }
 
+DECLARE_NETDEV_FEATURE_SET(efx_active_feature_set,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_RXALL_BIT);
+
+DECLARE_NETDEV_FEATURE_SET(efx_vlan_feature_set,
+			   NETIF_F_HW_CSUM_BIT,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_HIGHDMA_BIT,
+			   NETIF_F_RXCSUM_BIT);
+
 static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
@@ -1004,17 +1016,16 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
+	net_dev->features |= efx->type->offload_features;
+	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
-				   NETIF_F_RXCSUM);
+	net_dev->vlan_features |= NETIF_F_ALL_TSO;
+	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 60c595ef7589..eeae4edf4a47 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2859,6 +2859,12 @@ static int ef4_pci_probe_main(struct ef4_nic *efx)
 	return rc;
 }
 
+DECLARE_NETDEV_FEATURE_SET(efx_vlan_feature_set,
+			   NETIF_F_HW_CSUM_BIT,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_HIGHDMA_BIT,
+			   NETIF_F_RXCSUM_BIT);
+
 /* NIC initialisation
  *
  * This is called at module load (or hotplug insertion,
@@ -2907,9 +2913,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_RXCSUM);
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_RXCSUM);
-
+	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
 
 	/* Disable VLAN filtering by default.  It may be enforced if
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a381cf9ec4f3..e1c7e3098a95 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -26,6 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
+#include <linux/netdev_features_helper.h>
 #include <net/busy_poll.h>
 
 #include "enum.h"
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index c75dc75e2857..2407fd4ef785 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -25,6 +25,7 @@
 #include <linux/rwsem.h>
 #include <linux/vmalloc.h>
 #include <linux/mtd/mtd.h>
+#include <linux/netdev_features_helper.h>
 #include <net/busy_poll.h>
 #include <net/xdp.h>
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 326e14ee05db..243ee8a0bd18 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/bitops.h>
@@ -288,9 +289,13 @@ static int ethtool_set_one_feature(struct net_device *dev,
 
 #define ETH_ALL_FLAGS    (ETH_FLAG_LRO | ETH_FLAG_RXVLAN | ETH_FLAG_TXVLAN | \
 			  ETH_FLAG_NTUPLE | ETH_FLAG_RXHASH)
-#define ETH_ALL_FEATURES (NETIF_F_LRO | NETIF_F_HW_VLAN_CTAG_RX | \
-			  NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_NTUPLE | \
-			  NETIF_F_RXHASH)
+
+DECLARE_NETDEV_FEATURE_SET(ethtool_all_feature_set,
+			   NETIF_F_LRO_BIT,
+			   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_NTUPLE_BIT,
+			   NETIF_F_RXHASH_BIT);
 
 static u32 __ethtool_get_flags(struct net_device *dev)
 {
@@ -313,6 +318,7 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
 	netdev_features_t features = 0, changed;
+	netdev_features_t eth_all_features;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
@@ -328,8 +334,11 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	if (data & ETH_FLAG_RXHASH)
 		features |= NETIF_F_RXHASH;
 
+	netdev_features_zero(&eth_all_features);
+	netdev_features_set_array(&ethtool_all_feature_set, &eth_all_features);
+
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->features) & ETH_ALL_FEATURES;
+	changed = (features ^ dev->features) & eth_all_features;
 	if (changed & ~dev->hw_features)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-- 
2.33.0

