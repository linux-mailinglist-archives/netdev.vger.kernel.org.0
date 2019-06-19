Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E759D4C447
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbfFTAAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfFTAAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 20:00:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A5476EB83;
        Thu, 20 Jun 2019 00:00:23 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBFD219C5B;
        Thu, 20 Jun 2019 00:00:20 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v6 04/11] ipv4: Dump route exceptions if requested
Date:   Thu, 20 Jun 2019 01:59:44 +0200
Message-Id: <b5aacd9a3a3f4b256dfd091cdd8771d0f6a1aea2.1560987611.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560987611.git.sbrivio@redhat.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 20 Jun 2019 00:00:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions."), cached
exception routes are stored as a separate entity, so they are not dumped
on a FIB dump, even if the RTM_F_CLONED flag is passed.

This implies that the command 'ip route list cache' doesn't return any
result anymore.

If the RTM_F_CLONED is passed, and strict checking requested, retrieve
nexthop exception routes and dump them. If no strict checking is
requested, filtering can't be performed consistently: dump everything in
that case.

With this, we need to add an argument to the netlink callback in order to
track how many entries were already dumped for the last leaf included in
a partial netlink dump.

Note that this is only as accurate as the existing tracking mechanism for
leaves: if a partial dump is restarted after exceptions are removed or
expired, we might skip some non-dumped entries. To improve this, we could
attach a 'sernum' attribute (similar to the one used for IPv6) to nexthop
entities, and bump this counter whenever exceptions change.

Listing of exception routes (modified routes pre-3.5) was tested against
these versions of kernel and iproute2:

                    iproute2
kernel         4.14.0   4.15.0   4.19.0   5.0.0   5.1.0
 3.5-rc4         +        +        +        +       +
 4.4
 4.9
 4.14
 4.15
 4.19
 5.0
 5.1
 fixed           +        +        +        +       +

v6:
   - Rebased onto net-next
   - Loop over nexthop paths too. Move loop over fnhe buckets to route.c,
     avoids need to export rt_fill_info() and to touch exceptions from
     fib_trie.c. Pass NULL as flow to rt_fill_info(), it now allows that
     (all suggested by David Ahern)

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/net/route.h |  4 +++
 net/ipv4/fib_trie.c | 60 ++++++++++++++++++++++++++++++++++++---------
 net/ipv4/route.c    | 56 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 12 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 065b47754f05..e7f65388a6d4 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -44,6 +44,7 @@
 #define RT_CONN_FLAGS_TOS(sk,tos)   (RT_TOS(tos) | sock_flag(sk, SOCK_LOCALROUTE))
 
 struct fib_nh;
