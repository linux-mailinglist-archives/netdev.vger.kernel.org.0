Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808E8149266
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbgAYAwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:52:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:29976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387475AbgAYAwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 19:52:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 16:52:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="294841487"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2020 16:52:18 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v1 1/3] taprio: Fix enabling offload with wrong number of traffic classes
Date:   Fri, 24 Jan 2020 16:53:18 -0800
Message-Id: <20200125005320.3353761-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200125005320.3353761-1-vinicius.gomes@intel.com>
References: <20200125005320.3353761-1-vinicius.gomes@intel.com>
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

