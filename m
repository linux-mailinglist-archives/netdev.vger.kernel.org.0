Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8838E1E7167
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438130AbgE2A0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:26:19 -0400
Received: from correo.us.es ([193.147.175.20]:44340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438099AbgE2AZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:25:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC71DCE76E
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA938DA71A
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A012FDA710; Fri, 29 May 2020 02:25:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A6E8DA709;
        Fri, 29 May 2020 02:25:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 02:25:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D293C426CCB9;
        Fri, 29 May 2020 02:25:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH net-next 4/8] net: use flow_indr_dev_setup_offload()
Date:   Fri, 29 May 2020 02:25:37 +0200
Message-Id: <20200529002541.19743-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update existing frontends to use flow_indr_dev_setup_offload().

This new function must be called if ->ndo_setup_tc is unset to deal
with tunnel devices.

If there is no driver that is subscribed to new tunnel device
flow_block bindings, then this function bails out with EOPNOTSUPP.

If the driver module is removed, the ->cleanup() callback removes the
entries that belong to this tunnel device. This cleanup procedures is
triggered when the device unregisters the tunnel device offload handler.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 19 ++++++---
 net/netfilter/nf_tables_offload.c     | 28 +++++++++++--
 net/sched/cls_api.c                   | 58 +++++++++++++--------------
 3 files changed, 67 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2ff4087007a6..01cfa02c43bd 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -942,6 +942,18 @@ static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
+static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
+{
+	struct nf_flowtable *flowtable = block_cb->indr.data;
+	struct net_device *dev = block_cb->indr.dev;
+
+	nf_flow_table_gc_cleanup(flowtable, dev);
+	down_write(&flowtable->flow_block_lock);
+	list_del(&block_cb->list);
+	flow_block_cb_free(block_cb);
+	up_write(&flowtable->flow_block_lock);
+}
+
 static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
 					  struct nf_flowtable *flowtable,
 					  struct net_device *dev,
@@ -950,12 +962,9 @@ static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
 {
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
-	flow_indr_block_call(dev, bo, cmd, TC_SETUP_FT);
 
-	if (list_empty(&bo->cb_list))
-		return -EOPNOTSUPP;
-
-	return 0;
+	return flow_indr_dev_setup_offload(dev, TC_SETUP_FT, flowtable, bo,
+					   nf_flow_table_indr_cleanup);
 }
 
 static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 954bccb7f32a..1960f11477e8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -304,21 +304,41 @@ static void nft_indr_block_ing_cmd(struct net_device *dev,
 	nft_block_setup(chain, &bo, cmd);
 }
 
-static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
+static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
+{
+	struct nft_base_chain *basechain = block_cb->indr.data;
+	struct net_device *dev = block_cb->indr.dev;
+	struct netlink_ext_ack extack = {};
+	struct net *net = dev_net(dev);
+	struct flow_block_offload bo;
+
+	nft_flow_block_offload_init(&bo, dev_net(dev), FLOW_BLOCK_UNBIND,
+				    basechain, &extack);
+	mutex_lock(&net->nft.commit_mutex);
+	list_move(&block_cb->list, &bo.cb_list);
+	nft_flow_offload_unbind(&bo, basechain);
+	mutex_unlock(&net->nft.commit_mutex);
+}
+
+static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
 				      struct net_device *dev,
 				      enum flow_block_command cmd)
 {
 	struct netlink_ext_ack extack = {};
 	struct flow_block_offload bo;
+	int err;
 
-	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, chain, &extack);
+	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, basechain, &extack);
 
-	flow_indr_block_call(dev, &bo, cmd, TC_SETUP_BLOCK);
+	err = flow_indr_dev_setup_offload(dev, TC_SETUP_BLOCK, basechain, &bo,
+					  nft_indr_block_cleanup);
+	if (err < 0)
+		return err;
 
 	if (list_empty(&bo.cb_list))
 		return -EOPNOTSUPP;
 
