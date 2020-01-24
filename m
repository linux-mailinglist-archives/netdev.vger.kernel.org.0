Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102DB148911
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392714AbgAXOcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbgAXOUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594A721569;
        Fri, 24 Jan 2020 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875602;
        bh=CIdKxlFvKsd/1KzZjemTt3oAGnuaPafxgd1NqrdNGVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wveZ7NHvPKMy9M3pJH9mph2xs+VYuQPblY8IwF1Wv9ul/HBAoKPWM8hUYY0tZvRpU
         HSI5NQvZ3IiuKpSO0p7U8/8v1q3I1wW49q+nYdbGMfXNh3JHTSzbxNG8ENXQ6id4QQ
         LQezcQtjQH+lMQwmrVf4jUcm7bKA4AQtoOwxdB1o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Marco Oliverio <marco.oliverio@tanaza.com>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 090/107] netfilter: nf_tables: store transaction list locally while requesting module
Date:   Fri, 24 Jan 2020 09:18:00 -0500
Message-Id: <20200124141817.28793-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ec7470b834fe7b5d7eff11b6677f5d7fdf5e9a91 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 67ca47c7ce542..b0cd1cee412b2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -500,23 +500,21 @@ __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
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
@@ -527,6 +525,9 @@ static void nft_request_module(struct net *net, const char *fmt, ...)
 	mutex_unlock(&net->nft.commit_mutex);
 	request_module("%s", module_name);
 	mutex_lock(&net->nft.commit_mutex);
+
+	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
+	list_splice(&commit_list, &net->nft.commit_list);
 }
 #endif
 
-- 
2.20.1

