Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E0B99416
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388699AbfHVMoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:44:24 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44421 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387877AbfHVMoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:44:19 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 15:44:11 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MCiAok025522;
        Thu, 22 Aug 2019 15:44:11 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 03/10] net: sched: refactor block offloads counter usage
Date:   Thu, 22 Aug 2019 15:43:46 +0300
Message-Id: <20190822124353.16902-4-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822124353.16902-1-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without rtnl lock protection filters can no longer safely manage block
offloads counter themselves. Refactor cls API to protect block offloadcnt
with tcf_block->cb_lock that is already used to protect driver callback
list and nooffloaddevcnt counter. The counter can be modified by concurrent
tasks by new functions that execute block callbacks (which is safe with
previous patch that changed its type to atomic_t), however, block
bind/unbind code that checks the counter value takes cb_lock in write mode
to exclude any concurrent modifications. This approach prevents race
conditions between bind/unbind and callback execution code but allows for
concurrency for tc rule update path.

Move block offload counter, filter in hardware counter and filter flags
management from classifiers into cls hardware offloads API. Make functions
tcf_block_offload_inc() and tcf_block_offload_dec() to be cls API private.
Implement following new cls API to be used instead:

  tc_setup_cb_add() - non-destructive filter add. If filter that wasn't
  already in hardware is successfully offloaded, increment block offloads
  counter, set filter in hardware counter and flag. On failure, previously
  offloaded filter is considered to be intact and offloads counter is not
  decremented.

  tc_setup_cb_replace() - destructive filter replace. Release existing
  filter block offload counter and reset its in hardware counter and flag.
  Set new filter in hardware counter and flag. On failure, previously
  offloaded filter is considered to be destroyed and offload counter is
  decremented.

  tc_setup_cb_destroy() - filter destroy. Unconditionally decrement block
  offloads counter.

Refactor all offload-capable classifiers to atomically offload filters to
hardware, change block offload counter, and set filter in hardware counter
and flag by means of the new cls API functions.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h     |  13 +++-
 include/net/sch_generic.h |  32 +-------
 net/sched/cls_api.c       | 155 ++++++++++++++++++++++++++++++++++----
 net/sched/cls_bpf.c       |  22 +++---
 net/sched/cls_flower.c    |  23 +++---
 net/sched/cls_matchall.c  |  15 ++--
 net/sched/cls_u32.c       |  17 ++---
 7 files changed, 193 insertions(+), 84 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 64999ffcb486..a5937fb3c4b2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -506,7 +506,18 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
