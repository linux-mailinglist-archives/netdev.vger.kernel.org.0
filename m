Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09603154E47
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgBFVo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:44:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:55693 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgBFVot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 16:44:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 13:44:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="225156047"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by orsmga008.jf.intel.com with ESMTP; 06 Feb 2020 13:44:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v4 1/5] taprio: Fix enabling offload with wrong number of traffic classes
Date:   Thu,  6 Feb 2020 13:46:06 -0800
Message-Id: <20200206214610.1307191-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200206214610.1307191-1-vinicius.gomes@intel.com>
References: <20200206214610.1307191-1-vinicius.gomes@intel.com>
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

