Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0139F2A0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbfH0SuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:50:09 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36318 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729903AbfH0SuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:50:08 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 Aug 2019 21:50:06 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7RIo687027377;
        Tue, 27 Aug 2019 21:50:06 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net] net: sched: act_sample: fix psample group handling on overwrite
Date:   Tue, 27 Aug 2019 21:49:38 +0300
Message-Id: <20190827184938.1824-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Action sample doesn't properly handle psample_group pointer in overwrite
case. Following issues need to be fixed:

- In tcf_sample_init() function RCU_INIT_POINTER() is used to set
  s->psample_group, even though we neither setting the pointer to NULL, nor
  preventing concurrent readers from accessing the pointer in some way.
  Use rcu_swap_protected() instead to safely reset the pointer.

- Old value of s->psample_group is not released or deallocated in any way,
  which results resource leak. Use psample_group_put() on non-NULL value
  obtained with rcu_swap_protected().

- The function psample_group_put() that released reference to struct
  psample_group pointed by rcu-pointer s->psample_group doesn't respect rcu
  grace period when deallocating it. Extend struct psample_group with rcu
  head and use kfree_rcu when freeing it.

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/net/psample.h  | 1 +
 net/psample/psample.c  | 2 +-
 net/sched/act_sample.c | 6 +++++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/psample.h b/include/net/psample.h
index 37a4df2325b2..6b578ce69cd8 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -11,6 +11,7 @@ struct psample_group {
 	u32 group_num;
 	u32 refcount;
 	u32 seq;
+	struct rcu_head rcu;
 };
 
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 841f198ea1a8..66e4b61a350d 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -154,7 +154,7 @@ static void psample_group_destroy(struct psample_group *group)
 {
 	psample_group_notify(group, PSAMPLE_CMD_DEL_GROUP);
 	list_del(&group->list);
-	kfree(group);
+	kfree_rcu(group, rcu);
 }
 
 static struct psample_group *
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 595308d60133..b75377d8c596 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -102,13 +102,17 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	s->rate = rate;
 	s->psample_group_num = psample_group_num;
-	RCU_INIT_POINTER(s->psample_group, psample_group);
+	rcu_swap_protected(s->psample_group, psample_group,
+			   lockdep_is_held(&s->tcf_lock));
 
 	if (tb[TCA_SAMPLE_TRUNC_SIZE]) {
 		s->truncate = true;
 		s->trunc_size = nla_get_u32(tb[TCA_SAMPLE_TRUNC_SIZE]);
 	}
 	spin_unlock_bh(&s->tcf_lock);
+
+	if (psample_group)
+		psample_group_put(psample_group);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-- 
2.21.0

