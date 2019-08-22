Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC53C99411
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfHVMoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:44:18 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44422 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387884AbfHVMoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:44:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 15:44:11 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MCiAol025522;
        Thu, 22 Aug 2019 15:44:11 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 04/10] net: sched: notify classifier on successful offload add/delete
Date:   Thu, 22 Aug 2019 15:43:47 +0300
Message-Id: <20190822124353.16902-5-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822124353.16902-1-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To remove dependency on rtnl lock, extend classifier ops with new
ops->hw_add() and ops->hw_del() callbacks. Call them from cls API while
holding cb_lock every time filter if successfully added to or deleted from
hardware.

Implement the new API in flower classifier. Use it to manage hw_filters
list under cb_lock protection, instead of relying on rtnl lock to
synchronize with concurrent fl_reoffload() call.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/sch_generic.h |  4 ++++
 net/sched/cls_api.c       | 25 +++++++++++++++++++------
 net/sched/cls_flower.c    | 33 ++++++++++++++++++++++++++-------
 3 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 373f9476c1de..4ad43335cae5 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -312,6 +312,10 @@ struct tcf_proto_ops {
 	int			(*reoffload)(struct tcf_proto *tp, bool add,
 					     flow_setup_cb_t *cb, void *cb_priv,
 					     struct netlink_ext_ack *extack);
+	void			(*hw_add)(struct tcf_proto *tp,
+					  void *type_data);
+	void			(*hw_del)(struct tcf_proto *tp,
+					  void *type_data);
 	void			(*bind_class)(void *, u32, unsigned long);
 	void *			(*tmplt_create)(struct net *net,
 						struct tcf_chain *chain,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4215c849f4a3..d8ef7a9e6906 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3099,9 +3099,13 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
 	}
 
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
-	if (ok_count > 0)
-		tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
-					  ok_count, true);
+	if (ok_count >= 0) {
+		if (tp->ops->hw_add)
+			tp->ops->hw_add(tp, type_data);
+		if (ok_count > 0)
+			tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
+						  ok_count, true);
+	}
 errout:
 	up_read(&block->cb_lock);
 	return ok_count;
@@ -3130,11 +3134,17 @@ int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
 	}
 
 	tc_cls_offload_cnt_reset(block, tp, old_in_hw_count, old_flags);
+	if (tp->ops->hw_del)
+		tp->ops->hw_del(tp, type_data);
 
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
-	if (ok_count > 0)
-		tc_cls_offload_cnt_update(block, tp, new_in_hw_count, new_flags,
-					  ok_count, true);
+	if (ok_count >= 0) {
+		if (tp->ops->hw_add)
+			tp->ops->hw_add(tp, type_data);
+		if (ok_count > 0)
+			tc_cls_offload_cnt_update(block, tp, new_in_hw_count,
+						  new_flags, ok_count, true);
+	}
 errout:
 	up_read(&block->cb_lock);
 	return ok_count;
@@ -3155,6 +3165,9 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
 
 	tc_cls_offload_cnt_reset(block, tp, in_hw_count, flags);
+	if (tp->ops->hw_del)
+		tp->ops->hw_del(tp, type_data);
+
 	up_read(&block->cb_lock);
 	return ok_count;
 }
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0001a933d48b..cd1686a5abe7 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -421,9 +421,6 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 
 	tc_setup_cb_destroy(block, tp, TC_SETUP_CLSFLOWER, &cls_flower, false,
 			    &f->flags, &f->in_hw_count, true);
-	spin_lock(&tp->lock);
-	list_del_init(&f->hw_list);
-	spin_unlock(&tp->lock);
 
 	if (!rtnl_held)
 		rtnl_unlock();
@@ -433,7 +430,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 				struct cls_fl_filter *f, bool rtnl_held,
 				struct netlink_ext_ack *extack)
 {
-	struct cls_fl_head *head = fl_head_dereference(tp);
 	struct tcf_block *block = tp->chain->block;
 	struct flow_cls_offload cls_flower = {};
 	bool skip_sw = tc_skip_sw(f->flags);
@@ -482,9 +478,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		goto errout;
 	}
 
-	spin_lock(&tp->lock);
-	list_add(&f->hw_list, &head->hw_filters);
-	spin_unlock(&tp->lock);
 errout:
 	if (!rtnl_held)
 		rtnl_unlock();
@@ -1861,6 +1854,30 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	return 0;
 }
 
+static void fl_hw_add(struct tcf_proto *tp, void *type_data)
+{
+	struct flow_cls_offload *cls_flower = type_data;
+	struct cls_fl_filter *f =
+		(struct cls_fl_filter *) cls_flower->cookie;
+	struct cls_fl_head *head = fl_head_dereference(tp);
+
+	spin_lock(&tp->lock);
+	list_add(&f->hw_list, &head->hw_filters);
+	spin_unlock(&tp->lock);
+}
+
+static void fl_hw_del(struct tcf_proto *tp, void *type_data)
+{
+	struct flow_cls_offload *cls_flower = type_data;
+	struct cls_fl_filter *f =
+		(struct cls_fl_filter *) cls_flower->cookie;
+
+	spin_lock(&tp->lock);
+	if (!list_empty(&f->hw_list))
+		list_del_init(&f->hw_list);
+	spin_unlock(&tp->lock);
+}
+
 static int fl_hw_create_tmplt(struct tcf_chain *chain,
 			      struct fl_flow_tmplt *tmplt)
 {
@@ -2521,6 +2538,8 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.delete		= fl_delete,
 	.walk		= fl_walk,
 	.reoffload	= fl_reoffload,
+	.hw_add		= fl_hw_add,
+	.hw_del		= fl_hw_del,
 	.dump		= fl_dump,
 	.bind_class	= fl_bind_class,
 	.tmplt_create	= fl_tmplt_create,
-- 
2.21.0

