Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F717629519
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiKOJ7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238144AbiKOJ7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:59:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7E1FFD0E;
        Tue, 15 Nov 2022 01:59:26 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 3/6] netfilter: nf_tables: Extend nft_expr_ops::dump callback parameters
Date:   Tue, 15 Nov 2022 10:59:19 +0100
Message-Id: <20221115095922.139954-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115095922.139954-1-pablo@netfilter.org>
References: <20221115095922.139954-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Add a 'reset' flag just like with nft_object_ops::dump. This will be
useful to reset "anonymous stateful objects", e.g. simple rule counters.

No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h  | 3 ++-
 include/net/netfilter/nft_fib.h    | 2 +-
 include/net/netfilter/nft_meta.h   | 4 ++--
 include/net/netfilter/nft_reject.h | 3 ++-
 net/ipv4/netfilter/nft_dup_ipv4.c  | 3 ++-
 net/ipv6/netfilter/nft_dup_ipv6.c  | 3 ++-
 net/netfilter/nf_tables_api.c      | 2 +-
 net/netfilter/nft_bitwise.c        | 6 ++++--
 net/netfilter/nft_byteorder.c      | 3 ++-
 net/netfilter/nft_cmp.c            | 9 ++++++---
 net/netfilter/nft_compat.c         | 9 ++++++---
 net/netfilter/nft_connlimit.c      | 3 ++-
 net/netfilter/nft_counter.c        | 3 ++-
 net/netfilter/nft_ct.c             | 6 ++++--
 net/netfilter/nft_dup_netdev.c     | 3 ++-
 net/netfilter/nft_dynset.c         | 3 ++-
 net/netfilter/nft_exthdr.c         | 9 ++++++---
 net/netfilter/nft_fib.c            | 2 +-
 net/netfilter/nft_flow_offload.c   | 3 ++-
 net/netfilter/nft_fwd_netdev.c     | 6 ++++--
 net/netfilter/nft_hash.c           | 4 ++--
 net/netfilter/nft_immediate.c      | 3 ++-
 net/netfilter/nft_inner.c          | 3 ++-
 net/netfilter/nft_last.c           | 3 ++-
 net/netfilter/nft_limit.c          | 5 +++--
 net/netfilter/nft_log.c            | 3 ++-
 net/netfilter/nft_lookup.c         | 3 ++-
 net/netfilter/nft_masq.c           | 3 ++-
 net/netfilter/nft_meta.c           | 5 +++--
 net/netfilter/nft_nat.c            | 3 ++-
 net/netfilter/nft_numgen.c         | 6 ++++--
 net/netfilter/nft_objref.c         | 6 ++++--
 net/netfilter/nft_osf.c            | 3 ++-
 net/netfilter/nft_payload.c        | 6 ++++--
 net/netfilter/nft_queue.c          | 6 ++++--
 net/netfilter/nft_quota.c          | 3 ++-
 net/netfilter/nft_range.c          | 3 ++-
 net/netfilter/nft_redir.c          | 3 ++-
 net/netfilter/nft_reject.c         | 3 ++-
 net/netfilter/nft_rt.c             | 2 +-
 net/netfilter/nft_socket.c         | 2 +-
 net/netfilter/nft_synproxy.c       | 3 ++-
 net/netfilter/nft_tproxy.c         | 2 +-
 net/netfilter/nft_tunnel.c         | 2 +-
 net/netfilter/nft_xfrm.c           | 2 +-
 45 files changed, 110 insertions(+), 62 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 38e2b396e38a..c557a57fb0f1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -927,7 +927,8 @@ struct nft_expr_ops {
 	void				(*destroy_clone)(const struct nft_ctx *ctx,
 							 const struct nft_expr *expr);
 	int				(*dump)(struct sk_buff *skb,
-						const struct nft_expr *expr);
+						const struct nft_expr *expr,
+						bool reset);
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index eed099eae672..167640b843ef 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -18,7 +18,7 @@ nft_fib_is_loopback(const struct sk_buff *skb, const struct net_device *in)
 	return skb->pkt_type == PACKET_LOOPBACK || in->flags & IFF_LOOPBACK;
 }
 
-int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr);
+int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
 int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index f3a5285a511c..ba1238f12a48 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -24,10 +24,10 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[]);
 
 int nft_meta_get_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr);
