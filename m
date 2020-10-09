Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BD82899E0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390607AbgJIUmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:42:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:39468 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388544AbgJIUmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:42:53 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQzE1-00084o-G5; Fri, 09 Oct 2020 22:42:49 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 2/6] bpf: add redirect_peer helper
Date:   Fri,  9 Oct 2020 22:42:41 +0200
Message-Id: <20201009204245.27905-3-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201009204245.27905-1-daniel@iogearbox.net>
References: <20201009204245.27905-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an efficient ingress to ingress netns switch that can be used out of tc BPF
programs in order to redirect traffic from host ns ingress into a container
veth device ingress without having to go via CPU backlog queue [0]. For local
containers this can also be utilized and path via CPU backlog queue only needs
to be taken once, not twice. On a high level this borrows from ipvlan which does
similar switch in __netif_receive_skb_core() and then iterates via another_round.
This helps to reduce latency for mentioned use cases.

Pod to remote pod with redirect(), TCP_RR [1]:

  # percpu_netperf 10.217.1.33
          RT_LATENCY:         122.450         (per CPU:         122.666         122.401         122.333         122.401 )
        MEAN_LATENCY:         121.210         (per CPU:         121.100         121.260         121.320         121.160 )
      STDDEV_LATENCY:         120.040         (per CPU:         119.420         119.910         125.460         115.370 )
         MIN_LATENCY:          46.500         (per CPU:          47.000          47.000          47.000          45.000 )
         P50_LATENCY:         118.500         (per CPU:         118.000         119.000         118.000         119.000 )
         P90_LATENCY:         127.500         (per CPU:         127.000         128.000         127.000         128.000 )
         P99_LATENCY:         130.750         (per CPU:         131.000         131.000         129.000         132.000 )

    TRANSACTION_RATE:       32666.400         (per CPU:        8152.200        8169.842        8174.439        8169.897 )

Pod to remote pod with redirect_peer(), TCP_RR:

  # percpu_netperf 10.217.1.33
          RT_LATENCY:          44.449         (per CPU:          43.767          43.127          45.279          45.622 )
        MEAN_LATENCY:          45.065         (per CPU:          44.030          45.530          45.190          45.510 )
      STDDEV_LATENCY:          84.823         (per CPU:          66.770          97.290          84.380          90.850 )
         MIN_LATENCY:          33.500         (per CPU:          33.000          33.000          34.000          34.000 )
         P50_LATENCY:          43.250         (per CPU:          43.000          43.000          43.000          44.000 )
         P90_LATENCY:          46.750         (per CPU:          46.000          47.000          47.000          47.000 )
         P99_LATENCY:          52.750         (per CPU:          51.000          54.000          53.000          53.000 )

    TRANSACTION_RATE:       90039.500         (per CPU:       22848.186       23187.089       22085.077       21919.130 )

  [0] https://linuxplumbersconf.org/event/7/contributions/674/attachments/568/1002/plumbers_2020_cilium_load_balancer.pdf
  [1] https://github.com/borkmann/netperf_scripts/blob/master/percpu_netperf

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 drivers/net/veth.c             |  9 ++++++
 include/linux/netdevice.h      |  4 +++
 include/uapi/linux/bpf.h       | 17 +++++++++++
 net/core/dev.c                 | 15 ++++++++--
 net/core/filter.c              | 54 +++++++++++++++++++++++++++++-----
 tools/include/uapi/linux/bpf.h | 17 +++++++++++
 6 files changed, 106 insertions(+), 10 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 091e5b4ba042..8c737668008a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -420,6 +420,14 @@ static int veth_select_rxq(struct net_device *dev)
 	return smp_processor_id() % dev->real_num_rx_queues;
 }
 
+static struct net_device *veth_peer_dev(struct net_device *dev)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+
+	/* Callers must be under RCU read side. */
+	return rcu_dereference(priv->peer);
+}
+
 static int veth_xdp_xmit(struct net_device *dev, int n,
 			 struct xdp_frame **frames,
 			 u32 flags, bool ndo_xmit)
