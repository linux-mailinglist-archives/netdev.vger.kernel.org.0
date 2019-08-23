Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603D99B664
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406007AbfHWSv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:51:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44542 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390833AbfHWSv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:51:26 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Aug 2019 21:51:19 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7NIpJEC012807;
        Fri, 23 Aug 2019 21:51:19 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v2 01/10] net: sched: protect block offload-related fields with rw_semaphore
Date:   Fri, 23 Aug 2019 21:50:47 +0300
Message-Id: <20190823185056.12536-2-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823185056.12536-1-vladbu@mellanox.com>
References: <20190823185056.12536-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to remove dependency on rtnl lock, extend tcf_block with 'cb_lock'
rwsem and use it to protect flow_block->cb_list and related counters from
concurrent modification. The lock is taken in read mode for read-only
traversal of cb_list in tc_setup_cb_call() and write mode in all other
cases. This approach ensures that:

- cb_list is not changed concurrently while filters is being offloaded on
  block.

- block->nooffloaddevcnt is checked while holding the lock in read mode,
  but is only changed by bind/unbind code when holding the cb_lock in write
  mode to prevent concurrent modification.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
Changes from V1 to V2:
  - Rename 'errout' label to 'err_unlock'.

 include/net/sch_generic.h |  2 ++
 net/sched/cls_api.c       | 45 +++++++++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d9f359af0b93..a3eaf5f9d28f 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -13,6 +13,7 @@
 #include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 #include <net/flow_offload.h>
@@ -396,6 +397,7 @@ struct tcf_block {
 	refcount_t refcnt;
 	struct net *net;
 	struct Qdisc *q;
+	struct rw_semaphore cb_lock; /* protects cb_list and offload counters */
 	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e0d8b456e9f5..959b7ca1ca02 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -568,9 +568,11 @@ static void tc_indr_block_ing_cmd(struct net_device *dev,
 
 	bo.block = &block->flow_block;
 
+	down_write(&block->cb_lock);
 	cb(dev, cb_priv, TC_SETUP_BLOCK, &bo);
 
 	tcf_block_setup(block, &bo);
+	up_write(&block->cb_lock);
 }
 
 static struct tcf_block *tc_dev_ingress_block(struct net_device *dev)
@@ -661,6 +663,7 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	struct net_device *dev = q->dev_queue->dev;
 	int err;
 
+	down_write(&block->cb_lock);
 	if (!dev->netdev_ops->ndo_setup_tc)
 		goto no_offload_dev_inc;
 
@@ -669,24 +672,31 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	 */
 	if (!tc_can_offload(dev) && tcf_block_offload_in_use(block)) {
 		NL_SET_ERR_MSG(extack, "Bind to offloaded block failed as dev has offload disabled");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto err_unlock;
 	}
 
 	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_BIND, extack);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_inc;
 	if (err)
-		return err;
+		goto err_unlock;
 
 	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
+	up_write(&block->cb_lock);
 	return 0;
 
 no_offload_dev_inc:
-	if (tcf_block_offload_in_use(block))
-		return -EOPNOTSUPP;
+	if (tcf_block_offload_in_use(block)) {
+		err = -EOPNOTSUPP;
+		goto err_unlock;
+	}
+	err = 0;
 	block->nooffloaddevcnt++;
 	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
-	return 0;
+err_unlock:
+	up_write(&block->cb_lock);
+	return err;
 }
 
 static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
@@ -695,6 +705,7 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	struct net_device *dev = q->dev_queue->dev;
 	int err;
 
+	down_write(&block->cb_lock);
 	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
 
 	if (!dev->netdev_ops->ndo_setup_tc)
@@ -702,10 +713,12 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_dec;
+	up_write(&block->cb_lock);
 	return;
 
 no_offload_dev_dec:
 	WARN_ON(block->nooffloaddevcnt-- == 0);
+	up_write(&block->cb_lock);
 }
 
 static int
@@ -820,6 +833,7 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
 		return ERR_PTR(-ENOMEM);
 	}
 	mutex_init(&block->lock);
+	init_rwsem(&block->cb_lock);
 	flow_block_init(&block->flow_block);
 	INIT_LIST_HEAD(&block->chain_list);
 	INIT_LIST_HEAD(&block->owner_list);
@@ -1355,6 +1369,8 @@ tcf_block_playback_offloads(struct tcf_block *block, flow_setup_cb_t *cb,
 	struct tcf_proto *tp, *tp_prev;
 	int err;
 
+	lockdep_assert_held(&block->cb_lock);
+
 	for (chain = __tcf_get_next_chain(block, NULL);
 	     chain;
 	     chain_prev = chain,
@@ -1393,6 +1409,8 @@ static int tcf_block_bind(struct tcf_block *block,
 	struct flow_block_cb *block_cb, *next;
 	int err, i = 0;
 
+	lockdep_assert_held(&block->cb_lock);
+
 	list_for_each_entry(block_cb, &bo->cb_list, list) {
 		err = tcf_block_playback_offloads(block, block_cb->cb,
 						  block_cb->cb_priv, true,
@@ -1427,6 +1445,8 @@ static void tcf_block_unbind(struct tcf_block *block,
 {
 	struct flow_block_cb *block_cb, *next;
 
+	lockdep_assert_held(&block->cb_lock);
+
 	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
 		tcf_block_playback_offloads(block, block_cb->cb,
 					    block_cb->cb_priv, false,
@@ -2987,19 +3007,26 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 	int ok_count = 0;
 	int err;
 
+	down_read(&block->cb_lock);
 	/* Make sure all netdevs sharing this block are offload-capable. */
-	if (block->nooffloaddevcnt && err_stop)
-		return -EOPNOTSUPP;
+	if (block->nooffloaddevcnt && err_stop) {
+		ok_count = -EOPNOTSUPP;
+		goto err_unlock;
+	}
 
 	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
 		if (err) {
-			if (err_stop)
-				return err;
+			if (err_stop) {
+				ok_count = err;
+				goto err_unlock;
+			}
 		} else {
 			ok_count++;
 		}
 	}
+err_unlock:
+	up_read(&block->cb_lock);
 	return ok_count;
 }
 EXPORT_SYMBOL(tc_setup_cb_call);
-- 
2.21.0

