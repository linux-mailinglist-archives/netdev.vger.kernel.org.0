Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661A24E666E
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351433AbiCXP5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351434AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86910AD102
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KPVBR3pr2zfZM8;
        Thu, 24 Mar 2022 23:53:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:09 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 14/20] net: use netdev_features_intersects helpers
Date:   Thu, 24 Mar 2022 23:49:26 +0800
Message-ID: <20220324154932.17557-15-shenjian15@huawei.com>
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

Replace the '(f1 & f2)' operations of features by
netdev_features_intersects helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/sfc/efx_common.c |  4 ++--
 net/core/dev.c                        | 20 +++++++++++---------
 net/ethtool/ioctl.c                   |  6 +++---
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 94a3884f016e..d2874aad3ce7 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1365,7 +1365,7 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 	struct efx_nic *efx = netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (features & NETIF_F_GSO_MASK)
+		if (netdev_features_intersects(features, NETIF_F_GSO_MASK))
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
@@ -1373,7 +1373,7 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			    EFX_TSO2_MAX_HDRLEN)
 				netdev_features_direct_andnot(&features,
 							      NETIF_F_GSO_MASK);
-		if (features & netdev_csum_gso_features_mask)
+		if (netdev_features_intersects(features, netdev_csum_gso_features_mask))
 			if (!efx_can_encap_offloads(efx, skb))
 				netdev_features_direct_andnot(&features,
 							      netdev_csum_gso_features_mask);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4bb40175e38a..5e92261a047a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3578,7 +3578,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features))
 		return 0;
 
-	if (features & netdev_ip_csum_features) {
+	if (netdev_features_intersects(features, netdev_ip_csum_features)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -9437,8 +9437,8 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	upper_disables = NETIF_F_UPPER_DISABLES;
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		feature = __NETIF_F_BIT(feature_bit);
-		if (!(upper->wanted_features & feature)
-		    && (features & feature)) {
+		if (!netdev_wanted_features_intersects(upper, feature) &&
+		    netdev_features_intersects(features, feature)) {
 			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
 				   &feature, upper->name);
 			netdev_features_direct_andnot(&features, feature);
@@ -9458,13 +9458,14 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	upper_disables = NETIF_F_UPPER_DISABLES;
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		feature = __NETIF_F_BIT(feature_bit);
-		if (!(features & feature) && (lower->active_features & feature)) {
+		if (!netdev_features_intersects(features, feature) &&
+		    netdev_active_features_intersects(lower, feature)) {
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
 			netdev_wanted_features_direct_andnot(lower, feature);
 			__netdev_update_features(lower);
 
-			if (unlikely(lower->active_features & feature))
+			if (unlikely(netdev_active_features_intersects(lower, feature)))
 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
 					    &feature, lower->name);
 			else
@@ -9480,14 +9481,15 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 
 	/* Fix illegal checksum combinations */
 	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features) &&
-	    (features & netdev_ip_csum_features)) {
+	    netdev_features_intersects(features, netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
 		netdev_features_direct_andnot(&features,
 					      netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((features & NETIF_F_ALL_TSO) && !netdev_features_test_bit(NETIF_F_SG_BIT, features)) {
+	if (netdev_features_intersects(features, NETIF_F_ALL_TSO) &&
+	    !netdev_features_test_bit(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
 		netdev_features_direct_andnot(&features, NETIF_F_ALL_TSO);
 	}
@@ -9515,7 +9517,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
 	netdev_features_clear_bit(NETIF_F_TSO_ECN_BIT, &tmp);
-	if (!(features & tmp) &&
+	if (!netdev_features_intersects(features, tmp) &&
 	    netdev_features_test_bit(NETIF_F_TSO_ECN_BIT, features))
 		netdev_features_clear_bit(NETIF_F_TSO_ECN_BIT, &features);
 
@@ -9527,7 +9529,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if ((features & dev->gso_partial_features) &&
+	if (netdev_gso_partial_features_intersects(dev, features) &&
 	    !netdev_features_test_bit(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e6f6690b3848..2190209b2a0c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -164,7 +164,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	__netdev_update_features(dev);
 
 	tmp = netdev_wanted_features_xor(dev, dev->active_features);
-	if (tmp & valid)
+	if (netdev_features_intersects(tmp, valid))
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
@@ -277,7 +277,7 @@ static int ethtool_get_one_feature(struct net_device *dev,
 	};
 
 	mask = ethtool_get_feature_mask(ethcmd);
-	edata.data = !!(dev->active_features & mask);
+	edata.data = !!netdev_active_features_intersects(dev, mask);
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
 		return -EFAULT;
 	return 0;
@@ -370,7 +370,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	changed &= eth_all_features;
 	tmp = netdev_hw_features_andnot_r(dev, changed);
 	if (tmp)
-		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
+		return netdev_hw_features_intersects(dev, changed) ? -EINVAL : -EOPNOTSUPP;
 
 	netdev_wanted_features_direct_andnot(dev, changed);
 	tmp = features & changed;
-- 
2.33.0

