Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027A9BCBD9
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403792AbfIXPva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:51:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46812 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390614AbfIXPvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:51:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Sep 2019 18:51:22 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8OFpMlv010930;
        Tue, 24 Sep 2019 18:51:22 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>,
        syzbot+ac54455281db908c581e@syzkaller.appspotmail.com
Subject: [PATCH net v3 3/3] net: sched: sch_sfb: don't call qdisc_put() while holding tree lock
Date:   Tue, 24 Sep 2019 18:51:18 +0300
Message-Id: <20190924155118.2488-4-vladbu@mellanox.com>
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

Steps to reproduce for sfb:

tc qdisc add dev ens1f0 handle 1: root sfb
tc qdisc add dev ens1f0 parent 1:10 handle 50: sfq perturb 10
tc qdisc change dev ens1f0 root handle 1: sfb

Resulting dmesg:

[ 7265.938717] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:909
[ 7265.940152] in_atomic(): 1, irqs_disabled(): 0, pid: 28579, name: tc
[ 7265.941455] INFO: lockdep is turned off.
[ 7265.942744] CPU: 11 PID: 28579 Comm: tc Tainted: G        W         5.3.0-rc8+ #721
[ 7265.944065] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[ 7265.945396] Call Trace:
[ 7265.946709]  dump_stack+0x85/0xc0
[ 7265.947994]  ___might_sleep.cold+0xac/0xbc
[ 7265.949282]  __mutex_lock+0x5b/0x960
[ 7265.950543]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 7265.951803]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 7265.953022]  tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 7265.954248]  tcf_block_put_ext.part.0+0x21/0x50
[ 7265.955478]  tcf_block_put+0x50/0x70
[ 7265.956694]  sfq_destroy+0x15/0x50 [sch_sfq]
[ 7265.957898]  qdisc_destroy+0x5f/0x160
[ 7265.959099]  sfb_change+0x175/0x330 [sch_sfb]
[ 7265.960304]  tc_modify_qdisc+0x324/0x840
[ 7265.961503]  rtnetlink_rcv_msg+0x170/0x4b0
[ 7265.962692]  ? netlink_deliver_tap+0x95/0x400
[ 7265.963876]  ? rtnl_dellink+0x2d0/0x2d0
[ 7265.965064]  netlink_rcv_skb+0x49/0x110
[ 7265.966251]  netlink_unicast+0x171/0x200
[ 7265.967427]  netlink_sendmsg+0x224/0x3f0
[ 7265.968595]  sock_sendmsg+0x5e/0x60
[ 7265.969753]  ___sys_sendmsg+0x2ae/0x330
[ 7265.970916]  ? ___sys_recvmsg+0x159/0x1f0
[ 7265.972074]  ? do_wp_page+0x9c/0x790
[ 7265.973233]  ? __handle_mm_fault+0xcd3/0x19e0
[ 7265.974407]  __sys_sendmsg+0x59/0xa0
[ 7265.975591]  do_syscall_64+0x5c/0xb0
[ 7265.976753]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 7265.977938] RIP: 0033:0x7f229069f7b8
[ 7265.979117] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 5
4
[ 7265.981681] RSP: 002b:00007ffd7ed2d158 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[ 7265.983001] RAX: ffffffffffffffda RBX: 000000005d813ca1 RCX: 00007f229069f7b8
[ 7265.984336] RDX: 0000000000000000 RSI: 00007ffd7ed2d1c0 RDI: 0000000000000003
[ 7265.985682] RBP: 0000000000000000 R08: 0000000000000001 R09: 000000000165c9a0
[ 7265.987021] R10: 0000000000404eda R11: 0000000000000246 R12: 0000000000000001
[ 7265.988309] R13: 000000000047f640 R14: 0000000000000000 R15: 0000000000000000

In sfb_change() function use qdisc_purge_queue() instead of
qdisc_tree_flush_backlog() to properly reset old child Qdisc and save
pointer to it into local temporary variable. Put reference to Qdisc after
sch tree lock is released in order not to call potentially sleeping cls API
in atomic section. This is safe to do because Qdisc has already been reset
by qdisc_purge_queue() inside sch tree lock critical section.

Reported-by: syzbot+ac54455281db908c581e@syzkaller.appspotmail.com
Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes V2 -> V3:
    
    - Use regular qdisc_put() instead of qdisc_put_empty() introduced in V2.
    
    Changes V1 -> V2:
    
    - Use qdisc_purge_queue() instead of qdisc_tree_flush_backlog() to properly
      reset Qdiscs inside sch tree lock critical section.
    
    - Call qdisc_put_empty() instead of regular qdisc_put() after sch tree lock
      is released.

 net/sched/sch_sfb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 1dff8506a715..d448fe3068e5 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -488,7 +488,7 @@ static int sfb_change(struct Qdisc *sch, struct nlattr *opt,
 		      struct netlink_ext_ack *extack)
 {
 	struct sfb_sched_data *q = qdisc_priv(sch);
-	struct Qdisc *child;
+	struct Qdisc *child, *old;
 	struct nlattr *tb[TCA_SFB_MAX + 1];
 	const struct tc_sfb_qopt *ctl = &sfb_default_ops;
 	u32 limit;
@@ -518,8 +518,8 @@ static int sfb_change(struct Qdisc *sch, struct nlattr *opt,
 		qdisc_hash_add(child, true);
 	sch_tree_lock(sch);
 
-	qdisc_tree_flush_backlog(q->qdisc);
-	qdisc_put(q->qdisc);
+	qdisc_purge_queue(q->qdisc);
+	old = q->qdisc;
 	q->qdisc = child;
 
 	q->rehash_interval = msecs_to_jiffies(ctl->rehash_interval);
@@ -542,6 +542,7 @@ static int sfb_change(struct Qdisc *sch, struct nlattr *opt,
 	sfb_init_perturbation(1, q);
 
 	sch_tree_unlock(sch);
+	qdisc_put(old);
 
 	return 0;
 }
-- 
2.21.0

