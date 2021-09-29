Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867ED41C8EE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345653AbhI2QAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12975 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343738AbhI2P7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLb828pWzWJBw;
        Wed, 29 Sep 2021 23:56:36 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 004/167] net: convert the prototype of harmonize_features
Date:   Wed, 29 Sep 2021 23:50:51 +0800
Message-ID: <20210929155334.12454-5-shenjian15@huawei.com>
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
harmonize_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/core/dev.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 81e93be4cedb..ef77e080504b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3457,22 +3457,19 @@ static void net_mpls_features(struct sk_buff *skb, netdev_features_t *features,
 }
 #endif
 
-static netdev_features_t harmonize_features(struct sk_buff *skb,
-	netdev_features_t features)
+static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 {
 	__be16 type;
 
 	type = skb_network_protocol(skb, NULL);
-	net_mpls_features(skb, &features, type);
+	net_mpls_features(skb, features, type);
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
-	    !can_checksum_protocol(features, type)) {
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	    !can_checksum_protocol(*features, type)) {
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 	}
 	if (illegal_highdma(skb->dev, skb))
-		features &= ~NETIF_F_SG;
-
-	return features;
+		*features &= ~NETIF_F_SG;
 }
 
 netdev_features_t passthru_features_check(struct sk_buff *skb,
@@ -3554,7 +3551,8 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	else
 		features &= dflt_features_check(skb, dev, features);
 
-	return harmonize_features(skb, features);
+	harmonize_features(skb, &features);
+	return features;
 }
 EXPORT_SYMBOL(netif_skb_features);
 
-- 
2.33.0

