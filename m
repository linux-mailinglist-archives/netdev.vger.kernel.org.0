Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3265680B21
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 15:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfHDNYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 09:24:16 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:8305 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfHDNYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 09:24:16 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9B5CB41614;
        Sun,  4 Aug 2019 21:24:02 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jakub.kicinski@netronome.com, jiri@resnulli.us
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v6 5/6] flow_offload: support get multi-subsystem block
Date:   Sun,  4 Aug 2019 21:24:00 +0800
Message-Id: <1564925041-23530-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUhJS0tLSUhKTE9JQ01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDY6PRw4SDg#GE43EBo9KyNW
        MgMaCVFVSlVKTk1PQklOS09JTEtMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1NQ0k3Bg++
X-HM-Tid: 0a6c5ccd1fe02086kuqy9b5cb41614
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

It provide a callback list to find the blocks of tc
and nft subsystems

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: new patch

 include/net/flow_offload.h | 10 +++++++++-
 net/core/flow_offload.c    | 47 +++++++++++++++++++++++++++++++++-------------
 net/sched/cls_api.c        |  9 ++++++++-
 3 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 8f1a7b8..6022dd0 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -375,6 +375,15 @@ typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
 					void *cb_priv,
 					enum flow_block_command command);
 
+struct flow_indr_block_ing_entry {
+	flow_indr_block_ing_cmd_t *cb;
+	struct list_head	list;
+};
+
+void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry);
+
+void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry);
+
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				  flow_indr_block_bind_cb_t *cb,
 				  void *cb_ident);
@@ -391,7 +400,6 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
 				   void *cb_ident);
 
 void flow_indr_block_call(struct net_device *dev,
-			  flow_indr_block_ing_cmd_t *cb,
 			  struct flow_block_offload *bo,
 			  enum flow_block_command command);
 
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 4cc18e4..0e84537 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -282,6 +282,8 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 }
 EXPORT_SYMBOL(flow_block_cb_setup_simple);
 
+static LIST_HEAD(block_ing_cb_list);
+
 static struct rhashtable indr_setup_block_ht;
 
 struct flow_indr_block_cb {
@@ -295,7 +297,6 @@ struct flow_indr_block_dev {
 	struct rhash_head ht_node;
 	struct net_device *dev;
 	unsigned int refcnt;
-	flow_indr_block_ing_cmd_t  *block_ing_cmd_cb;
 	struct list_head cb_list;
 };
 
@@ -389,6 +390,22 @@ static void flow_indr_block_cb_del(struct flow_indr_block_cb *indr_block_cb)
 	kfree(indr_block_cb);
 }
 
+static void flow_block_ing_cmd(struct net_device *dev,
+			       flow_indr_block_bind_cb_t *cb,
+			       void *cb_priv,
+			       enum flow_block_command command)
+{
+	struct flow_indr_block_ing_entry *entry;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(entry, &block_ing_cb_list, list) {
+		entry->cb(dev, cb, cb_priv, command);
+	}
+
+	rcu_read_unlock();
+}
+
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				  flow_indr_block_bind_cb_t *cb,
 				  void *cb_ident)
@@ -406,10 +423,8 @@ int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 	if (err)
 		goto err_dev_put;
 
-	if (indr_dev->block_ing_cmd_cb)
-		indr_dev->block_ing_cmd_cb(dev, indr_block_cb->cb,
-					   indr_block_cb->cb_priv,
-					   FLOW_BLOCK_BIND);
+	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
+			   FLOW_BLOCK_BIND);
 
 	return 0;
 
@@ -448,10 +463,8 @@ void __flow_indr_block_cb_unregister(struct net_device *dev,
 	if (!indr_block_cb)
 		return;
 
-	if (indr_dev->block_ing_cmd_cb)
-		indr_dev->block_ing_cmd_cb(dev, indr_block_cb->cb,
-					   indr_block_cb->cb_priv,
-					   FLOW_BLOCK_UNBIND);
+	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
+			   FLOW_BLOCK_UNBIND);
 
 	flow_indr_block_cb_del(indr_block_cb);
 	flow_indr_block_dev_put(indr_dev);
@@ -469,7 +482,6 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
 EXPORT_SYMBOL_GPL(flow_indr_block_cb_unregister);
 
 void flow_indr_block_call(struct net_device *dev,
-			  flow_indr_block_ing_cmd_t cb,
 			  struct flow_block_offload *bo,
 			  enum flow_block_command command)
 {
@@ -480,15 +492,24 @@ void flow_indr_block_call(struct net_device *dev,
 	if (!indr_dev)
 		return;
 
-	indr_dev->block_ing_cmd_cb = command == FLOW_BLOCK_BIND
-				     ? cb : NULL;
-
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 				  bo);
 }
 EXPORT_SYMBOL_GPL(flow_indr_block_call);
 
+void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry)
+{
+	list_add_tail_rcu(&entry->list, &block_ing_cb_list);
+}
+EXPORT_SYMBOL_GPL(flow_indr_add_block_ing_cb);
+
+void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry)
+{
+	list_del_rcu(&entry->list);
+}
+EXPORT_SYMBOL_GPL(flow_indr_del_block_ing_cb);
+
 static int __init init_flow_indr_rhashtable(void)
 {
 	return rhashtable_init(&indr_setup_block_ht,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 939a5c0..f53478f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -621,7 +621,7 @@ static void tc_indr_block_call(struct tcf_block *block,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
-	flow_indr_block_call(dev, tc_indr_block_get_and_ing_cmd, &bo, command);
+	flow_indr_block_call(dev, &bo, command);
 	tcf_block_setup(block, &bo);
 }
 
@@ -3174,6 +3174,11 @@ static void __net_exit tcf_net_exit(struct net *net)
 	.size = sizeof(struct tcf_net),
 };
 
+static struct flow_indr_block_ing_entry block_ing_entry = {
+	.cb = tc_indr_block_get_and_ing_cmd,
+	.list = LIST_HEAD_INIT(block_ing_entry.list),
+};
+
 static int __init tc_filter_init(void)
 {
 	int err;
@@ -3186,6 +3191,8 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
+	flow_indr_add_block_ing_cb(&block_ing_entry);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
1.8.3.1

