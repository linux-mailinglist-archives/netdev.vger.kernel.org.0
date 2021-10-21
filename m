Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F81E435EB0
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhJUKKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:10:47 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33826 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbhJUKKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:10:44 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AB90463F3C;
        Thu, 21 Oct 2021 12:06:45 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/8] netfilter: nf_tables: skip netdev events generated on netns removal
Date:   Thu, 21 Oct 2021 12:08:16 +0200
Message-Id: <20211021100821.964677-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211021100821.964677-1-pablo@netfilter.org>
References: <20211021100821.964677-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reported following (harmless) WARN:

 WARNING: CPU: 1 PID: 2648 at net/netfilter/core.c:468
  nft_netdev_unregister_hooks net/netfilter/nf_tables_api.c:230 [inline]
  nf_tables_unregister_hook include/net/netfilter/nf_tables.h:1090 [inline]
  __nft_release_basechain+0x138/0x640 net/netfilter/nf_tables_api.c:9524
  nft_netdev_event net/netfilter/nft_chain_filter.c:351 [inline]
  nf_tables_netdev_event+0x521/0x8a0 net/netfilter/nft_chain_filter.c:382

reproducer:
unshare -n bash -c 'ip link add br0 type bridge; nft add table netdev t ; \
 nft add chain netdev t ingress \{ type filter hook ingress device "br0" \
 priority 0\; policy drop\; \}'

Problem is that when netns device exit hooks create the UNREGISTER
event, the .pre_exit hook for nf_tables core has already removed the
base hook.  Notifier attempts to do this again.

The need to do base hook unregister unconditionally was needed in the past,
because notifier was last stage where reg->dev dereference was safe.

Now that nf_tables does the hook removal in .pre_exit, this isn't
needed anymore.

Reported-and-tested-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
Fixes: 767d1216bff825 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_chain_filter.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 5b02408a920b..3ced0eb6b7c3 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -342,12 +342,6 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		return;
 	}
 
-	/* UNREGISTER events are also happening on netns exit.
-	 *
-	 * Although nf_tables core releases all tables/chains, only this event
-	 * handler provides guarantee that hook->ops.dev is still accessible,
-	 * so we cannot skip exiting net namespaces.
-	 */
 	__nft_release_basechain(ctx);
 }
 
@@ -366,6 +360,9 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
+	if (!check_net(ctx.net))
+		return NOTIFY_DONE;
+
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-- 
2.30.2

