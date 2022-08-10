Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C8C58E554
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiHJDOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiHJDNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B96E81B37
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfr22HlzXdT0;
        Wed, 10 Aug 2022 11:09:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:45 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 09/36] test_bpf: replace const features initialization with NETDEV_FEATURE_SET
Date:   Wed, 10 Aug 2022 11:05:57 +0800
Message-ID: <20220810030624.34711-10-shenjian15@huawei.com>
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

The test_bpf uses netdev_features in global structure
initialization. Changed the its netdev_features_t memeber
to netdev_features_t *, and make it refer to a netdev_features_t
global variables.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 lib/test_bpf.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 5820704165a6..5ba5e9064903 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -13,6 +13,7 @@
 #include <linux/bpf.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_vlan.h>
 #include <linux/random.h>
 #include <linux/highmem.h>
@@ -14718,27 +14719,48 @@ static __init struct sk_buff *build_test_skb_linear_no_head_frag(void)
 struct skb_segment_test {
 	const char *descr;
 	struct sk_buff *(*build_skb)(void);
-	netdev_features_t features;
+	const netdev_features_t *features;
 };
 
+static DECLARE_NETDEV_FEATURE_SET(gso_frags_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_GSO_PARTIAL_BIT,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static DECLARE_NETDEV_FEATURE_SET(gso_linear_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_FRAGLIST_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_GSO_BIT,
+				  NETIF_F_LLTX_BIT,
+				  NETIF_F_GRO_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_STAG_TX_BIT);
+static netdev_features_t gso_frags_features __ro_after_init;
+static netdev_features_t gso_linear_feature_features __ro_after_init;
+
 static struct skb_segment_test skb_segment_tests[] __initconst = {
 	{
 		.descr = "gso_with_rx_frags",
 		.build_skb = build_test_skb,
-		.features = NETIF_F_SG | NETIF_F_GSO_PARTIAL | NETIF_F_IP_CSUM |
-			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM
+		.features = &gso_frags_features
 	},
 	{
 		.descr = "gso_linear_no_head_frag",
 		.build_skb = build_test_skb_linear_no_head_frag,
-		.features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_GSO |
-			    NETIF_F_LLTX | NETIF_F_GRO |
-			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_STAG_TX
+		.features = &gso_linear_feature_features
 	}
 };
 
+static void __init test_skb_features_init(void)
+{
+	netdev_features_set_array(&gso_frags_feature_set, &gso_frags_features);
+	netdev_features_set_array(&gso_linear_feature_set,
+				  &gso_linear_feature_features);
+}
+
 static __init int test_skb_segment_single(const struct skb_segment_test *test)
 {
 	struct sk_buff *skb, *segs;
@@ -14750,7 +14772,7 @@ static __init int test_skb_segment_single(const struct skb_segment_test *test)
 		goto done;
 	}
 
-	segs = skb_segment(skb, test->features);
+	segs = skb_segment(skb, *test->features);
 	if (!IS_ERR(segs)) {
 		kfree_skb_list(segs);
 		ret = 0;
@@ -14764,6 +14786,8 @@ static __init int test_skb_segment(void)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
 
+	test_skb_features_init();
+
 	for (i = 0; i < ARRAY_SIZE(skb_segment_tests); i++) {
 		const struct skb_segment_test *test = &skb_segment_tests[i];
 
-- 
2.33.0

