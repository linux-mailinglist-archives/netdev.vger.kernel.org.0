Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1640DBCBD8
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390707AbfIXPv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:51:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46809 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390606AbfIXPv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:51:26 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Sep 2019 18:51:22 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8OFpMlu010930;
        Tue, 24 Sep 2019 18:51:22 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net v3 2/3] net: sched: multiq: don't call qdisc_put() while holding tree lock
Date:   Tue, 24 Sep 2019 18:51:17 +0300
Message-Id: <20190924155118.2488-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190924155118.2488-1-vladbu@mellanox.com>
References: <20190924155118.2488-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes that removed rtnl dependency from rules update path of tc
also made tcf_block_put() function sleeping. This function is called from
ops->destroy() of several Qdisc implementations, which in turn is called by
qdisc_put(). Some Qdiscs call qdisc_put() while holding sch tree spinlock,
which results sleeping-while-atomic BUG.

Steps to reproduce for multiq:

tc qdisc add dev ens1f0 root handle 1: multiq
tc qdisc add dev ens1f0 parent 1:10 handle 50: sfq perturb 10
ethtool -L ens1f0 combined 2
tc qdisc change dev ens1f0 root handle 1: multiq

Resulting dmesg:

[ 5539.419344] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:909
[ 5539.420945] in_atomic(): 1, irqs_disabled(): 0, pid: 27658, name: tc
[ 5539.422435] INFO: lockdep is turned off.
[ 5539.423904] CPU: 21 PID: 27658 Comm: tc Tainted: G        W         5.3.0-rc8+ #721
[ 5539.425400] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[ 5539.426911] Call Trace:
[ 5539.428380]  dump_stack+0x85/0xc0
[ 5539.429823]  ___might_sleep.cold+0xac/0xbc
[ 5539.431262]  __mutex_lock+0x5b/0x960
[ 5539.432682]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 5539.434103]  ? __nla_validate_parse+0x51/0x840
[ 5539.435493]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 5539.436903]  tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 5539.438327]  tcf_block_put_ext.part.0+0x21/0x50
[ 5539.439752]  tcf_block_put+0x50/0x70
[ 5539.441165]  sfq_destroy+0x15/0x50 [sch_sfq]
[ 5539.442570]  qdisc_destroy+0x5f/0x160
[ 5539.444000]  multiq_tune+0x14a/0x420 [sch_multiq]
[ 5539.445421]  tc_modify_qdisc+0x324/0x840
[ 5539.446841]  rtnetlink_rcv_msg+0x170/0x4b0
[ 5539.448269]  ? netlink_deliver_tap+0x95/0x400
[ 5539.449691]  ? rtnl_dellink+0x2d0/0x2d0
[ 5539.451116]  netlink_rcv_skb+0x49/0x110
[ 5539.452522]  netlink_unicast+0x171/0x200
[ 5539.453914]  netlink_sendmsg+0x224/0x3f0
[ 5539.455304]  sock_sendmsg+0x5e/0x60
[ 5539.456686]  ___sys_sendmsg+0x2ae/0x330
[ 5539.458071]  ? ___sys_recvmsg+0x159/0x1f0
[ 5539.459461]  ? do_wp_page+0x9c/0x790
[ 5539.460846]  ? __handle_mm_fault+0xcd3/0x19e0
[ 5539.462263]  __sys_sendmsg+0x59/0xa0
[ 5539.463661]  do_syscall_64+0x5c/0xb0
[ 5539.465044]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 5539.466454] RIP: 0033:0x7f1fe08177b8
[ 5539.467863] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 5
4
[ 5539.470906] RSP: 002b:00007ffe812de5d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[ 5539.472483] RAX: ffffffffffffffda RBX: 000000005d8135e3 RCX: 00007f1fe08177b8
[ 5539.474069] RDX: 0000000000000000 RSI: 00007ffe812de640 RDI: 0000000000000003
[ 5539.475655] RBP: 0000000000000000 R08: 0000000000000001 R09: 000000000182e9b0
[ 5539.477203] R10: 0000000000404eda R11: 0000000000000246 R12: 0000000000000001
[ 5539.478699] R13: 000000000047f640 R14: 0000000000000000 R15: 0000000000000000

Rearrange locking in multiq_tune() in following ways:

- In loop that removes Qdiscs from disabled queues, call
  qdisc_purge_queue() instead of qdisc_tree_flush_backlog() on Qdisc that
  is being destroyed. Save the Qdisc in temporary allocated array and call
  qdisc_put() on each element of the array after sch tree lock is released.
  This is safe to do because Qdiscs have already been reset by
  qdisc_purge_queue() inside sch tree lock critical section.

- Do the same change for second loop that initializes Qdiscs for newly
  enabled queues in multiq_tune() function. Since sch tree lock is obtained
  and released on each iteration of this loop, just call qdisc_put()
  directly outside of critical section. Don't verify that old Qdisc is not
  noop_qdisc before releasing reference to it because such check is already
  performed by qdisc_put*() functions.

Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes V2 -> V3:
    
    - Use regular qdisc_put() instead of qdisc_put_empty() introduced in V2.
    
    Changes V1 -> V2:
    
    - Refactor first loop in multiq_tune() to save child Qdiscs that are being
      removed into an array and call qdisc_put_empty() on all of its elements
      after sch tree lock critical section. Revert the change in V1 that
      obtained and released sch tree lock on every loop iteration.
    
    - Use qdisc_purge_queue() instead of qdisc_tree_flush_backlog() to properly
      reset Qdiscs inside sch tree lock critical section.
    
    - Use qdisc_put_empty() in both loops of multiq_tune() instead of regular
      qdisc_put().

 net/sched/sch_multiq.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index e1087746f6a2..b2b7fdb06fc6 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -174,7 +174,8 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct multiq_sched_data *q = qdisc_priv(sch);
 	struct tc_multiq_qopt *qopt;
-	int i;
+	struct Qdisc **removed;
+	int i, n_removed = 0;
 
 	if (!netif_is_multiqueue(qdisc_dev(sch)))
 		return -EOPNOTSUPP;
@@ -185,6 +186,11 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 
 	qopt->bands = qdisc_dev(sch)->real_num_tx_queues;
 
+	removed = kmalloc(sizeof(*removed) * (q->max_bands - q->bands),
+			  GFP_KERNEL);
+	if (!removed)
+		return -ENOMEM;
+
 	sch_tree_lock(sch);
 	q->bands = qopt->bands;
 	for (i = q->bands; i < q->max_bands; i++) {
@@ -192,13 +198,17 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 			struct Qdisc *child = q->queues[i];
 
 			q->queues[i] = &noop_qdisc;
-			qdisc_tree_flush_backlog(child);
-			qdisc_put(child);
+			qdisc_purge_queue(child);
+			removed[n_removed++] = child;
 		}
 	}
 
 	sch_tree_unlock(sch);
 
+	for (i = 0; i < n_removed; i++)
+		qdisc_put(removed[i]);
+	kfree(removed);
+
 	for (i = 0; i < q->bands; i++) {
 		if (q->queues[i] == &noop_qdisc) {
 			struct Qdisc *child, *old;
@@ -213,11 +223,10 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 				if (child != &noop_qdisc)
 					qdisc_hash_add(child, true);
 
-				if (old != &noop_qdisc) {
-					qdisc_tree_flush_backlog(old);
-					qdisc_put(old);
-				}
+				if (old != &noop_qdisc)
+					qdisc_purge_queue(old);
 				sch_tree_unlock(sch);
+				qdisc_put(old);
 			}
 		}
 	}
-- 
2.21.0

