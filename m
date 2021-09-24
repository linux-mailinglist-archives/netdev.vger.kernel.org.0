Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9CF417D9F
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345965AbhIXWNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49774 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345111AbhIXWM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:12:57 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 46BB563EA4;
        Sat, 25 Sep 2021 00:10:01 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 04/15] netfilter: conntrack: make max chain length random
Date:   Sat, 25 Sep 2021 00:11:02 +0200
Message-Id: <20210924221113.348767-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Similar to commit 67d6d681e15b
("ipv4: make exception cache less predictible"):

Use a random drop length to make it harder to detect when entries were
hashed to same bucket list.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 94e18fb9690d..91b7edaa635c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -77,7 +77,8 @@ static __read_mostly bool nf_conntrack_locks_all;
 #define GC_SCAN_INTERVAL	(120u * HZ)
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
-#define MAX_CHAINLEN	64u
+#define MIN_CHAINLEN	8u
+#define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -842,6 +843,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
+	unsigned int max_chainlen;
 	unsigned int chainlen = 0;
 	unsigned int sequence;
 	int err = -EEXIST;
@@ -857,13 +859,15 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
+	max_chainlen = MIN_CHAINLEN + prandom_u32_max(MAX_CHAINLEN);
+
 	/* See if there's one in the list already, including reverse */
 	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
 
-		if (chainlen++ > MAX_CHAINLEN)
+		if (chainlen++ > max_chainlen)
 			goto chaintoolong;
 	}
 
@@ -873,7 +877,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
-		if (chainlen++ > MAX_CHAINLEN)
+		if (chainlen++ > max_chainlen)
 			goto chaintoolong;
 	}
 
@@ -1103,8 +1107,8 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h,
 int
 __nf_conntrack_confirm(struct sk_buff *skb)
 {
+	unsigned int chainlen = 0, sequence, max_chainlen;
 	const struct nf_conntrack_zone *zone;
-	unsigned int chainlen = 0, sequence;
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -1168,6 +1172,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		goto dying;
 	}
 
+	max_chainlen = MIN_CHAINLEN + prandom_u32_max(MAX_CHAINLEN);
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
@@ -1175,7 +1180,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
-		if (chainlen++ > MAX_CHAINLEN)
+		if (chainlen++ > max_chainlen)
 			goto chaintoolong;
 	}
 
@@ -1184,7 +1189,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
-		if (chainlen++ > MAX_CHAINLEN) {
+		if (chainlen++ > max_chainlen) {
 chaintoolong:
 			nf_ct_add_to_dying_list(ct);
 			NF_CT_STAT_INC(net, chaintoolong);
-- 
2.30.2

