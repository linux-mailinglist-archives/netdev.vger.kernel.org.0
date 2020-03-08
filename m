Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F405817D653
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 22:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCHV1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 17:27:55 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:37326 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHV1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 17:27:55 -0400
Received: by mail-pj1-f74.google.com with SMTP id d9so649876pjs.2
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 14:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nWZdwlBIgJFhBX2PY2QRYxPF53NaS+esnsUOXD9Yob0=;
        b=NTcP7dah6LTCmpZ8OhPdPQ5R3A3nByZXhoJhThGrp/LV+7ElGqgBo+bEVW0MPioWoh
         8lV3QJexfD3e5uYlVGx7CT6BHCLHms/X7JJCU/6HmycBuYGi6ecChJnef3eo3ik9lodL
         P+l8Fj68eqYeDQWA5wYoas+SPK/ZcBIXf6r0SLzyS7uFzzgWxfYFF74MyMcdXy1Bp1QF
         j4JNQqP4kAdesxFAvP9l9I8UY6U56uMQUT9sNfuWMRvhUFdq6IH4uyoNcpmyU6AIuTpi
         XxWzcrFf36tYYMr789wsD4tu+xs/oGNIbeUngN0N2GawDbg/5Basfx4IJqiAjUo/icdE
         U1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nWZdwlBIgJFhBX2PY2QRYxPF53NaS+esnsUOXD9Yob0=;
        b=nFJcgYi7LaRdWfd9QhSDlkBeKq3iGQxCVFRanTkk8BrPj8epGuZgCGjAwwnnw2Uwk6
         KllV1MxYGxkVLPLyKdIE/fu678y6tMEkfUI8L3woNQtHie7fTa8nINql6wRyoxo60+6s
         e6lWrZqGaa6Ma4Dn2D+yW+9+LIDIJgCN5OrIjM7btNL8ws/StRIG5QVoeYW2Ofi93RaX
         Ic7+4XpByPFRxVkpZqni1aduaJsm8OE06+R6f8y0Vufo6SWILzRQK4164qWNMG6ynG3b
         bVYAQdIwgCZMHGE9oGAKw69c8sph+A6QDePL4GuMBCPu4AVyJriBnJc2Ka5rqB7UugHw
         XYLA==
X-Gm-Message-State: ANhLgQ3YX33WDTNMz0VHE/G4X3x676nkz0LLZPgAf5ioJ/KpPUrjsROh
        gSJXCq6eoKH4/SsEqNcSGnOUrkLL/spxNg==
X-Google-Smtp-Source: ADFU+vu1TBqOq0TMXpLSeOc60wZR2WnOD36Inqem1c2wlwPRoDeGODVxwqe58ZShWJZDh+v63XqKoOavfpGYDg==
X-Received: by 2002:a65:668c:: with SMTP id b12mr13541209pgw.14.1583702872220;
 Sun, 08 Mar 2020 14:27:52 -0700 (PDT)
Date:   Sun,  8 Mar 2020 14:27:48 -0700
Message-Id: <20200308212748.107539-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net-next] net/sched: act_ct: fix lockdep splat in tcf_ct_flow_table_get
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paul Blakey <paulb@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert zones_lock spinlock to zones_mutex mutex,
and struct (tcf_ct_flow_table)->ref to a refcount,
so that control path can use regular GFP_KERNEL allocations
from standard process context. This is more robust
in case of memory pressure.

The refcount is needed because tcf_ct_flow_table_put() can
be called from RCU callback, thus in BH context.

The issue was spotted by syzbot, as rhashtable_init()
was called with a spinlock held, which is bad since GFP_KERNEL
allocations can sleep.

Note to developers : Please make sure your patches are tested
with CONFIG_DEBUG_ATOMIC_SLEEP=y

