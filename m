Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD5741C8EA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbhI2P76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:59:58 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12976 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbhI2P7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLb82yrGzWX2s;
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
Subject: [RFCv2 net-next 005/167] net: convert the prototype of gso_features_check
Date:   Wed, 29 Sep 2021 23:50:52 +0800
Message-ID: <20210929155334.12454-6-shenjian15@huawei.com>
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
gso_features_check for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/core/dev.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ef77e080504b..b3426559bac7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3487,18 +3487,21 @@ static netdev_features_t dflt_features_check(struct sk_buff *skb,
 	return vlan_features_check(skb, features);
 }
 
-static netdev_features_t gso_features_check(const struct sk_buff *skb,
-					    struct net_device *dev,
-					    netdev_features_t features)
+static void gso_features_check(const struct sk_buff *skb,
+			       struct net_device *dev,
+			       netdev_features_t *features)
 {
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
-	if (gso_segs > dev->gso_max_segs)
-		return features & ~NETIF_F_GSO_MASK;
+	if (gso_segs > dev->gso_max_segs) {
+		*features &= ~NETIF_F_GSO_MASK;
+		return;
+	}
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		return features & ~NETIF_F_GSO_MASK;
+		*features &= ~NETIF_F_GSO_MASK;
+		return;
 	}
 
 	/* Support for GSO partial features requires software
@@ -3508,7 +3511,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		features &= ~dev->gso_partial_features;
+		*features &= ~dev->gso_partial_features;
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -3518,10 +3521,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			*features &= ~NETIF_F_TSO_MANGLEID;
 	}
-
-	return features;
 }
 
 netdev_features_t netif_skb_features(struct sk_buff *skb)
@@ -3530,7 +3531,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	netdev_features_t features = dev->features;
 
 	if (skb_is_gso(skb))
-		features = gso_features_check(skb, dev, features);
+		gso_features_check(skb, dev, &features);
 
 	/* If encapsulation offload request, verify we are testing
 	 * hardware encapsulation features instead of standard
-- 
2.33.0

