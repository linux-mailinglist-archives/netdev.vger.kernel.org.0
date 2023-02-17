Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6A969B231
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 19:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBQSMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 13:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBQSMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 13:12:37 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667BAEB4A;
        Fri, 17 Feb 2023 10:12:36 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676657554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PwZEl/wTUxGr6miLXiGTMsN4b7aOUjpQuGXPVrDinoE=;
        b=LWN8t1utfMMIJM62G51S9NemwmLynRw+ergvQkN8rvtVFYlkd+TMLXacqMxiKojQXX6wec
        H6uZDcDMBpPeG3+JZAILVE58k0RosT2PEictoyFDQua/oM9CZHVR3FpNauVSFRc7my5haB
        5BE8MslZ396platY1F/XCiCD3jcawq0=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 bpf-next 1/2] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for bpf_fib_lookup
Date:   Fri, 17 Feb 2023 10:12:23 -0800
Message-Id: <20230217181224.2320704-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
bpf_redirect_neigh() to do the neigh lookup. The params->smac
output is skipped together when SKIP_NEIGH is set because
bpf_redirect_neigh() will figure out the smac also.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
v2:
  - Skip copying smac when the SKIP_NEIGH is set
  - Keep the ordering of the (nhc->nhc_gw_family != AF_INET6) test

 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 39 ++++++++++++++++++++++------------
 tools/include/uapi/linux/bpf.h |  1 +
 3 files changed, 28 insertions(+), 13 deletions(-)

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
index 8daaaf76ab15..1d6f165923bf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5722,12 +5722,8 @@ static const struct bpf_func_proto bpf_skb_get_xfrm_state_proto = {
 #endif
 
 #if IS_ENABLED(CONFIG_INET) || IS_ENABLED(CONFIG_IPV6)
-static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
-				  const struct neighbour *neigh,
-				  const struct net_device *dev, u32 mtu)
+static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params, u32 mtu)
 {
-	memcpy(params->dmac, neigh->ha, ETH_ALEN);
-	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 	params->h_vlan_TCI = 0;
 	params->h_vlan_proto = 0;
 	if (mtu)
@@ -5838,21 +5834,29 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
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
+	if (likely(nhc->nhc_gw_family != AF_INET6))
+		neigh = __ipv4_neigh_lookup_noref(dev,
+						  (__force u32)params->ipv4_dst);
+	else
+		neigh = __ipv6_neigh_lookup_noref_stub(dev, params->ipv6_dst);
+
 	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
+	memcpy(params->dmac, neigh->ha, ETH_ALEN);
+	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 
-	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
+set_fwd_params:
+	return bpf_fib_set_fwd_params(params, mtu);
 }
 #endif
 
@@ -5960,24 +5964,33 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
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
+	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 
-	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
+set_fwd_params:
+	return bpf_fib_set_fwd_params(params, mtu);
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

