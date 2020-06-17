Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BB51FD2E9
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgFQQzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:55:14 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:61196 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgFQQzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 12:55:14 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BA5804160F;
        Thu, 18 Jun 2020 00:55:09 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com,
        simon.horman@netronome.com
Subject: [PATCH net v4 1/4] flow_offload: add flow_indr_block_cb_alloc/remove function
Date:   Thu, 18 Jun 2020 00:55:04 +0800
Message-Id: <1592412907-3856-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
References: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0hIS0tLSkpKTkxCQllXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWRcyNQs4HDojIwENDygOCx4PUANQOhxWVlVJTUJOSihJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mxw6Pgw*NjgwMzU0Sy8OHRwR
        SDMaFDNVSlVKTkJJT0pJQktCQ01IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9NTUM3Bg++
X-HM-Tid: 0a72c334b0d52086kuqyba5804160f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add flow_indr_block_cb_alloc/remove function prepare for the bug fix
in the third patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/flow_offload.h | 13 +++++++++++++
 net/core/flow_offload.c    | 43 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f2c8311..bf43430 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -467,6 +467,12 @@ struct flow_block_cb {
 struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv));
+struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
+					       void *cb_ident, void *cb_priv,
+					       void (*release)(void *cb_priv),
+					       struct flow_block_offload *bo,
+					       struct net_device *dev, void *data,
+					       void (*cleanup)(struct flow_block_cb *block_cb));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
 
 struct flow_block_cb *flow_block_cb_lookup(struct flow_block *block,
@@ -488,6 +494,13 @@ static inline void flow_block_cb_remove(struct flow_block_cb *block_cb,
 	list_move(&block_cb->list, &offload->cb_list);
 }
 
+static inline void flow_indr_block_cb_remove(struct flow_block_cb *block_cb,
+					     struct flow_block_offload *offload)
+{
+	list_del(&block_cb->indr.list);
+	list_move(&block_cb->list, &offload->cb_list);
+}
+
 bool flow_block_cb_is_busy(flow_setup_cb_t *cb, void *cb_ident,
 			   struct list_head *driver_block_list);
 
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 0cfc35e..9fe4b58 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -329,6 +329,38 @@ struct flow_indr_dev {
 	struct rcu_head			rcu;
 };
 
+static void flow_block_indr_init(struct flow_block_cb *flow_block,
+				 struct flow_block_offload *bo,
+				 struct net_device *dev, void *data,
+				 void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	flow_block->indr.binder_type = bo->binder_type;
+	flow_block->indr.data = data;
+	flow_block->indr.dev = dev;
+	flow_block->indr.cleanup = cleanup;
+}
+
+struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
+					       void *cb_ident, void *cb_priv,
+					       void (*release)(void *cb_priv),
+					       struct flow_block_offload *bo,
+					       struct net_device *dev, void *data,
+					       void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	struct flow_block_cb *block_cb;
+
+	block_cb = flow_block_cb_alloc(cb, cb_ident, cb_priv, release);
+	if (IS_ERR(block_cb))
+		goto out;
+
+	flow_block_indr_init(block_cb, bo, dev, data, cleanup);
+	list_add(&block_cb->indr.list, &flow_block_indr_list);
+
+out:
+	return block_cb;
+}
+EXPORT_SYMBOL(flow_indr_block_cb_alloc);
+
 static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
 						 void *cb_priv)
 {
@@ -426,17 +458,6 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 }
 EXPORT_SYMBOL(flow_indr_dev_unregister);
 
-static void flow_block_indr_init(struct flow_block_cb *flow_block,
-				 struct flow_block_offload *bo,
-				 struct net_device *dev, void *data,
-				 void (*cleanup)(struct flow_block_cb *block_cb))
-{
-	flow_block->indr.binder_type = bo->binder_type;
-	flow_block->indr.data = data;
-	flow_block->indr.dev = dev;
-	flow_block->indr.cleanup = cleanup;
-}
-
 static void __flow_block_indr_binding(struct flow_block_offload *bo,
 				      struct net_device *dev, void *data,
 				      void (*cleanup)(struct flow_block_cb *block_cb))
-- 
1.8.3.1

