Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF34417D98
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345790AbhIXWNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49768 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345097AbhIXWM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:12:57 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 063F763EB2;
        Sat, 25 Sep 2021 00:10:01 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 05/15] netfilter: conntrack: include zone id in tuple hash again
Date:   Sat, 25 Sep 2021 00:11:03 +0200
Message-Id: <20210924221113.348767-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit deedb59039f111 ("netfilter: nf_conntrack: add direction support for zones")
removed the zone id from the hash value.

This has implications on hash chain lengths with overlapping tuples, which
can hit 64k entries on released kernels, before upper droplimit was added
in d7e7747ac5c ("netfilter: refuse insertion if chain has grown too large").

With that change reverted, test script coming with this series shows
linear insertion time growth:

 10000 entries in 3737 ms (now 10000 total, loop 1)
 10000 entries in 16994 ms (now 20000 total, loop 2)
 10000 entries in 47787 ms (now 30000 total, loop 3)
 10000 entries in 72731 ms (now 40000 total, loop 4)
 10000 entries in 95761 ms (now 50000 total, loop 5)
 10000 entries in 96809 ms (now 60000 total, loop 6)
 inserted 60000 entries from packet path in 333825 ms

With d7e7747ac5c in place, the test fails.

There are three supported zone use cases:
 1. Connection is in the default zone (zone 0).
    This means to special config (the default).
 2. Connection is in a different zone (1 to 2**16).
    This means rules are in place to put packets in
    the desired zone, e.g. derived from vlan id or interface.
 3. Original direction is in zone X and Reply is in zone 0.

3) allows to use of the existing NAT port collision avoidance to provide
   connectivity to internet/wan even when the various zones have overlapping
   source networks separated via policy routing.

In case the original zone is 0 all three cases are identical.

There is no way to place original direction in zone x and reply in
zone y (with y != 0).

Zones need to be assigned manually via the iptables/nftables ruleset,
before conntrack lookup occurs (raw table in iptables) using the
"CT" target conntrack template support
(-j CT --{zone,zone-orig,zone-reply} X).

Normally zone assignment happens based on incoming interface, but could
also be derived from packet mark, vlan id and so on.

This means that when case 3 is used, the ruleset will typically not even
assign a connection tracking template to the "reply" packets, so lookup
happens in zone 0.

However, it is possible that reply packets also match a ct zone
assignment rule which sets up a template for zone X (X > 0) in original
direction only.

Therefore, after making the zone id part of the hash, we need to do a
second lookup using the reply zone id if we did not find an entry on
the first lookup.

In practice, most deployments will either not use zones at all or the
origin and reply zones are the same, no second lookup is required in
either case.

After this change, packet path insertion test passes with constant
insertion times:

 10000 entries in 1064 ms (now 10000 total, loop 1)
 10000 entries in 1074 ms (now 20000 total, loop 2)
 10000 entries in 1066 ms (now 30000 total, loop 3)
 10000 entries in 1079 ms (now 40000 total, loop 4)
 10000 entries in 1081 ms (now 50000 total, loop 5)
 10000 entries in 1082 ms (now 60000 total, loop 6)
 inserted 60000 entries from packet path in 6452 ms

Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 67 ++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 91b7edaa635c..97b91d62589d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -189,11 +189,13 @@ seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static siphash_key_t nf_conntrack_hash_rnd __read_mostly;
 
 static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
