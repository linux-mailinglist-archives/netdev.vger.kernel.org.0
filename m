Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0904377F
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 16:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732700AbfFMO7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 10:59:25 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55095 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732613AbfFMOyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:54:21 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Jun 2019 17:54:13 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.213.18.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5DEsDgb006771;
        Thu, 13 Jun 2019 17:54:13 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, pablo@netfilter.org, alexanderk@mellanox.com,
        pabeni@redhat.com, mlxsw@mellanox.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net] net: sched: flower: don't call synchronize_rcu() on mask creation
Date:   Thu, 13 Jun 2019 17:54:04 +0300
Message-Id: <20190613145404.4774-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current flower mask creating code assumes that temporary mask that is used
when inserting new filter is stack allocated. To prevent race condition
with data patch synchronize_rcu() is called every time fl_create_new_mask()
replaces temporary stack allocated mask. As reported by Jiri, this
increases runtime of creating 20000 flower classifiers from 4 seconds to
163 seconds. However, this design is no longer necessary since temporary
mask was converted to be dynamically allocated by commit 2cddd2014782
("net/sched: cls_flower: allocate mask dynamically in fl_change()").

Remove synchronize_rcu() calls from mask creation code. Instead, refactor
fl_change() to always deallocate temporary mask with rcu grace period.

Fixes: 195c234d15c9 ("net: sched: flower: handle concurrent mask insertion")
Reported-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/cls_flower.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index c388372df0e2..eedd5786c084 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -320,10 +320,13 @@ static int fl_init(struct tcf_proto *tp)
 	return rhashtable_init(&head->ht, &mask_ht_params);
 }
 
-static void fl_mask_free(struct fl_flow_mask *mask)
+static void fl_mask_free(struct fl_flow_mask *mask, bool mask_init_done)
 {
-	WARN_ON(!list_empty(&mask->filters));
-	rhashtable_destroy(&mask->ht);
+	/* temporary masks don't have their filters list and ht initialized */
+	if (mask_init_done) {
+		WARN_ON(!list_empty(&mask->filters));
+		rhashtable_destroy(&mask->ht);
+	}
 	kfree(mask);
 }
 
@@ -332,7 +335,15 @@ static void fl_mask_free_work(struct work_struct *work)
 	struct fl_flow_mask *mask = container_of(to_rcu_work(work),
 						 struct fl_flow_mask, rwork);
 
-	fl_mask_free(mask);
+	fl_mask_free(mask, true);
+}
+
+static void fl_uninit_mask_free_work(struct work_struct *work)
+{
+	struct fl_flow_mask *mask = container_of(to_rcu_work(work),
+						 struct fl_flow_mask, rwork);
+
+	fl_mask_free(mask, false);
 }
 
 static bool fl_mask_put(struct cls_fl_head *head, struct fl_flow_mask *mask)
@@ -1346,9 +1357,6 @@ static struct fl_flow_mask *fl_create_new_mask(struct cls_fl_head *head,
 	if (err)
 		goto errout_destroy;
 
-	/* Wait until any potential concurrent users of mask are finished */
-	synchronize_rcu();
-
 	spin_lock(&head->masks_lock);
 	list_add_tail_rcu(&newmask->list, &head->masks);
 	spin_unlock(&head->masks_lock);
@@ -1375,11 +1383,7 @@ static int fl_check_assign_mask(struct cls_fl_head *head,
 
 	/* Insert mask as temporary node to prevent concurrent creation of mask
 	 * with same key. Any concurrent lookups with same key will return
-	 * -EAGAIN because mask's refcnt is zero. It is safe to insert
-	 * stack-allocated 'mask' to masks hash table because we call
-	 * synchronize_rcu() before returning from this function (either in case
-	 * of error or after replacing it with heap-allocated mask in
-	 * fl_create_new_mask()).
+	 * -EAGAIN because mask's refcnt is zero.
 	 */
 	fnew->mask = rhashtable_lookup_get_insert_fast(&head->ht,
 						       &mask->ht_node,
@@ -1414,8 +1418,6 @@ static int fl_check_assign_mask(struct cls_fl_head *head,
 errout_cleanup:
 	rhashtable_remove_fast(&head->ht, &mask->ht_node,
 			       mask_ht_params);
-	/* Wait until any potential concurrent users of mask are finished */
-	synchronize_rcu();
 	return ret;
 }
 
@@ -1644,7 +1646,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	*arg = fnew;
 
 	kfree(tb);
-	kfree(mask);
+	tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
 	return 0;
 
 errout_ht:
@@ -1664,7 +1666,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 errout_tb:
 	kfree(tb);
 errout_mask_alloc:
-	kfree(mask);
+	tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
 errout_fold:
 	if (fold)
 		__fl_put(fold);
-- 
2.21.0

