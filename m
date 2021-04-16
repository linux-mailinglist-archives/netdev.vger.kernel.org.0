Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3598362992
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240974AbhDPUnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:43:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:45471 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238987AbhDPUnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:43:39 -0400
IronPort-SDR: sMLCVkeelGgwGWHsSBYOHfkIWLWu0I70Z4Dr7sSS222A3deT5UVjpIlcPShCPfLl7iF7fhlyKt
 lGCMxNjF6JMg==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="182234180"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="182234180"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 13:43:12 -0700
IronPort-SDR: bM34aWh/vwGOMAaF71MhNCFjE8vG0IHZh9bcn+1BxH0avsRwoRz5LC1Ee04yOFF72Px7Gv2H5r
 xo0YnEMvTFwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="384425610"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2021 13:43:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Ederson de Souza <ederson.desouza@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 3/6] igc: Enable internal i225 PPS
Date:   Fri, 16 Apr 2021 13:44:57 -0700
Message-Id: <20210416204500.2012073-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ederson de Souza <ederson.desouza@intel.com>

The i225 device can produce one interrupt on the full second, much
like i210 - from where this patch is inspired.

This patch sets up the full second interruption on the i225 and when
receiving it, it sends a PPS event to PTP (Precision Time Protocol)
kernel subsystem.

The PTP subsystem exposes the PPS events via ioctl and sysfs, and one
can use the `testptp` tool (tools/testing/selftests/ptp) to check that
the events are being generated.

Signed-off-by: Ederson de Souza <ederson.desouza@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  2 ++
 drivers/net/ethernet/intel/igc/igc_main.c |  8 +++++++
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 28 ++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 91493a73355d..7c404c2daa47 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -223,6 +223,8 @@ struct igc_adapter {
 	char fw_version[32];
 
 	struct bpf_prog *xdp_prog;
+
+	bool pps_sys_wrap_on;
 };
 
 void igc_up(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 10765491e357..ac93c0e1b618 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4251,9 +4251,17 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 static void igc_tsync_interrupt(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
+	struct ptp_clock_event event;
 	u32 tsicr = rd32(IGC_TSICR);
 	u32 ack = 0;
 
+	if (tsicr & IGC_TSICR_SYS_WRAP) {
+		event.type = PTP_CLOCK_PPS;
+		if (adapter->ptp_caps.pps)
+			ptp_clock_event(adapter->ptp_clock, &event);
+		ack |= IGC_TSICR_SYS_WRAP;
+	}
+
 	if (tsicr & IGC_TSICR_TXTS) {
 		/* retrieve hardware timestamp */
 		schedule_work(&adapter->ptp_tx_work);
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index dfa3b247fcd8..8d6fbf609761 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -123,6 +123,29 @@ static int igc_ptp_settime_i225(struct ptp_clock_info *ptp,
 static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 				       struct ptp_clock_request *rq, int on)
 {
+	struct igc_adapter *igc =
+		container_of(ptp, struct igc_adapter, ptp_caps);
+	struct igc_hw *hw = &igc->hw;
+	unsigned long flags;
+	u32 tsim;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_PPS:
+		spin_lock_irqsave(&igc->tmreg_lock, flags);
+		tsim = rd32(IGC_TSIM);
+		if (on)
+			tsim |= IGC_TSICR_SYS_WRAP;
+		else
+			tsim &= ~IGC_TSICR_SYS_WRAP;
+		igc->pps_sys_wrap_on = on;
+		wr32(IGC_TSIM, tsim);
+		spin_unlock_irqrestore(&igc->tmreg_lock, flags);
+		return 0;
+
+	default:
+		break;
+	}
+
 	return -EOPNOTSUPP;
 }
 
@@ -497,6 +520,7 @@ void igc_ptp_init(struct igc_adapter *adapter)
 		adapter->ptp_caps.gettimex64 = igc_ptp_gettimex64_i225;
 		adapter->ptp_caps.settime64 = igc_ptp_settime_i225;
 		adapter->ptp_caps.enable = igc_ptp_feature_enable_i225;
+		adapter->ptp_caps.pps = 1;
 		break;
 	default:
 		adapter->ptp_clock = NULL;
@@ -598,7 +622,9 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 	case igc_i225:
 		wr32(IGC_TSAUXC, 0x0);
 		wr32(IGC_TSSDP, 0x0);
-		wr32(IGC_TSIM, IGC_TSICR_INTERRUPTS);
+		wr32(IGC_TSIM,
+		     IGC_TSICR_INTERRUPTS |
+		     (adapter->pps_sys_wrap_on ? IGC_TSICR_SYS_WRAP : 0));
 		wr32(IGC_IMS, IGC_IMS_TS);
 		break;
 	default:
-- 
2.26.2

