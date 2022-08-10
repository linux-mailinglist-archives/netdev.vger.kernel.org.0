Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DAF58E56B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiHJDOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiHJDN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB53C82F96
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zft5lDKzXdT8;
        Wed, 10 Aug 2022 11:09:42 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 26/36] treewide: use netdev_feature_change helpers
Date:   Wed, 10 Aug 2022 11:06:14 +0800
Message-ID: <20220810030624.34711-27-shenjian15@huawei.com>
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

Replace the '^=' expressions of single feature bit by
netdev_feature_change helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  2 +-
 drivers/net/ethernet/google/gve/gve_main.c      |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c  |  2 +-
 drivers/net/hyperv/netvsc_drv.c                 |  4 ++--
 drivers/s390/net/qeth_core_main.c               | 10 +++++-----
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index fd2e42662dd5..316fa87237b2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1285,7 +1285,7 @@ static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 			    !!(features & NETIF_F_HW_VLAN_CTAG_RX), true);
 	if (unlikely(err)) {
 		dev->features = features;
-		dev->features ^= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_active_feature_change(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 	return err;
 }
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 357e2d9cd740..dd7bc0374d6f 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1186,7 +1186,7 @@ static int gve_set_features(struct net_device *netdev,
 	int err;
 
 	if ((netdev->features & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
-		netdev->features ^= NETIF_F_LRO;
+		netdev_active_feature_change(netdev, NETIF_F_LRO_BIT);
 		if (netif_carrier_ok(netdev)) {
 			/* To make this process as simple as possible we
 			 * teardown the device, set the new configuration,
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index fc51958cd77a..ab7e234132ed 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1100,7 +1100,7 @@ int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
 	if (!(changed & NETIF_F_LRO))
 		return 0;
 
-	netdev->features ^= NETIF_F_LRO;
+	netdev_active_feature_change(netdev, NETIF_F_LRO_BIT);
 
 	if (qlcnic_config_hw_lro(adapter, hw_lro))
 		return -EIO;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 72f0500ae697..e241f9a1fca7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1910,7 +1910,7 @@ static netdev_features_t netvsc_fix_features(struct net_device *ndev,
 		return features;
 
 	if ((features & NETIF_F_LRO) && netvsc_xdp_get(nvdev)) {
-		features ^= NETIF_F_LRO;
+		netdev_feature_change(NETIF_F_LRO_BIT, &features);
 		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
 	}
 
@@ -1946,7 +1946,7 @@ static int netvsc_set_features(struct net_device *ndev,
 	ret = rndis_filter_set_offload_params(ndev, nvdev, &offloads);
 
 	if (ret) {
-		features ^= NETIF_F_LRO;
+		netdev_feature_change(NETIF_F_LRO_BIT, &features);
 		ndev->features = features;
 	}
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0d3d0ffdb46b..39e0bd7ba519 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6871,31 +6871,31 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4,
 				       &card->info.has_lp2lp_cso_v4);
 		if (rc)
-			changed ^= NETIF_F_IP_CSUM;
+			netdev_feature_change(NETIF_F_IP_CSUM_BIT, &changed);
 	}
 	if (changed & NETIF_F_IPV6_CSUM) {
 		rc = qeth_set_ipa_csum(card, features & NETIF_F_IPV6_CSUM,
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV6,
 				       &card->info.has_lp2lp_cso_v6);
 		if (rc)
-			changed ^= NETIF_F_IPV6_CSUM;
+			netdev_feature_change(NETIF_F_IPV6_CSUM_BIT, &changed);
 	}
 	if (changed & NETIF_F_RXCSUM) {
 		rc = qeth_set_ipa_rx_csum(card, features & NETIF_F_RXCSUM);
 		if (rc)
-			changed ^= NETIF_F_RXCSUM;
+			netdev_feature_change(NETIF_F_RXCSUM_BIT, &changed);
 	}
 	if (changed & NETIF_F_TSO) {
 		rc = qeth_set_ipa_tso(card, features & NETIF_F_TSO,
 				      QETH_PROT_IPV4);
 		if (rc)
-			changed ^= NETIF_F_TSO;
+			netdev_feature_change(NETIF_F_TSO_BIT, &changed);
 	}
 	if (changed & NETIF_F_TSO6) {
 		rc = qeth_set_ipa_tso(card, features & NETIF_F_TSO6,
 				      QETH_PROT_IPV6);
 		if (rc)
-			changed ^= NETIF_F_TSO6;
+			netdev_feature_change(NETIF_F_TSO6_BIT, &changed);
 	}
 
 	qeth_check_restricted_features(card, dev->features ^ features,
-- 
2.33.0