-		     void *type_data, bool err_stop);
+		     void *type_data, bool err_stop, bool rtnl_held);
+int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
+		    enum tc_setup_type type, void *type_data, bool err_stop,
+		    u32 *flags, unsigned int *in_hw_count, bool rtnl_held);
+int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
+			enum tc_setup_type type, void *type_data, bool err_stop,
+			u32 *old_flags, unsigned int *old_in_hw_count,
+			u32 *new_flags, unsigned int *new_in_hw_count,
+			bool rtnl_held);
+int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
+			enum tc_setup_type type, void *type_data, bool err_stop,
+			u32 *flags, unsigned int *in_hw_count, bool rtnl_held);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
 
 struct tc_cls_u32_knode {
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d778c502decd..373f9476c1de 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -439,36 +439,8 @@ static inline bool lockdep_tcf_proto_is_locked(struct tcf_proto *tp)
 #define tcf_proto_dereference(p, tp)					\
 	rcu_dereference_protected(p, lockdep_tcf_proto_is_locked(tp))
 
-static inline void tcf_block_offload_inc(struct tcf_block *block, u32 *flags)
-{
-	if (*flags & TCA_CLS_FLAGS_IN_HW)
-		return;
-	*flags |= TCA_CLS_FLAGS_IN_HW;
-	atomic_inc(&block->offloadcnt);
-}
-
-static inline void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
-{
-	if (!(*flags & TCA_CLS_FLAGS_IN_HW))
-		return;
-	*flags &= ~TCA_CLS_FLAGS_IN_HW;
-	atomic_dec(&block->offloadcnt);
-}
-
-static inline void
-tc_cls_offload_cnt_update(struct tcf_block *block, u32 *cnt,
-			  u32 *flags, bool add)
-{
-	if (add) {
-		if (!*cnt)
-			tcf_block_offload_inc(block, flags);
-		(*cnt)++;
-	} else {
-		(*cnt)--;
-		if (!*cnt)
-			tcf_block_offload_dec(block, flags);
-	}
-}
+void tc_cls_offload_cnt_update(struct tcf_block *block, struct tcf_proto *tp,
+			       u32 *cnt, u32 *flags, u32 diff, bool add);
 
 static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 8502bd006b37..4215c849f4a3 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3000,13 +3000,97 @@ int tcf_exts_dump_stats(struct sk_buff *skb, struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_dump_stats);
 
-int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
-		     void *type_data, bool err_stop)
+static void tcf_block_offload_inc(struct tcf_block *block, u32 *flags)
+{
+	if (*flags & TCA_CLS_FLAGS_IN_HW)
+		return;
+	*flags |= TCA_CLS_FLAGS_IN_HW;
+	atomic_inc(&block->offloadcnt);
+}
+
+static void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
+{
+	if (!(*flags & TCA_CLS_FLAGS_IN_HW))
+		return;
+	*flags &= ~TCA_CLS_FLAGS_IN_HW;
+	atomic_dec(&block->offloadcnt);
+}
+
+void tc_cls_offload_cnt_update(struct tcf_block *block, struct tcf_proto *tp,
+			       u32 *cnt, u32 *flags, u32 diff, bool add)
+{
+	lockdep_assert_held(&block->cb_lock);
+
+	spin_lock(&tp->lock);
+	if (add) {
+		if (!*cnt)
+			tcf_block_offload_inc(block, flags);
+		(*cnt) += diff;
+	} else {
+		(*cnt) -= diff;
+		if (!*cnt)
+			tcf_block_offload_dec(block, flags);
+	}
+	spin_unlock(&tp->lock);
+}
+EXPORT_SYMBOL(tc_cls_offload_cnt_update);
+
+static void
+tc_cls_offload_cnt_reset(struct tcf_block *block, struct tcf_proto *tp,
+			 u32 *cnt, u32 *flags)
+{
+	lockdep_assert_held(&block->cb_lock);
+
+	spin_lock(&tp->lock);
+	tcf_block_offload_dec(block, flags);
+	(*cnt) = 0;
+	spin_unlock(&tp->lock);
+}
+
+static int
+__tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
+		   void *type_data, bool err_stop)
 {
 	struct flow_block_cb *block_cb;
 	int ok_count = 0;
 	int err;
 
+	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
+		err = block_cb->cb(type, type_data, block_cb->cb_priv);
+		if (err) {
+			if (err_stop)
+				return err;
+		} else {
+			ok_count++;
+		}
+	}
+	return ok_count;
+}
+
+int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
+		     void *type_data, bool err_stop, bool rtnl_held)
+{
+	int ok_count;
+
+	down_read(&block->cb_lock);
+	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
+	up_read(&block->cb_lock);
+	return ok_count;
+}
+EXPORT_SYMBOL(tc_setup_cb_call);
+
+/* Non-destructive filter add. If filter that wasn't already in hardware is
+ * successfully offloaded, increment block offloads counter. On failure,
+ * previously offloaded filter is considered to be intact and offloads counter
+ * is not decremented.
+ */
+
+int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
+		    enum tc_setup_type type, void *type_data, bool err_stop,
+		    u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
+{
+	int ok_count;
+
 	down_read(&block->cb_lock);
 	/* Make sure all netdevs sharing this block are offload-capable. */
 	if (block->nooffloaddevcnt && err_stop) {
@@ -3014,22 +3098,67 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		goto errout;
 	}
 
-	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
-		err = block_cb->cb(type, type_data, block_cb->cb_priv);
-		if (err) {
-			if (err_stop) {
-				ok_count = err;
-				goto errout;
-			}
-		} else {
-			ok_count++;
-		}
+	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
+	if (ok_count > 0)
+		tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
+					  ok_count, true);
+errout:
+	up_read(&block->cb_lock);
+	return ok_count;
+}
+EXPORT_SYMBOL(tc_setup_cb_add);
+
+/* Destructive filter replace. If filter that wasn't already in hardware is
+ * successfully offloaded, increment block offload counter. On failure,
+ * previously offloaded filter is considered to be destroyed and offload counter
+ * is decremented.
+ */
+
+int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
+			enum tc_setup_type type, void *type_data, bool err_stop,
+			u32 *old_flags, unsigned int *old_in_hw_count,
+			u32 *new_flags, unsigned int *new_in_hw_count,
+			bool rtnl_held)
+{
+	int ok_count;
+
+	down_read(&block->cb_lock);
+	/* Make sure all netdevs sharing this block are offload-capable. */
+	if (block->nooffloaddevcnt && err_stop) {
+		ok_count = -EOPNOTSUPP;
+		goto errout;
 	}
+
+	tc_cls_offload_cnt_reset(block, tp, old_in_hw_count, old_flags);
+
+	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
+	if (ok_count > 0)
+		tc_cls_offload_cnt_update(block, tp, new_in_hw_count, new_flags,
+					  ok_count, true);
 errout:
 	up_read(&block->cb_lock);
 	return ok_count;
 }
