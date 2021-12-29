Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E88481615
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhL2Slk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:41:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:17139 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhL2Sli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 13:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640803298; x=1672339298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j6gtoAvgBJCahebSxatrY5fRqnEozksEn8XxYbSX/YE=;
  b=JuQFIj4bJaUzh0uz8BZUHpscYlaNYyRCzq9aQVT9fIwb30I9TxRY12ri
   Wckn+83OR0S8bCYx63H8xT1mxAWKaxw0LDyqOkeSWf/J5otqJiXn3Hxe6
   O8Q1sBposl5Y168lSGizDmbmTb56nA93fJPRrxuoU41FSgsPBj5WnD/24
   hQnI7AxT7CL8Dxa9hDzEiCMRvmj0vjQNSofQ2iNILMIW4YWh0LDLG25wT
   rTEOFZWkA5xrjTcnRpe7e0/kK16Em0+DTAEESifRRifoSIs6f+C+2K+jn
   cvi71fz8IcAJEOKNUOvRUWspJWXpwOZ9qMcT9u9/9Eq3phL+Z5tej8ZWs
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="222226255"
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="222226255"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 10:41:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="524881577"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 29 Dec 2021 10:41:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Ruud Bos <kernel.hbk@gmail.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/4] igb: support PEROUT on 82580/i354/i350
Date:   Wed, 29 Dec 2021 10:40:52 -0800
Message-Id: <20211229184053.632634-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
References: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ruud Bos <kernel.hbk@gmail.com>

Support for the PEROUT PTP pin function on 82580/i354/i350 based adapters.
Because the time registers of these adapters do not have the nice split in
second rollovers as the i210 has, the implementation is slightly more
complex compared to the i210 implementation.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c |  59 +++++++++-
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 127 +++++++++++++++++++++-
 2 files changed, 182 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 6d1d65f4a528..bf8fb4347bc5 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6750,8 +6750,62 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 		return;
 
 	spin_lock(&adapter->tmreg_lock);
-	ts = timespec64_add(adapter->perout[pin].start,
-			    adapter->perout[pin].period);
+
+	if (hw->mac.type == e1000_82580 ||
+	    hw->mac.type == e1000_i354 ||
+	    hw->mac.type == e1000_i350) {
+		s64 ns = timespec64_to_ns(&adapter->perout[pin].period);
+		u32 systiml, systimh, level_mask, level, rem;
+		u64 systim, now;
+
+		/* read systim registers in sequence */
+		rd32(E1000_SYSTIMR);
+		systiml = rd32(E1000_SYSTIML);
+		systimh = rd32(E1000_SYSTIMH);
+		systim = (((u64)(systimh & 0xFF)) << 32) | ((u64)systiml);
+		now = timecounter_cyc2time(&adapter->tc, systim);
+
+		if (pin < 2) {
+			level_mask = (tsintr_tt == 1) ? 0x80000 : 0x40000;
+			level = (rd32(E1000_CTRL) & level_mask) ? 1 : 0;
+		} else {
+			level_mask = (tsintr_tt == 1) ? 0x80 : 0x40;
+			level = (rd32(E1000_CTRL_EXT) & level_mask) ? 1 : 0;
+		}
+
+		div_u64_rem(now, ns, &rem);
+		systim = systim + (ns - rem);
+
+		/* synchronize pin level with rising/falling edges */
+		div_u64_rem(now, ns << 1, &rem);
+		if (rem < ns) {
+			/* first half of period */
+			if (level == 0) {
+				/* output is already low, skip this period */
+				systim += ns;
+				pr_notice("igb: periodic output on %s missed falling edge\n",
+					  adapter->sdp_config[pin].name);
+			}
+		} else {
+			/* second half of period */
+			if (level == 1) {
+				/* output is already high, skip this period */
+				systim += ns;
+				pr_notice("igb: periodic output on %s missed rising edge\n",
+					  adapter->sdp_config[pin].name);
+			}
+		}
+
+		/* for this chip family tv_sec is the upper part of the binary value,
+		 * so not seconds
+		 */
+		ts.tv_nsec = (u32)systim;
+		ts.tv_sec  = ((u32)(systim >> 32)) & 0xFF;
+	} else {
+		ts = timespec64_add(adapter->perout[pin].start,
+				    adapter->perout[pin].period);
+	}
+
 	/* u32 conversion of tv_sec is safe until y2106 */
 	wr32((tsintr_tt == 1) ? E1000_TRGTTIML1 : E1000_TRGTTIML0, ts.tv_nsec);
 	wr32((tsintr_tt == 1) ? E1000_TRGTTIMH1 : E1000_TRGTTIMH0, (u32)ts.tv_sec);
@@ -6759,6 +6813,7 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 	tsauxc |= TSAUXC_EN_TT0;
 	wr32(E1000_TSAUXC, tsauxc);
 	adapter->perout[pin].start = ts;
+
 	spin_unlock(&adapter->tmreg_lock);
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 538d59e501e7..33cde531560a 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -508,6 +508,124 @@ static void igb_pin_perout(struct igb_adapter *igb, int chan, int pin, int freq)
 	wr32(E1000_CTRL_EXT, ctrl_ext);
 }
 
