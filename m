Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F388481612
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhL2Sli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:41:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:17139 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhL2Sli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 13:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640803298; x=1672339298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B04WscG/hOoYp4q3r7Po9xZEQsbnvJLkhpPDelAY/Bs=;
  b=cYrgDpxEqGixT05BRLUjUhGn8oEW4DfZ5Img3DQIOipXEQWCufjXKqpZ
   Uc/GtOkOVXF6qmOJ9OYUnhotjj5BNdkPXv3Ku2KcXqg2c1iFHgKnfuEw9
   cY90vBjAcYDrPIfd9DT0NMlJ7xzOXUUH4j60dmSgnGFi6OyM05Gf47Z5X
   VWe8ScmaHXnOUIbD7Thq4BJL23uOSRKiF34MJe34PinhZYEq/gM0lNw44
   D7l7dzDTAKYb8dg36GWmP8U/Q3g3sN/RmeKR2uydi7//3mQu0QbqxIFJl
   cDAbCjF/ffLqt0DgfAnrrvUuRMBkRfoBg0Yj2MbIPNKBo1ttKy8BQAcsi
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="222226253"
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="222226253"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 10:41:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="524881573"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 29 Dec 2021 10:41:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Ruud Bos <kernel.hbk@gmail.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/4] igb: move PEROUT and EXTTS isr logic to separate functions
Date:   Wed, 29 Dec 2021 10:40:51 -0800
Message-Id: <20211229184053.632634-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
References: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ruud Bos <kernel.hbk@gmail.com>

Remove code duplication in the tsync interrupt handler function by moving
this logic to separate functions. This keeps the interrupt handler readable
and allows the new functions to be extended for adapter types other than
i210.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 81 +++++++++++++----------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 47ece02fce99..6d1d65f4a528 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6739,12 +6739,52 @@ void igb_update_stats(struct igb_adapter *adapter)
 	}
 }
 
+static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
+{
+	int pin = ptp_find_pin(adapter->ptp_clock, PTP_PF_PEROUT, tsintr_tt);
+	struct e1000_hw *hw = &adapter->hw;
+	struct timespec64 ts;
+	u32 tsauxc;
+
+	if (pin < 0 || pin >= IGB_N_PEROUT)
+		return;
+
+	spin_lock(&adapter->tmreg_lock);
+	ts = timespec64_add(adapter->perout[pin].start,
+			    adapter->perout[pin].period);
+	/* u32 conversion of tv_sec is safe until y2106 */
+	wr32((tsintr_tt == 1) ? E1000_TRGTTIML1 : E1000_TRGTTIML0, ts.tv_nsec);
+	wr32((tsintr_tt == 1) ? E1000_TRGTTIMH1 : E1000_TRGTTIMH0, (u32)ts.tv_sec);
+	tsauxc = rd32(E1000_TSAUXC);
+	tsauxc |= TSAUXC_EN_TT0;
+	wr32(E1000_TSAUXC, tsauxc);
+	adapter->perout[pin].start = ts;
+	spin_unlock(&adapter->tmreg_lock);
+}
+
+static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
+{
+	int pin = ptp_find_pin(adapter->ptp_clock, PTP_PF_EXTTS, tsintr_tt);
+	struct e1000_hw *hw = &adapter->hw;
+	struct ptp_clock_event event;
+	u32 sec, nsec;
+
+	if (pin < 0 || pin >= IGB_N_EXTTS)
+		return;
+
+	nsec = rd32((tsintr_tt == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0);
+	sec  = rd32((tsintr_tt == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0);
+	event.type = PTP_CLOCK_EXTTS;
+	event.index = tsintr_tt;
+	event.timestamp = sec * 1000000000ULL + nsec;
+	ptp_clock_event(adapter->ptp_clock, &event);
+}
+
 static void igb_tsync_interrupt(struct igb_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
+	u32 ack = 0, tsicr = rd32(E1000_TSICR);
 	struct ptp_clock_event event;
-	struct timespec64 ts;
-	u32 ack = 0, tsauxc, sec, nsec, tsicr = rd32(E1000_TSICR);
 
 	if (tsicr & TSINTR_SYS_WRAP) {
 		event.type = PTP_CLOCK_PPS;
@@ -6760,51 +6800,22 @@ static void igb_tsync_interrupt(struct igb_adapter *adapter)
 	}
 
 	if (tsicr & TSINTR_TT0) {
-		spin_lock(&adapter->tmreg_lock);
-		ts = timespec64_add(adapter->perout[0].start,
-				    adapter->perout[0].period);
-		/* u32 conversion of tv_sec is safe until y2106 */
-		wr32(E1000_TRGTTIML0, ts.tv_nsec);
-		wr32(E1000_TRGTTIMH0, (u32)ts.tv_sec);
-		tsauxc = rd32(E1000_TSAUXC);
-		tsauxc |= TSAUXC_EN_TT0;
-		wr32(E1000_TSAUXC, tsauxc);
-		adapter->perout[0].start = ts;
-		spin_unlock(&adapter->tmreg_lock);
+		igb_perout(adapter, 0);
 		ack |= TSINTR_TT0;
 	}
 
 	if (tsicr & TSINTR_TT1) {
-		spin_lock(&adapter->tmreg_lock);
-		ts = timespec64_add(adapter->perout[1].start,
-				    adapter->perout[1].period);
-		wr32(E1000_TRGTTIML1, ts.tv_nsec);
-		wr32(E1000_TRGTTIMH1, (u32)ts.tv_sec);
-		tsauxc = rd32(E1000_TSAUXC);
-		tsauxc |= TSAUXC_EN_TT1;
-		wr32(E1000_TSAUXC, tsauxc);
-		adapter->perout[1].start = ts;
-		spin_unlock(&adapter->tmreg_lock);
+		igb_perout(adapter, 1);
 		ack |= TSINTR_TT1;
 	}
 
 	if (tsicr & TSINTR_AUTT0) {
-		nsec = rd32(E1000_AUXSTMPL0);
-		sec  = rd32(E1000_AUXSTMPH0);
-		event.type = PTP_CLOCK_EXTTS;
-		event.index = 0;
-		event.timestamp = sec * 1000000000ULL + nsec;
-		ptp_clock_event(adapter->ptp_clock, &event);
+		igb_extts(adapter, 0);
 		ack |= TSINTR_AUTT0;
 	}
 
 	if (tsicr & TSINTR_AUTT1) {
-		nsec = rd32(E1000_AUXSTMPL1);
-		sec  = rd32(E1000_AUXSTMPH1);
-		event.type = PTP_CLOCK_EXTTS;
-		event.index = 1;
-		event.timestamp = sec * 1000000000ULL + nsec;
-		ptp_clock_event(adapter->ptp_clock, &event);
+		igb_extts(adapter, 1);
 		ack |= TSINTR_AUTT1;
 	}
 
-- 
2.31.1

