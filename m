Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35263553B9
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343902AbhDFMWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34434 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343982AbhDFMWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9F59463E59;
        Tue,  6 Apr 2021 14:21:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 20/28] netfilter: cttimeout: use net_generic infra
Date:   Tue,  6 Apr 2021 14:21:25 +0200
Message-Id: <20210406122133.1644-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

reduce size of struct net and make this self-contained.
The member in struct net is kept to minimize changes to struct net
layout, it will be removed in a separate patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 41 ++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index de831a257512..46da5548d0b3 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -20,6 +20,7 @@
 
 #include <linux/netfilter.h>
 #include <net/netlink.h>
+#include <net/netns/generic.h>
 #include <net/sock.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -30,6 +31,12 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
 
+static unsigned int nfct_timeout_id __read_mostly;
+
+struct nfct_timeout_pernet {
+	struct list_head	nfct_timeout_list;
+};
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_DESCRIPTION("cttimeout: Extended Netfilter Connection Tracking timeout tuning");
@@ -42,6 +49,11 @@ static const struct nla_policy cttimeout_nla_policy[CTA_TIMEOUT_MAX+1] = {
 	[CTA_TIMEOUT_DATA]	= { .type = NLA_NESTED },
 };
 
+static struct nfct_timeout_pernet *nfct_timeout_pernet(struct net *net)
+{
+	return net_generic(net, nfct_timeout_id);
+}
+
 static int
 ctnl_timeout_parse_policy(void *timeout,
 			  const struct nf_conntrack_l4proto *l4proto,
@@ -77,6 +89,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 				 const struct nlattr * const cda[],
 				 struct netlink_ext_ack *extack)
 {
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 	__u16 l3num;
 	__u8 l4num;
 	const struct nf_conntrack_l4proto *l4proto;
@@ -94,7 +107,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 	l3num = ntohs(nla_get_be16(cda[CTA_TIMEOUT_L3PROTO]));
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
 
-	list_for_each_entry(timeout, &net->nfct_timeout_list, head) {
+	list_for_each_entry(timeout, &pernet->nfct_timeout_list, head) {
 		if (strncmp(timeout->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
 
@@ -146,7 +159,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 	timeout->timeout.l3num = l3num;
 	timeout->timeout.l4proto = l4proto;
 	refcount_set(&timeout->refcnt, 1);
-	list_add_tail_rcu(&timeout->head, &net->nfct_timeout_list);
+	list_add_tail_rcu(&timeout->head, &pernet->nfct_timeout_list);
 
 	return 0;
 err:
@@ -201,6 +214,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 static int
 ctnl_timeout_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct nfct_timeout_pernet *pernet;
 	struct net *net = sock_net(skb->sk);
 	struct ctnl_timeout *cur, *last;
 
@@ -212,7 +226,8 @@ ctnl_timeout_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		cb->args[1] = 0;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &net->nfct_timeout_list, head) {
+	pernet = nfct_timeout_pernet(net);
+	list_for_each_entry_rcu(cur, &pernet->nfct_timeout_list, head) {
 		if (last) {
 			if (cur != last)
 				continue;
@@ -239,6 +254,7 @@ static int cttimeout_get_timeout(struct net *net, struct sock *ctnl,
 				 const struct nlattr * const cda[],
 				 struct netlink_ext_ack *extack)
 {
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 	int ret = -ENOENT;
 	char *name;
 	struct ctnl_timeout *cur;
@@ -254,7 +270,7 @@ static int cttimeout_get_timeout(struct net *net, struct sock *ctnl,
 		return -EINVAL;
 	name = nla_data(cda[CTA_TIMEOUT_NAME]);
 
-	list_for_each_entry(cur, &net->nfct_timeout_list, head) {
+	list_for_each_entry(cur, &pernet->nfct_timeout_list, head) {
 		struct sk_buff *skb2;
 
 		if (strncmp(cur->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
@@ -310,12 +326,13 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
 				 const struct nlattr * const cda[],
 				 struct netlink_ext_ack *extack)
 {
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 	struct ctnl_timeout *cur, *tmp;
 	int ret = -ENOENT;
 	char *name;
 
 	if (!cda[CTA_TIMEOUT_NAME]) {
-		list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list,
+		list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_list,
 					 head)
 			ctnl_timeout_try_del(net, cur);
 
@@ -323,7 +340,7 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
 	}
 	name = nla_data(cda[CTA_TIMEOUT_NAME]);
 
-	list_for_each_entry(cur, &net->nfct_timeout_list, head) {
+	list_for_each_entry(cur, &pernet->nfct_timeout_list, head) {
 		if (strncmp(cur->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
 
@@ -503,9 +520,10 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 static struct nf_ct_timeout *ctnl_timeout_find_get(struct net *net,
 						   const char *name)
 {
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 	struct ctnl_timeout *timeout, *matching = NULL;
 
-	list_for_each_entry_rcu(timeout, &net->nfct_timeout_list, head) {
+	list_for_each_entry_rcu(timeout, &pernet->nfct_timeout_list, head) {
 		if (strncmp(timeout->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
 
@@ -563,19 +581,22 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_TIMEOUT);
 
 static int __net_init cttimeout_net_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->nfct_timeout_list);
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
+
+	INIT_LIST_HEAD(&pernet->nfct_timeout_list);
 
 	return 0;
 }
 
 static void __net_exit cttimeout_net_exit(struct net *net)
 {
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 	struct ctnl_timeout *cur, *tmp;
 
 	nf_ct_unconfirmed_destroy(net);
 	nf_ct_untimeout(net, NULL);
 
-	list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list, head) {
+	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_list, head) {
 		list_del_rcu(&cur->head);
 
 		if (refcount_dec_and_test(&cur->refcnt))
@@ -586,6 +607,8 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 static struct pernet_operations cttimeout_ops = {
 	.init	= cttimeout_net_init,
 	.exit	= cttimeout_net_exit,
+	.id     = &nfct_timeout_id,
+	.size   = sizeof(struct nfct_timeout_pernet),
 };
 
 static int __init cttimeout_init(void)
-- 
2.30.2

