Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6479D0E7
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfHZNpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:45:32 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52987 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732059AbfHZNpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:45:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 16:45:15 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QDjEFY000366;
        Mon, 26 Aug 2019 16:45:15 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 10/10] net: sched: flower: don't take rtnl lock for cls hw offloads API
Date:   Mon, 26 Aug 2019 16:45:06 +0300
Message-Id: <20190826134506.9705-11-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't manually take rtnl lock in flower classifier before calling cls
hardware offloads API. Instead, pass rtnl lock status via 'rtnl_held'
parameter.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/cls_flower.c | 53 +++++++++++++-----------------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 2852fe6f50d2..74221e3351c3 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -412,18 +412,13 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 	struct tcf_block *block = tp->chain->block;
 	struct flow_cls_offload cls_flower = {};
 
-	if (!rtnl_held)
-		rtnl_lock();
-
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
 	cls_flower.command = FLOW_CLS_DESTROY;
 	cls_flower.cookie = (unsigned long) f;
 
 	tc_setup_cb_destroy(block, tp, TC_SETUP_CLSFLOWER, &cls_flower, false,
-			    &f->flags, &f->in_hw_count, true);
+			    &f->flags, &f->in_hw_count, rtnl_held);
 
-	if (!rtnl_held)
-		rtnl_unlock();
 }
 
 static int fl_hw_replace_filter(struct tcf_proto *tp,
@@ -435,14 +430,9 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	bool skip_sw = tc_skip_sw(f->flags);
 	int err = 0;
 
-	if (!rtnl_held)
-		rtnl_lock();
-
 	cls_flower.rule = flow_rule_alloc(tcf_exts_num_actions(&f->exts));
-	if (!cls_flower.rule) {
-		err = -ENOMEM;
-		goto errout;
-	}
+	if (!cls_flower.rule)
+		return -ENOMEM;
 
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
 	cls_flower.command = FLOW_CLS_REPLACE;
@@ -453,36 +443,30 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.classid = f->res.classid;
 
 	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts,
-				   true);
+				   rtnl_held);
 	if (err) {
 		kfree(cls_flower.rule);
-		if (skip_sw)
+		if (skip_sw) {
 			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
-		else
-			err = 0;
-		goto errout;
+			return err;
+		}
+		return 0;
 	}
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
-			      skip_sw, &f->flags, &f->in_hw_count, true);
+			      skip_sw, &f->flags, &f->in_hw_count, rtnl_held);
 	tc_cleanup_flow_action(&cls_flower.rule->action);
 	kfree(cls_flower.rule);
 
 	if (err) {
-		fl_hw_destroy_filter(tp, f, true, NULL);
-		goto errout;
-	}
-
-	if (skip_sw && !(f->flags & TCA_CLS_FLAGS_IN_HW)) {
-		err = -EINVAL;
-		goto errout;
+		fl_hw_destroy_filter(tp, f, rtnl_held, NULL);
+		return err;
 	}
 
-errout:
-	if (!rtnl_held)
-		rtnl_unlock();
+	if (skip_sw && !(f->flags & TCA_CLS_FLAGS_IN_HW))
+		return -EINVAL;
 
-	return err;
+	return 0;
 }
 
 static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
@@ -491,22 +475,17 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	struct tcf_block *block = tp->chain->block;
 	struct flow_cls_offload cls_flower = {};
 
-	if (!rtnl_held)
-		rtnl_lock();
-
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, NULL);
 	cls_flower.command = FLOW_CLS_STATS;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.classid = f->res.classid;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false, true);
+	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
+			 rtnl_held);
 
 	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
 			      cls_flower.stats.pkts,
 			      cls_flower.stats.lastused);
-
-	if (!rtnl_held)
-		rtnl_unlock();
 }
 
 static void __fl_put(struct cls_fl_filter *f)
-- 
2.21.0