+			      unsigned int zoneid,
 			      const struct net *net)
 {
 	struct {
 		struct nf_conntrack_man src;
 		union nf_inet_addr dst_addr;
+		unsigned int zone;
 		u32 net_mix;
 		u16 dport;
 		u16 proto;
@@ -206,6 +208,7 @@ static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
 	/* The direction must be ignored, so handle usable members manually. */
 	combined.src = tuple->src;
 	combined.dst_addr = tuple->dst.u3;
+	combined.zone = zoneid;
 	combined.net_mix = net_hash_mix(net);
 	combined.dport = (__force __u16)tuple->dst.u.all;
 	combined.proto = tuple->dst.protonum;
@@ -220,15 +223,17 @@ static u32 scale_hash(u32 hash)
 
 static u32 __hash_conntrack(const struct net *net,
 			    const struct nf_conntrack_tuple *tuple,
+			    unsigned int zoneid,
 			    unsigned int size)
 {
-	return reciprocal_scale(hash_conntrack_raw(tuple, net), size);
+	return reciprocal_scale(hash_conntrack_raw(tuple, zoneid, net), size);
 }
 
 static u32 hash_conntrack(const struct net *net,
-			  const struct nf_conntrack_tuple *tuple)
+			  const struct nf_conntrack_tuple *tuple,
+			  unsigned int zoneid)
 {
-	return scale_hash(hash_conntrack_raw(tuple, net));
+	return scale_hash(hash_conntrack_raw(tuple, zoneid, net));
 }
 
 static bool nf_ct_get_tuple_ports(const struct sk_buff *skb,
@@ -651,9 +656,11 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
 		hash = hash_conntrack(net,
-				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				      nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_ORIGINAL));
 		reply_hash = hash_conntrack(net,
-					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
 	clean_from_lists(ct);
@@ -820,8 +827,20 @@ struct nf_conntrack_tuple_hash *
 nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		      const struct nf_conntrack_tuple *tuple)
 {
-	return __nf_conntrack_find_get(net, zone, tuple,
-				       hash_conntrack_raw(tuple, net));
+	unsigned int rid, zone_id = nf_ct_zone_id(zone, IP_CT_DIR_ORIGINAL);
+	struct nf_conntrack_tuple_hash *thash;
+
+	thash = __nf_conntrack_find_get(net, zone, tuple,
+					hash_conntrack_raw(tuple, zone_id, net));
+
+	if (thash)
+		return thash;
+
+	rid = nf_ct_zone_id(zone, IP_CT_DIR_REPLY);
+	if (rid != zone_id)
+		return __nf_conntrack_find_get(net, zone, tuple,
+					       hash_conntrack_raw(tuple, rid, net));
+	return thash;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
 
@@ -854,9 +873,11 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
 		hash = hash_conntrack(net,
-				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				      nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_ORIGINAL));
 		reply_hash = hash_conntrack(net,
-					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
 	max_chainlen = MIN_CHAINLEN + prandom_u32_max(MAX_CHAINLEN);
@@ -1137,8 +1158,8 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		hash = *(unsigned long *)&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev;
 		hash = scale_hash(hash);
 		reply_hash = hash_conntrack(net,
-					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-
+					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
 	/* We're not in hash table, and we refuse to set up related
@@ -1251,7 +1272,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	rcu_read_lock();
  begin:
 	nf_conntrack_get_ht(&ct_hash, &hsize);
-	hash = __hash_conntrack(net, tuple, hsize);
+	hash = __hash_conntrack(net, tuple, nf_ct_zone_id(zone, IP_CT_DIR_REPLY), hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[hash], hnnode) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
@@ -1692,8 +1713,8 @@ resolve_normal_ct(struct nf_conn *tmpl,
 	struct nf_conntrack_tuple_hash *h;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_zone tmp;
+	u32 hash, zone_id, rid;
 	struct nf_conn *ct;
-	u32 hash;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, state->pf, protonum, state->net,
@@ -1704,8 +1725,20 @@ resolve_normal_ct(struct nf_conn *tmpl,
 
 	/* look for tuple match */
 	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
-	hash = hash_conntrack_raw(&tuple, state->net);
+
+	zone_id = nf_ct_zone_id(zone, IP_CT_DIR_ORIGINAL);
+	hash = hash_conntrack_raw(&tuple, zone_id, state->net);
 	h = __nf_conntrack_find_get(state->net, zone, &tuple, hash);
+
+	if (!h) {
+		rid = nf_ct_zone_id(zone, IP_CT_DIR_REPLY);
+		if (zone_id != rid) {
+			u32 tmp = hash_conntrack_raw(&tuple, rid, state->net);
+
+			h = __nf_conntrack_find_get(state->net, zone, &tuple, tmp);
+		}
+	}
+
 	if (!h) {
 		h = init_conntrack(state->net, tmpl, &tuple,
 				   skb, dataoff, hash);
@@ -2542,12 +2575,16 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
 		while (!hlist_nulls_empty(&nf_conntrack_hash[i])) {
+			unsigned int zone_id;
+
 			h = hlist_nulls_entry(nf_conntrack_hash[i].first,
 					      struct nf_conntrack_tuple_hash, hnnode);
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			hlist_nulls_del_rcu(&h->hnnode);
+
+			zone_id = nf_ct_zone_id(nf_ct_zone(ct), NF_CT_DIRECTION(h));
 			bucket = __hash_conntrack(nf_ct_net(ct),
-						  &h->tuple, hashsize);
+						  &h->tuple, zone_id, hashsize);
 			hlist_nulls_add_head_rcu(&h->hnnode, &hash[bucket]);
 		}
 	}
-- 
2.30.2

