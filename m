Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CB53A1F45
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhFIVrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:48 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60498 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhFIVrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:32 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F260664230;
        Wed,  9 Jun 2021 23:44:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/13] netfilter: add new hook nfnl subsystem
Date:   Wed,  9 Jun 2021 23:45:19 +0200
Message-Id: <20210609214523.1678-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This nfnl subsystem allows to dump the list of all active netfiler hooks,
e.g. defrag, conntrack, nf/ip/arp/ip6tables and so on.

This helps to see what kind of features are currently enabled in
the network stack.

Sample output from nft tool using this infra:

 $ nft list hook ip input
 family ip hook input {
   +0000000010 nft_do_chain_inet [nf_tables] # nft table firewalld INPUT
   +0000000100 nf_nat_ipv4_local_in [nf_nat]
   +2147483647 ipv4_confirm [nf_conntrack]
 }

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink.h      |   3 +-
 include/uapi/linux/netfilter/nfnetlink_hook.h |  55 +++
 net/netfilter/Kconfig                         |   9 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nfnetlink.c                     |   1 +
 net/netfilter/nfnetlink_hook.c                | 375 ++++++++++++++++++
 6 files changed, 443 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/netfilter/nfnetlink_hook.h
 create mode 100644 net/netfilter/nfnetlink_hook.c

diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 5bc960f220b3..6cd58cd2a6f0 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -60,7 +60,8 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_CTHELPER		9
 #define NFNL_SUBSYS_NFTABLES		10
 #define NFNL_SUBSYS_NFT_COMPAT		11
-#define NFNL_SUBSYS_COUNT		12
+#define NFNL_SUBSYS_HOOK		12
+#define NFNL_SUBSYS_COUNT		13
 
 /* Reserved control nfnetlink messages */
 #define NFNL_MSG_BATCH_BEGIN		NLMSG_MIN_TYPE
diff --git a/include/uapi/linux/netfilter/nfnetlink_hook.h b/include/uapi/linux/netfilter/nfnetlink_hook.h
new file mode 100644
index 000000000000..912ec60b26b0
--- /dev/null
+++ b/include/uapi/linux/netfilter/nfnetlink_hook.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _NFNL_HOOK_H_
+#define _NFNL_HOOK_H_
+
+enum nfnl_hook_msg_types {
+	NFNL_MSG_HOOK_GET,
+	NFNL_MSG_HOOK_MAX,
+};
+
+/**
+ * enum nfnl_hook_attributes - netfilter hook netlink attributes
+ *
+ * @NFNLA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
+ * @NFNLA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
+ * @NFNLA_HOOK_DEV: netdevice name (NLA_STRING)
+ * @NFNLA_HOOK_FUNCTION_NAME: hook function name (NLA_STRING)
+ * @NFNLA_HOOK_MODULE_NAME: kernel module that registered this hook (NLA_STRING)
+ * @NFNLA_HOOK_CHAIN_INFO: basechain hook metadata (NLA_NESTED)
+ */
+enum nfnl_hook_attributes {
+	NFNLA_HOOK_UNSPEC,
+	NFNLA_HOOK_HOOKNUM,
+	NFNLA_HOOK_PRIORITY,
+	NFNLA_HOOK_DEV,
+	NFNLA_HOOK_FUNCTION_NAME,
+	NFNLA_HOOK_MODULE_NAME,
+	NFNLA_HOOK_CHAIN_INFO,
+	__NFNLA_HOOK_MAX
+};
+#define NFNLA_HOOK_MAX		(__NFNLA_HOOK_MAX - 1)
+
+/**
+ * enum nfnl_hook_chain_info_attributes - chain description
+ *
+ * NFNLA_HOOK_INFO_DESC: nft chain and table name (enum nft_table_attributes) (NLA_NESTED)
+ * NFNLA_HOOK_INFO_TYPE: chain type (enum nfnl_hook_chaintype) (NLA_U32)
+ */
+enum nfnl_hook_chain_info_attributes {
+	NFNLA_HOOK_INFO_UNSPEC,
+	NFNLA_HOOK_INFO_DESC,
+	NFNLA_HOOK_INFO_TYPE,
+	__NFNLA_HOOK_INFO_MAX,
+};
+#define NFNLA_HOOK_INFO_MAX (__NFNLA_HOOK_INFO_MAX - 1)
+
+/**
+ * enum nfnl_hook_chaintype - chain type
+ *
+ * @NFNL_HOOK_TYPE_NFTABLES nf_tables base chain
+ */
+enum nfnl_hook_chaintype {
+	NFNL_HOOK_TYPE_NFTABLES = 0x1,
+};
+
+#endif /* _NFNL_HOOK_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 172d74560632..c81321372198 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -19,6 +19,15 @@ config NETFILTER_FAMILY_BRIDGE
 config NETFILTER_FAMILY_ARP
 	bool
 
