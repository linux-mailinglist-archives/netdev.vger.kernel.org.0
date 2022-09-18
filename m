Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316125BBD0C
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiIRJu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiIRJt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFBC13E07
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:55 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjbF4M45zMmy2;
        Sun, 18 Sep 2022 17:45:13 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:52 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 35/55] treewide: use netdev_features_empty helpers
Date:   Sun, 18 Sep 2022 09:43:16 +0000
Message-ID: <20220918094336.28958-36-shenjian15@huawei.com>
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

Replace the empty checking expressions of features by
netdev_features_empty helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c       | 4 ++--
 net/ethtool/ioctl.c                             | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 1095cfb0783a..53b6ed00e124 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4965,7 +4965,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 	/* Don't care about GRO changes */
 	netdev_feature_del(NETIF_F_GRO_BIT, changes);
 
-	if (changes)
+	if (!netdev_features_empty(changes))
 		bnx2x_reload = true;
 
 	if (bnx2x_reload) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 27a45adb7672..e8ccccb07045 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11198,7 +11198,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 		if (netdev_active_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
 			netdev_features_clear(features,
 					      BNXT_HW_FEATURE_VLAN_ALL_RX);
-		else if (vlan_features)
+		else if (!netdev_features_empty(vlan_features))
 			netdev_features_set(features,
 					    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 955f9f8ce66e..2cc85f1a81df 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4825,7 +4825,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	/* Do not turn on offloads when they are requested to be turned off.
 	 * TSO needs minimum 576 bytes to work correctly.
 	 */
-	if (netdev->wanted_features) {
+	if (!netdev_wanted_features_empty(netdev)) {
 		if (!netdev_wanted_feature_test(netdev, NETIF_F_TSO_BIT) ||
 		    netdev->mtu < 576)
 			netdev_active_feature_del(netdev, NETIF_F_TSO_BIT);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d52775c16a81..b69357c220d9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5974,7 +5974,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 			    NETIF_VLAN_OFFLOAD_FEATURES);
 	netdev_features_xor(diff, current_vlan_features,
 			    requested_vlan_features);
-	if (diff) {
+	if (!netdev_features_empty(diff)) {
 		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features) &&
 		    netdev_features_intersects(features,
 					       NETIF_VLAN_STRIPPING_FEATURES)) {
@@ -5994,7 +5994,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 			    NETIF_VLAN_FILTERING_FEATURES);
 	netdev_features_xor(diff, current_vlan_features,
 			    requested_vlan_features);
-	if (diff) {
+	if (!netdev_features_empty(diff)) {
 		err = ice_set_vlan_filtering_features(vsi, features);
 		if (err)
 			return err;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e3897766781f..c4154666e82a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -293,7 +293,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 
 	mask = ethtool_get_feature_mask(ethcmd);
 	netdev_features_mask(mask, dev->hw_features);
-	if (!mask)
+	if (netdev_features_empty(mask))
 		return -EOPNOTSUPP;
 
 	if (edata.data)
@@ -359,7 +359,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	netdev_features_xor(changed, dev->features, features);
 	netdev_features_mask(changed, eth_all_features);
 	netdev_features_andnot(tmp, changed, dev->hw_features);
-	if (tmp)
+	if (!netdev_features_empty(tmp))
 		return netdev_hw_features_intersects(dev, changed) ?
 			-EINVAL : -EOPNOTSUPP;
 
-- 
2.33.0

