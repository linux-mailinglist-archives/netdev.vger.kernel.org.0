Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5257B1C53
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbfIMLbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:22 -0400
Received: from correo.us.es ([193.147.175.20]:42588 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388108AbfIMLbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13FB84FFE17
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0A04A7EC6
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E6021A8271; Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3B09A7D6E;
        Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A4D0A42EE395;
        Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/27] netfilter: nf_tables_offload: refactor the nft_flow_offload_rule function
Date:   Fri, 13 Sep 2019 13:30:43 +0200
Message-Id: <20190913113102.15776-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Pass rule, chain and flow_rule object parameters to nft_flow_offload_rule
to reuse it.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 367a7fa5c9dd..739a79cdb741 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -155,20 +155,20 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
 	return 0;
 }
 
-static int nft_flow_offload_rule(struct nft_trans *trans,
+static int nft_flow_offload_rule(struct nft_chain *chain,
+				 struct nft_rule *rule,
+				 struct nft_flow_rule *flow,
 				 enum flow_cls_command command)
 {
-	struct nft_flow_rule *flow = nft_trans_flow_rule(trans);
-	struct nft_rule *rule = nft_trans_rule(trans);
 	struct flow_cls_offload cls_flow = {};
 	struct nft_base_chain *basechain;
 	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
 
-	if (!nft_is_base_chain(trans->ctx.chain))
+	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
 
-	basechain = nft_base_chain(trans->ctx.chain);
+	basechain = nft_base_chain(chain);
 
 	if (flow)
 		proto = flow->proto;
@@ -357,14 +357,20 @@ int nft_flow_rule_offload_commit(struct net *net)
 			    !(trans->ctx.flags & NLM_F_APPEND))
 				return -EOPNOTSUPP;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_REPLACE);
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    nft_trans_flow_rule(trans),
+						    FLOW_CLS_REPLACE);
 			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_rule(trans, FLOW_CLS_DESTROY);
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    nft_trans_flow_rule(trans),
+						    FLOW_CLS_DESTROY);
 			break;
 		}
 
-- 
2.11.0

