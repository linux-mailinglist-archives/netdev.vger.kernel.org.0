Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B613FB1C2E
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbfIMLbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:19 -0400
Received: from correo.us.es ([193.147.175.20]:42560 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387752AbfIMLbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29C7D4FFE2E
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CC97A7D6A
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1C20EA7D68; Fri, 13 Sep 2019 13:31:15 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E83DAA7E25;
        Fri, 13 Sep 2019 13:31:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B890A42EE38F;
        Fri, 13 Sep 2019 13:31:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/27] netfilter: nf_tables_offload: move indirect flow_block callback logic to core
Date:   Fri, 13 Sep 2019 13:30:38 +0200
Message-Id: <20190913113102.15776-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add nft_offload_init() and nft_offload_exit() function to deal with the
init and the exit path of the offload infrastructure.

Rename nft_indr_block_get_and_ing_cmd() to nft_indr_block_cb().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h |  7 +++----
 net/netfilter/nf_tables_api.c             | 10 +++-------
 net/netfilter/nf_tables_offload.c         | 22 ++++++++++++++++++----
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index db104665a9e4..6de896ebcf30 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -64,10 +64,6 @@ struct nft_rule;
 struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
 int nft_flow_rule_offload_commit(struct net *net);
-void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
-				    flow_indr_block_bind_cb_t *cb,
-				    void *cb_priv,
-				    enum flow_block_command command);
 
 #define NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
 	(__reg)->base_offset	=					\
@@ -80,4 +76,7 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
+void nft_offload_init(void);
+void nft_offload_exit(void);
+
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7def31ae3022..efd0c97cc2a3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7669,11 +7669,6 @@ static struct pernet_operations nf_tables_net_ops = {
 	.exit	= nf_tables_exit_net,
 };
 
-static struct flow_indr_block_ing_entry block_ing_entry = {
-	.cb = nft_indr_block_get_and_ing_cmd,
-	.list = LIST_HEAD_INIT(block_ing_entry.list),
-};
-
 static int __init nf_tables_module_init(void)
 {
 	int err;
@@ -7705,7 +7700,8 @@ static int __init nf_tables_module_init(void)
 		goto err5;
 
 	nft_chain_route_init();
-	flow_indr_add_block_ing_cb(&block_ing_entry);
+	nft_offload_init();
+
 	return err;
 err5:
 	rhltable_destroy(&nft_objname_ht);
@@ -7722,7 +7718,7 @@ static int __init nf_tables_module_init(void)
 
 static void __exit nf_tables_module_exit(void)
 {
-	flow_indr_del_block_ing_cb(&block_ing_entry);
+	nft_offload_exit();
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index fabe2997188b..8abf193f8012 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -354,10 +354,9 @@ int nft_flow_rule_offload_commit(struct net *net)
 	return err;
 }
 
-void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
-				    flow_indr_block_bind_cb_t *cb,
-				    void *cb_priv,
-				    enum flow_block_command command)
+static void nft_indr_block_cb(struct net_device *dev,
+			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      enum flow_block_command command)
 {
 	struct net *net = dev_net(dev);
 	const struct nft_table *table;
@@ -383,3 +382,18 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 		}
 	}
 }
+
+static struct flow_indr_block_ing_entry block_ing_entry = {
+	.cb	= nft_indr_block_cb,
+	.list	= LIST_HEAD_INIT(block_ing_entry.list),
+};
+
+void nft_offload_init(void)
+{
+	flow_indr_add_block_ing_cb(&block_ing_entry);
+}
+
+void nft_offload_exit(void)
+{
+	flow_indr_del_block_ing_cb(&block_ing_entry);
+}
-- 
2.11.0

