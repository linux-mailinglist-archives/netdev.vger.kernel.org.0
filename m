Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98DB4AF2F6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiBINgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiBINgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2700BC061355;
        Wed,  9 Feb 2022 05:36:31 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 887E5601CD;
        Wed,  9 Feb 2022 14:36:20 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 14/14] netfilter: ctnetlink: use dump structure instead of raw args
Date:   Wed,  9 Feb 2022 14:36:16 +0100
Message-Id: <20220209133616.165104-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

netlink_dump structure has a union of 'long args[6]' and a context
buffer as scratch space.

Convert ctnetlink to use a structure, its easier to read than the
raw 'args' usage which comes with no type checks and no readable names.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 36 ++++++++++++++++++----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ac438370f94a..3d9f9ee50294 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -58,6 +58,12 @@
 
 MODULE_LICENSE("GPL");
 
+struct ctnetlink_list_dump_ctx {
+	struct nf_conn *last;
+	unsigned int cpu;
+	bool done;
+};
+
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_l4proto *l4proto)
@@ -1694,14 +1700,18 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
 
 static int ctnetlink_done_list(struct netlink_callback *cb)
 {
-	if (cb->args[1])
-		nf_ct_put((struct nf_conn *)cb->args[1]);
+	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
+
+	if (ctx->last)
+		nf_ct_put(ctx->last);
+
 	return 0;
 }
 
 static int
 ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
 {
+	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
@@ -1712,12 +1722,12 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 	struct hlist_nulls_head *list;
 	struct net *net = sock_net(skb->sk);
 
-	if (cb->args[2])
+	if (ctx->done)
 		return 0;
 
-	last = (struct nf_conn *)cb->args[1];
+	last = ctx->last;
 
-	for (cpu = cb->args[0]; cpu < nr_cpu_ids; cpu++) {
+	for (cpu = ctx->cpu; cpu < nr_cpu_ids; cpu++) {
 		struct ct_pcpu *pcpu;
 
 		if (!cpu_possible(cpu))
@@ -1731,10 +1741,10 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (l3proto && nf_ct_l3num(ct) != l3proto)
 				continue;
-			if (cb->args[1]) {
+			if (ctx->last) {
 				if (ct != last)
 					continue;
-				cb->args[1] = 0;
+				ctx->last = NULL;
 			}
 
 			/* We can't dump extension info for the unconfirmed
@@ -1751,19 +1761,19 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 			if (res < 0) {
 				if (!refcount_inc_not_zero(&ct->ct_general.use))
 					continue;
-				cb->args[0] = cpu;
-				cb->args[1] = (unsigned long)ct;
+				ctx->cpu = cpu;
+				ctx->last = ct;
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
 			}
 		}
-		if (cb->args[1]) {
-			cb->args[1] = 0;
+		if (ctx->last) {
+			ctx->last = NULL;
 			goto restart;
 		}
 		spin_unlock_bh(&pcpu->lock);
 	}
-	cb->args[2] = 1;
+	ctx->done = true;
 out:
 	if (last)
 		nf_ct_put(last);
@@ -3877,6 +3887,8 @@ static int __init ctnetlink_init(void)
 {
 	int ret;
 
+	BUILD_BUG_ON(sizeof(struct ctnetlink_list_dump_ctx) > sizeof_field(struct netlink_callback, ctx));
+
 	ret = nfnetlink_subsys_register(&ctnl_subsys);
 	if (ret < 0) {
 		pr_err("ctnetlink_init: cannot register with nfnetlink.\n");
-- 
2.30.2

