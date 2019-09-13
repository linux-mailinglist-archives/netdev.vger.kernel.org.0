Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBDAB1C60
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbfIMLcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:32:10 -0400
Received: from correo.us.es ([193.147.175.20]:42626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387752AbfIMLbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 736B44FFE1E
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 637D410079A
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 58E27FF6EC; Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 452BCA7D66;
        Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1684D42EE393;
        Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/27] netfilter: nf_tables_offload: refactor the nft_flow_offload_chain function
Date:   Fri, 13 Sep 2019 13:30:42 +0200
Message-Id: <20190913113102.15776-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Pass chain and policy parameters to nft_flow_offload_chain to reuse it.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index e200491ec672..367a7fa5c9dd 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -294,12 +294,13 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 
 #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
 
-static int nft_flow_offload_chain(struct nft_trans *trans,
+static int nft_flow_offload_chain(struct nft_chain *chain,
+				  u8 *ppolicy,
 				  enum flow_block_command cmd)
 {
-	struct nft_chain *chain = trans->ctx.chain;
 	struct nft_base_chain *basechain;
 	struct net_device *dev;
+	u8 policy;
 
 	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
@@ -309,10 +310,10 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 	if (!dev)
 		return -EOPNOTSUPP;
 
+	policy = ppolicy ? *ppolicy : basechain->policy;
+
 	/* Only default policy to accept is supported for now. */
-	if (cmd == FLOW_BLOCK_BIND &&
-	    nft_trans_chain_policy(trans) != -1 &&
-	    nft_trans_chain_policy(trans) != NF_ACCEPT)
+	if (cmd == FLOW_BLOCK_BIND && policy != -1 && policy != NF_ACCEPT)
 		return -EOPNOTSUPP;
 
 	if (dev->netdev_ops->ndo_setup_tc)
@@ -325,6 +326,7 @@ int nft_flow_rule_offload_commit(struct net *net)
 {
 	struct nft_trans *trans;
 	int err = 0;
+	u8 policy;
 
 	list_for_each_entry(trans, &net->nft.commit_list, list) {
 		if (trans->ctx.family != NFPROTO_NETDEV)
@@ -335,13 +337,17 @@ int nft_flow_rule_offload_commit(struct net *net)
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_chain(trans, FLOW_BLOCK_BIND);
+			policy = nft_trans_chain_policy(trans);
+			err = nft_flow_offload_chain(trans->ctx.chain, &policy,
+						     FLOW_BLOCK_BIND);
 			break;
 		case NFT_MSG_DELCHAIN:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_chain(trans, FLOW_BLOCK_UNBIND);
+			policy = nft_trans_chain_policy(trans);
+			err = nft_flow_offload_chain(trans->ctx.chain, &policy,
+						     FLOW_BLOCK_BIND);
 			break;
 		case NFT_MSG_NEWRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
-- 
2.11.0