+		      const struct nft_expr *expr, bool reset);
 
 int nft_meta_set_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr);
+		      const struct nft_expr *expr, bool reset);
 
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
diff --git a/include/net/netfilter/nft_reject.h b/include/net/netfilter/nft_reject.h
index 56b123a42220..6d9ba62efd75 100644
--- a/include/net/netfilter/nft_reject.h
+++ b/include/net/netfilter/nft_reject.h
@@ -22,7 +22,8 @@ int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nft_expr *expr,
 		    const struct nlattr * const tb[]);
 
-int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr);
+int nft_reject_dump(struct sk_buff *skb,
+		    const struct nft_expr *expr, bool reset);
 
 int nft_reject_icmp_code(u8 code);
 int nft_reject_icmpv6_code(u8 code);
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index 0bcd6aee6000..a522c3a3be52 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -52,7 +52,8 @@ static int nft_dup_ipv4_init(const struct nft_ctx *ctx,
 	return err;
 }
 
-static int nft_dup_ipv4_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_dup_ipv4_dump(struct sk_buff *skb,
+			     const struct nft_expr *expr, bool reset)
 {
 	struct nft_dup_ipv4 *priv = nft_expr_priv(expr);
 
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 70a405b4006f..c82f3fdd4a65 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -50,7 +50,8 @@ static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
 	return err;
 }
 
-static int nft_dup_ipv6_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_dup_ipv6_dump(struct sk_buff *skb,
+			     const struct nft_expr *expr, bool reset)
 {
 	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62da204eed41..741a0e386406 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2769,7 +2769,7 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 							    NFTA_EXPR_DATA);
 		if (data == NULL)
 			goto nla_put_failure;
-		if (expr->ops->dump(skb, expr) < 0)
+		if (expr->ops->dump(skb, expr, false) < 0)
 			goto nla_put_failure;
 		nla_nest_end(skb, data);
 	}
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index e6e402b247d0..84eae7cabc67 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -232,7 +232,8 @@ static int nft_bitwise_dump_shift(struct sk_buff *skb,
 	return 0;
 }
 
-static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_bitwise_dump(struct sk_buff *skb,
+			    const struct nft_expr *expr, bool reset)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	int err = 0;
@@ -393,7 +394,8 @@ static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
 }
 
 static int
-nft_bitwise_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
+nft_bitwise_fast_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr, bool reset)
 {
 	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
 	struct nft_data data;
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index f952a80275a8..b66647a5a171 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -148,7 +148,8 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 					priv->len);
 }
 
-static int nft_byteorder_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_byteorder_dump(struct sk_buff *skb,
+			      const struct nft_expr *expr, bool reset)
 {
 	const struct nft_byteorder *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 963cf831799c..6eb21a4f5698 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -92,7 +92,8 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	return 0;
 }
 
-static int nft_cmp_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_cmp_dump(struct sk_buff *skb,
+			const struct nft_expr *expr, bool reset)
 {
 	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
 
@@ -253,7 +254,8 @@ static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
 	return __nft_cmp_offload(ctx, flow, &cmp);
 }
 
-static int nft_cmp_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_cmp_fast_dump(struct sk_buff *skb,
+			     const struct nft_expr *expr, bool reset)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
 	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
@@ -347,7 +349,8 @@ static int nft_cmp16_fast_offload(struct nft_offload_ctx *ctx,
 	return __nft_cmp_offload(ctx, flow, &cmp);
 }
 
-static int nft_cmp16_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_cmp16_fast_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr, bool reset)
 {
 	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
 	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index c16172427622..5284cd2ad532 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -324,7 +324,8 @@ static int nft_extension_dump_info(struct sk_buff *skb, int attr,
 	return 0;
 }
 
-static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_target_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct xt_target *target = expr->ops->data;
 	void *info = nft_expr_priv(expr);
@@ -572,12 +573,14 @@ static int __nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr,
 	return -1;
 }
 
-static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_match_dump(struct sk_buff *skb,
+			  const struct nft_expr *expr, bool reset)
 {
 	return __nft_match_dump(skb, expr, nft_expr_priv(expr));
 }
 
