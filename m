Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF474EC78
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfFUPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfFUPrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:47:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 62E26356EC;
        Fri, 21 Jun 2019 15:47:00 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBAF819C68;
        Fri, 21 Jun 2019 15:46:57 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v7 04/11] ipv4: Dump route exceptions if requested
Date:   Fri, 21 Jun 2019 17:45:23 +0200
Message-Id: <8d3b68cd37fb5fddc470904cdd6793fcf480c6c1.1561131177.git.sbrivio@redhat.com>
In-Reply-To: <cover.1561131177.git.sbrivio@redhat.com>
References: <cover.1561131177.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 21 Jun 2019 15:47:05 +0000 (UTC)
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

A single additional argument is sufficient, even if we traverse logically
nested structures (nexthop objects, hash table buckets, bucket chains): it
doesn't matter if we stop in the middle of any of those, because they are
always traversed the same way. As an example, s_i values in [], s_fa
values in ():

  node (fa) #1 [1]
    nexthop #1
    bucket #1 -> #0 in chain (1)
    bucket #2 -> #0 in chain (2) -> #1 in chain (3) -> #2 in chain (4)
    bucket #3 -> #0 in chain (5) -> #1 in chain (6)

    nexthop #2
    bucket #1 -> #0 in chain (7) -> #1 in chain (8)
    bucket #2 -> #0 in chain (9)
  --
  node (fa) #2 [2]
    nexthop #1
    bucket #1 -> #0 in chain (1) -> #1 in chain (2)
    bucket #2 -> #0 in chain (3)

it doesn't matter if we stop at (3), (4), (7) for "node #1", or at (2)
for "node #2": walking flattens all that.

It would even be possible to drop the distinction between the in-tree
(s_i) and in-node (s_fa) counter, but a further improvement might
advise against this. This is only as accurate as the existing tracking
mechanism for leaves: if a partial dump is restarted after exceptions
are removed or expired, we might skip some non-dumped entries.

To improve this, we could attach a 'sernum' attribute (similar to the
one used for IPv6) to nexthop entities, and bump this counter whenever
exceptions change: having a distinction between the two counters would
make this more convenient.

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

v7:
   - Move loop over nexthop objects to route.c, and pass struct fib_info
     and table ID to it, not a struct fib_alias (suggested by David Ahern)
   - While at it, note that the NULL check on fa->fa_info is redundant,
     and the check on RTNH_F_DEAD is also not consistent with what's done
     with regular route listing: just keep it for nhc_flags
   - Rename entry point function for dumping exceptions to
     fib_dump_info_fnhe(), and rearrange arguments for consistency with
     fib_dump_info()
   - Rename fnhe_dump_buckets() to fnhe_dump_bucket() and make it handle
     one bucket at a time
   - Expand commit message to describe why we can have a single "skip"
     counter for all exceptions stored in bucket chains in nexthop objects
     (suggested by David Ahern)

v6:
   - Rebased onto net-next
   - Loop over nexthop paths too. Move loop over fnhe buckets to route.c,
     avoids need to export rt_fill_info() and to touch exceptions from
     fib_trie.c. Pass NULL as flow to rt_fill_info(), it now allows that
     (suggested by David Ahern)

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/net/route.h |  4 +++
 net/ipv4/fib_trie.c | 44 +++++++++++++++++++--------
 net/ipv4/route.c    | 73 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 13 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 065b47754f05..cfcd0f5980f9 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -230,6 +230,10 @@ void fib_modify_prefix_metric(struct in_ifaddr *ifa, u32 new_metric);
 void rt_add_uncached_list(struct rtable *rt);
 void rt_del_uncached_list(struct rtable *rt);
 
+int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
+		       u32 table_id, struct fib_info *fi,
+		       int *fa_index, int fa_start);
+
 static inline void ip_rt_put(struct rtable *rt)
 {
 	/* dst_release() accepts a NULL parameter.
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 90f0fc8c87bd..4400f5051977 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2090,22 +2090,26 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
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
+		struct fib_info *fi = fa->fa_info;
 
 		if (i < s_i)
 			goto next;
 
+		i_fa = 0;
+
 		if (tb->tb_id != fa->tb_id)
 			goto next;
 
@@ -2114,29 +2118,43 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				goto next;
 
 			if ((filter->protocol &&
-			     fa->fa_info->fib_protocol != filter->protocol))
+			     fi->fib_protocol != filter->protocol))
 				goto next;
 
 			if (filter->dev &&
-			    !fib_info_nh_uses_dev(fa->fa_info, filter->dev))
+			    !fib_info_nh_uses_dev(fi, filter->dev))
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
+					    fa->fa_tos, fi, flags);
+			if (err < 0)
+				goto stop;
+			i_fa++;
 		}
+
+		if (filter->dump_exceptions) {
+			err = fib_dump_info_fnhe(skb, cb, tb->tb_id, fi,
+						 &i_fa, s_fa);
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
index b1628d25e828..6aee412a68bd 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2812,6 +2812,79 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	return -EMSGSIZE;
 }
 
+static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
+			    struct netlink_callback *cb, u32 table_id,
+			    struct fnhe_hash_bucket *bucket, int genid,
+			    int *fa_index, int fa_start)
+{
+	int i;
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
+					   table_id, NULL, skb,
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
+int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
+		       u32 table_id, struct fib_info *fi,
+		       int *fa_index, int fa_start)
+{
+	struct net *net = sock_net(cb->skb->sk);
+	int nhsel, genid = fnhe_genid(net);
+
+	for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
+		struct fib_nh_common *nhc = fib_info_nhc(fi, nhsel);
+		struct fnhe_hash_bucket *bucket;
+		int err;
+
+		if (nhc->nhc_flags & RTNH_F_DEAD)
+			continue;
+
+		bucket = rcu_dereference(nhc->nhc_exceptions);
+		if (!bucket)
+			continue;
+
+		err = fnhe_dump_bucket(net, skb, cb, table_id, bucket, genid,
+				       fa_index, fa_start);
+		if (err)
+			return err;
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

