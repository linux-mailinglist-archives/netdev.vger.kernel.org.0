Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB51D1FF24C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgFRMtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:49:22 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:6107 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgFRMtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 08:49:20 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1042C415F1;
        Thu, 18 Jun 2020 20:49:14 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com,
        simon.horman@netronome.com
Subject: [PATCH net v5 2/4] flow_offload: use flow_indr_block_cb_alloc/remove function
Date:   Thu, 18 Jun 2020 20:49:09 +0800
Message-Id: <1592484551-16188-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
References: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlIS0tLSk1DQ0tLSE5ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw*SC8RDTEiDg8eLyMwPzocVlZVSUpDTU0oSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MUk6Njo5Cjg#TjQRHEMoHTkt
        MAsaCTBVSlVKTkJJT0NPTk5PSUtKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpKSEhLNwY+
X-HM-Tid: 0a72c779e5652086kuqy1042c415f1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Prepare fix the bug in the next patch. use flow_indr_block_cb_alloc/remove
function and remove the __flow_block_indr_binding.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       | 19 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    | 21 ++++++++++++++-------
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  4 +++-
 .../net/ethernet/netronome/nfp/flower/offload.c    | 18 +++++++++++-------
 include/net/flow_offload.h                         |  4 +++-
 net/core/flow_offload.c                            | 22 +---------------------
 6 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0eef4f5..3e3a884 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1889,7 +1889,8 @@ static void bnxt_tc_setup_indr_rel(void *cb_priv)
 }
 
 static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
-				    struct flow_block_offload *f)
+				    struct flow_block_offload *f, void *data,
+				    void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct bnxt_flower_indr_block_cb_priv *cb_priv;
 	struct flow_block_cb *block_cb;
@@ -1907,9 +1908,10 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 		cb_priv->bp = bp;
 		list_add(&cb_priv->list, &bp->tc_indr_block_list);
 
-		block_cb = flow_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
-					       cb_priv, cb_priv,
-					       bnxt_tc_setup_indr_rel);
+		block_cb = flow_indr_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
+						    cb_priv, cb_priv,
+						    bnxt_tc_setup_indr_rel, f,
+						    netdev, data, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
@@ -1930,7 +1932,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 		if (!block_cb)
 			return -ENOENT;
 
-		flow_block_cb_remove(block_cb, f);
+		flow_indr_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
 		break;
 	default:
@@ -1945,14 +1947,17 @@ static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
 }
 
 static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
-				 enum tc_setup_type type, void *type_data)
+				 enum tc_setup_type type, void *type_data,
+				 void *data,
+				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	if (!bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data);
+		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data, data,
+						cleanup);
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 80713123..d629864 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -407,7 +407,9 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 mlx5e_rep_indr_setup_block(struct net_device *netdev,
 			   struct mlx5e_rep_priv *rpriv,
 			   struct flow_block_offload *f,
-			   flow_setup_cb_t *setup_cb)
+			   flow_setup_cb_t *setup_cb,
+			   void *data,
+			   void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 	struct mlx5e_rep_indr_block_priv *indr_priv;
@@ -438,8 +440,9 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
-					       mlx5e_rep_indr_block_unbind);
+		block_cb = flow_indr_block_cb_alloc(setup_cb, indr_priv, indr_priv,
+						    mlx5e_rep_indr_block_unbind,
+						    f, netdev, data, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
@@ -458,7 +461,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 		if (!block_cb)
 			return -ENOENT;
 
-		flow_block_cb_remove(block_cb, f);
+		flow_indr_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
 		return 0;
 	default:
@@ -469,15 +472,19 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 
 static
 int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
-			    enum tc_setup_type type, void *type_data)
+			    enum tc_setup_type type, void *type_data,
+			    void *data,
+			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
-						  mlx5e_rep_indr_setup_tc_cb);
+						  mlx5e_rep_indr_setup_tc_cb,
+						  data, cleanup);
 	case TC_SETUP_FT:
 		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
-						  mlx5e_rep_indr_setup_ft_cb);
+						  mlx5e_rep_indr_setup_ft_cb,
+						  data, cleanup);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 6c3dc3b..56b3b68 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -459,7 +459,9 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 				 struct tc_cls_matchall_offload *flow);
 void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
 int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
-				enum tc_setup_type type, void *type_data);
+				enum tc_setup_type type, void *type_data,
+				void *data,
+				void (*cleanup)(struct flow_block_cb *block_cb));
 int nfp_flower_setup_indr_block_cb(enum tc_setup_type type, void *type_data,
 				   void *cb_priv);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 695d24b9..95c7525 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1647,7 +1647,8 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 
 static int
 nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
-			       struct flow_block_offload *f)
+			       struct flow_block_offload *f, void *data,
+			       void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
@@ -1676,9 +1677,10 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		block_cb = flow_block_cb_alloc(nfp_flower_setup_indr_block_cb,
-					       cb_priv, cb_priv,
-					       nfp_flower_setup_indr_tc_release);
+		block_cb = flow_indr_block_cb_alloc(nfp_flower_setup_indr_block_cb,
+						    cb_priv, cb_priv,
+						    nfp_flower_setup_indr_tc_release,
+						    f, netdev, data, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
@@ -1699,7 +1701,7 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 		if (!block_cb)
 			return -ENOENT;
 
-		flow_block_cb_remove(block_cb, f);
+		flow_indr_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
 		return 0;
 	default:
@@ -1710,7 +1712,9 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 
 int
 nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
-			    enum tc_setup_type type, void *type_data)
+			    enum tc_setup_type type, void *type_data,
+			    void *data,
+			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
@@ -1718,7 +1722,7 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return nfp_flower_setup_indr_tc_block(netdev, cb_priv,
-						      type_data);
+						      type_data, data, cleanup);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index bf43430..1961c79 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -545,7 +545,9 @@ static inline void flow_block_init(struct flow_block *flow_block)
 }
 
 typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
-				      enum tc_setup_type type, void *type_data);
+				      enum tc_setup_type type, void *type_data,
+				      void *data,
+				      void (*cleanup)(struct flow_block_cb *block_cb));
 
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 1fd781d..ddd958c 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -458,25 +458,6 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(flow_indr_block_cb_alloc);
 
-static void __flow_block_indr_binding(struct flow_block_offload *bo,
-				      struct net_device *dev, void *data,
-				      void (*cleanup)(struct flow_block_cb *block_cb))
-{
-	struct flow_block_cb *block_cb;
-
-	list_for_each_entry(block_cb, &bo->cb_list, list) {
-		switch (bo->command) {
-		case FLOW_BLOCK_BIND:
-			flow_block_indr_init(block_cb, bo, dev, data, cleanup);
-			list_add(&block_cb->indr.list, &flow_block_indr_list);
-			break;
-		case FLOW_BLOCK_UNBIND:
-			list_del(&block_cb->indr.list);
-			break;
-		}
-	}
-}
-
 int flow_indr_dev_setup_offload(struct net_device *dev,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
@@ -486,9 +467,8 @@ int flow_indr_dev_setup_offload(struct net_device *dev,
 
 	mutex_lock(&flow_indr_block_lock);
 	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, this->cb_priv, type, bo);
+		this->cb(dev, this->cb_priv, type, bo, data, cleanup);
 
-	__flow_block_indr_binding(bo, dev, data, cleanup);
 	mutex_unlock(&flow_indr_block_lock);
 
 	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
-- 
1.8.3.1

