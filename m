Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD9777E57
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 08:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfG1Gw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 02:52:57 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:1507 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfG1Gw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 02:52:57 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0FCD9416E3;
        Sun, 28 Jul 2019 14:52:50 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v4 2/3] flow_offload: Support get default block from tc immediately
Date:   Sun, 28 Jul 2019 14:52:48 +0800
Message-Id: <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS09NQkJCQ0pJSklNSk1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PxQ6NBw4MTg5HEoVIhciKx8V
        OhkKCzNVSlVKTk1PSUJNTExLSklNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9KSUw3Bg++
X-HM-Tid: 0a6c375a72232086kuqy0fcd9416e3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When thre indr device register, it can get the default block
from tc immediately if the block is exist.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: no change
v4: get tc default block without callback

 include/net/pkt_cls.h   |  7 +++++++
 net/core/flow_offload.c |  2 ++
 net/sched/cls_api.c     | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 0790a4e..77c3a42 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -54,6 +54,8 @@ int tcf_block_get_ext(struct tcf_block **p_block, struct Qdisc *q,
 void tcf_block_put_ext(struct tcf_block *block, struct Qdisc *q,
 		       struct tcf_block_ext_info *ei);
 
+void tc_indr_get_default_block(struct flow_indr_block_dev *indr_dev);
+
 static inline bool tcf_block_shared(struct tcf_block *block)
 {
 	return block->index;
@@ -74,6 +76,11 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		 struct tcf_result *res, bool compat_mode);
 
 #else
+static inline
+void tc_indr_get_default_block(struct flow_indr_block_dev *indr_dev)
+{
+}
+
 static inline bool tcf_block_shared(struct tcf_block *block)
 {
 	return false;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 9f1ae67..0ca3d51 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -3,6 +3,7 @@
 #include <linux/slab.h>
 #include <net/flow_offload.h>
 #include <linux/rtnetlink.h>
+#include <net/pkt_cls.h>
 
 struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 {
@@ -312,6 +313,7 @@ static struct flow_indr_block_dev *flow_indr_block_dev_get(struct net_device *de
 
 	INIT_LIST_HEAD(&indr_dev->cb_list);
 	indr_dev->dev = dev;
+	tc_indr_get_default_block(indr_dev);
 	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
 				   flow_indr_setup_block_ht_params)) {
 		kfree(indr_dev);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d551c56..59e9572 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -576,6 +576,39 @@ static void tc_indr_block_ing_cmd(struct net_device *dev,
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
+void tc_indr_get_default_block(struct flow_indr_block_dev *indr_dev)
+{
+	struct tcf_block *block = tc_dev_ingress_block(indr_dev->dev);
+
+	if (block) {
+		indr_dev->flow_block = &block->flow_block;
+		indr_dev->ing_cmd_cb = tc_indr_block_ing_cmd;
+	}
+}
+EXPORT_SYMBOL(tc_indr_get_default_block);
+
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
 			       enum flow_block_command command,
-- 
1.8.3.1

