Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC36E5A17
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfJZLrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:55 -0400
Received: from correo.us.es ([193.147.175.20]:46416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbfJZLrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A7AF88C3C5F
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 996ECA7E1F
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8F175A7E1C; Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 698D7A7EE4;
        Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 38EBB42EE393;
        Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 20/31] netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables
Date:   Sat, 26 Oct 2019 13:47:22 +0200
Message-Id: <20191026114733.28111-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a list of hooks per device instead an array.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   8 +-
 net/netfilter/nf_tables_api.c     | 253 +++++++++++++++++++++++---------------
 2 files changed, 158 insertions(+), 103 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d529dfb5aa64..7a2ac82ee0ad 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -963,6 +963,12 @@ struct nft_stats {
 	struct u64_stats_sync	syncp;
 };
 
+struct nft_hook {
+	struct list_head	list;
+	struct nf_hook_ops	ops;
+	struct rcu_head		rcu;
+};
+
 /**
  *	struct nft_base_chain - nf_tables base chain
  *
@@ -1173,7 +1179,7 @@ struct nft_flowtable {
 					use:30;
 	u64				handle;
 	/* runtime data below here */
-	struct nf_hook_ops		*ops ____cacheline_aligned;
+	struct list_head		hook_list ____cacheline_aligned;
 	struct nf_flowtable		data;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bfea0d6effc5..d6224c7b0e28 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1508,6 +1508,76 @@ static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	}
 }
 
