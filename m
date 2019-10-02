Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494FDC49CC
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfJBIlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42023 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727942AbfJBIlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F20A622318;
        Wed,  2 Oct 2019 04:41:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=tijckC9qZZFqCQU5HJgcSg63Wrov86xf9S4u2GYRP9A=; b=sgspC6Ji
        Joy4++mvHUkm3BJ+SYG9VpVVno8zk1aBgpfJR8QvxthJf5iHnQCJuOyvXA99x2O2
        waTtO0q41dI7ggAkZsN5b6t3ZOQcPC8bSD2s3IcG6iyCw+JY1xau1eghcmqomeRI
        GHkNu1ZhbrnVoWiaPhdFWGqk8m6nPTgHxUvDvv2u7aI6YKnheYIgrkFIK+n5c7Kv
        CiEF5pWlcd77nutS050pRc75pX3DepWEw2tiqRHnn+8UGSGY9zTm94y/WFQml17I
        106LtX3OrMvCdUL7SaxXnovgytWFB9OQwcwx7jCbW+gSoCxpoC695cBhNF8srfAR
        mdQGpx10bzSd/A==
X-ME-Sender: <xms:zGKUXcqWSIXZ8umNlwtZvJopl3owCwqSuPwUgQmLOa9dl9Wp0_iVZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:zGKUXWqgLGgSuJJPkQ3HZ_6mOqWy-y9jCuejLmTQno9RdsauN3wNNw>
    <xmx:zGKUXR2-hxQJxfHQJ6bkMIFw0p-Jwx2HWAVBUZ4wX753fqwh5yLymA>
    <xmx:zGKUXTxOWbDYxKlz6OXdFVQsRjMNLk_U4nrWx9pmExnopB1eFjVkCw>
    <xmx:zGKUXZ-RFYItb9nvZ6UU6mZDUoC0tyPxZiOkuYzoAfWvMjbUGy1boA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C883D60065;
        Wed,  2 Oct 2019 04:41:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to routes
Date:   Wed,  2 Oct 2019 11:41:00 +0300
Message-Id: <20191002084103.12138-13-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When performing L3 offload, routes and nexthops are usually programmed
into two different tables in the underlying device. Therefore, the fact
that a nexthop resides in hardware does not necessarily mean that all
the associated routes also reside in hardware and vice-versa.

While the kernel can signal to user space the presence of a nexthop in
hardware (via 'RTNH_F_OFFLOAD'), it does not have a corresponding flag
for routes. In addition, the fact that a route resides in hardware does
not necessarily mean that the traffic is offloaded. For example,
unreachable routes (i.e., 'RTN_UNREACHABLE') are programmed to trap
packets to the CPU so that the kernel will be able to generate the
appropriate ICMP error packet.

This patch adds an "in hardware" indication to IPv4 routes, so that
users will have better visibility into the offload process. In the
future IPv6 will be extended with this indication as well.

'struct fib_alias' is extended with a new field that indicates if
the route resides in hardware or not. Note that the new field is added
in the 6 bytes hole and therefore the struct still fits in a single
cache line [1].

Capable drivers are expected to invoke fib_alias_in_hw_{set,clear}()
with the route's key in order to set / clear the "in hardware
indication".

