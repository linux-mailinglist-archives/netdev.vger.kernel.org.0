Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F1A9D0E5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732122AbfHZNp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:45:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52965 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732050AbfHZNpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:45:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 16:45:15 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QDjEFW000366;
        Mon, 26 Aug 2019 16:45:15 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 08/10] net: sched: take reference to action dev before calling offloads
Date:   Mon, 26 Aug 2019 16:45:04 +0300
Message-Id: <20190826134506.9705-9-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to remove dependency on rtnl lock when calling hardware offload
API, take reference to action mirred dev when initializing flow_action
structure in tc_setup_flow_action(). Implement function
tc_cleanup_flow_action(), use it to release the device after hardware
offload API is done using it.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h  |  2 ++
 net/sched/cls_api.c    | 32 ++++++++++++++++++++++++++++++++
 net/sched/cls_flower.c |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a48824bc1489..e553fc80eb23 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -505,6 +505,8 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts, bool rtnl_held);
+void tc_cleanup_flow_action(struct flow_action *flow_action);
+
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held);
 int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 8751bb8a682f..d988737693e4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3265,6 +3265,27 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 }
 EXPORT_SYMBOL(tc_setup_cb_reoffload);
 
+void tc_cleanup_flow_action(struct flow_action *flow_action)
+{
+	struct flow_action_entry *entry;
+	int i;
+
+	flow_action_for_each(i, entry, flow_action) {
+		switch (entry->id) {
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_MIRRED:
+		case FLOW_ACTION_REDIRECT_INGRESS:
+		case FLOW_ACTION_MIRRED_INGRESS:
+			if (entry->dev)
+				dev_put(entry->dev);
+			break;
+		default:
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(tc_cleanup_flow_action);
+
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts, bool rtnl_held)
 {
@@ -3294,15 +3315,23 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		} else if (is_tcf_mirred_egress_redirect(act)) {
 			entry->id = FLOW_ACTION_REDIRECT;
 			entry->dev = tcf_mirred_dev(act);
+			if (entry->dev)
+				dev_hold(entry->dev);
 		} else if (is_tcf_mirred_egress_mirror(act)) {
 			entry->id = FLOW_ACTION_MIRRED;
 			entry->dev = tcf_mirred_dev(act);
+			if (entry->dev)
+				dev_hold(entry->dev);
 		} else if (is_tcf_mirred_ingress_redirect(act)) {
 			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
 			entry->dev = tcf_mirred_dev(act);
+			if (entry->dev)
+				dev_hold(entry->dev);
 		} else if (is_tcf_mirred_ingress_mirror(act)) {
 			entry->id = FLOW_ACTION_MIRRED_INGRESS;
 			entry->dev = tcf_mirred_dev(act);
+			if (entry->dev)
+				dev_hold(entry->dev);
 		} else if (is_tcf_vlan(act)) {
 			switch (tcf_vlan_action(act)) {
 			case TCA_VLAN_ACT_PUSH:
@@ -3410,6 +3439,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	if (!rtnl_held)
 		rtnl_unlock();
 
+	if (err)
+		tc_cleanup_flow_action(flow_action);
+
 	return err;
 }
 EXPORT_SYMBOL(tc_setup_flow_action);
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index fb305bd45d93..2852fe6f50d2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -465,6 +465,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
 			      skip_sw, &f->flags, &f->in_hw_count, true);
+	tc_cleanup_flow_action(&cls_flower.rule->action);
 	kfree(cls_flower.rule);
 
 	if (err) {
@@ -1838,6 +1839,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 					    TC_SETUP_CLSFLOWER, &cls_flower,
 					    cb_priv, &f->flags,
 					    &f->in_hw_count);
+		tc_cleanup_flow_action(&cls_flower.rule->action);
 		kfree(cls_flower.rule);
 
 		if (err) {
-- 
2.21.0

