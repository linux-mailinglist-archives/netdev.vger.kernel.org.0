Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D188D28F615
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389770AbgJOPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:46:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389693AbgJOPq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602776814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vx9aQYubZ4LFkrPuA7E8/fqIUZ9jky3v5t7ct4oHSyQ=;
        b=IDW1AkhVB8IBRkf5cIOD+RK7jcS54MHC3cx/Qcf7B70wxz6TOcpZ5598fqWbbOIaI8F1WP
        XMlqHu4lMUrXc7p9oFZ9b7pe5iNCgcDjKAWosROuVVR2wUiGPz5a0LUmyHPrJG0LH4/IOf
        UxirSF5v14uvVdYwKEqXEP3Pp7ZjTvU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-PggyD3LLOAqJJf0Gj58_8w-1; Thu, 15 Oct 2020 11:46:52 -0400
X-MC-Unique: PggyD3LLOAqJJf0Gj58_8w-1
Received: by mail-qt1-f200.google.com with SMTP id d22so2206960qtn.0
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vx9aQYubZ4LFkrPuA7E8/fqIUZ9jky3v5t7ct4oHSyQ=;
        b=fUl1AudhnLoR7lLQCmAy5U75SsnEvj0du3gdYXCBLZEERVfW0fvcsfBoHhD+8OJJsH
         TVQcNLdeqCNWIsTj3bSSrLtqICfKhChwsE9EG1fMQjTR/r8POsR4K5UB+TSSiPu7jnwE
         mwu/YrWxSEhppSxQsCcrqGavBLZoQ6HRRcc+xGImsus24bl9EQNCSeSjJndERSkbaMe2
         /A8jGZTMsWL8m2cNKaYgWrT5+VesROtxbPJy6nbOfUmqH0xqthZhh+Jq0PdVCWvoER43
         2q/T3OzcDaHaYAMx5lrNMO8UsMJjDre6BWcE9T6/2sHErgRAiYXLdCCcWnDi5JtXDaYB
         f44g==
X-Gm-Message-State: AOAM533Fv5roq58Wsu4wtDWeprMjAECHUpAECxOhZXDouyGa2cO6BJTh
        buf7Ex28p9hll+bXgUaTF+ukI0hx+1g1zl9V2G2TbzCJtrszixFxoCK8w2RBPRLjNYWLrCbZsam
        NGxkta7VaeqtGB8Yx
X-Received: by 2002:ac8:1c1b:: with SMTP id a27mr4830360qtk.157.1602776811883;
        Thu, 15 Oct 2020 08:46:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl/FYp601RI0rkdV0j5+GeEXBgs24O/7EBXFa0TxNjpHey7YTPK7am8x8r7fyC8h+UgVDcWg==
X-Received: by 2002:ac8:1c1b:: with SMTP id a27mr4830305qtk.157.1602776811256;
        Thu, 15 Oct 2020 08:46:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x43sm1347334qtx.40.2020.10.15.08.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 08:46:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B17F31838E4; Thu, 15 Oct 2020 17:46:48 +0200 (CEST)
Subject: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 15 Oct 2020 17:46:48 +0200
Message-ID: <160277680864.157904.8719768977907736015.stgit@toke.dk>
In-Reply-To: <160277680746.157904.8726318184090980429.stgit@toke.dk>
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Based on the discussion in [0], update the bpf_redirect_neigh() helper to
accept an optional parameter specifying the nexthop information. This makes
it possible to combine bpf_fib_lookup() and bpf_redirect_neigh() without
incurring a duplicate FIB lookup - since the FIB lookup helper will return
the nexthop information even if no neighbour is present, this can simply be
passed on to bpf_redirect_neigh() if bpf_fib_lookup() returns
BPF_FIB_LKUP_RET_NO_NEIGH.

[0] https://lore.kernel.org/bpf/393e17fc-d187-3a8d-2f0d-a627c7c63fca@iogearbox.net/

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/filter.h         |    9 ++
 include/uapi/linux/bpf.h       |   23 +++++-
 net/core/filter.c              |  152 +++++++++++++++++++++++++---------------
 scripts/bpf_helpers_doc.py     |    1 
 tools/include/uapi/linux/bpf.h |   23 +++++-
 5 files changed, 143 insertions(+), 65 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 20fc24c9779a..ba9de7188cd0 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -607,12 +607,21 @@ struct bpf_skb_data_end {
 	void *data_end;
 };
 
