Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB14369A306
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBQAmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjBQAmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:42:07 -0500
Received: from out-108.mta1.migadu.com (out-108.mta1.migadu.com [IPv6:2001:41d0:203:375::6c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B7056491
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 16:42:05 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676594523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ed2+f8mj2GWUiP7BF08YFzGiN1bMw4RE6JpbOljb3o=;
        b=iNxXx8Id56GzHy3a3oMQHCJm6xXZyNz1cjMZz9Yl1dfjyO+Mse/zOO+aXM67XigtPkDaQA
        +t94jhZGdj+wJIca7oULAOUc3DxSdrD6SnRGqopY09d1O9jUEWaxoETp5TRUDmZtq/NiTy
        mUPdgGrsChESkOGtsbyeona2s1gZMsk=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 3/4] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for bpf_fib_lookup
Date:   Thu, 16 Feb 2023 16:41:49 -0800
Message-Id: <20230217004150.2980689-4-martin.lau@linux.dev>
In-Reply-To: <20230217004150.2980689-1-martin.lau@linux.dev>
References: <20230217004150.2980689-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The bpf_fib_lookup() also looks up the neigh table.
This was done before bpf_redirect_neigh() was added.

In the use case that does not manage the neigh table
and requires bpf_fib_lookup() to lookup a fib to
decide if it needs to redirect or not, the bpf prog can
depend only on using bpf_redirect_neigh() to lookup the
neigh. It also keeps the neigh entries fresh and connected.

This patch adds a bpf_fib_lookup flag, SKIP_NEIGH, to avoid
the double neigh lookup when the bpf prog always call
bpf_redirect_neigh() to do the neigh lookup.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 33 +++++++++++++++++++++++----------
 tools/include/uapi/linux/bpf.h |  1 +
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1503f61336b6..6c1956e36c97 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6750,6 +6750,7 @@ struct bpf_raw_tracepoint_args {
 enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 8daaaf76ab15..08f0f21863bc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5723,10 +5723,8 @@ static const struct bpf_func_proto bpf_skb_get_xfrm_state_proto = {
 
 #if IS_ENABLED(CONFIG_INET) || IS_ENABLED(CONFIG_IPV6)
 static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
-				  const struct neighbour *neigh,
 				  const struct net_device *dev, u32 mtu)
 {
-	memcpy(params->dmac, neigh->ha, ETH_ALEN);
 	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 	params->h_vlan_TCI = 0;
 	params->h_vlan_proto = 0;
@@ -5838,21 +5836,28 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	if (likely(nhc->nhc_gw_family != AF_INET6)) {
 		if (nhc->nhc_gw_family)
 			params->ipv4_dst = nhc->nhc_gw.ipv4;
-
-		neigh = __ipv4_neigh_lookup_noref(dev,
-						 (__force u32)params->ipv4_dst);
 	} else {
 		struct in6_addr *dst = (struct in6_addr *)params->ipv6_dst;
 
 		params->family = AF_INET6;
 		*dst = nhc->nhc_gw.ipv6;
-		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	}
 
+	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
+		goto set_fwd_params;
+
+	if (params->family == AF_INET6)
+		neigh = __ipv6_neigh_lookup_noref_stub(dev, params->ipv6_dst);
+	else
+		neigh = __ipv4_neigh_lookup_noref(dev,
+						  (__force u32)params->ipv4_dst);
+
 	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
+	memcpy(params->dmac, neigh->ha, ETH_ALEN);
 
-	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
+set_fwd_params:
+	return bpf_fib_set_fwd_params(params, dev, mtu);
 }
 #endif
 
@@ -5960,24 +5965,32 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	params->rt_metric = res.f6i->fib6_metric;
 	params->ifindex = dev->ifindex;
 
+	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
+		goto set_fwd_params;
+
 	/* xdp and cls_bpf programs are run in RCU-bh so rcu_read_lock_bh is
 	 * not needed here.
 	 */
 	neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
+	memcpy(params->dmac, neigh->ha, ETH_ALEN);
 
-	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
+set_fwd_params:
+	return bpf_fib_set_fwd_params(params, dev, mtu);
 }
 #endif
 
+#define BPF_FIB_LOOKUP_MASK (BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT | \
+			     BPF_FIB_LOOKUP_SKIP_NEIGH)
+
 BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
 	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
 {
 	if (plen < sizeof(*params))
 		return -EINVAL;
 
-	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
+	if (flags & ~BPF_FIB_LOOKUP_MASK)
 		return -EINVAL;
 
 	switch (params->family) {
@@ -6015,7 +6028,7 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 	if (plen < sizeof(*params))
 		return -EINVAL;
 
-	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
+	if (flags & ~BPF_FIB_LOOKUP_MASK)
 		return -EINVAL;
 
 	if (params->tot_len)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1503f61336b6..6c1956e36c97 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6750,6 +6750,7 @@ struct bpf_raw_tracepoint_args {
 enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 };
 
 enum {
-- 
2.30.2

