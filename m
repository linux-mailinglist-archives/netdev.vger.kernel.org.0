Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831634FB993
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345476AbiDKKaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344899AbiDKKaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9FA639169;
        Mon, 11 Apr 2022 03:27:51 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4B2326302B;
        Mon, 11 Apr 2022 12:23:50 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/11] netfilter: conntrack: split inner loop of list dumping to own function
Date:   Mon, 11 Apr 2022 12:27:36 +0200
Message-Id: <20220411102744.282101-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
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

This allows code re-use in the followup patch.
No functional changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 68 ++++++++++++++++++----------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1ea2ad732d57..924d766e6c53 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1708,6 +1708,47 @@ static int ctnetlink_done_list(struct netlink_callback *cb)
 	return 0;
 }
 
+static int ctnetlink_dump_one_entry(struct sk_buff *skb,
+				    struct netlink_callback *cb,
+				    struct nf_conn *ct,
+				    bool dying)
+{
+	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	u8 l3proto = nfmsg->nfgen_family;
+	int res;
+
+	if (l3proto && nf_ct_l3num(ct) != l3proto)
+		return 0;
+
+	if (ctx->last) {
+		if (ct != ctx->last)
+			return 0;
+
+		ctx->last = NULL;
+	}
+
+	/* We can't dump extension info for the unconfirmed
+	 * list because unconfirmed conntracks can have
+	 * ct->ext reallocated (and thus freed).
+	 *
+	 * In the dying list case ct->ext can't be free'd
+	 * until after we drop pcpu->lock.
+	 */
+	res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq,
+				  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
+				  ct, dying, 0);
+	if (res < 0) {
+		if (!refcount_inc_not_zero(&ct->ct_general.use))
+			return 0;
+
+		ctx->last = ct;
+	}
+
+	return res;
+}
+
 static int
 ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
 {
@@ -1715,12 +1756,9 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	u_int8_t l3proto = nfmsg->nfgen_family;
-	int res;
-	int cpu;
 	struct hlist_nulls_head *list;
 	struct net *net = sock_net(skb->sk);
+	int res, cpu;
 
 	if (ctx->done)
 		return 0;
@@ -1739,30 +1777,10 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 restart:
 		hlist_nulls_for_each_entry(h, n, list, hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (l3proto && nf_ct_l3num(ct) != l3proto)
-				continue;
-			if (ctx->last) {
-				if (ct != last)
-					continue;
-				ctx->last = NULL;
-			}
 
-			/* We can't dump extension info for the unconfirmed
-			 * list because unconfirmed conntracks can have
-			 * ct->ext reallocated (and thus freed).
-			 *
-			 * In the dying list case ct->ext can't be free'd
-			 * until after we drop pcpu->lock.
-			 */
-			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
-						  cb->nlh->nlmsg_seq,
-						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct, dying, 0);
+			res = ctnetlink_dump_one_entry(skb, cb, ct, dying);
 			if (res < 0) {
-				if (!refcount_inc_not_zero(&ct->ct_general.use))
-					continue;
 				ctx->cpu = cpu;
-				ctx->last = ct;
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
 			}
-- 
2.30.2

