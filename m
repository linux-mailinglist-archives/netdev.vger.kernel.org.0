Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FCD417D9B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbhIXWNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49780 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345143AbhIXWM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:12:58 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id A403A63EAA;
        Sat, 25 Sep 2021 00:10:02 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 06/15] netfilter: nat: include zone id in nat table hash again
Date:   Sat, 25 Sep 2021 00:11:04 +0200
Message-Id: <20210924221113.348767-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Similar to the conntrack change, also use the zone id for the nat source
lists if the zone id is valid in both directions.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7008961f5cb0..273117683922 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -150,13 +150,16 @@ static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 
 /* We keep an extra hash for each conntrack, for fast searching. */
 static unsigned int
-hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
+hash_by_src(const struct net *net,
+	    const struct nf_conntrack_zone *zone,
+	    const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int hash;
 	struct {
 		struct nf_conntrack_man src;
 		u32 net_mix;
 		u32 protonum;
+		u32 zone;
 	} __aligned(SIPHASH_ALIGNMENT) combined;
 
 	get_random_once(&nf_nat_hash_rnd, sizeof(nf_nat_hash_rnd));
@@ -165,9 +168,13 @@ hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
 
 	/* Original src, to ensure we map it consistently if poss. */
 	combined.src = tuple->src;
-	combined.net_mix = net_hash_mix(n);
+	combined.net_mix = net_hash_mix(net);
 	combined.protonum = tuple->dst.protonum;
 
+	/* Zone ID can be used provided its valid for both directions */
+	if (zone->dir == NF_CT_DEFAULT_ZONE_DIR)
+		combined.zone = zone->id;
+
 	hash = siphash(&combined, sizeof(combined), &nf_nat_hash_rnd);
 
 	return reciprocal_scale(hash, nf_nat_htable_size);
@@ -272,7 +279,7 @@ find_appropriate_src(struct net *net,
 		     struct nf_conntrack_tuple *result,
 		     const struct nf_nat_range2 *range)
 {
-	unsigned int h = hash_by_src(net, tuple);
+	unsigned int h = hash_by_src(net, zone, tuple);
 	const struct nf_conn *ct;
 
 	hlist_for_each_entry_rcu(ct, &nf_nat_bysource[h], nat_bysource) {
@@ -619,7 +626,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		unsigned int srchash;
 		spinlock_t *lock;
 
-		srchash = hash_by_src(net,
+		srchash = hash_by_src(net, nf_ct_zone(ct),
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
 		spin_lock_bh(lock);
@@ -788,7 +795,7 @@ static void __nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
 	unsigned int h;
 
-	h = hash_by_src(nf_ct_net(ct), &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	h = hash_by_src(nf_ct_net(ct), nf_ct_zone(ct), &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	spin_lock_bh(&nf_nat_locks[h % CONNTRACK_LOCKS]);
 	hlist_del_rcu(&ct->nat_bysource);
 	spin_unlock_bh(&nf_nat_locks[h % CONNTRACK_LOCKS]);
-- 
2.30.2

