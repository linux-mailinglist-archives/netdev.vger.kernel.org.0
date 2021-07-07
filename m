Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E733BEBF1
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhGGQVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:21:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55122 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhGGQVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:21:34 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C3F9062440;
        Wed,  7 Jul 2021 18:18:40 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 04/11] netfilter: conntrack: nf_ct_gre_keymap_flush() removal
Date:   Wed,  7 Jul 2021 18:18:37 +0200
Message-Id: <20210707161844.20827-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

nf_ct_gre_keymap_flush() is useless.
It is called from nf_conntrack_cleanup_net_list() only and tries to remove
nf_ct_gre_keymap entries from pernet gre keymap list. Though:
a) at this point the list should already be empty, all its entries were
deleted during the conntracks cleanup, because
nf_conntrack_cleanup_net_list() executes nf_ct_iterate_cleanup(kill_all)
before nf_conntrack_proto_pernet_fini():
 nf_conntrack_cleanup_net_list
  +- nf_ct_iterate_cleanup
  |   nf_ct_put
  |    nf_conntrack_put
  |     nf_conntrack_destroy
  |      destroy_conntrack
  |       destroy_gre_conntrack
  |        nf_ct_gre_keymap_destroy
  `- nf_conntrack_proto_pernet_fini
      nf_ct_gre_keymap_flush

b) Let's say we find that the keymap list is not empty. This means netns
still has a conntrack associated with gre, in which case we should not free
its memory, because this will lead to a double free and related crashes.
However I doubt it could have gone unnoticed for years, obviously
this does not happen in real life. So I think we can remove
both nf_ct_gre_keymap_flush() and nf_conntrack_proto_pernet_fini().

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h |  1 -
 net/netfilter/nf_conntrack_core.c         |  1 -
 net/netfilter/nf_conntrack_proto.c        |  7 -------
 net/netfilter/nf_conntrack_proto_gre.c    | 13 -------------
 4 files changed, 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 09f2efea0b97..13807ea94cd2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -30,7 +30,6 @@ void nf_conntrack_cleanup_net(struct net *net);
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list);
 
 void nf_conntrack_proto_pernet_init(struct net *net);
-void nf_conntrack_proto_pernet_fini(struct net *net);
 
 int nf_conntrack_proto_init(void);
 void nf_conntrack_proto_fini(void);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 96ba19fc8155..085a11f1eb43 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2457,7 +2457,6 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	}
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
-		nf_conntrack_proto_pernet_fini(net);
 		nf_conntrack_ecache_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
 		free_percpu(net->ct.stat);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 55647409a9be..8f7a9837349c 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -697,13 +697,6 @@ void nf_conntrack_proto_pernet_init(struct net *net)
 #endif
 }
 
-void nf_conntrack_proto_pernet_fini(struct net *net)
-{
-#ifdef CONFIG_NF_CT_PROTO_GRE
-	nf_ct_gre_keymap_flush(net);
-#endif
-}
-
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 		  &nf_conntrack_htable_size, 0600);
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index db11e403d818..728eeb0aea87 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -55,19 +55,6 @@ static inline struct nf_gre_net *gre_pernet(struct net *net)
 	return &net->ct.nf_ct_proto.gre;
 }
 
-void nf_ct_gre_keymap_flush(struct net *net)
-{
-	struct nf_gre_net *net_gre = gre_pernet(net);
-	struct nf_ct_gre_keymap *km, *tmp;
-
-	spin_lock_bh(&keymap_lock);
-	list_for_each_entry_safe(km, tmp, &net_gre->keymap_list, list) {
-		list_del_rcu(&km->list);
-		kfree_rcu(km, rcu);
-	}
-	spin_unlock_bh(&keymap_lock);
-}
-
 static inline int gre_key_cmpfn(const struct nf_ct_gre_keymap *km,
 				const struct nf_conntrack_tuple *t)
 {
-- 
2.20.1

