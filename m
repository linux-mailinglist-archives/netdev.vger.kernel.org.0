Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7A53769A0
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhEGRsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:48:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49098 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhEGRsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:48:47 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 73EF764150;
        Fri,  7 May 2021 19:47:00 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/8] netfilter: arptables: use pernet ops struct during unregister
Date:   Fri,  7 May 2021 19:47:33 +0200
Message-Id: <20210507174739.1850-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507174739.1850-1-pablo@netfilter.org>
References: <20210507174739.1850-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Like with iptables and ebtables, hook unregistration has to use the
pernet ops struct, not the template.

This triggered following splat:
  hook not found, pf 3 num 0
  WARNING: CPU: 0 PID: 224 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
[..]
 nf_unregister_net_hook net/netfilter/core.c:502 [inline]
 nf_unregister_net_hooks+0x117/0x160 net/netfilter/core.c:576
 arpt_unregister_table_pre_exit+0x67/0x80 net/ipv4/netfilter/arp_tables.c:1565

Fixes: f9006acc8dfe5 ("netfilter: arp_tables: pass table pointer via nf_hook_ops")
Reported-by: syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_arp/arp_tables.h | 3 +--
 net/ipv4/netfilter/arp_tables.c          | 5 ++---
 net/ipv4/netfilter/arptable_filter.c     | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 2aab9612f6ab..4f9a4b3c5892 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -53,8 +53,7 @@ int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops);
 void arpt_unregister_table(struct net *net, const char *name);
-void arpt_unregister_table_pre_exit(struct net *net, const char *name,
-				    const struct nf_hook_ops *ops);
+void arpt_unregister_table_pre_exit(struct net *net, const char *name);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index cf20316094d0..c53f14b94356 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1556,13 +1556,12 @@ int arpt_register_table(struct net *net,
 	return ret;
 }
 
-void arpt_unregister_table_pre_exit(struct net *net, const char *name,
-				    const struct nf_hook_ops *ops)
+void arpt_unregister_table_pre_exit(struct net *net, const char *name)
 {
 	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
 
 	if (table)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }
 EXPORT_SYMBOL(arpt_unregister_table_pre_exit);
 
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index b8f45e9bbec8..6922612df456 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -54,7 +54,7 @@ static int __net_init arptable_filter_table_init(struct net *net)
 
 static void __net_exit arptable_filter_net_pre_exit(struct net *net)
 {
-	arpt_unregister_table_pre_exit(net, "filter", arpfilter_ops);
+	arpt_unregister_table_pre_exit(net, "filter");
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
-- 
2.30.2

