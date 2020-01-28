Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D3814C3BD
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 00:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgA1XvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 18:51:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:42267 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgA1XvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 18:51:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2020 15:51:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,375,1574150400"; 
   d="scan'208";a="277321924"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jan 2020 15:51:16 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v2 1/3] taprio: Fix enabling offload with wrong number of traffic classes
Date:   Tue, 28 Jan 2020 15:52:25 -0800
Message-Id: <20200128235227.3942256-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128235227.3942256-1-vinicius.gomes@intel.com>
References: <20200128235227.3942256-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the driver implementing taprio offloading depends on the value of
the network device number of traffic classes (dev->num_tc) for
whatever reason, it was going to receive the value zero. The value was
only set after the offloading function is called.

So, moving setting the number of traffic classes to before the
offloading function is called fixes this issue. This is safe because
this only happens when taprio is instantiated (we don't allow this
configuration to be changed without first removing taprio).

Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Reported-by: Po Liu <po.liu@nxp.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c609373c8661..ad0dadcfcdba 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1444,6 +1444,19 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	taprio_set_picos_per_byte(dev, q);
 
+	if (mqprio) {
+		netdev_set_num_tc(dev, mqprio->num_tc);
+		for (i = 0; i < mqprio->num_tc; i++)
+			netdev_set_tc_queue(dev, i,
+					    mqprio->count[i],
+					    mqprio->offset[i]);
+
+		/* Always use supplied priority mappings */
+		for (i = 0; i <= TC_BITMASK; i++)
+			netdev_set_prio_tc_map(dev, i,
+					       mqprio->prio_tc_map[i]);
+	}
+
 	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
 		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
 	else
@@ -1471,19 +1484,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		q->advance_timer.function = advance_sched;
 	}
 
-	if (mqprio) {
-		netdev_set_num_tc(dev, mqprio->num_tc);
-		for (i = 0; i < mqprio->num_tc; i++)
-			netdev_set_tc_queue(dev, i,
-					    mqprio->count[i],
-					    mqprio->offset[i]);
-
-		/* Always use supplied priority mappings */
-		for (i = 0; i <= TC_BITMASK; i++)
-			netdev_set_prio_tc_map(dev, i,
-					       mqprio->prio_tc_map[i]);
-	}
-
 	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags)) {
 		q->dequeue = taprio_dequeue_offload;
 		q->peek = taprio_peek_offload;
-- 
2.25.0

