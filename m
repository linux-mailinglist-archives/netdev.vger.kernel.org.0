Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253015BBCFD
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIRJve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiIRJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE7117E29
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjcB60XFzmVMS;
        Sun, 18 Sep 2022 17:46:02 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:53 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 42/55] net: adjust the prototype of ndo_fix_features
Date:   Sun, 18 Sep 2022 09:43:23 +0000
Message-ID: <20220918094336.28958-43-shenjian15@huawei.com>
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

The function net_device_ops.ndo_fix_features() using
netdev_features_t as parameters, and returns netdev_features_t
directly. For the prototype of netdev_features_t will be extended
to be larger than 8 bytes, so change the prototype of the function,
change the prototype of input features to'netdev_features_t *',
and return the features pointer as output parameter. So changes
all the implement for this function of all the netdev drivers, and
relative functions.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |   7 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   6 +-
 drivers/net/bonding/bond_main.c               |  20 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  28 ++---
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  14 +--
 drivers/net/ethernet/atheros/alx/main.c       |   8 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  14 +--
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  12 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  12 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |  12 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  29 ++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  27 ++---
 drivers/net/ethernet/broadcom/tg3.c           |   8 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  34 +++---
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  30 +++--
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  10 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  11 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  12 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  10 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  12 +-
 drivers/net/ethernet/cortina/gemini.c         |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |   7 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  10 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  10 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  12 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  14 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 114 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_main.c     |  30 +++--
 drivers/net/ethernet/intel/igb/igb_main.c     |  12 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  12 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  16 ++-
 drivers/net/ethernet/jme.c                    |   9 +-
 drivers/net/ethernet/marvell/mvneta.c         |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  12 +-
 drivers/net/ethernet/marvell/sky2.c           |  18 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  10 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  54 ++++-----
 .../ethernet/netronome/nfp/nfp_net_common.c   |  13 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  15 ++-
 drivers/net/ethernet/nvidia/forcedeth.c       |   9 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  10 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |   3 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |   9 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |   4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  35 +++---
 drivers/net/ethernet/realtek/r8169_main.c     |  12 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  14 +--
 drivers/net/hyperv/netvsc_drv.c               |  12 +-
 drivers/net/ipvlan/ipvlan_main.c              |  18 ++-
 drivers/net/macsec.c                          |  14 +--
 drivers/net/macvlan.c                         |  20 ++-
 drivers/net/team/team.c                       |  16 ++-
 drivers/net/tun.c                             |  10 +-
 drivers/net/veth.c                            |  10 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  10 +-
 drivers/net/vmxnet3/vmxnet3_int.h             |   4 +-
 drivers/net/xen-netback/interface.c           |  16 ++-
 drivers/net/xen-netfront.c                    |  22 ++--
 drivers/s390/net/qeth_core.h                  |   2 +-
 drivers/s390/net/qeth_core_main.c             |  16 ++-
 include/linux/netdevice.h                     |   4 +-
 net/8021q/vlan_dev.c                          |  15 ++-
 net/bridge/br_device.c                        |   5 +-
 net/bridge/br_if.c                            |  15 +--
 net/bridge/br_private.h                       |   3 +-
 net/core/dev.c                                |   2 +-
 net/hsr/hsr_device.c                          |  18 ++-
 70 files changed, 461 insertions(+), 592 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 4ac7af5a635d..d41ac42762ed 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1336,11 +1336,10 @@ static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	schedule_work(&vp->reset_tx);
 }
 
-static netdev_features_t vector_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void vector_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
-	netdev_features_clear(features, netdev_ip_csum_features);
-	return features;
+	netdev_features_clear(*features, netdev_ip_csum_features);
 }
 
 static int vector_set_features(struct net_device *dev,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index de878f4f7963..f802022f53fb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -214,15 +214,13 @@ static int ipoib_stop(struct net_device *dev)
 	return 0;
 }
 
-static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_features_t features)
+static void ipoib_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
-		netdev_features_clear_set(features, NETIF_F_IP_CSUM_BIT,
+		netdev_features_clear_set(*features, NETIF_F_IP_CSUM_BIT,
 					  NETIF_F_TSO_BIT);
-
-	return features;
 }
 
 static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a50f8935658a..cd7c8d81ba0c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1396,8 +1396,8 @@ static void bond_netpoll_cleanup(struct net_device *bond_dev)
 
 /*---------------------------------- IOCTL ----------------------------------*/
 
-static netdev_features_t bond_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void bond_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct bonding *bond = netdev_priv(dev);
 	struct list_head *iter;
@@ -1406,23 +1406,21 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		netdev_features_set(features, BOND_TLS_FEATURES);
+		netdev_features_set(*features, BOND_TLS_FEATURES);
 	else
-		netdev_features_clear(features, BOND_TLS_FEATURES);
+		netdev_features_clear(*features, BOND_TLS_FEATURES);
 #endif
 
-	mask = features;
+	netdev_features_copy(mask, *features);
 
-	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
-	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
+	netdev_features_clear(*features, NETIF_F_ONE_FOR_ALL);
+	netdev_features_set(*features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
-		netdev_increment_features(&features, &features,
+		netdev_increment_features(features, features,
 					  &slave->dev->features, &mask);
 	}
-	netdev_add_tso_features(&features, &mask);
-
-	return features;
+	netdev_add_tso_features(features, &mask);
 }
 
 #define BOND_VLAN_FEATURES	bond_vlan_features
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 5ecd0904aacc..e84a69fb4812 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2177,8 +2177,8 @@ static int xgbe_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	return 0;
 }
 
-static netdev_features_t xgbe_fix_features(struct net_device *netdev,
-					   netdev_features_t features)
+static void xgbe_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	netdev_features_t vxlan_base;
@@ -2188,40 +2188,38 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 				NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 
 	if (!pdata->hw_feat.vxn)
-		return features;
+		return;
 
 	/* VXLAN CSUM requires VXLAN base */
-	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, *features)) {
 		netdev_notice(netdev,
 			      "forcing tx udp tunnel support\n");
-		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, features);
+		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, *features);
 	}
 
 	/* Can't do one without doing the other */
-	if (!netdev_features_subset(vxlan_base, features)) {
+	if (!netdev_features_subset(vxlan_base, *features)) {
 		netdev_notice(netdev,
 			      "forcing both tx and rx udp tunnel support\n");
-		netdev_features_set(features, vxlan_base);
+		netdev_features_set(*features, vxlan_base);
 	}
 
-	if (netdev_features_intersects(features, netdev_ip_csum_features)) {
-		if (!netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features)) {
+	if (netdev_features_intersects(*features, netdev_ip_csum_features)) {
+		if (!netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, *features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
 			netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-					   features);
+					   *features);
 		}
 	} else {
-		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, *features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming off\n");
 			netdev_feature_del(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-					   features);
+					   *features);
 		}
 	}
-
-	return features;
 }
 
 static int xgbe_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index c331631d82c0..cd714a6cdf27 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -227,23 +227,21 @@ static int aq_ndev_set_features(struct net_device *ndev,
 	return err;
 }
 
-static netdev_features_t aq_ndev_fix_features(struct net_device *ndev,
-					      netdev_features_t features)
+static void aq_ndev_fix_features(struct net_device *ndev,
+				 netdev_features_t *features)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct bpf_prog *prog;
 
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 
 	prog = READ_ONCE(aq_nic->xdp_prog);
 	if (prog && !prog->aux->xdp_has_frags &&
-	    aq_nic->xdp_prog && netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	    aq_nic->xdp_prog && netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 		netdev_err(ndev, "LRO is not supported with single buffer XDP, disabling\n");
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 	}
-
-	return features;
 }
 
 static int aq_ndev_set_mac_address(struct net_device *ndev, void *addr)
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index d780a32ca51d..96a28cb8c6a4 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1098,13 +1098,11 @@ static int alx_init_sw(struct alx_priv *alx)
 }
 
 
-static netdev_features_t alx_fix_features(struct net_device *netdev,
-					  netdev_features_t features)
+static void alx_fix_features(struct net_device *netdev,
+			     netdev_features_t *features)
 {
 	if (netdev->mtu > ALX_MAX_TSO_PKT_SIZE)
-		netdev_features_clear(features, netdev_general_tso_features);
-
-	return features;
+		netdev_features_clear(*features, netdev_general_tso_features);
 }
 
 static void alx_netif_stop(struct alx_priv *alx)
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 202cc99ac334..b38b508db29c 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -504,8 +504,8 @@ static void atl1c_set_rxbufsize(struct atl1c_adapter *adapter,
 	adapter->rx_frag_size = roundup_pow_of_two(head_size);
 }
 
