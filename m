Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1167D382
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfHADED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:04:03 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:40189 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbfHADEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 23:04:02 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7B33E417B1;
        Thu,  1 Aug 2019 11:03:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        jakub.kicinski@netronome.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v5 5/6] flow_offload: support get flow_block immediately
Date:   Thu,  1 Aug 2019 11:03:46 +0800
Message-Id: <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSE5CS0tLS0NNTENPSE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MSo6Txw4SjgxPkgiKzADEBk2
        P0IwFBZVSlVKTk1PTUlDTUlCTkJOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1IQk83Bg++
X-HM-Tid: 0a6c4b2238232086kuqy7b33e417b1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The new flow-indr-block can't get the tcf_block
directly. It provide a callback list to find the flow_block immediately
when the device register and contain a ingress block.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v5: add get_block_cb_list for both nft and tc

 include/net/flow_offload.h | 17 +++++++++++++++++
 net/core/flow_offload.c    | 33 +++++++++++++++++++++++++++++++++
 net/sched/cls_api.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c8d60a6..db04e3f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -376,6 +376,23 @@ typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
 				       void *cb_priv,
 				       enum flow_block_command command);
 
+struct flow_indr_block_info {
+	struct flow_block *flow_block;
+	flow_indr_block_ing_cmd_t *ing_cmd_cb;
+};
+
+typedef bool flow_indr_get_default_block_t(struct net_device *dev,
+					    struct flow_indr_block_info *info);
+
+struct flow_indr_get_block_entry {
+	flow_indr_get_default_block_t *get_block_cb;
+	struct list_head	list;
+};
+
+void flow_indr_add_default_block_cb(struct flow_indr_get_block_entry *entry);
+
+void flow_indr_del_default_block_cb(struct flow_indr_get_block_entry *entry);
+
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				  flow_indr_block_bind_cb_t *cb,
 				  void *cb_ident);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index a1fdfa4..8ff7a75b 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -282,6 +282,8 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 }
 EXPORT_SYMBOL(flow_block_cb_setup_simple);
 
+static LIST_HEAD(get_default_block_cb_list);
+
 static struct rhashtable indr_setup_block_ht;
 
 struct flow_indr_block_cb {
@@ -313,6 +315,24 @@ struct flow_indr_block_dev {
 				      flow_indr_setup_block_ht_params);
 }
 
+static void flow_get_default_block(struct flow_indr_block_dev *indr_dev)
+{
+	struct flow_indr_get_block_entry *entry_cb;
+	struct flow_indr_block_info info;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(entry_cb, &get_default_block_cb_list, list) {
+		if (entry_cb->get_block_cb(indr_dev->dev, &info)) {
+			indr_dev->flow_block = info.flow_block;
+			indr_dev->ing_cmd_cb = info.ing_cmd_cb;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+}
+
 static struct flow_indr_block_dev *
 flow_indr_block_dev_get(struct net_device *dev)
 {
@@ -328,6 +348,7 @@ struct flow_indr_block_dev {
 
 	INIT_LIST_HEAD(&indr_dev->cb_list);
 	indr_dev->dev = dev;
+	flow_get_default_block(indr_dev);
 	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
 				   flow_indr_setup_block_ht_params)) {
 		kfree(indr_dev);
@@ -492,6 +513,18 @@ void flow_indr_block_call(struct flow_block *flow_block,
 }
 EXPORT_SYMBOL_GPL(flow_indr_block_call);
 
+void flow_indr_add_default_block_cb(struct flow_indr_get_block_entry *entry)
+{
+	list_add_tail_rcu(&entry->list, &get_default_block_cb_list);
+}
+EXPORT_SYMBOL_GPL(flow_indr_add_default_block_cb);
+
+void flow_indr_del_default_block_cb(struct flow_indr_get_block_entry *entry)
+{
+	list_del_rcu(&entry->list);
+}
+EXPORT_SYMBOL_GPL(flow_indr_del_default_block_cb);
+
 static int __init init_flow_indr_rhashtable(void)
 {
 	return rhashtable_init(&indr_setup_block_ht,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bd5e591..8bf918c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -576,6 +576,43 @@ static void tc_indr_block_ing_cmd(struct net_device *dev,
 	tcf_block_setup(block, &bo);
 }
 
+static struct tcf_block *tc_dev_ingress_block(struct net_device *dev)
+{
+	const struct Qdisc_class_ops *cops;
+	struct Qdisc *qdisc;
+
+	if (!dev_ingress_queue(dev))
+		return NULL;
+
+	qdisc = dev_ingress_queue(dev)->qdisc_sleeping;
+	if (!qdisc)
+		return NULL;
+
+	cops = qdisc->ops->cl_ops;
+	if (!cops)
+		return NULL;
+
+	if (!cops->tcf_block)
+		return NULL;
+
+	return cops->tcf_block(qdisc, TC_H_MIN_INGRESS, NULL);
+}
+
+static bool tc_indr_get_default_block(struct net_device *dev,
+				      struct flow_indr_block_info *info)
+{
+	struct tcf_block *block = tc_dev_ingress_block(dev);
+
+	if (block) {
+		info->flow_block = &block->flow_block;
+		info->ing_cmd_cb = tc_indr_block_ing_cmd;
+
+		return true;
+	}
+
+	return false;
+}
+
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
 			       enum flow_block_command command,
@@ -3146,6 +3183,11 @@ static void __net_exit tcf_net_exit(struct net *net)
 	.size = sizeof(struct tcf_net),
 };
 
+static struct flow_indr_get_block_entry get_block_entry = {
+	.get_block_cb = tc_indr_get_default_block,
+	.list = LIST_HEAD_INIT(get_block_entry.list),
+};
+
 static int __init tc_filter_init(void)
 {
 	int err;
@@ -3158,6 +3200,8 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
+	flow_indr_add_default_block_cb(&get_block_entry);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
1.8.3.1

