Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A36B27B019
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgI1OjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:39:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:59232 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgI1OjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:39:06 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kMuIw-0002dm-Vy; Mon, 28 Sep 2020 16:39:03 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH bpf-next v2 3/6] bpf: add redirect_neigh helper as redirect drop-in
Date:   Mon, 28 Sep 2020 16:38:54 +0200
Message-Id: <f4dec1d6d0fd9d79cf23bc4b54092f089e59f6b7.1601303057.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1601303057.git.daniel@iogearbox.net>
References: <cover.1601303057.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25940/Sun Sep 27 15:51:36 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a redirect_neigh() helper as redirect() drop-in replacement
for the xmit side. Main idea for the helper is to be very similar
in semantics to the latter just that the skb gets injected into
the neighboring subsystem in order to let the stack do the work
it knows best anyway to populate the L2 addresses of the packet
and then hand over to dev_queue_xmit() as redirect() does.

This solves two bigger items: i) skbs don't need to go up to the
stack on the host facing veth ingress side for traffic egressing
the container to achieve the same for populating L2 which also
has the huge advantage that ii) the skb->sk won't get orphaned in
ip_rcv_core() when entering the IP routing layer on the host stack.

Given that skb->sk neither gets orphaned when crossing the netns
as per 9c4c325252c5 ("skbuff: preserve sock reference when scrubbing
the skb.") the helper can then push the skbs directly to the phys
device where FQ scheduler can do its work and TCP stack gets proper
backpressure given we hold on to skb->sk as long as skb is still
residing in queues.

With the helper used in BPF data path to then push the skb to the
phys device, I observed a stable/consistent TCP_STREAM improvement
on veth devices for traffic going container -> host -> host ->
container from ~10Gbps to ~15Gbps for a single stream in my test
environment.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h         |   5 +
 include/uapi/linux/bpf.h       |  14 ++
 net/core/filter.c              | 255 +++++++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |  14 ++
 4 files changed, 275 insertions(+), 13 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 04a18e01b362..3d0cf3722bb4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2548,6 +2548,11 @@ static inline int skb_mac_header_was_set(const struct sk_buff *skb)
 	return skb->mac_header != (typeof(skb->mac_header))~0U;
 }
 