-static netdev_features_t atl1c_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atl1c_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 	struct atl1c_hw *hw = &adapter->hw;
@@ -514,18 +514,16 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 
 	if (hw->nic_type != athr_mt) {
 		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-			netdev_features_clear(features,
+			netdev_features_clear(*features,
 					      netdev_general_tso_features);
 	}
-
-	return features;
 }
 
 static int atl1c_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index ebc1606368d0..fef2ba816451 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -382,19 +382,17 @@ static int atl1e_set_mac_addr(struct net_device *netdev, void *p)
 	return 0;
 }
 
-static netdev_features_t atl1e_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atl1e_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int atl1e_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index b43c193dc433..589c9f38e3ae 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -372,19 +372,17 @@ static void atl2_restore_vlan(struct atl2_adapter *adapter)
 	atl2_vlan_mode(adapter->netdev, adapter->netdev->features);
 }
 
-static netdev_features_t atl2_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atl2_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int atl2_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index d840713c8ad8..1943f97e8283 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -237,19 +237,17 @@ static void atlx_restore_vlan(struct atlx_adapter *adapter)
 	atlx_vlan_mode(adapter->netdev, adapter->netdev->features);
 }
 
-static netdev_features_t atlx_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atlx_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int atlx_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 53b6ed00e124..23a9746c6e55 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4899,43 +4899,40 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu)
 	return bnx2x_reload_if_running(dev);
 }
 
-netdev_features_t bnx2x_fix_features(struct net_device *dev,
-				     netdev_features_t features)
+void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
 	if (pci_num_vf(bp->pdev)) {
 		netdev_features_t changed;
 
-		netdev_features_xor(changed, dev->features, features);
+		netdev_features_xor(changed, dev->features, *features);
 		/* Revert the requested changes in features if they
 		 * would require internal reload of PF in bnx2x_set_features().
 		 */
-		if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !bp->disable_tpa) {
-			netdev_feature_del(NETIF_F_RXCSUM_BIT, features);
+		if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) && !bp->disable_tpa) {
+			netdev_feature_del(NETIF_F_RXCSUM_BIT, *features);
 			if (netdev_active_feature_test(dev, NETIF_F_RXCSUM_BIT))
 				netdev_feature_add(NETIF_F_RXCSUM_BIT,
-						   features);
+						   *features);
 		}
 
 		if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed)) {
-			netdev_feature_del(NETIF_F_LOOPBACK_BIT, features);
+			netdev_feature_del(NETIF_F_LOOPBACK_BIT, *features);
 			if (netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT))
 				netdev_feature_add(NETIF_F_LOOPBACK_BIT,
-						   features);
+						   *features);
 		}
 	}
 
 	/* TPA requires Rx CSUM offloading */
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 
-	if (!netdev_feature_test(NETIF_F_GRO_BIT, features) || !bnx2x_mtu_allows_gro(dev->mtu))
-		netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
-	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
-
-	return features;
+	if (!netdev_feature_test(NETIF_F_GRO_BIT, *features) || !bnx2x_mtu_allows_gro(dev->mtu))
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features))
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 }
 
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index d8b1824c334d..4c66ef3e04bf 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -606,8 +606,7 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu);
 int bnx2x_fcoe_get_wwn(struct net_device *dev, u64 *wwn, int type);
 #endif
 
-netdev_features_t bnx2x_fix_features(struct net_device *dev,
-				     netdev_features_t features);
+void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features);
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features);
 
 /**
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 97a108fdf693..b6ca502a3af1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11170,43 +11170,42 @@ static bool bnxt_rfs_capable(struct bnxt *bp)
 #endif
 }
 
-static netdev_features_t bnxt_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void bnxt_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	netdev_features_t vlan_features;
 
-	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features) && !bnxt_rfs_capable(bp))
-		netdev_feature_del(NETIF_F_NTUPLE_BIT, features);
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, *features) && !bnxt_rfs_capable(bp))
+		netdev_feature_del(NETIF_F_NTUPLE_BIT, *features);
 
 	if ((bp->flags & BNXT_FLAG_NO_AGG_RINGS) || bp->xdp_prog)
-		netdev_features_clear_set(features, NETIF_F_LRO_BIT,
+		netdev_features_clear_set(*features, NETIF_F_LRO_BIT,
 					  NETIF_F_GRO_HW_BIT);
 
-	if (!netdev_feature_test(NETIF_F_GRO_BIT, features))
-		netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+	if (!netdev_feature_test(NETIF_F_GRO_BIT, *features))
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 
-	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features))
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	netdev_features_and(vlan_features, features,
+	netdev_features_and(vlan_features, *features,
 			    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	if (!netdev_features_equal(vlan_features, BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		if (netdev_active_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
-			netdev_features_clear(features,
+			netdev_features_clear(*features,
 					      BNXT_HW_FEATURE_VLAN_ALL_RX);
 		else if (!netdev_features_empty(vlan_features))
-			netdev_features_set(features,
+			netdev_features_set(*features,
 					    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	}
 #ifdef CONFIG_BNXT_SRIOV
 	if (BNXT_VF(bp) && bp->vf.vlan)
-		netdev_features_clear(features, BNXT_HW_FEATURE_VLAN_ALL_RX);
+		netdev_features_clear(*features, BNXT_HW_FEATURE_VLAN_ALL_RX);
 #endif
-	return features;
 }
 
 static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 00f887601a1a..be6d69b9c3c1 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8304,15 +8304,13 @@ static void tg3_set_loopback(struct net_device *dev, netdev_features_t features)
 	}
 }
 
-static netdev_features_t tg3_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void tg3_fix_features(struct net_device *dev,
+			     netdev_features_t *features)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
 	if (dev->mtu > ETH_DATA_LEN && tg3_flag(tp, 5780_CLASS))
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
-
-	return features;
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 }
 
 static int tg3_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index a2e18f493d7e..cb0cc8a5c268 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2715,43 +2715,41 @@ static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
  * @request: features requested
  * Return: updated features list
  */
-static netdev_features_t liquidio_fix_features(struct net_device *netdev,
-					       netdev_features_t request)
+static void liquidio_fix_features(struct net_device *netdev,
+				  netdev_features_t *request)
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_RXCSUM_BIT, request);
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_HW_CSUM_BIT, request);
+		netdev_feature_del(NETIF_F_HW_CSUM_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_TSO_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_TSO_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_TSO_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_TSO_BIT, request);
+		netdev_feature_del(NETIF_F_TSO_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_TSO6_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_TSO6_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_TSO6_BIT, request);
+		netdev_feature_del(NETIF_F_TSO6_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_LRO_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_LRO_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_LRO_BIT, request);
+		netdev_feature_del(NETIF_F_LRO_BIT, *request);
 
 	/*Disable LRO if RXCSUM is off */
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *request) &&
 	    netdev_active_feature_test(netdev, NETIF_F_LRO_BIT) &&
 	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_LRO_BIT, request);
+		netdev_feature_del(NETIF_F_LRO_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				 lio->dev_capability))
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, request);
-
-	return request;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *request);
 }
 
 /**
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 51d202c0bf52..8cf64202846b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1813,38 +1813,36 @@ static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
  * @param request features requested
  * @returns updated features list
  */
-static netdev_features_t liquidio_fix_features(struct net_device *netdev,
-					       netdev_features_t request)
+static void liquidio_fix_features(struct net_device *netdev,
+				  netdev_features_t *request)
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_RXCSUM_BIT, request);
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_HW_CSUM_BIT, request);
+		netdev_feature_del(NETIF_F_HW_CSUM_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_TSO_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_TSO_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_TSO_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_TSO_BIT, request);
+		netdev_feature_del(NETIF_F_TSO_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_TSO6_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_TSO6_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_TSO6_BIT, request);
+		netdev_feature_del(NETIF_F_TSO6_BIT, *request);
 
-	if (netdev_feature_test(NETIF_F_LRO_BIT, request) &&
+	if (netdev_feature_test(NETIF_F_LRO_BIT, *request) &&
 	    !netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_LRO_BIT, request);
+		netdev_feature_del(NETIF_F_LRO_BIT, *request);
 
 	/* Disable LRO if RXCSUM is off */
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, request) &&
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *request) &&
 	    netdev_active_feature_test(netdev, NETIF_F_LRO_BIT) &&
 	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
