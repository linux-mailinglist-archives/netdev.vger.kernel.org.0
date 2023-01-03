Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC6D65CA22
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjACXES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjACXEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:04:16 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F77140D3
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787055; x=1704323055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8tG/OENQLMLkGDKnR1CT7qsHvg6hSnbPrVPCrvW4wVI=;
  b=Nu0qJnoXLrAzMqqLayoha8Bp51rZHYkixE49Fnvwo39QcxrYLrUoDafO
   vQ3mm39TzhwlHmjEhGnDpCurnZ5hE1jU6xHYwv3fykIJyHgpkCC8tzro3
   vlJXmzyDjuuCkHtl/VcI95qpz5F7mhGjIKHMI53Ox+qxeDWosrOvRAdFX
   Sgx3r9RLzWgr23dK5NwvzNjIHpL9+NBN0f0ZuaXPnx5cOCEEQ/mbl4uvk
   tBauKN90EZyQI9HO7osx8I6UGq2P3DL/cogZtENvGmnlnEedxAFu4IH/L
   xWeaJ1Qyk8Q55Rk6raNcCDoOZVJj7aEwH+Zl47OHEJSztsJzosv6M0ojl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="302152108"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="302152108"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:04:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="723427624"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="723427624"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jan 2023 15:04:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, Tan Tee Min <tee.min.tan@linux.intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 1/3] igc: remove I226 Qbv BaseTime restriction
Date:   Tue,  3 Jan 2023 15:05:01 -0800
Message-Id: <20230103230503.1102426-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
References: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

Remove the Qbv BaseTime restriction for I226 so that the BaseTime can be
scheduled to the future time. A new register bit of Tx Qav Control
(Bit-7: FutScdDis) was introduced to allow I226 scheduling future time as
Qbv BaseTime and not having the Tx hang timeout issue.

Besides, according to datasheet section 7.5.2.9.3.3, FutScdDis bit has to
be configured first before the cycle time and base time.

Indeed the FutScdDis bit is only active on re-configuration, thus we have
to set the BASET_L to zero and then only set it to the desired value.

Please also note that the Qbv configuration flow is moved around based on
the Qbv programming guideline that is documented in the latest datasheet.

Co-developed-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c    | 29 +++++++++++++
 drivers/net/ethernet/intel/igc/igc_base.h    |  2 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c    |  5 ++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 44 +++++++++++++-------
 5 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index a15927e77272..a1d815af507d 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -396,6 +396,35 @@ void igc_rx_fifo_flush_base(struct igc_hw *hw)
 	rd32(IGC_MPC);
 }
 
