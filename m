Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75C9E5A1C
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfJZLsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:02 -0400
Received: from correo.us.es ([193.147.175.20]:46410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfJZLsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:48:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C9578C3C68
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C008A7EFE
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5FDF5A7EE6; Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0911FB8017;
        Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C7BB442EE393;
        Sat, 26 Oct 2019 13:47:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 27/31] netfilter: nf_tables: support for multiple devices per netdev hook
Date:   Sat, 26 Oct 2019 13:47:29 +0200
Message-Id: <20191026114733.28111-28-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows you to register one netdev basechain to multiple
devices. This adds a new NFTA_HOOK_DEVS netlink attribute to specify
the list of netdevices. Basechains store a list of hooks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   4 +-
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c            | 296 ++++++++++++++++++++++++-------
 net/netfilter/nf_tables_offload.c        |  44 +++--
 net/netfilter/nft_chain_filter.c         |  45 +++--
 5 files changed, 293 insertions(+), 98 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3d71070e747a..5bf569e1173b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -973,21 +973,21 @@ struct nft_hook {
  *	struct nft_base_chain - nf_tables base chain
  *
  *	@ops: netfilter hook ops
+ *	@hook_list: list of netfilter hooks (for NFPROTO_NETDEV family)
  *	@type: chain type
  *	@policy: default policy
  *	@stats: per-cpu chain stats
  *	@chain: the chain
- *	@dev_name: device name that this base chain is attached to (if any)
  *	@flow_block: flow block (for hardware offload)
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops;
+	struct list_head		hook_list;
 	const struct nft_chain_type	*type;
 	u8				policy;
 	u8				flags;
 	struct nft_stats __percpu	*stats;
 	struct nft_chain		chain;
-	char 				dev_name[IFNAMSIZ];
 	struct flow_block		flow_block;
 };
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ed8881ad18ed..81fed16fe2b2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -144,12 +144,14 @@ enum nft_list_attributes {
  * @NFTA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
  * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
+ * @NFTA_HOOK_DEVS: list of netdevices (NLA_NESTED)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
 	NFTA_HOOK_HOOKNUM,
 	NFTA_HOOK_PRIORITY,
 	NFTA_HOOK_DEV,
+	NFTA_HOOK_DEVS,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 98169af56c0f..13f09412cc6a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -151,11 +151,64 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 	}
 }
 
