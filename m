Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83639F8377
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKKXaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:30:18 -0500
Received: from correo.us.es ([193.147.175.20]:41008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbfKKXaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 04A501C439B
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E916F2201F
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E8382FB362; Tue, 12 Nov 2019 00:30:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A67BB7FF2;
        Tue, 12 Nov 2019 00:30:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BB50A42EF4E0;
        Tue, 12 Nov 2019 00:30:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 6/6] netfilter: nf_flow_table: hardware offload support
Date:   Tue, 12 Nov 2019 00:29:56 +0100
Message-Id: <20191111232956.24898-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the dataplane hardware offload to the flowtable
infrastructure. Three new flags represent the hardware state of this
flow:

* FLOW_OFFLOAD_HW: This flow entry resides in the hardware.
* FLOW_OFFLOAD_HW_DYING: This flow entry has been scheduled to be remove
  from hardware. This might be triggered by either packet path (via TCP
  RST/FIN packet) or via aging.
* FLOW_OFFLOAD_HW_DEAD: This flow entry has been already removed from
  the hardware, the software garbage collector can remove it from the
  software flowtable.

This patch supports for:

* IPv4 only.
* Aging via FLOW_CLS_STATS, no packet and byte counter synchronization
  at this stage.

This patch also adds the action callback that specifies how to convert
the flow entry into the flow_rule object that is passed to the driver.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h               |   1 +
 include/net/netfilter/nf_flow_table.h   |  33 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c |   1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c |   1 +
 net/netfilter/Makefile                  |   3 +-
 net/netfilter/nf_flow_table_core.c      |  33 +-
 net/netfilter/nf_flow_table_inet.c      |   1 +
 net/netfilter/nf_flow_table_offload.c   | 758 ++++++++++++++++++++++++++++++++
 8 files changed, 822 insertions(+), 9 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_offload.c

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f857f01234f7..9e6fb8524d91 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -848,6 +848,7 @@ enum tc_setup_type {
 	TC_SETUP_ROOT_QDISC,
 	TC_SETUP_QDISC_GRED,
 	TC_SETUP_QDISC_TAPRIO,
+	TC_SETUP_FT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ece09d36c7a6..eea66de328d3 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -12,6 +12,9 @@
 #include <net/dst.h>
 
 struct nf_flowtable;
+struct nf_flow_rule;
+struct flow_offload;
+enum flow_offload_tuple_dir;
 
 struct nf_flowtable_type {
 	struct list_head		list;
@@ -20,6 +23,10 @@ struct nf_flowtable_type {
 	int				(*setup)(struct nf_flowtable *ft,
 						 struct net_device *dev,
 						 enum flow_block_command cmd);
+	int				(*action)(struct net *net,
+						  const struct flow_offload *flow,
+						  enum flow_offload_tuple_dir dir,
+						  struct nf_flow_rule *flow_rule);
 	void				(*free)(struct nf_flowtable *ft);
 	nf_hookfn			*hook;
 	struct module			*owner;
@@ -80,6 +87,9 @@ struct flow_offload_tuple_rhash {
 #define FLOW_OFFLOAD_DNAT	0x2
 #define FLOW_OFFLOAD_DYING	0x4
 #define FLOW_OFFLOAD_TEARDOWN	0x8
+#define FLOW_OFFLOAD_HW		0x10
+#define FLOW_OFFLOAD_HW_DYING	0x20
+#define FLOW_OFFLOAD_HW_DEAD	0x40
 
 enum flow_offload_type {
 	NF_FLOW_OFFLOAD_UNSPEC	= 0,
@@ -142,11 +152,22 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
-static inline int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
-					      struct net_device *dev,
-					      enum flow_block_command cmd)
-{
-	return 0;
-}
+void nf_flow_offload_add(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow);
+void nf_flow_offload_del(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow);
+void nf_flow_offload_stats(struct nf_flowtable *flowtable,
+			   struct flow_offload *flow);
+
+void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
+int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
+				struct net_device *dev,
+				enum flow_block_command cmd);
+int nf_flow_rule_route(struct net *net, const struct flow_offload *flow,
+		       enum flow_offload_tuple_dir dir,
+		       struct nf_flow_rule *flow_rule);
+
+int nf_flow_table_offload_init(void);
+void nf_flow_table_offload_exit(void);
 
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index f3befddb5fdd..168b72e18be0 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -10,6 +10,7 @@ static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
+	.action		= nf_flow_rule_route,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index 1c47f05eabd6..f069bc0dc056 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -11,6 +11,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
+	.action		= nf_flow_rule_route,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4fc075b612fe..5e9b2eb24349 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -120,7 +120,8 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
-nf_flow_table-objs := nf_flow_table_core.o nf_flow_table_ip.o
+nf_flow_table-objs		:= nf_flow_table_core.o nf_flow_table_ip.o \
+				   nf_flow_table_offload.o
 
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 139a5e074743..8468d2d02284 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -250,6 +250,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
+	if (flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD)
+		nf_flow_offload_add(flow_table, flow);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
@@ -350,9 +353,20 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
 
+	if (flow->flags & FLOW_OFFLOAD_HW)
+		nf_flow_offload_stats(flow_table, flow);
+
 	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
-	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
-		flow_offload_del(flow_table, flow);
+	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))) {
+		if (flow->flags & FLOW_OFFLOAD_HW) {
+			if (!(flow->flags & FLOW_OFFLOAD_HW_DYING))
+				nf_flow_offload_del(flow_table, flow);
+			else if (flow->flags & FLOW_OFFLOAD_HW_DEAD)
+				flow_offload_del(flow_table, flow);
+		} else {
+			flow_offload_del(flow_table, flow);
+		}
+	}
 }
 
 static void nf_flow_offload_work_gc(struct work_struct *work)
