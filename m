Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FA674A84
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390843AbfGYJzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:55:50 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18654 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbfGYJzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 05:55:47 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B828E41B1B;
        Thu, 25 Jul 2019 17:55:39 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] netfilter: nf_tables_offload: support indr block call
Date:   Thu, 25 Jul 2019 17:55:33 +0800
Message-Id: <1564048533-27283-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUNKS0tLS0pDSkpCQ0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PTo6NDo6PDg2LlYvHT8MMx4w
        FC8KCjZVSlVKTk1PS09DTk9LSkhOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1IS0w3Bg++
X-HM-Tid: 0a6c288ec07b2086kuqyb828e41b1b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nftable support indr-block call. It makes nftable an offload vlan
and tunnel device

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_api.c     |   6 ++
 net/netfilter/nf_tables_offload.c | 137 ++++++++++++++++++++++++++++++--------
 2 files changed, 115 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c6dc173..20daf87 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7623,8 +7623,14 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err5;
 
+	err = flow_indr_rhashtable_init();
+	if (err)
+		goto err6;
+
 	nft_chain_route_init();
 	return err;
+err6:
+	nfnetlink_subsys_unregister(&nf_tables_subsys);
 err5:
 	rhltable_destroy(&nft_objname_ht);
 err4:
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 3e1a1a8..be050f4 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -176,24 +176,125 @@ static int nft_flow_offload_unbind(struct flow_block_offload *bo,
 	return 0;
 }
 
+static int nft_block_setup(struct nft_base_chain *basechain,
+			   struct flow_block_offload *bo,
+			   enum flow_block_command cmd)
+{
+	int err;
+
+	switch (cmd) {
+	case FLOW_BLOCK_BIND:
+		err = nft_flow_offload_bind(bo, basechain);
+		break;
+	case FLOW_BLOCK_UNBIND:
+		err = nft_flow_offload_unbind(bo, basechain);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int nft_block_offload_cmd(struct nft_base_chain *chain,
+				 struct net_device *dev,
+				 enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo = {};
+	int err;
+
+	bo.net = dev_net(dev);
+	bo.block = &chain->flow_block;
+	bo.command = cmd;
+	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo.extack = &extack;
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	rtnl_lock();
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (err < 0) {
+		rtnl_unlock();
+		return err;
+	}
+	rtnl_unlock();
+
+	return nft_block_setup(chain, &bo, cmd);
+}
+
+static void nft_indr_block_ing_cmd(struct net_device *dev, void *block,
+				   struct flow_indr_block_cb *indr_block_cb,
+				   enum flow_block_command cmd)
+{
+	struct nft_base_chain *chain = (struct nft_base_chain *)block;
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo = {};
+
+	bo.net = dev_net(dev);
+	bo.block = &chain->flow_block;
+	bo.command = cmd;
+	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo.extack = &extack;
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	if (block)
+		return;
+
+	rtnl_lock();
+	indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK, &bo);
+	rtnl_unlock();
+
+	nft_block_setup(chain, &bo, cmd);
+}
+
+static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
+				      struct net_device *dev,
+				      enum flow_block_command cmd)
+{
+	struct flow_indr_block_cb *indr_block_cb;
+	struct flow_indr_block_dev *indr_dev;
+	struct flow_block_offload bo = {};
+	struct netlink_ext_ack extack = {};
+
+	bo.net = dev_net(dev);
+	bo.block = &chain->flow_block;
+	bo.command = cmd;
+	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo.extack = &extack;
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	indr_dev = flow_indr_block_dev_lookup(dev);
+	if (!indr_dev)
+		return -EOPNOTSUPP;
+
+	indr_dev->block = cmd == FLOW_BLOCK_BIND ? chain : NULL;
+	indr_dev->cmd_cb = cmd == FLOW_BLOCK_BIND ? nft_indr_block_ing_cmd : NULL;
+
+	rtnl_lock();
+	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
+		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
+				  &bo);
+	rtnl_unlock();
+
+	return nft_block_setup(chain, &bo, cmd);
+}
+
 #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
 
 static int nft_flow_offload_chain(struct nft_trans *trans,
 				  enum flow_block_command cmd)
 {
 	struct nft_chain *chain = trans->ctx.chain;
-	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo = {};
 	struct nft_base_chain *basechain;
 	struct net_device *dev;
-	int err;
 
 	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
 
 	basechain = nft_base_chain(chain);
 	dev = basechain->ops.dev;
-	if (!dev || !dev->netdev_ops->ndo_setup_tc)
+	if (!dev)
 		return -EOPNOTSUPP;
 
 	/* Only default policy to accept is supported for now. */
@@ -202,30 +303,10 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 	    nft_trans_chain_policy(trans) != NF_ACCEPT)
 		return -EOPNOTSUPP;
 
-	bo.command = cmd;
-	bo.block = &basechain->flow_block;
-	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
-	bo.extack = &extack;
-	INIT_LIST_HEAD(&bo.cb_list);
-
-	rtnl_lock();
-
-	err = dev->netdev_ops->ndo_setup_tc(dev, FLOW_SETUP_BLOCK, &bo);
-	if (err < 0)
-		goto out;
-
-	switch (cmd) {
-	case FLOW_BLOCK_BIND:
-		err = nft_flow_offload_bind(&bo, basechain);
-		break;
-	case FLOW_BLOCK_UNBIND:
-		err = nft_flow_offload_unbind(&bo, basechain);
-		break;
-	}
-
-out:
-	rtnl_unlock();
-	return err;
+	if (dev->netdev_ops->ndo_setup_tc)
+		return nft_block_offload_cmd(basechain, dev, cmd);
+	else
+		return nft_indr_block_offload_cmd(basechain, dev, cmd);
 }
 
 int nft_flow_rule_offload_commit(struct net *net)
-- 
1.8.3.1

