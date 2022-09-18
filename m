Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAF55BBCFC
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiIRJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIRJt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB32BE32
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjc55f8czmVMf;
        Sun, 18 Sep 2022 17:45:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 14/55] net: simplify the netdev features expressions for xxx_gso_segment
Date:   Sun, 18 Sep 2022 09:42:55 +0000
Message-ID: <20220918094336.28958-15-shenjian15@huawei.com>
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

The xxx_gso_segment functions use netdev features as input
parameter. Some of them using features handling expression
directly. Simplify these expreesions, so it can be replaced
by netdev features helpers later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/broadcom/tg3.c              | 5 +++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 4 +++-
 drivers/net/ethernet/sfc/siena/net_driver.h      | 1 +
 drivers/net/ethernet/sfc/siena/tx_common.c       | 4 +++-
 drivers/net/ethernet/sfc/tx_common.c             | 4 +++-
 drivers/net/ethernet/sun/sunvnet_common.c        | 4 +++-
 drivers/net/wireguard/device.c                   | 5 ++++-
 net/core/dev.c                                   | 8 +++++---
 net/ipv4/ip_output.c                             | 3 ++-
 net/ipv4/tcp_offload.c                           | 3 ++-
 net/ipv6/ip6_output.c                            | 3 ++-
 net/mac80211/tx.c                                | 4 +++-
 net/netfilter/nfnetlink_queue.c                  | 5 ++++-
 net/nsh/nsh.c                                    | 8 ++++++--
 net/openvswitch/datapath.c                       | 6 +++++-
 net/sched/sch_cake.c                             | 3 ++-
 net/sched/sch_netem.c                            | 3 ++-
 net/sched/sch_taprio.c                           | 3 ++-
 net/sched/sch_tbf.c                              | 3 ++-
 net/sctp/offload.c                               | 9 +++++++--
 net/xfrm/xfrm_device.c                           | 3 ++-
 net/xfrm/xfrm_output.c                           | 5 ++++-
 22 files changed, 70 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 153d51c7ffbf..c9f784ba26eb 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7860,6 +7860,7 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 {
 	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
 	struct sk_buff *segs, *seg, *next;
+	netdev_features_t features;
 
 	/* Estimate the number of fragments in the worst case */
 	if (unlikely(tg3_tx_avail(tnapi) <= frag_cnt_est)) {
@@ -7877,8 +7878,8 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		netif_tx_wake_queue(txq);
 	}
 
-	segs = skb_gso_segment(skb, tp->dev->features &
-				    ~netdev_general_tso_features);
+	features = tp->dev->features & ~netdev_general_tso_features;
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 8873cdcadb0f..96b437f01afe 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2894,10 +2894,12 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 {
 	struct sk_buff *segs, *curr, *next;
 	struct myri10ge_priv *mgp = netdev_priv(dev);
+	netdev_features_t features = dev->features;
 	struct myri10ge_slice_state *ss;
 	netdev_tx_t status;
 
-	segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO6);
+	features &= ~NETIF_F_TSO6;
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs))
 		goto drop;
 
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 331af932e56d..36db05a3fb03 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -11,6 +11,7 @@
 #define EFX_NET_DRIVER_H
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index 93a32d61944f..58d87add9a46 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -432,8 +432,10 @@ int efx_siena_tx_tso_fallback(struct efx_tx_queue *tx_queue,
 			      struct sk_buff *skb)
 {
 	struct sk_buff *segments, *next;
+	netdev_features_t feats;
 
-	segments = skb_gso_segment(skb, 0);
+	netdev_features_zero(feats);
+	segments = skb_gso_segment(skb, feats);
 	if (IS_ERR(segments))
 		return PTR_ERR(segments);
 
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 67e789b96c43..14fa2c65fc25 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -449,8 +449,10 @@ unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
 int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 {
 	struct sk_buff *segments, *next;
+	netdev_features_t feats;
 
-	segments = skb_gso_segment(skb, 0);
+	netdev_features_zero(feats);
+	segments = skb_gso_segment(skb, feats);
 	if (IS_ERR(segments))
 		return PTR_ERR(segments);
 
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 80fde5f06fce..f8aced92d2a9 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1228,6 +1228,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 	int status;
 	int gso_size, gso_type, gso_segs;
 	int hlen = skb_transport_header(skb) - skb_mac_header(skb);
+	netedv_features_t features = dev->features;
 	int proto = IPPROTO_IP;
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -1274,7 +1275,8 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_size = datalen;
 		skb_shinfo(skb)->gso_segs = gso_segs;
 	}
-	segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
+	features &= ~NETIF_F_TSO;
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs))
 		goto out_dropped;
 
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 87a1675843ce..a6e25e8c2c91 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -176,8 +176,11 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!skb_is_gso(skb)) {
 		skb_mark_not_on_list(skb);
 	} else {
-		struct sk_buff *segs = skb_gso_segment(skb, 0);
+		netdev_features_t feats;
+		struct sk_buff *segs;
 
+		netdev_features_zero(feats);
+		segs = skb_gso_segment(skb, feats);
 		if (IS_ERR(segs)) {
 			ret = PTR_ERR(segs);
 			goto err_peer;
diff --git a/net/core/dev.c b/net/core/dev.c
index a53e5362cc89..5b5f53608331 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3394,11 +3394,13 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * work.
 	 */
 	if (features & NETIF_F_GSO_PARTIAL) {
-		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
+		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->features & dev->gso_partial_features;
-		if (!skb_gso_ok(skb, features | partial_features))
+		partial_features = dev->features & dev->gso_partial_features;
+		partial_features |= NETIF_F_GSO_ROBUST;
+		partial_features |= features;
+		if (!skb_gso_ok(skb, partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8201cd423ff9..3c6206e2e0f4 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -264,7 +264,8 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 */
 	features = netif_skb_features(skb);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	features &= ~NETIF_F_GSO_MASK;
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index a844a0d38482..a55e9729a438 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -82,7 +82,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb->len <= mss))
 		goto out;
 
-	if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
+	features |= NETIF_F_GSO_ROBUST;
+	if (skb_gso_ok(skb, features)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 
 		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(skb->len, mss);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index a60176e913a8..0663be2415fe 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -149,7 +149,8 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 * egress MTU.
 	 */
 	features = netif_skb_features(skb);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	features &= ~NETIF_F_GSO_MASK;
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1be8c9d83d6a..28ab258da6af 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4203,9 +4203,11 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	}
 
 	if (skb_is_gso(skb)) {
+		netdev_features_t feats;
 		struct sk_buff *segs;
 
-		segs = skb_gso_segment(skb, 0);
+		netdev_features_zero(feats);
+		segs = skb_gso_segment(skb, feats);
 		if (IS_ERR(segs)) {
 			goto out_free;
 		} else if (segs) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 87a9009d5234..32644cc2b153 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netfilter.h>
 #include <linux/proc_fs.h>
 #include <linux/netfilter_ipv4.h>
@@ -788,6 +789,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	int err = -ENOBUFS;
 	struct net *net = entry->state.net;
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+	netdev_features_t feats;
 
 	/* rcu_read_lock()ed by nf_hook_thresh */
 	queue = instance_lookup(q, queuenum);
@@ -812,7 +814,8 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		return __nfqnl_enqueue_packet(net, queue, entry);
 
 	nf_bridge_adjust_skb_data(skb);
-	segs = skb_gso_segment(skb, 0);
+	netdev_features_zero(feats);
+	segs = skb_gso_segment(skb, feats);
 	/* Does not use PTR_ERR to limit the number of error codes that can be
 	 * returned by nf_queue.  For instance, callers rely on -ESRCH to
 	 * mean 'ignore this hook'.
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index e9ca007718b7..1484394a7e4a 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <net/nsh.h>
 #include <net/tun_proto.h>
@@ -78,6 +79,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	unsigned int nsh_len, mac_len;
+	netdev_features_t feats;
 	__be16 proto;
 	int nhoff;
 
@@ -104,8 +106,10 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb->mac_len = proto == htons(ETH_P_TEB) ? ETH_HLEN : 0;
 	skb->protocol = proto;
 
-	features &= NETIF_F_SG;
-	segs = skb_mac_gso_segment(skb, features);
+	netdev_features_zero(feats);
+	if (features & NETIF_F_SG)
+		feats |= NETIF_F_SG;
+	segs = skb_mac_gso_segment(skb, feats);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
 				     skb->network_header - nhoff,
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c8a9075ddd0a..a7687f1f668f 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -27,6 +27,7 @@
 #include <linux/wait.h>
 #include <asm/div64.h>
 #include <linux/highmem.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/inetdevice.h>
@@ -328,10 +329,13 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 	unsigned int gso_type = skb_shinfo(skb)->gso_type;
 	struct sw_flow_key later_key;
 	struct sk_buff *segs, *nskb;
+	netdev_features_t features;
 	int err;
 
 	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = __skb_gso_segment(skb, NETIF_F_SG, false);
+	netdev_features_zero(features);
+	features |= NETIF_F_SG;
+	segs = __skb_gso_segment(skb, features, false);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
 	if (segs == NULL)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 36acc95d611e..7e7585a16f11 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1743,7 +1743,8 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		netdev_features_t features = netif_skb_features(skb);
 		unsigned int slen = 0, numsegs = 0;
 
-		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		features &= ~NETIF_F_GSO_MASK;
+		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index b70ac04110dd..72f99074ff58 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -415,7 +415,8 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 	struct sk_buff *segs;
 	netdev_features_t features = netif_skb_features(skb);
 
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	features &= ~NETIF_F_GSO_MASK;
+	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs)) {
 		qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index db88a692ef81..621ac3c6d505 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -463,7 +463,8 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		struct sk_buff *segs, *nskb;
 		int ret;
 
-		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		features &= ~NETIF_F_GSO_MASK;
+		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index e031c1a41ea6..9a114fd9de4d 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -210,7 +210,8 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
 	int ret, nb;
 
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	features &= ~NETIF_F_GSO_MASK;
+	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs))
 		return qdisc_drop(skb, sch, to_free);
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index eb874e3c399a..1433fcc0977d 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -39,6 +39,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	netdev_features_t tmp = features;
 	struct sctphdr *sh;
 
 	if (!skb_is_gso_sctp(skb))
@@ -50,7 +51,8 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 
 	__skb_pull(skb, sizeof(*sh));
 
-	if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
+	tmp |= NETIF_F_GSO_ROBUST;
+	if (skb_gso_ok(skb, tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 		struct skb_shared_info *pinfo = skb_shinfo(skb);
 		struct sk_buff *frag_iter;
@@ -68,7 +70,10 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 		goto out;
 	}
 
-	segs = skb_segment(skb, (features | NETIF_F_HW_CSUM) & ~NETIF_F_SG);
+	tmp = features;
+	tmp |= NETIF_F_HW_CSUM;
+	tmp &= ~NETIF_F_SG;
+	segs = skb_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto out;
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 637ca8838436..96ffd287ae9a 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -138,7 +138,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
-		esp_features = esp_features & ~(NETIF_F_HW_ESP | NETIF_F_GSO_ESP);
+		esp_features &= ~NETIF_F_HW_ESP;
+		esp_features &= ~NETIF_F_GSO_ESP;
 
 		segs = skb_gso_segment(skb, esp_features);
 		if (IS_ERR(segs)) {
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9a5e79a38c67..e986c4b64902 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -618,10 +619,12 @@ static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb)
 static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff *segs, *nskb;
+	netdev_features_t feats;
 
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
 	BUILD_BUG_ON(sizeof(*IP6CB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = skb_gso_segment(skb, 0);
+	netdev_features_zero(feats);
+	segs = skb_gso_segment(skb, feats);
 	kfree_skb(skb);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
-- 
2.33.0

