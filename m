Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A585B6436CE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiLEVZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiLEVYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:24:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9905B2CC8A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275471; x=1701811471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=znkhC3c0cVLPc+L89yjs3VLUgHTutCmz4ge8GZdyvZ4=;
  b=YXcsTgWzOQzaP/xe1Vy6kZ4Nkuw/VKI6hghOjYRNwzFm3Awa+Sm5eWak
   Y9Ymh51WLMCOgDLj5X75RDuAuG2THv40g4oDaCUc6pNUMQYqk7JJjG4Sq
   m/qobbCYgj2m6asBOC61bUgv3Hf1+rQsfKKYqR3M8FNoNW4Pmvq/NBTf0
   iwYXIpTj6Ad9GcXAi48dbvHByVLOEKRBkQB76ZxWWv/hz8K2DejpGE/ux
   lcSiywA0vCfoHnnGAC7LNjZXTt3rbS8zQF7oP4PfOkhqDeWtJyUy1/Jg3
   oXUOG6+uO3iasKxazRnechwOSaalsSXRMzym5GifpjrJTok0bae0l18ye
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296157798"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296157798"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:24:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734744947"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734744947"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 13:24:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, Tan Tee Min <tee.min.tan@linux.intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 2/8] igc: remove I226 Qbv BaseTime restriction
Date:   Mon,  5 Dec 2022 13:24:08 -0800
Message-Id: <20221205212414.3197525-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index f7311aeb293b..25ba10f5df96 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -520,6 +520,7 @@
 /* Transmit Scheduling */
 #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
 #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
+#define IGC_TQAVCTRL_FUTSCDDIS		0x00000080
 
 #define IGC_TXQCTL_QUEUE_MODE_LAUNCHT	0x00000001
 #define IGC_TXQCTL_STRICT_CYCLE		0x00000002
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 140d96dc475c..eb4b916a609d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5840,6 +5840,7 @@ static bool validate_schedule(struct igc_adapter *adapter,
 			      const struct tc_taprio_qopt_offload *qopt)
 {
 	int queue_uses[IGC_MAX_TX_QUEUES] = { };
+	struct igc_hw *hw = &adapter->hw;
 	struct timespec64 now;
 	size_t n;
 
@@ -5852,8 +5853,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
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
index b63736176709..d7832cf1bc5b 100644
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
@@ -240,21 +232,43 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
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
2.35.1

