Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CC25BBD1C
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiIRJu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B9F1571E
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbt5TBZzlVwB;
        Sun, 18 Sep 2022 17:45:46 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 20/55] net: mlxsw: adjust input parameter for function mlxsw_sp_handle_feature
Date:   Sun, 18 Sep 2022 09:43:01 +0000
Message-ID: <20220918094336.28958-21-shenjian15@huawei.com>
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

The function mlxsw_sp_handle_feature() use NETIF_F_XXX as input
parameter directly, change it to use NETIF_F_XXX_BIT, for all
the NETIF_F_XXX macroes will be removed later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 72aa22236ffa..702edcfa25a3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1217,27 +1217,27 @@ typedef int (*mlxsw_sp_feature_handler)(struct net_device *dev, bool enable);
 
 static int mlxsw_sp_handle_feature(struct net_device *dev,
 				   netdev_features_t wanted_features,
-				   netdev_features_t feature,
+				   int feature_bit,
 				   mlxsw_sp_feature_handler feature_handler)
 {
 	netdev_features_t changes = wanted_features ^ dev->features;
-	bool enable = !!(wanted_features & feature);
+	bool enable = netdev_feature_test(feature_bit, wanted_features);
 	int err;
 
-	if (!(changes & feature))
+	if (!netdev_feature_test(feature_bit, changes))
 		return 0;
 
 	err = feature_handler(dev, enable);
 	if (err) {
-		netdev_err(dev, "%s feature %pNF failed, err %d\n",
-			   enable ? "Enable" : "Disable", &feature, err);
+		netdev_err(dev, "%s feature bit %d failed, err %d\n",
+			   enable ? "Enable" : "Disable", feature_bit, err);
 		return err;
 	}
 
 	if (enable)
-		dev->features |= feature;
+		netdev_active_feature_add(dev, feature_bit);
 	else
-		dev->features &= ~feature;
+		netdev_active_feature_del(dev, feature_bit);
 
 	return 0;
 }
@@ -1247,9 +1247,9 @@ static int mlxsw_sp_set_features(struct net_device *dev,
 	netdev_features_t oper_features = dev->features;
 	int err = 0;
 
-	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC,
+	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC_BIT,
 				       mlxsw_sp_feature_hw_tc);
-	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_LOOPBACK,
+	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_LOOPBACK_BIT,
 				       mlxsw_sp_feature_loopback);
 
 	if (err) {
-- 
2.33.0