-EXPORT_SYMBOL(tc_setup_cb_call);
+EXPORT_SYMBOL(tc_setup_cb_replace);
+
+/* Destroy filter and decrement block offload counter, if filter was previously
+ * offloaded.
+ */
+
+int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
+			enum tc_setup_type type, void *type_data, bool err_stop,
+			u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
+{
+	int ok_count;
+
+	down_read(&block->cb_lock);
+	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
+
+	tc_cls_offload_cnt_reset(block, tp, in_hw_count, flags);
+	up_read(&block->cb_lock);
+	return ok_count;
+}
+EXPORT_SYMBOL(tc_setup_cb_destroy);
 
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts)
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 3f7a9c02b70c..7f304db7e697 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -162,17 +162,21 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 	cls_bpf.name = obj->bpf_name;
 	cls_bpf.exts_integrated = obj->exts_integrated;
 
-	if (oldprog)
-		tcf_block_offload_dec(block, &oldprog->gen_flags);
+	if (cls_bpf.oldprog)
+		err = tc_setup_cb_replace(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
+					  skip_sw, &oldprog->gen_flags,
+					  &oldprog->in_hw_count,
+					  &prog->gen_flags, &prog->in_hw_count,
+					  true);
+	else
+		err = tc_setup_cb_add(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
+				      skip_sw, &prog->gen_flags,
+				      &prog->in_hw_count, true);
 
-	err = tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, skip_sw);
 	if (prog) {
 		if (err < 0) {
 			cls_bpf_offload_cmd(tp, oldprog, prog, extack);
 			return err;
-		} else if (err > 0) {
-			prog->in_hw_count = err;
-			tcf_block_offload_inc(block, &prog->gen_flags);
 		}
 	}
 
@@ -230,7 +234,7 @@ static void cls_bpf_offload_update_stats(struct tcf_proto *tp,
 	cls_bpf.name = prog->bpf_name;
 	cls_bpf.exts_integrated = prog->exts_integrated;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, false);
+	tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, false, true);
 }
 
 static int cls_bpf_init(struct tcf_proto *tp)
@@ -680,8 +684,8 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb
 			continue;
 		}
 
-		tc_cls_offload_cnt_update(block, &prog->in_hw_count,
-					  &prog->gen_flags, add);
+		tc_cls_offload_cnt_update(block, tp, &prog->in_hw_count,
+					  &prog->gen_flags, 1, add);
 	}
 
 	return 0;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 054123742e32..0001a933d48b 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -419,10 +419,10 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 	cls_flower.command = FLOW_CLS_DESTROY;
 	cls_flower.cookie = (unsigned long) f;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+	tc_setup_cb_destroy(block, tp, TC_SETUP_CLSFLOWER, &cls_flower, false,
+			    &f->flags, &f->in_hw_count, true);
 	spin_lock(&tp->lock);
 	list_del_init(&f->hw_list);
-	tcf_block_offload_dec(block, &f->flags);
 	spin_unlock(&tp->lock);
 
 	if (!rtnl_held)
@@ -466,18 +466,15 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		goto errout;
 	}
 
-	err = tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, skip_sw);
+	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
+			      skip_sw, &f->flags, &f->in_hw_count, true);
 	kfree(cls_flower.rule);
 
 	if (err < 0) {
 		fl_hw_destroy_filter(tp, f, true, NULL);
 		goto errout;
 	} else if (err > 0) {
-		f->in_hw_count = err;
 		err = 0;
-		spin_lock(&tp->lock);
-		tcf_block_offload_inc(block, &f->flags);
-		spin_unlock(&tp->lock);
 	}
 
 	if (skip_sw && !(f->flags & TCA_CLS_FLAGS_IN_HW)) {
@@ -509,7 +506,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.classid = f->res.classid;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false, true);
 
 	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
 			      cls_flower.stats.pkts,
@@ -1855,10 +1852,8 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 			goto next_flow;
 		}
 
-		spin_lock(&tp->lock);
-		tc_cls_offload_cnt_update(block, &f->in_hw_count, &f->flags,
-					  add);
-		spin_unlock(&tp->lock);
+		tc_cls_offload_cnt_update(block, tp, &f->in_hw_count, &f->flags,
+					  1, add);
 next_flow:
 		__fl_put(f);
 	}
@@ -1886,7 +1881,7 @@ static int fl_hw_create_tmplt(struct tcf_chain *chain,
 	/* We don't care if driver (any of them) fails to handle this
 	 * call. It serves just as a hint for it.
 	 */
-	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false, true);
 	kfree(cls_flower.rule);
 
 	return 0;