+static int nft_netdev_register_hooks(struct net *net,
+				     struct list_head *hook_list)
+{
+	struct nft_hook *hook;
+	int err, j;
+
+	j = 0;
+	list_for_each_entry(hook, hook_list, list) {
+		err = nf_register_net_hook(net, &hook->ops);
+		if (err < 0)
+			goto err_register;
+
+		j++;
+	}
+	return 0;
+
+err_register:
+	list_for_each_entry(hook, hook_list, list) {
+		if (j-- <= 0)
+			break;
+
+		nf_unregister_net_hook(net, &hook->ops);
+	}
+	return err;
+}
+
+static void nft_netdev_unregister_hooks(struct net *net,
+					struct list_head *hook_list)
+{
+	struct nft_hook *hook;
+
+	list_for_each_entry(hook, hook_list, list)
+		nf_unregister_net_hook(net, &hook->ops);
+}
+
+static int nft_register_basechain_hooks(struct net *net, int family,
+					struct nft_base_chain *basechain)
+{
+	if (family == NFPROTO_NETDEV)
+		return nft_netdev_register_hooks(net, &basechain->hook_list);
+
+	return nf_register_net_hook(net, &basechain->ops);
+}
+
+static void nft_unregister_basechain_hooks(struct net *net, int family,
+					   struct nft_base_chain *basechain)
+{
+	if (family == NFPROTO_NETDEV)
+		nft_netdev_unregister_hooks(net, &basechain->hook_list);
+	else
+		nf_unregister_net_hook(net, &basechain->ops);
+}
+
 static int nf_tables_register_hook(struct net *net,
 				   const struct nft_table *table,
 				   struct nft_chain *chain)
 {
-	const struct nft_base_chain *basechain;
+	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
 
 	if (table->flags & NFT_TABLE_F_DORMANT ||
@@ -168,14 +221,14 @@ static int nf_tables_register_hook(struct net *net,
 	if (basechain->type->ops_register)
 		return basechain->type->ops_register(net, ops);
 
-	return nf_register_net_hook(net, ops);
+	return nft_register_basechain_hooks(net, table->family, basechain);
 }
 
 static void nf_tables_unregister_hook(struct net *net,
 				      const struct nft_table *table,
 				      struct nft_chain *chain)
 {
-	const struct nft_base_chain *basechain;
+	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
 
 	if (table->flags & NFT_TABLE_F_DORMANT ||
@@ -187,7 +240,7 @@ static void nf_tables_unregister_hook(struct net *net,
 	if (basechain->type->ops_unregister)
 		return basechain->type->ops_unregister(net, ops);
 
-	nf_unregister_net_hook(net, ops);
+	nft_unregister_basechain_hooks(net, table->family, basechain);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -742,7 +795,8 @@ static void nft_table_disable(struct net *net, struct nft_table *table, u32 cnt)
 		if (cnt && i++ == cnt)
 			break;
 
-		nf_unregister_net_hook(net, &nft_base_chain(chain)->ops);
+		nft_unregister_basechain_hooks(net, table->family,
+					       nft_base_chain(chain));
 	}
 }
 
@@ -757,14 +811,16 @@ static int nf_tables_table_enable(struct net *net, struct nft_table *table)
 		if (!nft_is_base_chain(chain))
 			continue;
 
-		err = nf_register_net_hook(net, &nft_base_chain(chain)->ops);
+		err = nft_register_basechain_hooks(net, table->family,
+						   nft_base_chain(chain));
 		if (err < 0)
-			goto err;
+			goto err_register_hooks;
 
 		i++;
 	}
 	return 0;
-err:
+
+err_register_hooks:
 	if (i)
 		nft_table_disable(net, table, i);
 	return err;
@@ -1225,6 +1281,46 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
+static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
+				   const struct nft_base_chain *basechain)
+{
+	const struct nf_hook_ops *ops = &basechain->ops;
+	struct nft_hook *hook, *first = NULL;
+	struct nlattr *nest, *nest_devs;
+	int n = 0;
+
+	nest = nla_nest_start_noflag(skb, NFTA_CHAIN_HOOK);
+	if (nest == NULL)
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_HOOK_HOOKNUM, htonl(ops->hooknum)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_HOOK_PRIORITY, htonl(ops->priority)))
+		goto nla_put_failure;
+
+	if (family == NFPROTO_NETDEV) {
+		nest_devs = nla_nest_start_noflag(skb, NFTA_HOOK_DEVS);
+		list_for_each_entry(hook, &basechain->hook_list, list) {
+			if (!first)
+				first = hook;
+
+			if (nla_put_string(skb, NFTA_DEVICE_NAME,
+					   hook->ops.dev->name))
+				goto nla_put_failure;
+			n++;
+		}
+		nla_nest_end(skb, nest_devs);
+
+		if (n == 1 &&
+		    nla_put_string(skb, NFTA_HOOK_DEV, first->ops.dev->name))
+			goto nla_put_failure;
+	}
+	nla_nest_end(skb, nest);
+
+	return 0;
+nla_put_failure:
+	return -1;
+}
+
 static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 				     u32 portid, u32 seq, int event, u32 flags,
 				     int family, const struct nft_table *table,
@@ -1253,21 +1349,10 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
-		const struct nf_hook_ops *ops = &basechain->ops;
 		struct nft_stats __percpu *stats;
-		struct nlattr *nest;
 
-		nest = nla_nest_start_noflag(skb, NFTA_CHAIN_HOOK);
-		if (nest == NULL)
+		if (nft_dump_basechain_hook(skb, family, basechain))
 			goto nla_put_failure;
-		if (nla_put_be32(skb, NFTA_HOOK_HOOKNUM, htonl(ops->hooknum)))
-			goto nla_put_failure;
-		if (nla_put_be32(skb, NFTA_HOOK_PRIORITY, htonl(ops->priority)))
-			goto nla_put_failure;
-		if (basechain->dev_name[0] &&
-		    nla_put_string(skb, NFTA_HOOK_DEV, basechain->dev_name))
-			goto nla_put_failure;
-		nla_nest_end(skb, nest);
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
 				 htonl(basechain->policy)))
