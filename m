Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B17506222
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344728AbiDSCbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344743AbiDSCa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:58 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA1A2E9DE
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Kj6zm2jxWzCrBr;
        Tue, 19 Apr 2022 10:23:32 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 16/19] net: use netdev_features_equal helpers
Date:   Tue, 19 Apr 2022 10:22:03 +0800
Message-ID: <20220419022206.36381-17-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419022206.36381-1-shenjian15@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
index 769f3a8b3ff9..6851f2196041 100644
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
index 52d3ced17602..0bbe83f661d1 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -644,7 +644,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
 	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
-	if (efx->net_dev->features != old_features)
+	if (!netdev_active_features_equal(efx->net_dev, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
diff --git a/net/core/dev.c b/net/core/dev.c
index 03e64399c7b4..c59f50898444 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9632,7 +9632,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		features = netdev_sync_upper_features(dev, upper, features);
 
-	if (dev->features == features)
+	if (netdev_active_features_equal(dev, features))
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
-- 
2.33.0

