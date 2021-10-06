Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C71423E58
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbhJFNCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238614AbhJFNCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:02:48 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8F2C061764
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 06:00:54 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id f4so4233926edr.8
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 06:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cFfvl+nTVDvlC7gg1tfLwFH72KHG0Lit+RHr8pSBa1I=;
        b=Hn2yomcdnWXNmNdZLpqLavnMCv9eqdRbniT7FthXK3eJtsLbTImEoG4Cag8Dho77r1
         H7Bk1OTKt+Ygh5Yy46KN+O54XwKwVfc+rJvttuHrxx4gAGTQegBVGAMLusxMJJTov3Fs
         caCp2TDFzabHgD5NKdP/4ybJQ4O2vs734R1z5d5jWr4lIrvkPFUn0XaiYYsV7vkHEuD7
         vmcRaybizvdn0Inp9et+bNVo3PMClG6uH/Itswa74R/dkUUI2aASIepTsZc0dOqFFC5a
         MkU4cgR5xUJABJl6NAA+OnuL+vnVii89nMZyeYDHWkfyCtTAZl8DkNsD+VZt4AzjEqPZ
         FfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFfvl+nTVDvlC7gg1tfLwFH72KHG0Lit+RHr8pSBa1I=;
        b=FwU+xFyCFXqOOSrrdpQYrW4Lj4hSXiOncU54lS36fi4NKX0O9lVAtFqeZK1UWDynZI
         xLoFYvZ7QgKOtch5ZIK7N7g2cUqqC9IkR5Mee2Ckn/GpbP/zJqGE/36+qhuZk5AwjtkS
         ETXtJTejxn6OifQaa+YOidkvQu73ugnM575EIT+aP1Zr7f7XV327Hur9lCqA4D5apT2m
         GPwCsGjsR4Zcv5vwdYL6UbNveK5Ng8NHPJId7s/M+/oPhTIlSmz2buZVllini6D8+Fv0
         xbEDBLz6XfHsZxnyIuNuCpc1TTIDp+7AA1lMnfdUHgY5RGW6UQg4AY3GQ8iv7KlxTTz+
         ImkQ==
X-Gm-Message-State: AOAM532syTThytP2+2S7sCnzpXm8obPl4yWzB3u5VkldyxnsVGYn+8N8
        1augrCMkcnH/OyfkzoOQF480etw76tM=
X-Google-Smtp-Source: ABdhPJwFj6fcKfJtkIpr6InPGRTuBfUCxVo7gJB3dSA2FwrOFk3uxQRAvQABer1z4h/D4FBdhq9rfQ==
X-Received: by 2002:a17:906:fb91:: with SMTP id lr17mr13506902ejb.256.1633525249528;
        Wed, 06 Oct 2021 06:00:49 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id y16sm194122eds.70.2021.10.06.06.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:00:49 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next 3/4] igb: support PEROUT on 82580/i354/i350
Date:   Wed,  6 Oct 2021 14:58:24 +0200
Message-Id: <20211006125825.1383-4-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006125825.1383-1-kernel.hbk@gmail.com>
References: <20211006125825.1383-1-kernel.hbk@gmail.com>
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

