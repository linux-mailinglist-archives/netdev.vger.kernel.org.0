Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA71E2FAE2C
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391581AbhASAmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:42:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:38527 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391385AbhASAmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 19:42:11 -0500
IronPort-SDR: 2CgKtVw4udaSCOaJ+tTiSlgWBr5ExDbFjp3hGZ5vsJkATgRgywnLyguXnookbu/Ad3sCHT4VtQ
 J9JOyCTDXRkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="179011267"
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="179011267"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:55 -0800
IronPort-SDR: Hn1Lm3Gh7gEqt8pRJz3t5DXZeFpfWxuDZ5yXY5+XRlx995Rlplt1vJFgdYw4F1v5Q6E9VGulkl
 TwQXmGpWGCIA==
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="426285788"
Received: from cemillan-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.57.184])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:54 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v2 7/8] igc: Add support for Frame Preemption offload
Date:   Mon, 18 Jan 2021 16:40:27 -0800
Message-Id: <20210119004028.2809425-8-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210119004028.2809425-1-vinicius.gomes@intel.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
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
index f1b31fa04734..6a09f37ba7ed 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4818,6 +4818,23 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
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
@@ -4834,6 +4851,18 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
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
@@ -4846,6 +4875,9 @@ static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
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