-		netdev_feature_del(NETIF_F_LRO_BIT, request);
-
-	return request;
+		netdev_feature_del(NETIF_F_LRO_BIT, *request);
 }
 
 /** \brief Net device set features
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 979a03faca7a..994608dde650 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1773,16 +1773,14 @@ static int nicvf_config_loopback(struct nicvf *nic,
 	return nicvf_send_msg_to_pf(nic, &mbx);
 }
 
-static netdev_features_t nicvf_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void nicvf_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
-	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features) &&
 	    netif_running(netdev) && !nic->loopback_supported)
-		netdev_feature_del(NETIF_F_LOOPBACK_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_LOOPBACK_BIT, *features);
 }
 
 static int nicvf_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 30e371efcb77..23dcdc7bde05 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -863,19 +863,16 @@ static int t1_set_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 
-static netdev_features_t t1_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void t1_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int t1_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index a1d6279886a7..56bba53a8dd6 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2588,19 +2588,17 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 
-static netdev_features_t cxgb_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void cxgb_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 08ce0b730ec4..c96b11d6c5d8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3858,14 +3858,12 @@ static void cxgb_features_check(struct sk_buff *skb, struct net_device *dev,
 	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
-static netdev_features_t cxgb_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void cxgb_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	/* Disable GRO, if RX_CSUM is disabled */
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
-		netdev_feature_del(NETIF_F_GRO_BIT, features);
-
-	return features;
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_del(NETIF_F_GRO_BIT, *features);
 }
 
 static const struct net_device_ops cxgb4_netdev_ops = {
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 94f253feda79..7941946e512d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1174,19 +1174,17 @@ static int cxgb4vf_change_mtu(struct net_device *dev, int new_mtu)
 	return ret;
 }
 
-static netdev_features_t cxgb4vf_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void cxgb4vf_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int cxgb4vf_set_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index cc3865fb7d83..4da024437808 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1978,13 +1978,11 @@ static int gmac_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
-static netdev_features_t gmac_fix_features(struct net_device *netdev,
-					   netdev_features_t features)
+static void gmac_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	if (netdev->mtu + ETH_HLEN + VLAN_HLEN > MTU_SIZE_BIT_MASK)
-		netdev_features_clear(features, GMAC_OFFLOAD_FEATURES);
-
-	return features;
+		netdev_features_clear(*features, GMAC_OFFLOAD_FEATURES);
 }
 
 static int gmac_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 6147864b0322..c29f2eab3d5f 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1792,21 +1792,20 @@ static int hns_nic_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t hns_nic_fix_features(
-		struct net_device *netdev, netdev_features_t features)
+static void hns_nic_fix_features(struct net_device *netdev,
+				 netdev_features_t *features)
 {
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		netdev_features_clear_set(features, NETIF_F_TSO_BIT,
+		netdev_features_clear_set(*features, NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT,
 					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 		break;
 	default:
 		break;
 	}
-	return features;
 }
 
 static int hns_nic_uc_sync(struct net_device *netdev, const unsigned char *addr)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 59475894676e..035b77c95cf0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -864,18 +864,16 @@ static int hinic_set_features(struct net_device *netdev,
 			    features, false);
 }
 
-static netdev_features_t hinic_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void hinic_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)) {
 		netif_info(nic_dev, drv, netdev, "disabling LRO as RXCSUM is off\n");
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 	}
-
-	return features;
 }
 
 static const struct net_device_ops hinic_netdev_ops = {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 90402227dbd4..3658783641c7 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -731,8 +731,8 @@ static void netdev_get_drvinfo(struct net_device *dev,
 	strscpy(info->version, ibmveth_driver_version, sizeof(info->version));
 }
 
-static netdev_features_t ibmveth_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void ibmveth_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	/*
 	 * Since the ibmveth firmware interface does not have the
@@ -743,10 +743,8 @@ static netdev_features_t ibmveth_fix_features(struct net_device *dev,
 	 * checksummed.
 	 */
 
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
-		netdev_features_clear(features, NETIF_F_CSUM_MASK);
-
-	return features;
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
+		netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 }
 
 static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index a1a0cdb3cf2e..a689aba72050 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -787,18 +787,16 @@ static int e1000_is_need_ioport(struct pci_dev *pdev)
 	}
 }
 
-static netdev_features_t e1000_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void e1000_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int e1000_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index dc286f57a683..d5b022b309aa 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7291,25 +7291,23 @@ static void e1000_eeprom_checks(struct e1000_adapter *adapter)
 	}
 }
 
-static netdev_features_t e1000_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void e1000_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 
 	/* Jumbo frame workaround on 82579 and newer requires CRC be stripped */
 	if ((hw->mac.type >= e1000_pch2lan) && (netdev->mtu > ETH_DATA_LEN))
-		netdev_feature_del(NETIF_F_RXFCS_BIT, features);
+		netdev_feature_del(NETIF_F_RXFCS_BIT, *features);
 
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int e1000_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9b9873d62687..bc9b963a3bd9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4440,23 +4440,23 @@ static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
 /**
  * iavf_get_netdev_vlan_hw_features - get NETDEV VLAN features that can toggle on/off
  * @adapter: board private structure
+ * @hw_features: hw vlan features
  *
  * Depending on whether VIRTHCNL_VF_OFFLOAD_VLAN or VIRTCHNL_VF_OFFLOAD_VLAN_V2
  * were negotiated determine the VLAN features that can be toggled on and off.
  **/
-static netdev_features_t
-iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
+static void
+iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter,
+				 netdev_features_t *hw_features)
 {
-	netdev_features_t hw_features;
-
-	netdev_features_zero(hw_features);
+	netdev_features_zero(*hw_features);
 
 	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
-		return hw_features;
+		return;
 
 	/* Enable VLAN features if supported */
 	if (VLAN_ALLOWED(adapter)) {
-		netdev_features_set(hw_features,
+		netdev_features_set(*hw_features,
 				    netdev_ctag_vlan_offload_features);
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
@@ -4471,18 +4471,18 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 			if (stripping_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-						   hw_features);
+						   *hw_features);
 			if (stripping_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8)
 				netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT,
-						   hw_features);
+						   *hw_features);
 		} else if (stripping_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED &&
 			   stripping_support->inner & VIRTCHNL_VLAN_TOGGLE) {
 			if (stripping_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-						   hw_features);
+						   *hw_features);
 		}
 
 		if (insertion_support->outer != VIRTCHNL_VLAN_UNSUPPORTED &&
@@ -4490,41 +4490,39 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 			if (insertion_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-						   hw_features);
+						   *hw_features);
 			if (insertion_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8)
 				netdev_feature_add(NETIF_F_HW_VLAN_STAG_TX_BIT,
-						   hw_features);
+						   *hw_features);
 		} else if (insertion_support->inner &&
 			   insertion_support->inner & VIRTCHNL_VLAN_TOGGLE) {
 			if (insertion_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-						   hw_features);
+						   *hw_features);
 		}
 	}
-
-	return hw_features;
 }
 
 /**
  * iavf_get_netdev_vlan_features - get the enabled NETDEV VLAN fetures
  * @adapter: board private structure
+ * @features: vlan features
  *
  * Depending on whether VIRTHCNL_VF_OFFLOAD_VLAN or VIRTCHNL_VF_OFFLOAD_VLAN_V2
  * were negotiated determine the VLAN features that are enabled by default.
  **/
-static netdev_features_t
-iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
+static void
+iavf_get_netdev_vlan_features(struct iavf_adapter *adapter,
+			      netdev_features_t *features)
 {
-	netdev_features_t features;
-
-	netdev_features_zero(features);
+	netdev_features_zero(*features);
 	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
-		return features;
+		return;
 
 	if (VLAN_ALLOWED(adapter)) {
-		netdev_features_set(features, netdev_ctag_vlan_features);
+		netdev_features_set(*features, netdev_ctag_vlan_features);
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4545,19 +4543,19 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-						   features);
+						   *features);
 			else if (stripping_support->outer &
 				 VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 				 ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
 				netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT,
-						   features);
+						   *features);
 		} else if (stripping_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED) {
 			if (stripping_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-						   features);
+						   *features);
 		}
 
 		/* give priority to outer insertion and don't support both outer
@@ -4568,19 +4566,19 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-						   features);
+						   *features);
 			else if (insertion_support->outer &
 				 VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 				 ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
 				netdev_feature_add(NETIF_F_HW_VLAN_STAG_TX_BIT,
-						   features);
+						   *features);
 		} else if (insertion_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED) {
 			if (insertion_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-						   features);
+						   *features);
 		}
 
 		/* give priority to outer filtering and don't bother if both
@@ -4592,28 +4590,26 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-						   features);
+						   *features);
 			if (filtering_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
 				netdev_feature_add(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
-						   features);
+						   *features);
 		} else if (filtering_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED) {
 			if (filtering_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-						   features);
+						   *features);
 			if (filtering_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
 				netdev_feature_add(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
-						   features);
+						   *features);
 		}
 	}
-
-	return features;
 }
 
 #define IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested, allowed, feature_bit) \
@@ -4625,63 +4621,61 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
  * @adapter: board private structure
  * @requested_features: stack requested NETDEV features
  **/
