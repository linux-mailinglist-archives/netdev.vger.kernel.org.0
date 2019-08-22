Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4747199412
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbfHVMoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:44:18 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44444 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387892AbfHVMoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:44:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 15:44:11 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MCiAoo025522;
        Thu, 22 Aug 2019 15:44:11 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 07/10] net: sched: take rtnl lock in tc_setup_flow_action()
Date:   Thu, 22 Aug 2019 15:43:50 +0300
Message-Id: <20190822124353.16902-8-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822124353.16902-1-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow using new flow_action infrastructure from unlocked
classifiers, modify tc_setup_flow_action() to accept new 'rtnl_held'
argument. Take rtnl lock before accessing tc_action data. This is necessary
to protect from concurrent action replace.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h    |  2 +-
 net/sched/cls_api.c      | 17 +++++++++++++----
 net/sched/cls_flower.c   |  6 ++++--
 net/sched/cls_matchall.c |  4 ++--
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a5937fb3c4b2..4d861426507c 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -504,7 +504,7 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 }
 
 int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts);
+			 const struct tcf_exts *exts, bool rtnl_held);
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held);
 int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bda42f1b5514..31680493b2b1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3245,14 +3245,17 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 EXPORT_SYMBOL(tc_setup_cb_destroy);
 
 int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+			 const struct tcf_exts *exts, bool rtnl_held)
 {
 	const struct tc_action *act;
-	int i, j, k;
+	int i, j, k, err = 0;
 
 	if (!exts)
 		return 0;
 
+	if (!rtnl_held)
+		rtnl_lock();
+
 	j = 0;
 	tcf_exts_for_each_action(i, act, exts) {
 		struct flow_action_entry *entry;
@@ -3297,6 +3300,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->vlan.prio = tcf_vlan_push_prio(act);
 				break;
 			default:
+				err = -EOPNOTSUPP;
 				goto err_out;
 			}
 		} else if (is_tcf_tunnel_set(act)) {
@@ -3314,6 +3318,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 					entry->id = FLOW_ACTION_ADD;
 					break;
 				default:
+					err = -EOPNOTSUPP;
 					goto err_out;
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
@@ -3372,15 +3377,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->id = FLOW_ACTION_PTYPE;
 			entry->ptype = tcf_skbedit_ptype(act);
 		} else {
+			err = -EOPNOTSUPP;
 			goto err_out;
 		}
 
 		if (!is_tcf_pedit(act))
 			j++;
 	}
-	return 0;
+
 err_out:
-	return -EOPNOTSUPP;
+	if (!rtnl_held)
+		rtnl_unlock();
+
+	return err;
 }
 EXPORT_SYMBOL(tc_setup_flow_action);
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index cd1686a5abe7..006759b9c78a 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -452,7 +452,8 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
-	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts,
+				   true);
 	if (err) {
 		kfree(cls_flower.rule);
 		if (skip_sw)
@@ -1821,7 +1822,8 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts,
+					   true);
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index d38e329d71bd..52e6ef7538b7 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -97,7 +97,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts, true);
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
@@ -300,7 +300,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts, true);
 	if (err) {
 		kfree(cls_mall.rule);
 		if (add && tc_skip_sw(head->flags)) {
-- 
2.21.0