@@ -485,6 +499,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 	int err;
 
 	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
+	flow_block_init(&flowtable->flow_block);
 
 	err = rhashtable_init(&flowtable->rhashtable,
 			      &nf_flow_offload_rhash_params);
@@ -520,6 +535,7 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
 					  struct net_device *dev)
 {
+	nf_flow_table_offload_flush(flowtable);
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
 }
@@ -547,5 +563,18 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
+static int __init nf_flow_table_module_init(void)
+{
+	return nf_flow_table_offload_init();
+}
+
+static void __exit nf_flow_table_module_exit(void)
+{
+	nf_flow_table_offload_exit();
+}
+
+module_init(nf_flow_table_module_init);
+module_exit(nf_flow_table_module_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 1e70fd504da3..bfb910b874ce 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -25,6 +25,7 @@ static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
+	.action		= nf_flow_rule_route,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
new file mode 100644
index 000000000000..9be61f47303a
--- /dev/null
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -0,0 +1,758 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/rhashtable.h>
+#include <linux/netdevice.h>
+#include <linux/tc_act/tc_csum.h>
+#include <net/flow_offload.h>
+#include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+static struct work_struct nf_flow_offload_work;
+static DEFINE_SPINLOCK(flow_offload_pending_list_lock);
+static LIST_HEAD(flow_offload_pending_list);
+
+struct flow_offload_work {
+	struct list_head	list;
+	enum flow_cls_command	cmd;
+	int			priority;
+	struct nf_flowtable	*flowtable;
+	struct flow_offload	*flow;
+};
+
+struct nf_flow_key {
+	struct flow_dissector_key_control		control;
+	struct flow_dissector_key_basic			basic;
+	union {
+		struct flow_dissector_key_ipv4_addrs	ipv4;
+	};
+	struct flow_dissector_key_tcp			tcp;
+	struct flow_dissector_key_ports			tp;
+} __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
+
+struct nf_flow_match {
+	struct flow_dissector	dissector;
+	struct nf_flow_key	key;
+	struct nf_flow_key	mask;
+};
+
+struct nf_flow_rule {
+	struct nf_flow_match	match;
+	struct flow_rule	*rule;
+};
+
+#define NF_FLOW_DISSECTOR(__match, __type, __field)	\
+	(__match)->dissector.offset[__type] =		\
+		offsetof(struct nf_flow_key, __field)
+
+static int nf_flow_rule_match(struct nf_flow_match *match,
+			      const struct flow_offload_tuple *tuple)
+{
+	struct nf_flow_key *mask = &match->mask;
+	struct nf_flow_key *key = &match->key;
+
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
+
+	switch (tuple->l3proto) {
+	case AF_INET:
+		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		key->basic.n_proto = htons(ETH_P_IP);
+		key->ipv4.src = tuple->src_v4.s_addr;
+		mask->ipv4.src = 0xffffffff;
+		key->ipv4.dst = tuple->dst_v4.s_addr;
+		mask->ipv4.dst = 0xffffffff;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	mask->basic.n_proto = 0xffff;
+
+	switch (tuple->l4proto) {
+	case IPPROTO_TCP:
+		key->tcp.flags = 0;
+		mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
+		break;
+	case IPPROTO_UDP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	key->basic.ip_proto = tuple->l4proto;
+	mask->basic.ip_proto = 0xff;
+
+	key->tp.src = tuple->src_port;
+	mask->tp.src = 0xffff;
+	key->tp.dst = tuple->dst_port;
+	mask->tp.dst = 0xffff;
+
+	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+				      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+				      BIT(FLOW_DISSECTOR_KEY_PORTS);
+	return 0;
+}
+
+static void flow_offload_mangle(struct flow_action_entry *entry,
+				enum flow_action_mangle_base htype,
+				u32 offset, u8 *value, u8 *mask)
+{
+	entry->id = FLOW_ACTION_MANGLE;
+	entry->mangle.htype = htype;
+	entry->mangle.offset = offset;
+	memcpy(&entry->mangle.mask, mask, sizeof(u32));
+	memcpy(&entry->mangle.val, value, sizeof(u32));
+}
+
+static int flow_offload_eth_src(struct net *net,
+				const struct flow_offload *flow,
+				enum flow_offload_tuple_dir dir,
+				struct flow_action_entry *entry0,
+				struct flow_action_entry *entry1)
+{
+	const struct flow_offload_tuple *tuple = &flow->tuplehash[!dir].tuple;
+	struct net_device *dev;
+	u32 mask, val;
+	u16 val16;
+
+	dev = dev_get_by_index(net, tuple->iifidx);
+	if (!dev)
+		return -ENOENT;
+
+	mask = ~0xffff0000;
+	memcpy(&val16, dev->dev_addr, 2);
+	val = val16 << 16;
+	flow_offload_mangle(entry0, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 4,
+			    (u8 *)&val, (u8 *)&mask);
+
+	mask = ~0xffffffff;
+	memcpy(&val, dev->dev_addr + 2, 4);
+	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 8,
+			    (u8 *)&val, (u8 *)&mask);
+	dev_put(dev);
+
+	return 0;
+}
+
+static int flow_offload_eth_dst(struct net *net,
+				const struct flow_offload *flow,
+				enum flow_offload_tuple_dir dir,
+				struct flow_action_entry *entry0,
+				struct flow_action_entry *entry1)
+{
+	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+	struct neighbour *n;
+	u32 mask, val;
+	u16 val16;
+
+	n = dst_neigh_lookup(tuple->dst_cache, &tuple->dst_v4);
+	if (!n)
+		return -ENOENT;
+
+	mask = ~0xffffffff;
+	memcpy(&val, n->ha, 4);
+	flow_offload_mangle(entry0, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 0,
+			    (u8 *)&val, (u8 *)&mask);
+
+	mask = ~0x0000ffff;
+	memcpy(&val16, n->ha + 4, 2);
+	val = val16;
+	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 4,
+			    (u8 *)&val, (u8 *)&mask);
+	neigh_release(n);
+
+	return 0;
+}
+
+static void flow_offload_ipv4_snat(struct net *net,
+				   const struct flow_offload *flow,
+				   enum flow_offload_tuple_dir dir,
+				   struct flow_action_entry *entry)
+{
+	u32 mask = ~htonl(0xffffffff);
+	__be32 addr;
+	u32 offset;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v4.s_addr;
+		offset = offsetof(struct iphdr, saddr);
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v4.s_addr;
+		offset = offsetof(struct iphdr, daddr);
+		break;
+	default:
+		return;
+	}
+
+	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
+			    (u8 *)&addr, (u8 *)&mask);
+}
+
+static void flow_offload_ipv4_dnat(struct net *net,
+				   const struct flow_offload *flow,
+				   enum flow_offload_tuple_dir dir,
+				   struct flow_action_entry *entry)
+{
+	u32 mask = ~htonl(0xffffffff);
+	__be32 addr;
+	u32 offset;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v4.s_addr;
+		offset = offsetof(struct iphdr, daddr);
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v4.s_addr;
+		offset = offsetof(struct iphdr, saddr);
+		break;
+	default:
+		return;
+	}
+
+	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
+			    (u8 *)&addr, (u8 *)&mask);
+}
+
+static int flow_offload_l4proto(const struct flow_offload *flow)
+{
+	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
+	u8 type = 0;
+
+	switch (protonum) {
+	case IPPROTO_TCP:
+		type = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
+		break;
+	case IPPROTO_UDP:
+		type = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
+		break;
+	default:
+		break;
+	}
+
+	return type;
+}
+
+static void flow_offload_port_snat(struct net *net,
+				   const struct flow_offload *flow,
+				   enum flow_offload_tuple_dir dir,
+				   struct flow_action_entry *entry)
+{
+	u32 mask = ~htonl(0xffff0000);
+	__be16 port;
+	u32 offset;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		port = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port;
+		offset = 0; /* offsetof(struct tcphdr, source); */
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
+		offset = 0; /* offsetof(struct tcphdr, dest); */
+		break;
+	default:
+		break;
+	}
+
+	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
+			    (u8 *)&port, (u8 *)&mask);
+}
+
+static void flow_offload_port_dnat(struct net *net,
+				   const struct flow_offload *flow,
+				   enum flow_offload_tuple_dir dir,
+				   struct flow_action_entry *entry)
+{
+	u32 mask = ~htonl(0xffff);
+	__be16 port;
+	u32 offset;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		port = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port;
+		offset = 0; /* offsetof(struct tcphdr, source); */
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
+		offset = 0; /* offsetof(struct tcphdr, dest); */
+		break;
+	default:
+		break;
+	}
+
+	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
+			    (u8 *)&port, (u8 *)&mask);
+}
+
+static void flow_offload_ipv4_checksum(struct net *net,
+				       const struct flow_offload *flow,
+				       struct flow_action_entry *entry)
+{
+	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
+
+	entry->id = FLOW_ACTION_CSUM;
+	entry->csum_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR;
+
+	switch (protonum) {
+	case IPPROTO_TCP:
+		entry->csum_flags |= TCA_CSUM_UPDATE_FLAG_TCP;
+		break;
+	case IPPROTO_UDP:
+		entry->csum_flags |= TCA_CSUM_UPDATE_FLAG_UDP;
+		break;
+	}
+}
+
+static void flow_offload_redirect(const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct flow_action_entry *entry)
+{
+	struct rtable *rt;
+
+	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
+	entry->id = FLOW_ACTION_REDIRECT;
+	entry->dev = rt->dst.dev;
+	dev_hold(rt->dst.dev);
+}
+
+int nf_flow_rule_route(struct net *net, const struct flow_offload *flow,
+		       enum flow_offload_tuple_dir dir,
+		       struct nf_flow_rule *flow_rule)
+{
+	int i;
+
+	if (flow_offload_eth_src(net, flow, dir,
+				 &flow_rule->rule->action.entries[0],
+				 &flow_rule->rule->action.entries[1]) < 0)
+		return -1;
+
+	if (flow_offload_eth_dst(net, flow, dir,
+				 &flow_rule->rule->action.entries[2],
+				 &flow_rule->rule->action.entries[3]) < 0)
+		return -1;
+
+	i = 4;
+	if (flow->flags & FLOW_OFFLOAD_SNAT) {
+		flow_offload_ipv4_snat(net, flow, dir,
+				       &flow_rule->rule->action.entries[i++]);
+		flow_offload_port_snat(net, flow, dir,
+				       &flow_rule->rule->action.entries[i++]);
+	}
+	if (flow->flags & FLOW_OFFLOAD_DNAT) {
+		flow_offload_ipv4_dnat(net, flow, dir,
+				       &flow_rule->rule->action.entries[i++]);
+		flow_offload_port_dnat(net, flow, dir,
+				       &flow_rule->rule->action.entries[i++]);
+	}
+	if (flow->flags & FLOW_OFFLOAD_SNAT ||
+	    flow->flags & FLOW_OFFLOAD_DNAT)
+		flow_offload_ipv4_checksum(net, flow,
+					   &flow_rule->rule->action.entries[i++]);
+
+	flow_offload_redirect(flow, dir, &flow_rule->rule->action.entries[i++]);
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(nf_flow_rule_route);
+
+static struct nf_flow_rule *
+nf_flow_offload_rule_alloc(struct net *net,
+			   const struct flow_offload_work *offload,
+			   enum flow_offload_tuple_dir dir)
+{
+	const struct nf_flowtable *flowtable = offload->flowtable;
+	const struct flow_offload *flow = offload->flow;
+	const struct flow_offload_tuple *tuple;
+	struct nf_flow_rule *flow_rule;
+	int err = -ENOMEM, num_actions;
+
+	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
+	if (!flow_rule)
+		goto err_flow;
+
+	flow_rule->rule = flow_rule_alloc(10);
+	if (!flow_rule->rule)
+		goto err_flow_rule;
+
+	flow_rule->rule->match.dissector = &flow_rule->match.dissector;
+	flow_rule->rule->match.mask = &flow_rule->match.mask;
+	flow_rule->rule->match.key = &flow_rule->match.key;
+
+	tuple = &flow->tuplehash[dir].tuple;
+	err = nf_flow_rule_match(&flow_rule->match, tuple);
+	if (err < 0)
+		goto err_flow_match;
+
+	num_actions = flowtable->type->action(net, flow, dir, flow_rule);
+	if (num_actions < 0)
+		goto err_flow_match;
+
+	flow_rule->rule->action.num_entries = num_actions;
+
+	return flow_rule;
+
+err_flow_match:
+	kfree(flow_rule->rule);
+err_flow_rule:
+	kfree(flow_rule);
+err_flow:
+	return NULL;
+}
+
+static void __nf_flow_offload_destroy(struct nf_flow_rule *flow_rule)
+{
+	struct flow_action_entry *entry;
+	int i;
+
+	for (i = 0; i < flow_rule->rule->action.num_entries; i++) {
+		entry = &flow_rule->rule->action.entries[i];
+		if (entry->id != FLOW_ACTION_REDIRECT)
+			continue;
+
+		dev_put(entry->dev);
+	}
+	kfree(flow_rule->rule);
+	kfree(flow_rule);
+}
+
+static void nf_flow_offload_destroy(struct nf_flow_rule *flow_rule[])
+{
+	int i;
+
+	for (i = 0; i < FLOW_OFFLOAD_DIR_MAX; i++)
+		__nf_flow_offload_destroy(flow_rule[i]);
+}
+
+static int nf_flow_offload_alloc(const struct flow_offload_work *offload,
+				 struct nf_flow_rule *flow_rule[])
+{
+	struct net *net = read_pnet(&offload->flowtable->net);
+
+	flow_rule[0] = nf_flow_offload_rule_alloc(net, offload,
+						  FLOW_OFFLOAD_DIR_ORIGINAL);
+	if (!flow_rule[0])
+		return -ENOMEM;
+
+	flow_rule[1] = nf_flow_offload_rule_alloc(net, offload,
+						  FLOW_OFFLOAD_DIR_REPLY);
+	if (!flow_rule[1]) {
+		__nf_flow_offload_destroy(flow_rule[0]);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void nf_flow_offload_init(struct flow_cls_offload *cls_flow,
+				 __be16 proto, int priority,
+				 enum flow_cls_command cmd,
+				 const struct flow_offload_tuple *tuple,
+				 struct netlink_ext_ack *extack)
+{
+	cls_flow->common.protocol = proto;
+	cls_flow->common.prio = priority;
+	cls_flow->common.extack = extack;
+	cls_flow->command = cmd;
+	cls_flow->cookie = (unsigned long)tuple;
+}
+
+static int flow_offload_tuple_add(struct flow_offload_work *offload,
+				  struct nf_flow_rule *flow_rule,
+				  enum flow_offload_tuple_dir dir)
+{
+	struct nf_flowtable *flowtable = offload->flowtable;
+	struct flow_cls_offload cls_flow = {};
+	struct flow_block_cb *block_cb;
+	struct netlink_ext_ack extack;
+	__be16 proto = ETH_P_ALL;
+	int err, i = 0;
+
+	nf_flow_offload_init(&cls_flow, proto, offload->priority,
+			     FLOW_CLS_REPLACE,
+			     &offload->flow->tuplehash[dir].tuple, &extack);
+	cls_flow.rule = flow_rule->rule;
+
+	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list) {
+		err = block_cb->cb(TC_SETUP_FT, &cls_flow,
+				   block_cb->cb_priv);
+		if (err < 0)
+			continue;
+
+		i++;
+	}
+
+	return i;
+}
+
+static void flow_offload_tuple_del(struct flow_offload_work *offload,
+				   enum flow_offload_tuple_dir dir)
+{
+	struct nf_flowtable *flowtable = offload->flowtable;
+	struct flow_cls_offload cls_flow = {};
+	struct flow_block_cb *block_cb;
+	struct netlink_ext_ack extack;
+	__be16 proto = ETH_P_ALL;
+
+	nf_flow_offload_init(&cls_flow, proto, offload->priority,
+			     FLOW_CLS_DESTROY,
+			     &offload->flow->tuplehash[dir].tuple, &extack);
+
+	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
+		block_cb->cb(TC_SETUP_FT, &cls_flow, block_cb->cb_priv);
+
+	offload->flow->flags |= FLOW_OFFLOAD_HW_DEAD;
+}
+
+static int flow_offload_rule_add(struct flow_offload_work *offload,
+				 struct nf_flow_rule *flow_rule[])
+{
+	int ok_count = 0;
+
+	ok_count += flow_offload_tuple_add(offload, flow_rule[0],
+					   FLOW_OFFLOAD_DIR_ORIGINAL);
+	ok_count += flow_offload_tuple_add(offload, flow_rule[1],
+					   FLOW_OFFLOAD_DIR_REPLY);
+	if (ok_count == 0)
+		return -ENOENT;
+
+	return 0;
+}
+
+static int flow_offload_work_add(struct flow_offload_work *offload)
+{
+	struct nf_flow_rule *flow_rule[FLOW_OFFLOAD_DIR_MAX];
+	int err;
+
+	err = nf_flow_offload_alloc(offload, flow_rule);
+	if (err < 0)
+		return -ENOMEM;
+
+	err = flow_offload_rule_add(offload, flow_rule);
+
+	nf_flow_offload_destroy(flow_rule);
+
+	return err;
+}
+
+static void flow_offload_work_del(struct flow_offload_work *offload)
+{
+	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+}
+
+static void flow_offload_tuple_stats(struct flow_offload_work *offload,
+				     enum flow_offload_tuple_dir dir,
+				     struct flow_stats *stats)
+{
+	struct nf_flowtable *flowtable = offload->flowtable;
+	struct flow_cls_offload cls_flow = {};
+	struct flow_block_cb *block_cb;
+	struct netlink_ext_ack extack;
+	__be16 proto = ETH_P_ALL;
+
+	nf_flow_offload_init(&cls_flow, proto, offload->priority,
+			     FLOW_CLS_STATS,
+			     &offload->flow->tuplehash[dir].tuple, &extack);
+
+	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
+		block_cb->cb(TC_SETUP_FT, &cls_flow, block_cb->cb_priv);
+	memcpy(stats, &cls_flow.stats, sizeof(*stats));
+}
+
+static void flow_offload_work_stats(struct flow_offload_work *offload)
+{
+	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
+	u64 lastused;
+
+	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
+	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
+
+	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
+	offload->flow->timeout = max_t(u64, offload->flow->timeout,
+				       lastused + NF_FLOW_TIMEOUT);
+}
+
+static void flow_offload_work_handler(struct work_struct *work)
+{
+	struct flow_offload_work *offload, *next;
+	LIST_HEAD(offload_pending_list);
+	int ret;
+
+	spin_lock_bh(&flow_offload_pending_list_lock);
+	list_replace_init(&flow_offload_pending_list, &offload_pending_list);
+	spin_unlock_bh(&flow_offload_pending_list_lock);
+
+	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
+		switch (offload->cmd) {
+		case FLOW_CLS_REPLACE:
+			ret = flow_offload_work_add(offload);
+			if (ret < 0)
+				offload->flow->flags &= ~FLOW_OFFLOAD_HW;
+			break;
+		case FLOW_CLS_DESTROY:
+			flow_offload_work_del(offload);
+			break;
+		case FLOW_CLS_STATS:
+			flow_offload_work_stats(offload);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+		}
+		list_del(&offload->list);
+		kfree(offload);
+	}
+}
+
+static void flow_offload_queue_work(struct flow_offload_work *offload)
+{
+	spin_lock_bh(&flow_offload_pending_list_lock);
+	list_add_tail(&offload->list, &flow_offload_pending_list);
+	spin_unlock_bh(&flow_offload_pending_list_lock);
+
+	schedule_work(&nf_flow_offload_work);
+}
+
+void nf_flow_offload_add(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow)
+{
+	struct flow_offload_work *offload;
+
+	offload = kmalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
+	if (!offload)
+		return;
+
+	offload->cmd = FLOW_CLS_REPLACE;
+	offload->flow = flow;
+	offload->priority = flowtable->priority;
+	offload->flowtable = flowtable;
+	flow->flags |= FLOW_OFFLOAD_HW;
+
+	flow_offload_queue_work(offload);
+}
+
+void nf_flow_offload_del(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow)
+{
+	struct flow_offload_work *offload;
+
+	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
+	if (!offload)
+		return;
+
+	offload->cmd = FLOW_CLS_DESTROY;
+	offload->flow = flow;
+	offload->flow->flags |= FLOW_OFFLOAD_HW_DYING;
+	offload->flowtable = flowtable;
+
+	flow_offload_queue_work(offload);
+}
+
+void nf_flow_offload_stats(struct nf_flowtable *flowtable,
+			   struct flow_offload *flow)
+{
+	struct flow_offload_work *offload;
+	s64 delta;
+
+	delta = flow->timeout - jiffies;
+	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10) ||
+	    flow->flags & FLOW_OFFLOAD_HW_DYING)
+		return;
+
+	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
+	if (!offload)
+		return;
+
+	offload->cmd = FLOW_CLS_STATS;
+	offload->flow = flow;
+	offload->flowtable = flowtable;
+
+	flow_offload_queue_work(offload);
+}
+
+void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
+{
+	if (flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD)
+		flush_work(&nf_flow_offload_work);
+}
+
+static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
+				     struct flow_block_offload *bo,
+				     enum flow_block_command cmd)
+{
+	struct flow_block_cb *block_cb, *next;
+	int err = 0;
+
+	switch (cmd) {
+	case FLOW_BLOCK_BIND:
+		list_splice(&bo->cb_list, &flowtable->flow_block.cb_list);
+		break;
+	case FLOW_BLOCK_UNBIND:
+		list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
+			list_del(&block_cb->list);
+			flow_block_cb_free(block_cb);
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
+				struct net_device *dev,
+				enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo = {};
+	int err;
+
+	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
+		return 0;
+
+	bo.net		= dev_net(dev);
+	bo.block	= &flowtable->flow_block;
+	bo.command	= cmd;
+	bo.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo.extack	= &extack;
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (err < 0)
+		return err;
+
+	return nf_flow_table_block_setup(flowtable, &bo, cmd);
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
+
+int nf_flow_table_offload_init(void)
+{
+	INIT_WORK(&nf_flow_offload_work, flow_offload_work_handler);
+
+	return 0;
+}
+
+void nf_flow_table_offload_exit(void)
+{
+	struct flow_offload_work *offload, *next;
+	LIST_HEAD(offload_pending_list);
+
+	cancel_work_sync(&nf_flow_offload_work);
+
+	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
+		list_del(&offload->list);
+		kfree(offload);
+	}
+}
-- 
2.11.0