+struct bpf_nh_params {
+	u8 nh_family;
+	union {
+		__u32 ipv4_nh;
+		struct in6_addr ipv6_nh;
+	};
+};
+
 struct bpf_redirect_info {
 	u32 flags;
 	u32 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
 	u32 kern_flags;
+	struct bpf_nh_params nh;
 };
 
 DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bf5a99d803e4..980cc1363be8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3677,15 +3677,19 @@ union bpf_attr {
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
  *
- * long bpf_redirect_neigh(u32 ifindex, u64 flags)
+ * long bpf_redirect_neigh(u32 ifindex, struct bpf_redir_neigh *params, int plen, u64 flags)
  * 	Description
  * 		Redirect the packet to another net device of index *ifindex*
  * 		and fill in L2 addresses from neighboring subsystem. This helper
  * 		is somewhat similar to **bpf_redirect**\ (), except that it
  * 		populates L2 addresses as well, meaning, internally, the helper
- * 		performs a FIB lookup based on the skb's networking header to
- * 		get the address of the next hop and then relies on the neighbor
- * 		lookup for the L2 address of the nexthop.
+ * 		relies on the neighbor lookup for the L2 address of the nexthop.
+ *
+ * 		The helper will perform a FIB lookup based on the skb's
+ * 		networking header to get the address of the next hop, unless
+ * 		this is supplied by the caller in the *params* argument. The
+ * 		*plen* argument indicates the len of *params* and should be set
+ * 		to 0 if *params* is NULL.
  *
  * 		The *flags* argument is reserved and must be 0. The helper is
  * 		currently only supported for tc BPF program types, and enabled
@@ -4906,6 +4910,17 @@ struct bpf_fib_lookup {
 	__u8	dmac[6];     /* ETH_ALEN */
 };
 
+struct bpf_redir_neigh {
+	/* network family for lookup (AF_INET, AF_INET6)
+	 */
+	__u8	nh_family;
+	/* network address of nexthop; skips fib lookup to find gateway */
+	union {
+		__be32		ipv4_nh;
+		__u32		ipv6_nh[4];  /* in6_addr; network order */
+	};
+};
+
 enum bpf_task_fd_type {
 	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
 	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
diff --git a/net/core/filter.c b/net/core/filter.c
index c5e2a1c5fd8d..d073031a3a61 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2165,12 +2165,11 @@ static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
+static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
+			    struct net_device *dev, const struct in6_addr *nexthop)
 {
-	struct dst_entry *dst = skb_dst(skb);
-	struct net_device *dev = dst->dev;
 	u32 hh_len = LL_RESERVED_SPACE(dev);
-	const struct in6_addr *nexthop;
+	struct dst_entry *dst = NULL;
 	struct neighbour *neigh;
 
 	if (dev_xmit_recursion()) {
@@ -2196,8 +2195,11 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
 	}
 
 	rcu_read_lock_bh();
-	nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
-			      &ipv6_hdr(skb)->daddr);
+	if (!nexthop) {
+		dst = skb_dst(skb);
+		nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
+				      &ipv6_hdr(skb)->daddr);
+	}
 	neigh = ip_neigh_gw6(dev, nexthop);
 	if (likely(!IS_ERR(neigh))) {
 		int ret;
@@ -2210,36 +2212,46 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
 		return ret;
 	}
 	rcu_read_unlock_bh();
-	IP6_INC_STATS(dev_net(dst->dev),
-		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+	if (dst)
+		IP6_INC_STATS(dev_net(dst->dev),
+			      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 out_drop:
 	kfree_skb(skb);
 	return -ENETDOWN;
 }
 
-static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
+static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
+				   struct bpf_nh_params *nh)
 {
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	struct in6_addr *nexthop = NULL;
 	struct net *net = dev_net(dev);
 	int err, ret = NET_XMIT_DROP;
-	struct dst_entry *dst;
-	struct flowi6 fl6 = {
-		.flowi6_flags	= FLOWI_FLAG_ANYSRC,
-		.flowi6_mark	= skb->mark,
-		.flowlabel	= ip6_flowinfo(ip6h),
-		.flowi6_oif	= dev->ifindex,
-		.flowi6_proto	= ip6h->nexthdr,
-		.daddr		= ip6h->daddr,
-		.saddr		= ip6h->saddr,
-	};
 
-	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
-	if (IS_ERR(dst))
-		goto out_drop;
+	if (!nh->nh_family) {
+		struct dst_entry *dst;
+		struct flowi6 fl6 = {
+			.flowi6_flags = FLOWI_FLAG_ANYSRC,
+			.flowi6_mark = skb->mark,
+			.flowlabel = ip6_flowinfo(ip6h),
+			.flowi6_oif = dev->ifindex,
+			.flowi6_proto = ip6h->nexthdr,
+			.daddr = ip6h->daddr,
+			.saddr = ip6h->saddr,
+		};
+
+		dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
+		if (IS_ERR(dst))
+			goto out_drop;
 
-	skb_dst_set(skb, dst);
+		skb_dst_set(skb, dst);
+	} else if (nh->nh_family == AF_INET6) {
+		nexthop = &nh->ipv6_nh;
+	} else {
+		goto out_drop;
+	}
 
-	err = bpf_out_neigh_v6(net, skb);
+	err = bpf_out_neigh_v6(net, skb, dev, nexthop);
 	if (unlikely(net_xmit_eval(err)))
 		dev->stats.tx_errors++;
 	else
@@ -2260,11 +2272,9 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev)
 #endif /* CONFIG_IPV6 */
 
 #if IS_ENABLED(CONFIG_INET)
