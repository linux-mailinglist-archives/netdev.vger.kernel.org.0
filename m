Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD5B1C5C
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388121AbfIMLbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:21 -0400
Received: from correo.us.es ([193.147.175.20]:42602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388082AbfIMLbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E20CC4FFE18
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2701B8019
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D1B98B8014; Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEDCFA7D63;
        Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 812D342EE38F;
        Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/27] netfilter: nf_tables_offload: add __nft_offload_get_chain function
Date:   Fri, 13 Sep 2019 13:30:41 +0200
Message-Id: <20190913113102.15776-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add __nft_offload_get_chain function to get basechain from device. This
function requires that caller holds the per-netns nftables mutex. This
patch implicitly fixes missing offload flags check and proper mutex from
nft_indr_block_cb().

Fixes: 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 52 +++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 239cb781ad13..e200491ec672 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -369,33 +369,49 @@ int nft_flow_rule_offload_commit(struct net *net)
 	return err;
 }
 
-static void nft_indr_block_cb(struct net_device *dev,
-			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      enum flow_block_command command)
+static struct nft_chain *__nft_offload_get_chain(struct net_device *dev)
 {
+	struct nft_base_chain *basechain;
 	struct net *net = dev_net(dev);
 	const struct nft_table *table;
-	const struct nft_chain *chain;
+	struct nft_chain *chain;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry(table, &net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
 
-		list_for_each_entry_rcu(chain, &table->chains, list) {
-			if (nft_is_base_chain(chain)) {
-				struct nft_base_chain *basechain;
-
-				basechain = nft_base_chain(chain);
-				if (!strncmp(basechain->dev_name, dev->name,
-					     IFNAMSIZ)) {
-					nft_indr_block_ing_cmd(dev, basechain,
-							       cb, cb_priv,
-							       command);
-					return;
-				}
-			}
+		list_for_each_entry(chain, &table->chains, list) {
+			if (!nft_is_base_chain(chain) ||
+			    !(chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			basechain = nft_base_chain(chain);
+			if (strncmp(basechain->dev_name, dev->name, IFNAMSIZ))
+				continue;
+
+			return chain;
 		}
 	}
+
+	return NULL;
+}
+
+static void nft_indr_block_cb(struct net_device *dev,
+			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      enum flow_block_command cmd)
+{
+	struct net *net = dev_net(dev);
+	struct nft_chain *chain;
+
+	mutex_lock(&net->nft.commit_mutex);
+	chain = __nft_offload_get_chain(dev);
+	if (chain) {
+		struct nft_base_chain *basechain;
+
+		basechain = nft_base_chain(chain);
+		nft_indr_block_ing_cmd(dev, basechain, cb, cb_priv, cmd);
+	}
+	mutex_unlock(&net->nft.commit_mutex);
 }
 
 static struct flow_indr_block_ing_entry block_ing_entry = {
-- 
2.11.0

