Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2687E14126
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfEEQjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEEQjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:42 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C26120B7C;
        Sun,  5 May 2019 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074381;
        bh=21pTRCLDyund9EF+uumu/pPtLQ/N4CA4IZ0cMNz8Zdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vhp5R6u+hI7V2etuq+829ggaPNOhoK5UBQ2kTaaMMWBj/dQi2YF8YfkILeib87PSZ
         VsODL9R0wbkLNf5i9ckhJJFGB6f144JQERhD+BQAo82Y4BeUlOP1fz5pYcD5tnmpLB
         d6XXTwUYRXKJ/a5YwIqZxjuRUf1qD5dFIIwmCli0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 4/7] ipv4: Add function to send route updates
Date:   Sun,  5 May 2019 09:40:53 -0700
Message-Id: <20190505164056.1742-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add fib_info_notify_update to walk the fib and send RTM_NEWROUTE
notifications with NLM_F_REPLACE set for entries linked to a fib_info
that have nh_updated flag set. This helper will be used by the nexthop
code to notify userspace of routes that are impacted when a nexthop
config is updated via replace. The new function and its helper are
similar to how fib_flush and fib_table_flush work for address delete
and link down events.

This notification is needed for legacy apps that do not understand
the new nexthop object. Apps that are nexthop aware can use the
RTA_NH_ID attribute in the route notification to just ignore it.

In the future this should be wrapped in a sysctl to allow OS'es that
are fully updated to avoid the notificaton storm.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h |  2 ++
 net/ipv4/fib_trie.c  | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index d0e28f4ab099..ec6496c08f48 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -150,6 +150,7 @@ struct fib_info {
 #define fib_advmss fib_metrics->metrics[RTAX_ADVMSS-1]
 	int			fib_nhs;
 	bool			fib_nh_is_v6;
+	bool			nh_updated;
 	struct rcu_head		rcu;
 	struct fib_nh		fib_nh[0];
 #define fib_dev		fib_nh[0].fib_nh_dev
@@ -231,6 +232,7 @@ int call_fib4_notifiers(struct net *net, enum fib_event_type event_type,
 int __net_init fib4_notifier_init(struct net *net);
 void __net_exit fib4_notifier_exit(struct net *net);
 
+void fib_info_notify_update(struct net *net, struct nl_info *info);
 void fib_notify(struct net *net, struct notifier_block *nb);
 
 struct fib_table {
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 334f723bdf80..ea7df7ebf597 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1943,6 +1943,78 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 	return found;
 }
 
+/* derived from fib_trie_free */
+static void __fib_info_notify_update(struct net *net, struct fib_table *tb,
+				     struct nl_info *info)
+{
+	struct trie *t = (struct trie *)tb->tb_data;
+	struct key_vector *pn = t->kv;
+	unsigned long cindex = 1;
+	struct fib_alias *fa;
+
+	for (;;) {
+		struct key_vector *n;
+
+		if (!(cindex--)) {
+			t_key pkey = pn->key;
+
+			if (IS_TRIE(pn))
+				break;
+
+			n = pn;
+			pn = node_parent(pn);
+			cindex = get_index(pkey, pn);
+			continue;
+		}
+
+		/* grab the next available node */
+		n = get_child(pn, cindex);
+		if (!n)
+			continue;
+
+		if (IS_TNODE(n)) {
+			/* record pn and cindex for leaf walking */
+			pn = n;
+			cindex = 1ul << n->bits;
+
+			continue;
+		}
+
+		hlist_for_each_entry(fa, &n->leaf, fa_list) {
+			struct fib_info *fi = fa->fa_info;
+
+			if (!fi || !fi->nh_updated || fa->tb_id != tb->tb_id)
+				continue;
+
+			rtmsg_fib(RTM_NEWROUTE, htonl(n->key), fa,
+				  KEYLENGTH - fa->fa_slen, tb->tb_id,
+				  info, NLM_F_REPLACE);
+
+			/* call_fib_entry_notifiers will be removed when
+			 * in-kernel notifier is implemented and supported
+			 * for nexthop objects
+			 */
+			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE,
+						 n->key,
+						 KEYLENGTH - fa->fa_slen, fa,
+						 NULL);
+		}
+	}
+}
+
+void fib_info_notify_update(struct net *net, struct nl_info *info)
+{
+	unsigned int h;
+
+	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
+		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
+		struct fib_table *tb;
+
+		hlist_for_each_entry_rcu(tb, head, tb_hlist)
+			__fib_info_notify_update(net, tb, info);
+	}
+}
+
 static void fib_leaf_notify(struct net *net, struct key_vector *l,
 			    struct fib_table *tb, struct notifier_block *nb)
 {
-- 
2.11.0