@@ -1224,6 +1232,7 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_set_rx_headroom	= veth_set_rx_headroom,
 	.ndo_bpf		= veth_xdp,
 	.ndo_xdp_xmit		= veth_ndo_xdp_xmit,
+	.ndo_get_peer_dev	= veth_peer_dev,
 };
 
 #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28cfa53daf72..0533f86018dd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1277,6 +1277,9 @@ struct netdev_net_notifier {
  * int (*ndo_tunnel_ctl)(struct net_device *dev, struct ip_tunnel_parm *p,
  *			 int cmd);
  *	Add, change, delete or get information on an IPv4 tunnel.
+ * struct net_device *(*ndo_get_peer_dev)(struct net_device *dev);
+ *	If a device is paired with a peer device, return the peer instance.
+ *	The caller must be under RCU read context.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1484,6 +1487,7 @@ struct net_device_ops {
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
 	int			(*ndo_tunnel_ctl)(struct net_device *dev,
 						  struct ip_tunnel_parm *p, int cmd);
+	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
 };
 
 /**
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4272cc53d478..b97bc5abb3b8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3719,6 +3719,22 @@ union bpf_attr {
  *		never return NULL.
  *	Return
  *		A pointer pointing to the kernel percpu variable on this cpu.
+ *
+ * long bpf_redirect_peer(u32 ifindex, u64 flags)
+ * 	Description
+ * 		Redirect the packet to another net device of index *ifindex*.
+ * 		This helper is somewhat similar to **bpf_redirect**\ (), except
+ * 		that the redirection happens to the *ifindex*' peer device and
+ * 		the netns switch takes place from ingress to ingress without
+ * 		going through the CPU's backlog queue.
+ *
+ * 		The *flags* argument is reserved and must be 0. The helper is
+ * 		currently only supported for tc BPF program types at the ingress
+ * 		hook and for veth device types. The peer device must reside in a
+ * 		different network namespace.
+ * 	Return
+ * 		The helper returns **TC_ACT_REDIRECT** on success or
+ * 		**TC_ACT_SHOT** on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3876,6 +3892,7 @@ union bpf_attr {
 	FN(redirect_neigh),		\
 	FN(bpf_per_cpu_ptr),            \
 	FN(bpf_this_cpu_ptr),		\
+	FN(redirect_peer),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/dev.c b/net/core/dev.c
index 9d55bf5d1a65..7dd015823593 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4930,7 +4930,7 @@ EXPORT_SYMBOL_GPL(br_fdb_test_addr_hook);
 
 static inline struct sk_buff *
 sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
-		   struct net_device *orig_dev)
+		   struct net_device *orig_dev, bool *another)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
@@ -4974,7 +4974,11 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		 * redirecting to another netdev
 		 */
 		__skb_push(skb, skb->mac_len);
-		skb_do_redirect(skb);
+		if (skb_do_redirect(skb) == -EAGAIN) {
+			__skb_pull(skb, skb->mac_len);
+			*another = true;
+			break;
+		}
 		return NULL;
 	case TC_ACT_CONSUMED:
 		return NULL;
@@ -5163,7 +5167,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 skip_taps:
 #ifdef CONFIG_NET_INGRESS
 	if (static_branch_unlikely(&ingress_needed_key)) {
-		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev);
+		bool another = false;
+
+		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev,
+					 &another);
+		if (another)
+			goto another_round;
 		if (!skb)
 			goto out;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 5da44b11e1ec..fab951c6be57 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2380,8 +2380,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
 
 /* Internal, non-exposed redirect flags. */
 enum {
-	BPF_F_NEIGH = (1ULL << 1),
-#define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH)
+	BPF_F_NEIGH	= (1ULL << 1),
+	BPF_F_PEER	= (1ULL << 2),
+#define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH | BPF_F_PEER)
 };
 
 BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
