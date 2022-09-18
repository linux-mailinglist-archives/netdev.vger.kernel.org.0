Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2D15BBD02
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiIRJuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIRJuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C431D13E8D
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjf76w91zHnmn;
        Sun, 18 Sep 2022 17:47:43 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:50 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 22/55] net: core: adjust netdev_sync_xxx_features
Date:   Sun, 18 Sep 2022 09:43:03 +0000
Message-ID: <20220918094336.28958-23-shenjian15@huawei.com>
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

The functions netdev_sync_upper_features() and
netdev_sync_lower_features() use NETIF_F_XXX as input parameter
directly, change them to use NETIF_F_XXX_BIT, for all macroes
NETIF_F_XXX will be removed later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/core/dev.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index cdfe1a0608a1..61e0a9f99ff8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9564,16 +9564,14 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
 	int feature_bit;
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(upper->wanted_features & feature)
-		    && (features & feature)) {
-			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
-				   &feature, upper->name);
-			features &= ~feature;
+		if (!netdev_wanted_feature_test(upper, feature_bit) &&
+		    netdev_feature_test(feature_bit, features)) {
+			netdev_dbg(lower, "Dropping feature bit %d, upper dev %s has it off.\n",
+				   feature_bit, upper->name);
+			netdev_feature_del(feature_bit, features);
 		}
 	}
 
@@ -9584,20 +9582,19 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
 	int feature_bit;
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(features & feature) && (lower->features & feature)) {
-			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
-				   &feature, lower->name);
-			lower->wanted_features &= ~feature;
+		if (!netdev_feature_test(feature_bit, features) &&
+		    netdev_active_feature_test(lower, feature_bit)) {
+			netdev_dbg(upper, "Disabling feature bit %d on lower dev %s.\n",
+				   feature_bit, lower->name);
+			netdev_wanted_feature_del(lower, feature_bit);
 			__netdev_update_features(lower);
 
-			if (unlikely(lower->features & feature))
-				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
-					    &feature, lower->name);
+			if (unlikely(netdev_active_feature_test(lower, feature_bit)))
+				netdev_WARN(upper, "failed to disable feature bit %d on %s!\n",
+					    feature_bit, lower->name);
 			else
 				netdev_features_change(lower);
 		}
-- 
2.33.0

