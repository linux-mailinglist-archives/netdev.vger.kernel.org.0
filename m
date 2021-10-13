Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BE842B8DF
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhJMHWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238353AbhJMHUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:20:11 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD28C061714
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so6072437edt.7
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cwzVputq9+5AheeWqHLhFOowmJ3q3Z3XOBFGNgiwI/k=;
        b=GqdNhRgrZ628omJIyJtKFALsEerCGsECe/hLhdel+ex7qWw+CvcUTRmsVU1FgGORix
         FvbomHtWIBMllx0NGvTV9HNVODsgqdSQkAb2wyKPwFp9w0LWubCdI+0eTeZUy1ozN3pN
         QrcYCGqGb5KAze9bji1Vo8dmud1CYFVy5esnMdGGa1tCz9AOdBcs8QK9GZBCgfNTe4bd
         sRJVULLIG4ODJic6o8Zn09uRCnP341MIpCIFVbIR1YNzVwoJMUt+W3QwMyyIN+GgF+YE
         OK1jYv4QxNxWaWHF0KsUaE//8TIimXVMk8AfSbPaQfEhR9IycNNfleltbrl3ETu2VwL2
         Yexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cwzVputq9+5AheeWqHLhFOowmJ3q3Z3XOBFGNgiwI/k=;
        b=eRvm3AstQRE3GlGIMEM8dyjPiTcT2Ix385ldq/XxQvB1HgPCpxUR9G6YWbGsm028RS
         L7s7RUVGxLaKEhSoKiolWcm5fFtfwDAhg/ZS2NfGvB3lA6Gpr7g95rzaSqjxnoO6vSqe
         pJVLFU24vow7wxwExLMI/tZ1dbjjDC1YMQHKFDLPFvo/OOj8a1i7Y8gMzGn3zeg8YcoE
         WyiILtyIdcPf+AqlITgxMXvGRwwTwMtK+0fZcX3Uwr2pq5Tg5w4lthIXIMLuSexMZPR0
         q7DFd5ijCHe0oEs91J32mvXhmdY43ny1ydMfO9O/CfcG26gCi8GjF6E/gogti+68rZcu
         PANQ==
X-Gm-Message-State: AOAM531DWIZ/loorj+TOkT9rVU4VFAZlQ0bc/d8mDQLwCx+7h/b16ZO8
        v736sbuov1TCHe2q0VpemUo=
X-Google-Smtp-Source: ABdhPJz7m9kEpvJpZmMCKaMlvgAmRYFcwbBO1EyhMvu/aPQnuwmMdIwT9RtYK4S4koACupweAiJecw==
X-Received: by 2002:a17:906:7017:: with SMTP id n23mr37751529ejj.446.1634109483530;
        Wed, 13 Oct 2021 00:18:03 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id f7sm2935886edl.33.2021.10.13.00.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:18:03 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next RESEND 2/4] igb: move PEROUT and EXTTS isr logic to separate functions
Date:   Wed, 13 Oct 2021 09:15:29 +0200
Message-Id: <20211013071531.1145-3-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013071531.1145-1-kernel.hbk@gmail.com>
References: <20211013071531.1145-1-kernel.hbk@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove code duplication in the tsync interrupt handler function by moving
this logic to separate functions. This keeps the interrupt handler readable
and allows the new functions to be extended for adapter types other than
i210.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 79 +++++++++++++----------
 1 file changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e67a71c3f141..1ff9bc452fcf 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6732,12 +6732,50 @@ void igb_update_stats(struct igb_adapter *adapter)
 	}
 }
 
+static void igb_perout(struct igb_adapter *adapter, int sdp)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	struct timespec64 ts;
+	u32 tsauxc;
+
+	if (sdp < 0 || sdp >= IGB_N_PEROUT)
+		return;
+
+	spin_lock(&adapter->tmreg_lock);
+	ts = timespec64_add(adapter->perout[sdp].start,
+			    adapter->perout[sdp].period);
+	/* u32 conversion of tv_sec is safe until y2106 */
+	wr32((sdp == 1) ? E1000_TRGTTIML1 : E1000_TRGTTIML0, ts.tv_nsec);
+	wr32((sdp == 1) ? E1000_TRGTTIMH1 : E1000_TRGTTIMH0, (u32)ts.tv_sec);
+	tsauxc = rd32(E1000_TSAUXC);
+	tsauxc |= TSAUXC_EN_TT0;
+	wr32(E1000_TSAUXC, tsauxc);
+	adapter->perout[sdp].start = ts;
+	spin_unlock(&adapter->tmreg_lock);
+}
+
+static void igb_extts(struct igb_adapter *adapter, int sdp)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 sec, nsec;
+	struct ptp_clock_event event;
+
+	if (sdp < 0 || sdp >= IGB_N_EXTTS)
+		return;
+
+	nsec = rd32((sdp == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0);
+	sec  = rd32((sdp == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0);
+	event.type = PTP_CLOCK_EXTTS;
+	event.index = sdp;
+	event.timestamp = sec * 1000000000ULL + nsec;
+	ptp_clock_event(adapter->ptp_clock, &event);
+}
+
 static void igb_tsync_interrupt(struct igb_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	struct ptp_clock_event event;
-	struct timespec64 ts;
-	u32 ack = 0, tsauxc, sec, nsec, tsicr = rd32(E1000_TSICR);
+	u32 ack = 0, tsicr = rd32(E1000_TSICR);
 
 	if (tsicr & TSINTR_SYS_WRAP) {
 		event.type = PTP_CLOCK_PPS;
@@ -6753,51 +6791,22 @@ static void igb_tsync_interrupt(struct igb_adapter *adapter)
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
2.30.2

