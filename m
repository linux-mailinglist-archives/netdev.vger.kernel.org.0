Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE4A3A1F44
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFIVrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60490 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhFIVrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:31 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6B63C6422E;
        Wed,  9 Jun 2021 23:44:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/13] netfilter: annotate nf_tables base hook ops
Date:   Wed,  9 Jun 2021 23:45:18 +0200
Message-Id: <20210609214523.1678-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This will allow a followup patch to treat the 'ops->priv' pointer
as nft_chain argument without having to first walk the table/chains
to check if there is a matching base chain pointer.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h     | 8 +++++++-
 net/netfilter/nf_tables_api.c | 4 +++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f161569fbe2f..3fda1a508733 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -77,12 +77,18 @@ struct nf_hook_state {
 typedef unsigned int nf_hookfn(void *priv,
 			       struct sk_buff *skb,
 			       const struct nf_hook_state *state);
+enum nf_hook_ops_type {
+	NF_HOOK_OP_UNDEFINED,
+	NF_HOOK_OP_NF_TABLES,
+};
+
 struct nf_hook_ops {
 	/* User fills in from here down. */
 	nf_hookfn		*hook;
 	struct net_device	*dev;
 	void			*priv;
-	u_int8_t		pf;
+	u8			pf;
+	enum nf_hook_ops_type	hook_ops_type:8;
 	unsigned int		hooknum;
 	/* Hooks are ordered in ascending priority. */
 	int			priority;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6c2000a11c7e..c9308241b688 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2168,8 +2168,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
-	if (nft_is_base_chain(chain))
+	if (nft_is_base_chain(chain)) {
+		basechain->ops.hook_ops_type = NF_HOOK_OP_NF_TABLES;
 		nft_trans_chain_policy(trans) = policy;
+	}
 
 	err = nft_chain_add(table, chain);
 	if (err < 0) {
-- 
2.30.2

