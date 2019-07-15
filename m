Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C30869556
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390769AbfGOOXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390118AbfGOOXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:23:31 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 427C52053B;
        Mon, 15 Jul 2019 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200609;
        bh=4/m/2Mfax+c7i6Z3CxWlTyE2IYQ4BoDrA/ah/vbuP70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9Kph1UeimZKnpWuhQIYpFfJw5Ka5mn8e2Y7OfSVbcrxHWnPxKnTXR5EnBx9/zCiY
         bkfxF9GFcrKz3lowMDdr4XTUW5kv8lWSD5srGndceq4FBtNZv4Kyu1eaAxIZxRLeBO
         D0ui/GDSA7GqdmFgscYPnps6Y4kkxM/N8NSxp0p0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        syzbot+722da59ccb264bc19910@syzkaller.appspotmail.com,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH AUTOSEL 4.19 091/158] ipvs: defer hook registration to avoid leaks
Date:   Mon, 15 Jul 2019 10:17:02 -0400
Message-Id: <20190715141809.8445-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit cf47a0b882a4e5f6b34c7949d7b293e9287f1972 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 62c0e80dcd71..a71f777d1353 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2218,7 +2218,6 @@ static const struct nf_hook_ops ip_vs_ops[] = {
 static int __net_init __ip_vs_init(struct net *net)
 {
 	struct netns_ipvs *ipvs;
-	int ret;
 
 	ipvs = net_generic(net, ip_vs_net_id);
 	if (ipvs == NULL)
@@ -2250,17 +2249,11 @@ static int __net_init __ip_vs_init(struct net *net)
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
@@ -2290,6 +2283,19 @@ static void __net_exit __ip_vs_cleanup(struct net *net)
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
@@ -2309,6 +2315,7 @@ static struct pernet_operations ipvs_core_ops = {
 };
 
 static struct pernet_operations ipvs_core_dev_ops = {
+	.init = __ip_vs_dev_init,
 	.exit = __ip_vs_dev_cleanup,
 };
 
-- 
2.20.1

