Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42270E5A19
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfJZLsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:00 -0400
Received: from correo.us.es ([193.147.175.20]:46416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfJZLr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BEF58C3C65
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0EFB5FF13B
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0284EB8005; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 196D3A7E24;
        Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DF32A42EE393;
        Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 24/31] netfilter: nf_tables_offload: Pass callback list to nft_setup_cb_call()
Date:   Sat, 26 Oct 2019 13:47:26 +0200
Message-Id: <20191026114733.28111-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows to reuse nft_setup_cb_call() from the callback unbind path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 4554bc661817..b85ea768ca80 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -132,13 +132,13 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
 	common->extack = extack;
 }
 
-static int nft_setup_cb_call(struct nft_base_chain *basechain,
-			     enum tc_setup_type type, void *type_data)
+static int nft_setup_cb_call(enum tc_setup_type type, void *type_data,
+			     struct list_head *cb_list)
 {
 	struct flow_block_cb *block_cb;
 	int err;
 
-	list_for_each_entry(block_cb, &basechain->flow_block.cb_list, list) {
+	list_for_each_entry(block_cb, cb_list, list) {
 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
 		if (err < 0)
 			return err;
@@ -180,7 +180,8 @@ static int nft_flow_offload_rule(struct nft_chain *chain,
 	if (flow)
 		cls_flow.rule = flow->rule;
 
-	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flow);
+	return nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow,
+				 &basechain->flow_block.cb_list);
 }
 
 static int nft_flow_offload_bind(struct flow_block_offload *bo,
-- 
2.11.0

