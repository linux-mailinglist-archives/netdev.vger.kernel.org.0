Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640681FF24D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgFRMt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:49:28 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:6093 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbgFRMtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 08:49:23 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E6E1941405;
        Thu, 18 Jun 2020 20:49:13 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com,
        simon.horman@netronome.com
Subject: [PATCH net v5 1/4] flow_offload: add flow_indr_block_cb_alloc/remove function
Date:   Thu, 18 Jun 2020 20:49:08 +0800
Message-Id: <1592484551-16188-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
References: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJIS0tLSkJMT0pLTkNZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw6FRckHTEiDg8eLzQoPzocVlZVQ0lOKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTo6Gjo5OTg5SjQrDEIfHStI
        MTMaCTVVSlVKTkJJT0NPTk5PS09PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhNTU03Bg++
X-HM-Tid: 0a72c779e4ec2086kuqye6e1941405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add flow_indr_block_cb_alloc/remove function for next fix patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/flow_offload.h | 13 +++++++++++++
 net/core/flow_offload.c    | 21 +++++++++++++++++++++
 2 files changed, 34 insertions(+)

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
index 0cfc35e..1fd781d 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -437,6 +437,27 @@ static void flow_block_indr_init(struct flow_block_cb *flow_block,
 	flow_block->indr.cleanup = cleanup;
 }
 
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
 static void __flow_block_indr_binding(struct flow_block_offload *bo,
 				      struct net_device *dev, void *data,
 				      void (*cleanup)(struct flow_block_cb *block_cb))
-- 
1.8.3.1