-static netdev_features_t
+static void
 iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
-			      netdev_features_t requested_features)
+			      netdev_features_t *requested_features)
 {
 	netdev_features_t allowed_features;
 	netdev_features_t vlan_hw_features;
 	netdev_features_t vlan_features;
 
-	vlan_hw_features = iavf_get_netdev_vlan_hw_features(adapter);
-	vlan_features = iavf_get_netdev_vlan_features(adapter);
+	iavf_get_netdev_vlan_hw_features(adapter, &vlan_hw_features);
+	iavf_get_netdev_vlan_features(adapter, &vlan_features);
 	netdev_features_or(allowed_features, vlan_hw_features, vlan_features);
 
-	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(*requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-				   requested_features);
+				   *requested_features);
 
-	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(*requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-				   requested_features);
+				   *requested_features);
 
-	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(*requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_STAG_TX_BIT))
 		netdev_feature_del(NETIF_F_HW_VLAN_STAG_TX_BIT,
-				   requested_features);
-	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+				   *requested_features);
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(*requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_STAG_RX_BIT))
 		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT,
-				   requested_features);
+				   *requested_features);
 
-	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(*requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				   requested_features);
+				   *requested_features);
 
-	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(*requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_STAG_FILTER_BIT))
 		netdev_feature_del(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
-				   requested_features);
+				   *requested_features);
 
-	if (netdev_features_intersects(requested_features, netdev_ctag_vlan_offload_features) &&
-	    netdev_features_intersects(requested_features, netdev_stag_vlan_offload_features) &&
+	if (netdev_features_intersects(*requested_features, netdev_ctag_vlan_offload_features) &&
+	    netdev_features_intersects(*requested_features, netdev_stag_vlan_offload_features) &&
 	    adapter->vlan_v2_caps.offloads.ethertype_match ==
 	    VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION) {
 		netdev_warn(adapter->netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		netdev_features_clear(requested_features,
+		netdev_features_clear(*requested_features,
 				      netdev_stag_vlan_offload_features);
 	}
-
-	return requested_features;
 }
 
 /**
@@ -4691,12 +4685,12 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
  *
  * Returns fixed-up features bits
  **/
-static netdev_features_t iavf_fix_features(struct net_device *netdev,
-					   netdev_features_t features)
+static void iavf_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	return iavf_fix_netdev_vlan_features(adapter, features);
+	iavf_fix_netdev_vlan_features(adapter, features);
 }
 
 static const struct net_device_ops iavf_netdev_ops = {
@@ -4799,7 +4793,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	hw_features = hw_enc_features;
 
 	/* get HW VLAN features that can be toggled */
-	hw_vlan_features = iavf_get_netdev_vlan_hw_features(adapter);
+	iavf_get_netdev_vlan_hw_features(adapter, &hw_vlan_features);
 
 	/* Enable cloud filter if ADQ is supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ)
@@ -4809,7 +4803,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 
 	netdev_hw_features_set(netdev, hw_features);
 	netdev_hw_features_set(netdev, hw_vlan_features);
-	vlan_features = iavf_get_netdev_vlan_features(adapter);
+	iavf_get_netdev_vlan_features(adapter, &vlan_features);
 
 	netdev_active_features_set(netdev, hw_features);
 	netdev_active_features_set(netdev, vlan_features);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 105f49eaec4d..cce947660cfd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5813,8 +5813,8 @@ ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
  *	enable/disable VLAN filtering based on VLAN ethertype when using VLAN
  *	prune rules.
  */
-static netdev_features_t
-ice_fix_features(struct net_device *netdev, netdev_features_t features)
+static void
+ice_fix_features(struct net_device *netdev, netdev_features_t *features)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	netdev_features_t req_vlan_fltr, cur_vlan_fltr;
@@ -5827,7 +5827,7 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	cur_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 				       cur_vlan_fltr);
 
-	netdev_features_and(req_vlan_fltr, features,
+	netdev_features_and(req_vlan_fltr, *features,
 			    NETIF_VLAN_FILTERING_FEATURES);
 	req_ctag = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       req_vlan_fltr);
@@ -5837,19 +5837,19 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	if (!netdev_features_equal(req_vlan_fltr, cur_vlan_fltr)) {
 		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
 			if (req_ctag && req_stag) {
-				netdev_features_set(features,
+				netdev_features_set(*features,
 						    NETIF_VLAN_FILTERING_FEATURES);
 			} else if (!req_ctag && !req_stag) {
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      NETIF_VLAN_FILTERING_FEATURES);
 			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
 				   (!cur_stag && req_stag && !cur_ctag)) {
-				netdev_features_set(features,
+				netdev_features_set(*features,
 						    NETIF_VLAN_FILTERING_FEATURES);
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
 			} else if ((cur_ctag && !req_ctag && cur_stag) ||
 				   (cur_stag && !req_stag && cur_ctag)) {
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      NETIF_VLAN_FILTERING_FEATURES);
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been disabled for both types.\n");
 			}
@@ -5859,27 +5859,25 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 
 			if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, req_vlan_fltr))
 				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-						   features);
+						   *features);
 		}
 	}
 
-	if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features) &&
-	    netdev_features_intersects(features, netdev_stag_vlan_offload_features)) {
+	if (netdev_features_intersects(*features, netdev_ctag_vlan_offload_features) &&
+	    netdev_features_intersects(*features, netdev_stag_vlan_offload_features)) {
 		netdev_warn(netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		netdev_features_clear(features,
+		netdev_features_clear(*features,
 				      netdev_stag_vlan_offload_features);
 	}
 
 	if (!netdev_active_feature_test(netdev, NETIF_F_RXFCS_BIT) &&
-	    netdev_feature_test(NETIF_F_RXFCS_BIT, features) &&
-	    netdev_features_intersects(features, NETIF_VLAN_STRIPPING_FEATURES) &&
+	    netdev_feature_test(NETIF_F_RXFCS_BIT, *features) &&
+	    netdev_features_intersects(*features, NETIF_VLAN_STRIPPING_FEATURES) &&
 	    !ice_vsi_has_non_zero_vlans(np->vsi)) {
 		netdev_warn(netdev, "Disabling VLAN stripping as FCS/CRC stripping is also disabled and there is no VLAN configured\n");
-		netdev_features_clear(features,
+		netdev_features_clear(*features,
 				      NETIF_VLAN_STRIPPING_FEATURES);
 	}
-
-	return features;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 05da0d2cc21f..a93e52cf01b3 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2432,18 +2432,16 @@ void igb_reset(struct igb_adapter *adapter)
 	igb_get_phy_info(hw);
 }
 
-static netdev_features_t igb_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void igb_fix_features(struct net_device *netdev,
+			     netdev_features_t *features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int igb_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 83a5f3ed7cd6..65eb629cda99 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4972,18 +4972,16 @@ static void igc_get_stats64(struct net_device *netdev,
 	spin_unlock(&adapter->stats64_lock);
 }
 
-static netdev_features_t igc_fix_features(struct net_device *netdev,
-					  netdev_features_t features)
+static void igc_fix_features(struct net_device *netdev,
+			     netdev_features_t *features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int igc_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 0caf35886a95..bb0ce65cd025 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -294,17 +294,15 @@ ixgb_reset(struct ixgb_adapter *adapter)
 	}
 }
 
-static netdev_features_t
-ixgb_fix_features(struct net_device *netdev, netdev_features_t features)
+static void
+ixgb_fix_features(struct net_device *netdev, netdev_features_t *features)
 {
 	/*
 	 * Tx VLAN insertion does not work per HW design when Rx stripping is
 	 * disabled.
 	 */
-	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-
-	return features;
+	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
 static int
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 731ac302cf8e..139eec69f5b9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9830,25 +9830,23 @@ void ixgbe_do_reset(struct net_device *netdev)
 		ixgbe_reset(adapter);
 }
 
-static netdev_features_t ixgbe_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void ixgbe_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then RSC/LRO should also be disabled */
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 
 	/* Turn off LRO if not RSC capable */
 	if (!(adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 
-	if (adapter->xdp_prog && netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	if (adapter->xdp_prog && netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 		e_dev_err("LRO is not supported with XDP\n");
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 	}
-
-	return features;
 }
 
 static void ixgbe_reset_l2fw_offload(struct ixgbe_adapter *adapter)
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 8a9918e34249..fc967f35f8a7 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2661,14 +2661,13 @@ jme_set_msglevel(struct net_device *netdev, u32 value)
 	jme->msg_enable = value;
 }
 
-static netdev_features_t
-jme_fix_features(struct net_device *netdev, netdev_features_t features)
+static void
+jme_fix_features(struct net_device *netdev, netdev_features_t *features)
 {
 	if (netdev->mtu > 1900) {
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
-		netdev_features_clear(features, NETIF_F_CSUM_MASK);
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
+		netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 	}
-	return features;
 }
 
 static int
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index bf6b662c2c91..c5e56dff4311 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3842,20 +3842,18 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 }
 
-static netdev_features_t mvneta_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void mvneta_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 
 	if (pp->tx_csum_limit && dev->mtu > pp->tx_csum_limit) {
-		netdev_features_clear_set(features, NETIF_F_IP_CSUM_BIT,
+		netdev_features_clear_set(*features, NETIF_F_IP_CSUM_BIT,
 					  NETIF_F_TSO_BIT);
 		netdev_info(dev,
 			    "Disable IP checksum for MTU greater than %dB\n",
 			    pp->tx_csum_limit);
 	}
-
-	return features;
 }
 
 /* Get mac address */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index c500f6f44569..839350458bc1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1905,15 +1905,13 @@ static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 	return netdev_pick_tx(netdev, skb, NULL);
 }
 
-static netdev_features_t otx2_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void otx2_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
-		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT, *features);
 }
 
 static void otx2_set_rx_mode(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 959456dcc505..afa6234cdd8f 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4305,8 +4305,8 @@ static int sky2_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom
 	return rc < 0 ? rc : 0;
 }
 
