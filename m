Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA7423E57
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhJFNCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbhJFNCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:02:47 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7246C061762
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 06:00:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so9494817edv.12
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cwzVputq9+5AheeWqHLhFOowmJ3q3Z3XOBFGNgiwI/k=;
        b=ONksVQ/MYb/fLHfCP6sp9F4HgsatVO5taGSLcZkKne0ysswPxI7+U+UBnHYthvuMMG
         Suyxhlj8YhHKeqrE9yFLduyCoEogz2Fp7iWYfWhgmaER1GTYIbMaA6ZLzXoF3pIOUjEI
         o7WPKq1QfeA6m1S+SdMJmL4UAMNtKv9pQlWmWujdgxWMeEWuXFhPwq2mj7S5/Xb1GsQa
         x95ESR4/Q4VibOAT5geJrZK1q+ezpIAMNN8jlIYbkDf2TSVE5Njb0jMOnneAmoObEtPo
         7M6mc9Fi5lUsvT5eBY9+YD1p0vO1a2pzeYutfMKVdkT0JIQrhMggQhv7QKom8LqraUgw
         +PKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cwzVputq9+5AheeWqHLhFOowmJ3q3Z3XOBFGNgiwI/k=;
        b=1HkJEdtbiMJdPuJq4Zg0b7yHZs1y8L5bLxNqktC1sUhuAOrSs76h//RSbSFS/L9Tjx
         3EQMr94uzEDSWFfyhlacsHf3JnBQEWcJupoxfwwwE2whEtPxJ0BY59NshMpOb2SiyvWY
         TZhnYJZi4xPrNyZbS0kPyde3J+UbLehymfP8hqu0aPeHIhTClBkeXZAmT9wuR76BUCXS
         vKqdPhsCiXwxiZObApgVkKp9kECaVpAzOKOa8uH5dwDM3OJDmaVynNKCcMj1nA9GV/7R
         0aexTb0YpDA+mD0lydtXfiO+kaXqeUt2+BQ1gV0B1kGdpvnauactGGQ7Y56Cz2uz0RHa
         NJEQ==
X-Gm-Message-State: AOAM531TSGByhvujwXujxQSy5VbqVOUIQKNzvo2su6YVQ8X0HDNFdgOX
        lvhurJ8YUOfDBVv7yF51NNiLNZnsUdk=
X-Google-Smtp-Source: ABdhPJylVIE94RGvHnLpodCePAOwee7R84V+gCR3TgrxE6bTbHyKbG9XVER4jriEcDkbvU0zVjQzzA==
X-Received: by 2002:a17:906:3486:: with SMTP id g6mr33343194ejb.71.1633525247964;
        Wed, 06 Oct 2021 06:00:47 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id y16sm194122eds.70.2021.10.06.06.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:00:47 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next 2/4] igb: move PEROUT and EXTTS isr logic to separate functions
Date:   Wed,  6 Oct 2021 14:58:23 +0200
Message-Id: <20211006125825.1383-3-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006125825.1383-1-kernel.hbk@gmail.com>
References: <20211006125825.1383-1-kernel.hbk@gmail.com>
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

