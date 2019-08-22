Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7ECF9940F
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbfHVMoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:44:18 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44434 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387890AbfHVMoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:44:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 15:44:11 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MCiAom025522;
        Thu, 22 Aug 2019 15:44:11 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 05/10] net: sched: add API for registering unlocked offload block callbacks
Date:   Thu, 22 Aug 2019 15:43:48 +0300
Message-Id: <20190822124353.16902-6-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822124353.16902-1-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend struct flow_block_offload with "unlocked_driver_cb" flag to allow
registering and unregistering block hardware offload callbacks that do not
require caller to hold rtnl lock. Extend tcf_block with additional
lockeddevcnt counter that is incremented for each non-unlocked driver
callback attached to device. This counter is necessary to conditionally
obtain rtnl lock before calling hardware callbacks in following patches.

Register mlx5 tc block offload callbacks as "unlocked".

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 3 +++
 include/net/flow_offload.h                        | 1 +
 include/net/sch_generic.h                         | 1 +
 net/sched/cls_api.c                               | 6 ++++++
 5 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7fdea6479ff6..8abdef1f8470 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3469,10 +3469,12 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct flow_block_offload *f = type_data;
 
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK:
+		f->unlocked_driver_cb = true;
 		return flow_block_cb_setup_simple(type_data,
 						  &mlx5e_block_cb_list,
 						  mlx5e_setup_tc_block_cb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3c0d36b2b91c..e7ac6233037d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -763,6 +763,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
+	f->unlocked_driver_cb = true;
 	f->driver_block_list = &mlx5e_block_cb_list;
 
 	switch (f->command) {
@@ -1245,9 +1246,11 @@ static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct flow_block_offload *f = type_data;
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
+		f->unlocked_driver_cb = true;
 		return flow_block_cb_setup_simple(type_data,
 						  &mlx5e_rep_block_cb_list,
 						  mlx5e_rep_setup_tc_cb,
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 757fa84de654..fc881875f856 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -284,6 +284,7 @@ struct flow_block_offload {
 	enum flow_block_command command;
 	enum flow_block_binder_type binder_type;
 	bool block_shared;
+	bool unlocked_driver_cb;
 	struct net *net;
 	struct flow_block *block;
 	struct list_head cb_list;
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 4ad43335cae5..d0c282e3630b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -408,6 +408,7 @@ struct tcf_block {
 	bool keep_dst;
 	atomic_t offloadcnt; /* Number of oddloaded filters */
 	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
+	unsigned int lockeddevcnt; /* Number of devs that require rtnl lock. */
 	struct {
 		struct tcf_chain *chain;
 		struct list_head filter_chain_list;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d8ef7a9e6906..02a547aa77c0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1418,6 +1418,8 @@ static int tcf_block_bind(struct tcf_block *block,
 						  bo->extack);
 		if (err)
 			goto err_unroll;
+		if (!bo->unlocked_driver_cb)
+			block->lockeddevcnt++;
 
 		i++;
 	}
@@ -1433,6 +1435,8 @@ static int tcf_block_bind(struct tcf_block *block,
 						    block_cb->cb_priv, false,
 						    tcf_block_offload_in_use(block),
 						    NULL);
+			if (!bo->unlocked_driver_cb)
+				block->lockeddevcnt--;
 		}
 		flow_block_cb_free(block_cb);
 	}
@@ -1454,6 +1458,8 @@ static void tcf_block_unbind(struct tcf_block *block,
 					    NULL);
 		list_del(&block_cb->list);
 		flow_block_cb_free(block_cb);
+		if (!bo->unlocked_driver_cb)
+			block->lockeddevcnt--;
 	}
 }
 
-- 
2.21.0

