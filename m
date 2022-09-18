Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B405BBD11
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiIRJvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiIRJuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:20 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76A613E8E
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjfB1t0lzHnhd;
        Sun, 18 Sep 2022 17:47:46 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:52 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 34/55] treewide: use netdev_features_equal helpers
Date:   Sun, 18 Sep 2022 09:43:15 +0000
Message-ID: <20220918094336.28958-35-shenjian15@huawei.com>
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

Replace the 'f1 == f2' and 'f1 != f2' features expressions by
netdev_features_equal helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c   | 2 +-
 drivers/net/ethernet/ibm/ibmvnic.c          | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c   | 2 +-
 drivers/net/ethernet/sfc/efx_common.c       | 2 +-
 drivers/net/ethernet/sfc/falcon/efx.c       | 2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c | 2 +-
 drivers/s390/net/qeth_core_main.c           | 4 ++--
 net/core/dev.c                              | 2 +-
 net/ethtool/ioctl.c                         | 2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ce886feeefdc..27a45adb7672 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11194,7 +11194,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	 */
 	netdev_features_and(vlan_features, features,
 			    BNXT_HW_FEATURE_VLAN_ALL_RX);
-	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
+	if (!netdev_features_equal(vlan_features, BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		if (netdev_active_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
 			netdev_features_clear(features,
 					      BNXT_HW_FEATURE_VLAN_ALL_RX);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9c6fb5e21cb4..6f84086ddfe2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4892,7 +4892,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	if (adapter->state == VNIC_PROBING) {
 		netdev_active_features_set(adapter->netdev,
 					   adapter->netdev->hw_features);
-	} else if (old_hw_features != adapter->netdev->hw_features) {
+	} else if (!netdev_hw_features_equal(adapter->netdev, old_hw_features)) {
 		netdev_features_t tmp;
 
 		netdev_features_zero(tmp);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ec148c43c130..d52775c16a81 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5834,7 +5834,7 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	req_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 				       req_vlan_fltr);
 
-	if (req_vlan_fltr != cur_vlan_fltr) {
+	if (!netdev_features_equal(req_vlan_fltr, cur_vlan_fltr)) {
 		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
 			if (req_ctag && req_stag) {
 				netdev_features_set(features,
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 8e6a86be924e..9a52492f3f06 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -417,7 +417,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
-	if (efx->net_dev->features != old_features)
+	if (!netdev_active_features_equal(efx->net_dev, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 8b37fc2e134e..232e8fde0a81 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -638,7 +638,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
-	if (efx->net_dev->features != old_features)
+	if (!netdev_active_features_equal(efx->net_dev, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index dcbb23a71c4d..5360c6d6c026 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -416,7 +416,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
-	if (efx->net_dev->features != old_features)
+	if (!netdev_active_features_equal(efx->net_dev, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index c7c0b8853452..72c487009c33 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6757,7 +6757,7 @@ void qeth_enable_hw_features(struct net_device *dev)
 					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 	netdev_update_features(dev);
-	if (features != dev->features)
+	if (!netdev_active_features_equal(dev, features))
 		dev_warn(&card->gdev->dev,
 			 "Device recovery failed to restore all offload features\n");
 }
@@ -6842,7 +6842,7 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 	qeth_check_restricted_features(card, diff1, diff2);
 
 	/* everything changed successfully? */
-	if (diff1 == changed)
+	if (netdev_features_equal(diff1, changed))
 		return 0;
 	/* something went wrong. save changed features and return error */
 	netdev_active_features_toggle(dev, changed);
diff --git a/net/core/dev.c b/net/core/dev.c
index 8d1dc83182a2..f790f1986dd3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9741,7 +9741,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		features = netdev_sync_upper_features(dev, upper, features);
 
-	if (dev->features == features)
+	if (netdev_active_features_equal(dev, features))
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index a094c9e14d3d..e3897766781f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -3033,7 +3033,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	if (dev->ethtool_ops->complete)
 		dev->ethtool_ops->complete(dev);
 
-	if (old_features != dev->features)
+	if (!netdev_active_features_equal(dev, old_features))
 		netdev_features_change(dev);
 out:
 	if (dev->dev.parent)
-- 
2.33.0

