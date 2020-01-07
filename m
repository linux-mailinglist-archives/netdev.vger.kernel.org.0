Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21556132A51
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgAGPpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:45:54 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46233 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727974AbgAGPpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:45:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4F98422233;
        Tue,  7 Jan 2020 10:45:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:45:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=mTd0a0VCFvgQc7ifKuUH8RrTqz9rex938hvg+ADmsw0=; b=Uw46HAV5
        Pzx6YwuknTOQbnNarM0+itZzg9CpKyDfaGDoGpSixgrqzUlhBdkqbI4CiuKgCj0z
        HWvv5/AAzbuaG+SdfOFYQRgWX+wELmCJMBcWa0iPGbD4egMHaXpp0FY8V4DKaOxG
        4+d0znQAKf9SJg/m6afRfiwLDoFDSApySRsb5B8tgXlvvglbnWe0CeW9rRFSnB2N
        CBrDhNpm/nomA4mb+7otOEQEbZtEq09DcoToD+2UIRWHiw3V3gTnWbon3mKbHcvZ
        mu9tYLsisidVftuenEovmb5VgmGSa+uKC1sfFE2Bz4Zd6BAi83Ln+3s3A9QyxNaq
        lCUZwtsCE0sg7g==
X-ME-Sender: <xms:sKcUXp1u_RWMJh2se2BD2ItPi5vnz3ooO83SAFNvL4alzwdcnbORKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:sKcUXllGpHc53dHs7Kq8Wb1oI0WMqsGfCc__Ms4G4qGzCxiYf6i92w>
    <xmx:sKcUXiOBTPIVAbdW64zqSH-pyosu823s8SyZPkow9Ji0SJrP6tN3xA>
    <xmx:sKcUXk4tk-hgPoFKxVU-8Ll7AZcC_000RDp3-LY8SlcpPea14veMaA>
    <xmx:sKcUXm2Wi0VHr13Oky5ezr135kbEUgGwNo6F_-ssrx56fNTt6jH5gA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A659980062;
        Tue,  7 Jan 2020 10:45:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/10] ipv4: Add "offload" and "trap" indications to routes
Date:   Tue,  7 Jan 2020 17:45:10 +0200
Message-Id: <20200107154517.239665-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107154517.239665-1-idosch@idosch.org>
References: <20200107154517.239665-1-idosch@idosch.org>
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

This patch adds an "offload" and "trap" indications to IPv4 routes, so
that users will have better visibility into the offload process.

'struct fib_alias' is extended with two new fields that indicate if the
route resides in hardware or not and if it is offloading traffic from
the kernel or trapping packets to it. Note that the new fields are added
in the 6 bytes hole and therefore the struct still fits in a single
cache line [1].

Capable drivers are expected to invoke fib_alias_hw_flags_set() with the
route's key in order to set the flags.

