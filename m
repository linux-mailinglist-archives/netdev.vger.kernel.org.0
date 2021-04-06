Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B3E3553C3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344206AbhDFMXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34470 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343986AbhDFMWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:05 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2C58163E5D;
        Tue,  6 Apr 2021 14:21:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 21/28] netfilter: nf_defrag_ipv6: use net_generic infra
Date:   Tue,  6 Apr 2021 14:21:26 +0200
Message-Id: <20210406122133.1644-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This allows followup patch to remove these members from struct net.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |  6 ++
 net/ipv6/netfilter/nf_conntrack_reasm.c     | 68 +++++++++++----------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   | 15 +++--
 3 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index 6d31cd041143..ece923e2035b 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -13,4 +13,10 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user);
 
 struct inet_frags_ctl;
 
+struct nft_ct_frag6_pernet {
+	struct ctl_table_header *nf_frag_frags_hdr;
+	struct fqdir	*fqdir;
+	unsigned int users;
+};
+
 #endif /* _NF_DEFRAG_IPV6_H */
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index c129ad334eb3..a0108415275f 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -15,28 +15,13 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#include <linux/socket.h>
-#include <linux/sockios.h>
-#include <linux/jiffies.h>
 #include <linux/net.h>
-#include <linux/list.h>
 #include <linux/netdevice.h>
-#include <linux/in6.h>
 #include <linux/ipv6.h>
-#include <linux/icmpv6.h>
-#include <linux/random.h>
 #include <linux/slab.h>
 
-#include <net/sock.h>
-#include <net/snmp.h>
 #include <net/ipv6_frag.h>
 
-#include <net/protocol.h>
-#include <net/transp_v6.h>
-#include <net/rawv6.h>
-#include <net/ndisc.h>
-#include <net/addrconf.h>
-#include <net/inet_ecn.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 #include <linux/sysctl.h>
 #include <linux/netfilter.h>
@@ -44,11 +29,18 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/netns/generic.h>
 
 static const char nf_frags_cache_name[] = "nf-frags";
 
+unsigned int nf_frag_pernet_id __read_mostly;
 static struct inet_frags nf_frags;
 
