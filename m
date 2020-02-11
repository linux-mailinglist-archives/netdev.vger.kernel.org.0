Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E1158BB4
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgBKJTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:19:45 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50234 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727806AbgBKJTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 04:19:44 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Feb 2020 11:19:37 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01B9Jbgx031153;
        Tue, 11 Feb 2020 11:19:37 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 4/4] net: sched: don't take rtnl lock during flow_action setup
Date:   Tue, 11 Feb 2020 11:19:18 +0200
Message-Id: <20200211091918.20974-5-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200211091918.20974-1-vladbu@mellanox.com>
References: <20200211091918.20974-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor tc_setup_flow_action() function not to use rtnl lock and remove
'rtnl_held' argument that is no longer needed.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h    | 2 +-
 net/sched/cls_api.c      | 8 +-------
 net/sched/cls_flower.c   | 6 ++----
 net/sched/cls_matchall.c | 4 ++--
 4 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a972244ab193..53946b509b51 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -509,7 +509,7 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 }
 
 int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts, bool rtnl_held);
+			 const struct tcf_exts *exts);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 610505117780..13c33eaf1ca1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3433,7 +3433,7 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 }
 
 int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts, bool rtnl_held)
+			 const struct tcf_exts *exts)
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3441,9 +3441,6 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	if (!exts)
 		return 0;
 
-	if (!rtnl_held)
-		rtnl_lock();
-
 	j = 0;
 	tcf_exts_for_each_action(i, act, exts) {
 		struct flow_action_entry *entry;
@@ -3577,9 +3574,6 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	}
 
 err_out:
-	if (!rtnl_held)
-		rtnl_unlock();
-
 	if (err)
 		tc_cleanup_flow_action(flow_action);
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f9c0d1e8d380..d7d3aab53120 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -449,8 +449,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
-	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts,
-				   rtnl_held);
+	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
 	if (err) {
 		kfree(cls_flower.rule);
 		if (skip_sw) {
@@ -1999,8 +1998,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts,
-					   true);
+		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 039cc86974f4..bf2d42ee55a3 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -97,7 +97,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts, true);
+	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
@@ -301,7 +301,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts, true);
+	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
 		if (add && tc_skip_sw(head->flags)) {
-- 
2.21.0

