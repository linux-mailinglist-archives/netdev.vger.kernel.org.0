Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A965341C92E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344349AbhI2QCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:16 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23320 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344198AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWp66RYzR5GN;
        Wed, 29 Sep 2021 23:53:42 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 025/167] skbuff: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:12 +0800
Message-ID: <20210929155334.12454-26-shenjian15@huawei.com>
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
 include/linux/skbuff.h |  6 ++++--
 net/core/skbuff.c      | 10 ++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 841e2f0f5240..5dbb04a5f29f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3730,8 +3730,10 @@ static inline bool skb_needs_linearize(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	return skb_is_nonlinear(skb) &&
-	       ((skb_has_frag_list(skb) && !(features & NETIF_F_FRAGLIST)) ||
-		(skb_shinfo(skb)->nr_frags && !(features & NETIF_F_SG)));
+	       ((skb_has_frag_list(skb) &&
+		 !netdev_feature_test_bit(NETIF_F_FRAGLIST_BIT, features)) ||
+		(skb_shinfo(skb)->nr_frags &&
+		!netdev_feature_test_bit(NETIF_F_SG_BIT, features)));
 }
 
 static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 74601bbc56ac..e229c1c0ce41 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3992,7 +3992,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		 * skbs; we do so by disabling SG.
 		 */
 		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
-			features &= ~NETIF_F_SG;
+			netdev_feature_clear_bit(NETIF_F_SG_BIT, &features);
 	}
 
 	__skb_push(head_skb, doffset);
@@ -4000,11 +4000,12 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	if (unlikely(!proto))
 		return ERR_PTR(-EINVAL);
 
-	sg = !!(features & NETIF_F_SG);
+	sg = !!netdev_feature_test_bit(NETIF_F_SG_BIT, features);
 	csum = !!can_checksum_protocol(features, proto);
 
 	if (sg && csum && (mss != GSO_BY_FRAGS))  {
-		if (!(features & NETIF_F_GSO_PARTIAL)) {
+		if (!netdev_feature_test_bit(NETIF_F_GSO_PARTIAL_BIT,
+					     features)) {
 			struct sk_buff *iter;
 			unsigned int frag_len;
 
@@ -4261,7 +4262,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		unsigned short gso_size = skb_shinfo(head_skb)->gso_size;
 
 		/* Update type to add partial and then remove dodgy if set */
-		type |= (features & NETIF_F_GSO_PARTIAL) / NETIF_F_GSO_PARTIAL * SKB_GSO_PARTIAL;
+		type |= netdev_feature_test_bit(NETIF_F_GSO_PARTIAL_BIT,
+						features) * SKB_GSO_PARTIAL;
 		type &= ~SKB_GSO_DODGY;
 
 		/* Update GSO info and prepare to start updating headers on
-- 
2.33.0

