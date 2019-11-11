Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC0F8373
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfKKXaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:30:14 -0500
Received: from correo.us.es ([193.147.175.20]:41004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfKKXaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 98AF51C439D
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7ADD0A7EE6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6CACDA7EC5; Tue, 12 Nov 2019 00:30:07 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 515E4DA840;
        Tue, 12 Nov 2019 00:30:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E48A142EF4E0;
        Tue, 12 Nov 2019 00:30:04 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 5/6] netfilter: nf_tables: add flowtable offload control plane
Date:   Tue, 12 Nov 2019 00:29:55 +0100
Message-Id: <20191111232956.24898-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the NFTA_FLOWTABLE_FLAGS attribute that allows users to
specify the NF_FLOWTABLE_HW_OFFLOAD flag. This patch also adds a new
setup interface for the flowtable type to perform the flowtable offload
block callback configuration.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h    | 18 ++++++++++++++++++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/ipv4/netfilter/nf_flow_table_ipv4.c  |  1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c  |  1 +
 net/netfilter/nf_flow_table_inet.c       |  1 +
 net/netfilter/nf_tables_api.c            | 21 +++++++++++++++++++--
 6 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f000e8917487..ece09d36c7a6 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -8,6 +8,7 @@
 #include <linux/rcupdate.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/flow_offload.h>
 #include <net/dst.h>
 
 struct nf_flowtable;
@@ -16,17 +17,27 @@ struct nf_flowtable_type {
 	struct list_head		list;
 	int				family;
 	int				(*init)(struct nf_flowtable *ft);
+	int				(*setup)(struct nf_flowtable *ft,
+						 struct net_device *dev,
+						 enum flow_block_command cmd);
 	void				(*free)(struct nf_flowtable *ft);
 	nf_hookfn			*hook;
 	struct module			*owner;
 };
 
+enum nf_flowtable_flags {
+	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,
+};
+
 struct nf_flowtable {
 	struct list_head		list;
 	struct rhashtable		rhashtable;
 	int				priority;
 	const struct nf_flowtable_type	*type;
 	struct delayed_work		gc_work;
+	unsigned int			flags;
+	struct flow_block		flow_block;
+	possible_net_t			net;
 };
 
 enum flow_offload_tuple_dir {
@@ -131,4 +142,11 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
+static inline int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
+					      struct net_device *dev,
+					      enum flow_block_command cmd)
+{
+	return 0;
+}
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 81fed16fe2b2..bb9b049310df 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1518,6 +1518,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
+ * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1527,6 +1528,7 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_USE,
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
+	NFTA_FLOWTABLE_FLAGS,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index 012c4047c788..f3befddb5fdd 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -9,6 +9,7 @@
 static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index f6d9a48c7a2a..1c47f05eabd6 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -10,6 +10,7 @@
 static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 593357aedb36..1e70fd504da3 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -24,6 +24,7 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
 	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0d2243945f1d..2dc636faa322 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5835,6 +5835,7 @@ static const struct nla_policy nft_flowtable_policy[NFTA_FLOWTABLE_MAX + 1] = {
 					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_FLOWTABLE_HOOK]		= { .type = NLA_NESTED },
 	[NFTA_FLOWTABLE_HANDLE]		= { .type = NLA_U64 },
+	[NFTA_FLOWTABLE_FLAGS]		= { .type = NLA_U32 },
 };
 
 struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
@@ -5968,8 +5969,11 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 {
 	struct nft_hook *hook;
 
-	list_for_each_entry(hook, &flowtable->hook_list, list)
+	list_for_each_entry(hook, &flowtable->hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_UNBIND);
+	}
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -5991,6 +5995,8 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_BIND);
 		err = nf_register_net_hook(net, &hook->ops);
 		if (err < 0)
 			goto err_unregister_net_hooks;
@@ -6006,6 +6012,8 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			break;
 
 		nf_unregister_net_hook(net, &hook->ops);
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 	}
@@ -6080,6 +6088,14 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		goto err2;
 	}
 
+	if (nla[NFTA_FLOWTABLE_FLAGS]) {
+		flowtable->data.flags =
+			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
+		if (flowtable->data.flags & ~NF_FLOWTABLE_HW_OFFLOAD)
+			goto err3;
+	}
+
+	write_pnet(&flowtable->data.net, net);
 	flowtable->data.type = type;
 	err = type->init(&flowtable->data);
 	if (err < 0)
@@ -6191,7 +6207,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be64(skb, NFTA_FLOWTABLE_HANDLE, cpu_to_be64(flowtable->handle),
-			 NFTA_FLOWTABLE_PAD))
+			 NFTA_FLOWTABLE_PAD) ||
+	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
 
 	nest = nla_nest_start_noflag(skb, NFTA_FLOWTABLE_HOOK);
-- 
2.11.0

