Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6722A5BBD27
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiIRJvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiIRJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:24 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D923418E12
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:59 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjfF3F7qzHnqd;
        Sun, 18 Sep 2022 17:47:49 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 53/55] net: sfc: adjust the prototype of xxx_supported_features()
Date:   Sun, 18 Sep 2022 09:43:34 +0000
Message-ID: <20220918094336.28958-54-shenjian15@huawei.com>
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

The function xxx_supported_features() of sfc driver return
netdev_features_t directly.

For the prototype of netdev_features_t will be extended to be
larger than 8 bytes, so change the prototype of the function,
return the features pointer as output parameter.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/sfc/falcon/net_driver.h | 8 +++-----
 drivers/net/ethernet/sfc/mcdi_filters.c      | 2 +-
 drivers/net/ethernet/sfc/net_driver.h        | 8 +++-----
 drivers/net/ethernet/sfc/siena/net_driver.h  | 8 +++-----
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 35fa95504a5f..d23912406c69 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1299,14 +1299,12 @@ static inline struct ef4_rx_buffer *ef4_rx_buffer(struct ef4_rx_queue *rx_queue,
  * If a feature is fixed, it does not present in hw_features, but
  * always in features.
  */
-static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx)
+static inline void ef4_supported_features(const struct ef4_nic *efx,
+					  netdev_features_t *features)
 {
 	const struct net_device *net_dev = efx->net_dev;
-	netdev_features_t features;
 
-	netdev_features_or(features, net_dev->features, net_dev->hw_features);
-
-	return features;
+	netdev_features_or(*features, net_dev->features, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index fb4db91f4d8f..99c85b51a487 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1324,7 +1324,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		rc = efx_mcdi_filter_table_probe_matches(efx, table, true);
 	if (rc)
 		goto fail;
-	feats = efx_supported_features(efx);
+	efx_supported_features(efx, &feats);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, feats) &&
 	    !(efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC)) &&
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index dae500645595..20db4472bbe9 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1750,14 +1750,12 @@ efx_channel_tx_old_fill_level(struct efx_channel *channel)
  * If a feature is fixed, it does not present in hw_features, but
  * always in features.
  */
-static inline netdev_features_t efx_supported_features(const struct efx_nic *efx)
+static inline void efx_supported_features(const struct efx_nic *efx,
+					  netdev_features_t *features)
 {
 	const struct net_device *net_dev = efx->net_dev;
-	netdev_features_t features;
 
-	netdev_features_or(features, net_dev->features, net_dev->hw_features);
-
-	return features;
+	netdev_features_or(*features, net_dev->features, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 7040cfccd556..1420522bd0e6 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -1678,14 +1678,12 @@ efx_channel_tx_old_fill_level(struct efx_channel *channel)
  * If a feature is fixed, it does not present in hw_features, but
  * always in features.
  */
-static inline netdev_features_t efx_supported_features(const struct efx_nic *efx)
+static inline void efx_supported_features(const struct efx_nic *efx,
+					  netdev_features_t *features)
 {
 	const struct net_device *net_dev = efx->net_dev;
-	netdev_features_t features;
 
-	netdev_features_or(features, net_dev->features, net_dev->hw_features);
-
-	return features;
+	netdev_features_or(*features, net_dev->features, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
-- 
2.33.0

