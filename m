Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAACBC132
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 07:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408836AbfIXFE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 01:04:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:17966 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408802AbfIXFE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 01:04:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 22:04:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="195583040"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.82])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2019 22:04:55 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net
Subject: [PATCH net v3] net/sched: cbs: Fix not adding cbs instance to list
Date:   Mon, 23 Sep 2019 22:04:58 -0700
Message-Id: <20190924050458.14223-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing a cbs instance when offloading is enabled, the crash
below can be observed.

The problem happens because that when offloading is enabled, the cbs
instance is not added to the list.

Also, the current code doesn't handle correctly the case when offload
is disabled without removing the qdisc: if the link speed changes the
credit calculations will be wrong. When we create the cbs instance
with offloading enabled, it's not added to the notification list, when
later we disable offloading, it's not in the list, so link speed
changes will not affect it.

The solution for both issues is the same, add the cbs instance being
created unconditionally to the global list, even if the link state
notification isn't useful "right now".

Crash log:

[518758.189866] BUG: kernel NULL pointer dereference, address: 0000000000000000
[518758.189870] #PF: supervisor read access in kernel mode
[518758.189871] #PF: error_code(0x0000) - not-present page
[518758.189872] PGD 0 P4D 0
[518758.189874] Oops: 0000 [#1] SMP PTI
[518758.189876] CPU: 3 PID: 4825 Comm: tc Not tainted 5.2.9 #1
[518758.189877] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS ULTRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
[518758.189881] RIP: 0010:__list_del_entry_valid+0x29/0xa0
[518758.189883] Code: 90 48 b8 00 01 00 00 00 00 ad de 55 48 8b 17 4c 8b 47 08 48 89 e5 48 39 c2 74 27 48 b8 00 02 00 00 00 00 ad de 49 39 c0 74 2d <49> 8b 30 48 39 fe 75 3d 48 8b 52 08 48 39 f2 75 4c b8 01 00 00 00
[518758.189885] RSP: 0018:ffffa27e43903990 EFLAGS: 00010207
[518758.189887] RAX: dead000000000200 RBX: ffff8bce69f0f000 RCX: 0000000000000000
[518758.189888] RDX: 0000000000000000 RSI: ffff8bce69f0f064 RDI: ffff8bce69f0f1e0
[518758.189890] RBP: ffffa27e43903990 R08: 0000000000000000 R09: ffff8bce69e788c0
[518758.189891] R10: ffff8bce62acd400 R11: 00000000000003cb R12: ffff8bce69e78000
[518758.189892] R13: ffff8bce69f0f140 R14: 0000000000000000 R15: 0000000000000000
[518758.189894] FS:  00007fa1572c8f80(0000) GS:ffff8bce6e0c0000(0000) knlGS:0000000000000000
[518758.189895] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[518758.189896] CR2: 0000000000000000 CR3: 000000040a398006 CR4: 00000000003606e0
[518758.189898] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[518758.189899] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[518758.189900] Call Trace:
[518758.189904]  cbs_destroy+0x32/0xa0 [sch_cbs]
[518758.189906]  qdisc_destroy+0x45/0x120
[518758.189907]  qdisc_put+0x25/0x30
[518758.189908]  qdisc_graft+0x2c1/0x450
[518758.189910]  tc_get_qdisc+0x1c8/0x310
[518758.189912]  ? get_page_from_freelist+0x91a/0xcb0
[518758.189914]  rtnetlink_rcv_msg+0x293/0x360
[518758.189916]  ? kmem_cache_alloc_node_trace+0x178/0x260
[518758.189918]  ? __kmalloc_node_track_caller+0x38/0x50
[518758.189920]  ? rtnl_calcit.isra.0+0xf0/0xf0
[518758.189922]  netlink_rcv_skb+0x48/0x110
[518758.189923]  rtnetlink_rcv+0x10/0x20
[518758.189925]  netlink_unicast+0x15b/0x1d0
[518758.189926]  netlink_sendmsg+0x1ea/0x380
[518758.189929]  sock_sendmsg+0x2f/0x40
[518758.189930]  ___sys_sendmsg+0x295/0x2f0
[518758.189932]  ? ___sys_recvmsg+0x151/0x1e0
[518758.189933]  ? do_wp_page+0x7e/0x450
[518758.189935]  __sys_sendmsg+0x48/0x80
[518758.189937]  __x64_sys_sendmsg+0x1a/0x20
[518758.189939]  do_syscall_64+0x53/0x1f0
[518758.189941]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[518758.189942] RIP: 0033:0x7fa15755169a
[518758.189944] Code: 48 c7 c0 ff ff ff ff eb be 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 18 b8 2e 00 00 00 c5 fc 77 0f 05 <48> 3d 00 f0 ff ff 77 5e c3 0f 1f 44 00 00 48 83 ec 28 89 54 24 1c
[518758.189946] RSP: 002b:00007ffda58b60b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[518758.189948] RAX: ffffffffffffffda RBX: 000055e4b836d9a0 RCX: 00007fa15755169a
[518758.189949] RDX: 0000000000000000 RSI: 00007ffda58b6128 RDI: 0000000000000003
[518758.189951] RBP: 00007ffda58b6190 R08: 0000000000000001 R09: 000055e4b9d848a0
[518758.189952] R10: 0000000000000000 R11: 0000000000000246 R12: 000000005d654b49
[518758.189953] R13: 0000000000000000 R14: 00007ffda58b6230 R15: 00007ffda58b6210
[518758.189955] Modules linked in: sch_cbs sch_etf sch_mqprio netlink_diag unix_diag e1000e igb intel_pch_thermal thermal video backlight pcc_cpufreq
[518758.189960] CR2: 0000000000000000
[518758.189961] ---[ end trace 6a13f7aaf5376019 ]---
[518758.189963] RIP: 0010:__list_del_entry_valid+0x29/0xa0
[518758.189964] Code: 90 48 b8 00 01 00 00 00 00 ad de 55 48 8b 17 4c 8b 47 08 48 89 e5 48 39 c2 74 27 48 b8 00 02 00 00 00 00 ad de 49 39 c0 74 2d <49> 8b 30 48 39 fe 75 3d 48 8b 52 08 48 39 f2 75 4c b8 01 00 00 00
[518758.189967] RSP: 0018:ffffa27e43903990 EFLAGS: 00010207
[518758.189968] RAX: dead000000000200 RBX: ffff8bce69f0f000 RCX: 0000000000000000
[518758.189969] RDX: 0000000000000000 RSI: ffff8bce69f0f064 RDI: ffff8bce69f0f1e0
[518758.189971] RBP: ffffa27e43903990 R08: 0000000000000000 R09: ffff8bce69e788c0
[518758.189972] R10: ffff8bce62acd400 R11: 00000000000003cb R12: ffff8bce69e78000
[518758.189973] R13: ffff8bce69f0f140 R14: 0000000000000000 R15: 0000000000000000
[518758.189975] FS:  00007fa1572c8f80(0000) GS:ffff8bce6e0c0000(0000) knlGS:0000000000000000
[518758.189976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[518758.189977] CR2: 0000000000000000 CR3: 000000040a398006 CR4: 00000000003606e0
[518758.189979] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[518758.189980] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: e0a7683 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---

Changes from v2:
  - Simplification to cbs_init() (Cong Wang)

Changes from v1:
  - Expanded commit message.


 net/sched/sch_cbs.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 93b58fd..1bef152 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -392,7 +392,6 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	int err;
 
 	if (!opt) {
 		NL_SET_ERR_MSG(extack, "Missing CBS qdisc options  which are mandatory");
@@ -404,6 +403,10 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!q->qdisc)
 		return -ENOMEM;
 
+	spin_lock(&cbs_list_lock);
+	list_add(&q->cbs_list, &cbs_list);
+	spin_unlock(&cbs_list_lock);
+
 	qdisc_hash_add(q->qdisc, false);
 
 	q->queue = sch->dev_queue - netdev_get_tx_queue(dev, 0);
@@ -413,17 +416,7 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 
 	qdisc_watchdog_init(&q->watchdog, sch);
 
-	err = cbs_change(sch, opt, extack);
-	if (err)
-		return err;
-
-	if (!q->offload) {
-		spin_lock(&cbs_list_lock);
-		list_add(&q->cbs_list, &cbs_list);
-		spin_unlock(&cbs_list_lock);
-	}
-
-	return 0;
+	return cbs_change(sch, opt, extack);
 }
 
 static void cbs_destroy(struct Qdisc *sch)
@@ -431,15 +424,18 @@ static void cbs_destroy(struct Qdisc *sch)
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

