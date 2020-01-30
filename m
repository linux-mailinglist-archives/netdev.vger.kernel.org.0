Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8FE14D503
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 02:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgA3BgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 20:36:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:49906 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727139AbgA3BgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 20:36:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 17:36:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,380,1574150400"; 
   d="scan'208";a="262008478"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by fmsmga002.fm.intel.com with ESMTP; 29 Jan 2020 17:36:13 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v3 2/2] taprio: Fix still allowing changing the flags during runtime
Date:   Wed, 29 Jan 2020 17:37:21 -0800
Message-Id: <20200130013721.33812-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130013721.33812-1-vinicius.gomes@intel.com>
References: <20200130013721.33812-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because 'q->flags' starts as zero, and zero is a valid value, we
aren't able to detect the transition from zero to something else
during "runtime".

The solution is to initialize 'q->flags' with an invalid value, so we
can detect if 'q->flags' was set by the user or not.

To better solidify the behavior, 'flags' handling is moved to a
separate function. The behavior is:
 - 'flags' if unspecified by the user, is assumed to be zero;
 - 'flags' cannot change during "runtime" (i.e. a change() request
 cannot modify it);

Allowing flags to be changed was causing the following RCU stall:

[ 1730.558249] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1730.558258] rcu: 	  6-...0: (190 ticks this GP) idle=922/0/0x1 softirq=25580/25582 fqs=16250
[ 1730.558264] 		  (detected by 2, t=65002 jiffies, g=33017, q=81)
[ 1730.558269] Sending NMI from CPU 2 to CPUs 6:
[ 1730.559277] NMI backtrace for cpu 6
[ 1730.559277] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G            E     5.5.0-rc6+ #35
[ 1730.559278] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS ULTRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
[ 1730.559278] RIP: 0010:__hrtimer_run_queues+0xe2/0x440
[ 1730.559278] Code: 48 8b 43 28 4c 89 ff 48 8b 75 c0 48 89 45 c8 e8 f4 bb 7c 00 0f 1f 44 00 00 65 8b 05 40 31 f0 68 89 c0 48 0f a3 05 3e 5c 25 01 <0f> 82 fc 01 00 00 48 8b 45 c8 48 89 df ff d0 89 45 c8 0f 1f 44 00
[ 1730.559279] RSP: 0018:ffff9970802d8f10 EFLAGS: 00000083
[ 1730.559279] RAX: 0000000000000006 RBX: ffff8b31645bff38 RCX: 0000000000000000
[ 1730.559280] RDX: 0000000000000000 RSI: ffffffff9710f2ec RDI: ffffffff978daf0e
[ 1730.559280] RBP: ffff9970802d8f68 R08: 0000000000000000 R09: 0000000000000000
[ 1730.559280] R10: 0000018336d7944e R11: 0000000000000001 R12: ffff8b316e39f9c0
[ 1730.559281] R13: ffff8b316e39f940 R14: ffff8b316e39f998 R15: ffff8b316e39f7c0
[ 1730.559281] FS:  0000000000000000(0000) GS:ffff8b316e380000(0000) knlGS:0000000000000000
[ 1730.559281] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1730.559281] CR2: 00007f1105303760 CR3: 0000000227210005 CR4: 00000000003606e0
[ 1730.559282] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1730.559282] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1730.559282] Call Trace:
[ 1730.559282]  <IRQ>
[ 1730.559283]  ? taprio_dequeue_soft+0x2d0/0x2d0 [sch_taprio]
[ 1730.559283]  hrtimer_interrupt+0x104/0x220
[ 1730.559283]  ? irqtime_account_irq+0x34/0xa0
[ 1730.559283]  smp_apic_timer_interrupt+0x6d/0x230
[ 1730.559284]  apic_timer_interrupt+0xf/0x20
[ 1730.559284]  </IRQ>
[ 1730.559284] RIP: 0010:cpu_idle_poll+0x35/0x1a0
[ 1730.559285] Code: 88 82 ff 65 44 8b 25 12 7d 73 68 0f 1f 44 00 00 e8 90 c3 89 ff fb 65 48 8b 1c 25 c0 7e 01 00 48 8b 03 a8 08 74 0b eb 1c f3 90 <48> 8b 03 a8 08 75 13 8b 05 be a8 a8 00 85 c0 75 ed e8 75 48 84 ff
[ 1730.559285] RSP: 0018:ffff997080137ea8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
[ 1730.559285] RAX: 0000000000000001 RBX: ffff8b316bc3c580 RCX: 0000000000000000
[ 1730.559286] RDX: 0000000000000001 RSI: 000000002819aad9 RDI: ffffffff978da730
[ 1730.559286] RBP: ffff997080137ec0 R08: 0000018324a6d387 R09: 0000000000000000
[ 1730.559286] R10: 0000000000000400 R11: 0000000000000001 R12: 0000000000000006
[ 1730.559286] R13: ffff8b316bc3c580 R14: 0000000000000000 R15: 0000000000000000
[ 1730.559287]  ? cpu_idle_poll+0x20/0x1a0
[ 1730.559287]  ? cpu_idle_poll+0x20/0x1a0
[ 1730.559287]  do_idle+0x4d/0x1f0
[ 1730.559287]  ? complete+0x44/0x50
[ 1730.559288]  cpu_startup_entry+0x1b/0x20
[ 1730.559288]  start_secondary+0x142/0x180
[ 1730.559288]  secondary_startup_64+0xb6/0xc0
[ 1776.686313] nvme nvme0: I/O 96 QID 1 timeout, completion polled

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 61 ++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ad0dadcfcdba..7290de6cc0bc 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -31,6 +31,7 @@ static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
 #define FULL_OFFLOAD_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
