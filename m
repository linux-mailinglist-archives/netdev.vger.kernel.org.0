Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73815E5A29
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfJZLsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:15 -0400
Received: from correo.us.es ([193.147.175.20]:46610 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfJZLr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA1B58C3C57
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD2DDA7EC8
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A21ACA7EC1; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4B0EDA8E8;
        Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 858FE42EE393;
        Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 25/31] netfilter: nf_tables_offload: add nft_flow_cls_offload_setup()
Date:   Sat, 26 Oct 2019 13:47:27 +0200
Message-Id: <20191026114733.28111-26-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper function to set up the flow_cls_offload object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b85ea768ca80..93363c7ab177 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -155,30 +155,41 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
 	return 0;
 }
 
+static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
+				       const struct nft_base_chain *basechain,
+				       const struct nft_rule *rule,
+				       const struct nft_flow_rule *flow,
+				       enum flow_cls_command command)
+{
+	struct netlink_ext_ack extack;
+	__be16 proto = ETH_P_ALL;
+
+	memset(cls_flow, 0, sizeof(*cls_flow));
+
+	if (flow)
+		proto = flow->proto;
+
+	nft_flow_offload_common_init(&cls_flow->common, proto,
+				     basechain->ops.priority, &extack);
+	cls_flow->command = command;
+	cls_flow->cookie = (unsigned long) rule;
+	if (flow)
+		cls_flow->rule = flow->rule;
+}
+
 static int nft_flow_offload_rule(struct nft_chain *chain,
 				 struct nft_rule *rule,
 				 struct nft_flow_rule *flow,
 				 enum flow_cls_command command)
 {
-	struct flow_cls_offload cls_flow = {};
+	struct flow_cls_offload cls_flow;
 	struct nft_base_chain *basechain;
-	struct netlink_ext_ack extack;
-	__be16 proto = ETH_P_ALL;
 
 	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
 
 	basechain = nft_base_chain(chain);
-
-	if (flow)
-		proto = flow->proto;
-
-	nft_flow_offload_common_init(&cls_flow.common, proto,
-				     basechain->ops.priority, &extack);
-	cls_flow.command = command;
-	cls_flow.cookie = (unsigned long) rule;
-	if (flow)
-		cls_flow.rule = flow->rule;
+	nft_flow_cls_offload_setup(&cls_flow, basechain, rule, flow, command);
 
 	return nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow,
 				 &basechain->flow_block.cb_list);
-- 
2.11.0