-static netdev_features_t sky2_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void sky2_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	const struct sky2_port *sky2 = netdev_priv(dev);
 	const struct sky2_hw *hw = sky2->hw;
@@ -4316,20 +4316,18 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 	 */
 	if (dev->mtu > ETH_DATA_LEN && hw->chip_id == CHIP_ID_YUKON_EC_U) {
 		netdev_info(dev, "checksum offload not possible with jumbo frames\n");
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
-		netdev_feature_del(NETIF_F_SG_BIT, features);
-		netdev_features_clear(features, NETIF_F_CSUM_MASK);
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
+		netdev_feature_del(NETIF_F_SG_BIT, *features);
+		netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
-	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) &&
-	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features) &&
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) &&
 	    (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
 		netdev_info(dev, "receive hashing forces receive checksum\n");
-		netdev_feature_add(NETIF_F_RXCSUM_BIT, features);
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, *features);
 	}
-
-	return features;
 }
 
 static int sky2_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5c76433a70ab..c1236dd59f56 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2697,21 +2697,19 @@ static int mtk_hwlro_get_fdir_all(struct net_device *dev,
 	return 0;
 }
 
-static netdev_features_t mtk_fix_features(struct net_device *dev,
-					  netdev_features_t features)
+static void mtk_fix_features(struct net_device *dev,
+			     netdev_features_t *features)
 {
-	if (!netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 		struct mtk_mac *mac = netdev_priv(dev);
 		int ip_cnt = mtk_hwlro_get_ip_cnt(mac);
 
 		if (ip_cnt) {
 			netdev_info(dev, "RX flow is programmed, LRO should keep on\n");
 
-			netdev_feature_add(NETIF_F_LRO_BIT, features);
+			netdev_feature_add(NETIF_F_LRO_BIT, *features);
 		}
 	}
-
-	return features;
 }
 
 static int mtk_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 7cec4a97a3a1..3ace17bbbae0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2496,8 +2496,8 @@ static int mlx4_en_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 }
 
-static netdev_features_t mlx4_en_fix_features(struct net_device *netdev,
-					      netdev_features_t features)
+static void mlx4_en_fix_features(struct net_device *netdev,
+				 netdev_features_t *features)
 {
 	struct mlx4_en_priv *en_priv = netdev_priv(netdev);
 	struct mlx4_en_dev *mdev = en_priv->mdev;
@@ -2506,13 +2506,11 @@ static netdev_features_t mlx4_en_fix_features(struct net_device *netdev,
 	 * enable/disable make sure S-TAG flag is always in same state as
 	 * C-TAG.
 	 */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) &&
 	    !(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
-		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
+		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, *features);
 	else
-		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT, *features);
 }
 
 static int mlx4_en_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7a7679262252..d6cc33d2079b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3892,30 +3892,28 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	return 0;
 }
 
-static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev,
-						       netdev_features_t features)
+static void mlx5e_fix_uplink_rep_features(struct net_device *netdev,
+					  netdev_features_t *features)
 {
-	netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, features);
+	netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, *features);
 	if (netdev_active_feature_test(netdev, NETIF_F_HW_TLS_RX_BIT))
 		netdev_warn(netdev, "Disabling hw_tls_rx, not supported in switchdev mode\n");
 
-	netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, features);
+	netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, *features);
 	if (netdev_active_feature_test(netdev, NETIF_F_HW_TLS_TX_BIT))
 		netdev_warn(netdev, "Disabling hw_tls_tx, not supported in switchdev mode\n");
 
-	netdev_feature_del(NETIF_F_NTUPLE_BIT, features);
+	netdev_feature_del(NETIF_F_NTUPLE_BIT, *features);
 	if (netdev_active_feature_test(netdev, NETIF_F_NTUPLE_BIT))
 		netdev_warn(netdev, "Disabling ntuple, not supported in switchdev mode\n");
 
-	netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+	netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 	if (netdev_active_feature_test(netdev, NETIF_F_GRO_HW_BIT))
 		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
-
-	return features;
 }
 
-static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void mlx5e_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_vlan_table *vlan;
@@ -3929,63 +3927,61 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		/* HW strips the outer C-tag header, this is a problem
 		 * for S-tag traffic.
 		 */
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features);
 		if (!params->vlan_strip_disable)
 			netdev_warn(netdev, "Dropping C-tag vlan stripping offload due to S-tag vlan\n");
 	}
 
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
-			netdev_feature_del(NETIF_F_LRO_BIT, features);
+			netdev_feature_del(NETIF_F_LRO_BIT, *features);
 		}
-		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_warn(netdev, "Disabling HW-GRO, not supported in legacy RQ\n");
-			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 		}
 	}
 
 	if (params->xdp_prog) {
-		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 			netdev_warn(netdev, "LRO is incompatible with XDP\n");
-			netdev_feature_del(NETIF_F_LRO_BIT, features);
+			netdev_feature_del(NETIF_F_LRO_BIT, *features);
 		}
-		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_warn(netdev, "HW GRO is incompatible with XDP\n");
-			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 		}
 	}
 
 	if (priv->xsk.refcnt) {
-		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 			netdev_warn(netdev, "LRO is incompatible with AF_XDP (%u XSKs are active)\n",
 				    priv->xsk.refcnt);
-			netdev_feature_del(NETIF_F_LRO_BIT, features);
+			netdev_feature_del(NETIF_F_LRO_BIT, *features);
 		}
-		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_warn(netdev, "HW GRO is incompatible with AF_XDP (%u XSKs are active)\n",
 				    priv->xsk.refcnt);
-			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 		}
 	}
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-		netdev_feature_del(NETIF_F_RXHASH_BIT, features);
+		netdev_feature_del(NETIF_F_RXHASH_BIT, *features);
 		if (netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
 
-		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features)) {
 			netdev_warn(netdev, "Disabling HW-GRO, not supported when CQE compress is active\n");
-			netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 		}
 	}
 
 	if (mlx5e_is_uplink_rep(priv))
-		features = mlx5e_fix_uplink_rep_features(netdev, features);
+		mlx5e_fix_uplink_rep_features(netdev, features);
 
 	mutex_unlock(&priv->state_lock);
-
-	return features;
 }
 
 static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 164fbeaa1ca4..754179c46769 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1756,29 +1756,28 @@ static int nfp_net_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t
+static void
 nfp_net_fix_features(struct net_device *netdev,
-		     netdev_features_t features)
+		     netdev_features_t *features)
 {
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
-	    netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) &&
+	    netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, *features)) {
 		if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 			netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					   features);
+					   *features);
 			netdev_wanted_feature_del(netdev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 			netdev_warn(netdev,
 				    "S-tag and C-tag stripping can't be enabled at the same time. Enabling S-tag stripping and disabling C-tag stripping\n");
 		} else if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_STAG_RX_BIT)) {
 			netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT,
-					   features);
+					   *features);
 			netdev_wanted_feature_del(netdev,
 						  NETIF_F_HW_VLAN_STAG_RX_BIT);
 			netdev_warn(netdev,
 				    "S-tag and C-tag stripping can't be enabled at the same time. Enabling C-tag stripping and disabling S-tag stripping\n");
 		}
 	}
-	return features;
 }
 
 static void
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 0ab4f1b5e547..bb310a247e4b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -233,12 +233,12 @@ static int nfp_repr_open(struct net_device *netdev)
 	return err;
 }
 
-static netdev_features_t
-nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
+static void
+nfp_repr_fix_features(struct net_device *netdev, netdev_features_t *features)
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
-	netdev_features_t old_features = features;
 	netdev_features_t lower_features;
