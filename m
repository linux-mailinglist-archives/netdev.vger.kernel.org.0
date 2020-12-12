Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09242D8A96
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408198AbgLLXJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:09:35 -0500
Received: from correo.us.es ([193.147.175.20]:46764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408156AbgLLXGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3577E303D17
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 230B2DA78F
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 181FFDA78B; Sun, 13 Dec 2020 00:05:12 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3F1EDA704;
        Sun, 13 Dec 2020 00:05:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 9C40B4265A5A;
        Sun, 13 Dec 2020 00:05:09 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/10] netfilter: nfnl_acct: remove data from struct net
Date:   Sun, 13 Dec 2020 00:05:07 +0100
Message-Id: <20201212230513.3465-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Shanker <shankerwangmiao@gmail.com>

This patch removes nfnl_acct_list from struct net to reduce the default
memory footprint for the netns structure.

Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/net_namespace.h    |  3 ---
 net/netfilter/nfnetlink_acct.c | 38 ++++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 22bc07f4b043..dc20a47e3828 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -151,9 +151,6 @@ struct net {
 #endif
 	struct sock		*nfnl;
 	struct sock		*nfnl_stash;
-#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_ACCT)
-	struct list_head        nfnl_acct_list;
-#endif
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
 	struct list_head	nfct_timeout_list;
 #endif
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 5e511df8d709..0fa1653b5f19 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <net/netlink.h>
 #include <net/sock.h>
+#include <net/netns/generic.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -41,6 +42,17 @@ struct nfacct_filter {
 	u32 mask;
 };
 
+struct nfnl_acct_net {
+	struct list_head        nfnl_acct_list;
+};
+
+static unsigned int nfnl_acct_net_id __read_mostly;
+
+static inline struct nfnl_acct_net *nfnl_acct_pernet(struct net *net)
+{
+	return net_generic(net, nfnl_acct_net_id);
+}
+
 #define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
 #define NFACCT_OVERQUOTA_BIT	2	/* NFACCT_F_OVERQUOTA */
 
@@ -49,6 +61,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 			 const struct nlattr * const tb[],
 			 struct netlink_ext_ack *extack)
 {
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
 	struct nf_acct *nfacct, *matching = NULL;
 	char *acct_name;
 	unsigned int size = 0;
@@ -61,7 +74,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 	if (strlen(acct_name) == 0)
 		return -EINVAL;
 
-	list_for_each_entry(nfacct, &net->nfnl_acct_list, head) {
+	list_for_each_entry(nfacct, &nfnl_acct_net->nfnl_acct_list, head) {
 		if (strncmp(nfacct->name, acct_name, NFACCT_NAME_MAX) != 0)
 			continue;
 
@@ -123,7 +136,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
 	refcount_set(&nfacct->refcnt, 1);
-	list_add_tail_rcu(&nfacct->head, &net->nfnl_acct_list);
+	list_add_tail_rcu(&nfacct->head, &nfnl_acct_net->nfnl_acct_list);
 	return 0;
 }
 
@@ -188,6 +201,7 @@ static int
 nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
 	struct nf_acct *cur, *last;
 	const struct nfacct_filter *filter = cb->data;
 
@@ -199,7 +213,7 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		cb->args[1] = 0;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry_rcu(cur, &nfnl_acct_net->nfnl_acct_list, head) {
 		if (last) {
 			if (cur != last)
 				continue;
@@ -269,6 +283,7 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 			 const struct nlattr * const tb[],
 			 struct netlink_ext_ack *extack)
 {
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
 	int ret = -ENOENT;
 	struct nf_acct *cur;
 	char *acct_name;
@@ -288,7 +303,7 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 		return -EINVAL;
 	acct_name = nla_data(tb[NFACCT_NAME]);
 
-	list_for_each_entry(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry(cur, &nfnl_acct_net->nfnl_acct_list, head) {
 		struct sk_buff *skb2;
 
 		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
@@ -342,19 +357,20 @@ static int nfnl_acct_del(struct net *net, struct sock *nfnl,
 			 const struct nlattr * const tb[],
 			 struct netlink_ext_ack *extack)
 {
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
 	struct nf_acct *cur, *tmp;
 	int ret = -ENOENT;
 	char *acct_name;
 
 	if (!tb[NFACCT_NAME]) {
-		list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head)
+		list_for_each_entry_safe(cur, tmp, &nfnl_acct_net->nfnl_acct_list, head)
 			nfnl_acct_try_del(cur);
 
 		return 0;
 	}
 	acct_name = nla_data(tb[NFACCT_NAME]);
 
-	list_for_each_entry(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry(cur, &nfnl_acct_net->nfnl_acct_list, head) {
 		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX) != 0)
 			continue;
 
@@ -402,10 +418,11 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ACCT);
 
 struct nf_acct *nfnl_acct_find_get(struct net *net, const char *acct_name)
 {
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
 	struct nf_acct *cur, *acct = NULL;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry_rcu(cur, &nfnl_acct_net->nfnl_acct_list, head) {
 		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
 			continue;
 
@@ -488,16 +505,17 @@ EXPORT_SYMBOL_GPL(nfnl_acct_overquota);
 
 static int __net_init nfnl_acct_net_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->nfnl_acct_list);
+	INIT_LIST_HEAD(&nfnl_acct_pernet(net)->nfnl_acct_list);
 
 	return 0;
 }
 
 static void __net_exit nfnl_acct_net_exit(struct net *net)
 {
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
 	struct nf_acct *cur, *tmp;
 
-	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
+	list_for_each_entry_safe(cur, tmp, &nfnl_acct_net->nfnl_acct_list, head) {
 		list_del_rcu(&cur->head);
 
 		if (refcount_dec_and_test(&cur->refcnt))
@@ -508,6 +526,8 @@ static void __net_exit nfnl_acct_net_exit(struct net *net)
 static struct pernet_operations nfnl_acct_ops = {
         .init   = nfnl_acct_net_init,
         .exit   = nfnl_acct_net_exit,
+        .id     = &nfnl_acct_net_id,
+        .size   = sizeof(struct nfnl_acct_net),
 };
 
 static int __init nfnl_acct_init(void)
-- 
2.20.1

