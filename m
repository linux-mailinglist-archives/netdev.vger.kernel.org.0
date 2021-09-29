Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231C641C929
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345701AbhI2QCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23322 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344369AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWs2dHBzRTD1;
        Wed, 29 Sep 2021 23:53:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 045/167] net: sched: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:32 +0800
Message-ID: <20210929155334.12454-46-shenjian15@huawei.com>
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
 include/net/pkt_cls.h  | 2 +-
 net/sched/sch_cake.c   | 3 ++-
 net/sched/sch_netem.c  | 3 ++-
 net/sched/sch_taprio.c | 3 ++-
 net/sched/sch_tbf.c    | 3 ++-
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 83a6d0792180..228881d40dd8 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -636,7 +636,7 @@ struct tc_cls_u32_offload {
 
 static inline bool tc_can_offload(const struct net_device *dev)
 {
-	return dev->features & NETIF_F_HW_TC;
+	return netdev_feature_test_bit(NETIF_F_HW_TC_BIT, dev->features);
 }
 
 static inline bool tc_can_offload_extack(const struct net_device *dev,
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index e650ec5dc791..5d783cd72290 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1744,7 +1744,8 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		unsigned int slen = 0, numsegs = 0;
 
 		netif_skb_features(skb, &features);
-		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 414d57e017b9..4aabeb206777 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -416,7 +416,8 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 	netdev_features_t features;
 
 	netif_skb_features(skb, &features);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs)) {
 		qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index d7fe4a2cc14f..e42deaf723b1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -458,7 +458,8 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		int ret;
 
 		netif_skb_features(skb, &features);
-		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 99e6d7265e7f..8ac786f467a0 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -197,7 +197,8 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	int ret, nb;
 
 	netif_skb_features(skb, &features);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs))
 		return qdisc_drop(skb, sch, to_free);
-- 
2.33.0

