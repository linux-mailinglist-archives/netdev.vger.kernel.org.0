Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17BD4E666F
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351445AbiCXP5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351437AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F93CAC92F
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KPVBS0H98zfZML;
        Thu, 24 Mar 2022 23:53:36 +0800 (CST)
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
Subject: [RFCv5 PATCH net-next 17/20] net: use netdev_features_equal helpers
Date:   Thu, 24 Mar 2022 23:49:29 +0800
Message-ID: <20220324154932.17557-18-shenjian15@huawei.com>
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

Replace the '==' and '!=' operations of features by
netdev_features_equal helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/sfc/efx_common.c | 2 +-
 drivers/net/ethernet/sfc/falcon/efx.c | 2 +-
 net/core/dev.c                        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index d2874aad3ce7..fd6eb74b4fa6 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -418,7 +418,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 				     efx->net_dev->active_features);
 	netdev_hw_features_direct_andnot(efx->net_dev, efx->fixed_features);
 	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
-	if (efx->net_dev->active_features != old_features)
+	if (!netdev_active_features_equal(efx->net_dev, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index efa3054cba35..22ea294a39fa 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -645,7 +645,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 				     efx->net_dev->active_features);
 	netdev_hw_features_direct_andnot(efx->net_dev, efx->fixed_features);
 	netdev_active_features_direct_or(efx->net_dev, efx->fixed_features);
-	if (efx->net_dev->active_features != old_features)
+	if (!netdev_active_features_equal(efx->net_dev, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
diff --git a/net/core/dev.c b/net/core/dev.c
index bb3c1b55cc2e..57409f97feb1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9613,7 +9613,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		features = netdev_sync_upper_features(dev, upper, features);
 
-	if (dev->active_features == features)
+	if (netdev_active_features_equal(dev, features))
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
-- 
2.33.0

