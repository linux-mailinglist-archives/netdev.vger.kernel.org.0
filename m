Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B31F41C96C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346504AbhI2QE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23333 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345619AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX31ZSCzRb3L;
        Wed, 29 Sep 2021 23:53:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 112/167] net: oki-semi: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:39 +0800
Message-ID: <20210929155334.12454-113-shenjian15@huawei.com>
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

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c    | 13 ++++++++-----
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c   |  6 ++++--
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ec3e558f890e..49caca2ae753 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2210,9 +2210,11 @@ static int pch_gbe_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	if (!(changed & NETIF_F_RXCSUM))
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	if (netif_running(netdev))
@@ -2523,9 +2525,10 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	netdev->watchdog_timeo = PCH_GBE_WATCHDOG_PERIOD;
 	netif_napi_add(netdev, &adapter->napi,
 		       pch_gbe_napi_poll, PCH_GBE_RX_WEIGHT);
-	netdev->hw_features = NETIF_F_RXCSUM |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	netdev->features = netdev->hw_features;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM, &netdev->hw_features);
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 	pch_gbe_set_ethtool_ops(netdev);
 
 	/* MTU range: 46 - 10300 */
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
index 81fc5a6e3221..1e3a909a08c5 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
@@ -477,7 +477,8 @@ void pch_gbe_check_options(struct pch_gbe_adapter *adapter)
 		val = XsumRX;
 		pch_gbe_validate_option(&val, &opt, adapter);
 		if (!val)
-			dev->features &= ~NETIF_F_RXCSUM;
+			netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
+						 &dev->features);
 	}
 	{ /* Checksum Offload Enable/Disable */
 		static const struct pch_gbe_option opt = {
@@ -489,7 +490,8 @@ void pch_gbe_check_options(struct pch_gbe_adapter *adapter)
 		val = XsumTX;
 		pch_gbe_validate_option(&val, &opt, adapter);
 		if (!val)
-			dev->features &= ~NETIF_F_CSUM_MASK;
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK,
+						  &dev->features);
 	}
 	{ /* Flow Control */
 		static const struct pch_gbe_option opt = {
-- 
2.33.0

