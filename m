Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238D2578929
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiGRSEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbiGRSEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:04:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93DD2CDDE
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658167458; x=1689703458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J/rXRjy1jMAk01OZR4jRtxMroPZaFRupbWUF9WOib9s=;
  b=RIA9l3294cPfS62ziHyrBYYp9W7guuhh1x5fLZBd7wenV+Ykt54znyl8
   7EV1MgX1fRB1hkNDWK/9ucJfi49m2UeyreaUm+lQnVFD1p0ZZlMhsC0Qd
   Nyds752jc1qpJFLovZM7s9kfcrYAzsye0vMaf0tAPezxktnffY6C9tVsI
   0SV96ZJK2BAQx2Q/YU7a79s8XS1m4+bcwPVoBvcqW5jjfEj9d9UgFP9bi
   lhugTL0txFVwG1w3LJ+9+4MM6SHGLFGoXE9sSuojPexQ/bpCKwY1OFX+N
   D8erVZPhtAkyN4GrZHZM6qqCHEN8sEP23GYI73WGo/qKrVMMl93lYK/mI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287434728"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="287434728"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:04:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655392512"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 11:04:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 1/3] igc: Lift TAPRIO schedule restriction
Date:   Mon, 18 Jul 2022 11:01:07 -0700
Message-Id: <20220718180109.4114540-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220718180109.4114540-1-anthony.l.nguyen@intel.com>
References: <20220718180109.4114540-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

Add support for Qbv schedules where one queue stays open
in consecutive entries. Currently that's not supported.

Example schedule:

|tc qdisc replace dev ${INTERFACE} handle 100 parent root taprio num_tc 3 \
|   map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
|   queues 1@0 1@1 2@2 \
|   base-time ${BASETIME} \
|   sched-entry S 0x01 300000 \ # Stream High/Low
|   sched-entry S 0x06 500000 \ # Management and Best Effort
|   sched-entry S 0x04 200000 \ # Best Effort
|   flags 0x02

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ae17af44fe02..4758bdbe5df3 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5813,9 +5813,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		return false;
 
 	for (n = 0; n < qopt->num_entries; n++) {
-		const struct tc_taprio_sched_entry *e;
+		const struct tc_taprio_sched_entry *e, *prev;
 		int i;
 
+		prev = n ? &qopt->entries[n - 1] : NULL;
 		e = &qopt->entries[n];
 
 		/* i225 only supports "global" frame preemption
@@ -5828,7 +5829,12 @@ static bool validate_schedule(struct igc_adapter *adapter,
 			if (e->gate_mask & BIT(i))
 				queue_uses[i]++;
 
-			if (queue_uses[i] > 1)
+			/* There are limitations: A single queue cannot be
+			 * opened and closed multiple times per cycle unless the
+			 * gate stays open. Check for it.
+			 */
+			if (queue_uses[i] > 1 &&
+			    !(prev->gate_mask & BIT(i)))
 				return false;
 		}
 	}
@@ -5872,6 +5878,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 				 struct tc_taprio_qopt_offload *qopt)
 {
+	bool queue_configured[IGC_MAX_TX_QUEUES] = { };
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 
@@ -5887,9 +5894,6 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	adapter->cycle_time = qopt->cycle_time;
 	adapter->base_time = qopt->base_time;
 
-	/* FIXME: be a little smarter about cases when the gate for a
-	 * queue stays open for more than one entry.
-	 */
 	for (n = 0; n < qopt->num_entries; n++) {
 		struct tc_taprio_sched_entry *e = &qopt->entries[n];
 		int i;
@@ -5902,8 +5906,15 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 			if (!(e->gate_mask & BIT(i)))
 				continue;
 
-			ring->start_time = start_time;
+			/* Check whether a queue stays open for more than one
+			 * entry. If so, keep the start and advance the end
+			 * time.
+			 */
+			if (!queue_configured[i])
+				ring->start_time = start_time;
 			ring->end_time = end_time;
+
+			queue_configured[i] = true;
 		}
 
 		start_time += e->interval;
-- 
2.35.1

