Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6E642B8E1
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbhJMHWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238335AbhJMHUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:20:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E4FC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:05 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t16so6010462eds.9
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cFfvl+nTVDvlC7gg1tfLwFH72KHG0Lit+RHr8pSBa1I=;
        b=eUuPNTyDpVUBBPO3BgrxEMQnc554AqTToJ+vJRPu9nr3MD3m6vx0boe66Z/skUqICe
         fisaXkaYzdP8oeN4BgbQSYawSlUdSMyfAd+JdWImX0TIW4ceqVnOQSzbehrQ54rc66UN
         ON3WjUQrCrIRzc5OMdCAU6yY3EqmMZQVtfO/cKd9HFNar9akU6zbKoY2TtKEf4qaxHvw
         PqW5U448KIWv9RNzQX4t28oEE8WH4KhYxYOZWiWyOp0SnK0WZbsSascSX3caY4JH27Dv
         MFcNy+upTIQxKVN0eZGNJxg2RmWPzv2Hc3uxSE7ImijfjeYJA978C2KZdELyRL0Rn0gH
         W07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFfvl+nTVDvlC7gg1tfLwFH72KHG0Lit+RHr8pSBa1I=;
        b=Lf3SddJCmHOlPA1p52Qke45mFlbsY4FAGdQHEDxeHk9JMxbx4zVf45GvQUYmqGmn8X
         XSSQxtLfm5M5OWfRafK2TxWeB9dieBsRfzpAOMFYwxsNGJuQq/0Beb0XR3Ako7eHSMLz
         QHtbpdEb8T4zQgRhxGmxj2uMBWt6iUefoufJco96JFFI2U4ZW94VF7LYpYDXMSzs1B16
         eDx1wk0md+6F4+LNRfmCX+XgTfk0STqagzn3rXJapZ0tkVHGpo5ltGienKqEL0Y3/Owj
         oiiB2CoxPGe+2WndEqfUKduByOfkOj1NlEWqFKC/DqH5PXh3UCtmXn6GAhsbzXimtX30
         rgsw==
X-Gm-Message-State: AOAM531fJD1Q7Xq9RwzvDf79pJSLr3rXyi9cxnNmJ1vCqsZlw+WI+nng
        k9HSaxqDRUjp6GUPhatpG6q4uiRzNKQ=
X-Google-Smtp-Source: ABdhPJwGfHuGQQ1ZEZAxaV7c7dLltuMtk9X6H9B0MXID+bpQ/LgbFsQ2l2N3cBzf0+CCTPGU2AcRiA==
X-Received: by 2002:a17:906:34c3:: with SMTP id h3mr9190734ejb.10.1634109484237;
        Wed, 13 Oct 2021 00:18:04 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id f7sm2935886edl.33.2021.10.13.00.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:18:03 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next RESEND 3/4] igb: support PEROUT on 82580/i354/i350
Date:   Wed, 13 Oct 2021 09:15:30 +0200
Message-Id: <20211013071531.1145-4-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013071531.1145-1-kernel.hbk@gmail.com>
References: <20211013071531.1145-1-kernel.hbk@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for the PEROUT PTP pin function on 82580/i354/i350 based adapters.
Because the time registers of these adapters do not have the nice split in
second rollovers as the i210 has, the implementation is slightly more
complex compared to the i210 implementation.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c |  54 +++++++++-
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 122 +++++++++++++++++++++-
 2 files changed, 172 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 1ff9bc452fcf..5f59c5de7033 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6742,8 +6742,57 @@ static void igb_perout(struct igb_adapter *adapter, int sdp)
 		return;
 
 	spin_lock(&adapter->tmreg_lock);
-	ts = timespec64_add(adapter->perout[sdp].start,
-			    adapter->perout[sdp].period);
+
+	if ((hw->mac.type == e1000_82580) ||
+	    (hw->mac.type == e1000_i354) ||
+	    (hw->mac.type == e1000_i350)) {
+		u32 systiml, systimh, level_mask, level, rem;
+		u64 systim, now;
+		s64 ns = timespec64_to_ns(&adapter->perout[sdp].period);
+
+		/* read systim registers in sequence */
+		rd32(E1000_SYSTIMR);
+		systiml = rd32(E1000_SYSTIML);
+		systimh = rd32(E1000_SYSTIMH);
+		systim = (((u64)(systimh & 0xFF)) << 32) | ((u64)systiml);
+		now = timecounter_cyc2time(&adapter->tc, systim);
+
+		level_mask = (sdp == 1) ? 0x80000 : 0x40000;
+		level = (rd32(E1000_CTRL) & level_mask) ? 1 : 0;
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
+					  adapter->sdp_config[sdp].name);
+			}
+		} else {
+			/* second half of period */
+			if (level == 1) {
+				/* output is already high, skip this period */
+				systim += ns;
+				pr_notice("igb: periodic output on %s missed rising edge\n",
+					  adapter->sdp_config[sdp].name);
+			}
+		}
+
+		/* for this chip family tv_sec is the upper part of the binary value,
+		 * so not seconds
+		 */
+		ts.tv_nsec = (u32)systim;
+		ts.tv_sec  = ((u32)(systim >> 32)) & 0xFF;
+	} else {
+		ts = timespec64_add(adapter->perout[sdp].start,
+				    adapter->perout[sdp].period);
+	}
+
 	/* u32 conversion of tv_sec is safe until y2106 */
 	wr32((sdp == 1) ? E1000_TRGTTIML1 : E1000_TRGTTIML0, ts.tv_nsec);
 	wr32((sdp == 1) ? E1000_TRGTTIMH1 : E1000_TRGTTIMH0, (u32)ts.tv_sec);
@@ -6751,6 +6800,7 @@ static void igb_perout(struct igb_adapter *adapter, int sdp)
 	tsauxc |= TSAUXC_EN_TT0;
 	wr32(E1000_TSAUXC, tsauxc);
 	adapter->perout[sdp].start = ts;
+
 	spin_unlock(&adapter->tmreg_lock);
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index c78d0c2a5341..64a949bb5d8a 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -508,6 +508,119 @@ static void igb_pin_perout(struct igb_adapter *igb, int chan, int pin, int freq)
 	wr32(E1000_CTRL_EXT, ctrl_ext);
 }
 
+static int igb_ptp_feature_enable_82580(struct ptp_clock_info *ptp,
+					struct ptp_clock_request *rq, int on)
+{
+	struct igb_adapter *igb =
+		container_of(ptp, struct igb_adapter, ptp_caps);
+	struct e1000_hw *hw = &igb->hw;
+	u32 tsauxc, tsim, tsauxc_mask, tsim_mask, trgttiml, trgttimh, systiml,
+		systimh, level_mask, level, rem;
+	unsigned long flags;
+	struct timespec64 ts, start;
+	int pin = -1;
+	s64 ns;
+	u64 systim, now;
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
+		if (on && (ns < 8LL))
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
+			level_mask = (pin == 1) ? 0x80000 : 0x40000;
+	                level = (rd32(E1000_CTRL) & level_mask) ? 1 : 0;
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
@@ -1215,16 +1328,21 @@ void igb_ptp_init(struct igb_adapter *adapter)
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
2.30.2

