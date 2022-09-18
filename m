Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93325BBCF2
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiIRJt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIRJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4615211C29
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjc52Bx0zmVMW;
        Sun, 18 Sep 2022 17:45:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 11/55] treewide: replace NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM by netdev_ip_csum_features
Date:   Sun, 18 Sep 2022 09:42:52 +0000
Message-ID: <20220918094336.28958-12-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    |  4 ++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c |  3 +--
 drivers/net/ethernet/sfc/ef10.c                      |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c    |  6 ++----
 drivers/net/usb/smsc75xx.c                           |  2 +-
 include/linux/netdev_feature_helpers.h               |  4 ++--
 include/net/udp.h                                    |  2 +-
 net/8021q/vlan_dev.c                                 |  2 +-
 net/core/dev.c                                       | 10 +++++-----
 16 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index e1e91f6db8f9..70b76c41e314 100644
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
index 4101c9ee7c99..7fa30a2dbb51 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2205,7 +2205,7 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 		features |= vxlan_base;
 	}
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+	if (features & netdev_ip_csum_features) {
 		if (!(features & NETIF_F_GSO_UDP_TUNNEL_CSUM)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 2b79cf7b6b69..09a1e623882b 100644
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
@@ -4694,7 +4694,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_csum;
 
 	err = dpaa2_eth_set_tx_csum(priv,
-				    !!(net_dev->features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)));
+				    !!(net_dev->features & netdev_ip_csum_features));
 	if (err)
 		goto err_csum;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fa773037a484..5bd054b39dad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3336,7 +3336,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev->features |= NETIF_F_HW_CSUM;
 	else
-		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->features |= netdev_ip_csum_features;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1987bedb5c12..06c1b9dd25ce 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4880,8 +4880,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
 		adapter->netdev->hw_features |= NETIF_F_IPV6_CSUM;
 
-	if ((adapter->netdev->features &
-	    (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)))
+	if ((adapter->netdev->features & netdev_ip_csum_features))
 		adapter->netdev->hw_features |= NETIF_F_RXCSUM;
 
 	if (buf->large_tx_ipv4)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index be0b95342b1d..b50cfdb33f53 100644
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
index 4b38f3105523..0106f759b3b3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1682,8 +1682,8 @@ static int nfp_net_set_features(struct net_device *netdev,
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 
-	if (changed & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+	if (changed & netdev_ip_csum_features) {
+		if (features & netdev_ip_csum_features)
 			new_ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXCSUM;
@@ -2361,7 +2361,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXCSUM) {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->hw_features |= netdev_ip_csum_features;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_GATHER) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 8023a3f0d43b..fd5cb2138520 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -244,7 +244,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	lower_dev = repr->dst->u.port_info.lower_dev;
 
 	lower_features = lower_dev->features;
-	if (lower_features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+	if (lower_features & netdev_ip_csum_features)
 		lower_features |= NETIF_F_HW_CSUM;
 
 	features = netdev_intersect_features(features, lower_features);
@@ -345,7 +345,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
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
index fdc5f6450072..c0d6f6419228 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1351,7 +1351,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		hw_enc_features |= netdev_ip_csum_features;
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index f8e133604146..cfe715019699 100644
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
index d598ef577c47..5332bb724f98 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1474,7 +1474,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		dev->net->features |= netdev_ip_csum_features;
 
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 7faea4c39bca..456ebfd97632 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -702,9 +702,9 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
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
index c98828e28e0d..b1aab3cd7c28 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -657,7 +657,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
-	if (lower_features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))
+	if (lower_features & netdev_ip_csum_features)
 		lower_features |= NETIF_F_HW_CSUM;
 	features = netdev_intersect_features(features, lower_features);
 	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
diff --git a/net/core/dev.c b/net/core/dev.c
index 103e1022bb0d..302ae1fdca85 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3641,7 +3641,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 	if (features & NETIF_F_HW_CSUM)
 		return 0;
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+	if (features & netdev_ip_csum_features) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -9607,9 +9607,9 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
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
@@ -9684,8 +9684,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
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

