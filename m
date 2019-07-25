Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA2574A7F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbfGYJzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:55:45 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18612 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfGYJzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 05:55:44 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9F7D341D89;
        Thu, 25 Jul 2019 17:55:39 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] flow_offload: Support get tcf block immediately
Date:   Thu, 25 Jul 2019 17:55:32 +0800
Message-Id: <1564048533-27283-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUNKS0tLS0pDSkpCQ0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRg6Pio4TTg2TVY2QjgoMx8e
        LUowChlVSlVKTk1PS09DTkhCTElKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9JS083Bg++
X-HM-Tid: 0a6c288ec0132086kuqy9f7d341d89
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

It provide a callback to find the tcf block in
the flow_indr_block_dev_get

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/flow_offload.h |  4 ++++
 net/core/flow_offload.c    | 12 ++++++++++++
 net/sched/cls_api.c        | 31 +++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 373028e..0ebb7e1 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -371,6 +371,10 @@ struct flow_indr_block_dev {
 	void *block;
 };
 
+typedef void flow_indr_get_default_block_t(struct flow_indr_block_dev *indr_dev);
+
+void flow_indr_set_default_block_cb(flow_indr_get_default_block_t *cb);
+
 struct flow_indr_block_dev *flow_indr_block_dev_lookup(struct net_device *dev);
 
 int flow_indr_rhashtable_init(void);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 77e18dc..6aa02b5 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -298,6 +298,14 @@ struct flow_indr_block_dev *
 }
 EXPORT_SYMBOL(flow_indr_block_dev_lookup);
 
+static flow_indr_get_default_block_t *flow_indr_get_default_block;
+
+void flow_indr_set_default_block_cb(flow_indr_get_default_block_t *cb)
+{
+	flow_indr_get_default_block = cb;
+}
+EXPORT_SYMBOL(flow_indr_set_default_block_cb);
+
 static struct flow_indr_block_dev *flow_indr_block_dev_get(struct net_device *dev)
 {
 	struct flow_indr_block_dev *indr_dev;
@@ -312,6 +320,10 @@ static struct flow_indr_block_dev *flow_indr_block_dev_get(struct net_device *de
 
 	INIT_LIST_HEAD(&indr_dev->cb_list);
 	indr_dev->dev = dev;
+
+	if (flow_indr_get_default_block)
+		flow_indr_get_default_block(indr_dev);
+
 	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
 				   flow_indr_setup_block_ht_params)) {
 		kfree(indr_dev);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 359d92f..e64a0d2 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -571,6 +571,35 @@ static void tc_indr_block_ing_cmd(struct net_device *dev, void *block,
 	tcf_block_setup(t_block, &bo);
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
+static void tc_indr_get_default_block(struct flow_indr_block_dev *indr_dev)
+{
+	indr_dev->block = tc_dev_ingress_block(indr_dev->dev);
+	if (indr_dev->block)
+		indr_dev->cmd_cb = tc_indr_block_ing_cmd;
+}
+
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
 			       enum flow_block_command command,
@@ -3143,6 +3172,8 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_rhash_setup_block_ht;
 
+	flow_indr_set_default_block_cb(tc_indr_get_default_block);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
1.8.3.1

