Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4CB5BBD29
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiIRJuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C171276D
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjbv07Wxz14QVb;
        Sun, 18 Sep 2022 17:45:47 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 19/55] net: mlx5e: adjust net device feature relative macroes
Date:   Sun, 18 Sep 2022 09:43:00 +0000
Message-ID: <20220918094336.28958-20-shenjian15@huawei.com>
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

The macroes MLX5E_SET_FEATURE and MLX5E_HANDLE_FEATURE use
NETIF_F_XXX as parameter directly, change it to NETIF_F_XXX_BIT,
for all the NETIF_F_XXX macroes will be removed later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 40 ++++++++++---------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a73d730ad55d..56cefb49b396 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3593,9 +3593,9 @@ static int mlx5e_set_mac(struct net_device *netdev, void *addr)
 #define MLX5E_SET_FEATURE(features, feature, enable)	\
 	do {						\
 		if (enable)				\
-			*features |= feature;		\
+			netdev_feature_add(feature, *(features));	\
 		else					\
-			*features &= ~feature;		\
+			netdev_feature_del(feature, *(features));	\
 	} while (0)
 
 typedef int (*mlx5e_feature_handler)(struct net_device *netdev, bool enable);
@@ -3839,21 +3839,21 @@ static int set_feature_arfs(struct net_device *netdev, bool enable)
 
 static int mlx5e_handle_feature(struct net_device *netdev,
 				netdev_features_t *features,
-				netdev_features_t feature,
+				unsigned short feature_bit,
 				mlx5e_feature_handler feature_handler)
 {
 	netdev_features_t changes = *features ^ netdev->features;
-	bool enable = !!(*features & feature);
+	bool enable = netdev_feature_test(feature_bit, *features);
 	int err;
 
-	if (!(changes & feature))
+	if (!netdev_feature_test(feature_bit, changes))
 		return 0;
 
 	err = feature_handler(netdev, enable);
 	if (err) {
-		MLX5E_SET_FEATURE(features, feature, !enable);
-		netdev_err(netdev, "%s feature %pNF failed, err %d\n",
-			   enable ? "Enable" : "Disable", &feature, err);
+		MLX5E_SET_FEATURE(features, feature_bit, !enable);
+		netdev_err(netdev, "%s feature bit %u failed, err %d\n",
+			   enable ? "Enable" : "Disable", feature_bit, err);
 		return err;
 	}
 
@@ -3865,21 +3865,23 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	netdev_features_t oper_features = features;
 	int err = 0;
 
-#define MLX5E_HANDLE_FEATURE(feature, handler) \
-	mlx5e_handle_feature(netdev, &oper_features, feature, handler)
+#define MLX5E_HANDLE_FEATURE(feature_bit, handler) \
+	mlx5e_handle_feature(netdev, &oper_features, feature_bit, handler)
 
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_GRO_HW, set_feature_hw_gro);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER,
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO_BIT, set_feature_lro);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_GRO_HW_BIT, set_feature_hw_gro);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				    set_feature_cvlan_filter);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_hw_tc);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXALL, set_feature_rx_all);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXFCS, set_feature_rx_fcs);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_RX, set_feature_rx_vlan);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC_BIT, set_feature_hw_tc);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXALL_BIT, set_feature_rx_all);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXFCS_BIT, set_feature_rx_fcs);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    set_feature_rx_vlan);
 #ifdef CONFIG_MLX5_EN_ARFS
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE_BIT, set_feature_arfs);
 #endif
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX_BIT,
+				    mlx5e_ktls_set_feature_rx);
 
 	if (err) {
 		netdev->features = oper_features;
-- 
2.33.0