+static inline void skb_unset_mac_header(struct sk_buff *skb)
+{
+	skb->mac_header = (typeof(skb->mac_header))~0U;
+}
+
 static inline void skb_reset_mac_header(struct sk_buff *skb)
 {
 	skb->mac_header = skb->data - skb->head;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 88d5d900255c..c6582f729659 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3596,6 +3596,19 @@ union bpf_attr {
  * 		associated socket instead of the current process.
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
+ *
+ * long bpf_redirect_neigh(u32 ifindex, u64 flags)
+ * 	Description
+ * 		Redirect the packet to another net device of index *ifindex*
+ * 		and fill in L2 addresses from neighboring subsystem. This helper
+ * 		is somewhat similar to **bpf_redirect**\ (), except that it
+ * 		fills in e.g. MAC addresses based on the L3 information from
+ * 		the packet. This helper is supported for IPv4 and IPv6 protocols.
+ * 		The *flags* argument is reserved and must be 0. The helper is
+ * 		currently only supported for tc BPF program types.
+ * 	Return
+ * 		The helper returns **TC_ACT_REDIRECT** on success or
+ * 		**TC_ACT_SHOT** on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3748,6 +3761,7 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(skb_cgroup_classid),		\
+	FN(redirect_neigh),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index a0776e48dcc9..64c6e5ec97d7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2163,6 +2163,204 @@ static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
 		return __bpf_redirect_no_mac(skb, dev, flags);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = dst->dev;
+	const struct in6_addr *nexthop;
+	struct neighbour *neigh;
+
+	if (dev_xmit_recursion())
+		goto out_rec;
+	skb->dev = dev;
+	rcu_read_lock_bh();
+	nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
+			      &ipv6_hdr(skb)->daddr);
+	neigh = ip_neigh_gw6(dev, nexthop);
+	if (likely(!IS_ERR(neigh))) {
+		int ret;
+
+		sock_confirm_neigh(skb, neigh);
+		dev_xmit_recursion_inc();
+		ret = neigh_output(neigh, skb, false);
+		dev_xmit_recursion_dec();
+		rcu_read_unlock_bh();
+		return ret;
+	}
+	rcu_read_unlock_bh();
+	IP6_INC_STATS(dev_net(dst->dev),
+		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+out_drop:
+	kfree_skb(skb);
+	return -EINVAL;
+out_rec:
+	net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
+	goto out_drop;
+}
+
+static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	struct net *net = dev_net(dev);
+	int err, ret = NET_XMIT_DROP;
+	struct flowi6 fl6 = {
+		.flowi6_flags	= FLOWI_FLAG_ANYSRC,
+		.flowi6_mark	= skb->mark,
+		.flowlabel	= ip6_flowinfo(ip6h),
+		.flowi6_proto	= ip6h->nexthdr,
+		.flowi6_oif	= dev->ifindex,
+		.daddr		= ip6h->daddr,
+		.saddr		= ip6h->saddr,
+	};
+	struct dst_entry *dst;
+
+	skb->dev = dev;
+	skb->tstamp = 0;
+
+	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
+	if (IS_ERR(dst))
+		goto out_drop;
+
+	skb_dst_set(skb, dst);
+
+	err = bpf_out_neigh_v6(net, skb);
+	if (unlikely(net_xmit_eval(err)))
+		dev->stats.tx_errors++;
+	else
+		ret = NET_XMIT_SUCCESS;
+	goto out_xmit;
+out_drop:
+	dev->stats.tx_errors++;
+	kfree_skb(skb);
+out_xmit:
+	return ret;
+}
+#else
+static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
+{
+	kfree_skb(skb);
+	return NET_XMIT_DROP;
+}
+#endif /* CONFIG_IPV6 */
+
+#if IS_ENABLED(CONFIG_INET)
+static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct rtable *rt = container_of(dst, struct rtable, dst);
+	struct net_device *dev = dst->dev;
+	u32 hh_len = LL_RESERVED_SPACE(dev);
+	struct neighbour *neigh;
+	bool is_v6gw = false;
+
+	if (dev_xmit_recursion())
+		goto out_rec;
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		struct sk_buff *skb2;
+
+		skb2 = skb_realloc_headroom(skb, hh_len);
+		if (!skb2) {
+			kfree_skb(skb);
+			return -ENOMEM;
+		}
+		if (skb->sk)
+			skb_set_owner_w(skb2, skb->sk);
+		consume_skb(skb);
+		skb = skb2;
+	}
+	rcu_read_lock_bh();
+	neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
+	if (likely(!IS_ERR(neigh))) {
+		int ret;
+
+		sock_confirm_neigh(skb, neigh);
+		dev_xmit_recursion_inc();
+		ret = neigh_output(neigh, skb, is_v6gw);
+		dev_xmit_recursion_dec();
+		rcu_read_unlock_bh();
+		return ret;
+	}
+	rcu_read_unlock_bh();
+out_drop:
+	kfree_skb(skb);
+	return -EINVAL;
+out_rec:
+	net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
+	goto out_drop;
+}
+
+static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev)
+{
+	const struct iphdr *ip4h = ip_hdr(skb);
+	struct net *net = dev_net(dev);
+	int err, ret = NET_XMIT_DROP;
+	struct flowi4 fl4 = {
+		.flowi4_flags	= FLOWI_FLAG_ANYSRC,
+		.flowi4_mark	= skb->mark,
+		.flowi4_tos	= RT_TOS(ip4h->tos),
+		.flowi4_oif	= dev->ifindex,
+		.daddr		= ip4h->daddr,
+		.saddr		= ip4h->saddr,
+	};
+	struct rtable *rt;
+
+	skb->dev = dev;
+	skb->tstamp = 0;
+
+	rt = ip_route_output_flow(net, &fl4, NULL);
+	if (IS_ERR(rt))
+		goto out_drop;
+	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
+		ip_rt_put(rt);
+		goto out_drop;
+	}
+
+	skb_dst_set(skb, &rt->dst);
+
+	err = bpf_out_neigh_v4(net, skb);
+	if (unlikely(net_xmit_eval(err)))
+		dev->stats.tx_errors++;
+	else
+		ret = NET_XMIT_SUCCESS;
+	goto out_xmit;
+out_drop:
+	dev->stats.tx_errors++;
+	kfree_skb(skb);
+out_xmit:
+	return ret;
+}
+#else
+static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev)
+{
+	kfree_skb(skb);
+	return NET_XMIT_DROP;
+}
+#endif /* CONFIG_INET */
+
+static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
+{
+	struct ethhdr *ethh = eth_hdr(skb);
+
+	if (unlikely(skb->mac_header >= skb->network_header))
+		goto out;
+	bpf_push_mac_rcsum(skb);
+	if (is_multicast_ether_addr(ethh->h_dest))
+		goto out;
+
+	skb_pull(skb, sizeof(*ethh));
+	skb_unset_mac_header(skb);
+	skb_reset_network_header(skb);
+
+	if (skb->protocol == htons(ETH_P_IP))
+		return __bpf_redirect_neigh_v4(skb, dev);
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		return __bpf_redirect_neigh_v6(skb, dev);
+out:
+	kfree_skb(skb);
+	return -ENOTSUPP;
+}
+
 BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
 {
 	struct net_device *dev;
@@ -2206,23 +2404,16 @@ static const struct bpf_func_proto bpf_clone_redirect_proto = {
 DEFINE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
 EXPORT_PER_CPU_SYMBOL_GPL(bpf_redirect_info);
 
-BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
-{
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-
-	if (unlikely(flags & ~(BPF_F_INGRESS)))
-		return TC_ACT_SHOT;
-
-	ri->flags = flags;
-	ri->tgt_index = ifindex;
-
-	return TC_ACT_REDIRECT;
-}
+/* Internal, non-exposed redirect flags. */
+enum {
+	BPF_F_NEIGH = (1ULL << 1),
+};
 
 int skb_do_redirect(struct sk_buff *skb)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	struct net_device *dev;
+	u32 flags = ri->flags;
 
 	dev = dev_get_by_index_rcu(dev_net(skb->dev), ri->tgt_index);
 	ri->tgt_index = 0;
@@ -2231,7 +2422,22 @@ int skb_do_redirect(struct sk_buff *skb)
 		return -EINVAL;
 	}
 
-	return __bpf_redirect(skb, dev, ri->flags);
+	return flags & BPF_F_NEIGH ?
+	       __bpf_redirect_neigh(skb, dev) :
+	       __bpf_redirect(skb, dev, flags);
+}
+
+BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	if (unlikely(flags & ~(BPF_F_INGRESS)))
+		return TC_ACT_SHOT;
+
+	ri->flags = flags;
+	ri->tgt_index = ifindex;
+
+	return TC_ACT_REDIRECT;
 }
 
 static const struct bpf_func_proto bpf_redirect_proto = {
@@ -2242,6 +2448,27 @@ static const struct bpf_func_proto bpf_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_2(bpf_redirect_neigh, u32, ifindex, u64, flags)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	if (unlikely(flags))
+		return TC_ACT_SHOT;
+
+	ri->flags = BPF_F_NEIGH;
+	ri->tgt_index = ifindex;
+
+	return TC_ACT_REDIRECT;
+}
+
+static const struct bpf_func_proto bpf_redirect_neigh_proto = {
+	.func		= bpf_redirect_neigh,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_2(bpf_msg_apply_bytes, struct sk_msg *, msg, u32, bytes)
 {
 	msg->apply_bytes = bytes;
@@ -6759,6 +6986,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return bpf_get_skb_set_tunnel_proto(func_id);
 	case BPF_FUNC_redirect:
 		return &bpf_redirect_proto;
+	case BPF_FUNC_redirect_neigh:
+		return &bpf_redirect_neigh_proto;
 	case BPF_FUNC_get_route_realm:
 		return &bpf_get_route_realm_proto;
 	case BPF_FUNC_get_hash_recalc:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 88d5d900255c..c6582f729659 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3596,6 +3596,19 @@ union bpf_attr {
  * 		associated socket instead of the current process.
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
+ *
+ * long bpf_redirect_neigh(u32 ifindex, u64 flags)
+ * 	Description
+ * 		Redirect the packet to another net device of index *ifindex*
+ * 		and fill in L2 addresses from neighboring subsystem. This helper
+ * 		is somewhat similar to **bpf_redirect**\ (), except that it
+ * 		fills in e.g. MAC addresses based on the L3 information from
+ * 		the packet. This helper is supported for IPv4 and IPv6 protocols.
+ * 		The *flags* argument is reserved and must be 0. The helper is
+ * 		currently only supported for tc BPF program types.
+ * 	Return
+ * 		The helper returns **TC_ACT_REDIRECT** on success or
+ * 		**TC_ACT_SHOT** on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3748,6 +3761,7 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(skb_cgroup_classid),		\
+	FN(redirect_neigh),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.21.0

