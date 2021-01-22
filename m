Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA4301050
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbhAVWun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:50:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:1524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbhAVWsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:48:24 -0500
IronPort-SDR: fZqLtl4sU5J4MklfZmI3h+ylFnyN69ZeQwgdSl2kQo5rHOMMs5zGZkq2GsaXUsK9hdLgJG+MZH
 BcYftAxrZKYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="166619686"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="166619686"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:23 -0800
IronPort-SDR: amZTGzIMLzi2fOnNwrMMtE2zgJUYqmbfnEzneSWtSd8UwosifIwc7yozMzOwLygVEBzfK5yXbv
 goQ1V1FaIPCw==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="355390581"
Received: from apalur-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.155.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:23 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v3 7/8] igc: Add support for Frame Preemption offload
Date:   Fri, 22 Jan 2021 14:44:52 -0800
Message-Id: <20210122224453.4161729-8-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122224453.4161729-1-vinicius.gomes@intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the set of queues that are marked as preemptible are exposed to
the driver we can configure the hardware to enable the frame
preemption functionality.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1ae5f29d1b70..b05fdf739e7f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4806,6 +4806,23 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	return 0;
 }
 
+static int igc_save_frame_preemption(struct igc_adapter *adapter,
+				     struct tc_preempt_qopt_offload *qopt)
+{
+	u32 preempt;
+	int i;
+
+	preempt = qopt->preemptible_queues;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		ring->preemptible = preempt & BIT(i);
+	}
+
+	return 0;
+}
+
 static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 					 struct tc_taprio_qopt_offload *qopt)
 {
@@ -4822,6 +4839,18 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
+static int igc_tsn_enable_frame_preemption(struct igc_adapter *adapter,
+					   struct tc_preempt_qopt_offload *qopt)
+{
+	int err;
+
+	err = igc_save_frame_preemption(adapter, qopt);
+	if (err)
+		return err;
+
+	return igc_tsn_offload_apply(adapter);
+}
+
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
@@ -4834,6 +4863,9 @@ static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_ETF:
 		return igc_tsn_enable_launchtime(adapter, type_data);
 
+	case TC_SETUP_PREEMPT:
+		return igc_tsn_enable_frame_preemption(adapter, type_data);
+
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.30.0

