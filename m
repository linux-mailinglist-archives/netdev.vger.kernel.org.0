Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1115C58E54D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiHJDOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiHJDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA6482F8E
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfr2cGJzXdT3;
        Wed, 10 Aug 2022 11:09:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:45 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 11/36] treewide: replace NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM by netdev_ip_csum_features
Date:   Wed, 10 Aug 2022 11:05:59 +0800
Message-ID: <20220810030624.34711-12-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the expression "NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM" by
netdev_ip_csum_features, make it simple to use netdev features
helpers later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                        |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c             |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     |  6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c      |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                   |  3 +--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      | 11 +++++------
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |  6 +++---
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    |  5 +++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c |  3 +--
 drivers/net/ethernet/sfc/ef10.c                      |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c    |  6 ++----
 drivers/net/usb/smsc75xx.c                           |  2 +-
 include/linux/netdev_features_helper.h               |  4 ++--
 include/net/udp.h                                    |  2 +-
 net/8021q/vlan_dev.c                                 |  2 +-
 net/core/dev.c                                       | 10 +++++-----
 16 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 548265312743..1d59522a50d8 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1339,7 +1339,7 @@ static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static netdev_features_t vector_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
-	features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+	features &= ~netdev_ip_csum_features;
 	return features;
 }
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index f342bb853189..135c6e95b6f1 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2203,7 +2203,7 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 		features |= vxlan_base;
 	}
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+	if (features & netdev_ip_csum_features) {
 		if (!(features & NETIF_F_GSO_UDP_TUNNEL_CSUM)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index d3c51e1a7c82..8248e10717b9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2440,8 +2440,8 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 			return err;
 	}
 
-	if (changed & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		enable = !!(features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM));
+	if (changed & netdev_ip_csum_features) {
+		enable = !!(features & netdev_ip_csum_features);
 		err = dpaa2_eth_set_tx_csum(priv, enable);
 		if (err)
 			return err;
@@ -4700,7 +4700,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_csum;
 
 	err = dpaa2_eth_set_tx_csum(priv,
-				    !!(net_dev->features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)));
+				    !!(net_dev->features & netdev_ip_csum_features));
 	if (err)
 		goto err_csum;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index dccb20072d28..3213322fcb08 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3304,7 +3304,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev->features |= NETIF_F_HW_CSUM;
 	else
-		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->features |= netdev_ip_csum_features;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c0ae18a2b601..43f12a96cf90 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4884,8 +4884,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
 		adapter->netdev->hw_features |= NETIF_F_IPV6_CSUM;
 
