Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A5A08A9
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfH1Rgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:36:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:14208 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfH1Rgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:36:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:36:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="332243844"
Received: from ellie.jf.intel.com (HELO localhost.localdomain) ([10.24.12.211])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2019 10:36:38 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, olteanv@gmail.com
Subject: [PATCH net v1] net/sched: cbs: Fix not adding cbs instance to list
Date:   Wed, 28 Aug 2019 10:36:15 -0700
Message-Id: <20190828173615.4264-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing a cbs instance when offloading is enabled, the crash
below can be observed. Also, the current code doesn't handle correctly
the case when offload is disabled without removing the qdisc: if the
link speed changes the credit calculations will be wrong.

The solution for both issues is the same, add the cbs instance being
created unconditionally to the global list, even if the link state
notification isn't useful "right now".

Crash log:

[   59.838566] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   59.838570] #PF: supervisor read access in kernel mode
[   59.838571] #PF: error_code(0x0000) - not-present page
[   59.838572] PGD 0 P4D 0
[   59.838574] Oops: 0000 [#1] SMP PTI
[   59.838576] CPU: 4 PID: 492 Comm: tc Not tainted 5.3.0-rc6+ #5
[   59.838577] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS ULTRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
[   59.838581] RIP: 0010:__list_del_entry_valid+0x29/0xa0
[   59.838583] Code: 90 48 b8 00 01 00 00 00 00 ad de 55 48 8b 17 4c 8b 47 08 48 89 e5 48 39 c2 74 27 48 b8 22 01 00 00 00 00 ad de 49 39 c0 74 2d <49> 8b 30 48 39 fe 75 3d 48 8b 52 08 48 39 f2 75 4c b8 01 00 00 00
[   59.838585] RSP: 0018:ffffbba040a47988 EFLAGS: 00010217
[   59.838587] RAX: dead000000000122 RBX: ffff9f356410cc00 RCX: 0000000000000000
[   59.838588] RDX: 0000000000000000 RSI: ffff9f356410cc64 RDI: ffff9f356410cde0
[   59.838589] RBP: ffffbba040a47988 R08: 0000000000000000 R09: ffffbba040a47a34
[   59.838591] R10: 0000000000000000 R11: ffffbba040a47aa0 R12: ffff9f3569aa0000
[   59.838592] R13: ffff9f356410cd40 R14: 0000000000000000 R15: 0000000000000000
[   59.838593] FS:  00007f88b2822f80(0000) GS:ffff9f356e100000(0000) knlGS:0000000000000000
[   59.838595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.838596] CR2: 0000000000000000 CR3: 00000004a0b0c004 CR4: 00000000003606e0
[   59.838597] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.838598] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   59.838599] Call Trace:
[   59.838603]  cbs_destroy+0x32/0xa0 [sch_cbs]
[   59.838605]  qdisc_destroy+0x45/0x120
[   59.838607]  qdisc_put+0x25/0x30
[   59.838608]  qdisc_graft+0x2c1/0x450
[   59.838610]  tc_get_qdisc+0x1c8/0x310
[   59.838612]  ? prep_new_page+0x40/0xc0
[   59.838614]  rtnetlink_rcv_msg+0x293/0x360
[   59.838616]  ? kmem_cache_alloc_node_trace+0x177/0x290
[   59.838617]  ? __kmalloc_node_track_caller+0x38/0x50
[   59.838619]  ? rtnl_calcit.isra.0+0xf0/0xf0
[   59.838621]  netlink_rcv_skb+0x48/0x110
[   59.838623]  rtnetlink_rcv+0x10/0x20
[   59.838624]  netlink_unicast+0x15b/0x1d0
[   59.838625]  netlink_sendmsg+0x1fb/0x3a0
[   59.838628]  sock_sendmsg+0x2f/0x40
[   59.838629]  ___sys_sendmsg+0x295/0x2f0
[   59.838631]  ? ___sys_recvmsg+0x151/0x1e0
[   59.838633]  ? do_wp_page+0x7c/0x450
[   59.838634]  __sys_sendmsg+0x48/0x80
[   59.838636]  __x64_sys_sendmsg+0x1a/0x20
[   59.838638]  do_syscall_64+0x53/0x1e0
[   59.838640]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   59.838641] RIP: 0033:0x7f88b2aab69a
[   59.838643] Code: 48 c7 c0 ff ff ff ff eb be 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 18 b8 2e 00 00 00 c5 fc 77 0f 05 <48> 3d 00 f0 ff ff 77 5e c3 0f 1f 44 00 00 48 83 ec 28 89 54 24 1c
[   59.838645] RSP: 002b:00007fff79f253d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[   59.838647] RAX: ffffffffffffffda RBX: 000055bfdd1c19a0 RCX: 00007f88b2aab69a
[   59.838648] RDX: 0000000000000000 RSI: 00007fff79f25448 RDI: 0000000000000003
[   59.838649] RBP: 00007fff79f254b0 R08: 0000000000000001 R09: 000055bfddc268a0
[   59.838650] R10: 0000000000000000 R11: 0000000000000246 R12: 000000005d66a666
[   59.838652] R13: 0000000000000000 R14: 00007fff79f25550 R15: 00007fff79f25530
[   59.838653] Modules linked in: sch_cbs sch_mqprio e1000e igb intel_pch_thermal thermal video backlight
[   59.838657] CR2: 0000000000000000
[   59.838658] ---[ end trace 08db7a13640831a0 ]---
[   59.838660] RIP: 0010:__list_del_entry_valid+0x29/0xa0
[   59.838662] Code: 90 48 b8 00 01 00 00 00 00 ad de 55 48 8b 17 4c 8b 47 08 48 89 e5 48 39 c2 74 27 48 b8 22 01 00 00 00 00 ad de 49 39 c0 74 2d <49> 8b 30 48 39 fe 75 3d 48 8b 52 08 48 39 f2 75 4c b8 01 00 00 00
[   59.838664] RSP: 0018:ffffbba040a47988 EFLAGS: 00010217
[   59.838665] RAX: dead000000000122 RBX: ffff9f356410cc00 RCX: 0000000000000000
[   59.838666] RDX: 0000000000000000 RSI: ffff9f356410cc64 RDI: ffff9f356410cde0
[   59.838667] RBP: ffffbba040a47988 R08: 0000000000000000 R09: ffffbba040a47a34
[   59.838669] R10: 0000000000000000 R11: ffffbba040a47aa0 R12: ffff9f3569aa0000
[   59.838670] R13: ffff9f356410cd40 R14: 0000000000000000 R15: 0000000000000000
[   59.838671] FS:  00007f88b2822f80(0000) GS:ffff9f356e100000(0000) knlGS:0000000000000000
[   59.838673] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.838674] CR2: 0000000000000000 CR3: 00000004a0b0c004 CR4: 00000000003606e0
[   59.838675] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.838676] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: e0a7683 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_cbs.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 732e109..a167bda 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -401,6 +401,10 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!q->qdisc)
 		return -ENOMEM;
 