+static struct nft_ct_frag6_pernet *nf_frag_pernet(struct net *net)
+{
+	return net_generic(net, nf_frag_pernet_id);
+}
+
 #ifdef CONFIG_SYSCTL
 
 static struct ctl_table nf_ct_frag6_sysctl_table[] = {
@@ -75,6 +67,7 @@ static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 
 static int nf_ct_frag6_sysctl_register(struct net *net)
 {
+	struct nft_ct_frag6_pernet *nf_frag;
 	struct ctl_table *table;
 	struct ctl_table_header *hdr;
 
@@ -86,18 +79,20 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 			goto err_alloc;
 	}
 
-	table[0].data	= &net->nf_frag.fqdir->timeout;
-	table[1].data	= &net->nf_frag.fqdir->low_thresh;
-	table[1].extra2	= &net->nf_frag.fqdir->high_thresh;
-	table[2].data	= &net->nf_frag.fqdir->high_thresh;
-	table[2].extra1	= &net->nf_frag.fqdir->low_thresh;
-	table[2].extra2	= &init_net.nf_frag.fqdir->high_thresh;
+	nf_frag = nf_frag_pernet(net);
+
+	table[0].data	= &nf_frag->fqdir->timeout;
+	table[1].data	= &nf_frag->fqdir->low_thresh;
+	table[1].extra2	= &nf_frag->fqdir->high_thresh;
+	table[2].data	= &nf_frag->fqdir->high_thresh;
+	table[2].extra1	= &nf_frag->fqdir->low_thresh;
+	table[2].extra2	= &nf_frag->fqdir->high_thresh;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
 		goto err_reg;
 
-	net->nf_frag_frags_hdr = hdr;
+	nf_frag->nf_frag_frags_hdr = hdr;
 	return 0;
 
 err_reg:
@@ -109,10 +104,11 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 
 static void __net_exit nf_ct_frags6_sysctl_unregister(struct net *net)
 {
+	struct nft_ct_frag6_pernet *nf_frag = nf_frag_pernet(net);
 	struct ctl_table *table;
 
-	table = net->nf_frag_frags_hdr->ctl_table_arg;
-	unregister_net_sysctl_table(net->nf_frag_frags_hdr);
+	table = nf_frag->nf_frag_frags_hdr->ctl_table_arg;
+	unregister_net_sysctl_table(nf_frag->nf_frag_frags_hdr);
 	if (!net_eq(net, &init_net))
 		kfree(table);
 }
@@ -149,6 +145,7 @@ static void nf_ct_frag6_expire(struct timer_list *t)
 static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 				  const struct ipv6hdr *hdr, int iif)
 {
+	struct nft_ct_frag6_pernet *nf_frag = nf_frag_pernet(net);
 	struct frag_v6_compare_key key = {
 		.id = id,
 		.saddr = hdr->saddr,
@@ -158,7 +155,7 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 	};
 	struct inet_frag_queue *q;
 
-	q = inet_frag_find(net->nf_frag.fqdir, &key);
+	q = inet_frag_find(nf_frag->fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -495,37 +492,44 @@ EXPORT_SYMBOL_GPL(nf_ct_frag6_gather);
 
 static int nf_ct_net_init(struct net *net)
 {
+	struct nft_ct_frag6_pernet *nf_frag  = nf_frag_pernet(net);
 	int res;
 
-	res = fqdir_init(&net->nf_frag.fqdir, &nf_frags, net);
+	res = fqdir_init(&nf_frag->fqdir, &nf_frags, net);
 	if (res < 0)
 		return res;
 
-	net->nf_frag.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->nf_frag.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
-	net->nf_frag.fqdir->timeout = IPV6_FRAG_TIMEOUT;
+	nf_frag->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
+	nf_frag->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
+	nf_frag->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = nf_ct_frag6_sysctl_register(net);
 	if (res < 0)
-		fqdir_exit(net->nf_frag.fqdir);
+		fqdir_exit(nf_frag->fqdir);
 	return res;
 }
 
 static void nf_ct_net_pre_exit(struct net *net)
 {
-	fqdir_pre_exit(net->nf_frag.fqdir);
+	struct nft_ct_frag6_pernet *nf_frag  = nf_frag_pernet(net);
+
+	fqdir_pre_exit(nf_frag->fqdir);
 }
 
 static void nf_ct_net_exit(struct net *net)
 {
+	struct nft_ct_frag6_pernet *nf_frag  = nf_frag_pernet(net);
+
 	nf_ct_frags6_sysctl_unregister(net);
-	fqdir_exit(net->nf_frag.fqdir);
+	fqdir_exit(nf_frag->fqdir);
 }
 
 static struct pernet_operations nf_ct_net_ops = {
 	.init		= nf_ct_net_init,
 	.pre_exit	= nf_ct_net_pre_exit,
 	.exit		= nf_ct_net_exit,
+	.id		= &nf_frag_pernet_id,
+	.size		= sizeof(struct nft_ct_frag6_pernet),
 };
 
 static const struct rhashtable_params nfct_rhash_params = {
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 6646a87fb5dc..402dc4ca9504 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -25,6 +25,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 
+extern unsigned int nf_frag_pernet_id;
+
 static DEFINE_MUTEX(defrag6_mutex);
 
 static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
@@ -89,10 +91,12 @@ static const struct nf_hook_ops ipv6_defrag_ops[] = {
 
 static void __net_exit defrag6_net_exit(struct net *net)
 {
-	if (net->nf.defrag_ipv6) {
+	struct nft_ct_frag6_pernet *nf_frag = net_generic(net, nf_frag_pernet_id);
+
+	if (nf_frag->users) {
 		nf_unregister_net_hooks(net, ipv6_defrag_ops,
 					ARRAY_SIZE(ipv6_defrag_ops));
-		net->nf.defrag_ipv6 = false;
+		nf_frag->users = 0;
 	}
 }
 
@@ -130,21 +134,22 @@ static void __exit nf_defrag_fini(void)
 
 int nf_defrag_ipv6_enable(struct net *net)
 {
+	struct nft_ct_frag6_pernet *nf_frag = net_generic(net, nf_frag_pernet_id);
 	int err = 0;
 
 	might_sleep();
 
-	if (net->nf.defrag_ipv6)
+	if (nf_frag->users)
 		return 0;
 
 	mutex_lock(&defrag6_mutex);
-	if (net->nf.defrag_ipv6)
+	if (nf_frag->users)
 		goto out_unlock;
 
 	err = nf_register_net_hooks(net, ipv6_defrag_ops,
 				    ARRAY_SIZE(ipv6_defrag_ops));
 	if (err == 0)
-		net->nf.defrag_ipv6 = true;
+		nf_frag->users = 1;
 
  out_unlock:
 	mutex_unlock(&defrag6_mutex);
-- 
2.30.2

