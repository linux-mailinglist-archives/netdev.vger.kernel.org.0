Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59243B4B8D
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhFZAgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:48451 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhFZAgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:04 -0400
IronPort-SDR: ef6qv3RzNo8UbyHxJsWRreD/xuNkHBL/hN/lZ0IOvL3MmAzbVLuQCYI0SFeha0lhpruFIyMQth
 ztf901jRqXmg==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054020"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054020"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:42 -0700
IronPort-SDR: WOmR0nQg/8nF1b3TfYd7pXKwt61TzWUwcueqhEWb0gMfL+UHvLpsDch+THC/qWpDEA5iwjoyhI
 bT9kFDPLq/Tw==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008606"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:41 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 04/12] taprio: Replace tc_map_to_queue_mask()
Date:   Fri, 25 Jun 2021 17:33:06 -0700
Message-Id: <20210626003314.3159402-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210626003314.3159402-1-vinicius.gomes@intel.com>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replaces tc_map_to_queue_mask() by netdev_tc_map_to_queue_mask() that
was just introduced.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 58586f98c648..4e411ca3a9eb 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1201,25 +1201,6 @@ static void taprio_offload_config_changed(struct taprio_sched *q)
 	spin_unlock(&q->current_entry_lock);
 }
 
-static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
-{
-	u32 i, queue_mask = 0;
-
-	for (i = 0; i < dev->num_tc; i++) {
-		u32 offset, count;
-
-		if (!(tc_mask & BIT(i)))
-			continue;
-
-		offset = dev->tc_to_txq[i].offset;
-		count = dev->tc_to_txq[i].count;
-
-		queue_mask |= GENMASK(offset + count - 1, offset);
-	}
-
-	return queue_mask;
-}
-
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
 				    struct tc_taprio_qopt_offload *offload)
@@ -1236,7 +1217,7 @@ static void taprio_sched_to_offload(struct net_device *dev,
 
 		e->command = entry->command;
 		e->interval = entry->interval;
-		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
+		e->gate_mask = netdev_tc_map_to_queue_mask(dev, entry->gate_mask);
 
 		i++;
 	}
@@ -1536,14 +1517,15 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]) {
 		u32 preempt = nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]);
 		struct tc_preempt_qopt_offload qopt = { };
+		u32 all_tcs_mask = GENMASK(mqprio->num_tc, 0);
 
-		if (preempt == U32_MAX) {
+		if ((preempt & all_tcs_mask) == all_tcs_mask) {
 			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible");
 			err = -EINVAL;
 			goto free_sched;
 		}
 
-		qopt.preemptible_queues = tc_map_to_queue_mask(dev, preempt);
+		qopt.preemptible_queues = netdev_tc_map_to_queue_mask(dev, preempt);
 
 		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
 						    &qopt);
-- 
2.32.0