-static int nft_match_large_dump(struct sk_buff *skb, const struct nft_expr *e)
+static int nft_match_large_dump(struct sk_buff *skb,
+				const struct nft_expr *e, bool reset)
 {
 	struct nft_xt_match_priv *priv = nft_expr_priv(e);
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index d657f999a11b..de9d1980df69 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -185,7 +185,8 @@ static void nft_connlimit_eval(const struct nft_expr *expr,
 	nft_connlimit_do_eval(priv, regs, pkt, NULL);
 }
 
-static int nft_connlimit_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_connlimit_dump(struct sk_buff *skb,
+			      const struct nft_expr *expr, bool reset)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index f4d3573e8782..06482fb9c145 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -201,7 +201,8 @@ void nft_counter_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	nft_counter_do_eval(priv, regs, pkt);
 }
 
-static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_counter_dump(struct sk_buff *skb,
+			    const struct nft_expr *expr, bool reset)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a3f01f209a53..a0696d7ea10c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -641,7 +641,8 @@ static void nft_ct_set_destroy(const struct nft_ctx *ctx,
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
-static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_ct_get_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 
@@ -703,7 +704,8 @@ static bool nft_ct_get_reduce(struct nft_regs_track *track,
 	return nft_expr_reduce_bitwise(track, expr);
 }
 
-static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_ct_set_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 63507402716d..e5739a59ebf1 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -44,7 +44,8 @@ static int nft_dup_netdev_init(const struct nft_ctx *ctx,
 				       sizeof(int));
 }
 
-static int nft_dup_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_dup_netdev_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr, bool reset)
 {
 	struct nft_dup_netdev *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6983e6ddeef9..01c61e090639 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -357,7 +357,8 @@ static void nft_dynset_destroy(const struct nft_ctx *ctx,
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
-static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_dynset_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	u32 flags = priv->invert ? NFT_DYNSET_F_INV : 0;
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a67ea9c3ae57..ed929d0d37ce 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -576,7 +576,8 @@ static int nft_exthdr_dump_common(struct sk_buff *skb, const struct nft_exthdr *
 	return -1;
 }
 
-static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_exthdr_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_exthdr *priv = nft_expr_priv(expr);
 
@@ -586,7 +587,8 @@ static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return nft_exthdr_dump_common(skb, priv);
 }
 
-static int nft_exthdr_dump_set(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_exthdr_dump_set(struct sk_buff *skb,
+			       const struct nft_expr *expr, bool reset)
 {
 	const struct nft_exthdr *priv = nft_expr_priv(expr);
 
@@ -596,7 +598,8 @@ static int nft_exthdr_dump_set(struct sk_buff *skb, const struct nft_expr *expr)
 	return nft_exthdr_dump_common(skb, priv);
 }
 
-static int nft_exthdr_dump_strip(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_exthdr_dump_strip(struct sk_buff *skb,
+				 const struct nft_expr *expr, bool reset)
 {
 	const struct nft_exthdr *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 1f12d7ade606..6e049fd48760 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -118,7 +118,7 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 }
 EXPORT_SYMBOL_GPL(nft_fib_init);
 
-int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr)
+int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset)
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index a25c88bc8b75..e860d8fe0e5e 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -433,7 +433,8 @@ static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
-static int nft_flow_offload_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_flow_offload_dump(struct sk_buff *skb,
+				 const struct nft_expr *expr, bool reset)
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 7c5876dc9ff2..7b9d4d1bd17c 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -56,7 +56,8 @@ static int nft_fwd_netdev_init(const struct nft_ctx *ctx,
 				       sizeof(int));
 }
 
-static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_fwd_netdev_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr, bool reset)
 {
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 
@@ -186,7 +187,8 @@ static int nft_fwd_neigh_init(const struct nft_ctx *ctx,
 				       addr_len);
 }
 
-static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_fwd_neigh_dump(struct sk_buff *skb,
+			      const struct nft_expr *expr, bool reset)
 {
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index e5631e88b285..ee8d487b69c0 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -139,7 +139,7 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 }
 
 static int nft_jhash_dump(struct sk_buff *skb,
-			  const struct nft_expr *expr)
+			  const struct nft_expr *expr, bool reset)
 {
 	const struct nft_jhash *priv = nft_expr_priv(expr);
 
@@ -176,7 +176,7 @@ static bool nft_jhash_reduce(struct nft_regs_track *track,
 }
 
 static int nft_symhash_dump(struct sk_buff *skb,
-			    const struct nft_expr *expr)
+			    const struct nft_expr *expr, bool reset)
 {
 	const struct nft_symhash *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 5f28b21abc7d..c9d2f7c29f53 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -147,7 +147,8 @@ static void nft_immediate_destroy(const struct nft_ctx *ctx,
 	}
 }
 
