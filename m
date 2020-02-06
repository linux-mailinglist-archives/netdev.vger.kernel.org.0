Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC202154E43
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBFVov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:44:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:55694 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbgBFVot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 16:44:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 13:44:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="225156055"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by orsmga008.jf.intel.com with ESMTP; 06 Feb 2020 13:44:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v4 4/5] taprio: Use taprio_reset_tc() to reset Traffic Classes configuration
Date:   Thu,  6 Feb 2020 13:46:09 -0800
Message-Id: <20200206214610.1307191-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200206214610.1307191-1-vinicius.gomes@intel.com>
References: <20200206214610.1307191-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When destroying the current taprio instance, which can happen when the
creation of one fails, we should reset the traffic class configuration
back to the default state.

netdev_reset_tc() is a better way because in addition to setting the
number of traffic classes to zero, it also resets the priority to
traffic classes mapping to the default value.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b82a9769ab40..21df69071df2 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1588,7 +1588,7 @@ static void taprio_destroy(struct Qdisc *sch)
 	}
 	q->qdiscs = NULL;
 
-	netdev_set_num_tc(dev, 0);
+	netdev_reset_tc(dev);
 
 	if (q->oper_sched)
 		call_rcu(&q->oper_sched->rcu, taprio_free_sched_cb);
-- 
2.25.0