+	netdev_features_t old_features;
 	struct net_device *lower_dev;
 	netdev_features_t tmp;
 
@@ -248,14 +248,13 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	if (netdev_features_intersects(lower_features, netdev_ip_csum_features))
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, lower_features);
 
-	netdev_intersect_features(&features, &features, &lower_features);
+	netdev_features_copy(old_features, *features);
+	netdev_intersect_features(features, features, &lower_features);
 	tmp = NETIF_F_SOFT_FEATURES;
 	netdev_feature_add(NETIF_F_HW_TC_BIT, tmp);
 	netdev_features_mask(tmp, old_features);
-	netdev_features_set(features, tmp);
-	netdev_feature_add(NETIF_F_LLTX_BIT, features);
-
-	return features;
+	netdev_features_set(*features, tmp);
+	netdev_feature_add(NETIF_F_LLTX_BIT, *features);
 }
 
 const struct net_device_ops nfp_repr_netdev_ops = {
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index c6bce7f847b7..82bccdfcfa50 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4927,14 +4927,11 @@ static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
 	return retval;
 }
 
-static netdev_features_t nv_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void nv_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	/* vlan is dependent on rx checksum offload */
-	if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features))
-		netdev_feature_add(NETIF_F_RXCSUM_BIT, features);
-
-	return features;
+	if (netdev_features_intersects(*features, netdev_ctag_vlan_offload_features))
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, *features);
 }
 
 static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 15dc30e0dff5..e2af570cda6e 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -520,16 +520,14 @@ static void netxen_set_multicast_list(struct net_device *dev)
 	adapter->set_multi(dev);
 }
 
-static netdev_features_t netxen_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void netxen_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)) {
 		netdev_info(dev, "disabling LRO as RXCSUM is off\n");
 
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 	}
-
-	return features;
 }
 
 static int netxen_set_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index c1f26a2e374d..ada71452d454 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -545,8 +545,7 @@ int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid);
 void qede_vlan_mark_nonconfigured(struct qede_dev *edev);
 int qede_configure_vlan_filters(struct qede_dev *edev);
 
-netdev_features_t qede_fix_features(struct net_device *dev,
-				    netdev_features_t features);
+void qede_fix_features(struct net_device *dev, netdev_features_t *features);
 int qede_set_features(struct net_device *dev, netdev_features_t features);
 void qede_set_rx_mode(struct net_device *ndev);
 void qede_config_rx_mode(struct net_device *ndev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 4fb113d9713e..b6d6ce69929c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -910,16 +910,13 @@ static void qede_set_features_reload(struct qede_dev *edev,
 	edev->ndev->features = args->u.features;
 }
 
-netdev_features_t qede_fix_features(struct net_device *dev,
-				    netdev_features_t features)
+void qede_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
 	if (edev->xdp_prog || edev->ndev->mtu > PAGE_SIZE ||
-	    !netdev_feature_test(NETIF_F_GRO_BIT, features))
-		netdev_feature_del(NETIF_F_GRO_HW_BIT, features);
-
-	return features;
+	    !netdev_feature_test(NETIF_F_GRO_BIT, *features))
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 }
 
 int qede_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index b25102fded7b..9b41e2f5c82c 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -1622,8 +1622,8 @@ int qlcnic_82xx_read_phys_port_id(struct qlcnic_adapter *);
 int qlcnic_fw_cmd_set_mtu(struct qlcnic_adapter *adapter, int mtu);
 int qlcnic_fw_cmd_set_drv_version(struct qlcnic_adapter *, u32);
 int qlcnic_change_mtu(struct net_device *netdev, int new_mtu);
-netdev_features_t qlcnic_fix_features(struct net_device *netdev,
-	netdev_features_t features);
+void qlcnic_fix_features(struct net_device *netdev,
+			 netdev_features_t *features);
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features);
 int qlcnic_config_bridged_mode(struct qlcnic_adapter *adapter, u32 enable);
 void qlcnic_update_cmd_producer(struct qlcnic_host_tx_ring *);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index b97bbb07d06a..3efc9f294712 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1021,45 +1021,42 @@ int qlcnic_change_mtu(struct net_device *netdev, int mtu)
 	return rc;
 }
 
-static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
-					      netdev_features_t features)
+static void qlcnic_process_flags(struct qlcnic_adapter *adapter,
+				 netdev_features_t *features)
 {
 	u32 offload_flags = adapter->offload_flags;
 
 	if (offload_flags & BIT_0) {
-		netdev_features_set_set(features, NETIF_F_RXCSUM_BIT,
+		netdev_features_set_set(*features, NETIF_F_RXCSUM_BIT,
 					NETIF_F_IP_CSUM_BIT,
 					NETIF_F_IPV6_CSUM_BIT);
 		adapter->rx_csum = 1;
 		if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 			if (!(offload_flags & BIT_1))
-				netdev_feature_del(NETIF_F_TSO_BIT, features);
+				netdev_feature_del(NETIF_F_TSO_BIT, *features);
 			else
-				netdev_feature_add(NETIF_F_TSO_BIT, features);
+				netdev_feature_add(NETIF_F_TSO_BIT, *features);
 
 			if (!(offload_flags & BIT_2))
 				netdev_feature_del(NETIF_F_TSO6_BIT,
-						   features);
+						   *features);
 			else
 				netdev_feature_add(NETIF_F_TSO6_BIT,
-						   features);
+						   *features);
 		}
 	} else {
-		netdev_features_clear_set(features, NETIF_F_RXCSUM_BIT,
+		netdev_features_clear_set(*features, NETIF_F_RXCSUM_BIT,
 					  NETIF_F_IP_CSUM_BIT,
 					  NETIF_F_IPV6_CSUM_BIT);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
-			netdev_features_clear(features,
+			netdev_features_clear(*features,
 					      netdev_general_tso_features);
 		adapter->rx_csum = 0;
 	}
-
-	return features;
 }
 
-netdev_features_t qlcnic_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changeable;
@@ -1068,10 +1065,10 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 	if (qlcnic_82xx_check(adapter) &&
 	    (adapter->flags & QLCNIC_ESWITCH_ENABLED)) {
 		if (adapter->flags & QLCNIC_APP_CHANGED_FLAGS) {
-			features = qlcnic_process_flags(adapter, features);
+			qlcnic_process_flags(adapter, features);
 		} else {
 			netdev_features_xor(changed, netdev->features,
-					    features);
+					    *features);
 			netdev_features_zero(changeable);
 			netdev_features_set_set(changeable,
 						NETIF_F_RXCSUM_BIT,
@@ -1080,14 +1077,12 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 						NETIF_F_TSO_BIT,
 						NETIF_F_TSO6_BIT);
 			netdev_features_mask(changed, changeable);
-			netdev_features_toggle(features, changed);
+			netdev_features_toggle(*features, changed);
 		}
 	}
 
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
-
-	return features;
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 }
 
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7434f3c06dc6..7f1dd10b6387 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1422,21 +1422,19 @@ static int rtl8169_get_regs_len(struct net_device *dev)
 	return R8169_REGS_SIZE;
 }
 
-static netdev_features_t rtl8169_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void rtl8169_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (dev->mtu > TD_MSS_MAX)
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 
 	if (dev->mtu > ETH_DATA_LEN &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06) {
-		netdev_features_clear(features, NETIF_F_CSUM_MASK);
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
+		netdev_features_clear(*features, NETIF_F_CSUM_MASK);
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 	}
-
-	return features;
 }
 
 static void rtl_set_rx_config_features(struct rtl8169_private *tp,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 05dc3483757d..c70f297c1653 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5585,16 +5585,16 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static netdev_features_t stmmac_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void stmmac_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	if (priv->plat->rx_coe == STMMAC_RX_COE_NONE)
-		netdev_feature_del(NETIF_F_RXCSUM_BIT, features);
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, *features);
 
 	if (!priv->plat->tx_coe)
-		netdev_features_clear(features, NETIF_F_CSUM_MASK);
+		netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 
 	/* Some GMAC devices have a bugged Jumbo frame support that
 	 * needs to have the Tx COE disabled for oversized frames
@@ -5602,17 +5602,15 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 	 * the TX csum insertion in the TDES and not use SF.
 	 */
 	if (priv->plat->bugged_jumbo && (dev->mtu > ETH_DATA_LEN))
-		netdev_features_clear(features, NETIF_F_CSUM_MASK);
+		netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 
 	/* Disable tso if asked by ethtool */
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		if (netdev_feature_test(NETIF_F_TSO_BIT, features))
+		if (netdev_feature_test(NETIF_F_TSO_BIT, *features))
 			priv->tso = true;
 		else
 			priv->tso = false;
 	}
