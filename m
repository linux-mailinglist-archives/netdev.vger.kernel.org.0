Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170AD5BBD1F
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiIRJud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiIRJt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8690613E38
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:55 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjdR5glczpSvf;
        Sun, 18 Sep 2022 17:47:07 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:53 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 39/55] net: adjust the prototype of netdev_intersect_features()
Date:   Sun, 18 Sep 2022 09:43:20 +0000
Message-ID: <20220918094336.28958-40-shenjian15@huawei.com>
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

The fcuntion netdev_intersect_features() using netdev_features_t
as parameters, and returns netdev_features_t directly. For the
prototype of netdev_features_t will be extended to be larger than
8 bytes, so change the prototype of the function, change the
prototype of input features to 'netdev_features_t *', and return
the features pointer as output parameters.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  2 +-
 include/linux/netdev_feature_helpers.h        | 25 +++++++++++--------
 net/8021q/vlan_dev.c                          |  4 +--
 net/core/dev.c                                |  2 +-
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 8a15ec010282..0ab4f1b5e547 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -248,7 +248,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	if (netdev_features_intersects(lower_features, netdev_ip_csum_features))
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, lower_features);
 
-	features = netdev_intersect_features(features, lower_features);
+	netdev_intersect_features(&features, &features, &lower_features);
 	tmp = NETIF_F_SOFT_FEATURES;
 	netdev_feature_add(NETIF_F_HW_TC_BIT, tmp);
 	netdev_features_mask(tmp, old_features);
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 60bc021648e4..a15bd3a3b574 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -697,21 +697,24 @@ static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 #define netdev_gso_partial_features_clear_set(ndev, ...)		\
 	__netdev_gso_partial_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
 
-static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
-							  netdev_features_t f2)
+static inline void netdev_intersect_features(netdev_features_t *ret,
+					     const netdev_features_t *f1,
+					     const netdev_features_t *f2)
 {
-	netdev_features_t ret;
-
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, f1) !=
-	    netdev_feature_test(NETIF_F_HW_CSUM_BIT, f2)) {
-		if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, f1))
-			netdev_features_set(f1, netdev_ip_csum_features);
+	netdev_features_t local_f1;
+	netdev_features_t local_f2;
+
+	netdev_features_copy(local_f1, *f1);
+	netdev_features_copy(local_f2, *f2);
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, local_f1) !=
+	    netdev_feature_test(NETIF_F_HW_CSUM_BIT, local_f2)) {
+		if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, local_f1))
+			netdev_features_set(local_f1, netdev_ip_csum_features);
 		else
-			netdev_features_set(f2, netdev_ip_csum_features);
+			netdev_features_set(local_f2, netdev_ip_csum_features);
 	}
 
-	netdev_features_and(ret, f1, f2);
-	return ret;
+	netdev_features_and(*ret, local_f1, local_f2);
 }
 
 static inline void
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 04588800df24..d03348e29f36 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -655,14 +655,14 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 
 	tmp = real_dev->vlan_features;
 	netdev_feature_add(NETIF_F_RXCSUM_BIT, tmp);
-	lower_features = netdev_intersect_features(tmp, real_dev->features);
+	netdev_intersect_features(&lower_features, &tmp, &real_dev->features);
 
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
 	if (netdev_features_intersects(lower_features, netdev_ip_csum_features))
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, lower_features);
-	features = netdev_intersect_features(features, lower_features);
+	netdev_intersect_features(&features, &features, &lower_features);
 	netdev_features_or(tmp, NETIF_F_SOFT_FEATURES, NETIF_F_GSO_SOFTWARE);
 	netdev_features_mask(tmp, old_features);
 	netdev_features_set(features, tmp);
diff --git a/net/core/dev.c b/net/core/dev.c
index ac53e727d88f..e36347e0abe7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3565,7 +3565,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	if (skb_vlan_tagged(skb)) {
 		netdev_features_or(tmp, dev->vlan_features,
 				   netdev_tx_vlan_features);
-		features = netdev_intersect_features(features, tmp);
+		netdev_intersect_features(&features, &features, &tmp);
 	}
 
 	if (dev->netdev_ops->ndo_features_check)
-- 
2.33.0

