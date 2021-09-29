Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB2D41C8F7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbhI2QA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:27 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12981 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344300AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbD0sR6zWX6v;
        Wed, 29 Sep 2021 23:56:40 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:57 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 019/167] net: sfc: convert the prototype of xxx_supported_features
Date:   Wed, 29 Sep 2021 23:51:06 +0800
Message-ID: <20210929155334.12454-20-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
xxx_supported_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/sfc/falcon/net_driver.h | 5 +++--
 drivers/net/ethernet/sfc/mcdi_filters.c      | 5 ++++-
 drivers/net/ethernet/sfc/net_driver.h        | 5 +++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a381cf9ec4f3..6fabfe7f02f5 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1298,11 +1298,12 @@ static inline struct ef4_rx_buffer *ef4_rx_buffer(struct ef4_rx_queue *rx_queue,
  * If a feature is fixed, it does not present in hw_features, but
  * always in features.
  */
-static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx)
+static inline void ef4_supported_features(const struct ef4_nic *efx,
+					  netdev_features_t *supported)
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	*supported = net_dev->features | net_dev->hw_features;
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 1523be77b9db..8e788c3a6f2a 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1298,6 +1298,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 {
 	struct net_device *net_dev = efx->net_dev;
 	struct efx_mcdi_filter_table *table;
+	netdev_features_t supported;
 	int rc;
 
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
@@ -1319,7 +1320,9 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		rc = efx_mcdi_filter_table_probe_matches(efx, table, true);
 	if (rc)
 		goto fail;
-	if ((efx_supported_features(efx) & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+
+	efx_supported_features(efx, &supported);
+	if ((supported & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    !(efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC)) &&
 	      efx_mcdi_filter_match_supported(table, false,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index f6981810039d..bf962ca160e7 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1681,11 +1681,12 @@ efx_channel_tx_old_fill_level(struct efx_channel *channel)
  * If a feature is fixed, it does not present in hw_features, but
  * always in features.
  */
-static inline netdev_features_t efx_supported_features(const struct efx_nic *efx)
+static inline void efx_supported_features(const struct efx_nic *efx,
+					  netdev_features_t *supported)
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	*supported = net_dev->features | net_dev->hw_features;
 }
 
 /* Get the current TX queue insert index. */
-- 
2.33.0