+#define TAPRIO_FLAGS_INVALID U32_MAX
 
 struct sched_entry {
 	struct list_head list;
@@ -1367,6 +1368,33 @@ static int taprio_mqprio_cmp(const struct net_device *dev,
 	return 0;
 }
 
+/* The semantics of the 'flags' argument in relation to 'change()'
+ * requests, are interpreted following two rules (which are applied in
+ * this order): (1) an omitted 'flags' argument is interpreted as
+ * zero; (2) the 'flags' of a "running" taprio instance cannot be
+ * changed.
+ */
+static int taprio_new_flags(const struct nlattr *attr, u32 old,
+			    struct netlink_ext_ack *extack)
+{
+	u32 new = 0;
+
+	if (attr)
+		new = nla_get_u32(attr);
+
+	if (old != TAPRIO_FLAGS_INVALID && old != new) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
+		return -ENOTSUPP;
+	}
+
+	if (!taprio_flags_valid(new)) {
+		NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
+		return -EINVAL;
+	}
+
+	return new;
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -1375,7 +1403,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
-	u32 taprio_flags = 0;
 	unsigned long flags;
 	ktime_t start;
 	int i, err;
@@ -1388,21 +1415,14 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
 		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
 
-	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
-		taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
-
-		if (q->flags != 0 && q->flags != taprio_flags) {
-			NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
-			return -EOPNOTSUPP;
-		} else if (!taprio_flags_valid(taprio_flags)) {
-			NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
-			return -EINVAL;
-		}
+	err = taprio_new_flags(tb[TCA_TAPRIO_ATTR_FLAGS],
+			       q->flags, extack);
+	if (err < 0)
+		return err;
 
-		q->flags = taprio_flags;
-	}
+	q->flags = err;
 
-	err = taprio_parse_mqprio_opt(dev, mqprio, extack, taprio_flags);
+	err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
 	if (err < 0)
 		return err;
 
@@ -1457,7 +1477,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
-	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
 	else
 		err = taprio_disable_offload(dev, q, extack);
@@ -1477,14 +1497,14 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		q->txtime_delay = nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
 	}
 
-	if (!TXTIME_ASSIST_IS_ENABLED(taprio_flags) &&
-	    !FULL_OFFLOAD_IS_ENABLED(taprio_flags) &&
+	if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
+	    !FULL_OFFLOAD_IS_ENABLED(q->flags) &&
 	    !hrtimer_active(&q->advance_timer)) {
 		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
 		q->advance_timer.function = advance_sched;
 	}
 
-	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags)) {
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 		q->dequeue = taprio_dequeue_offload;
 		q->peek = taprio_peek_offload;
 	} else {
@@ -1501,7 +1521,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
-	if (TXTIME_ASSIST_IS_ENABLED(taprio_flags)) {
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
 		setup_txtime(q, new_admin, start);
 
 		if (!oper) {
@@ -1528,7 +1548,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		spin_unlock_irqrestore(&q->current_entry_lock, flags);
 
-		if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+		if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 			taprio_offload_config_changed(q);
 	}
 
@@ -1597,6 +1617,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 * and get the valid one on taprio_change().
 	 */
 	q->clockid = -1;
+	q->flags = TAPRIO_FLAGS_INVALID;
 
 	spin_lock(&taprio_list_lock);
 	list_add(&q->taprio_list, &taprio_list);
-- 
2.25.0

