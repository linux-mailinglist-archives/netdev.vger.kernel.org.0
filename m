Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79549B663
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405958AbfHWSv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:51:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44592 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390915AbfHWSv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:51:26 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Aug 2019 21:51:20 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7NIpJEI012807;
        Fri, 23 Aug 2019 21:51:19 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 07/10] net: sched: take rtnl lock in tc_setup_flow_action()
Date:   Fri, 23 Aug 2019 21:50:53 +0300
Message-Id: <20190823185056.12536-8-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823185056.12536-1-vladbu@mellanox.com>
References: <20190823185056.12536-1-vladbu@mellanox.com>
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
index 612232492f67..a48824bc1489 100644
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
index f2dcecf34c6f..cb835d581b77 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3261,14 +3261,17 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 EXPORT_SYMBOL(tc_setup_cb_reoffload);
 
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
@@ -3313,6 +3316,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->vlan.prio = tcf_vlan_push_prio(act);
 				break;
 			default:
+				err = -EOPNOTSUPP;
 				goto err_out;
 			}
 		} else if (is_tcf_tunnel_set(act)) {
@@ -3330,6 +3334,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 					entry->id = FLOW_ACTION_ADD;
 					break;
 				default:
+					err = -EOPNOTSUPP;
 					goto err_out;
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
@@ -3388,15 +3393,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
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
index 9a7fd6bcd0a5..d47d4e84d4e5 100644
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
@@ -1819,7 +1820,8 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts,
+					   true);
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 7801851b55d5..d53d81dfee03 100644
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

