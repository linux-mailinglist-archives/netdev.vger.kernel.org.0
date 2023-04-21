Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9816EB5E3
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjDUXu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbjDUXuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:50:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D1B2268B;
        Fri, 21 Apr 2023 16:50:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 15/19] netfilter: nf_tables: do not send complete notification of deletions
Date:   Sat, 22 Apr 2023 01:50:17 +0200
Message-Id: <20230421235021.216950-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421235021.216950-1-pablo@netfilter.org>
References: <20230421235021.216950-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In most cases, table, name and handle is sufficient for userspace to
identify an object that has been deleted. Skipping unneeded fields in
the netlink attributes in the message saves bandwidth (ie. less chances
of hitting ENOBUFS).

Rules are an exception: the existing userspace monitor code relies on
the rule definition. This exception can be removed by implementing a
rule cache in userspace, this is already supported by the tracing
infrastructure.

Regarding flowtables, incremental deletion of devices is possible.
Skipping a full notification allows userspace to differentiate between
flowtable removal and incremental removal of devices.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 70 +++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0fd4e28fbb60..3f95fb24a0bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -819,12 +819,20 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
-	    nla_put_be32(skb, NFTA_TABLE_FLAGS,
-			 htonl(table->flags & NFT_TABLE_F_MASK)) ||
 	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)) ||
 	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
+
+	if (event == NFT_MSG_DELTABLE) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
+	if (nla_put_be32(skb, NFTA_TABLE_FLAGS,
+			 htonl(table->flags & NFT_TABLE_F_MASK)))
+		goto nla_put_failure;
+
 	if (nft_table_has_owner(table) &&
 	    nla_put_be32(skb, NFTA_TABLE_OWNER, htonl(table->nlpid)))
 		goto nla_put_failure;
@@ -1626,13 +1634,16 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	if (!nlh)
 		goto nla_put_failure;
 
-	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name))
-		goto nla_put_failure;
-	if (nla_put_be64(skb, NFTA_CHAIN_HANDLE, cpu_to_be64(chain->handle),
+	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name) ||
+	    nla_put_string(skb, NFTA_CHAIN_NAME, chain->name) ||
+	    nla_put_be64(skb, NFTA_CHAIN_HANDLE, cpu_to_be64(chain->handle),
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
-	if (nla_put_string(skb, NFTA_CHAIN_NAME, chain->name))
-		goto nla_put_failure;
+
+	if (event == NFT_MSG_DELCHAIN) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
 
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
@@ -4150,6 +4161,12 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	if (nla_put_be64(skb, NFTA_SET_HANDLE, cpu_to_be64(set->handle),
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
+
+	if (event == NFT_MSG_DELSET) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -7154,13 +7171,20 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
-	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
-	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
-	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset) ||
 	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
+	if (event == NFT_MSG_DELOBJ) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
+	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
+	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
+	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
+		goto nla_put_failure;
+
 	if (obj->udata &&
 	    nla_put(skb, NFTA_OBJ_USERDATA, obj->udlen, obj->udata))
 		goto nla_put_failure;
@@ -8089,9 +8113,16 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_string(skb, NFTA_FLOWTABLE_TABLE, flowtable->table->name) ||
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
-	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be64(skb, NFTA_FLOWTABLE_HANDLE, cpu_to_be64(flowtable->handle),
-			 NFTA_FLOWTABLE_PAD) ||
+			 NFTA_FLOWTABLE_PAD))
+		goto nla_put_failure;
+
+	if (event == NFT_MSG_DELFLOWTABLE && !hook_list) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
+	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
 
@@ -8106,6 +8137,9 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	if (!nest_devs)
 		goto nla_put_failure;
 
+	if (!hook_list)
+		hook_list = &flowtable->hook_list;
+
 	list_for_each_entry_rcu(hook, hook_list, list) {
 		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
 			goto nla_put_failure;
@@ -8162,8 +8196,7 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 							  NFT_MSG_NEWFLOWTABLE,
 							  NLM_F_MULTI | NLM_F_APPEND,
 							  table->family,
-							  flowtable,
-							  &flowtable->hook_list) < 0)
+							  flowtable, NULL) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -8258,7 +8291,7 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 	err = nf_tables_fill_flowtable_info(skb2, net, NETLINK_CB(skb).portid,
 					    info->nlh->nlmsg_seq,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
-					    flowtable, &flowtable->hook_list);
+					    flowtable, NULL);
 	if (err < 0)
 		goto err_fill_flowtable_info;
 
@@ -8271,8 +8304,7 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 
 static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 				       struct nft_flowtable *flowtable,
-				       struct list_head *hook_list,
-				       int event)
+				       struct list_head *hook_list, int event)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct sk_buff *skb;
@@ -9333,7 +9365,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_clear(net, nft_trans_flowtable(trans));
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
-							   &nft_trans_flowtable(trans)->hook_list,
+							   NULL,
 							   NFT_MSG_NEWFLOWTABLE);
 			}
 			nft_trans_destroy(trans);
@@ -9351,7 +9383,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
-							   &nft_trans_flowtable(trans)->hook_list,
+							   NULL,
 							   trans->msg_type);
 				nft_unregister_flowtable_net_hooks(net,
 						&nft_trans_flowtable(trans)->hook_list);
-- 
2.30.2

