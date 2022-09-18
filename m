Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883145BBD20
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIRJui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiIRJuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:02 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F7611C29
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjby5WKTz14QX8;
        Sun, 18 Sep 2022 17:45:50 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:53 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 40/55] net: adjust the prototype of netif_skb_features()
Date:   Sun, 18 Sep 2022 09:43:21 +0000
Message-ID: <20220918094336.28958-41-shenjian15@huawei.com>
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

The fcuntion netif_skb_features() using netdev_features_t as
parameters, and returns netdev_features_t directly. For the
prototype of netdev_features_t will be extended to be larger
than 8 bytes, so change the prototype of the function, change
the prototype of input features to 'netdev_features_t *', and
return the features pointer as output parameters.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/xen-netfront.c |  4 +++-
 include/linux/netdevice.h  |  2 +-
 net/core/dev.c             | 22 +++++++++++-----------
 net/core/netpoll.c         |  2 +-
 net/ipv4/ip_output.c       |  2 +-
 net/ipv6/ip6_output.c      |  2 +-
 net/sched/sch_cake.c       |  3 ++-
 net/sched/sch_netem.c      |  3 ++-
 net/sched/sch_taprio.c     |  3 ++-
 net/sched/sch_tbf.c        |  3 ++-
 10 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index ace8ebaaaabf..fedbd35aa1c1 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -719,6 +719,7 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	struct netfront_queue *queue = NULL;
 	struct xennet_gnttab_make_txreq info = { };
 	unsigned int num_queues = dev->real_num_tx_queues;
+	netdev_features_t features;
 	u16 queue_index;
 	struct sk_buff *nskb;
 
@@ -773,9 +774,10 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 
 	spin_lock_irqsave(&queue->tx_lock, flags);
 
+	netif_skb_features(skb, &features);
 	if (unlikely(!netif_carrier_ok(dev) ||
 		     (slots > 1 && !xennet_can_sg(dev)) ||
-		     netif_needs_gso(skb, netif_skb_features(skb)))) {
+		     netif_needs_gso(skb, features))) {
 		spin_unlock_irqrestore(&queue->tx_lock, flags);
 		goto drop;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 68f950f5a36b..75a839cf5cd2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4915,7 +4915,7 @@ void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 netdev_features_t passthru_features_check(struct sk_buff *skb,
 					  struct net_device *dev,
 					  netdev_features_t features);
-netdev_features_t netif_skb_features(struct sk_buff *skb);
+void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index e36347e0abe7..695b724a4054 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3546,36 +3546,36 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	return features;
 }
 
-netdev_features_t netif_skb_features(struct sk_buff *skb)
+void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->features;
 	netdev_features_t tmp;
 
+	netdev_features_copy(*features, dev->features);
+
 	if (skb_is_gso(skb))
-		features = gso_features_check(skb, dev, features);
+		*features = gso_features_check(skb, dev, *features);
 
 	/* If encapsulation offload request, verify we are testing
 	 * hardware encapsulation features instead of standard
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		netdev_features_mask(features, dev->hw_enc_features);
+		netdev_features_mask(*features, dev->hw_enc_features);
 
 	if (skb_vlan_tagged(skb)) {
 		netdev_features_or(tmp, dev->vlan_features,
 				   netdev_tx_vlan_features);
-		netdev_intersect_features(&features, &features, &tmp);
+		netdev_intersect_features(features, features, &tmp);
 	}
 
 	if (dev->netdev_ops->ndo_features_check)
-		tmp = dev->netdev_ops->ndo_features_check(skb, dev, features);
+		tmp = dev->netdev_ops->ndo_features_check(skb, dev, *features);
 	else
-		tmp = dflt_features_check(skb, dev, features);
-	netdev_features_mask(features, tmp);
+		tmp = dflt_features_check(skb, dev, *features);
+	netdev_features_mask(*features, tmp);
 
-	harmonize_features(skb, &features);
-	return features;
+	harmonize_features(skb, features);
 }
 EXPORT_SYMBOL(netif_skb_features);
 
@@ -3659,7 +3659,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 {
 	netdev_features_t features;
 
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, &features);
 	skb = validate_xmit_vlan(skb, features);
 	if (unlikely(!skb))
 		goto out_null;
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9be762e1d042..94dd11aa1b83 100644
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
index e128d2957d3f..8e9993eae1a4 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -262,7 +262,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 *    bridged to a NETIF_F_TSO tunnel stacked over an interface with an
 	 *    insufficient MTU.
 	 */
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, &features);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 40ca76257ec1..0ac686957ab7 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -148,7 +148,7 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 * describing the cases where GSO segment length exceeds the
 	 * egress MTU.
 	 */
-	features = netif_skb_features(skb);
+	netif_skb_features(skb, &features);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 022fd85394e8..837efd4c786f 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1740,9 +1740,10 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (skb_is_gso(skb) && q->rate_flags & CAKE_FLAG_SPLIT_GSO) {
 		struct sk_buff *segs, *nskb;
-		netdev_features_t features = netif_skb_features(skb);
+		netdev_features_t features;
 		unsigned int slen = 0, numsegs = 0;
 
+		netif_skb_features(skb, &features);
 		netdev_features_clear(features, NETIF_F_GSO_MASK);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 55084f0f2f57..cb253eb3a936 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -412,9 +412,10 @@ static void tfifo_enqueue(struct sk_buff *nskb, struct Qdisc *sch)
 static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 				     struct sk_buff **to_free)
 {
+	netdev_features_t features;
 	struct sk_buff *segs;
-	netdev_features_t features = netif_skb_features(skb);
 
+	netif_skb_features(skb, &features);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index dc8b114388e2..96bff2fdeecb 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -459,10 +459,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (skb_is_gso(skb) && !FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
-		netdev_features_t features = netif_skb_features(skb);
 		struct sk_buff *segs, *nskb;
+		netdev_features_t features;
 		int ret;
 
+		netif_skb_features(skb, &features);
 		netdev_features_clear(features, NETIF_F_GSO_MASK);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 5c883b639ed7..ce0bb68b02f3 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -207,10 +207,11 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct tbf_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *segs, *nskb;
-	netdev_features_t features = netif_skb_features(skb);
+	netdev_features_t features;
 	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
 	int ret, nb;
 
+	netif_skb_features(skb, &features);
 	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
 
-- 
2.33.0

