Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3A3134FEC
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgAHXRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:17:39 -0500
Received: from correo.us.es ([193.147.175.20]:43146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbgAHXRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 18:17:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8C82FF9AD
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACEF4DA70F
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC535DA709; Thu,  9 Jan 2020 00:17:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 975CEDA70E;
        Thu,  9 Jan 2020 00:17:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 00:17:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 72C57426CCB9;
        Thu,  9 Jan 2020 00:17:21 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/9] netfilter: nf_tables: unbind callbacks from flowtable destroy path
Date:   Thu,  9 Jan 2020 00:17:10 +0100
Message-Id: <20200108231713.100458-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200108231713.100458-1-pablo@netfilter.org>
References: <20200108231713.100458-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callback unbinding needs to be done after nf_flow_table_free(),
otherwise entries are not removed from the hardware.

Update nft_unregister_flowtable_net_hooks() to call
nf_unregister_net_hook() instead since the commit/abort paths do not
deal with the callback unbinding anymore.

Add a comment to nft_flowtable_event() to clarify that
flow_offload_netdev_event() already removes the entries before the
callback unbinding.

Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
Fixes ff4bf2f42a40 ("netfilter: nf_tables: add nft_unregister_flowtable_hook()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 273f3838318b..43f05b3acd60 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5984,6 +5984,7 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	return ERR_PTR(-ENOENT);
 }
 
+/* Only called from error and netdev event paths. */
 static void nft_unregister_flowtable_hook(struct net *net,
 					  struct nft_flowtable *flowtable,
 					  struct nft_hook *hook)
@@ -5999,7 +6000,7 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &flowtable->hook_list, list)
-		nft_unregister_flowtable_hook(net, flowtable, hook);
+		nf_unregister_net_hook(net, &hook->ops);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -6448,12 +6449,14 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook, *next;
 
+	flowtable->data.type->free(&flowtable->data);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
 		kfree(hook);
 	}
 	kfree(flowtable->name);
-	flowtable->data.type->free(&flowtable->data);
 	module_put(flowtable->data.type->owner);
 	kfree(flowtable);
 }
@@ -6497,6 +6500,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 		if (hook->ops.dev != dev)
 			continue;
 
+		/* flow_offload_netdev_event() cleans up entries for us. */
 		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
-- 
2.11.0