BUG: sleeping function called from invalid context at mm/slab.h:565
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 9582, name: syz-executor610
2 locks held by syz-executor610/9582:
 #0: ffffffff8a34eb80 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a34eb80 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5437
 #1: ffffffff8a3961b8 (zones_lock){+...}, at: spin_lock_bh include/linux/spinlock.h:343 [inline]
 #1: ffffffff8a3961b8 (zones_lock){+...}, at: tcf_ct_flow_table_get+0xa3/0x1700 net/sched/act_ct.c:67
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 PID: 9582 Comm: syz-executor610 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 ___might_sleep.cold+0x1f4/0x23d kernel/sched/core.c:6798
 slab_pre_alloc_hook mm/slab.h:565 [inline]
 slab_alloc_node mm/slab.c:3227 [inline]
 kmem_cache_alloc_node_trace+0x272/0x790 mm/slab.c:3593
 __do_kmalloc_node mm/slab.c:3615 [inline]
 __kmalloc_node+0x38/0x60 mm/slab.c:3623
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:645 [inline]
 kvzalloc include/linux/mm.h:653 [inline]
 bucket_table_alloc+0x8b/0x480 lib/rhashtable.c:175
 rhashtable_init+0x3d2/0x750 lib/rhashtable.c:1054
 nf_flow_table_init+0x16d/0x310 net/netfilter/nf_flow_table_core.c:498
 tcf_ct_flow_table_get+0xe33/0x1700 net/sched/act_ct.c:82
 tcf_ct_init+0xba4/0x18a6 net/sched/act_ct.c:1050
 tcf_action_init_1+0x697/0xa20 net/sched/act_api.c:945
 tcf_action_init+0x1e9/0x2f0 net/sched/act_api.c:1001
 tcf_action_add+0xdb/0x370 net/sched/act_api.c:1411
 tc_ctl_action+0x366/0x456 net/sched/act_api.c:1466
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4403d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd719af218 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004403d9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000005 R09: 00000000004002c8
R10: 0000000000000008 R11: 00000000000

Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paul Blakey <paulb@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/act_ct.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 23eba61f0f819212a3522c3c63b938d0b8d997e2..3d9e678d7d5336f1746035745b091bea0dcb5fdd 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -35,15 +35,15 @@
 
 static struct workqueue_struct *act_ct_wq;
 static struct rhashtable zones_ht;
-static DEFINE_SPINLOCK(zones_lock);
+static DEFINE_MUTEX(zones_mutex);
 
 struct tcf_ct_flow_table {
 	struct rhash_head node; /* In zones tables */
 
 	struct rcu_work rwork;
 	struct nf_flowtable nf_ft;
+	refcount_t ref;
 	u16 zone;
-	u32 ref;
 
 	bool dying;
 };
@@ -64,14 +64,15 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
 
-	spin_lock_bh(&zones_lock);
+	mutex_lock(&zones_mutex);
 	ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
-	if (ct_ft)
-		goto take_ref;
+	if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
+		goto out_unlock;
 
-	ct_ft = kzalloc(sizeof(*ct_ft), GFP_ATOMIC);
+	ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
 	if (!ct_ft)
 		goto err_alloc;
+	refcount_set(&ct_ft->ref, 1);
 
 	ct_ft->zone = params->zone;
 	err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
@@ -84,10 +85,9 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 		goto err_init;
 
 	__module_get(THIS_MODULE);
-take_ref:
+out_unlock:
 	params->ct_ft = ct_ft;
-	ct_ft->ref++;
-	spin_unlock_bh(&zones_lock);
+	mutex_unlock(&zones_mutex);
 
 	return 0;
 
@@ -96,7 +96,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 err_insert:
 	kfree(ct_ft);
 err_alloc:
-	spin_unlock_bh(&zones_lock);
+	mutex_unlock(&zones_mutex);
 	return err;
 }
 
@@ -116,13 +116,11 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
 {
 	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
 
-	spin_lock_bh(&zones_lock);
-	if (--params->ct_ft->ref == 0) {
+	if (refcount_dec_and_test(&params->ct_ft->ref)) {
 		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
 		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
 		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
 	}
-	spin_unlock_bh(&zones_lock);
 }
 
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
-- 
2.25.1.481.gfbce0eb801-goog

