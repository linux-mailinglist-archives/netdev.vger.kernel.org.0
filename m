Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4302481614
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhL2Slj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:41:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:17139 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhL2Sli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 13:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640803298; x=1672339298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z1opx6p5AQgojg3iMd0dufsUuTWzwDR/dWDDvxMj+og=;
  b=nJdflsf93lC6JhQTPue+rOgeePgYBP45UR81ymd0+0/DX34q5fLhJGxO
   Jt7Ynk7MgrkadmxmFfy4ik57l4/YWSxIwcudCv84XsJvehy6CRKwhBJYL
   lsR2MzpkxIq/seKtL/nYNJbNEfZn2WGIZkwVucQm/TgXFeFGTo9Q6k2a7
   CyyJ0/q39ZiNwRp3mt2recZlHOeiTd0hYAXCWnjhcuhBSm1Je687ilb69
   PPdI+PqmgGZFhZA3ZMa1U/Kk/XooMndxOw0e4+TM+PN8FBzSUvlgsmDUY
   7Vb3jIMKxfBNWkIaTOsDN9aO1woH6iwzbVnegSVc4ZOSDMILPYgNDUX7H
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="222226257"
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="222226257"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 10:41:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="524881580"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 29 Dec 2021 10:41:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Ruud Bos <kernel.hbk@gmail.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/4] igb: support EXTTS on 82580/i354/i350
Date:   Wed, 29 Dec 2021 10:40:53 -0800
Message-Id: <20211229184053.632634-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
References: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ruud Bos <kernel.hbk@gmail.com>

Support for the PTP pin function on 82580/i354/i350 based adapters.
Because the time registers of these adapters do not have the nice split in
second rollovers as the i210 has, the implementation is slightly more
complex compared to the i210 implementation.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 20 ++++++++++---
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 36 ++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index bf8fb4347bc5..4603ae35fcab 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6820,18 +6820,30 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 {
 	int pin = ptp_find_pin(adapter->ptp_clock, PTP_PF_EXTTS, tsintr_tt);
+	int auxstmpl = (tsintr_tt == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0;
+	int auxstmph = (tsintr_tt == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0;
 	struct e1000_hw *hw = &adapter->hw;
 	struct ptp_clock_event event;
-	u32 sec, nsec;
+	struct timespec64 ts;
 
 	if (pin < 0 || pin >= IGB_N_EXTTS)
 		return;
 
-	nsec = rd32((tsintr_tt == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0);
-	sec  = rd32((tsintr_tt == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0);
+	if (hw->mac.type == e1000_82580 ||
+	    hw->mac.type == e1000_i354 ||
+	    hw->mac.type == e1000_i350) {
+		s64 ns = rd32(auxstmpl);
+
+		ns += ((s64)(rd32(auxstmph) & 0xFF)) << 32;
+		ts = ns_to_timespec64(ns);
+	} else {
+		ts.tv_nsec = rd32(auxstmpl);
+		ts.tv_sec  = rd32(auxstmph);
+	}
+
 	event.type = PTP_CLOCK_EXTTS;
 	event.index = tsintr_tt;
-	event.timestamp = sec * 1000000000ULL + nsec;
+	event.timestamp = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 	ptp_clock_event(adapter->ptp_clock, &event);
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 33cde531560a..6580fcddb4be 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -524,7 +524,41 @@ static int igb_ptp_feature_enable_82580(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
-		return -EOPNOTSUPP;
+		/* Reject requests with unsupported flags */
+		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+					PTP_RISING_EDGE |
+					PTP_FALLING_EDGE |
+					PTP_STRICT_FLAGS))
+			return -EOPNOTSUPP;
+
+		if (on) {
+			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_EXTTS,
+					   rq->extts.index);
+			if (pin < 0)
+				return -EBUSY;
+		}
+		if (rq->extts.index == 1) {
+			tsauxc_mask = TSAUXC_EN_TS1;
+			tsim_mask = TSINTR_AUTT1;
+		} else {
+			tsauxc_mask = TSAUXC_EN_TS0;
+			tsim_mask = TSINTR_AUTT0;
+		}
+		spin_lock_irqsave(&igb->tmreg_lock, flags);
+		tsauxc = rd32(E1000_TSAUXC);
+		tsim = rd32(E1000_TSIM);
+		if (on) {
+			igb_pin_extts(igb, rq->extts.index, pin);
+			tsauxc |= tsauxc_mask;
+			tsim |= tsim_mask;
+		} else {
+			tsauxc &= ~tsauxc_mask;
+			tsim &= ~tsim_mask;
+		}
+		wr32(E1000_TSAUXC, tsauxc);
+		wr32(E1000_TSIM, tsim);
+		spin_unlock_irqrestore(&igb->tmreg_lock, flags);
+		return 0;
 
 	case PTP_CLK_REQ_PEROUT:
 		/* Reject requests with unsupported flags */
-- 
2.31.1