+struct fib_alias;
 struct fib_info;
 struct uncached_list;
 struct rtable {
@@ -230,6 +231,9 @@ void fib_modify_prefix_metric(struct in_ifaddr *ifa, u32 new_metric);
 void rt_add_uncached_list(struct rtable *rt);
 void rt_del_uncached_list(struct rtable *rt);
 
+int fnhe_dump_buckets(struct fib_alias *fa, int nhsel, struct sk_buff *skb,
+		      struct netlink_callback *cb, int *fa_index, int fa_start);
+
 static inline void ip_rt_put(struct rtable *rt)
 {
 	/* dst_release() accepts a NULL parameter.
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 94e5d83db4db..03f51e5192e5 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2078,28 +2078,51 @@ void fib_free_table(struct fib_table *tb)
 	call_rcu(&tb->rcu, __trie_free_rcu);
 }
 
+static int fib_dump_fnhe_from_leaf(struct fib_alias *fa, struct sk_buff *skb,
+				   struct netlink_callback *cb,
+				   int *fa_index, int fa_start)
+{
+	struct fib_info *fi = fa->fa_info;
+	int nhsel;
+
+	if (!fi || fi->fib_flags & RTNH_F_DEAD)
+		return 0;
+
+	for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
+		int err;
+
+		err = fnhe_dump_buckets(fa, nhsel, skb, cb, fa_index, fa_start);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 			     struct sk_buff *skb, struct netlink_callback *cb,
 			     struct fib_dump_filter *filter)
 {
 	unsigned int flags = NLM_F_MULTI;
 	__be32 xkey = htonl(l->key);
+	int i, s_i, i_fa, s_fa, err;
 	struct fib_alias *fa;
-	int i, s_i;
 
-	if (filter->filter_set)
+	if (filter->filter_set ||
+	    !filter->dump_exceptions || !filter->dump_routes)
 		flags |= NLM_F_DUMP_FILTERED;
 
 	s_i = cb->args[4];
+	s_fa = cb->args[5];
 	i = 0;
 
 	/* rcu_read_lock is hold by caller */
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
-		int err;
-
 		if (i < s_i)
 			goto next;
 
+		i_fa = 0;
+
 		if (tb->tb_id != fa->tb_id)
 			goto next;
 
@@ -2116,21 +2139,34 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				goto next;
 		}
 
-		err = fib_dump_info(skb, NETLINK_CB(cb->skb).portid,
-				    cb->nlh->nlmsg_seq, RTM_NEWROUTE,
-				    tb->tb_id, fa->fa_type,
-				    xkey, KEYLENGTH - fa->fa_slen,
-				    fa->fa_tos, fa->fa_info, flags);
-		if (err < 0) {
-			cb->args[4] = i;
-			return err;
+		if (filter->dump_routes && !s_fa) {
+			err = fib_dump_info(skb, NETLINK_CB(cb->skb).portid,
+					    cb->nlh->nlmsg_seq, RTM_NEWROUTE,
+					    tb->tb_id, fa->fa_type,
+					    xkey, KEYLENGTH - fa->fa_slen,
+					    fa->fa_tos, fa->fa_info, flags);
+			if (err < 0)
+				goto stop;
+			i_fa++;
 		}
+
+		if (filter->dump_exceptions) {
+			err = fib_dump_fnhe_from_leaf(fa, skb, cb, &i_fa, s_fa);
+			if (err < 0)
+				goto stop;
+		}
+
 next:
 		i++;
 	}
 
 	cb->args[4] = i;
 	return skb->len;
+
+stop:
+	cb->args[4] = i;
+	cb->args[5] = i_fa;
+	return err;
 }
 
 /* rcu_read_lock needs to be hold by caller from readside */
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 052a80373b1d..b3961a135dfc 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2813,6 +2813,62 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	return -EMSGSIZE;
 }
 
+int fnhe_dump_buckets(struct fib_alias *fa, int nhsel, struct sk_buff *skb,
+		      struct netlink_callback *cb, int *fa_index, int fa_start)
+{
+	struct net *net = sock_net(cb->skb->sk);
+	struct fnhe_hash_bucket *bucket;
+	struct fib_nh_common *nhc;
+	int i, genid;
+
+	nhc = fib_info_nhc(fa->fa_info, nhsel);
+	if (nhc->nhc_flags & RTNH_F_DEAD)
+		return 0;
+
+	bucket = rcu_dereference(nhc->nhc_exceptions);
+	if (!bucket)
+		return 0;
+
+	genid = fnhe_genid(net);
+
+	for (i = 0; i < FNHE_HASH_SIZE; i++) {
+		struct fib_nh_exception *fnhe;
+
+		for (fnhe = rcu_dereference(bucket[i].chain); fnhe;
+		     fnhe = rcu_dereference(fnhe->fnhe_next)) {
+			struct rtable *rt;
+			int err;
+
+			if (*fa_index < fa_start)
+				goto next;
+
+			if (fnhe->fnhe_genid != genid)
+				goto next;
+
+			if (fnhe->fnhe_expires &&
+			    time_after(jiffies, fnhe->fnhe_expires))
+				goto next;
+
+			rt = rcu_dereference(fnhe->fnhe_rth_input);
+			if (!rt)
+				rt = rcu_dereference(fnhe->fnhe_rth_output);
+			if (!rt)
+				goto next;
+
+			err = rt_fill_info(net, fnhe->fnhe_daddr, 0, rt,
+					   fa->tb_id, NULL, skb,
+					   NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq);
+			if (err)
+				return err;
+next:
+			(*fa_index)++;
+		}
+	}
+
+	return 0;
+}
+
 static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
 						   u8 ip_proto, __be16 sport,
 						   __be16 dport)
-- 
2.20.1