+	spin_lock(&cbs_list_lock);
+	list_add(&q->cbs_list, &cbs_list);
+	spin_unlock(&cbs_list_lock);
+
 	qdisc_hash_add(q->qdisc, false);
 
 	q->queue = sch->dev_queue - netdev_get_tx_queue(dev, 0);
@@ -414,12 +418,6 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
 
-	if (!q->offload) {
-		spin_lock(&cbs_list_lock);
-		list_add(&q->cbs_list, &cbs_list);
-		spin_unlock(&cbs_list_lock);
-	}
-
 	return 0;
 }
 
@@ -428,15 +426,18 @@ static void cbs_destroy(struct Qdisc *sch)
 	struct cbs_sched_data *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 
-	spin_lock(&cbs_list_lock);
-	list_del(&q->cbs_list);
-	spin_unlock(&cbs_list_lock);
+	/* Nothing to do if we couldn't create the underlying qdisc */
+	if (!q->qdisc)
+		return;
 
 	qdisc_watchdog_cancel(&q->watchdog);
 	cbs_disable_offload(dev, q);
 
-	if (q->qdisc)
-		qdisc_put(q->qdisc);
+	spin_lock(&cbs_list_lock);
+	list_del(&q->cbs_list);
+	spin_unlock(&cbs_list_lock);
+
+	qdisc_put(q->qdisc);
 }
 
 static int cbs_dump(struct Qdisc *sch, struct sk_buff *skb)
-- 
2.23.0

