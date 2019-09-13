Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54684B1C5B
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbfIMLcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:32:05 -0400
Received: from correo.us.es ([193.147.175.20]:42650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388109AbfIMLbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAD0A4FFE0D
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B5B6A7EFE
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90A79A7EE6; Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D200A7D6A;
        Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 38EC842EE393;
        Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/27] netfilter: nf_tables_offload: remove rules when the device unregisters
Date:   Fri, 13 Sep 2019 13:30:44 +0200
Message-Id: <20190913113102.15776-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

If the net_device unregisters, clean up the offload rules before the
chain is destroy.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h |  2 +-
 net/netfilter/nf_tables_api.c             | 11 +++++---
 net/netfilter/nf_tables_offload.c         | 43 ++++++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index ddd048be4330..03cf5856d76f 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -77,7 +77,7 @@ int nft_flow_rule_offload_commit(struct net *net);
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
-void nft_offload_init(void);
+int nft_offload_init(void);
 void nft_offload_exit(void);
 
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c6f59ef96017..e4a68dc42694 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7694,15 +7694,20 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err4;
 
+	err = nft_offload_init();
+	if (err < 0)
+		goto err5;
+
 	/* must be last */
 	err = nfnetlink_subsys_register(&nf_tables_subsys);
 	if (err < 0)
-		goto err5;
+		goto err6;
 
 	nft_chain_route_init();
-	nft_offload_init();
 
 	return err;
+err6:
+	nft_offload_exit();
 err5:
 	rhltable_destroy(&nft_objname_ht);
 err4:
@@ -7718,8 +7723,8 @@ static int __init nf_tables_module_init(void)
 
 static void __exit nf_tables_module_exit(void)
 {
-	nft_offload_exit();
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
+	nft_offload_exit();
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
 	nft_chain_route_fini();
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 739a79cdb741..21bb772cb4b7 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -426,17 +426,58 @@ static void nft_indr_block_cb(struct net_device *dev,
 	mutex_unlock(&net->nft.commit_mutex);
 }
 
+static void nft_offload_chain_clean(struct nft_chain *chain)
+{
+	struct nft_rule *rule;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		nft_flow_offload_rule(chain, rule,
+				      NULL, FLOW_CLS_DESTROY);
+	}
+
+	nft_flow_offload_chain(chain, NULL, FLOW_BLOCK_UNBIND);
+}
+
+static int nft_offload_netdev_event(struct notifier_block *this,
+				    unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	struct nft_chain *chain;
+
+	mutex_lock(&net->nft.commit_mutex);
+	chain = __nft_offload_get_chain(dev);
+	if (chain)
+		nft_offload_chain_clean(chain);
+	mutex_unlock(&net->nft.commit_mutex);
+
+	return NOTIFY_DONE;
+}
+
 static struct flow_indr_block_ing_entry block_ing_entry = {
 	.cb	= nft_indr_block_cb,
 	.list	= LIST_HEAD_INIT(block_ing_entry.list),
 };
 
-void nft_offload_init(void)
+static struct notifier_block nft_offload_netdev_notifier = {
+	.notifier_call	= nft_offload_netdev_event,
+};
+
+int nft_offload_init(void)
 {
+	int err;
+
+	err = register_netdevice_notifier(&nft_offload_netdev_notifier);
+	if (err < 0)
+		return err;
+
 	flow_indr_add_block_ing_cb(&block_ing_entry);
+
+	return 0;
 }
 
 void nft_offload_exit(void)
 {
 	flow_indr_del_block_ing_cb(&block_ing_entry);
+	unregister_netdevice_notifier(&nft_offload_netdev_notifier);
 }
-- 
2.11.0