-	if ((adapter->netdev->features &
-	    (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)))
+	if ((adapter->netdev->features & netdev_ip_csum_features))
 		adapter->netdev->hw_features |= NETIF_F_RXCSUM;
 
 	if (buf->large_tx_ipv4)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 38c5ab6a5126..d693c6580e27 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1266,7 +1266,7 @@ static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
 static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 			      enum mvpp2_bm_pool_log_num new_long_pool)
 {
-	const netdev_features_t csums = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	const netdev_features_t csums = netdev_ip_csum_features;
 
 	/* Update L4 checksum when jumbo enable/disable on port.
 	 * Only port 0 supports hardware checksum offload due to
@@ -1341,12 +1341,11 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 
 		/* Update L4 checksum when jumbo enable/disable on port */
 		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-			dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-			dev->hw_features &= ~(NETIF_F_IP_CSUM |
-					      NETIF_F_IPV6_CSUM);
+			dev->features &= ~netdev_ip_csum_features;
+			dev->hw_features &= ~netdev_ip_csum_features;
 		} else {
-			dev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-			dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+			dev->features |= netdev_ip_csum_features;
+			dev->hw_features |= netdev_ip_csum_features;
 		}
 	}
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b9bade6cd50e..1ab570715dfb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1678,8 +1678,8 @@ static int nfp_net_set_features(struct net_device *netdev,
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 
-	if (changed & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+	if (changed & netdev_ip_csum_features) {
+		if (features & netdev_ip_csum_features)
 			new_ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXCSUM;
@@ -2357,7 +2357,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXCSUM) {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->hw_features |= netdev_ip_csum_features;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_GATHER) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 8b77582bdfa0..e63788a66ff7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/lockdep.h>
+#include <linux/netdev_features_helper.h>
 #include <net/dst_metadata.h>
 
 #include "nfpcore/nfp_cpp.h"
@@ -243,7 +244,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	lower_dev = repr->dst->u.port_info.lower_dev;
 
 	lower_features = lower_dev->features;
-	if (lower_features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+	if (lower_features & netdev_ip_csum_features)
 		lower_features |= NETIF_F_HW_CSUM;
 
 	features = netdev_intersect_features(features, lower_features);
@@ -344,7 +345,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	if (repr_cap & NFP_NET_CFG_CTRL_RXCSUM_ANY)
 		netdev->hw_features |= NETIF_F_RXCSUM;
 	if (repr_cap & NFP_NET_CFG_CTRL_TXCSUM)
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->hw_features |= netdev_ip_csum_features;
 	if (repr_cap & NFP_NET_CFG_CTRL_GATHER)
 		netdev->hw_features |= NETIF_F_SG;
 	if ((repr_cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index ba194698cc14..0b06f9875b56 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -437,8 +437,7 @@ static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
 	ul_header = (struct rmnet_map_ul_csum_header *)
 		    skb_push(skb, sizeof(struct rmnet_map_ul_csum_header));
 
-	if (unlikely(!(orig_dev->features &
-		     (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))))
+	if (unlikely(!(orig_dev->features & netdev_ip_csum_features)))
 		goto sw_csum;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 5e0d21475574..064d6f224af8 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1357,7 +1357,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		hw_enc_features |= netdev_ip_csum_features;
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index 5c9b6c90942b..c5c53269c2f8 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -182,11 +182,9 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 		netdev->hw_features = NETIF_F_TSO;
 		netdev->hw_features |= NETIF_F_TSO6;
 		netdev->hw_features |= NETIF_F_SG;
-		netdev->hw_features |= NETIF_F_IP_CSUM;
-		netdev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev->hw_features |= netdev_ip_csum_features;
 	} else if (pdata->hw_feat.tx_coe) {
-		netdev->hw_features = NETIF_F_IP_CSUM;
-		netdev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev->hw_features = netdev_ip_csum_features;
 	}
 
 	if (pdata->hw_feat.rx_coe) {
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 34b79291e159..8aa7a0417476 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1479,7 +1479,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		dev->net->features |= netdev_ip_csum_features;
 
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index 5423927d139b..e096786e4b7a 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -690,9 +690,9 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 {
 	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
 		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+			f1 |= netdev_ip_csum_features;
 		else
-			f2 |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+			f2 |= netdev_ip_csum_features;
 	}
 
 	return f1 & f2;
diff --git a/include/net/udp.h b/include/net/udp.h
index 5ee88ddf79c3..13887234a241 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -464,7 +464,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	 * asks for the final checksum values
 	 */
 	if (!inet_get_convert_csum(sk))
-		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		features |= netdev_ip_csum_features;
 
 	/* UDP segmentation expects packets of type CHECKSUM_PARTIAL or
 	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 75d12ff0d146..3af719812f00 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -660,7 +660,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
-	if (lower_features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))
+	if (lower_features & netdev_ip_csum_features)
 		lower_features |= NETIF_F_HW_CSUM;
 	features = netdev_intersect_features(features, lower_features);
 	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
diff --git a/net/core/dev.c b/net/core/dev.c
index 7e600c69abe5..ae2c44624732 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3642,7 +3642,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 	if (features & NETIF_F_HW_CSUM)
 		return 0;
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+	if (features & netdev_ip_csum_features) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -9608,9 +9608,9 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 {
 	/* Fix illegal checksum combinations */
 	if ((features & NETIF_F_HW_CSUM) &&
-	    (features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))) {
+	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+		features &= ~netdev_ip_csum_features;
 	}
 
 	/* TSO requires that SG is present as well. */
@@ -9685,8 +9685,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	}
 
 	if (features & NETIF_F_HW_TLS_TX) {
-		bool ip_csum = (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
-			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+		bool ip_csum = (features & netdev_ip_csum_features) ==
+			netdev_ip_csum_features;
 		bool hw_csum = features & NETIF_F_HW_CSUM;
 
 		if (!ip_csum && !hw_csum) {
-- 
2.33.0

