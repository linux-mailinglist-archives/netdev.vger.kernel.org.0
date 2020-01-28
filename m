Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FABF14C3BF
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 00:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgA1XvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 18:51:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:42267 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgA1XvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 18:51:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2020 15:51:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,375,1574150400"; 
   d="scan'208";a="277321927"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jan 2020 15:51:16 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v2 2/3] taprio: Allow users not to specify "flags" when changing schedules
Date:   Tue, 28 Jan 2020 15:52:26 -0800
Message-Id: <20200128235227.3942256-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128235227.3942256-1-vinicius.gomes@intel.com>
References: <20200128235227.3942256-1-vinicius.gomes@intel.com>
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

This will make that we have one source of truth for 'flags'.

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ad0dadcfcdba..110143fba114 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1402,7 +1402,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		q->flags = taprio_flags;
 	}
 
-	err = taprio_parse_mqprio_opt(dev, mqprio, extack, taprio_flags);
+	err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
 	if (err < 0)
 		return err;
 
@@ -1457,7 +1457,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
-	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
 	else
 		err = taprio_disable_offload(dev, q, extack);
@@ -1477,14 +1477,14 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1501,7 +1501,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
-	if (TXTIME_ASSIST_IS_ENABLED(taprio_flags)) {
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
 		setup_txtime(q, new_admin, start);
 
 		if (!oper) {
@@ -1528,7 +1528,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		spin_unlock_irqrestore(&q->current_entry_lock, flags);
 
-		if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+		if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 			taprio_offload_config_changed(q);
 	}
 
-- 
2.25.0

