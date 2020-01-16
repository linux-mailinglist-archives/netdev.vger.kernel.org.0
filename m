Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B213F9F4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbgAPTvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:51:16 -0500
Received: from correo.us.es ([193.147.175.20]:56034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgAPTuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:50:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A0E0807E2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EFD18DA70E
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E5715DA70F; Thu, 16 Jan 2020 20:50:52 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C522CDA721;
        Thu, 16 Jan 2020 20:50:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 20:50:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9E76842EF9E1;
        Thu, 16 Jan 2020 20:50:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/9] netfilter: nf_tables: store transaction list locally while requesting module
Date:   Thu, 16 Jan 2020 20:50:38 +0100
Message-Id: <20200116195044.326614-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200116195044.326614-1-pablo@netfilter.org>
References: <20200116195044.326614-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a WARN_ON in nft_set_destroy() due to missing
set reference count drop from the preparation phase. This is triggered
by the module autoload path. Do not exercise the abort path from
nft_request_module() while preparation phase cleaning up is still
pending.

 WARNING: CPU: 3 PID: 3456 at net/netfilter/nf_tables_api.c:3740 nft_set_destroy+0x45/0x50 [nf_tables]
 [...]
 CPU: 3 PID: 3456 Comm: nft Not tainted 5.4.6-arch3-1 #1
 RIP: 0010:nft_set_destroy+0x45/0x50 [nf_tables]
 Code: e8 30 eb 83 c6 48 8b 85 80 00 00 00 48 8b b8 90 00 00 00 e8 dd 6b d7 c5 48 8b 7d 30 e8 24 dd eb c5 48 89 ef 5d e9 6b c6 e5 c5 <0f> 0b c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 7f 10 e9 52
 RSP: 0018:ffffac4f43e53700 EFLAGS: 00010202
 RAX: 0000000000000001 RBX: ffff99d63a154d80 RCX: 0000000001f88e03
 RDX: 0000000001f88c03 RSI: ffff99d6560ef0c0 RDI: ffff99d63a101200
 RBP: ffff99d617721de0 R08: 0000000000000000 R09: 0000000000000318
 R10: 00000000f0000000 R11: 0000000000000001 R12: ffffffff880fabf0
 R13: dead000000000122 R14: dead000000000100 R15: ffff99d63a154d80
 FS:  00007ff3dbd5b740(0000) GS:ffff99d6560c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00001cb5de6a9000 CR3: 000000016eb6a004 CR4: 00000000001606e0
 Call Trace:
  __nf_tables_abort+0x3e3/0x6d0 [nf_tables]
  nft_request_module+0x6f/0x110 [nf_tables]
  nft_expr_type_request_module+0x28/0x50 [nf_tables]
  nf_tables_expr_parse+0x198/0x1f0 [nf_tables]
  nft_expr_init+0x3b/0xf0 [nf_tables]
  nft_dynset_init+0x1e2/0x410 [nf_tables]
  nf_tables_newrule+0x30a/0x930 [nf_tables]
  nfnetlink_rcv_batch+0x2a0/0x640 [nfnetlink]
  nfnetlink_rcv+0x125/0x171 [nfnetlink]
  netlink_unicast+0x179/0x210
  netlink_sendmsg+0x208/0x3d0
  sock_sendmsg+0x5e/0x60
  ____sys_sendmsg+0x21b/0x290

Update comment on the code to describe the new behaviour.

Reported-by: Marco Oliverio <marco.oliverio@tanaza.com>
Fixes: 452238e8d5ff ("netfilter: nf_tables: add and use helper for module autoload")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 43f05b3acd60..168765d1d1c2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -564,23 +564,21 @@ __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 }
 
 /*
- * Loading a module requires dropping mutex that guards the
- * transaction.
- * We first need to abort any pending transactions as once
- * mutex is unlocked a different client could start a new
- * transaction.  It must not see any 'future generation'
- * changes * as these changes will never happen.
+ * Loading a module requires dropping mutex that guards the transaction.
+ * A different client might race to start a new transaction meanwhile. Zap the
+ * list of pending transaction and then restore it once the mutex is grabbed
+ * again. Users of this function return EAGAIN which implicitly triggers the
+ * transaction abort path to clean up the list of pending transactions.
  */
 #ifdef CONFIG_MODULES
-static int __nf_tables_abort(struct net *net);
-
 static void nft_request_module(struct net *net, const char *fmt, ...)
 {
 	char module_name[MODULE_NAME_LEN];
+	LIST_HEAD(commit_list);
 	va_list args;
 	int ret;
 
-	__nf_tables_abort(net);
+	list_splice_init(&net->nft.commit_list, &commit_list);
 
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
@@ -591,6 +589,9 @@ static void nft_request_module(struct net *net, const char *fmt, ...)
 	mutex_unlock(&net->nft.commit_mutex);
 	request_module("%s", module_name);
 	mutex_lock(&net->nft.commit_mutex);
+
+	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
+	list_splice(&commit_list, &net->nft.commit_list);
 }
 #endif
 
-- 
2.11.0

