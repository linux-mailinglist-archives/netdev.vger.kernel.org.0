Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1143C41C997
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344800AbhI2QGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23330 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345923AbhI2QBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:01:21 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLXB48PWzRdL1;
        Wed, 29 Sep 2021 23:54:02 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:19 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 160/167] test_bpf: change the prototype of features
Date:   Wed, 29 Sep 2021 23:53:27 +0800
Message-ID: <20210929155334.12454-161-shenjian15@huawei.com>
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

Changes the type of "features" of struct skb_segment_test
to "u64", for it is initialized in the variable definition
stage, avoid compile issue when change the type of
"netdev_features_t" to "unsigned long *".

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 lib/test_bpf.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 0018d51b93b0..68c1cebdb300 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8876,30 +8876,31 @@ static __init struct sk_buff *build_test_skb_linear_no_head_frag(void)
 struct skb_segment_test {
 	const char *descr;
 	struct sk_buff *(*build_skb)(void);
-	netdev_features_t features;
+	u64 features[NETDEV_FEATURE_DWORDS];
 };
 
 static struct skb_segment_test skb_segment_tests[] __initconst = {
 	{
 		.descr = "gso_with_rx_frags",
 		.build_skb = build_test_skb,
-		.features = NETIF_F_SG | NETIF_F_GSO_PARTIAL | NETIF_F_IP_CSUM |
-			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM
+		.features = { NETIF_F_SG | NETIF_F_GSO_PARTIAL | NETIF_F_IP_CSUM |
+			      NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM }
 	},
 	{
 		.descr = "gso_linear_no_head_frag",
 		.build_skb = build_test_skb_linear_no_head_frag,
-		.features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_GSO |
-			    NETIF_F_LLTX_BIT | NETIF_F_GRO |
-			    NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_STAG_TX_BIT
+		.features = { NETIF_F_SG | NETIF_F_FRAGLIST |
+			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_GSO |
+			      NETIF_F_LLTX_BIT | NETIF_F_GRO |
+			      NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
+			      NETIF_F_HW_VLAN_STAG_TX_BIT }
 	}
 };
 
 static __init int test_skb_segment_single(const struct skb_segment_test *test)
 {
 	struct sk_buff *skb, *segs;
+	netdev_features_t features;
 	int ret = -1;
 
 	skb = test->build_skb();
@@ -8908,7 +8909,9 @@ static __init int test_skb_segment_single(const struct skb_segment_test *test)
 		goto done;
 	}
 
-	segs = skb_segment(skb, test->features);
+	netdev_feature_zero(&features);
+	netdev_feature_set_bits(test->features[0], &features);
+	segs = skb_segment(skb, features);
 	if (!IS_ERR(segs)) {
 		kfree_skb_list(segs);
 		ret = 0;
-- 
2.33.0

