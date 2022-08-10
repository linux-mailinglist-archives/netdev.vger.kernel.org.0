Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB4D58E546
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiHJDOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiHJDNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088FF81B3F
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M2Zjy4YHwzGpKW;
        Wed, 10 Aug 2022 11:12:22 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:47 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 21/36] net: iavf: adjust net device features relative macroes
Date:   Wed, 10 Aug 2022 11:06:09 +0800
Message-ID: <20220810030624.34711-22-shenjian15@huawei.com>
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

The macro IAVF_NETDEV_VLAN_FEATURE_ALLOWED use NETIF_F_XXX as
parameter directly, change it to use NETIF_F_XXX_BIT, for all
the macroes NETIF_F_XXX will be removed later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d4a2776381c3..1f9884539807 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4467,8 +4467,8 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 }
 
 #define IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested, allowed, feature_bit) \
-	(!(((requested) & (feature_bit)) && \
-	   !((allowed) & (feature_bit))))
+	(!(netdev_feature_test(feature_bit, requested) && \
+	   !netdev_feature_test(feature_bit, allowed)))
 
 /**
  * iavf_fix_netdev_vlan_features - fix NETDEV VLAN features based on support
@@ -4486,31 +4486,31 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
-					      NETIF_F_HW_VLAN_CTAG_TX))
+					      NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		requested_features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
-					      NETIF_F_HW_VLAN_CTAG_RX))
+					      NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		requested_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
-					      NETIF_F_HW_VLAN_STAG_TX))
+					      NETIF_F_HW_VLAN_STAG_TX_BIT))
 		requested_features &= ~NETIF_F_HW_VLAN_STAG_TX;
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
-					      NETIF_F_HW_VLAN_STAG_RX))
+					      NETIF_F_HW_VLAN_STAG_RX_BIT))
 		requested_features &= ~NETIF_F_HW_VLAN_STAG_RX;
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
-					      NETIF_F_HW_VLAN_CTAG_FILTER))
+					      NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		requested_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
-					      NETIF_F_HW_VLAN_STAG_FILTER))
+					      NETIF_F_HW_VLAN_STAG_FILTER_BIT))
 		requested_features &= ~NETIF_F_HW_VLAN_STAG_FILTER;
 
 	if ((requested_features & netdev_ctag_vlan_offload_features) &&
-- 
2.33.0

