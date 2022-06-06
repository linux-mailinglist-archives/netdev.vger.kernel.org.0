Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D14A53EC28
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiFFJ2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 05:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiFFJ2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 05:28:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D75DF53
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 02:28:07 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654507685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h0mv3Rgx96FN+/OFOGtmFOM6oVf6bWOhe0iKb3I5DyM=;
        b=pmuXX6a324DjO+/TQPmrwMd0vfnwotl2m96Im1D6qL507Q+L2knsTK+i/adcmrb1eYN2Ug
        yX0QdD+tNwA2aofYuPVF94TkM7clBJ90DqNU9iylT5iA7ritZT3aZoR8EIV2I2/5nrN97k
        ko6H9S1HK3uLesOHbuGJ4hOWuB9/qXWC3zW98/cqVWoViPsifGdZrjJRzHxsDvO6c9nrAB
        a/CEbYPayKTc38HByFysAdPnfJBbhsHy3K+nnZXKTKLYPFUaZ3OILAsz823nDfO/h4fa17
        +3dg0riubK0RxbHpbB7MJVXTOfJX/LoixuKNo6xpq6GgSLSTAaEwgvx3q9AgGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654507685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h0mv3Rgx96FN+/OFOGtmFOM6oVf6bWOhe0iKb3I5DyM=;
        b=fHb7pCB0G9Cs8FkAm0TdMvAGKMFbCAw//JRMu47w5/m6fLgfA4NalLIrBWZZVqEURy1Ehw
        Sio9RoLyMtY0RTAw==
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] igc: Lift TAPRIO schedule restriction
Date:   Mon,  6 Jun 2022 11:27:47 +0200
Message-Id: <20220606092747.16730-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.30.2

