Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654096B828F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCMUSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCMUSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:18:21 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577411024E
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:17:36 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5376fa4106eso142437047b3.7
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678738655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QwafAoMjj0CaXsrX9aOQK+5xUkL6fS5fo/35wlHJSPo=;
        b=G6Tlf7QoU/OjIAf+GnUUGj7vDEm3pXpf16fQbjJ9pJRQ1vWNs7v6V9ZgCuw1Bb3UkV
         osnHP851h3tBbmF2eMabIIQgsRkj4Ltfe60aGg+7AkSLMP6CxvGE7aMvURQG6MchsRfe
         V/Hy99FXOgwbSXPgiMb2WYoegUzB7vqnayjM28l6Rq1xWRfGFHuQgRNg/xM2950O3n2z
         gRIimwOWAQ3oHY75/fzot9EezrvzwVE+V/9FBrJRpaOO/NeQQnjg6j2a5m2U69CRZRL4
         OBDhrBMGHDwbhud6E0Ez+sZQBtWd3w6BFquByajRkDN3us3kMYmGnFprejedHUTOBXWF
         pLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678738655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QwafAoMjj0CaXsrX9aOQK+5xUkL6fS5fo/35wlHJSPo=;
        b=wITUtP+FTjGxnLZF8F2rvxqZWJnMSER2WqVOLBwfxrnd1TSm9qyh0b71OXJd5os842
         L5MlDzF0gu8leB4DXd5RZ/lKz1kMUe3FwSS9Fiz68Bdj0kPxYuE4solMVp4mDkd4AzN4
         9mviP7Mxgkk0QLx1XwRXo5nVGr8V+717mqx+R5KgP6L55hW3jO4qvBPGF3jJNfFQNIEl
         zipMP6lGxnEbq0yXED4GPBrXtQXgSBHKkiEV+H08YwM7fKLmYj/lic0tGF5IQKJzrctt
         NsnoJ+d2No4WyPzg1TnImq9NYiywGD5DRzbBT8VBoLX7P7MNYf7gnLpJH7Tf4chGel/F
         V3Gw==
X-Gm-Message-State: AO0yUKW6GXG6CxMtGArfesnqko8kTmKFWxj7HelCLbr16QQ2K2mIdwU6
        uVIpkh7n+Gaaw64PxULLA+qA3Cn4da8f3A==
X-Google-Smtp-Source: AK7set+xMrXOsnb3rcqQyKdy2hbPtmjU3zReXZjf4W9vmmuSq/jSKLkbYXptLIvWQQ57bkjb0X4KBxXeBpnOfA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:145:b0:ac2:a7a7:23c3 with SMTP
 id p5-20020a056902014500b00ac2a7a723c3mr15799623ybh.12.1678738655647; Mon, 13
 Mar 2023 13:17:35 -0700 (PDT)
Date:   Mon, 13 Mar 2023 20:17:31 +0000
In-Reply-To: <20230313201732.887488-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230313201732.887488-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313201732.887488-2-edumazet@google.com>
Subject: [PATCH net-next 1/2] neighbour: annotate lockless accesses to n->nud_state
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have many lockless accesses to n->nud_state.

Before adding another one in the following patch,
add annotations to readers and writers.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/vxlan/vxlan_core.c  |  4 ++--
 include/net/neighbour.h         |  2 +-
 net/bridge/br_arp_nd_proxy.c    |  4 ++--
 net/bridge/br_netfilter_hooks.c |  3 ++-
 net/core/filter.c               |  4 ++--
 net/core/neighbour.c            | 28 ++++++++++++++--------------
 net/ipv4/arp.c                  |  8 ++++----
 net/ipv4/fib_semantics.c        |  4 ++--
 net/ipv4/nexthop.c              |  4 ++--
 net/ipv4/route.c                |  2 +-
 net/ipv6/ip6_output.c           |  2 +-
 net/ipv6/ndisc.c                |  4 ++--
 net/ipv6/route.c                |  2 +-
 13 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a13e52f1bd3df386d1e339ea4fe68..f2c30214cae8e24e6a3d865efc92b16a66c9731b 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1863,7 +1863,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		struct vxlan_fdb *f;
 		struct sk_buff	*reply;
 
