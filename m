Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE16A43E3EC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhJ1Ok2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhJ1Ok1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:40:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261E3C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:38:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ee16so12775656edb.10
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CQLc+Bb9g6jSO8h73swFJnMyQM+VpvaPbenLUuNW4bs=;
        b=bIL2iz/w0TGFdEcjDN4SQF/msvOjLF1A6tGqzQZgFUVPO2FEuS0GcZB3tSHfR30oa1
         QN1V22pyd0nRS8bf+zQh8O7bwBYy/mas9mg9sFmDD1Hmw/v9tTIA+t+2uhJ9/+4MT9gz
         sTyH+kQ3+liMzYnkHRp65ftZMJQiYybRsTJyx9a9tcL9SJux5Q7z+RZ9FP5Y6WSyxzqj
         cLQmJ7RRHwFDQqqAF7ZHKsrd1SIvN1ktM4Wkrog6MYK8G44keR/i/5+I64tp09hJIuuu
         PYaxC+sNRnFz1F+XMKGZ1lkPp3Y1xnBTyL7w7TeeUOWTEelBJLoNYDZXiXjFilFJYICX
         eV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CQLc+Bb9g6jSO8h73swFJnMyQM+VpvaPbenLUuNW4bs=;
        b=UQQu+aDjW99lCdBwuUY8KupEtKB9SR6Ao1Kigegm/5bmuIuGZvqIXZ+xU0iGVcLquN
         UUCataDjWnCHmPepap8mEEFNHf+pu/7el4WBKYh+VDuYz+A0fJ/lQsza/+A7a/oZ6CLp
         hRHoJLz8poufJQeqI8Zwy6xPN4mKjJ2hQSjjNcOMft4VsBP3T8kxhREyc/uMhLk2OaEV
         hyUqPuxgJnTGLW34GFZAz2FAvu1x2DMF0WoZqf7apt/YvWEdEuNQugqeyKK1m7LRmeHY
         cdKBSR73PUe4ZNDUdIxEcfzLPY2caq7+DTd0mY9PnItHRfjubLuNT6WHUn07VfS5t7sO
         YyCA==
X-Gm-Message-State: AOAM533TYjGtid2zB5K9+pepO0OhPS398FTUJ5oLEBP4yDF0cbuLrIvo
        uy/NfmN6KuwtJzKfg4PXiJI=
X-Google-Smtp-Source: ABdhPJwhFBIIf0TSZyBl+J2Ly84sBbg1jXpBYXTyFG31lhjT7BMQVTVrsdFrpVD2sM9wWH2V0+eAVg==
X-Received: by 2002:aa7:cd99:: with SMTP id x25mr6575697edv.266.1635431877754;
        Thu, 28 Oct 2021 07:37:57 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id di12sm1514501ejc.3.2021.10.28.07.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 07:37:57 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next v2 4/4] igb: support EXTTS on 82580/i354/i350
Date:   Thu, 28 Oct 2021 16:34:59 +0200
Message-Id: <20211028143459.903439-5-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211028143459.903439-1-kernel.hbk@gmail.com>
References: <20211028143459.903439-1-kernel.hbk@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for the PTP pin function on 82580/i354/i350 based adapters.
Because the time registers of these adapters do not have the nice split in
second rollovers as the i210 has, the implementation is slightly more
complex compared to the i210 implementation.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 20 ++++++++++---
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 36 ++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 715302377b1a..13b0c1bb26f0 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6813,18 +6813,30 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 {
 	struct e1000_hw *hw = &adapter->hw;
-	u32 sec, nsec;
+	int auxstmpl = (tsintr_tt == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0;
+	int auxstmph = (tsintr_tt == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0;
+	struct timespec64 ts;
 	struct ptp_clock_event event;
 	int pin = ptp_find_pin(adapter->ptp_clock, PTP_PF_EXTTS, tsintr_tt);
 
 	if (pin < 0 || pin >= IGB_N_EXTTS)
 		return;
 
-	nsec = rd32((tsintr_tt == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0);
-	sec  = rd32((tsintr_tt == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0);
+	if ((hw->mac.type == e1000_82580) ||
+	    (hw->mac.type == e1000_i354) ||
+	    (hw->mac.type == e1000_i350)) {
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
index 57af8db73be6..6d59847f5097 100644
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
2.30.2

