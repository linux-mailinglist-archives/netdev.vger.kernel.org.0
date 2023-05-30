Return-Path: <netdev+bounces-6282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CEA0715870
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EE06281093
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6735812B75;
	Tue, 30 May 2023 08:27:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F8F12B63
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:27:23 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1147B0;
	Tue, 30 May 2023 01:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685435241; x=1716971241;
  h=from:to:cc:subject:date:message-id;
  bh=Y1u5VKUrzfq/TNpbW/rgb44i5VtQdp1XEdoxN1+4FaQ=;
  b=gRCEM/u5HJ7eLgm0k651uKrFITbUXG9FFQmUuF/NZCPjGxfRAsHBkWjg
   Pp1bnA9TPSoZGPIOQHHo4ZGBeZBecuQij/DN6aQMahf/AEevN5Z7uyTHv
   zupwwTOiHsV3iMgSlweFY7QmbHyT1aOVJvY2JiY5uP34SKoWf1caMzhKb
   KHUAW3lqWTxBpvFm300E8MMM9mWzQ+gozdl/9ViM0AaCfJxvfSC3mfEdg
   TF8ZdxsIv01gjrEgtuKJ7AKXK7UjE1ckuT77oecMP2fZnhOgrSvCFhn8J
   vxmRXSlPsSSonQTI+fMiLZHJkx7B6vP0K7V3pahLo0nxPZeIkaZsxkw87
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="383107721"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="383107721"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:27:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="953034513"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="953034513"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga006.fm.intel.com with ESMTP; 30 May 2023 01:27:18 -0700
From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To: netdev@vger.kernel.org,
	vinicius.gomes@intel.com,
	kuba@kernel.org,
	vladimir.oltean@nxp.com,
	pabeni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	tee.min.tan@linux.intel.com,
	muhammad.husaini.zulkifli@intel.com,
	edumazet@google.com
Subject: [PATCH net v1] net/sched: taprio: fix cycle time extension logic
Date: Tue, 30 May 2023 16:25:41 +0800
Message-Id: <20230530082541.495-1-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

From: Tan Tee Min <tee.min.tan@linux.intel.com>

According to IEEE Std. 802.1Q-2018 section Q.5 CycleTimeExtension,
the Cycle Time Extension variable allows this extension of the last old
cycle to be done in a defined way. If the last complete old cycle would
normally end less than OperCycleTimeExtension nanoseconds before the new
base time, then the last complete cycle before AdminBaseTime is reached
is extended so that it ends at AdminBaseTime.

This patch extends the last entry of last complete cycle to AdminBaseTime.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 net/sched/sch_taprio.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 76db9a10ef504..ef487fef83fce 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -99,6 +99,7 @@ struct taprio_sched {
 	u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
 	u32 fp[TC_QOPT_MAX_QUEUE]; /* only for dump and offloading */
 	u32 txtime_delay;
+	bool sched_changed;
 };
 
 struct __tc_taprio_qopt_offload {
@@ -934,8 +935,10 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	admin = rcu_dereference_protected(q->admin_sched,
 					  lockdep_is_held(&q->current_entry_lock));
 
-	if (!oper)
+	if (!oper || q->sched_changed) {
+		q->sched_changed = false;
 		switch_schedules(q, &admin, &oper);
+	}
 
 	/* This can happen in two cases: 1. this is the very first run
 	 * of this function (i.e. we weren't running any schedule
@@ -962,20 +965,27 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	end_time = ktime_add_ns(entry->end_time, next->interval);
 	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
+	if (should_change_schedules(admin, oper, oper->cycle_end_time) &&
+	    list_is_last(&next->list, &oper->entries)) {
+		u32 ori_interval = next->interval;
+
+		next->interval += ktime_sub(sched_base_time(admin), end_time);
+		oper->cycle_time += next->interval - ori_interval;
+		end_time = sched_base_time(admin);
+		oper->cycle_end_time = end_time;
+		q->sched_changed = true;
+	}
+
 	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
+		if (next->gate_duration[tc] == oper->cycle_time) {
 			next->gate_close_time[tc] = KTIME_MAX;
-		else
+		} else if (q->sched_changed && next->gate_duration[tc]) {
+			next->gate_close_time[tc] = end_time;
+			next->gate_duration[tc] = next->interval;
+		} else {
 			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
 								 next->gate_duration[tc]);
-	}
-
-	if (should_change_schedules(admin, oper, end_time)) {
-		/* Set things so the next time this runs, the new
-		 * schedule runs.
-		 */
-		end_time = sched_base_time(admin);
-		switch_schedules(q, &admin, &oper);
+		}
 	}
 
 	next->end_time = end_time;
-- 
2.17.1


