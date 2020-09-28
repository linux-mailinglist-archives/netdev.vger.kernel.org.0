Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019D427B3D3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgI1R7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:32955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgI1R7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:44 -0400
IronPort-SDR: s9twG4CnyKWXwp0ud58cHSQMRmNhNj9KnxmCU/EZy2gI5zDqTX9ML9OAaHR7xPfXAvChDucne4
 9Ji4/KfQqwAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810274"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810274"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: ImmS4nONWXvJCKjKgUowZ5H3fEHRsTGpLPsLAZKZDmf/n3lWfyhL8ekB0rKtlRk5TFcnKI6/XX
 j2WfkVqHUuJA==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505406"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 13/15] igc: Reject schedules with a base_time in the future
Date:   Mon, 28 Sep 2020 10:59:06 -0700
Message-Id: <20200928175908.318502-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
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

