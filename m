Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E7417C52F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCFSPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:15:35 -0500
Received: from correo.us.es ([193.147.175.20]:40772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbgCFSPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3798915AEBB
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 292C6DA3AC
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1E86BDA3A8; Fri,  6 Mar 2020 19:15:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37433DA3C2;
        Fri,  6 Mar 2020 19:15:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0A2EF4301DE0;
        Fri,  6 Mar 2020 19:15:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/11] netfilter: nf_tables: free flowtable hooks on hook register error
Date:   Fri,  6 Mar 2020 19:15:07 +0100
Message-Id: <20200306181513.656594-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
need to be freed.

We can't change the goto label to 'goto 5' -- while it does fix the memleak
it does cause a warning splat from the netfilter core (the hooks were not
registered).

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Reported-by: syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