The indications are dumped to user space via a new flags (i.e.,
'RTM_F_OFFLOAD' and 'RTM_F_TRAP') in the 'rtm_flags' field in the
ancillary header.

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
        u8                         offload:1;            /*    34: 0  1 */
        u8                         trap:1;               /*    34: 1  1 */
        u8                         unused:6;             /*    34: 2  1 */

        /* XXX 5 bytes hole, try to pack */

        struct callback_head rcu __attribute__((__aligned__(8))); /*    40    16 */

        /* size: 56, cachelines: 1, members: 12 */
        /* sum members: 50, holes: 1, sum holes: 5 */
        /* sum bitfield members: 8 bits (1 bytes) */
        /* forced alignments: 1, forced holes: 1, sum forced holes: 5 */
        /* last cacheline: 56 bytes */
} __attribute__((__aligned__(8)));

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/ip_fib.h           |  4 +++
 include/uapi/linux/rtnetlink.h |  2 ++
 net/ipv4/fib_lookup.h          |  6 ++++
 net/ipv4/fib_semantics.c       |  7 +++++
 net/ipv4/fib_trie.c            | 56 ++++++++++++++++++++++++++++++++++
 net/ipv4/route.c               | 19 ++++++++++++
 6 files changed, 94 insertions(+)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index b9cba41c6d4f..5fc57c015e28 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -21,6 +21,7 @@
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/refcount.h>
+#include <linux/bits.h>
 
 struct fib_config {
 	u8			fc_dst_len;
@@ -464,6 +465,9 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *fc_encap,
 void fib_nh_common_release(struct fib_nh_common *nhc);
 
 /* Exported by fib_trie.c */
+void fib_alias_hw_flags_set(struct net *net, u32 dst, int dst_len,
+			    const struct fib_info *fi, u8 tos, u8 type,
+			    u32 tb_id, bool offload, bool trap);
 void fib_trie_init(void);
 struct fib_table *fib_trie_table(u32 id, struct fib_table *alias);
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 1418a8362bb7..cd43321d20dd 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -309,6 +309,8 @@ enum rt_scope_t {
 #define RTM_F_PREFIX		0x800	/* Prefix addresses		*/
 #define RTM_F_LOOKUP_TABLE	0x1000	/* set rtm_table to FIB lookup result */
 #define RTM_F_FIB_MATCH	        0x2000	/* return full fib lookup match */
+#define RTM_F_OFFLOAD		0x4000	/* route is offloaded */
+#define RTM_F_TRAP		0x8000	/* route is trapping packets */
 
 /* Reserved table identifiers */
 
diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index b34594a9965f..b7839127a43a 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -16,6 +16,9 @@ struct fib_alias {
 	u8			fa_slen;
 	u32			tb_id;
 	s16			fa_default;
+	u8			offload:1,
+				trap:1,
+				unused:6;
 	struct rcu_head		rcu;
 };
 
@@ -28,6 +31,9 @@ struct fib_rt_info {
 	int			dst_len;
 	u8			tos;
 	u8			type;
+	u8			offload:1,
+				trap:1,
+				unused:6;
 };
 
 /* Dont write on fa_state unless needed, to keep it shared on all cpus */
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3ed1349be428..a803cdd9400a 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -519,6 +519,8 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.dst_len = dst_len;
 	fri.tos = fa->fa_tos;
 	fri.type = fa->fa_type;
+	fri.offload = fa->offload;
+	fri.trap = fa->trap;
 	err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
@@ -1801,6 +1803,11 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 	}
 
+	if (fri->offload)
+		rtm->rtm_flags |= RTM_F_OFFLOAD;
+	if (fri->trap)
+		rtm->rtm_flags |= RTM_F_TRAP;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 75af3f8ae50e..272c9f73e4b3 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1012,6 +1012,56 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
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
+void fib_alias_hw_flags_set(struct net *net, u32 dst, int dst_len,
+			    const struct fib_info *fi, u8 tos, u8 type,
+			    u32 tb_id, bool offload, bool trap)
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
+	fa_match->offload = offload;
+	fa_match->trap = trap;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(fib_alias_hw_flags_set);
+
 static void trie_rebalance(struct trie *t, struct key_vector *tn)
 {
 	while (!IS_TRIE(tn))
@@ -1220,6 +1270,8 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->fa_slen = fa->fa_slen;
 			new_fa->tb_id = tb->tb_id;
 			new_fa->fa_default = -1;
+			new_fa->offload = 0;
+			new_fa->trap = 0;
 
 			hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
 
@@ -1278,6 +1330,8 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	new_fa->fa_slen = slen;
 	new_fa->tb_id = tb->tb_id;
 	new_fa->fa_default = -1;
+	new_fa->offload = 0;
+	new_fa->trap = 0;
 
 	/* Insert new entry to the list. */
 	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
@@ -2202,6 +2256,8 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				fri.dst_len = KEYLENGTH - fa->fa_slen;
 				fri.tos = fa->fa_tos;
 				fri.type = fa->fa_type;
+				fri.offload = fa->offload;
+				fri.trap = fa->trap;
 				err = fib_dump_info(skb,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 167a7357d12a..2010888e68ca 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3237,6 +3237,25 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		fri.dst_len = res.prefixlen;
 		fri.tos = fl4.flowi4_tos;
 		fri.type = rt->rt_type;
+		fri.offload = 0;
+		fri.trap = 0;
+		if (res.fa_head) {
+			struct fib_alias *fa;
+
+			hlist_for_each_entry_rcu(fa, res.fa_head, fa_list) {
+				u8 slen = 32 - fri.dst_len;
+
+				if (fa->fa_slen == slen &&
+				    fa->tb_id == fri.tb_id &&
+				    fa->fa_tos == fri.tos &&
+				    fa->fa_info == res.fi &&
+				    fa->fa_type == fri.type) {
+					fri.offload = fa->offload;
+					fri.trap = fa->trap;
+					break;
+				}
+			}
+		}
 		err = fib_dump_info(skb, NETLINK_CB(in_skb).portid,
 				    nlh->nlmsg_seq, RTM_NEWROUTE, &fri, 0);
 	} else {
-- 
2.24.1

