Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BABBE5A27
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfJZLsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:13 -0400
Received: from correo.us.es ([193.147.175.20]:46624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfJZLr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5C9328C3C63
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FAA7A7EE6
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 454E5A7EC6; Sat, 26 Oct 2019 13:47:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B960CA0F3;
        Sat, 26 Oct 2019 13:47:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2C35B42EE393;
        Sat, 26 Oct 2019 13:47:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 26/31] netfilter: nf_tables_offload: remove rules on unregistered device only
Date:   Sat, 26 Oct 2019 13:47:28 +0200
Message-Id: <20191026114733.28111-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After unbinding the list of flow_block callbacks, iterate over it to
remove the existing rules in the netdevice that has just been
unregistered.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 93363c7ab177..e7f32a9dad63 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -206,6 +206,16 @@ static int nft_flow_offload_unbind(struct flow_block_offload *bo,
 				   struct nft_base_chain *basechain)
 {
 	struct flow_block_cb *block_cb, *next;
+	struct flow_cls_offload cls_flow;
+	struct nft_chain *chain;
+	struct nft_rule *rule;
+
+	chain = &basechain->chain;
+	list_for_each_entry(rule, &chain->rules, list) {
+		nft_flow_cls_offload_setup(&cls_flow, basechain, rule, NULL,
+					   FLOW_CLS_DESTROY);
+		nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow, &bo->cb_list);
+	}
 
 	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
 		list_del(&block_cb->list);
@@ -445,18 +455,6 @@ static void nft_indr_block_cb(struct net_device *dev,
 	mutex_unlock(&net->nft.commit_mutex);
 }
 
-static void nft_offload_chain_clean(struct nft_chain *chain)
-{
-	struct nft_rule *rule;
-
-	list_for_each_entry(rule, &chain->rules, list) {
-		nft_flow_offload_rule(chain, rule,
-				      NULL, FLOW_CLS_DESTROY);
-	}
-
-	nft_flow_offload_chain(chain, NULL, FLOW_BLOCK_UNBIND);
-}
-
 static int nft_offload_netdev_event(struct notifier_block *this,
 				    unsigned long event, void *ptr)
 {
@@ -467,7 +465,9 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	mutex_lock(&net->nft.commit_mutex);
 	chain = __nft_offload_get_chain(dev);
 	if (chain)
-		nft_offload_chain_clean(chain);
+		nft_flow_block_chain(nft_base_chain(chain), dev,
+				     FLOW_BLOCK_UNBIND);
+
 	mutex_unlock(&net->nft.commit_mutex);
 
 	return NOTIFY_DONE;
-- 
2.11.0

