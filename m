Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1621506218
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344781AbiDSCbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344728AbiDSCa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD682E9D5
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Kj7413QF4z1GCZY;
        Tue, 19 Apr 2022 10:27:13 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 17/19] net: use netdev_features_copy helpers
Date:   Tue, 19 Apr 2022 10:22:04 +0800
Message-ID: <20220419022206.36381-18-shenjian15@huawei.com>
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

Replace the direct assignment for features members of netdev
with netdev_features_copy helpers, for the nic drivers are
not supposed to modify netdev_features directly

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  2 +-
 drivers/net/ethernet/sfc/ef10.c                 |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c           |  4 ++--
 net/core/dev.c                                  | 12 ++++++------
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f872a624faad..06384ec2ac82 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2454,7 +2454,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	netdev->features = features;
+	netdev_active_features_copy(netdev, features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index bf8274c03176..b718dfae9389 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1371,7 +1371,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		netdev_feature_add(NETIF_F_TSO_BIT, &hw_enc_features);
 		netdev_active_features_set(efx->net_dev, encap_tso_features);
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
+	netdev_hw_enc_features_copy(efx->net_dev, hw_enc_features);
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 0bbe83f661d1..4fc2f06b2781 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2920,8 +2920,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
-	net_dev->hw_features = netdev_active_features_andnot(net_dev,
-							     efx->fixed_features);
+	netdev_hw_features_copy(net_dev,
+				netdev_active_features_andnot(net_dev, efx->fixed_features));
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
diff --git a/net/core/dev.c b/net/core/dev.c
index c59f50898444..c7505f126318 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9675,7 +9675,7 @@ int __netdev_update_features(struct net_device *dev)
 			 */
 			if (netdev_feature_test(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
 						features)) {
-				dev->features = features;
+				netdev_active_features_copy(dev, features);
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
@@ -9685,7 +9685,7 @@ int __netdev_update_features(struct net_device *dev)
 		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
 			if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 						features)) {
-				dev->features = features;
+				netdev_active_features_copy(dev, features);
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
@@ -9695,14 +9695,14 @@ int __netdev_update_features(struct net_device *dev)
 		if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
 			if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 						features)) {
-				dev->features = features;
+				netdev_active_features_copy(dev, features);
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		dev->features = features;
+		netdev_active_features_copy(dev, features);
 	}
 
 	return err < 0 ? 0 : 1;
@@ -9955,8 +9955,8 @@ int register_netdevice(struct net_device *dev)
 		netdev_hw_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
-	dev->wanted_features = netdev_active_features_and(dev,
-							  dev->hw_features);
+	netdev_wanted_features_copy(dev,
+				    netdev_active_features_and(dev, dev->hw_features));
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		netdev_hw_feature_add(dev, NETIF_F_NOCACHE_COPY_BIT);
-- 
2.33.0

