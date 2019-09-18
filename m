Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3987B5E1A
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 09:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbfIRHcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 03:32:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49576 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729126AbfIRHcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 03:32:20 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 18 Sep 2019 10:32:16 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8I7WGCK021192;
        Wed, 18 Sep 2019 10:32:16 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net 2/3] net: sched: multiq: don't call qdisc_put() while holding tree lock
Date:   Wed, 18 Sep 2019 10:32:00 +0300
Message-Id: <20190918073201.2320-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190918073201.2320-1-vladbu@mellanox.com>
References: <20190918073201.2320-1-vladbu@mellanox.com>
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

- Don't hold sch tree lock for whole duration of the loop that removes
  Qdiscs from queues that have been disabled. Obtain the lock each time
  parent qdisc is changed and release it afterwards.

- Move call to qdisc_put() after sch_tree_unlock(sch) in loop that adds
  Qdiscs on newly enabled tx queues. Since qdisc_put() implementation
  already verifies that argument Qdisc is not of builtin type before
  processing it we don't need additional conditional around the call here.

Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/sch_multiq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index e1087746f6a2..4cfa9a7bd29e 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -187,18 +187,21 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 
 	sch_tree_lock(sch);
 	q->bands = qopt->bands;
+	sch_tree_unlock(sch);
+
 	for (i = q->bands; i < q->max_bands; i++) {
 		if (q->queues[i] != &noop_qdisc) {
 			struct Qdisc *child = q->queues[i];
 
+			sch_tree_lock(sch);
 			q->queues[i] = &noop_qdisc;
 			qdisc_tree_flush_backlog(child);
+			sch_tree_unlock(sch);
+
 			qdisc_put(child);
 		}
 	}
 
-	sch_tree_unlock(sch);
-
 	for (i = 0; i < q->bands; i++) {
 		if (q->queues[i] == &noop_qdisc) {
 			struct Qdisc *child, *old;
@@ -213,11 +216,10 @@ static int multiq_tune(struct Qdisc *sch, struct nlattr *opt,
 				if (child != &noop_qdisc)
 					qdisc_hash_add(child, true);
 
-				if (old != &noop_qdisc) {
+				if (old != &noop_qdisc)
 					qdisc_tree_flush_backlog(old);
-					qdisc_put(old);
-				}
 				sch_tree_unlock(sch);
+				qdisc_put(old);
 			}
 		}
 	}
-- 
2.21.0

