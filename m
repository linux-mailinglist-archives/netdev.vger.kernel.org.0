Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 193654A1F3
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbfFRNU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfFRNU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:20:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 777FC307FBCB;
        Tue, 18 Jun 2019 13:20:56 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F65960D28;
        Tue, 18 Jun 2019 13:20:53 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v5 3/6] ipv4: Dump route exceptions if requested
Date:   Tue, 18 Jun 2019 15:20:36 +0200
Message-Id: <106687f38b1eaf957f4ff2bad343519231815482.1560827176.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560827176.git.sbrivio@redhat.com>
References: <cover.1560827176.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 18 Jun 2019 13:20:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions."), cached
exception routes are stored as a separate entity, so they are not dumped
on a FIB dump, even if the RTM_F_CLONED flag is passed.

This implies that the command 'ip route list cache' doesn't return any
result anymore.

If the RTM_F_CLONED flag is passed, and strict checking requested,
retrieve nexthop exception routes and dump them. If no strict checking
is requested, filtering can't be performed consistently: dump everything
in that case.

With this, we need to add an argument to the netlink callback in order to
track how many entries were already dumped for the last leaf included in
a partial netlink dump.

Note that this is only as accurate as the existing tracking mechanism for
leaves: if a partial dump is restarted after exceptions are removed or
expired, we might skip some non-dumped entries. To improve this, we could
attach a 'sernum' attribute (similar to the one used for IPv6) to nexthop
entities, and bump this counter whenever exceptions change.

Listing of exception routes (pre-3.5: modified routes) was tested against
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

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v5: Trivial adaptation for 1/6

v4: New patch

 include/net/route.h |   3 ++
 net/ipv4/fib_trie.c | 101 ++++++++++++++++++++++++++++++++++++++------
 net/ipv4/route.c    |   6 +--
 3 files changed, 95 insertions(+), 15 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 065b47754f05..f0d0086e76ce 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -221,6 +221,9 @@ void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
 struct rtable *rt_dst_alloc(struct net_device *dev,
 			     unsigned int flags, u16 type,
 			     bool nopolicy, bool noxfrm, bool will_cache);
+int rt_fill_info(struct net *net, __be32 dst, __be32 src, struct rtable *rt,
+		 u32 table_id, struct flowi4 *fl4, struct sk_buff *skb,
+		 u32 portid, u32 seq);
 
 struct in_ifaddr;
 void fib_add_ifaddr(struct in_ifaddr *);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 868c74771fa9..a00408827ae8 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2000,28 +2000,92 @@ void fib_free_table(struct fib_table *tb)
 	call_rcu(&tb->rcu, __trie_free_rcu);
 }
 
+static int fib_dump_fnhe_from_leaf(struct fib_alias *fa, struct sk_buff *skb,
+				   struct netlink_callback *cb,
+				   int *fa_index, int fa_start)
+{
+	struct net *net = sock_net(cb->skb->sk);
+	struct fib_info *fi = fa->fa_info;
+	struct fnhe_hash_bucket *bucket;
+	struct fib_nh_common *nhc;
+	int i, genid;
+
+	if (!fi || fi->fib_flags & RTNH_F_DEAD)
+		return 0;
+
+	nhc = fib_info_nhc(fi, 0);
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
+			struct flowi4 fl4 = {};
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
+					   fa->tb_id, &fl4, skb,
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
 
@@ -2038,21 +2102,34 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
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
+		}
+
+		if (filter->dump_exceptions) {
+			err = fib_dump_fnhe_from_leaf(fa, skb, cb, &i_fa, s_fa);
+			if (err < 0)
+				goto stop;
 		}
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
index 6cb7cff22db9..cc970fd861e8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2663,9 +2663,9 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
 EXPORT_SYMBOL_GPL(ip_route_output_flow);
 
 /* called with rcu_read_lock held */
-static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
-			struct rtable *rt, u32 table_id, struct flowi4 *fl4,
-			struct sk_buff *skb, u32 portid, u32 seq)
+int rt_fill_info(struct net *net, __be32 dst, __be32 src, struct rtable *rt,
+		 u32 table_id, struct flowi4 *fl4, struct sk_buff *skb,
+		 u32 portid, u32 seq)
 {
 	struct rtmsg *r;
 	struct nlmsghdr *nlh;
-- 
2.20.1

