Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA05BBD1D
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIRJuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4611811C0A
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbr6w52zlVll;
        Sun, 18 Sep 2022 17:45:44 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 09/55] test_bpf: replace const features initialization with NETDEV_FEATURE_SET
Date:   Sun, 18 Sep 2022 09:42:50 +0000
Message-ID: <20220918094336.28958-10-shenjian15@huawei.com>
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

The test_bpf uses netdev features in global structure
initialization. Changed the netdev_features_t memeber to
netdev_features_t *, and make it refer to a global constant
netdev_features_t variable.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 lib/test_bpf.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 5820704165a6..84073b768558 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -13,6 +13,7 @@
 #include <linux/bpf.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_vlan.h>
 #include <linux/random.h>
 #include <linux/highmem.h>
@@ -14718,27 +14719,45 @@ static __init struct sk_buff *build_test_skb_linear_no_head_frag(void)
 struct skb_segment_test {
 	const char *descr;
 	struct sk_buff *(*build_skb)(void);
-	netdev_features_t features;
+	const netdev_features_t *features;
 };
 
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
+	netdev_features_set_set(gso_frags_features,
+				NETIF_F_SG_BIT,
+				NETIF_F_GSO_PARTIAL_BIT,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT);
+	netdev_features_set_set(gso_linear_feature_features,
+				NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_GSO_BIT,
+				NETIF_F_LLTX_BIT,
+				NETIF_F_GRO_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_HW_VLAN_STAG_TX_BIT);
+}
+
 static __init int test_skb_segment_single(const struct skb_segment_test *test)
 {
 	struct sk_buff *skb, *segs;
@@ -14750,7 +14769,7 @@ static __init int test_skb_segment_single(const struct skb_segment_test *test)
 		goto done;
 	}
 
-	segs = skb_segment(skb, test->features);
+	segs = skb_segment(skb, *test->features);
 	if (!IS_ERR(segs)) {
 		kfree_skb_list(segs);
 		ret = 0;
@@ -14764,6 +14783,8 @@ static __init int test_skb_segment(void)
 {
 	int i, err_cnt = 0, pass_cnt = 0;
 
+	test_skb_features_init();
+
 	for (i = 0; i < ARRAY_SIZE(skb_segment_tests); i++) {
 		const struct skb_segment_test *test = &skb_segment_tests[i];
 
-- 
2.33.0