@@ -1902,7 +1897,7 @@ static void fl_hw_destroy_tmplt(struct tcf_chain *chain,
 	cls_flower.command = FLOW_CLS_TMPLT_DESTROY;
 	cls_flower.cookie = (unsigned long) tmplt;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
+	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false, true);
 }
 
 static void *fl_tmplt_create(struct net *net, struct tcf_chain *chain,
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 455ea2793f9b..d38e329d71bd 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -75,8 +75,8 @@ static void mall_destroy_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = cookie;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false);
-	tcf_block_offload_dec(block, &head->flags);
+	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
+	head->flags &= ~TCA_CLS_FLAGS_IN_HW;
 }
 
 static int mall_replace_hw_filter(struct tcf_proto *tp,
@@ -109,15 +109,13 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 		return err;
 	}
 
-	err = tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, skip_sw);
+	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSMATCHALL, &cls_mall,
+			      skip_sw, &head->flags, &head->in_hw_count, true);
 	kfree(cls_mall.rule);
 
 	if (err < 0) {
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
 		return err;
-	} else if (err > 0) {
-		head->in_hw_count = err;
-		tcf_block_offload_inc(block, &head->flags);
 	}
 
 	if (skip_sw && !(head->flags & TCA_CLS_FLAGS_IN_HW))
@@ -321,7 +319,8 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		return 0;
 	}
 
-	tc_cls_offload_cnt_update(block, &head->in_hw_count, &head->flags, add);
+	tc_cls_offload_cnt_update(block, tp, &head->in_hw_count, &head->flags,
+				  1, add);
 
 	return 0;
 }
@@ -337,7 +336,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_STATS;
 	cls_mall.cookie = cookie;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false);
+	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
 	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
 			      cls_mall.stats.pkts, cls_mall.stats.lastused);
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 8614088edd1b..94c6eca191f9 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -480,7 +480,7 @@ static void u32_clear_hw_hnode(struct tcf_proto *tp, struct tc_u_hnode *h,
 	cls_u32.hnode.handle = h->handle;
 	cls_u32.hnode.prio = h->prio;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSU32, &cls_u32, false);
+	tc_setup_cb_call(block, TC_SETUP_CLSU32, &cls_u32, false, true);
 }
 
 static int u32_replace_hw_hnode(struct tcf_proto *tp, struct tc_u_hnode *h,
@@ -498,7 +498,7 @@ static int u32_replace_hw_hnode(struct tcf_proto *tp, struct tc_u_hnode *h,
 	cls_u32.hnode.handle = h->handle;
 	cls_u32.hnode.prio = h->prio;
 
-	err = tc_setup_cb_call(block, TC_SETUP_CLSU32, &cls_u32, skip_sw);
+	err = tc_setup_cb_call(block, TC_SETUP_CLSU32, &cls_u32, skip_sw, true);
 	if (err < 0) {
 		u32_clear_hw_hnode(tp, h, NULL);
 		return err;
@@ -522,8 +522,8 @@ static void u32_remove_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	cls_u32.command = TC_CLSU32_DELETE_KNODE;
 	cls_u32.knode.handle = n->handle;
 
-	tc_setup_cb_call(block, TC_SETUP_CLSU32, &cls_u32, false);
-	tcf_block_offload_dec(block, &n->flags);
+	tc_setup_cb_destroy(block, tp, TC_SETUP_CLSU32, &cls_u32, false,
+			    &n->flags, &n->in_hw_count, true);
 }
 
 static int u32_replace_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
@@ -552,13 +552,11 @@ static int u32_replace_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	if (n->ht_down)
 		cls_u32.knode.link_handle = ht->handle;
 
-	err = tc_setup_cb_call(block, TC_SETUP_CLSU32, &cls_u32, skip_sw);
+	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSU32, &cls_u32, skip_sw,
+			      &n->flags, &n->in_hw_count, true);
 	if (err < 0) {
 		u32_remove_hw_knode(tp, n, NULL);
 		return err;
-	} else if (err > 0) {
-		n->in_hw_count = err;
-		tcf_block_offload_inc(block, &n->flags);
 	}
 
 	if (skip_sw && !(n->flags & TCA_CLS_FLAGS_IN_HW))
@@ -1208,7 +1206,8 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 		return 0;
 	}
 
-	tc_cls_offload_cnt_update(block, &n->in_hw_count, &n->flags, add);
+	tc_cls_offload_cnt_update(block, tp, &n->in_hw_count, &n->flags, 1,
+				  add);
 
 	return 0;
 }
-- 
2.21.0

