Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D7A75EDA
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 08:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfGZGR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 02:17:56 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:10878 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfGZGR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 02:17:56 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 039AC41ACA;
        Fri, 26 Jul 2019 14:17:50 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/3] netfilter: nf_tables_offload: support indr block call
Date:   Fri, 26 Jul 2019 14:17:49 +0800
Message-Id: <1564121869-3398-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564121869-3398-1-git-send-email-wenxu@ucloud.cn>
References: <1564121869-3398-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS09NQkJCQ0pJSklNSk1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBQ6DCo4GTgrSUsQIwgXTDQs
        GEMwCSxVSlVKTk1PSklKQ0xKT0xLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1NTUw3Bg++
X-HM-Tid: 0a6c2cedb2fb2086kuqy039ac41aca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nftable support indr-block call. It makes nftable an offload vlan
and tunnel device.

nft add table netdev firewall
nft add chain netdev firewall aclout { type filter hook ingress offload device mlx_pf0vf0 priority - 300 \; }
nft add rule netdev firewall aclout ip daddr 10.0.0.1 fwd to vlan0
nft add chain netdev firewall aclin { type filter hook ingress device vlan0 priority - 300 \; }
nft add rule netdev firewall aclin ip daddr 10.0.0.7 fwd to mlx_pf0vf0

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: make use of flow_block

 net/netfilter/nf_tables_api.c     |   6 ++
 net/netfilter/nf_tables_offload.c | 128 +++++++++++++++++++++++++++++++-------
 2 files changed, 110 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 605a7cf..a8ab3e9 100644
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
index 64f5fd5..09a5efe 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -171,24 +171,120 @@ static int nft_flow_offload_unbind(struct flow_block_offload *bo,
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
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (err < 0)
+		return err;
+
+	return nft_block_setup(chain, &bo, cmd);
+}
+
+static void nft_indr_block_ing_cmd(struct net_device *dev,
+				   struct flow_block *flow_block,
+				   struct flow_indr_block_cb *indr_block_cb,
+				   enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo = {};
+	struct nft_base_chain *chain;
+
+	if (flow_block)
+		return;
+
+	chain = container_of(flow_block, struct nft_base_chain, flow_block);
+
+	bo.net = dev_net(dev);
+	bo.block = flow_block;
+	bo.command = cmd;
+	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo.extack = &extack;
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK, &bo);
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
+	indr_dev->flow_block = cmd == FLOW_BLOCK_BIND ? &chain->flow_block : NULL;
+	indr_dev->ing_cmd_cb = cmd == FLOW_BLOCK_BIND ? nft_indr_block_ing_cmd : NULL;
+
+	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
+		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
+				  &bo);
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
@@ -197,26 +293,10 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 	    nft_trans_chain_policy(trans) != NF_ACCEPT)
 		return -EOPNOTSUPP;
 
-	bo.command = cmd;
-	bo.block = &basechain->flow_block;
-	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
-	bo.extack = &extack;
-	INIT_LIST_HEAD(&bo.cb_list);
-
-	err = dev->netdev_ops->ndo_setup_tc(dev, FLOW_SETUP_BLOCK, &bo);
-	if (err < 0)
-		return err;
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
-	return err;
+	if (dev->netdev_ops->ndo_setup_tc)
+		return nft_block_offload_cmd(basechain, dev, cmd);
+	else
+		return nft_indr_block_offload_cmd(basechain, dev, cmd);
 }
 
 int nft_flow_rule_offload_commit(struct net *net)
-- 
1.8.3.1

