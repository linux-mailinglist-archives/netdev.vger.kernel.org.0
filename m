Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC91B35C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfEMJ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:56:45 -0400
Received: from mail.us.es ([193.147.175.20]:34220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbfEMJ4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:56:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F28BDA707
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AA96DA713
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6EF0DDA708; Mon, 13 May 2019 11:56:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D827DA7A5;
        Mon, 13 May 2019 11:56:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2F0324265A32;
        Mon, 13 May 2019 11:56:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/13] netfilter: nf_tables: fix base chain stat rcu_dereference usage
Date:   Mon, 13 May 2019 11:56:23 +0200
Message-Id: <20190513095630.32443-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Following splat gets triggered when nfnetlink monitor is running while
xtables-nft selftests are running:

net/netfilter/nf_tables_api.c:1272 suspicious rcu_dereference_check() usage!
other info that might help us debug this:

1 lock held by xtables-nft-mul/27006:
 #0: 00000000e0f85be9 (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid+0x1a/0x50
Call Trace:
 nf_tables_fill_chain_info.isra.45+0x6cc/0x6e0
 nf_tables_chain_notify+0xf8/0x1a0
 nf_tables_commit+0x165c/0x1740

nf_tables_fill_chain_info() can be called both from dumps (rcu read locked)
or from the transaction path if a userspace process subscribed to nftables
notifications.

In the 'table dump' case, rcu_access_pointer() cannot be used: We do not
hold transaction mutex so the pointer can be NULLed right after the check.
Just unconditionally fetch the value, then have the helper return
immediately if its NULL.

In the notification case we don't hold the rcu read lock, but updates are
prevented due to transaction mutex. Use rcu_dereference_check() to make lockdep
aware of this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f2e12ae50544..e4f6ecac48c3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1190,6 +1190,9 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	u64 pkts, bytes;
 	int cpu;
 
+	if (!stats)
+		return 0;
+
 	memset(&total, 0, sizeof(total));
 	for_each_possible_cpu(cpu) {
 		cpu_stats = per_cpu_ptr(stats, cpu);
@@ -1247,6 +1250,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		struct nft_stats __percpu *stats;
 		struct nlattr *nest;
 
 		nest = nla_nest_start(skb, NFTA_CHAIN_HOOK);
@@ -1268,8 +1272,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		if (nla_put_string(skb, NFTA_CHAIN_TYPE, basechain->type->name))
 			goto nla_put_failure;
 
-		if (rcu_access_pointer(basechain->stats) &&
-		    nft_dump_stats(skb, rcu_dereference(basechain->stats)))
+		stats = rcu_dereference_check(basechain->stats,
+					      lockdep_commit_lock_is_held(net));
+		if (nft_dump_stats(skb, stats))
 			goto nla_put_failure;
 	}
 
-- 
2.11.0

