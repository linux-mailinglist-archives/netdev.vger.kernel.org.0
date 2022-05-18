Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846CD52C5BE
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiERVmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243259AbiERVjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:39:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0218249897;
        Wed, 18 May 2022 14:38:49 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 6/7] netfilter: flowtable: move dst_check to packet path
Date:   Wed, 18 May 2022 23:38:40 +0200
Message-Id: <20220518213841.359653-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518213841.359653-1-pablo@netfilter.org>
References: <20220518213841.359653-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ritaro Takenaka <ritarot634@gmail.com>

Fixes sporadic IPv6 packet loss when flow offloading is enabled.

IPv6 route GC and flowtable GC are not synchronized.
When dst_cache becomes stale and a packet passes through the flow before
the flowtable GC teardowns it, the packet can be dropped.
So, it is necessary to check dst every time in packet path.

Fixes: 227e1e4d0d6c ("netfilter: nf_flowtable: skip device lookup from interface index")
Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 23 +----------------------
 net/netfilter/nf_flow_table_ip.c   | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index ebdf5332e838..f2def06d1070 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -421,32 +421,11 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
-static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
-{
-	struct dst_entry *dst;
-
-	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
-		dst = tuple->dst_cache;
-		if (!dst_check(dst, tuple->dst_cookie))
-			return true;
-	}
-
-	return false;
-}
-
-static bool nf_flow_has_stale_dst(struct flow_offload *flow)
-{
-	return flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
-	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
-}
-
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
 	if (nf_flow_has_expired(flow) ||
-	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_has_stale_dst(flow))
+	    nf_ct_is_dying(flow->ct))
 		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 32c0eb1b4821..b350fe9d00b0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -248,6 +248,15 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
+{
+	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
+	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
+		return true;
+
+	return dst_check(tuple->dst_cache, tuple->dst_cookie);
+}
+
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
@@ -367,6 +376,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
@@ -624,6 +638,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-- 
2.30.2