-static int nft_immediate_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_immediate_dump(struct sk_buff *skb,
+			      const struct nft_expr *expr, bool reset)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 809f0d0787ec..6d96b826db4e 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -347,7 +347,8 @@ static int nft_inner_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_inner_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_inner_dump(struct sk_buff *skb,
+			  const struct nft_expr *expr, bool reset)
 {
 	const struct nft_inner *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index bb15a55dad5c..7f2bda6641bd 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -65,7 +65,8 @@ static void nft_last_eval(const struct nft_expr *expr,
 		WRITE_ONCE(last->set, 1);
 }
 
-static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_last_dump(struct sk_buff *skb,
+			 const struct nft_expr *expr, bool reset)
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
 	struct nft_last *last = priv->last;
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 981addb2d051..145dc62c6247 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -193,7 +193,8 @@ static int nft_limit_pkts_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_limit_pkts_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_limit_pkts_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr, bool reset)
 {
 	const struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
 
@@ -251,7 +252,7 @@ static int nft_limit_bytes_init(const struct nft_ctx *ctx,
 }
 
 static int nft_limit_bytes_dump(struct sk_buff *skb,
-				const struct nft_expr *expr)
+				const struct nft_expr *expr, bool reset)
 {
 	const struct nft_limit_priv *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 0e13c003f0c1..5defe6e4fd98 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -241,7 +241,8 @@ static void nft_log_destroy(const struct nft_ctx *ctx,
 	nf_logger_put(ctx->family, li->type);
 }
 
-static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_log_dump(struct sk_buff *skb,
+			const struct nft_expr *expr, bool reset)
 {
 	const struct nft_log *priv = nft_expr_priv(expr);
 	const struct nf_loginfo *li = &priv->loginfo;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index dfae12759c7c..cae5a6724163 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -178,7 +178,8 @@ static void nft_lookup_destroy(const struct nft_ctx *ctx,
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
-static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_lookup_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	u32 flags = priv->invert ? NFT_LOOKUP_F_INV : 0;
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 2a0adc497bbb..e55e455275c4 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -73,7 +73,8 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
 
-static int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_masq_dump(struct sk_buff *skb,
+			 const struct nft_expr *expr, bool reset)
 {
 	const struct nft_masq *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8c39adeebb5c..e384e0de7a54 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -669,7 +669,7 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 EXPORT_SYMBOL_GPL(nft_meta_set_init);
 
 int nft_meta_get_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr)
+		      const struct nft_expr *expr, bool reset)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -684,7 +684,8 @@ int nft_meta_get_dump(struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_dump);
 
-int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+int nft_meta_set_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr, bool reset)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e5fd6995e4bf..047999150390 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -255,7 +255,8 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	return nf_ct_netns_get(ctx->net, family);
 }
 
-static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_nat_dump(struct sk_buff *skb,
+			const struct nft_expr *expr, bool reset)
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 45d3dc9e96f2..7d29db7c2ac0 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -112,7 +112,8 @@ static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
 	return -1;
 }
 
-static int nft_ng_inc_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_ng_inc_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_ng_inc *priv = nft_expr_priv(expr);
 
@@ -168,7 +169,8 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
 
-static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_ng_random_dump(struct sk_buff *skb,
+			      const struct nft_expr *expr, bool reset)
 {
 	const struct nft_ng_random *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 74e0eea4abac..7b01aa2ef653 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -47,7 +47,8 @@ static int nft_objref_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_objref_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_object *obj = nft_objref_priv(expr);
 
@@ -155,7 +156,8 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_objref_map_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_objref_map_dump(struct sk_buff *skb,
+			       const struct nft_expr *expr, bool reset)
 {
 	const struct nft_objref_map *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index adacf95b6e2b..70820c66b591 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -92,7 +92,8 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_osf_dump(struct sk_buff *skb,
+			const struct nft_expr *expr, bool reset)
 {
 	const struct nft_osf *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 53e64d8aa01f..336ac668cae3 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -231,7 +231,8 @@ static int nft_payload_init(const struct nft_ctx *ctx,
 					priv->len);
 }
 
-static int nft_payload_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_payload_dump(struct sk_buff *skb,
+			    const struct nft_expr *expr, bool reset)
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 
@@ -919,7 +920,8 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 				       priv->len);
 }
 