-
-	return features;
 }
 
 static int stmmac_set_features(struct net_device *netdev,
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 98e2b649fabf..e89fcfc52247 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1904,21 +1904,19 @@ static int netvsc_set_ringparam(struct net_device *ndev,
 	return ret;
 }
 
-static netdev_features_t netvsc_fix_features(struct net_device *ndev,
-					     netdev_features_t features)
+static void netvsc_fix_features(struct net_device *ndev,
+				netdev_features_t *features)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
 
 	if (!nvdev || nvdev->destroy)
-		return features;
+		return;
 
-	if (netdev_feature_test(NETIF_F_LRO_BIT, features) && netvsc_xdp_get(nvdev)) {
-		netdev_feature_change(NETIF_F_LRO_BIT, features);
+	if (netdev_feature_test(NETIF_F_LRO_BIT, *features) && netvsc_xdp_get(nvdev)) {
+		netdev_feature_change(NETIF_F_LRO_BIT, *features);
 		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
 	}
-
-	return features;
 }
 
 static int netvsc_set_features(struct net_device *ndev,
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index e7737e7938fd..31d5e203e035 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -227,24 +227,22 @@ static netdev_tx_t ipvlan_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-static netdev_features_t ipvlan_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void ipvlan_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 	netdev_features_t tmp;
 
-	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
+	netdev_features_set(*features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(tmp);
 	netdev_features_clear(tmp, IPVLAN_FEATURES);
 	netdev_features_set(tmp, ipvlan->sfeatures);
-	netdev_features_mask(features, tmp);
-	netdev_increment_features(&features, &ipvlan->phy_dev->features,
-				  &features, &features);
-	netdev_features_set(features, IPVLAN_ALWAYS_ON);
+	netdev_features_mask(*features, tmp);
+	netdev_increment_features(features, &ipvlan->phy_dev->features,
+				  features, features);
+	netdev_features_set(*features, IPVLAN_ALWAYS_ON);
 	netdev_features_or(tmp, IPVLAN_FEATURES, IPVLAN_ALWAYS_ON);
-	netdev_features_mask(features, tmp);
-
-	return features;
+	netdev_features_mask(*features, tmp);
 }
 
 static void ipvlan_change_rx_flags(struct net_device *dev, int change)
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b5d263c6469f..513e1ff7a2a0 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3512,26 +3512,24 @@ static void macsec_dev_uninit(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-static netdev_features_t macsec_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void macsec_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 	netdev_features_t tmp;
 
 	if (macsec_is_offloaded(macsec)) {
-		macsec_real_dev_features(real_dev, &tmp);
-		return tmp;
+		macsec_real_dev_features(real_dev, features);
+		return;
 	}
 
 	netdev_features_and(tmp, real_dev->features, SW_MACSEC_FEATURES);
 	netdev_features_set(tmp, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set(tmp, NETIF_F_SOFT_FEATURES);
 
-	netdev_features_mask(features, tmp);
-	netdev_feature_add(NETIF_F_LLTX_BIT, features);
-
-	return features;
+	netdev_features_mask(*features, tmp);
+	netdev_feature_add(NETIF_F_LLTX_BIT, *features);
 }
 
 static int macsec_dev_open(struct net_device *dev)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 1e357643fd43..21071335c0ac 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1073,31 +1073,29 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 	return 0;
 }
 
-static netdev_features_t macvlan_fix_features(struct net_device *dev,
-					      netdev_features_t features)
+static void macvlan_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	netdev_features_t lowerdev_features = vlan->lowerdev->features;
 	netdev_features_t mask;
 	netdev_features_t tmp;
 
-	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
+	netdev_features_set(*features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(tmp);
 	netdev_features_clear(tmp, MACVLAN_FEATURES);
 	netdev_features_set(tmp, vlan->set_features);
-	netdev_features_mask(features, tmp);
-	mask = features;
+	netdev_features_mask(*features, tmp);
+	netdev_features_copy(mask, *features);
 
-	tmp = features;
+	netdev_features_copy(tmp, *features);
 	netdev_feature_del(NETIF_F_LRO_BIT, tmp);
 	netdev_features_mask(lowerdev_features, tmp);
-	netdev_increment_features(&features, &lowerdev_features, &features,
+	netdev_increment_features(features, &lowerdev_features, features,
 				  &mask);
-	netdev_features_set(features, ALWAYS_ON_FEATURES);
+	netdev_features_set(*features, ALWAYS_ON_FEATURES);
 	netdev_features_or(tmp, ALWAYS_ON_FEATURES, MACVLAN_FEATURES);
-	netdev_features_mask(features, tmp);
-
-	return features;
+	netdev_features_mask(*features, tmp);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 508424471c28..1f9642b400ec 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2000,27 +2000,25 @@ static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 	return err;
 }
 
-static netdev_features_t team_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void team_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct team_port *port;
 	struct team *team = netdev_priv(dev);
 	netdev_features_t mask;
 
-	mask = features;
-	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
-	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
+	netdev_features_copy(mask, *features);
+	netdev_features_clear(*features, NETIF_F_ONE_FOR_ALL);
+	netdev_features_set(*features, NETIF_F_ALL_FOR_ALL);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		netdev_increment_features(&features, &features,
+		netdev_increment_features(features, features,
 					  &port->dev->features, &mask);
 	}
 	rcu_read_unlock();
 
-	netdev_add_tso_features(&features, &mask);
-
-	return features;
+	netdev_add_tso_features(features, &mask);
 }
 
 static int team_change_carrier(struct net_device *dev, bool new_carrier)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index b9bc7ff7c283..d2e6bfb5edd4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1165,15 +1165,15 @@ static void tun_net_mclist(struct net_device *dev)
 	 */
 }
 
-static netdev_features_t tun_net_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void tun_net_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	netdev_features_t tmp1, tmp2;
 
-	netdev_features_and(tmp1, features, tun->set_features);
-	netdev_features_andnot(tmp2, features, TUN_USER_FEATURES);
-	return tmp1 | tmp2;
+	netdev_features_and(tmp1, *features, tun->set_features);
+	netdev_features_andnot(tmp2, *features, TUN_USER_FEATURES);
+	netdev_features_or(*features, tmp1, tmp2);
 }
 
 static void tun_set_headroom(struct net_device *dev, int new_hr)
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0e5bfe2ebfd2..ac7a6ebadf00 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1449,8 +1449,8 @@ static int veth_get_iflink(const struct net_device *dev)
 	return iflink;
 }
 
-static netdev_features_t veth_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void veth_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
@@ -1460,12 +1460,10 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 		struct veth_priv *peer_priv = netdev_priv(peer);
 
 		if (peer_priv->_xdp_prog)
-			netdev_features_clear(features, NETIF_F_GSO_SOFTWARE);
+			netdev_features_clear(*features, NETIF_F_GSO_SOFTWARE);
 	}
 	if (priv->_xdp_prog)
-		netdev_feature_add(NETIF_F_GRO_BIT, features);
-
-	return features;
+		netdev_feature_add(NETIF_F_GRO_BIT, *features);
 }
 
 static int veth_set_features(struct net_device *dev,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 9b7adc83c210..6f6338a22c31 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -246,14 +246,12 @@ vmxnet3_get_strings(struct net_device *netdev, u32 stringset, u8 *buf)
 		ethtool_sprintf(&buf, vmxnet3_global_stats[i].desc);
 }
 
-netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
-				       netdev_features_t features)
+void vmxnet3_fix_features(struct net_device *netdev,
+			  netdev_features_t *features)
 {
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
-		netdev_feature_del(NETIF_F_LRO_BIT, features);
-
-	return features;
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 }
 
 void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 4fe7be614c05..c9aac6a8e65c 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -491,8 +491,8 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
 void
 vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 
-netdev_features_t
-vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
+void
+vmxnet3_fix_features(struct net_device *netdev, netdev_features_t *features);
 
 void
 vmxnet3_features_check(struct sk_buff *skb,
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 0de51ba7bed3..62677a757409 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -360,23 +360,21 @@ static int xenvif_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 }
 
-static netdev_features_t xenvif_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void xenvif_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct xenvif *vif = netdev_priv(dev);
 
 	if (!vif->can_sg)
-		netdev_feature_del(NETIF_F_SG_BIT, features);
+		netdev_feature_del(NETIF_F_SG_BIT, *features);
 	if (~(vif->gso_mask) & GSO_BIT(TCPV4))
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 	if (~(vif->gso_mask) & GSO_BIT(TCPV6))
-		netdev_feature_del(NETIF_F_TSO6_BIT, features);
+		netdev_feature_del(NETIF_F_TSO6_BIT, *features);
 	if (!vif->ip_csum)