+static int igb_ptp_feature_enable_82580(struct ptp_clock_info *ptp,
+					struct ptp_clock_request *rq, int on)
+{
+	struct igb_adapter *igb =
+		container_of(ptp, struct igb_adapter, ptp_caps);
+	u32 tsauxc, tsim, tsauxc_mask, tsim_mask, trgttiml, trgttimh, systiml,
+		systimh, level_mask, level, rem;
+	struct e1000_hw *hw = &igb->hw;
+	struct timespec64 ts, start;
+	unsigned long flags;
+	u64 systim, now;
+	int pin = -1;
+	s64 ns;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return -EOPNOTSUPP;
+
+	case PTP_CLK_REQ_PEROUT:
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
+
+		if (on) {
+			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_PEROUT,
+					   rq->perout.index);
+			if (pin < 0)
+				return -EBUSY;
+		}
+		ts.tv_sec = rq->perout.period.sec;
+		ts.tv_nsec = rq->perout.period.nsec;
+		ns = timespec64_to_ns(&ts);
+		ns = ns >> 1;
+		if (on && ns < 8LL)
+			return -EINVAL;
+		ts = ns_to_timespec64(ns);
+		if (rq->perout.index == 1) {
+			tsauxc_mask = TSAUXC_EN_TT1;
+			tsim_mask = TSINTR_TT1;
+			trgttiml = E1000_TRGTTIML1;
+			trgttimh = E1000_TRGTTIMH1;
+		} else {
+			tsauxc_mask = TSAUXC_EN_TT0;
+			tsim_mask = TSINTR_TT0;
+			trgttiml = E1000_TRGTTIML0;
+			trgttimh = E1000_TRGTTIMH0;
+		}
+		spin_lock_irqsave(&igb->tmreg_lock, flags);
+		tsauxc = rd32(E1000_TSAUXC);
+		tsim = rd32(E1000_TSIM);
+		if (rq->perout.index == 1) {
+			tsauxc &= ~(TSAUXC_EN_TT1 | TSAUXC_EN_CLK1 | TSAUXC_ST1);
+			tsim &= ~TSINTR_TT1;
+		} else {
+			tsauxc &= ~(TSAUXC_EN_TT0 | TSAUXC_EN_CLK0 | TSAUXC_ST0);
+			tsim &= ~TSINTR_TT0;
+		}
+		if (on) {
+			int i = rq->perout.index;
+
+			/* read systim registers in sequence */
+			rd32(E1000_SYSTIMR);
+			systiml = rd32(E1000_SYSTIML);
+			systimh = rd32(E1000_SYSTIMH);
+			systim = (((u64)(systimh & 0xFF)) << 32) | ((u64)systiml);
+			now = timecounter_cyc2time(&igb->tc, systim);
+
+			if (pin < 2) {
+				level_mask = (i == 1) ? 0x80000 : 0x40000;
+				level = (rd32(E1000_CTRL) & level_mask) ? 1 : 0;
+			} else {
+				level_mask = (i == 1) ? 0x80 : 0x40;
+				level = (rd32(E1000_CTRL_EXT) & level_mask) ? 1 : 0;
+			}
+
+			div_u64_rem(now, ns, &rem);
+			systim = systim + (ns - rem);
+
+			/* synchronize pin level with rising/falling edges */
+			div_u64_rem(now, ns << 1, &rem);
+			if (rem < ns) {
+				/* first half of period */
+				if (level == 0) {
+					/* output is already low, skip this period */
+					systim += ns;
+				}
+			} else {
+				/* second half of period */
+				if (level == 1) {
+					/* output is already high, skip this period */
+					systim += ns;
+				}
+			}
+
+			start = ns_to_timespec64(systim + (ns - rem));
+			igb_pin_perout(igb, i, pin, 0);
+			igb->perout[i].start.tv_sec = start.tv_sec;
+			igb->perout[i].start.tv_nsec = start.tv_nsec;
+			igb->perout[i].period.tv_sec = ts.tv_sec;
+			igb->perout[i].period.tv_nsec = ts.tv_nsec;
+
+			wr32(trgttiml, (u32)systim);
+			wr32(trgttimh, ((u32)(systim >> 32)) & 0xFF);
+			tsauxc |= tsauxc_mask;
+			tsim |= tsim_mask;
+		}
+		wr32(E1000_TSAUXC, tsauxc);
+		wr32(E1000_TSIM, tsim);
+		spin_unlock_irqrestore(&igb->tmreg_lock, flags);
+		return 0;
+
+	case PTP_CLK_REQ_PPS:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
 				       struct ptp_clock_request *rq, int on)
 {
@@ -1211,16 +1329,21 @@ void igb_ptp_init(struct igb_adapter *adapter)
 	case e1000_82580:
 	case e1000_i354:
 	case e1000_i350:
+		igb_ptp_sdp_init(adapter);
 		snprintf(adapter->ptp_caps.name, 16, "%pm", netdev->dev_addr);
 		adapter->ptp_caps.owner = THIS_MODULE;
 		adapter->ptp_caps.max_adj = 62499999;
-		adapter->ptp_caps.n_ext_ts = 0;
+		adapter->ptp_caps.n_ext_ts = IGB_N_EXTTS;
+		adapter->ptp_caps.n_per_out = IGB_N_PEROUT;
+		adapter->ptp_caps.n_pins = IGB_N_SDP;
 		adapter->ptp_caps.pps = 0;
+		adapter->ptp_caps.pin_config = adapter->sdp_config;
 		adapter->ptp_caps.adjfine = igb_ptp_adjfine_82580;
 		adapter->ptp_caps.adjtime = igb_ptp_adjtime_82576;
 		adapter->ptp_caps.gettimex64 = igb_ptp_gettimex_82580;
 		adapter->ptp_caps.settime64 = igb_ptp_settime_82576;
-		adapter->ptp_caps.enable = igb_ptp_feature_enable;
+		adapter->ptp_caps.enable = igb_ptp_feature_enable_82580;
+		adapter->ptp_caps.verify = igb_ptp_verify_pin;
 		adapter->cc.read = igb_ptp_read_82580;
 		adapter->cc.mask = CYCLECOUNTER_MASK(IGB_NBITS_82580);
 		adapter->cc.mult = 1;
-- 
2.31.1

