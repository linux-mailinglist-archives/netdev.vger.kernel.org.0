Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED979D0E6
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbfHZNpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:45:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52966 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732060AbfHZNpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:45:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 16:45:15 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QDjEFS000366;
        Mon, 26 Aug 2019 16:45:15 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v3 04/10] net: sched: notify classifier on successful offload add/delete
Date:   Mon, 26 Aug 2019 16:45:00 +0300
Message-Id: <20190826134506.9705-5-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
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
---

Notes:
    Changes from V1 to V2:
      - Keep success flow unindented in tc_setup_cb_{add|replace}().

 include/net/sch_generic.h |  4 ++++
 net/sched/cls_api.c       | 19 +++++++++++++++++--
 net/sched/cls_flower.c    | 33 ++++++++++++++++++++++++++-------
 3 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f90e3b2a3065..c4fbbaff30a2 100644
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
index 6e612984e4a6..8b807e75fae2 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3099,6 +3099,11 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
 	}
 
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
+	if (ok_count < 0)
+		goto err_unlock;
+
+	if (tp->ops->hw_add)
+		tp->ops->hw_add(tp, type_data);
 	if (ok_count > 0)
 		tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
 					  ok_count, true);
@@ -3130,11 +3135,18 @@ int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
 	}
 
 	tc_cls_offload_cnt_reset(block, tp, old_in_hw_count, old_flags);
+	if (tp->ops->hw_del)
+		tp->ops->hw_del(tp, type_data);
 
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
+	if (ok_count < 0)
+		goto err_unlock;
+
+	if (tp->ops->hw_add)
+		tp->ops->hw_add(tp, type_data);
 	if (ok_count > 0)
-		tc_cls_offload_cnt_update(block, tp, new_in_hw_count, new_flags,
-					  ok_count, true);
+		tc_cls_offload_cnt_update(block, tp, new_in_hw_count,
+					  new_flags, ok_count, true);
 err_unlock:
 	up_read(&block->cb_lock);
 	return ok_count < 0 ? ok_count : 0;
@@ -3155,6 +3167,9 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
 
 	tc_cls_offload_cnt_reset(block, tp, in_hw_count, flags);
+	if (tp->ops->hw_del)
+		tp->ops->hw_del(tp, type_data);
+
 	up_read(&block->cb_lock);
 	return ok_count < 0 ? ok_count : 0;
 }
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index cb816bbbd376..5cb694469b51 100644
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
@@ -480,9 +476,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		goto errout;
 	}
 
-	spin_lock(&tp->lock);
-	list_add(&f->hw_list, &head->hw_filters);
-	spin_unlock(&tp->lock);
 errout:
 	if (!rtnl_held)
 		rtnl_unlock();
@@ -1856,6 +1849,30 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
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
@@ -2516,6 +2533,8 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
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