+bool igc_is_device_id_i225(struct igc_hw *hw)
+{
+	switch (hw->device_id) {
+	case IGC_DEV_ID_I225_LM:
+	case IGC_DEV_ID_I225_V:
+	case IGC_DEV_ID_I225_I:
+	case IGC_DEV_ID_I225_K:
+	case IGC_DEV_ID_I225_K2:
+	case IGC_DEV_ID_I225_LMVP:
+	case IGC_DEV_ID_I225_IT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+bool igc_is_device_id_i226(struct igc_hw *hw)
+{
+	switch (hw->device_id) {
+	case IGC_DEV_ID_I226_LM:
+	case IGC_DEV_ID_I226_V:
+	case IGC_DEV_ID_I226_K:
+	case IGC_DEV_ID_I226_IT:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static struct igc_mac_operations igc_mac_ops_base = {
 	.init_hw		= igc_init_hw_base,
 	.check_for_link		= igc_check_for_copper_link,
diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
index ce530f5fd7bd..7a992befca24 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.h
+++ b/drivers/net/ethernet/intel/igc/igc_base.h
@@ -7,6 +7,8 @@
 /* forward declaration */
 void igc_rx_fifo_flush_base(struct igc_hw *hw);
 void igc_power_down_phy_copper_base(struct igc_hw *hw);
+bool igc_is_device_id_i225(struct igc_hw *hw);
+bool igc_is_device_id_i226(struct igc_hw *hw);
 
 /* Transmit Descriptor - Advanced */
 union igc_adv_tx_desc {
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index a7b22639cfcd..0e23f6244ffb 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -522,6 +522,7 @@
 /* Transmit Scheduling */
 #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
 #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
+#define IGC_TQAVCTRL_FUTSCDDIS		0x00000080
 
 #define IGC_TXQCTL_QUEUE_MODE_LAUNCHT	0x00000001
 #define IGC_TXQCTL_STRICT_CYCLE		0x00000002
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 44b1740dc098..988131d7acd7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5958,6 +5958,7 @@ static bool validate_schedule(struct igc_adapter *adapter,
 			      const struct tc_taprio_qopt_offload *qopt)
 {
 	int queue_uses[IGC_MAX_TX_QUEUES] = { };
+	struct igc_hw *hw = &adapter->hw;
 	struct timespec64 now;
 	size_t n;
 
@@ -5970,8 +5971,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
 	 * in the future, it will hold all the packets until that
 	 * time, causing a lot of TX Hangs, so to avoid that, we
 	 * reject schedules that would start in the future.
+	 * Note: Limitation above is no longer in i226.
 	 */
-	if (!is_base_time_past(qopt->base_time, &now))
+	if (!is_base_time_past(qopt->base_time, &now) &&
+	    igc_is_device_id_i225(hw))
 		return false;
 
 	for (n = 0; n < qopt->num_entries; n++) {
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index bb10d7b65232..28325dc4fc5b 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -2,6 +2,7 @@
 /* Copyright (c)  2019 Intel Corporation */
 
 #include "igc.h"
+#include "igc_hw.h"
 #include "igc_tsn.h"
 
 static bool is_any_launchtime(struct igc_adapter *adapter)
@@ -92,7 +93,8 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 
 	tqavctrl = rd32(IGC_TQAVCTRL);
 	tqavctrl &= ~(IGC_TQAVCTRL_TRANSMIT_MODE_TSN |
-		      IGC_TQAVCTRL_ENHANCED_QAV);
+		      IGC_TQAVCTRL_ENHANCED_QAV | IGC_TQAVCTRL_FUTSCDDIS);
+
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -117,20 +119,10 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	ktime_t base_time, systim;
 	int i;
 
-	cycle = adapter->cycle_time;
-	base_time = adapter->base_time;
-
 	wr32(IGC_TSAUXC, 0);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_TSN);
 	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
 
-	tqavctrl = rd32(IGC_TQAVCTRL);
-	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
-	wr32(IGC_TQAVCTRL, tqavctrl);
-
-	wr32(IGC_QBVCYCLET_S, cycle);
-	wr32(IGC_QBVCYCLET, cycle);
-
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igc_ring *ring = adapter->tx_ring[i];
 		u32 txqctl = 0;
@@ -233,21 +225,43 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
+	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
+
+	cycle = adapter->cycle_time;
+	base_time = adapter->base_time;
+
 	nsec = rd32(IGC_SYSTIML);
 	sec = rd32(IGC_SYSTIMH);
 
 	systim = ktime_set(sec, nsec);
-
 	if (ktime_compare(systim, base_time) > 0) {
-		s64 n;
+		s64 n = div64_s64(ktime_sub_ns(systim, base_time), cycle);
 
-		n = div64_s64(ktime_sub_ns(systim, base_time), cycle);
 		base_time = ktime_add_ns(base_time, (n + 1) * cycle);
+	} else {
+		/* According to datasheet section 7.5.2.9.3.3, FutScdDis bit
+		 * has to be configured before the cycle time and base time.
+		 */
+		if (igc_is_device_id_i226(hw))
+			tqavctrl |= IGC_TQAVCTRL_FUTSCDDIS;
 	}
 
-	baset_h = div_s64_rem(base_time, NSEC_PER_SEC, &baset_l);
+	wr32(IGC_TQAVCTRL, tqavctrl);
+
+	wr32(IGC_QBVCYCLET_S, cycle);
+	wr32(IGC_QBVCYCLET, cycle);
 
+	baset_h = div_s64_rem(base_time, NSEC_PER_SEC, &baset_l);
 	wr32(IGC_BASET_H, baset_h);
+
+	/* In i226, Future base time is only supported when FutScdDis bit
+	 * is enabled and only active for re-configuration.
+	 * In this case, initialize the base time with zero to create
+	 * "re-configuration" scenario then only set the desired base time.
+	 */
+	if (tqavctrl & IGC_TQAVCTRL_FUTSCDDIS)
+		wr32(IGC_BASET_L, 0);
 	wr32(IGC_BASET_L, baset_l);
 
 	return 0;
-- 
2.38.1

