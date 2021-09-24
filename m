Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6370A417DA4
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345792AbhIXWNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49790 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345222AbhIXWNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:13:00 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id A301663EA7;
        Sat, 25 Sep 2021 00:10:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 09/15] netfilter: nf_tables: unlink table before deleting it
Date:   Sat, 25 Sep 2021 00:11:07 +0200
Message-Id: <20210924221113.348767-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reports following UAF:
BUG: KASAN: use-after-free in memcmp+0x18f/0x1c0 lib/string.c:955
 nla_strcmp+0xf2/0x130 lib/nlattr.c:836
 nft_table_lookup.part.0+0x1a2/0x460 net/netfilter/nf_tables_api.c:570
 nft_table_lookup net/netfilter/nf_tables_api.c:4064 [inline]
 nf_tables_getset+0x1b3/0x860 net/netfilter/nf_tables_api.c:4064
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504

Problem is that all get operations are lockless, so the commit_mutex
held by nft_rcv_nl_event() isn't enough to stop a parallel GET request
from doing read-accesses to the table object even after synchronize_rcu().

To avoid this, unlink the table first and store the table objects in
on-stack scratch space.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Reported-and-tested-by: syzbot+f31660cf279b0557160c@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 081437dd75b7..33e771cd847c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9599,7 +9599,6 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		table->use--;
 		nf_tables_chain_destroy(&ctx);
 	}
-	list_del(&table->list);
 	nf_tables_table_destroy(&ctx);
 }
 
@@ -9612,6 +9611,8 @@ static void __nft_release_tables(struct net *net)
 		if (nft_table_has_owner(table))
 			continue;
 
+		list_del(&table->list);
+
 		__nft_release_table(net, table);
 	}
 }
@@ -9619,31 +9620,38 @@ static void __nft_release_tables(struct net *net)
 static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
+	struct nft_table *table, *to_delete[8];
 	struct nftables_pernet *nft_net;
 	struct netlink_notify *n = ptr;
-	struct nft_table *table, *nt;
 	struct net *net = n->net;
-	bool release = false;
+	unsigned int deleted;
+	bool restart = false;
 
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(net);
+	deleted = 0;
 	mutex_lock(&nft_net->commit_mutex);
+again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
 		    n->portid == table->nlpid) {
 			__nft_release_hook(net, table);
-			release = true;
+			list_del_rcu(&table->list);
+			to_delete[deleted++] = table;
+			if (deleted >= ARRAY_SIZE(to_delete))
+				break;
 		}
 	}
-	if (release) {
+	if (deleted) {
+		restart = deleted >= ARRAY_SIZE(to_delete);
 		synchronize_rcu();
-		list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
-			if (nft_table_has_owner(table) &&
-			    n->portid == table->nlpid)
-				__nft_release_table(net, table);
-		}
+		while (deleted)
+			__nft_release_table(net, to_delete[--deleted]);
+
+		if (restart)
+			goto again;
 	}
 	mutex_unlock(&nft_net->commit_mutex);
 
-- 
2.30.2

