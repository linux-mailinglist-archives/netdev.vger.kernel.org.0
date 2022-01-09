Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE95488D0D
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiAIXQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:16:56 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42108 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbiAIXQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:52 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BBAF064291;
        Mon, 10 Jan 2022 00:14:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/32] netfilter: nf_tables: remove rcu read-size lock
Date:   Mon, 10 Jan 2022 00:16:11 +0100
Message-Id: <20220109231640.104123-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chain stats are updated from the Netfilter hook path which already run
under rcu read-size lock section.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index adc348056076..41c7509955e6 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -110,7 +110,6 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 
 	base_chain = nft_base_chain(chain);
 
-	rcu_read_lock();
 	pstats = READ_ONCE(base_chain->stats);
 	if (pstats) {
 		local_bh_disable();
@@ -121,7 +120,6 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 		u64_stats_update_end(&stats->syncp);
 		local_bh_enable();
 	}
-	rcu_read_unlock();
 }
 
 struct nft_jumpstack {
-- 
2.30.2

