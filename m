Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9948A58E568
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiHJDOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiHJDN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BF981B23
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgy3rRCzjXk1;
        Wed, 10 Aug 2022 11:10:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 34/36] treewide: use netdev_features_equal helpers
Date:   Wed, 10 Aug 2022 11:06:22 +0800
Message-ID: <20220810030624.34711-35-shenjian15@huawei.com>
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

Replace the '==' and '!=' expressions of features by
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
index 6b2ee76666bf..f329add7698e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11199,7 +11199,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	 * turned on or off together.
 	 */
 	vlan_features = netdev_features_and(features, BNXT_HW_FEATURE_VLAN_ALL_RX);
-	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
+	if (!netdev_features_equal(vlan_features, BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		if (netdev_active_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
 			netdev_features_clear(&features,
 					      BNXT_HW_FEATURE_VLAN_ALL_RX);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 95016982f03b..7f7d344addf5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4895,7 +4895,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	if (adapter->state == VNIC_PROBING) {
 		netdev_active_features_set(adapter->netdev,
 					   adapter->netdev->hw_features);
-	} else if (old_hw_features != adapter->netdev->hw_features) {
+	} else if (!netdev_hw_features_equal(adapter->netdev, old_hw_features)) {
 		netdev_features_t tmp = netdev_empty_features;
 
 		/* disable features no longer supported */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 19a0e82d45ae..ae4ff4e3720f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5792,7 +5792,7 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	req_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 				       req_vlan_fltr);
 
-	if (req_vlan_fltr != cur_vlan_fltr) {
+	if (netdev_features_equal(req_vlan_fltr, cur_vlan_fltr)) {
 		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
 			if (req_ctag && req_stag) {
 				netdev_features_set(&features,
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index fdde83bef88e..737290635ff5 100644
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
index 60f2152ec755..178c719e79ea 100644
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
index 7eaa2fe9dc13..1fd27d37debf 100644
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
index 99f7ad47dc19..46d191c93137 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6665,7 +6665,7 @@ static int qeth_set_csum_on(struct qeth_card *card, enum qeth_ipa_funcs cstype,
 	if (rc)
 		return rc;
 
-	if ((required_features & features) != required_features) {
+	if (!netdev_features_subset(features, required_features)) {
 		qeth_set_csum_off(card, cstype, prot);
 		return -EOPNOTSUPP;
 	}
@@ -6831,7 +6831,7 @@ void qeth_enable_hw_features(struct net_device *dev)
 					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 	netdev_update_features(dev);
-	if (features != dev->features)
+	if (!netdev_active_features_equal(dev, features))
 		dev_warn(&card->gdev->dev,
 			 "Device recovery failed to restore all offload features\n");
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 01340e889e72..2d6aed5a3a4f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9735,7 +9735,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		features = netdev_sync_upper_features(dev, upper, features);
 
-	if (dev->features == features)
+	if (netdev_active_features_equal(dev, features))
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9bca8eb4f1c9..78a276f34929 100644
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