-static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
+static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
+			    struct net_device *dev, struct bpf_nh_params *nh)
 {
-	struct dst_entry *dst = skb_dst(skb);
-	struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net_device *dev = dst->dev;
 	u32 hh_len = LL_RESERVED_SPACE(dev);
 	struct neighbour *neigh;
 	bool is_v6gw = false;
@@ -2292,7 +2302,20 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
 	}
 
 	rcu_read_lock_bh();
-	neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
+	if (!nh) {
+		struct dst_entry *dst = skb_dst(skb);
+		struct rtable *rt = container_of(dst, struct rtable, dst);
+
+		neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
+	} else if (nh->nh_family == AF_INET6) {
+		neigh = ip_neigh_gw6(dev, &nh->ipv6_nh);
+		is_v6gw = true;
+	} else if (nh->nh_family == AF_INET) {
+		neigh = ip_neigh_gw4(dev, nh->ipv4_nh);
+	} else {
+		goto out_drop;
+	}
+
 	if (likely(!IS_ERR(neigh))) {
 		int ret;
 
@@ -2309,33 +2332,38 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
 	return -ENETDOWN;
 }
 
-static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev)
+static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
+				   struct bpf_nh_params *nh)
 {
 	const struct iphdr *ip4h = ip_hdr(skb);
 	struct net *net = dev_net(dev);
 	int err, ret = NET_XMIT_DROP;
-	struct rtable *rt;
-	struct flowi4 fl4 = {
-		.flowi4_flags	= FLOWI_FLAG_ANYSRC,
-		.flowi4_mark	= skb->mark,
-		.flowi4_tos	= RT_TOS(ip4h->tos),
-		.flowi4_oif	= dev->ifindex,
-		.flowi4_proto	= ip4h->protocol,
-		.daddr		= ip4h->daddr,
-		.saddr		= ip4h->saddr,
-	};
 
-	rt = ip_route_output_flow(net, &fl4, NULL);
-	if (IS_ERR(rt))
-		goto out_drop;
-	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
-		ip_rt_put(rt);
-		goto out_drop;
-	}
+	if (!nh->nh_family) {
+		struct rtable *rt;
+		struct flowi4 fl4 = {
+			.flowi4_flags = FLOWI_FLAG_ANYSRC,
+			.flowi4_mark = skb->mark,
+			.flowi4_tos = RT_TOS(ip4h->tos),
+			.flowi4_oif = dev->ifindex,
+			.flowi4_proto = ip4h->protocol,
+			.daddr = ip4h->daddr,
+			.saddr = ip4h->saddr,
+		};
+
+		rt = ip_route_output_flow(net, &fl4, NULL);
+		if (IS_ERR(rt))
+			goto out_drop;
+		if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
+			ip_rt_put(rt);
+			goto out_drop;
+		}
 
-	skb_dst_set(skb, &rt->dst);
+		skb_dst_set(skb, &rt->dst);
+		nh = NULL;
+	}
 
-	err = bpf_out_neigh_v4(net, skb);
+	err = bpf_out_neigh_v4(net, skb, dev, nh);
 	if (unlikely(net_xmit_eval(err)))
 		dev->stats.tx_errors++;
 	else
@@ -2355,7 +2383,8 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev)
 }
 #endif /* CONFIG_INET */
 
