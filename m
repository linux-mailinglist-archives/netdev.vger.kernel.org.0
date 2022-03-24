Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF44E6661
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351461AbiCXP5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351447AbiCXP4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:52 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA79AD113
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:12 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPV9p0tgNzCrHm;
        Thu, 24 Mar 2022 23:53:02 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 18/20] net: use netdev_set_xxx_features helpers
Date:   Thu, 24 Mar 2022 23:49:30 +0800
Message-ID: <20220324154932.17557-19-shenjian15@huawei.com>
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

Replace the direct assignment for features members of netdev
with netdev_set_xxx_features helpers, for the nic drivers are
not supposed to modify netdev_features directly

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  2 +-
 drivers/net/ethernet/sfc/ef10.c                 |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c           |  4 ++--
 net/core/dev.c                                  | 11 ++++++-----
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a1a6accf8867..1a98e08f0a67 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2443,7 +2443,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	netdev->active_features = features;
+	netdev_set_active_features(netdev, features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 1a92dd1a0462..c07650368952 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1375,7 +1375,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		netdev_active_features_direct_or(efx->net_dev,
 						 encap_tso_features);
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
+	netdev_set_hw_enc_features(efx->net_dev, hw_enc_features);
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 22ea294a39fa..24993c979312 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2924,8 +2924,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
 				       ARRAY_SIZE(efx_vlan_features_array));
-	net_dev->hw_features = netdev_active_features_andnot(net_dev,
-							     efx->fixed_features);
+	netdev_set_hw_features(net_dev,
+			       netdev_active_features_andnot(net_dev, efx->fixed_features));
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
diff --git a/net/core/dev.c b/net/core/dev.c
index 57409f97feb1..62bfe12b69d9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9655,7 +9655,7 @@ int __netdev_update_features(struct net_device *dev)
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
 			if (netdev_features_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, features)) {
-				dev->active_features = features;
+				netdev_set_active_features(dev, features);
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
@@ -9664,7 +9664,7 @@ int __netdev_update_features(struct net_device *dev)
 
 		if (netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
 			if (netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
-				dev->active_features = features;
+				netdev_set_active_features(dev, features);
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
@@ -9673,14 +9673,14 @@ int __netdev_update_features(struct net_device *dev)
 
 		if (netdev_features_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
 			if (netdev_features_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, features)) {
-				dev->active_features = features;
+				netdev_set_active_features(dev, features);
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		dev->active_features = features;
+		netdev_set_active_features(dev, features);
 	}
 
 	return err < 0 ? 0 : 1;
@@ -9935,7 +9935,8 @@ int register_netdevice(struct net_device *dev)
 					   NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
-	dev->wanted_features = netdev_active_features_and(dev, dev->hw_enc_features);
+	netdev_set_wanted_features(dev,
+				   netdev_active_features_and(dev, dev->hw_enc_features));
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		netdev_hw_features_set_bit(dev, NETIF_F_NOCACHE_COPY_BIT);
-- 
2.33.0

