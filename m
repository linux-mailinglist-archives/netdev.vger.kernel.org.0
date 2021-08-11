Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB8F3E8C66
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbhHKIts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:49:48 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44060 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236365AbhHKIto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:49:44 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 83AD660066;
        Wed, 11 Aug 2021 10:48:37 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/10] netfilter: ebtables: do not hook tables by default
Date:   Wed, 11 Aug 2021 10:49:04 +0200
Message-Id: <20210811084908.14744-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210811084908.14744-1-pablo@netfilter.org>
References: <20210811084908.14744-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

If any of these modules is loaded, hooks get registered in all netns:

Before: 'unshare -n nft list hooks' shows:
family bridge hook prerouting {
	-2147483648 ebt_broute
	-0000000300 ebt_nat_hook
}
family bridge hook input {
	-0000000200 ebt_filter_hook
}
family bridge hook forward {
	-0000000200 ebt_filter_hook
}
family bridge hook output {
	+0000000100 ebt_nat_hook
	+0000000200 ebt_filter_hook
}
family bridge hook postrouting {
	+0000000300 ebt_nat_hook
}

This adds 'template 'tables' for ebtables.

Each ebtable_foo registers the table as a template, with an init function
that gets called once the first get/setsockopt call is made.

ebtables core then searches the (per netns) list of tables.
If no table is found, it searches the list of templates instead.
If a template entry exists, the init function is called which will
enable the table and register the hooks (so packets are diverted
to the table).

If no entry is found in the template list, request_module is called.

After this, hook registration is delayed until the 'ebtables'
(set/getsockopt) request is made for a given table and will only
happen in the specific namespace.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge/ebtables.h |   2 +
 net/bridge/netfilter/ebtable_broute.c     |  17 +++-
 net/bridge/netfilter/ebtable_filter.c     |  17 +++-
 net/bridge/netfilter/ebtable_nat.c        |  17 +++-
 net/bridge/netfilter/ebtables.c           | 109 +++++++++++++++++++---
 5 files changed, 139 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index a8178253ce53..10a01978bc0d 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -127,4 +127,6 @@ static inline bool ebt_invalid_target(int target)
 	return (target < -NUM_STANDARD_TARGETS || target >= 0);
 }
 
+int ebt_register_template(const struct ebt_table *t, int(*table_init)(struct net *net));
+void ebt_unregister_template(const struct ebt_table *t);
 #endif
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 020b1487ee0c..a7af4eaff17d 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -98,7 +98,7 @@ static const struct nf_hook_ops ebt_ops_broute = {
 	.priority	= NF_BR_PRI_FIRST,
 };
 
-static int __net_init broute_net_init(struct net *net)
+static int broute_table_init(struct net *net)
 {
 	return ebt_register_table(net, &broute_table, &ebt_ops_broute);
 }
@@ -114,19 +114,30 @@ static void __net_exit broute_net_exit(struct net *net)
 }
 
 static struct pernet_operations broute_net_ops = {
-	.init = broute_net_init,
 	.exit = broute_net_exit,
 	.pre_exit = broute_net_pre_exit,
 };
 
 static int __init ebtable_broute_init(void)
 {
-	return register_pernet_subsys(&broute_net_ops);
+	int ret = ebt_register_template(&broute_table, broute_table_init);
+
+	if (ret)
+		return ret;
+
+	ret = register_pernet_subsys(&broute_net_ops);
+	if (ret) {
+		ebt_unregister_template(&broute_table);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit ebtable_broute_fini(void)
 {
 	unregister_pernet_subsys(&broute_net_ops);
+	ebt_unregister_template(&broute_table);
 }
 
 module_init(ebtable_broute_init);
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 8ec0b3736803..c0b121df4a9a 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -86,7 +86,7 @@ static const struct nf_hook_ops ebt_ops_filter[] = {
 	},
 };
 
-static int __net_init frame_filter_net_init(struct net *net)
+static int frame_filter_table_init(struct net *net)
 {
 	return ebt_register_table(net, &frame_filter, ebt_ops_filter);
 }
@@ -102,19 +102,30 @@ static void __net_exit frame_filter_net_exit(struct net *net)
 }
 
 static struct pernet_operations frame_filter_net_ops = {
-	.init = frame_filter_net_init,
 	.exit = frame_filter_net_exit,
 	.pre_exit = frame_filter_net_pre_exit,
 };
 
 static int __init ebtable_filter_init(void)
 {
-	return register_pernet_subsys(&frame_filter_net_ops);
+	int ret = ebt_register_template(&frame_filter, frame_filter_table_init);
+
+	if (ret)
+		return ret;
+
+	ret = register_pernet_subsys(&frame_filter_net_ops);
+	if (ret) {
+		ebt_unregister_template(&frame_filter);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit ebtable_filter_fini(void)
 {
 	unregister_pernet_subsys(&frame_filter_net_ops);
+	ebt_unregister_template(&frame_filter);
 }
 
 module_init(ebtable_filter_init);
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 7c8a1064a531..4078151c224f 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -85,7 +85,7 @@ static const struct nf_hook_ops ebt_ops_nat[] = {
 	},
 };
 
-static int __net_init frame_nat_net_init(struct net *net)
+static int frame_nat_table_init(struct net *net)
 {
 	return ebt_register_table(net, &frame_nat, ebt_ops_nat);
 }
@@ -101,19 +101,30 @@ static void __net_exit frame_nat_net_exit(struct net *net)
 }
 
 static struct pernet_operations frame_nat_net_ops = {
-	.init = frame_nat_net_init,
 	.exit = frame_nat_net_exit,
 	.pre_exit = frame_nat_net_pre_exit,
 };
 
 static int __init ebtable_nat_init(void)
 {
-	return register_pernet_subsys(&frame_nat_net_ops);
+	int ret = ebt_register_template(&frame_nat, frame_nat_table_init);
+
+	if (ret)
+		return ret;
+
+	ret = register_pernet_subsys(&frame_nat_net_ops);
+	if (ret) {
+		ebt_unregister_template(&frame_nat);
+		return ret;
+	}
+
+	return ret;
 }
 
 static void __exit ebtable_nat_fini(void)
 {
 	unregister_pernet_subsys(&frame_nat_net_ops);
+	ebt_unregister_template(&frame_nat);
 }
 
 module_init(ebtable_nat_init);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f022deb3721e..83d1798dfbb4 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -44,7 +44,16 @@ struct ebt_pernet {
 	struct list_head tables;
 };
 
