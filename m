Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F0D31E1F
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 15:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfFANXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 09:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbfFANXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 09:23:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B06240F2;
        Sat,  1 Jun 2019 13:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395422;
        bh=y0YIx458h1pu2brSHcf1MnZn/W3uPgxIL1CV8IL7Z+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vP8OXVBvwh/B5Wj3++vvhov2/qn+2NbbbOsMUKuQPnLT1D2xG+DqXX0JsIzZKxaBv
         fzNM/DhhntOiKNERQcZKi3x77xqrvL4dOoqH/gm63Ct5VuQdaAqlki4+vwpu7a0sVW
         fp9hD6MukAWgL5SVj0Xias6N0kC/UmRtnjY1NPkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 054/141] netfilter: nf_tables: fix base chain stat rcu_dereference usage
Date:   Sat,  1 Jun 2019 09:20:30 -0400
Message-Id: <20190601132158.25821-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit edbd82c5fba009f68d20b5db585be1e667c605f6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ebfcfe1dcbdbb..29ff59dd99ace 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1142,6 +1142,9 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	u64 pkts, bytes;
 	int cpu;
 
+	if (!stats)
+		return 0;
+
 	memset(&total, 0, sizeof(total));
 	for_each_possible_cpu(cpu) {
 		cpu_stats = per_cpu_ptr(stats, cpu);
@@ -1199,6 +1202,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		struct nft_stats __percpu *stats;
 		struct nlattr *nest;
 
 		nest = nla_nest_start(skb, NFTA_CHAIN_HOOK);
@@ -1220,8 +1224,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
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
2.20.1

