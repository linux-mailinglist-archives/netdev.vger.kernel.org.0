Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB905251E97
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgHYRoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:44:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:7427 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgHYRoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 13:44:13 -0400
IronPort-SDR: aUumUTDwCz53Y2iHGwyAe3LAAUcoR1diOiWxoAYxmBFJAVcHCS7hB9nfWjwrWPOZz4TIAr8+Bp
 0IFeqYWCsdhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="155426814"
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="155426814"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 10:44:12 -0700
IronPort-SDR: zqhS6m/fLND9RgCesJVjpsnSbLCbCb3AXwQnlT9WRKKPBrzUIrbwF+Ghr3rZU/jwWiSRJouhJI
 xzyW8N/vSLPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="499936952"
Received: from adent-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.77.195])
  by fmsmga005.fm.intel.com with ESMTP; 25 Aug 2020 10:44:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, kurt@linutronix.de
Subject: [PATCH net-next v1] taprio: Fix using wrong queues in gate mask
Date:   Tue, 25 Aug 2020 10:44:04 -0700
Message-Id: <20200825174404.2727633-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 9c66d1564676 ("taprio: Add support for hardware
offloading") there's a bit of inconsistency when offloading schedules
to the hardware:

In software mode, the gate masks are specified in terms of traffic
classes, so if say "sched-entry S 03 20000", it means that the traffic
classes 0 and 1 are open for 20us; when taprio is offloaded to
hardware, the gate masks are specified in terms of hardware queues.

The idea here is to fix hardware offloading, so schedules in hardware
and software mode have the same behavior. What's needed to do is to
map traffic classes to queues when applying the offload to the driver.

Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index e981992634dd..fe53c1e38c7d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1176,9 +1176,27 @@ static void taprio_offload_config_changed(struct taprio_sched *q)
 	spin_unlock(&q->current_entry_lock);
 }
 
-static void taprio_sched_to_offload(struct taprio_sched *q,
+static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
+{
+	u32 i, queue_mask = 0;
+
+	for (i = 0; i < dev->num_tc; i++) {
+		u32 offset, count;
+
+		if (!(tc_mask & BIT(i)))
+			continue;
+
+		offset = dev->tc_to_txq[i].offset;
+		count = dev->tc_to_txq[i].count;
+
+		queue_mask |= GENMASK(offset + count - 1, offset);
+	}
+
+	return queue_mask;
+}
+
+static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    const struct tc_mqprio_qopt *mqprio,
 				    struct tc_taprio_qopt_offload *offload)
 {
 	struct sched_entry *entry;
@@ -1193,7 +1211,8 @@ static void taprio_sched_to_offload(struct taprio_sched *q,
 
 		e->command = entry->command;
 		e->interval = entry->interval;
-		e->gate_mask = entry->gate_mask;
+		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
+
 		i++;
 	}
 
@@ -1201,7 +1220,6 @@ static void taprio_sched_to_offload(struct taprio_sched *q,
 }
 
 static int taprio_enable_offload(struct net_device *dev,
-				 struct tc_mqprio_qopt *mqprio,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
 				 struct netlink_ext_ack *extack)
@@ -1223,7 +1241,7 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
-	taprio_sched_to_offload(q, sched, mqprio, offload);
+	taprio_sched_to_offload(dev, sched, offload);
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
@@ -1485,7 +1503,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
-		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
+		err = taprio_enable_offload(dev, q, new_admin, extack);
 	else
 		err = taprio_disable_offload(dev, q, extack);
 	if (err)
-- 
2.28.0

