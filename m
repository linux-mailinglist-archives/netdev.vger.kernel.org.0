Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6474B154E46
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBFVou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:44:50 -0500
Received: from mga04.intel.com ([192.55.52.120]:55694 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbgBFVot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 16:44:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 13:44:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="225156057"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by orsmga008.jf.intel.com with ESMTP; 06 Feb 2020 13:44:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v4 5/5] taprio: Fix dropping packets when using taprio + ETF offloading
Date:   Thu,  6 Feb 2020 13:46:10 -0800
Message-Id: <20200206214610.1307191-6-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200206214610.1307191-1-vinicius.gomes@intel.com>
References: <20200206214610.1307191-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using taprio offloading together with ETF offloading, configured
like this, for example:

$ tc qdisc replace dev $IFACE parent root handle 100 taprio \
  	num_tc 4 \
        map 2 2 1 0 3 2 2 2 2 2 2 2 2 2 2 2 \
	queues 1@0 1@1 1@2 1@3 \
	base-time $BASE_TIME \
	sched-entry S 01 1000000 \
	sched-entry S 0e 1000000 \
	flags 0x2

$ tc qdisc replace dev $IFACE parent 100:1 etf \
     	offload delta 300000 clockid CLOCK_TAI

During enqueue, it works out that the verification added for the
"txtime" assisted mode is run when using taprio + ETF offloading, the
only thing missing is initializing the 'next_txtime' of all the cycle
entries. (if we don't set 'next_txtime' all packets from SO_TXTIME
sockets are dropped)

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 21df69071df2..660fc45ee40f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1522,9 +1522,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
-	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		setup_txtime(q, new_admin, start);
+	setup_txtime(q, new_admin, start);
 
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
 		if (!oper) {
 			rcu_assign_pointer(q->oper_sched, new_admin);
 			err = 0;
-- 
2.25.0