-	return nft_block_setup(chain, &bo, cmd);
+	return nft_block_setup(basechain, &bo, cmd);
 }
 
 #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c5a2f16097b6..760e51d852f5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -709,24 +709,26 @@ static void tcf_block_offload_init(struct flow_block_offload *bo,
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
-static void tc_indr_block_call(struct tcf_block *block,
-			       struct net_device *dev,
-			       struct tcf_block_ext_info *ei,
-			       enum flow_block_command command,
-			       struct netlink_ext_ack *extack)
+static void tcf_block_unbind(struct tcf_block *block,
+			     struct flow_block_offload *bo);
+
+static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 {
-	struct flow_block_offload bo = {
-		.command	= command,
-		.binder_type	= ei->binder_type,
-		.net		= dev_net(dev),
-		.block		= &block->flow_block,
-		.block_shared	= tcf_block_shared(block),
-		.extack		= extack,
-	};
-	INIT_LIST_HEAD(&bo.cb_list);
+	struct tcf_block *block = block_cb->indr.data;
+	struct net_device *dev = block_cb->indr.dev;
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo;
 
-	flow_indr_block_call(dev, &bo, command, TC_SETUP_BLOCK);
-	tcf_block_setup(block, &bo);
+	tcf_block_offload_init(&bo, dev, FLOW_BLOCK_UNBIND,
+			       block_cb->indr.binder_type,
+			       &block->flow_block, tcf_block_shared(block),
+			       &extack);
+	down_write(&block->cb_lock);
+	list_move(&block_cb->list, &bo.cb_list);
+	up_write(&block->cb_lock);
+	rtnl_lock();
+	tcf_block_unbind(block, &bo);
+	rtnl_unlock();
 }
 
 static bool tcf_block_offload_in_use(struct tcf_block *block)
@@ -747,7 +749,12 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 			       &block->flow_block, tcf_block_shared(block),
 			       extack);
 
-	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (dev->netdev_ops->ndo_setup_tc)
+		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	else
+		err = flow_indr_dev_setup_offload(dev, TC_SETUP_BLOCK, block,
+						  &bo, tc_block_indr_cleanup);
+
 	if (err < 0) {
 		if (err != -EOPNOTSUPP)
 			NL_SET_ERR_MSG(extack, "Driver ndo_setup_tc failed");
@@ -765,13 +772,13 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	int err;
 
 	down_write(&block->cb_lock);
-	if (!dev->netdev_ops->ndo_setup_tc)
-		goto no_offload_dev_inc;
 
 	/* If tc offload feature is disabled and the block we try to bind
 	 * to already has some offloaded filters, forbid to bind.
 	 */
-	if (!tc_can_offload(dev) && tcf_block_offload_in_use(block)) {
+	if (dev->netdev_ops->ndo_setup_tc &&
+	    !tc_can_offload(dev) &&
+	    tcf_block_offload_in_use(block)) {
 		NL_SET_ERR_MSG(extack, "Bind to offloaded block failed as dev has offload disabled");
 		err = -EOPNOTSUPP;
 		goto err_unlock;
@@ -783,18 +790,15 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	if (err)
 		goto err_unlock;
 
-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
 	up_write(&block->cb_lock);
 	return 0;
 
 no_offload_dev_inc:
-	if (tcf_block_offload_in_use(block)) {
-		err = -EOPNOTSUPP;
+	if (tcf_block_offload_in_use(block))
 		goto err_unlock;
-	}
+
 	err = 0;
 	block->nooffloaddevcnt++;
-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
 err_unlock:
 	up_write(&block->cb_lock);
 	return err;
@@ -807,10 +811,6 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	int err;
 
 	down_write(&block->cb_lock);
-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
-
-	if (!dev->netdev_ops->ndo_setup_tc)
-		goto no_offload_dev_dec;
 	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_dec;
-- 
2.20.1

