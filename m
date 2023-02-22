Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4B969F13D
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjBVJVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjBVJVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:21:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D732937F16;
        Wed, 22 Feb 2023 01:21:44 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/8] netfilter: conntrack: fix rmmod double-free race
Date:   Wed, 22 Feb 2023 10:21:32 +0100
Message-Id: <20230222092137.88637-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222092137.88637-1-pablo@netfilter.org>
References: <20230222092137.88637-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_conntrack_hash_check_insert() callers free the ct entry directly, via
nf_conntrack_free.

This isn't safe anymore because
nf_conntrack_hash_check_insert() might place the entry into the conntrack
table and then delteted the entry again because it found that a conntrack
extension has been removed at the same time.

In this case, the just-added entry is removed again and an error is
returned to the caller.

Problem is that another cpu might have picked up this entry and
incremented its reference count.

This results in a use-after-free/double-free, once by the other cpu and
once by the caller of nf_conntrack_hash_check_insert().

Fix this by making nf_conntrack_hash_check_insert() not fail anymore
after the insertion, just like before the 'Fixes' commit.

This is safe because a racing nf_ct_iterate() has to wait for us
to release the conntrack hash spinlocks.

While at it, make the function return -EAGAIN in the rmmod (genid
changed) case, this makes nfnetlink replay the command (suggested
by Pablo Neira).

Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_bpf.c     |  1 -
 net/netfilter/nf_conntrack_core.c    | 25 +++++++++++++++----------
 net/netfilter/nf_conntrack_netlink.c |  3 ---
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 24002bc61e07..e1af14e3b63c 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -381,7 +381,6 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
-	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
 		nf_conntrack_free(nfct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 496c4920505b..ead11a9c261f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -886,10 +886,8 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
-	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
-		return -ETIMEDOUT;
-	}
+	if (!nf_ct_ext_valid_pre(ct->ext))
+		return -EAGAIN;
 
 	local_bh_disable();
 	do {
@@ -924,6 +922,19 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 			goto chaintoolong;
 	}
 
+	/* If genid has changed, we can't insert anymore because ct
+	 * extensions could have stale pointers and nf_ct_iterate_destroy
+	 * might have completed its table scan already.
+	 *
+	 * Increment of the ext genid right after this check is fine:
+	 * nf_ct_iterate_destroy blocks until locks are released.
+	 */
+	if (!nf_ct_ext_valid_post(ct->ext)) {
+		err = -EAGAIN;
+		goto out;
+	}
+
+	ct->status |= IPS_CONFIRMED;
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
@@ -932,12 +943,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
 
-	if (!nf_ct_ext_valid_post(ct->ext)) {
-		nf_ct_kill(ct);
-		NF_CT_STAT_INC_ATOMIC(net, drop);
-		return -ETIMEDOUT;
-	}
-
 	return 0;
 chaintoolong:
 	NF_CT_STAT_INC(net, chaintoolong);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ca4d5bb1ea52..733bb56950c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2316,9 +2316,6 @@ ctnetlink_create_conntrack(struct net *net,
 	nfct_seqadj_ext_add(ct);
 	nfct_synproxy_ext_add(ct);
 
-	/* we must add conntrack extensions before confirmation. */
-	ct->status |= IPS_CONFIRMED;
-
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
-- 
2.30.2