@@ -1485,6 +1570,7 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 {
 	struct nft_chain *chain = ctx->chain;
+	struct nft_hook *hook, *next;
 
 	if (WARN_ON(chain->use > 0))
 		return;
@@ -1495,6 +1581,13 @@ static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
+		if (ctx->family == NFPROTO_NETDEV) {
+			list_for_each_entry_safe(hook, next,
+						 &basechain->hook_list, list) {
+				list_del_rcu(&hook->list);
+				kfree_rcu(hook, rcu);
+			}
+		}
 		module_put(basechain->type->owner);
 		if (rcu_access_pointer(basechain->stats)) {
 			static_branch_dec(&nft_counters_enabled);
@@ -1599,9 +1692,34 @@ struct nft_chain_hook {
 	u32				num;
 	s32				priority;
 	const struct nft_chain_type	*type;
-	struct net_device		*dev;
+	struct list_head		list;
 };
 
+static int nft_chain_parse_netdev(struct net *net,
+				  struct nlattr *tb[],
+				  struct list_head *hook_list)
+{
+	struct nft_hook *hook;
+	int err;
+
+	if (tb[NFTA_HOOK_DEV]) {
+		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV]);
+		if (IS_ERR(hook))
+			return PTR_ERR(hook);
+
+		list_add_tail(&hook->list, hook_list);
+	} else if (tb[NFTA_HOOK_DEVS]) {
+		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
+						   hook_list);
+		if (err < 0)
+			return err;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_chain_parse_hook(struct net *net,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
@@ -1609,7 +1727,6 @@ static int nft_chain_parse_hook(struct net *net,
 {
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
 	const struct nft_chain_type *type;
-	struct net_device *dev;
 	int err;
 
 	lockdep_assert_held(&net->nft.commit_mutex);
@@ -1647,23 +1764,14 @@ static int nft_chain_parse_hook(struct net *net,
 
 	hook->type = type;
 
-	hook->dev = NULL;
+	INIT_LIST_HEAD(&hook->list);
 	if (family == NFPROTO_NETDEV) {
-		char ifname[IFNAMSIZ];
-
-		if (!ha[NFTA_HOOK_DEV]) {
-			module_put(type->owner);
-			return -EOPNOTSUPP;
-		}
-
-		nla_strlcpy(ifname, ha[NFTA_HOOK_DEV], IFNAMSIZ);
-		dev = __dev_get_by_name(net, ifname);
-		if (!dev) {
+		err = nft_chain_parse_netdev(net, ha, &hook->list);
+		if (err < 0) {
 			module_put(type->owner);
-			return -ENOENT;
+			return err;
 		}
-		hook->dev = dev;
-	} else if (ha[NFTA_HOOK_DEV]) {
+	} else if (ha[NFTA_HOOK_DEV] || ha[NFTA_HOOK_DEVS]) {
 		module_put(type->owner);
 		return -EOPNOTSUPP;
 	}
@@ -1673,6 +1781,12 @@ static int nft_chain_parse_hook(struct net *net,
 
 static void nft_chain_release_hook(struct nft_chain_hook *hook)
 {
+	struct nft_hook *h, *next;
+
+	list_for_each_entry_safe(h, next, &hook->list, list) {
+		list_del(&h->list);
+		kfree(h);
+	}
 	module_put(hook->type->owner);
 }
 
@@ -1697,6 +1811,49 @@ static struct nft_rule **nf_tables_chain_alloc_rules(const struct nft_chain *cha
 	return kvmalloc(alloc, GFP_KERNEL);
 }
 
+static void nft_basechain_hook_init(struct nf_hook_ops *ops, u8 family,
+				    const struct nft_chain_hook *hook,
+				    struct nft_chain *chain)
+{
+	ops->pf		= family;
+	ops->hooknum	= hook->num;
+	ops->priority	= hook->priority;
+	ops->priv	= chain;
+	ops->hook	= hook->type->hooks[ops->hooknum];
+}
+
+static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
+			      struct nft_chain_hook *hook, u32 flags)
+{
+	struct nft_chain *chain;
+	struct nft_hook *h;
+
+	basechain->type = hook->type;
+	INIT_LIST_HEAD(&basechain->hook_list);
+	chain = &basechain->chain;
+
+	if (family == NFPROTO_NETDEV) {
+		list_splice_init(&hook->list, &basechain->hook_list);
+		list_for_each_entry(h, &basechain->hook_list, list)
+			nft_basechain_hook_init(&h->ops, family, hook, chain);
+
+		basechain->ops.hooknum	= hook->num;
+		basechain->ops.priority	= hook->priority;
+	} else {
+		nft_basechain_hook_init(&basechain->ops, family, hook, chain);
+	}
+
+	chain->flags |= NFT_BASE_CHAIN | flags;
+	basechain->policy = NF_ACCEPT;
+	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
+	    nft_chain_offload_priority(basechain) < 0)
+		return -EOPNOTSUPP;
+
+	flow_block_init(&basechain->flow_block);
+
+	return 0;
+}
+
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      u8 policy, u32 flags)
 {
@@ -1715,7 +1872,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nft_chain_hook hook;
-		struct nf_hook_ops *ops;
 
 		err = nft_chain_parse_hook(net, nla, &hook, family, true);
 		if (err < 0)
@@ -1726,9 +1882,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			nft_chain_release_hook(&hook);
 			return -ENOMEM;
 		}
-
-		if (hook.dev != NULL)
-			strncpy(basechain->dev_name, hook.dev->name, IFNAMSIZ);
+		chain = &basechain->chain;
 
 		if (nla[NFTA_CHAIN_COUNTERS]) {
 			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
@@ -1741,24 +1895,12 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			static_branch_inc(&nft_counters_enabled);
 		}
 
-		basechain->type = hook.type;
-		chain = &basechain->chain;
-
-		ops		= &basechain->ops;
-		ops->pf		= family;
-		ops->hooknum	= hook.num;
-		ops->priority	= hook.priority;
-		ops->priv	= chain;
-		ops->hook	= hook.type->hooks[ops->hooknum];
-		ops->dev	= hook.dev;
-
-		chain->flags |= NFT_BASE_CHAIN | flags;
-		basechain->policy = NF_ACCEPT;
-		if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
-		    nft_chain_offload_priority(basechain) < 0)
-			return -EOPNOTSUPP;
-
-		flow_block_init(&basechain->flow_block);
+		err = nft_basechain_init(basechain, family, &hook, flags);
+		if (err < 0) {
+			nft_chain_release_hook(&hook);
+			kfree(basechain);
+			return err;
+		}
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
@@ -1818,6 +1960,25 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	return err;
 }
 
+static bool nft_hook_list_equal(struct list_head *hook_list1,
+				struct list_head *hook_list2)
+{
+	struct nft_hook *hook;
+	int n = 0, m = 0;
+
+	n = 0;
+	list_for_each_entry(hook, hook_list2, list) {
+		if (!nft_hook_list_find(hook_list1, hook))
+			return false;
+
+		n++;
+	}
+	list_for_each_entry(hook, hook_list1, list)
+		m++;
+
+	return n == m;
+}
+
 static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			      u32 flags)
 {
@@ -1849,12 +2010,19 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return -EBUSY;
 		}
 
-		ops = &basechain->ops;
-		if (ops->hooknum != hook.num ||
-		    ops->priority != hook.priority ||
-		    ops->dev != hook.dev) {
-			nft_chain_release_hook(&hook);
-			return -EBUSY;
+		if (ctx->family == NFPROTO_NETDEV) {
+			if (!nft_hook_list_equal(&basechain->hook_list,
+						 &hook.list)) {
+				nft_chain_release_hook(&hook);
+				return -EBUSY;
+			}
+		} else {
+			ops = &basechain->ops;
+			if (ops->hooknum != hook.num ||
+			    ops->priority != hook.priority) {
+				nft_chain_release_hook(&hook);
+				return -EBUSY;
+			}
 		}
 		nft_chain_release_hook(&hook);
 	}
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index e7f32a9dad63..beeb74f2b47d 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -317,38 +317,47 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
 
 static int nft_flow_block_chain(struct nft_base_chain *basechain,
-				struct net_device *dev,
+				const struct net_device *this_dev,
 				enum flow_block_command cmd)
 {
-	if (dev->netdev_ops->ndo_setup_tc)
-		return nft_block_offload_cmd(basechain, dev, cmd);
+	struct net_device *dev;
+	struct nft_hook *hook;
+	int err;
+
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		dev = hook->ops.dev;
+		if (this_dev && this_dev != dev)
+			continue;
 
-	return nft_indr_block_offload_cmd(basechain, dev, cmd);
+		if (dev->netdev_ops->ndo_setup_tc)
+			err = nft_block_offload_cmd(basechain, dev, cmd);
+		else
+			err = nft_indr_block_offload_cmd(basechain, dev, cmd);
+
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
 }
 
-static int nft_flow_offload_chain(struct nft_chain *chain,
-				  u8 *ppolicy,
+static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
 				  enum flow_block_command cmd)
 {
 	struct nft_base_chain *basechain;
-	struct net_device *dev;
 	u8 policy;
 
 	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
 
 	basechain = nft_base_chain(chain);
-	dev = basechain->ops.dev;
-	if (!dev)
-		return -EOPNOTSUPP;
-
 	policy = ppolicy ? *ppolicy : basechain->policy;
 
 	/* Only default policy to accept is supported for now. */
 	if (cmd == FLOW_BLOCK_BIND && policy == NF_DROP)
 		return -EOPNOTSUPP;
 
-	return nft_flow_block_chain(basechain, dev, cmd);
+	return nft_flow_block_chain(basechain, NULL, cmd);
 }
 
 int nft_flow_rule_offload_commit(struct net *net)
@@ -414,6 +423,7 @@ static struct nft_chain *__nft_offload_get_chain(struct net_device *dev)
 {
 	struct nft_base_chain *basechain;
 	struct net *net = dev_net(dev);
+	struct nft_hook *hook, *found;
 	const struct nft_table *table;
 	struct nft_chain *chain;
 
@@ -426,8 +436,16 @@ static struct nft_chain *__nft_offload_get_chain(struct net_device *dev)
 			    !(chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
+			found = NULL;
 			basechain = nft_base_chain(chain);
-			if (strncmp(basechain->dev_name, dev->name, IFNAMSIZ))
+			list_for_each_entry(hook, &basechain->hook_list, list) {
+				if (hook->ops.dev != dev)
+					continue;
+
+				found = hook;
+				break;
+			}
+			if (!found)
 				continue;
 
 			return chain;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b5d5d071d765..c78d01bc02e9 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -287,28 +287,35 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
+	struct nft_hook *hook, *found = NULL;
+	int n = 0;
 
-	switch (event) {
-	case NETDEV_UNREGISTER:
-		if (strcmp(basechain->dev_name, dev->name) != 0)
-			return;
-
-		/* UNREGISTER events are also happpening on netns exit.
-		 *
-		 * Altough nf_tables core releases all tables/chains, only
-		 * this event handler provides guarantee that
-		 * basechain.ops->dev is still accessible, so we cannot
-		 * skip exiting net namespaces.
-		 */
-		__nft_release_basechain(ctx);
-		break;
-	case NETDEV_CHANGENAME:
-		if (dev->ifindex != basechain->ops.dev->ifindex)
-			return;
+	if (event != NETDEV_UNREGISTER)
+		return;
 
-		strncpy(basechain->dev_name, dev->name, IFNAMSIZ);
-		break;
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		if (hook->ops.dev == dev)
+			found = hook;
+
+		n++;
 	}
+	if (!found)
+		return;
+
+	if (n > 1) {
+		nf_unregister_net_hook(ctx->net, &found->ops);
+		list_del_rcu(&found->list);
+		kfree_rcu(found, rcu);
+		return;
+	}
+
+	/* UNREGISTER events are also happening on netns exit.
+	 *
+	 * Although nf_tables core releases all tables/chains, only this event
+	 * handler provides guarantee that hook->ops.dev is still accessible,
+	 * so we cannot skip exiting net namespaces.
+	 */
+	__nft_release_basechain(ctx);
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
-- 
2.11.0