-static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_payload_set_dump(struct sk_buff *skb,
+				const struct nft_expr *expr, bool reset)
 {
 	const struct nft_payload_set *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index da29e92c03e2..b2b8127c8d43 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -152,7 +152,8 @@ static int nft_queue_sreg_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_queue_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_queue_dump(struct sk_buff *skb,
+			  const struct nft_expr *expr, bool reset)
 {
 	const struct nft_queue *priv = nft_expr_priv(expr);
 
@@ -168,7 +169,8 @@ static int nft_queue_dump(struct sk_buff *skb, const struct nft_expr *expr)
 }
 
 static int
-nft_queue_sreg_dump(struct sk_buff *skb, const struct nft_expr *expr)
+nft_queue_sreg_dump(struct sk_buff *skb,
+		    const struct nft_expr *expr, bool reset)
 {
 	const struct nft_queue *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index e6b0df68feea..b1a1217bca4c 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -217,7 +217,8 @@ static int nft_quota_init(const struct nft_ctx *ctx,
 	return nft_quota_do_init(tb, priv);
 }
 
-static int nft_quota_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_quota_dump(struct sk_buff *skb,
+			  const struct nft_expr *expr, bool reset)
 {
 	struct nft_quota *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 832f0d725a9e..0566d6aaf1e5 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -111,7 +111,8 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	return err;
 }
 
-static int nft_range_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_range_dump(struct sk_buff *skb,
+			  const struct nft_expr *expr, bool reset)
 {
 	const struct nft_range_expr *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 5086adfe731c..5f7739987559 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -75,7 +75,8 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
 
-static int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_redir_dump(struct sk_buff *skb,
+			  const struct nft_expr *expr, bool reset)
 {
 	const struct nft_redir *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 927ff8459bd9..f2addc844dd2 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -69,7 +69,8 @@ int nft_reject_init(const struct nft_ctx *ctx,
 }
 EXPORT_SYMBOL_GPL(nft_reject_init);
 
-int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
+int nft_reject_dump(struct sk_buff *skb,
+		    const struct nft_expr *expr, bool reset)
 {
 	const struct nft_reject *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 71931ec91721..5990fdd7b3cc 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -146,7 +146,7 @@ static int nft_rt_get_init(const struct nft_ctx *ctx,
 }
 
 static int nft_rt_get_dump(struct sk_buff *skb,
-			   const struct nft_expr *expr)
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 49a5348a6a14..85f8df87efda 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -199,7 +199,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 }
 
 static int nft_socket_dump(struct sk_buff *skb,
-			   const struct nft_expr *expr)
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_socket *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 6cf9a04fbfe2..13da882669a4 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -272,7 +272,8 @@ static void nft_synproxy_destroy(const struct nft_ctx *ctx,
 	nft_synproxy_do_destroy(ctx);
 }
 
-static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_synproxy_dump(struct sk_buff *skb,
+			     const struct nft_expr *expr, bool reset)
 {
 	struct nft_synproxy *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 62da25ad264b..ea83f661417e 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -294,7 +294,7 @@ static void nft_tproxy_destroy(const struct nft_ctx *ctx,
 }
 
 static int nft_tproxy_dump(struct sk_buff *skb,
-			   const struct nft_expr *expr)
+			   const struct nft_expr *expr, bool reset)
 {
 	const struct nft_tproxy *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 983ade4be3b3..b059aa541798 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -108,7 +108,7 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 }
 
 static int nft_tunnel_get_dump(struct sk_buff *skb,
-			       const struct nft_expr *expr)
+			       const struct nft_expr *expr, bool reset)
 {
 	const struct nft_tunnel *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 1c5343c936a8..c88fd078a9ae 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -212,7 +212,7 @@ static void nft_xfrm_get_eval(const struct nft_expr *expr,
 }
 
 static int nft_xfrm_get_dump(struct sk_buff *skb,
-			     const struct nft_expr *expr)
+			     const struct nft_expr *expr, bool reset)
 {
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 
-- 
2.30.2