-		if (!(n->nud_state & NUD_CONNECTED)) {
+		if (!(READ_ONCE(n->nud_state) & NUD_CONNECTED)) {
 			neigh_release(n);
 			goto out;
 		}
@@ -2027,7 +2027,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		struct vxlan_fdb *f;
 		struct sk_buff *reply;
 
-		if (!(n->nud_state & NUD_CONNECTED)) {
+		if (!(READ_ONCE(n->nud_state) & NUD_CONNECTED)) {
 			neigh_release(n);
 			goto out;
 		}
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 234799ca527e054dd0309a6d815bb6a447e0bd7c..c8d39bba2a0de1a6203fef9216212c409e1aec4c 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -464,7 +464,7 @@ static __always_inline int neigh_event_send_probe(struct neighbour *neigh,
 
 	if (READ_ONCE(neigh->used) != now)
 		WRITE_ONCE(neigh->used, now);
-	if (!(neigh->nud_state & (NUD_CONNECTED | NUD_DELAY | NUD_PROBE)))
+	if (!(READ_ONCE(neigh->nud_state) & (NUD_CONNECTED | NUD_DELAY | NUD_PROBE)))
 		return __neigh_event_send(neigh, skb, immediate_ok);
 	return 0;
 }
diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index e5e48c6e35d786c63ab14b7df59caad3ef799633..b45c00c01dea195cf41beb069fa20a883926c9d3 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -192,7 +192,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 	if (n) {
 		struct net_bridge_fdb_entry *f;
 
-		if (!(n->nud_state & NUD_VALID)) {
+		if (!(READ_ONCE(n->nud_state) & NUD_VALID)) {
 			neigh_release(n);
 			return;
 		}
@@ -452,7 +452,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 	if (n) {
 		struct net_bridge_fdb_entry *f;
 
-		if (!(n->nud_state & NUD_VALID)) {
+		if (!(READ_ONCE(n->nud_state) & NUD_VALID)) {
 			neigh_release(n);
 			return;
 		}
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 638a4d5359db08f72a1191548a8874190c5983f2..3e3065bc0465ca5e887cfeec56b6fb6d6520e4ef 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -277,7 +277,8 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
 		struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 		int ret;
 
-		if ((neigh->nud_state & NUD_CONNECTED) && neigh->hh.hh_len) {
+		if ((READ_ONCE(neigh->nud_state) & NUD_CONNECTED) &&
+		    READ_ONCE(neigh->hh.hh_len)) {
 			neigh_hh_bridge(&neigh->hh, skb);
 			skb->dev = nf_bridge->physindev;
 			ret = br_handle_frame_finish(net, sk, skb);
diff --git a/net/core/filter.c b/net/core/filter.c
index 50f649f1b4a90388ad960df9f97f80b5a9f2522a..d052fac28d02e79d83720c9001af40c53b5024fd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5871,7 +5871,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	else
 		neigh = __ipv6_neigh_lookup_noref_stub(dev, params->ipv6_dst);
 
-	if (!neigh || !(neigh->nud_state & NUD_VALID))
+	if (!neigh || !(READ_ONCE(neigh->nud_state) & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 	memcpy(params->dmac, neigh->ha, ETH_ALEN);
 	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
@@ -5992,7 +5992,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	 * not needed here.
 	 */
 	neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
-	if (!neigh || !(neigh->nud_state & NUD_VALID))
+	if (!neigh || !(READ_ONCE(neigh->nud_state) & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 	memcpy(params->dmac, neigh->ha, ETH_ALEN);
 	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0116b0ff91a780cbd12af9459eca2577e3998b1e..90d399b3f9800e574d65aa795fb5a96e5bc96919 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1093,13 +1093,13 @@ static void neigh_timer_handler(struct timer_list *t)
 					  neigh->used +
 					  NEIGH_VAR(neigh->parms, DELAY_PROBE_TIME))) {
 			neigh_dbg(2, "neigh %p is delayed\n", neigh);
-			neigh->nud_state = NUD_DELAY;
+			WRITE_ONCE(neigh->nud_state, NUD_DELAY);
 			neigh->updated = jiffies;
 			neigh_suspect(neigh);
 			next = now + NEIGH_VAR(neigh->parms, DELAY_PROBE_TIME);
 		} else {
 			neigh_dbg(2, "neigh %p is suspected\n", neigh);
-			neigh->nud_state = NUD_STALE;
+			WRITE_ONCE(neigh->nud_state, NUD_STALE);
 			neigh->updated = jiffies;
 			neigh_suspect(neigh);
 			notify = 1;
@@ -1109,14 +1109,14 @@ static void neigh_timer_handler(struct timer_list *t)
 				   neigh->confirmed +
 				   NEIGH_VAR(neigh->parms, DELAY_PROBE_TIME))) {
 			neigh_dbg(2, "neigh %p is now reachable\n", neigh);
-			neigh->nud_state = NUD_REACHABLE;
+			WRITE_ONCE(neigh->nud_state, NUD_REACHABLE);
 			neigh->updated = jiffies;
 			neigh_connect(neigh);
 			notify = 1;
 			next = neigh->confirmed + neigh->parms->reachable_time;
 		} else {
 			neigh_dbg(2, "neigh %p is probed\n", neigh);
-			neigh->nud_state = NUD_PROBE;
+			WRITE_ONCE(neigh->nud_state, NUD_PROBE);
 			neigh->updated = jiffies;
 			atomic_set(&neigh->probes, 0);
 			notify = 1;
@@ -1130,7 +1130,7 @@ static void neigh_timer_handler(struct timer_list *t)
 
 	if ((neigh->nud_state & (NUD_INCOMPLETE | NUD_PROBE)) &&
 	    atomic_read(&neigh->probes) >= neigh_max_probes(neigh)) {
-		neigh->nud_state = NUD_FAILED;
+		WRITE_ONCE(neigh->nud_state, NUD_FAILED);
 		notify = 1;
 		neigh_invalidate(neigh);
 		goto out;
@@ -1179,7 +1179,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
 			atomic_set(&neigh->probes,
 				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
 			neigh_del_timer(neigh);
-			neigh->nud_state = NUD_INCOMPLETE;
+			WRITE_ONCE(neigh->nud_state, NUD_INCOMPLETE);
 			neigh->updated = now;
 			if (!immediate_ok) {
 				next = now + 1;
@@ -1191,7 +1191,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
 			}
 			neigh_add_timer(neigh, next);
 		} else {
-			neigh->nud_state = NUD_FAILED;
+			WRITE_ONCE(neigh->nud_state, NUD_FAILED);
 			neigh->updated = jiffies;
 			write_unlock_bh(&neigh->lock);
 
@@ -1201,7 +1201,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
 	} else if (neigh->nud_state & NUD_STALE) {
 		neigh_dbg(2, "neigh %p is delayed\n", neigh);
 		neigh_del_timer(neigh);
-		neigh->nud_state = NUD_DELAY;
+		WRITE_ONCE(neigh->nud_state, NUD_DELAY);
 		neigh->updated = jiffies;
 		neigh_add_timer(neigh, jiffies +
 				NEIGH_VAR(neigh->parms, DELAY_PROBE_TIME));
@@ -1313,7 +1313,7 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 	neigh_update_flags(neigh, flags, &notify, &gc_update, &managed_update);
 	if (flags & (NEIGH_UPDATE_F_USE | NEIGH_UPDATE_F_MANAGED)) {
 		new = old & ~NUD_PERMANENT;
-		neigh->nud_state = new;
+		WRITE_ONCE(neigh->nud_state, new);
 		err = 0;
 		goto out;
 	}
@@ -1322,7 +1322,7 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 		neigh_del_timer(neigh);
 		if (old & NUD_CONNECTED)
 			neigh_suspect(neigh);
-		neigh->nud_state = new;
+		WRITE_ONCE(neigh->nud_state, new);
 		err = 0;
 		notify = old & NUD_VALID;
 		if ((old & (NUD_INCOMPLETE | NUD_PROBE)) &&
@@ -1401,7 +1401,7 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 						((new & NUD_REACHABLE) ?
 						 neigh->parms->reachable_time :
 						 0)));
-		neigh->nud_state = new;
+		WRITE_ONCE(neigh->nud_state, new);
 		notify = 1;
 	}
 
@@ -1488,7 +1488,7 @@ void __neigh_set_probe_once(struct neighbour *neigh)
 	neigh->updated = jiffies;
 	if (!(neigh->nud_state & NUD_FAILED))
 		return;
-	neigh->nud_state = NUD_INCOMPLETE;
+	WRITE_ONCE(neigh->nud_state, NUD_INCOMPLETE);
 	atomic_set(&neigh->probes, neigh_max_probes(neigh));
 	neigh_add_timer(neigh,
 			jiffies + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
@@ -3198,7 +3198,7 @@ static struct neighbour *neigh_get_first(struct seq_file *seq)
 			}
 			if (!(state->flags & NEIGH_SEQ_SKIP_NOARP))
 				break;
-			if (n->nud_state & ~NUD_NOARP)
+			if (READ_ONCE(n->nud_state) & ~NUD_NOARP)
 				break;
 next:
 			n = rcu_dereference_bh(n->next);
@@ -3240,7 +3240,7 @@ static struct neighbour *neigh_get_next(struct seq_file *seq,
 			if (!(state->flags & NEIGH_SEQ_SKIP_NOARP))
 				break;
 
-			if (n->nud_state & ~NUD_NOARP)
+			if (READ_ONCE(n->nud_state) & ~NUD_NOARP)
 				break;
 next:
 			n = rcu_dereference_bh(n->next);
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 4f7237661afb9b2c1a11a1740eae823443ebdea4..9456f5bb35e5d9e97d6c05be21561b435e2b704a 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -375,7 +375,7 @@ static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb)
 
 	probes -= NEIGH_VAR(neigh->parms, UCAST_PROBES);
 	if (probes < 0) {
-		if (!(neigh->nud_state & NUD_VALID))
+		if (!(READ_ONCE(neigh->nud_state) & NUD_VALID))
 			pr_debug("trying to ucast probe in NUD_INVALID\n");
 		neigh_ha_snapshot(dst_ha, neigh, dev);
 		dst_hw = dst_ha;
@@ -1123,7 +1123,7 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
 
 	neigh = neigh_lookup(&arp_tbl, &ip, dev);
 	if (neigh) {
-		if (!(neigh->nud_state & NUD_NOARP)) {
+		if (!(READ_ONCE(neigh->nud_state) & NUD_NOARP)) {
 			read_lock_bh(&neigh->lock);
 			memcpy(r->arp_ha.sa_data, neigh->ha, dev->addr_len);
 			r->arp_flags = arp_state_to_flags(neigh);
@@ -1144,12 +1144,12 @@ int arp_invalidate(struct net_device *dev, __be32 ip, bool force)
 	struct neigh_table *tbl = &arp_tbl;
 
 	if (neigh) {
-		if ((neigh->nud_state & NUD_VALID) && !force) {
+		if ((READ_ONCE(neigh->nud_state) & NUD_VALID) && !force) {
 			neigh_release(neigh);
 			return 0;
 		}
 
-		if (neigh->nud_state & ~NUD_NOARP)
+		if (READ_ONCE(neigh->nud_state) & ~NUD_NOARP)
 			err = neigh_update(neigh, NULL, NUD_FAILED,
 					   NEIGH_UPDATE_F_OVERRIDE|
 					   NEIGH_UPDATE_F_ADMIN, 0);
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3bb890a40ed73626acba8c22044d1c5f99c872e8..574ff450c4d234f806b2cc96352800b3e2ce256d 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -563,7 +563,7 @@ static int fib_detect_death(struct fib_info *fi, int order,
 		n = NULL;
 
 	if (n) {
-		state = n->nud_state;
+		state = READ_ONCE(n->nud_state);
 		neigh_release(n);
 	} else {
 		return 0;
@@ -2202,7 +2202,7 @@ static bool fib_good_nh(const struct fib_nh *nh)
 		else
 			n = NULL;
 		if (n)
-			state = n->nud_state;
+			state = READ_ONCE(n->nud_state);
 
 		rcu_read_unlock_bh();
 	}
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index d8ef05347fd98e3fa1dfa35e7ca9c77e0f3190d2..e28a99f1996b74b72dc938a3a6239069a0925f94 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1128,7 +1128,7 @@ static bool ipv6_good_nh(const struct fib6_nh *nh)
 
 	n = __ipv6_neigh_lookup_noref_stub(nh->fib_nh_dev, &nh->fib_nh_gw6);
 	if (n)
-		state = n->nud_state;
+		state = READ_ONCE(n->nud_state);
 
 	rcu_read_unlock_bh();
 
@@ -1145,7 +1145,7 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	n = __ipv4_neigh_lookup_noref(nh->fib_nh_dev,
 				      (__force u32)nh->fib_nh_gw4);
 	if (n)
-		state = n->nud_state;
+		state = READ_ONCE(n->nud_state);
 
 	rcu_read_unlock_bh();
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index de6e3515ab4fe63fb9192b1a92113f0cae9ca56e..232009d216c4e34558077efe80371ecc6d0b532c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -784,7 +784,7 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 	if (!n)
 		n = neigh_create(&arp_tbl, &new_gw, rt->dst.dev);
 	if (!IS_ERR(n)) {
-		if (!(n->nud_state & NUD_VALID)) {
+		if (!(READ_ONCE(n->nud_state) & NUD_VALID)) {
 			neigh_event_send(n, NULL);
 		} else {
 			if (fib_lookup(net, fl4, &res, 0) == 0) {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4ce3f9d3bc8acaa2b73f3cf01d033fcad4553bab..e5ed39a3c65f83d211dabb3c02a1d44b116257ed 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1153,7 +1153,7 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref(rt->dst.dev,
 				      rt6_nexthop(rt, &fl6->daddr));
-	err = n && !(n->nud_state & NUD_VALID) ? -EINVAL : 0;
+	err = n && !(READ_ONCE(n->nud_state) & NUD_VALID) ? -EINVAL : 0;
 	rcu_read_unlock_bh();
 
 	if (err) {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index c4be62c99f7371a55e56f4489f822d9c11b007f5..18634ebd20a47d2d0d707c164e0691d3beb60427 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -745,7 +745,7 @@ static void ndisc_solicit(struct neighbour *neigh, struct sk_buff *skb)
 		saddr = &ipv6_hdr(skb)->saddr;
 	probes -= NEIGH_VAR(neigh->parms, UCAST_PROBES);
 	if (probes < 0) {
-		if (!(neigh->nud_state & NUD_VALID)) {
+		if (!(READ_ONCE(neigh->nud_state) & NUD_VALID)) {
 			ND_PRINTK(1, dbg,
 				  "%s: trying to ucast probe in NUD_INVALID: %pI6\n",
 				  __func__, target);
@@ -1090,7 +1090,7 @@ static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 		u8 old_flags = neigh->flags;
 		struct net *net = dev_net(dev);
 
-		if (neigh->nud_state & NUD_FAILED)
+		if (READ_ONCE(neigh->nud_state) & NUD_FAILED)
 			goto out;
 
 		/*
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0fdb03df228700c9af935e834129bf1d8b3be2fc..25c00c6f5131c55055f30348ef4605f50440ddbb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -638,7 +638,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	idev = __in6_dev_get(dev);
 	neigh = __ipv6_neigh_lookup_noref(dev, nh_gw);
 	if (neigh) {
-		if (neigh->nud_state & NUD_VALID)
+		if (READ_ONCE(neigh->nud_state) & NUD_VALID)
 			goto out;
 
 		write_lock(&neigh->lock);
-- 
2.40.0.rc1.284.g88254d51c5-goog