+static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
+					      const struct nlattr *attr)
+{
+	struct net_device *dev;
+	char ifname[IFNAMSIZ];
+	struct nft_hook *hook;
+	int err;
+
+	hook = kmalloc(sizeof(struct nft_hook), GFP_KERNEL);
+	if (!hook) {
+		err = -ENOMEM;
+		goto err_hook_alloc;
+	}
+
+	nla_strlcpy(ifname, attr, IFNAMSIZ);
+	dev = __dev_get_by_name(net, ifname);
+	if (!dev) {
+		err = -ENOENT;
+		goto err_hook_dev;
+	}
+	hook->ops.dev = dev;
+
+	return hook;
+
+err_hook_dev:
+	kfree(hook);
+err_hook_alloc:
+	return ERR_PTR(err);
+}
+
+static int nf_tables_parse_netdev_hooks(struct net *net,
+					const struct nlattr *attr,
+					struct list_head *hook_list)
+{
+	struct nft_hook *hook, *next;
+	const struct nlattr *tmp;
+	int rem, n = 0, err;
+
+	nla_for_each_nested(tmp, attr, rem) {
+		if (nla_type(tmp) != NFTA_DEVICE_NAME) {
+			err = -EINVAL;
+			goto err_hook;
+		}
+
+		hook = nft_netdev_hook_alloc(net, tmp);
+		if (IS_ERR(hook)) {
+			err = PTR_ERR(hook);
+			goto err_hook;
+		}
+		list_add_tail(&hook->list, hook_list);
+		n++;
+
+		if (n == NFT_FLOWTABLE_DEVICE_MAX) {
+			err = -EFBIG;
+			goto err_hook;
+		}
+	}
+	if (!n)
+		return -EINVAL;
+
+	return 0;
+
+err_hook:
+	list_for_each_entry_safe(hook, next, hook_list, list) {
+		list_del(&hook->list);
+		kfree(hook);
+	}
+	return err;
+}
+
 struct nft_chain_hook {
 	u32				num;
 	s32				priority;
@@ -5628,43 +5698,6 @@ nft_flowtable_lookup_byhandle(const struct nft_table *table,
        return ERR_PTR(-ENOENT);
 }
 
-static int nf_tables_parse_devices(const struct nft_ctx *ctx,
-				   const struct nlattr *attr,
-				   struct net_device *dev_array[], int *len)
-{
-	const struct nlattr *tmp;
-	struct net_device *dev;
-	char ifname[IFNAMSIZ];
-	int rem, n = 0, err;
-
-	nla_for_each_nested(tmp, attr, rem) {
-		if (nla_type(tmp) != NFTA_DEVICE_NAME) {
-			err = -EINVAL;
-			goto err1;
-		}
-
-		nla_strlcpy(ifname, tmp, IFNAMSIZ);
-		dev = __dev_get_by_name(ctx->net, ifname);
-		if (!dev) {
-			err = -ENOENT;
-			goto err1;
-		}
-
-		dev_array[n++] = dev;
-		if (n == NFT_FLOWTABLE_DEVICE_MAX) {
-			err = -EFBIG;
-			goto err1;
-		}
-	}
-	if (!len)
-		return -EINVAL;
-
-	err = 0;
-err1:
-	*len = n;
-	return err;
-}
-
 static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX + 1] = {
 	[NFTA_FLOWTABLE_HOOK_NUM]	= { .type = NLA_U32 },
 	[NFTA_FLOWTABLE_HOOK_PRIORITY]	= { .type = NLA_U32 },
@@ -5675,11 +5708,10 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 					  const struct nlattr *attr,
 					  struct nft_flowtable *flowtable)
 {
-	struct net_device *dev_array[NFT_FLOWTABLE_DEVICE_MAX];
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
-	struct nf_hook_ops *ops;
+	struct nft_hook *hook;
 	int hooknum, priority;
-	int err, n = 0, i;
+	int err;
 
 	err = nla_parse_nested_deprecated(tb, NFTA_FLOWTABLE_HOOK_MAX, attr,
 					  nft_flowtable_hook_policy, NULL);
@@ -5697,27 +5729,21 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 
 	priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
 
-	err = nf_tables_parse_devices(ctx, tb[NFTA_FLOWTABLE_HOOK_DEVS],
-				      dev_array, &n);
+	err = nf_tables_parse_netdev_hooks(ctx->net,
+					   tb[NFTA_FLOWTABLE_HOOK_DEVS],
+					   &flowtable->hook_list);
 	if (err < 0)
 		return err;
 
-	ops = kcalloc(n, sizeof(struct nf_hook_ops), GFP_KERNEL);
-	if (!ops)
-		return -ENOMEM;
-
 	flowtable->hooknum		= hooknum;
 	flowtable->data.priority	= priority;
-	flowtable->ops			= ops;
-	flowtable->ops_len		= n;
 
-	for (i = 0; i < n; i++) {
-		flowtable->ops[i].pf		= NFPROTO_NETDEV;
-		flowtable->ops[i].hooknum	= hooknum;
-		flowtable->ops[i].priority	= priority;
-		flowtable->ops[i].priv		= &flowtable->data;
-		flowtable->ops[i].hook		= flowtable->data.type->hook;
-		flowtable->ops[i].dev		= dev_array[i];
+	list_for_each_entry(hook, &flowtable->hook_list, list) {
+		hook->ops.pf		= NFPROTO_NETDEV;
+		hook->ops.hooknum	= hooknum;
+		hook->ops.priority	= priority;
+		hook->ops.priv		= &flowtable->data;
+		hook->ops.hook		= flowtable->data.type->hook;
 	}
 
 	return err;
@@ -5757,14 +5783,51 @@ nft_flowtable_type_get(struct net *net, u8 family)
 static void nft_unregister_flowtable_net_hooks(struct net *net,
 					       struct nft_flowtable *flowtable)
 {
-	int i;
+	struct nft_hook *hook;
 
-	for (i = 0; i < flowtable->ops_len; i++) {
-		if (!flowtable->ops[i].dev)
-			continue;
+	list_for_each_entry(hook, &flowtable->hook_list, list)
+		nf_unregister_net_hook(net, &hook->ops);
+}
+
+static int nft_register_flowtable_net_hooks(struct net *net,
+					    struct nft_table *table,
+					    struct nft_flowtable *flowtable)
+{
+	struct nft_hook *hook, *hook2, *next;
+	struct nft_flowtable *ft;
+	int err, i = 0;
+
+	list_for_each_entry(hook, &flowtable->hook_list, list) {
+		list_for_each_entry(ft, &table->flowtables, list) {
+			list_for_each_entry(hook2, &ft->hook_list, list) {
+				if (hook->ops.dev == hook2->ops.dev &&
+				    hook->ops.pf == hook2->ops.pf) {
+					err = -EBUSY;
+					goto err_unregister_net_hooks;
+				}
+			}
+		}
 
-		nf_unregister_net_hook(net, &flowtable->ops[i]);
+		err = nf_register_net_hook(net, &hook->ops);
+		if (err < 0)
+			goto err_unregister_net_hooks;
+
+		i++;
 	}
+
+	return 0;
+
+err_unregister_net_hooks:
+	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+		if (i-- <= 0)
+			break;
+
+		nf_unregister_net_hook(net, &hook->ops);
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
+	}
+
+	return err;
 }
 
 static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
@@ -5775,12 +5838,13 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nf_flowtable_type *type;
-	struct nft_flowtable *flowtable, *ft;
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
+	struct nft_flowtable *flowtable;
+	struct nft_hook *hook, *next;
 	struct nft_table *table;
 	struct nft_ctx ctx;
-	int err, i, k;
+	int err;
 
 	if (!nla[NFTA_FLOWTABLE_TABLE] ||
 	    !nla[NFTA_FLOWTABLE_NAME] ||
@@ -5819,6 +5883,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 
 	flowtable->table = table;
 	flowtable->handle = nf_tables_alloc_handle(table);
+	INIT_LIST_HEAD(&flowtable->hook_list);
 
 	flowtable->name = nla_strdup(nla[NFTA_FLOWTABLE_NAME], GFP_KERNEL);
 	if (!flowtable->name) {
@@ -5842,43 +5907,24 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err4;
 
-	for (i = 0; i < flowtable->ops_len; i++) {
-		if (!flowtable->ops[i].dev)
-			continue;
-
-		list_for_each_entry(ft, &table->flowtables, list) {
-			for (k = 0; k < ft->ops_len; k++) {
-				if (!ft->ops[k].dev)
-					continue;
-
-				if (flowtable->ops[i].dev == ft->ops[k].dev &&
-				    flowtable->ops[i].pf == ft->ops[k].pf) {
-					err = -EBUSY;
-					goto err5;
-				}
-			}
-		}
-
-		err = nf_register_net_hook(net, &flowtable->ops[i]);
-		if (err < 0)
-			goto err5;
-	}
+	err = nft_register_flowtable_net_hooks(ctx.net, table, flowtable);
+	if (err < 0)
+		goto err4;
 
 	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
 	if (err < 0)
-		goto err6;
+		goto err5;
 
 	list_add_tail_rcu(&flowtable->list, &table->flowtables);
 	table->use++;
 
 	return 0;
-err6:
-	i = flowtable->ops_len;
 err5:
-	for (k = i - 1; k >= 0; k--)
-		nf_unregister_net_hook(net, &flowtable->ops[k]);
-
-	kfree(flowtable->ops);
+	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+		nf_unregister_net_hook(net, &hook->ops);
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
+	}
 err4:
 	flowtable->data.type->free(&flowtable->data);
 err3:
@@ -5945,8 +5991,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlattr *nest, *nest_devs;
 	struct nfgenmsg *nfmsg;
+	struct nft_hook *hook;
 	struct nlmsghdr *nlh;
-	int i;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), flags);
@@ -5976,11 +6022,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	if (!nest_devs)
 		goto nla_put_failure;
 
-	for (i = 0; i < flowtable->ops_len; i++) {
-		const struct net_device *dev = READ_ONCE(flowtable->ops[i].dev);
-
-		if (dev &&
-		    nla_put_string(skb, NFTA_DEVICE_NAME, dev->name))
+	list_for_each_entry_rcu(hook, &flowtable->hook_list, list) {
+		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
@@ -6171,7 +6214,12 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
-	kfree(flowtable->ops);
+	struct nft_hook *hook, *next;
+
+	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+		list_del_rcu(&hook->list);
+		kfree(hook);
+	}
 	kfree(flowtable->name);
 	flowtable->data.type->free(&flowtable->data);
 	module_put(flowtable->data.type->owner);
@@ -6211,14 +6259,15 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 				struct nft_flowtable *flowtable)
 {
-	int i;
+	struct nft_hook *hook;
 
-	for (i = 0; i < flowtable->ops_len; i++) {
-		if (flowtable->ops[i].dev != dev)
+	list_for_each_entry(hook, &flowtable->hook_list, list) {
+		if (hook->ops.dev != dev)
 			continue;
 
-		nf_unregister_net_hook(dev_net(dev), &flowtable->ops[i]);
-		flowtable->ops[i].dev = NULL;
+		nf_unregister_net_hook(dev_net(dev), &hook->ops);
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
 		break;
 	}
 }
-- 
2.11.0

