Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C54341AC6F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbhI1J5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:57:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56966 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240047AbhI1J52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 05:57:28 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id EC3FD63EC0;
        Tue, 28 Sep 2021 11:54:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        lukas@wunner.de, daniel@iogearbox.net, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: [PATCH nf-next v5 3/6] netfilter: nf_tables: move netdev ingress filter chain to nf_tables_netdev.c
Date:   Tue, 28 Sep 2021 11:55:35 +0200
Message-Id: <20210928095538.114207-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928095538.114207-1-pablo@netfilter.org>
References: <20210928095538.114207-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tristate Kconfig toggle whose default is to compile support for
the netdev family as a module, this allows to blacklist Netfilter as
Daniel Borkmann requests.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig            |   2 +-
 net/netfilter/Makefile           |   1 +
 net/netfilter/nf_tables_api.c    |   7 +-
 net/netfilter/nf_tables_netdev.c | 148 +++++++++++++++++++++++++++++++
 net/netfilter/nft_chain_filter.c | 143 -----------------------------
 5 files changed, 154 insertions(+), 147 deletions(-)
 create mode 100644 net/netfilter/nf_tables_netdev.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 54395266339d..b45fb3de8209 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -480,7 +480,7 @@ config NF_TABLES_INET
 	  This option enables support for a mixed IPv4/IPv6 "inet" table.
 
 config NF_TABLES_NETDEV
-	bool "Netfilter nf_tables netdev tables support"
+	tristate "Netfilter nf_tables netdev tables support"
 	help
 	  This option enables support for the "netdev" table.
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index aab20e575ecd..21c23ff8630d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -86,6 +86,7 @@ endif
 endif
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
+obj-$(CONFIG_NF_TABLES_NETDEV)	+= nf_tables_netdev.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_CONNLIMIT)	+= nft_connlimit.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c0851fec11d4..200c5af3c427 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -26,6 +26,7 @@
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 
 unsigned int nf_tables_net_id __read_mostly;