The new indication is dumped to user space via a new flag (i.e.,
'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.

[1]
struct fib_alias {
        struct hlist_node  fa_list;                      /*     0    16 */
        struct fib_info *          fa_info;              /*    16     8 */
        u8                         fa_tos;               /*    24     1 */
        u8                         fa_type;              /*    25     1 */
        u8                         fa_state;             /*    26     1 */
        u8                         fa_slen;              /*    27     1 */
        u32                        tb_id;                /*    28     4 */
        s16                        fa_default;           /*    32     2 */
        u8                         in_hw:1;              /*    34: 0  1 */
        u8                         unused:7;             /*    34: 1  1 */

        /* XXX 5 bytes hole, try to pack */

        struct callback_head rcu __attribute__((__aligned__(8))); /*    40    16 */

        /* size: 56, cachelines: 1, members: 11 */
        /* sum members: 50, holes: 1, sum holes: 5 */
        /* sum bitfield members: 8 bits (1 bytes) */
        /* forced alignments: 1, forced holes: 1, sum forced holes: 5 */
        /* last cacheline: 56 bytes */
} __attribute__((__aligned__(8)));

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/ip_fib.h           |  5 +++
 include/uapi/linux/rtnetlink.h |  1 +
 net/ipv4/fib_lookup.h          |  4 ++
 net/ipv4/fib_semantics.c       |  4 ++
 net/ipv4/fib_trie.c            | 71 ++++++++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 52b2406a5dfc..019a138a79f4 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -454,6 +454,11 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *fc_encap,
 void fib_nh_common_release(struct fib_nh_common *nhc);
 
 /* Exported by fib_trie.c */
+void fib_alias_in_hw_set(struct net *net, u32 dst, int dst_len,
+			 const struct fib_info *fi, u8 tos, u8 type, u32 tb_id);
+void fib_alias_in_hw_clear(struct net *net, u32 dst, int dst_len,
+			   const struct fib_info *fi, u8 tos, u8 type,
+			   u32 tb_id);
 void fib_trie_init(void);
 struct fib_table *fib_trie_table(u32 id, struct fib_table *alias);
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 1418a8362bb7..e5a104f5ce35 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -309,6 +309,7 @@ enum rt_scope_t {
 #define RTM_F_PREFIX		0x800	/* Prefix addresses		*/
 #define RTM_F_LOOKUP_TABLE	0x1000	/* set rtm_table to FIB lookup result */
 #define RTM_F_FIB_MATCH	        0x2000	/* return full fib lookup match */
+#define RTM_F_IN_HW		0x4000	/* route is in hardware */
 
 /* Reserved table identifiers */
 
diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index b34594a9965f..65a69a863499 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -16,6 +16,8 @@ struct fib_alias {
 	u8			fa_slen;
 	u32			tb_id;
 	s16			fa_default;
+	u8			in_hw:1,
+				unused:7;
 	struct rcu_head		rcu;
 };
 
@@ -28,6 +30,8 @@ struct fib_rt_info {
 	int			dst_len;
 	u8			tos;
 	u8			type;
+	u8			in_hw:1,
+				unused:7;
 };
 
 /* Dont write on fa_state unless needed, to keep it shared on all cpus */
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3c9d47804d93..94f201d44844 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -519,6 +519,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.dst_len = dst_len;
 	fri.tos = fa->fa_tos;
 	fri.type = fa->fa_type;
+	fri.in_hw = fa->in_hw;
 	err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
@@ -1801,6 +1802,9 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 	}
 
+	if (fri->in_hw)
+		rtm->rtm_flags |= RTM_F_IN_HW;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 646542de83ca..e3486bde6c5a 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1028,6 +1028,74 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
 	return NULL;
 }
 
+static struct fib_alias *
+fib_find_matching_alias(struct net *net, u32 dst, int dst_len,
+			const struct fib_info *fi, u8 tos, u8 type, u32 tb_id)
+{
+	u8 slen = KEYLENGTH - dst_len;
+	struct key_vector *l, *tp;
+	struct fib_table *tb;
+	struct fib_alias *fa;
+	struct trie *t;
+
+	tb = fib_get_table(net, tb_id);
+	if (!tb)
+		return NULL;
+
+	t = (struct trie *)tb->tb_data;
+	l = fib_find_node(t, &tp, dst);
+	if (!l)
+		return NULL;
+
+	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
+		if (fa->fa_slen == slen && fa->tb_id == tb_id &&
+		    fa->fa_tos == tos && fa->fa_info == fi &&
+		    fa->fa_type == type)
+			return fa;
+	}
+
+	return NULL;
+}
+
+void fib_alias_in_hw_set(struct net *net, u32 dst, int dst_len,
+			 const struct fib_info *fi, u8 tos, u8 type, u32 tb_id)
+{
+	struct fib_alias *fa_match;
+
+	rcu_read_lock();
+
+	fa_match = fib_find_matching_alias(net, dst, dst_len, fi, tos, type,
+					   tb_id);
+	if (!fa_match)
+		goto out;
+
+	fa_match->in_hw = 1;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(fib_alias_in_hw_set);
+
+void fib_alias_in_hw_clear(struct net *net, u32 dst, int dst_len,
+			   const struct fib_info *fi, u8 tos, u8 type,
+			   u32 tb_id)
+{
+	struct fib_alias *fa_match;
+
+	rcu_read_lock();
+
+	fa_match = fib_find_matching_alias(net, dst, dst_len, fi, tos, type,
+					   tb_id);
+	if (!fa_match)
+		goto out;
+
+	fa_match->in_hw = 0;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(fib_alias_in_hw_clear);
+
 static void trie_rebalance(struct trie *t, struct key_vector *tn)
 {
 	while (!IS_TRIE(tn))
@@ -1236,6 +1304,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->fa_slen = fa->fa_slen;
 			new_fa->tb_id = tb->tb_id;
 			new_fa->fa_default = -1;
+			new_fa->in_hw = 0;
 
 			hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
 
@@ -1294,6 +1363,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	new_fa->fa_slen = slen;
 	new_fa->tb_id = tb->tb_id;
 	new_fa->fa_default = -1;
+	new_fa->in_hw = 0;
 
 	/* Insert new entry to the list. */
 	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
@@ -2218,6 +2288,7 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				fri.dst_len = KEYLENGTH - fa->fa_slen;
 				fri.tos = fa->fa_tos;
 				fri.type = fa->fa_type;
+				fri.in_hw = fa->in_hw;
 				err = fib_dump_info(skb,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
-- 
2.21.0

