Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD55917657F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 21:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCBU7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 15:59:01 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59282 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgCBU7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 15:59:00 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j8s9S-0000av-WA; Mon, 02 Mar 2020 21:58:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: free flowtable hooks on hook register error
Date:   Mon,  2 Mar 2020 21:58:50 +0100
Message-Id: <20200302205850.29365-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
need to be freed.

We can't change the goto label to 'goto 5' -- while it does fix the memleak
it does cause a warning splat from the netfilter core (the hooks were not
registered).

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Reported-by: syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d1318bdf49ca..bb064aa4154b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6300,8 +6300,13 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		goto err4;
 
 	err = nft_register_flowtable_net_hooks(ctx.net, table, flowtable);
-	if (err < 0)
+	if (err < 0) {
+		list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+			list_del_rcu(&hook->list);
+			kfree_rcu(hook, rcu);
+		}
 		goto err4;
+	}
 
 	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
 	if (err < 0)
-- 
2.24.1