-		netdev_feature_del(NETIF_F_IP_CSUM_BIT, features);
+		netdev_feature_del(NETIF_F_IP_CSUM_BIT, *features);
 	if (!vif->ipv6_csum)
-		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, *features);
 }
 
 static const struct xenvif_stat {
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index fedbd35aa1c1..f83a5e3c6de9 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1471,29 +1471,27 @@ static void xennet_release_rx_bufs(struct netfront_queue *queue)
 	spin_unlock_bh(&queue->rx_lock);
 }
 
-static netdev_features_t xennet_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void xennet_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct netfront_info *np = netdev_priv(dev);
 
-	if (netdev_feature_test(NETIF_F_SG_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_SG_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-sg", 0))
-		netdev_feature_del(NETIF_F_SG_BIT, features);
+		netdev_feature_del(NETIF_F_SG_BIT, *features);
 
-	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend,
 				  "feature-ipv6-csum-offload", 0))
-		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, features);
+		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, *features);
 
-	if (netdev_feature_test(NETIF_F_TSO_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_TSO_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv4", 0))
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 
-	if (netdev_feature_test(NETIF_F_TSO6_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv6", 0))
-		netdev_feature_del(NETIF_F_TSO6_BIT, features);
-
-	return features;
+		netdev_feature_del(NETIF_F_TSO6_BIT, *features);
 }
 
 static int xennet_set_features(struct net_device *dev,
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 3015edb0ac66..6214f7f0d5ae 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1087,7 +1087,7 @@ int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
 int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
 int qeth_set_features(struct net_device *, netdev_features_t);
 void qeth_enable_hw_features(struct net_device *dev);
-netdev_features_t qeth_fix_features(struct net_device *, netdev_features_t);
+void qeth_fix_features(struct net_device *, netdev_features_t *);
 void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 			 netdev_features_t *features);
 void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9bed9ba8f6c4..31326e81344f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6850,26 +6850,24 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 }
 EXPORT_SYMBOL_GPL(qeth_set_features);
 
-netdev_features_t qeth_fix_features(struct net_device *dev,
-				    netdev_features_t features)
+void qeth_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct qeth_card *card = dev->ml_priv;
 
 	QETH_CARD_TEXT(card, 2, "fixfeat");
 	if (!qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM))
-		netdev_feature_del(NETIF_F_IP_CSUM_BIT, features);
+		netdev_feature_del(NETIF_F_IP_CSUM_BIT, *features);
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6))
-		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, features);
+		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, *features);
 	if (!qeth_is_supported(card, IPA_INBOUND_CHECKSUM) &&
 	    !qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6))
-		netdev_feature_del(NETIF_F_RXCSUM_BIT, features);
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, *features);
 	if (!qeth_is_supported(card, IPA_OUTBOUND_TSO))
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_TSO))
-		netdev_feature_del(NETIF_F_TSO6_BIT, features);
+		netdev_feature_del(NETIF_F_TSO6_BIT, *features);
 
-	QETH_CARD_HEX(card, 2, &features, sizeof(features));
-	return features;
+	QETH_CARD_HEX(card, 2, features, sizeof(*features));
 }
 EXPORT_SYMBOL_GPL(qeth_fix_features);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 78b0c501a24a..63e97effa858 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1514,8 +1514,8 @@ struct net_device_ops {
 						      bool all_slaves);
 	struct net_device*	(*ndo_sk_get_lower_dev)(struct net_device *dev,
 							struct sock *sk);
-	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
-						    netdev_features_t features);
+	void			(*ndo_fix_features)(struct net_device *dev,
+						    netdev_features_t *features);
 	int			(*ndo_set_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_neigh_construct)(struct net_device *dev,
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index d03348e29f36..2fa0b4ea260b 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -645,30 +645,29 @@ static void vlan_dev_uninit(struct net_device *dev)
 	vlan_dev_free_egress_priority(dev);
 }
 
-static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void vlan_dev_fix_features(struct net_device *dev,
+				  netdev_features_t *features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	netdev_features_t old_features = features;
 	netdev_features_t lower_features;
+	netdev_features_t old_features;
 	netdev_features_t tmp;
 
 	tmp = real_dev->vlan_features;
 	netdev_feature_add(NETIF_F_RXCSUM_BIT, tmp);
 	netdev_intersect_features(&lower_features, &tmp, &real_dev->features);
 
+	netdev_features_copy(old_features, *features);
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
 	if (netdev_features_intersects(lower_features, netdev_ip_csum_features))
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, lower_features);
-	netdev_intersect_features(&features, &features, &lower_features);
+	netdev_intersect_features(features, features, &lower_features);
 	netdev_features_or(tmp, NETIF_F_SOFT_FEATURES, NETIF_F_GSO_SOFTWARE);
 	netdev_features_mask(tmp, old_features);
-	netdev_features_set(features, tmp);
-	netdev_feature_add(NETIF_F_LLTX_BIT, features);
-
-	return features;
+	netdev_features_set(*features, tmp);
+	netdev_feature_add(NETIF_F_LLTX_BIT, *features);
 }
 
 static int vlan_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index f1d851deb536..fafcc67ca3bc 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -286,12 +286,11 @@ static int br_get_link_ksettings(struct net_device *dev,
 	return 0;
 }
 
-static netdev_features_t br_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void br_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct net_bridge *br = netdev_priv(dev);
 
-	return br_features_recompute(br, features);
+	br_features_recompute(br, features);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 2a9b564ff234..a971650b52e4 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -532,25 +532,22 @@ static void br_set_gso_limits(struct net_bridge *br)
 /*
  * Recomputes features using slave's features
  */
-netdev_features_t br_features_recompute(struct net_bridge *br,
-	netdev_features_t features)
+void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
 {
 	struct net_bridge_port *p;
 	netdev_features_t mask;
 
 	if (list_empty(&br->port_list))
-		return features;
+		return;
 
-	mask = features;
-	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
+	netdev_features_copy(mask, *features);
+	netdev_features_clear(*features, NETIF_F_ONE_FOR_ALL);
 
 	list_for_each_entry(p, &br->port_list, list) {
-		netdev_increment_features(&features, &features,
+		netdev_increment_features(features, features,
 					  &p->dev->features, &mask);
 	}
-	netdev_add_tso_features(&features, &mask);
-
-	return features;
+	netdev_add_tso_features(features, &mask);
 }
 
 /* called with RTNL */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06e5f6faa431..e6ccd246c325 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -846,8 +846,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	      struct netlink_ext_ack *extack);
 int br_del_if(struct net_bridge *br, struct net_device *dev);
 void br_mtu_auto_adjust(struct net_bridge *br);
-netdev_features_t br_features_recompute(struct net_bridge *br,
-					netdev_features_t features);
+void br_features_recompute(struct net_bridge *br, netdev_features_t *features);
 void br_port_flags_change(struct net_bridge_port *port, unsigned long mask);
 void br_manage_promisc(struct net_bridge *br);
 int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 5e84fdc8c7f5..0d5df1d4f712 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9716,7 +9716,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_get_wanted_features(dev, &features);
 
 	if (dev->netdev_ops->ndo_fix_features)
-		features = dev->netdev_ops->ndo_fix_features(dev, features);
+		dev->netdev_ops->ndo_fix_features(dev, &features);
 
 	/* driver might be less strict about feature dependencies */
 	netdev_fix_features(dev, &features);
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ae0261a450e6..7d89d3a72e54 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -178,13 +178,13 @@ static int hsr_dev_close(struct net_device *dev)
 	return 0;
 }
 
-static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
-						netdev_features_t features)
+static void hsr_features_recompute(struct hsr_priv *hsr,
+				   netdev_features_t *features)
 {
 	netdev_features_t mask;
 	struct hsr_port *port;
 
-	mask = features;
+	netdev_features_copy(mask, *features);
 
 	/* Mask out all features that, if supported by one device, should be
 	 * enabled for all devices (see NETIF_F_ONE_FOR_ALL).
@@ -193,20 +193,18 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 * that were in features originally, and also is in NETIF_F_ONE_FOR_ALL,
 	 * may become enabled.
 	 */
-	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
+	netdev_features_clear(*features, NETIF_F_ONE_FOR_ALL);
 	hsr_for_each_port(hsr, port)
-		netdev_increment_features(&features, &features,
+		netdev_increment_features(features, features,
 					  &port->dev->features, &mask);
-
-	return features;
 }
 
-static netdev_features_t hsr_fix_features(struct net_device *dev,
-					  netdev_features_t features)
+static void hsr_fix_features(struct net_device *dev,
+			     netdev_features_t *features)
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
 
-	return hsr_features_recompute(hsr, features);
+	hsr_features_recompute(hsr, features);
 }
 
 static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
2.33.0