+config NETFILTER_NETLINK_HOOK
+	tristate "Netfilter base hook dump support"
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_NETLINK
+	help
+	  If this option is enabled, the kernel will include support
+	  to list the base netfilter hooks via NFNETLINK.
+	  This is helpful for debugging.
+
 config NETFILTER_NETLINK_ACCT
 	tristate "Netfilter NFACCT over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e80e010354b1..87112dad1fd4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
 obj-$(CONFIG_NETFILTER_NETLINK_OSF) += nfnetlink_osf.o
+obj-$(CONFIG_NETFILTER_NETLINK_HOOK) += nfnetlink_hook.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK) += nf_conntrack.o
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 028a1f39318b..7e2c8dd01408 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -68,6 +68,7 @@ static const char *const nfnl_lockdep_names[NFNL_SUBSYS_COUNT] = {
 	[NFNL_SUBSYS_CTHELPER] = "nfnl_subsys_cthelper",
 	[NFNL_SUBSYS_NFTABLES] = "nfnl_subsys_nftables",
 	[NFNL_SUBSYS_NFT_COMPAT] = "nfnl_subsys_nftcompat",
+	[NFNL_SUBSYS_HOOK] = "nfnl_subsys_hook",
 };
 
 static const int nfnl_group2type[NFNLGRP_MAX+1] = {
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
new file mode 100644
index 000000000000..04586dfa2acd
--- /dev/null
+++ b/net/netfilter/nfnetlink_hook.c
@@ -0,0 +1,375 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021 Red Hat GmbH
+ *
+ * Author: Florian Westphal <fw@strlen.de>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/skbuff.h>
+#include <linux/errno.h>
+#include <linux/netlink.h>
+#include <linux/slab.h>
+
+#include <linux/netfilter.h>
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_hook.h>
+
+#include <net/netfilter/nf_tables.h>
+#include <net/sock.h>
+
+static const struct nla_policy nfnl_hook_nla_policy[NFNLA_HOOK_MAX + 1] = {
+	[NFNLA_HOOK_HOOKNUM]	= { .type = NLA_U32 },
+	[NFNLA_HOOK_PRIORITY]	= { .type = NLA_U32 },
+	[NFNLA_HOOK_DEV]	= { .type = NLA_STRING,
+				    .len = IFNAMSIZ - 1 },
+	[NFNLA_HOOK_FUNCTION_NAME] = { .type = NLA_NUL_STRING,
+				       .len = KSYM_NAME_LEN, },
+	[NFNLA_HOOK_MODULE_NAME] = { .type = NLA_NUL_STRING,
+				     .len = MODULE_NAME_LEN, },
+	[NFNLA_HOOK_CHAIN_INFO] = { .type = NLA_NESTED, },
+};
+
+static int nf_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
+				     const struct nlmsghdr *nlh,
+				     struct netlink_dump_control *c)
+{
+	int err;
+
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+
+	rcu_read_unlock();
+	err = netlink_dump_start(nlsk, skb, nlh, c);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
+
+	return err;
+}
+
+struct nfnl_dump_hook_data {
+	char devname[IFNAMSIZ];
+	unsigned long headv;
+	u8 hook;
+};
+
+static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
+					const struct nfnl_dump_hook_data *ctx,
+					unsigned int seq,
+					const struct nf_hook_ops *ops)
+{
+	struct net *net = sock_net(nlskb->sk);
+	struct nlattr *nest, *nest2;
+	struct nft_chain *chain;
+	int ret = 0;
+
+	if (ops->hook_ops_type != NF_HOOK_OP_NF_TABLES)
+		return 0;
+
+	chain = ops->priv;
+	if (WARN_ON_ONCE(!chain))
+		return 0;
+
+	if (!nft_is_active(net, chain))
+		return 0;
+
+	nest = nla_nest_start(nlskb, NFNLA_HOOK_CHAIN_INFO);
+	if (!nest)
+		return -EMSGSIZE;
+
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_INFO_TYPE,
+			   htonl(NFNL_HOOK_TYPE_NFTABLES));
+	if (ret)
+		goto cancel_nest;
+
+	nest2 = nla_nest_start(nlskb, NFNLA_HOOK_INFO_DESC);
+	if (!nest2)
+		goto cancel_nest;
+
+	ret = nla_put_string(nlskb, NFTA_CHAIN_TABLE, chain->table->name);
+	if (ret)
+		goto cancel_nest;
+
+	ret = nla_put_string(nlskb, NFTA_CHAIN_NAME, chain->name);
+	if (ret)
+		goto cancel_nest;
+
+	nla_nest_end(nlskb, nest2);
+	nla_nest_end(nlskb, nest);
+	return ret;
+
+cancel_nest:
+	nla_nest_cancel(nlskb, nest);
+	return -EMSGSIZE;
+}
+
+static int nfnl_hook_dump_one(struct sk_buff *nlskb,
+			      const struct nfnl_dump_hook_data *ctx,
+			      const struct nf_hook_ops *ops,
+			      unsigned int seq)
+{
+	u16 event = nfnl_msg_type(NFNL_SUBSYS_HOOK, NFNL_MSG_HOOK_GET);
+	unsigned int portid = NETLINK_CB(nlskb).portid;
+	struct nlmsghdr *nlh;
+	int ret = -EMSGSIZE;
+#ifdef CONFIG_KALLSYMS
+	char sym[KSYM_SYMBOL_LEN];
+	char *module_name;
+#endif
+	nlh = nfnl_msg_put(nlskb, portid, seq, event,
+			   NLM_F_MULTI, ops->pf, NFNETLINK_V0, 0);
+	if (!nlh)
+		goto nla_put_failure;
+
+#ifdef CONFIG_KALLSYMS
+	ret = snprintf(sym, sizeof(sym), "%ps", ops->hook);
+	if (ret < 0 || ret > (int)sizeof(sym))
+		goto nla_put_failure;
+
+	module_name = strstr(sym, " [");
+	if (module_name) {
+		char *end;
+
+		module_name += 2;
+		end = strchr(module_name, ']');
+		if (end) {
+			*end = 0;
+
+			ret = nla_put_string(nlskb, NFNLA_HOOK_MODULE_NAME, module_name);
+			if (ret)
+				goto nla_put_failure;
+		}
+	}
+
+	ret = nla_put_string(nlskb, NFNLA_HOOK_FUNCTION_NAME, sym);
+	if (ret)
+		goto nla_put_failure;
+#endif
+
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_HOOKNUM, htonl(ops->hooknum));
+	if (ret)
+		goto nla_put_failure;
+
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_PRIORITY, htonl(ops->priority));
+	if (ret)
+		goto nla_put_failure;
+
+	ret = nfnl_hook_put_nft_chain_info(nlskb, ctx, seq, ops);
+	if (ret)
+		goto nla_put_failure;
+
+	nlmsg_end(nlskb, nlh);
+	return 0;
+nla_put_failure:
+	nlmsg_trim(nlskb, nlh);
+	return ret;
+}
+
+static const struct nf_hook_entries *
+nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *dev)
+{
+	const struct nf_hook_entries *hook_head = NULL;
+	struct net_device *netdev;
+
+	switch (pf) {
+	case NFPROTO_IPV4:
+		if (hook >= ARRAY_SIZE(net->nf.hooks_ipv4))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
+		break;
+	case NFPROTO_IPV6:
+		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
+		if (hook >= ARRAY_SIZE(net->nf.hooks_ipv6))
+			return ERR_PTR(-EINVAL);
+		break;
+	case NFPROTO_ARP:
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
+		if (hook >= ARRAY_SIZE(net->nf.hooks_arp))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
+#endif
+		break;
+	case NFPROTO_BRIDGE:
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
+		if (hook >= ARRAY_SIZE(net->nf.hooks_bridge))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
+#endif
+		break;
+#if IS_ENABLED(CONFIG_DECNET)
+	case NFPROTO_DECNET:
+		if (hook >= ARRAY_SIZE(net->nf.hooks_decnet))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
+		break;
+#endif
+#ifdef CONFIG_NETFILTER_INGRESS
+	case NFPROTO_NETDEV:
+		if (hook != NF_NETDEV_INGRESS)
+			return ERR_PTR(-EOPNOTSUPP);
+
+		if (!dev)
+			return ERR_PTR(-ENODEV);
+
+		netdev = dev_get_by_name_rcu(net, dev);
+		if (!netdev)
+			return ERR_PTR(-ENODEV);
+
+		return rcu_dereference(netdev->nf_hooks_ingress);
+#endif
+	default:
+		return ERR_PTR(-EPROTONOSUPPORT);
+	}
+
+	return hook_head;
+}
+
+static int nfnl_hook_dump(struct sk_buff *nlskb,
+			  struct netlink_callback *cb)
+{
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	struct nfnl_dump_hook_data *ctx = cb->data;
+	int err, family = nfmsg->nfgen_family;
+	struct net *net = sock_net(nlskb->sk);
+	struct nf_hook_ops * const *ops;
+	const struct nf_hook_entries *e;
+	unsigned int i = cb->args[0];
+
+	rcu_read_lock();
+
+	e = nfnl_hook_entries_head(family, ctx->hook, net, ctx->devname);
+	if (!e)
+		goto done;
+
+	if (IS_ERR(e)) {
+		cb->seq++;
+		goto done;
+	}
+
+	if ((unsigned long)e != ctx->headv || i >= e->num_hook_entries)
+		cb->seq++;
+
+	ops = nf_hook_entries_get_hook_ops(e);
+
+	for (; i < e->num_hook_entries; i++) {
+		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], cb->seq);
+		if (err)
+			break;
+	}
+
+done:
+	nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
+	rcu_read_unlock();
+	cb->args[0] = i;
+	return nlskb->len;
+}
+
+static int nfnl_hook_dump_start(struct netlink_callback *cb)
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	const struct nlattr * const *nla = cb->data;
+	struct nfnl_dump_hook_data *ctx = NULL;
+	struct net *net = sock_net(cb->skb->sk);
+	u8 family = nfmsg->nfgen_family;
+	char name[IFNAMSIZ] = "";
+	const void *head;
+	u32 hooknum;
+
+	hooknum = ntohl(nla_get_be32(nla[NFNLA_HOOK_HOOKNUM]));
+	if (hooknum > 255)
+		return -EINVAL;
+
+	if (family == NFPROTO_NETDEV) {
+		if (!nla[NFNLA_HOOK_DEV])
+			return -EINVAL;
+
+		nla_strscpy(name, nla[NFNLA_HOOK_DEV], sizeof(name));
+	}
+
+	rcu_read_lock();
+	/* Not dereferenced; for consistency check only */
+	head = nfnl_hook_entries_head(family, hooknum, net, name);
+	rcu_read_unlock();
+
+	if (head && IS_ERR(head))
+		return PTR_ERR(head);
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	strscpy(ctx->devname, name, sizeof(ctx->devname));
+	ctx->headv = (unsigned long)head;
+	ctx->hook = hooknum;
+
+	cb->seq = 1;
+	cb->data = ctx;
+
+	return 0;
+}
+
+static int nfnl_hook_dump_stop(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+	return 0;
+}
+
+static int nfnl_hook_get(struct sk_buff *skb,
+			 const struct nfnl_info *info,
+			 const struct nlattr * const nla[])
+{
+	if (!nla[NFNLA_HOOK_HOOKNUM])
+		return -EINVAL;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nfnl_hook_dump_start,
+			.done = nfnl_hook_dump_stop,
+			.dump = nfnl_hook_dump,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nf_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static const struct nfnl_callback nfnl_hook_cb[NFNL_MSG_HOOK_MAX] = {
+	[NFNL_MSG_HOOK_GET] = {
+		.call		= nfnl_hook_get,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFNLA_HOOK_MAX,
+		.policy		= nfnl_hook_nla_policy
+	},
+};
+
+static const struct nfnetlink_subsystem nfhook_subsys = {
+	.name				= "nfhook",
+	.subsys_id			= NFNL_SUBSYS_HOOK,
+	.cb_count			= NFNL_MSG_HOOK_MAX,
+	.cb				= nfnl_hook_cb,
+};
+
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_HOOK);
+
+static int __init nfnetlink_hook_init(void)
+{
+	return nfnetlink_subsys_register(&nfhook_subsys);
+}
+
+static void __exit nfnetlink_hook_exit(void)
+{
+	nfnetlink_subsys_unregister(&nfhook_subsys);
+}
+
+module_init(nfnetlink_hook_init);
+module_exit(nfnetlink_hook_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
+MODULE_DESCRIPTION("nfnetlink_hook: list registered netfilter hooks");
-- 
2.30.2

