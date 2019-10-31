Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C637EAFA6
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfJaLzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:55:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55282 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfJaLzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:55:06 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iQ92U-0002qQ-EA; Thu, 31 Oct 2019 12:54:54 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 0F2C61C0070;
        Thu, 31 Oct 2019 12:54:54 +0100 (CET)
Date:   Thu, 31 Oct 2019 11:54:53 -0000
From:   "tip-bot2 for Paul E. McKenney" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] net/netfilter: Replace rcu_swap_protected() with
 rcu_replace_pointer()
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <157252289377.29376.5021804327399438080.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the core/rcu branch of tip:

Commit-ID:     b685b534bf1586a01b32280d1da39febaf270039
Gitweb:        https://git.kernel.org/tip/b685b534bf1586a01b32280d1da39febaf270039
Author:        Paul E. McKenney <paulmck@kernel.org>
AuthorDate:    Mon, 23 Sep 2019 15:53:02 -07:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Wed, 30 Oct 2019 08:45:38 -07:00

net/netfilter: Replace rcu_swap_protected() with rcu_replace_pointer()

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace_pointer() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
[ paulmck: From rcu_replace() to rcu_replace_pointer() per Ingo Molnar. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netfilter-devel@vger.kernel.org>
Cc: <coreteam@netfilter.org>
Cc: <netdev@vger.kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d481f9b..3379974 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1461,8 +1461,9 @@ static void nft_chain_stats_replace(struct nft_trans *trans)
 	if (!nft_trans_chain_stats(trans))
 		return;
 
-	rcu_swap_protected(chain->stats, nft_trans_chain_stats(trans),
-			   lockdep_commit_lock_is_held(trans->ctx.net));
+	nft_trans_chain_stats(trans) =
+		rcu_replace_pointer(chain->stats, nft_trans_chain_stats(trans),
+				    lockdep_commit_lock_is_held(trans->ctx.net));
 
 	if (!nft_trans_chain_stats(trans))
 		static_branch_inc(&nft_counters_enabled);