+EXPORT_SYMBOL_GPL(nf_tables_net_id);
 
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
@@ -1948,8 +1949,6 @@ static int nft_chain_parse_hook(struct net *net,
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
 	type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
-	if (!type)
-		return -EOPNOTSUPP;
 
 	if (nla[NFTA_CHAIN_TYPE]) {
 		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
@@ -1958,7 +1957,9 @@ static int nft_chain_parse_hook(struct net *net,
 			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
 			return PTR_ERR(type);
 		}
-	}
+	} else if (!type)
+		return -EOPNOTSUPP;
+
 	if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
 
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
new file mode 100644
index 000000000000..8c42ea7d1be9
--- /dev/null
+++ b/net/netfilter/nf_tables_netdev.c
@@ -0,0 +1,148 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <net/net_namespace.h>
+#include <net/netfilter/nf_tables.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter_bridge.h>
+#include <linux/netfilter_arp.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
+
+static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
+					const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		nft_set_pktinfo_ipv4_validate(&pkt);
+		break;
+	case htons(ETH_P_IPV6):
+		nft_set_pktinfo_ipv6_validate(&pkt);
+		break;
+	default:
+		nft_set_pktinfo_unspec(&pkt);
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nft_chain_type nft_chain_filter_netdev = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_NETDEV,
+	.hook_mask	= (1 << NF_NETDEV_INGRESS),
+	.hooks		= {
+		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
+	},
+};
+
+static void nft_netdev_event(unsigned long event, struct net_device *dev,
+			     struct nft_ctx *ctx)
+{
+	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
+	struct nft_hook *hook, *found = NULL;
+	int n = 0;
+
+	if (event != NETDEV_UNREGISTER)
+		return;
+
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		if (hook->ops.dev == dev)
+			found = hook;
+
+		n++;
+	}
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
+}
+
+static int nf_tables_netdev_event(struct notifier_block *this,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nftables_pernet *nft_net;
+	struct nft_table *table;
+	struct nft_chain *chain, *nr;
+	struct nft_ctx ctx = {
+		.net	= dev_net(dev),
+	};
+
+	if (event != NETDEV_UNREGISTER &&
+	    event != NETDEV_CHANGENAME)
+		return NOTIFY_DONE;
+
+	nft_net = nft_pernet(ctx.net);
+	mutex_lock(&nft_net->commit_mutex);
+	list_for_each_entry(table, &nft_net->tables, list) {
+		if (table->family != NFPROTO_NETDEV)
+			continue;
+
+		ctx.family = table->family;
+		ctx.table = table;
+		list_for_each_entry_safe(chain, nr, &table->chains, list) {
+			if (!nft_is_base_chain(chain))
+				continue;
+
+			ctx.chain = chain;
+			nft_netdev_event(event, dev, &ctx);
+		}
+	}
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nf_tables_netdev_notifier = {
+	.notifier_call	= nf_tables_netdev_event,
+};
+
+static int nft_chain_filter_netdev_init(void)
+{
+	int err;
+
+	nft_register_chain_type(&nft_chain_filter_netdev);
+
+	err = register_netdevice_notifier(&nf_tables_netdev_notifier);
+	if (err)
+		goto err_register_netdevice_notifier;
+
+	return 0;
+
+err_register_netdevice_notifier:
+	nft_unregister_chain_type(&nft_chain_filter_netdev);
+
+	return err;
+}
+
+static void nft_chain_filter_netdev_fini(void)
+{
+	nft_unregister_chain_type(&nft_chain_filter_netdev);
+	unregister_netdevice_notifier(&nf_tables_netdev_notifier);
+}
+
+module_init(nft_chain_filter_netdev_init);
+module_exit(nft_chain_filter_netdev_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_NFT_CHAIN(5, "filter");	/* NFPROTO_NETDEV */
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 5b02408a920b..1ce2ffb71981 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -283,150 +283,8 @@ static inline void nft_chain_filter_bridge_init(void) {}
 static inline void nft_chain_filter_bridge_fini(void) {}
 #endif /* CONFIG_NF_TABLES_BRIDGE */
 
-#ifdef CONFIG_NF_TABLES_NETDEV
-static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
-					const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt);
-		break;
-	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt);
-		break;
-	default:
-		nft_set_pktinfo_unspec(&pkt);
-		break;
-	}
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static const struct nft_chain_type nft_chain_filter_netdev = {
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.family		= NFPROTO_NETDEV,
-	.hook_mask	= (1 << NF_NETDEV_INGRESS),
-	.hooks		= {
-		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
-	},
-};
-
-static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_ctx *ctx)
-{
-	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
-	struct nft_hook *hook, *found = NULL;
-	int n = 0;
-
-	if (event != NETDEV_UNREGISTER)
-		return;
-
-	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (hook->ops.dev == dev)
-			found = hook;
-
-		n++;
-	}
-	if (!found)
-		return;
-
-	if (n > 1) {
-		nf_unregister_net_hook(ctx->net, &found->ops);
-		list_del_rcu(&found->list);
-		kfree_rcu(found, rcu);
-		return;
-	}
-
-	/* UNREGISTER events are also happening on netns exit.
-	 *
-	 * Although nf_tables core releases all tables/chains, only this event
-	 * handler provides guarantee that hook->ops.dev is still accessible,
-	 * so we cannot skip exiting net namespaces.
-	 */
-	__nft_release_basechain(ctx);
-}
-
-static int nf_tables_netdev_event(struct notifier_block *this,
-				  unsigned long event, void *ptr)
-{
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct nftables_pernet *nft_net;
-	struct nft_table *table;
-	struct nft_chain *chain, *nr;
-	struct nft_ctx ctx = {
-		.net	= dev_net(dev),
-	};
-
-	if (event != NETDEV_UNREGISTER &&
-	    event != NETDEV_CHANGENAME)
-		return NOTIFY_DONE;
-
-	nft_net = nft_pernet(ctx.net);
-	mutex_lock(&nft_net->commit_mutex);
-	list_for_each_entry(table, &nft_net->tables, list) {
-		if (table->family != NFPROTO_NETDEV)
-			continue;
-
-		ctx.family = table->family;
-		ctx.table = table;
-		list_for_each_entry_safe(chain, nr, &table->chains, list) {
-			if (!nft_is_base_chain(chain))
-				continue;
-
-			ctx.chain = chain;
-			nft_netdev_event(event, dev, &ctx);
-		}
-	}
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block nf_tables_netdev_notifier = {
-	.notifier_call	= nf_tables_netdev_event,
-};
-
-static int nft_chain_filter_netdev_init(void)
-{
-	int err;
-
-	nft_register_chain_type(&nft_chain_filter_netdev);
-
-	err = register_netdevice_notifier(&nf_tables_netdev_notifier);
-	if (err)
-		goto err_register_netdevice_notifier;
-
-	return 0;
-
-err_register_netdevice_notifier:
-	nft_unregister_chain_type(&nft_chain_filter_netdev);
-
-	return err;
-}
-
-static void nft_chain_filter_netdev_fini(void)
-{
-	nft_unregister_chain_type(&nft_chain_filter_netdev);
-	unregister_netdevice_notifier(&nf_tables_netdev_notifier);
-}
-#else
-static inline int nft_chain_filter_netdev_init(void) { return 0; }
-static inline void nft_chain_filter_netdev_fini(void) {}
-#endif /* CONFIG_NF_TABLES_NETDEV */
-
 int __init nft_chain_filter_init(void)
 {
-	int err;
-
-	err = nft_chain_filter_netdev_init();
-	if (err < 0)
-		return err;
-
 	nft_chain_filter_ipv4_init();
 	nft_chain_filter_ipv6_init();
 	nft_chain_filter_arp_init();
@@ -443,5 +301,4 @@ void nft_chain_filter_fini(void)
 	nft_chain_filter_arp_fini();
 	nft_chain_filter_ipv6_fini();
 	nft_chain_filter_ipv4_fini();
-	nft_chain_filter_netdev_fini();
 }
-- 
2.30.2