+struct ebt_template {
+	struct list_head list;
+	char name[EBT_TABLE_MAXNAMELEN];
+	struct module *owner;
+	/* called when table is needed in the given netns */
+	int (*table_init)(struct net *net);
+};
+
 static unsigned int ebt_pernet_id __read_mostly;
+static LIST_HEAD(template_tables);
 static DEFINE_MUTEX(ebt_mutex);
 
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
@@ -309,30 +318,57 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 
 /* If it succeeds, returns element and locks mutex */
 static inline void *
-find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
+find_inlist_lock_noload(struct net *net, const char *name, int *error,
 			struct mutex *mutex)
 {
-	struct {
-		struct list_head list;
-		char name[EBT_FUNCTION_MAXNAMELEN];
-	} *e;
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
+	struct ebt_template *tmpl;
+	struct ebt_table *table;
 
 	mutex_lock(mutex);
-	list_for_each_entry(e, head, list) {
-		if (strcmp(e->name, name) == 0)
-			return e;
+	list_for_each_entry(table, &ebt_net->tables, list) {
+		if (strcmp(table->name, name) == 0)
+			return table;
 	}
+
+	list_for_each_entry(tmpl, &template_tables, list) {
+		if (strcmp(name, tmpl->name) == 0) {
+			struct module *owner = tmpl->owner;
+
+			if (!try_module_get(owner))
+				goto out;
+
+			mutex_unlock(mutex);
+
+			*error = tmpl->table_init(net);
+			if (*error) {
+				module_put(owner);
+				return NULL;
+			}
+
+			mutex_lock(mutex);
+			module_put(owner);
+			break;
+		}
+	}
+
+	list_for_each_entry(table, &ebt_net->tables, list) {
+		if (strcmp(table->name, name) == 0)
+			return table;
+	}
+
+out:
 	*error = -ENOENT;
 	mutex_unlock(mutex);
 	return NULL;
 }
 
 static void *
-find_inlist_lock(struct list_head *head, const char *name, const char *prefix,
+find_inlist_lock(struct net *net, const char *name, const char *prefix,
 		 int *error, struct mutex *mutex)
 {
 	return try_then_request_module(
-			find_inlist_lock_noload(head, name, error, mutex),
+			find_inlist_lock_noload(net, name, error, mutex),
 			"%s%s", prefix, name);
 }
 
@@ -340,10 +376,7 @@ static inline struct ebt_table *
 find_table_lock(struct net *net, const char *name, int *error,
 		struct mutex *mutex)
 {
-	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
-
-	return find_inlist_lock(&ebt_net->tables, name,
-				"ebtable_", error, mutex);
+	return find_inlist_lock(net, name, "ebtable_", error, mutex);
 }
 
 static inline void ebt_free_table_info(struct ebt_table_info *info)
@@ -1258,6 +1291,54 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	return ret;
 }
 
+int ebt_register_template(const struct ebt_table *t, int (*table_init)(struct net *net))
+{
+	struct ebt_template *tmpl;
+
+	mutex_lock(&ebt_mutex);
+	list_for_each_entry(tmpl, &template_tables, list) {
+		if (WARN_ON_ONCE(strcmp(t->name, tmpl->name) == 0)) {
+			mutex_unlock(&ebt_mutex);
+			return -EEXIST;
+		}
+	}
+
+	tmpl = kzalloc(sizeof(*tmpl), GFP_KERNEL);
+	if (!tmpl) {
+		mutex_unlock(&ebt_mutex);
+		return -ENOMEM;
+	}
+
+	tmpl->table_init = table_init;
+	strscpy(tmpl->name, t->name, sizeof(tmpl->name));
+	tmpl->owner = t->me;
+	list_add(&tmpl->list, &template_tables);
+
+	mutex_unlock(&ebt_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(ebt_register_template);
+
+void ebt_unregister_template(const struct ebt_table *t)
+{
+	struct ebt_template *tmpl;
+
+	mutex_lock(&ebt_mutex);
+	list_for_each_entry(tmpl, &template_tables, list) {
+		if (strcmp(t->name, tmpl->name))
+			continue;
+
+		list_del(&tmpl->list);
+		mutex_unlock(&ebt_mutex);
+		kfree(tmpl);
+		return;
+	}
+
+	mutex_unlock(&ebt_mutex);
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL(ebt_unregister_template);
+
 static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
 {
 	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
-- 
2.20.1

