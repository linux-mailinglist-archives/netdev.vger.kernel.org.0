Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD56BD72A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCPRdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCPRdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:33:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6382EB5FDB
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678988018; x=1710524018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8xevIRTYWQZFD8RwPeoV/PYM36SpXmhAyIwOOsRvMYo=;
  b=l/BOMH2sboo10s5plTJdFmn9jrut/GeAEOLy9Y/SayZehRo4ONMP9kxb
   0dMEIv8o4+KLoPcy1xsrzI0Apd0Xq1h9MCdim8DNjaX2AJn2HxDBRkcgu
   Fe5iR+6U9HJTTeqUHQJqtAsRwlxsJPipsyRSpglNIkz2O82PoVIyNF50x
   c5askITtWIBJqsxMTTLp8hx3R0LJl2yhlg2KPgTG7sDSfTe6PnkvfOCRU
   +/ji35Z46usuDM4meOJcXEIXXR4S72RJnAokhmsEIJauIsyQn4RVN9s4W
   JXl6fMKiXJ4j8ZZNLEAnc7spTZtPKoayCjfQadS2DeYKNQbqQmtsHnM96
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="402948310"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402948310"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 10:33:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="679982485"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679982485"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 10:33:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     AKASHI Takahiro <takahiro.akashi@linaro.org>,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 5/5] igc: fix the validation logic for taprio's gate list
Date:   Thu, 16 Mar 2023 10:31:44 -0700
Message-Id: <20230316173144.2003469-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
References: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: AKASHI Takahiro <takahiro.akashi@linaro.org>

The check introduced in the commit a5fd39464a40 ("igc: Lift TAPRIO schedule
restriction") can detect a false positive error in some corner case.
For instance,
    tc qdisc replace ... taprio num_tc 4
	...
	sched-entry S 0x01 100000	# slot#1
	sched-entry S 0x03 100000	# slot#2
	sched-entry S 0x04 100000	# slot#3
	sched-entry S 0x08 200000	# slot#4
	flags 0x02			# hardware offload

Here the queue#0 (the first queue) is on at the slot#1 and #2,
and off at the slot#3 and #4. Under the current logic, when the slot#4
is examined, validate_schedule() returns *false* since the enablement
count for the queue#0 is two and it is already off at the previous slot
(i.e. #3). But this definition is truely correct.

Let's fix the logic to enforce a strict validation for consecutively-opened
slots.

Fixes: a5fd39464a40 ("igc: Lift TAPRIO schedule restriction")
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2928a6c73692..25fc6c65209b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6010,18 +6010,18 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < adapter->num_tx_queues; i++) {
-			if (e->gate_mask & BIT(i))
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			if (e->gate_mask & BIT(i)) {
 				queue_uses[i]++;
 
-			/* There are limitations: A single queue cannot be
-			 * opened and closed multiple times per cycle unless the
-			 * gate stays open. Check for it.
-			 */
-			if (queue_uses[i] > 1 &&
-			    !(prev->gate_mask & BIT(i)))
-				return false;
-		}
+				/* There are limitations: A single queue cannot
+				 * be opened and closed multiple times per cycle
+				 * unless the gate stays open. Check for it.
+				 */
+				if (queue_uses[i] > 1 &&
+				    !(prev->gate_mask & BIT(i)))
+					return false;
+			}
 	}
 
 	return true;
-- 
2.38.1

