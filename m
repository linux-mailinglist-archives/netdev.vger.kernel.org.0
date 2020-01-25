Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828BB149265
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbgAYAwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:52:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:29976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387405AbgAYAwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 19:52:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 16:52:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="294841513"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2020 16:52:18 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v1 3/3] taprio: Allow users not to specify "flags" when changing schedules
Date:   Fri, 24 Jan 2020 16:53:20 -0800
Message-Id: <20200125005320.3353761-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200125005320.3353761-1-vinicius.gomes@intel.com>
References: <20200125005320.3353761-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When any offload mode is enabled, users had to specify the
"flags" parameter when adding a new "admin" schedule.

This fix allows that parameter to be omitted when adding a new
schedule.

Also move 'taprio_flags' to a smaller scope, so we reduce the region
where we have two variables with the similar concepts ('taprio_flags'
and 'q->flags').

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index dfbecb9ee2f4..65357e2ba04e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1375,7 +1375,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
-	u32 taprio_flags = 0;
 	unsigned long flags;
 	ktime_t start;
 	int i, err;
@@ -1389,7 +1388,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
 
 	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
-		taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
+		u32 taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
 
 		if (q->flags != taprio_flags) {
 			NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
@@ -1402,7 +1401,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		q->flags = taprio_flags;
 	}
 
-	err = taprio_parse_mqprio_opt(dev, mqprio, extack, taprio_flags);
+	err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
 	if (err < 0)
 		return err;
 
@@ -1457,7 +1456,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
-	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
 	else
 		err = taprio_disable_offload(dev, q, extack);
@@ -1477,14 +1476,14 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1501,7 +1500,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
-	if (TXTIME_ASSIST_IS_ENABLED(taprio_flags)) {
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
 		setup_txtime(q, new_admin, start);
 
 		if (!oper) {
@@ -1528,7 +1527,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		spin_unlock_irqrestore(&q->current_entry_lock, flags);
 
-		if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+		if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 			taprio_offload_config_changed(q);
 	}
 
-- 
2.25.0

