Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C77100E5A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfKRVuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:50:02 -0500
Received: from correo.us.es ([193.147.175.20]:45696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfKRVte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5895BEB48C
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A276B8011
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3FCE9B8005; Mon, 18 Nov 2019 22:49:29 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80798D2B1E;
        Mon, 18 Nov 2019 22:49:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 530A242EE38F;
        Mon, 18 Nov 2019 22:49:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/18] netfilter: nf_tables_offload: pass extack to nft_flow_cls_offload_setup()
Date:   Mon, 18 Nov 2019 22:49:01 +0100
Message-Id: <20191118214914.142794-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise this leads to a stack corruption.

Fixes: c5d275276ff4 ("netfilter: nf_tables_offload: add nft_flow_cls_offload_setup()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index cdea3010c7a0..741045eb530e 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -159,9 +159,9 @@ static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
 				       const struct nft_base_chain *basechain,
 				       const struct nft_rule *rule,
 				       const struct nft_flow_rule *flow,
+				       struct netlink_ext_ack *extack,
 				       enum flow_cls_command command)
 {
-	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
 
 	memset(cls_flow, 0, sizeof(*cls_flow));
@@ -170,7 +170,7 @@ static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
 		proto = flow->proto;
 
 	nft_flow_offload_common_init(&cls_flow->common, proto,
-				     basechain->ops.priority, &extack);
+				     basechain->ops.priority, extack);
 	cls_flow->command = command;
 	cls_flow->cookie = (unsigned long) rule;
 	if (flow)
@@ -182,6 +182,7 @@ static int nft_flow_offload_rule(struct nft_chain *chain,
 				 struct nft_flow_rule *flow,
 				 enum flow_cls_command command)
 {
+	struct netlink_ext_ack extack = {};
 	struct flow_cls_offload cls_flow;
 	struct nft_base_chain *basechain;
 
@@ -189,7 +190,8 @@ static int nft_flow_offload_rule(struct nft_chain *chain,
 		return -EOPNOTSUPP;
 
 	basechain = nft_base_chain(chain);
-	nft_flow_cls_offload_setup(&cls_flow, basechain, rule, flow, command);
+	nft_flow_cls_offload_setup(&cls_flow, basechain, rule, flow, &extack,
+				   command);
 
 	return nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow,
 				 &basechain->flow_block.cb_list);
@@ -207,13 +209,15 @@ static int nft_flow_offload_unbind(struct flow_block_offload *bo,
 {
 	struct flow_block_cb *block_cb, *next;
 	struct flow_cls_offload cls_flow;
+	struct netlink_ext_ack extack;
 	struct nft_chain *chain;
 	struct nft_rule *rule;
 
 	chain = &basechain->chain;
 	list_for_each_entry(rule, &chain->rules, list) {
+		memset(&extack, 0, sizeof(extack));
 		nft_flow_cls_offload_setup(&cls_flow, basechain, rule, NULL,
-					   FLOW_CLS_DESTROY);
+					   &extack, FLOW_CLS_DESTROY);
 		nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow, &bo->cb_list);
 	}
 
-- 
2.11.0

