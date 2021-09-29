Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E1841C8E5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345513AbhI2P7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:59:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12978 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245242AbhI2P7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:40 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLb91V5gzWX5X;
        Wed, 29 Sep 2021 23:56:37 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 010/167] net: convert the prototype of netif_skb_features
Date:   Wed, 29 Sep 2021 23:50:57 +0800
Message-ID: <20210929155334.12454-11-shenjian15@huawei.com>
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
netif_skb_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/xen-netfront.c |  9 +++++++--
 include/linux/netdevice.h  |  2 +-
 net/core/dev.c             | 20 ++++++++++----------
 net/core/netpoll.c         |  2 +-
 net/ipv4/ip_output.c       |  2 +-
 net/ipv6/ip6_output.c      |  2 +-
 net/sched/sch_cake.c       |  3 ++-
 net/sched/sch_netem.c      |  3 ++-
 net/sched/sch_taprio.c     |  3 ++-
 net/sched/sch_tbf.c        |  3 ++-
 10 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index e31b98403f31..65c134ac2be5 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -679,6 +679,7 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	struct netfront_queue *queue = NULL;
 	struct xennet_gnttab_make_txreq info = { };
 	unsigned int num_queues = dev->real_num_tx_queues;
+	netdev_features_t features;
 	u16 queue_index;
 	struct sk_buff *nskb;
 
@@ -730,8 +731,12 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	spin_lock_irqsave(&queue->tx_lock, flags);
 
 	if (unlikely(!netif_carrier_ok(dev) ||
-		     (slots > 1 && !xennet_can_sg(dev)) ||
-		     netif_needs_gso(skb, netif_skb_features(skb)))) {
+		     (slots > 1 && !xennet_can_sg(dev)))) {
+		spin_unlock_irqrestore(&queue->tx_lock, flags);
+		goto drop;
+	}
+	netif_skb_features(skb, &features);
+	if (unlikely(netif_needs_gso(skb, features))) {
 		spin_unlock_irqrestore(&queue->tx_lock, flags);
 		goto drop;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 09233e7df8f1..d62edd4c99a9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5058,7 +5058,7 @@ void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 
 void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
 			     netdev_features_t *features);
-netdev_features_t netif_skb_features(struct sk_buff *skb);
+void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 43b81dc6b815..8f6316bee565 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3523,34 +3523,34 @@ static void gso_features_check(const struct sk_buff *skb,
 	}
 }
 
-netdev_features_t netif_skb_features(struct sk_buff *skb)
+void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->features;
+
+	*features = dev->features;
 
 	if (skb_is_gso(skb))
-		gso_features_check(skb, dev, &features);
+		gso_features_check(skb, dev, features);
 
 	/* If encapsulation offload request, verify we are testing
 	 * hardware encapsulation features instead of standard
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		features &= dev->hw_enc_features;
+		*features &= dev->hw_enc_features;
 
 	if (skb_vlan_tagged(skb))
-		netdev_intersect_features(&features, features,
+		netdev_intersect_features(features, *features,
 					  dev->vlan_features |
 					  NETIF_F_HW_VLAN_CTAG_TX |
 					  NETIF_F_HW_VLAN_STAG_TX);
 
 	if (dev->netdev_ops->ndo_features_check)
-		dev->netdev_ops->ndo_features_check(skb, dev, &features);
+		dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
-		dflt_features_check(skb, dev, &features);
+		dflt_features_check(skb, dev, features);
 
-	harmonize_features(skb, &features);
-	return features;
+	harmonize_features(skb, features);
 }
 EXPORT_SYMBOL(netif_skb_features);
 
@@ -3635,7 +3635,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 {
 	netdev_features_t features;
 
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, &features);
 	skb = validate_xmit_vlan(skb, features);
 	if (unlikely(!skb))
 		goto out_null;
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index edfc0f8011f8..d2fc92b89a5f 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -77,7 +77,7 @@ static netdev_tx_t netpoll_start_xmit(struct sk_buff *skb,
 	netdev_tx_t status = NETDEV_TX_OK;
 	netdev_features_t features;
 
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, &features);
 
 	if (skb_vlan_tag_present(skb) &&
 	    !vlan_hw_offload_capable(features, skb->vlan_proto)) {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9bca57ef8b83..8d552f1b7f62 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -255,7 +255,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 *    bridged to a NETIF_F_TSO tunnel stacked over an interface with an
 	 *    insufficient MTU.
 	 */
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, &features);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
 	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 	if (IS_ERR_OR_NULL(segs)) {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 12f985f43bcc..46a0867bcedf 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -146,7 +146,7 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 * describing the cases where GSO segment length exceeds the
 	 * egress MTU.
 	 */
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, &features);
 	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 3c2300d14468..e650ec5dc791 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1740,9 +1740,10 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (skb_is_gso(skb) && q->rate_flags & CAKE_FLAG_SPLIT_GSO) {
 		struct sk_buff *segs, *nskb;
-		netdev_features_t features = netif_skb_features(skb);
+		netdev_features_t features;
 		unsigned int slen = 0, numsegs = 0;
 
+		netif_skb_features(skb, &features);
 		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0c345e43a09a..414d57e017b9 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -413,8 +413,9 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 				     struct sk_buff **to_free)
 {
 	struct sk_buff *segs;
-	netdev_features_t features = netif_skb_features(skb);
+	netdev_features_t features;
 
+	netif_skb_features(skb, &features);
 	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 
 	if (IS_ERR_OR_NULL(segs)) {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1ab2fc933a21..d7fe4a2cc14f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -453,10 +453,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (skb_is_gso(skb) && !FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
-		netdev_features_t features = netif_skb_features(skb);
+		netdev_features_t features;
 		struct sk_buff *segs, *nskb;
 		int ret;
 
+		netif_skb_features(skb, &features);
 		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 78e79029dc63..99e6d7265e7f 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -192,10 +192,11 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct tbf_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *segs, *nskb;
-	netdev_features_t features = netif_skb_features(skb);
+	netdev_features_t features;
 	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
 	int ret, nb;
 
+	netif_skb_features(skb, &features);
 	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 
 	if (IS_ERR_OR_NULL(segs))
-- 
2.33.0

