Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24C45A29C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfF1Rli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:41:38 -0400
Received: from mail.us.es ([193.147.175.20]:52742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfF1Rlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 13:41:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C6AB1B2B63
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:41:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C60A1021A6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:41:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 31F2A10219C; Fri, 28 Jun 2019 19:41:35 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A55F0DA708;
        Fri, 28 Jun 2019 19:41:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 19:41:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.195.66])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4D6874265A32;
        Fri, 28 Jun 2019 19:41:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/4] ipvs: defer hook registration to avoid leaks
Date:   Fri, 28 Jun 2019 19:41:22 +0200
Message-Id: <20190628174125.20739-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628174125.20739-1-pablo@netfilter.org>
References: <20190628174125.20739-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

syzkaller reports for memory leak when registering hooks [1]

As we moved the nf_unregister_net_hooks() call into
__ip_vs_dev_cleanup(), defer the nf_register_net_hooks()
call, so that hooks are allocated and freed from same
pernet_operations (ipvs_core_dev_ops).

[1]
BUG: memory leak
unreferenced object 0xffff88810acd8a80 (size 96):
 comm "syz-executor073", pid 7254, jiffies 4294950560 (age 22.250s)
 hex dump (first 32 bytes):
   02 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
   00 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
 backtrace:
   [<0000000013db61f1>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
   [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
   [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
   [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0 mm/slab.c:3597
   [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
   [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
   [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
   [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
   [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
   [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
   [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60 net/netfilter/core.c:61
   [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270 net/netfilter/core.c:128
   [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170 net/netfilter/core.c:337
   [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0 net/netfilter/core.c:464
   [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0 net/netfilter/core.c:480
   [<000000002ea868e0>] __ip_vs_init+0xe8/0x170 net/netfilter/ipvs/ip_vs_core.c:2280
   [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
   [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
   [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
   [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0 kernel/nsproxy.c:107
   [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
   [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150 kernel/fork.c:2035
   [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
   [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

Reported-by: syzbot+722da59ccb264bc19910@syzkaller.appspotmail.com
Fixes: 719c7d563c17 ("ipvs: Fix use-after-free in ip_vs_in")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 7138556b206b..d5103a9eb302 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2245,7 +2245,6 @@ static const struct nf_hook_ops ip_vs_ops[] = {
 static int __net_init __ip_vs_init(struct net *net)
 {
 	struct netns_ipvs *ipvs;
-	int ret;
 
 	ipvs = net_generic(net, ip_vs_net_id);
 	if (ipvs == NULL)
@@ -2277,17 +2276,11 @@ static int __net_init __ip_vs_init(struct net *net)
 	if (ip_vs_sync_net_init(ipvs) < 0)
 		goto sync_fail;
 
-	ret = nf_register_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
-	if (ret < 0)
-		goto hook_fail;
-
 	return 0;
 /*
  * Error handling
  */
 
-hook_fail:
-	ip_vs_sync_net_cleanup(ipvs);
 sync_fail:
 	ip_vs_conn_net_cleanup(ipvs);
 conn_fail:
@@ -2317,6 +2310,19 @@ static void __net_exit __ip_vs_cleanup(struct net *net)
 	net->ipvs = NULL;
 }
 
+static int __net_init __ip_vs_dev_init(struct net *net)
+{
+	int ret;
+
+	ret = nf_register_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
+	if (ret < 0)
+		goto hook_fail;
+	return 0;
+
+hook_fail:
+	return ret;
+}
+
 static void __net_exit __ip_vs_dev_cleanup(struct net *net)
 {
 	struct netns_ipvs *ipvs = net_ipvs(net);
@@ -2336,6 +2342,7 @@ static struct pernet_operations ipvs_core_ops = {
 };
 
 static struct pernet_operations ipvs_core_dev_ops = {
+	.init = __ip_vs_dev_init,
 	.exit = __ip_vs_dev_cleanup,
 };
 
-- 
2.11.0


