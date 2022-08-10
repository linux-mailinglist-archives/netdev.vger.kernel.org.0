Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE458E54B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiHJDOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiHJDNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:52 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D55982F90
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgy5zg2z1M8lv;
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
Subject: [RFCv7 PATCH net-next 33/36] treewide: use netdev_features_subset helpers
Date:   Wed, 10 Aug 2022 11:06:21 +0800
Message-ID: <20220810030624.34711-34-shenjian15@huawei.com>
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

Replace the '(f1 & f2) == f2' expressions of features by
netdev_features_subset helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 +-
 net/core/dev.c                           | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index f6015c49363e..a4751aa92ddf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2200,7 +2200,7 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	}
 
 	/* Can't do one without doing the other */
-	if ((features & vxlan_base) != vxlan_base) {
+	if (!netdev_features_subset(vxlan_base, features)) {
 		netdev_notice(netdev,
 			      "forcing both tx and rx udp tunnel support\n");
 		netdev_features_set(&features, vxlan_base);
diff --git a/net/core/dev.c b/net/core/dev.c
index b97b9316dbde..01340e889e72 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9695,8 +9695,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	}
 
 	if (netdev_feature_test(NETIF_F_HW_TLS_TX_BIT, features)) {
-		bool ip_csum = (features & netdev_ip_csum_features) ==
-			netdev_ip_csum_features;
+		bool ip_csum = netdev_features_subset(netdev_ip_csum_features, features);
 		bool hw_csum = netdev_feature_test(NETIF_F_HW_CSUM_BIT,
 						   features);
 
-- 
2.33.0