-static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
+static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
+				struct bpf_nh_params *nh)
 {
 	struct ethhdr *ethh = eth_hdr(skb);
 
@@ -2370,9 +2399,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
 	skb_reset_network_header(skb);
 
 	if (skb->protocol == htons(ETH_P_IP))
-		return __bpf_redirect_neigh_v4(skb, dev);
+		return __bpf_redirect_neigh_v4(skb, dev, nh);
 	else if (skb->protocol == htons(ETH_P_IPV6))
-		return __bpf_redirect_neigh_v6(skb, dev);
+		return __bpf_redirect_neigh_v6(skb, dev, nh);
 out:
 	kfree_skb(skb);
 	return -ENOTSUPP;
@@ -2455,8 +2484,8 @@ int skb_do_redirect(struct sk_buff *skb)
 		return -EAGAIN;
 	}
 	return flags & BPF_F_NEIGH ?
-	       __bpf_redirect_neigh(skb, dev) :
-	       __bpf_redirect(skb, dev, flags);
+		__bpf_redirect_neigh(skb, dev, &ri->nh) :
+		__bpf_redirect(skb, dev, flags);
 out_drop:
 	kfree_skb(skb);
 	return -EINVAL;
@@ -2504,16 +2533,23 @@ static const struct bpf_func_proto bpf_redirect_peer_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
-BPF_CALL_2(bpf_redirect_neigh, u32, ifindex, u64, flags)
+BPF_CALL_4(bpf_redirect_neigh, u32, ifindex, struct bpf_redir_neigh *, params,
+	   int, plen, u64, flags)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
-	if (unlikely(flags))
+	if (unlikely((plen && plen < sizeof(*params)) || flags))
 		return TC_ACT_SHOT;
 
 	ri->flags = BPF_F_NEIGH;
 	ri->tgt_index = ifindex;
 
+	BUILD_BUG_ON(sizeof(struct bpf_redir_neigh) != sizeof(struct bpf_nh_params));
+	if (plen)
+		memcpy(&ri->nh, params, sizeof(ri->nh));
+	else
+		ri->nh.nh_family = 0; /* clear previous value */
+
 	return TC_ACT_REDIRECT;
 }
 
@@ -2522,7 +2558,9 @@ static const struct bpf_func_proto bpf_redirect_neigh_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type      = ARG_PTR_TO_MEM_OR_NULL,
+	.arg3_type      = ARG_CONST_SIZE_OR_ZERO,
+	.arg4_type	= ARG_ANYTHING,
 };
 
 BPF_CALL_2(bpf_msg_apply_bytes, struct sk_msg *, msg, u32, bytes)
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 7d86fdd190be..6769caae142f 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -453,6 +453,7 @@ class PrinterHelpers(Printer):
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_pidns_info',
+            'struct bpf_redir_neigh',
             'struct bpf_sk_lookup',
             'struct bpf_sock',
             'struct bpf_sock_addr',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bf5a99d803e4..980cc1363be8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3677,15 +3677,19 @@ union bpf_attr {
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
  *
- * long bpf_redirect_neigh(u32 ifindex, u64 flags)
+ * long bpf_redirect_neigh(u32 ifindex, struct bpf_redir_neigh *params, int plen, u64 flags)
  * 	Description
  * 		Redirect the packet to another net device of index *ifindex*
  * 		and fill in L2 addresses from neighboring subsystem. This helper
  * 		is somewhat similar to **bpf_redirect**\ (), except that it
  * 		populates L2 addresses as well, meaning, internally, the helper
- * 		performs a FIB lookup based on the skb's networking header to
- * 		get the address of the next hop and then relies on the neighbor
- * 		lookup for the L2 address of the nexthop.
+ * 		relies on the neighbor lookup for the L2 address of the nexthop.
+ *
+ * 		The helper will perform a FIB lookup based on the skb's
+ * 		networking header to get the address of the next hop, unless
+ * 		this is supplied by the caller in the *params* argument. The
+ * 		*plen* argument indicates the len of *params* and should be set
+ * 		to 0 if *params* is NULL.
  *
  * 		The *flags* argument is reserved and must be 0. The helper is
  * 		currently only supported for tc BPF program types, and enabled
@@ -4906,6 +4910,17 @@ struct bpf_fib_lookup {
 	__u8	dmac[6];     /* ETH_ALEN */
 };
 
+struct bpf_redir_neigh {
+	/* network family for lookup (AF_INET, AF_INET6)
+	 */
+	__u8	nh_family;
+	/* network address of nexthop; skips fib lookup to find gateway */
+	union {
+		__be32		ipv4_nh;
+		__u32		ipv6_nh[4];  /* in6_addr; network order */
+	};
+};
+
 enum bpf_task_fd_type {
 	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
 	BPF_FD_TYPE_TRACEPOINT,		/* tp name */

