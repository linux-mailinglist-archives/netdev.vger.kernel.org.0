Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901F727B879
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgI1Xxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:53:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:33804 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI1Xxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:53:42 -0400
IronPort-SDR: k6Mgk30GZJnTtfXlLE3tDCh20FVQZXvzPyk0pDuSxlU/67qTJUlwI3abxdCS33PWZq4Ewlucm9
 Wq+o6do8P1aw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="180224664"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="180224664"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:30 -0700
IronPort-SDR: fLM2tKmWnfpMd/KgNR/C5nPX2CqRR/L++JJ/WY9N1KN5ndKEUwq9btUZLOFP7hji/Oc67yGWrT
 6mh167zJzyBQ==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962131"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 13/15] igc: Reject schedules with a base_time in the future
Date:   Mon, 28 Sep 2020 14:50:16 -0700
Message-Id: <20200928215018.952991-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

When we set the BASET registers of i225 with a base_time in the
future, i225 will "hold" all packets until that base_time is reached,
causing a lot of TX Hangs.

As this behaviour seems contrary to the expectations of the IEEE
802.1Q standard (section 8.6.9, especially 8.6.9.4.5), let's start by
rejecting these types of schedules. If this is too limiting, we can
for example, setup a timer to configure the BASET registers closer to
the start time, only blocking the packets for a "short" while.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 25 +++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1c16cd35c81c..569747bbefd8 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4702,14 +4702,35 @@ static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
 	return 0;
 }
 
-static bool validate_schedule(const struct tc_taprio_qopt_offload *qopt)
+static bool is_base_time_past(ktime_t base_time, const struct timespec64 *now)
+{
+	struct timespec64 b;
+
+	b = ktime_to_timespec64(base_time);
+
+	return timespec64_compare(now, &b) > 0;
+}
+
+static bool validate_schedule(struct igc_adapter *adapter,
+			      const struct tc_taprio_qopt_offload *qopt)
 {
 	int queue_uses[IGC_MAX_TX_QUEUES] = { };
+	struct timespec64 now;
 	size_t n;
 
 	if (qopt->cycle_time_extension)
 		return false;
 
+	igc_ptp_read(adapter, &now);
+
+	/* If we program the controller's BASET registers with a time
+	 * in the future, it will hold all the packets until that
+	 * time, causing a lot of TX Hangs, so to avoid that, we
+	 * reject schedules that would start in the future.
+	 */
+	if (!is_base_time_past(qopt->base_time, &now))
+		return false;
+
 	for (n = 0; n < qopt->num_entries; n++) {
 		const struct tc_taprio_sched_entry *e;
 		int i;
@@ -4764,7 +4785,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	if (adapter->base_time)
 		return -EALREADY;
 
-	if (!validate_schedule(qopt))
+	if (!validate_schedule(adapter, qopt))
 		return -EINVAL;
 
 	adapter->cycle_time = qopt->cycle_time;
-- 
2.26.2

