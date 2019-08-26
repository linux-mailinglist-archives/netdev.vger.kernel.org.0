Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED81E9D0ED
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfHZNpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:45:38 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52964 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730502AbfHZNp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:45:26 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 16:45:15 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QDjEFV000366;
        Mon, 26 Aug 2019 16:45:15 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 07/10] net: sched: take rtnl lock in tc_setup_flow_action()
Date:   Mon, 26 Aug 2019 16:45:03 +0300
Message-Id: <20190826134506.9705-8-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
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
index 3c103cf9fd0d..8751bb8a682f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3266,14 +3266,17 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
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
@@ -3318,6 +3321,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->vlan.prio = tcf_vlan_push_prio(act);
 				break;
 			default:
+				err = -EOPNOTSUPP;
 				goto err_out;
 			}
 		} else if (is_tcf_tunnel_set(act)) {
@@ -3335,6 +3339,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 					entry->id = FLOW_ACTION_ADD;
 					break;
 				default:
+					err = -EOPNOTSUPP;
 					goto err_out;
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
@@ -3393,15 +3398,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
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
index 5cb694469b51..fb305bd45d93 100644
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
index 911d1ea28bb2..3266f25011cc 100644
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