@@ -2430,19 +2431,35 @@ EXPORT_PER_CPU_SYMBOL_GPL(bpf_redirect_info);
 int skb_do_redirect(struct sk_buff *skb)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	struct net *net = dev_net(skb->dev);
 	struct net_device *dev;
 	u32 flags = ri->flags;
 
-	dev = dev_get_by_index_rcu(dev_net(skb->dev), ri->tgt_index);
+	dev = dev_get_by_index_rcu(net, ri->tgt_index);
 	ri->tgt_index = 0;
-	if (unlikely(!dev)) {
-		kfree_skb(skb);
-		return -EINVAL;
+	ri->flags = 0;
+	if (unlikely(!dev))
+		goto out_drop;
+	if (flags & BPF_F_PEER) {
+		const struct net_device_ops *ops = dev->netdev_ops;
+
+		if (unlikely(!ops->ndo_get_peer_dev ||
+			     !skb_at_tc_ingress(skb)))
+			goto out_drop;
+		dev = ops->ndo_get_peer_dev(dev);
+		if (unlikely(!dev ||
+			     !is_skb_forwardable(dev, skb) ||
+			     net_eq(net, dev_net(dev))))
+			goto out_drop;
+		skb->dev = dev;
+		return -EAGAIN;
 	}
-
 	return flags & BPF_F_NEIGH ?
 	       __bpf_redirect_neigh(skb, dev) :
 	       __bpf_redirect(skb, dev, flags);
+out_drop:
+	kfree_skb(skb);
+	return -EINVAL;
 }
 
 BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
@@ -2466,6 +2483,27 @@ static const struct bpf_func_proto bpf_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_2(bpf_redirect_peer, u32, ifindex, u64, flags)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	if (unlikely(flags))
+		return TC_ACT_SHOT;
+
+	ri->flags = BPF_F_PEER;
+	ri->tgt_index = ifindex;
+
+	return TC_ACT_REDIRECT;
+}
+
+static const struct bpf_func_proto bpf_redirect_peer_proto = {
+	.func           = bpf_redirect_peer,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_ANYTHING,
+	.arg2_type      = ARG_ANYTHING,
+};
+
 BPF_CALL_2(bpf_redirect_neigh, u32, ifindex, u64, flags)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
@@ -7053,6 +7091,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_redirect_proto;
 	case BPF_FUNC_redirect_neigh:
 		return &bpf_redirect_neigh_proto;
+	case BPF_FUNC_redirect_peer:
+		return &bpf_redirect_peer_proto;
 	case BPF_FUNC_get_route_realm:
 		return &bpf_get_route_realm_proto;
 	case BPF_FUNC_get_hash_recalc:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4272cc53d478..b97bc5abb3b8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3719,6 +3719,22 @@ union bpf_attr {
  *		never return NULL.
  *	Return
  *		A pointer pointing to the kernel percpu variable on this cpu.
+ *
+ * long bpf_redirect_peer(u32 ifindex, u64 flags)
+ * 	Description
+ * 		Redirect the packet to another net device of index *ifindex*.
+ * 		This helper is somewhat similar to **bpf_redirect**\ (), except
+ * 		that the redirection happens to the *ifindex*' peer device and
+ * 		the netns switch takes place from ingress to ingress without
+ * 		going through the CPU's backlog queue.
+ *
+ * 		The *flags* argument is reserved and must be 0. The helper is
+ * 		currently only supported for tc BPF program types at the ingress
+ * 		hook and for veth device types. The peer device must reside in a
+ * 		different network namespace.
+ * 	Return
+ * 		The helper returns **TC_ACT_REDIRECT** on success or
+ * 		**TC_ACT_SHOT** on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3876,6 +3892,7 @@ union bpf_attr {
 	FN(redirect_neigh),		\
 	FN(bpf_per_cpu_ptr),            \
 	FN(bpf_this_cpu_ptr),		\
+	FN(redirect_peer),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.17.1

