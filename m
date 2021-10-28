Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1A343E3EA
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhJ1Ok1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbhJ1OkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:40:25 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07115C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:37:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w1so6901093edd.0
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmWmAMPPRjU0VuEUMI/mil0HhHd4P2g2fDKlZXPWyuI=;
        b=Rg6pbGXfLuqJmxs/PrXrNUUQt/9xsB1ppQ9v3DtZnWBo4ILD2OfDljUBJVtpeMokH/
         LeXsqP8H9cC24SDpT+OXV2yHoUAE7vAlDnf37+yzzi68KB4LbuOWeaAxgipeE5cWiQI3
         A5ptTUa0f4QZ/HPpsFxBYvRiDUk0BoVUKP2LsgHLsTwL9w2SVKCi14s3h19312roSOQX
         14BrV+Dm9OLo13PnKe9qfJYH3iDRSf9mK9CzJYLqGZqi9wMl6UuqK9Zm22rr6tJq+r6E
         as7h1GRysPWifOCeX8ruWUYoSNJSokENQ1asLH0htxSLVyh+OAuOWLnD4qUlbSH7FIkl
         YXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmWmAMPPRjU0VuEUMI/mil0HhHd4P2g2fDKlZXPWyuI=;
        b=WQonbU6VzTQgKviTk6+miYKjQUcJe9Zl/hfdcPXBiP0MCOCldvyz+7b0XUflg8lRDh
         3kFnZq2u4fA84Q7wUHdhrS+NNBNdNSyeRTXFpoQfSs3a1i9QwaFVaczJL6MrSzBcEz5A
         Rc9pADsh24ShCwr/ruSTwxr6pOa1BXXnkvDpRxZIb0Js6qCt7wL7kzLG7mS4QfcsOoK1
         LKczaFmeyyYpI/2anjekKX/ajr0eeMneZXT4dh2z0MyLsOaAM0a6fj7Qg5q8cDZBKyzo
         Vend8GlRRhnEkhdbELzKx8Lh2M6VUTiMU38DMFTLYb6ePwkeayQfSJT26576rIzK5mMg
         UOxA==
X-Gm-Message-State: AOAM5306lYkQgYooLxIfZWOCA3y0Pnw52ov5TSLyP7ly95oFZP+yDWms
        WvAj+lVNiWKuzUBAB+YVyXY=
X-Google-Smtp-Source: ABdhPJwflg9LAg5JKqjdfzmR8dng3mU/MIA78py9B/roaP12a1QRh02TQGuJM5vD6PcDtPB227gMlQ==
X-Received: by 2002:a17:906:a986:: with SMTP id jr6mr5887921ejb.520.1635431876440;
        Thu, 28 Oct 2021 07:37:56 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id di12sm1514501ejc.3.2021.10.28.07.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 07:37:56 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next v2 2/4] igb: move PEROUT and EXTTS isr logic to separate functions
Date:   Thu, 28 Oct 2021 16:34:57 +0200
Message-Id: <20211028143459.903439-3-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211028143459.903439-1-kernel.hbk@gmail.com>
References: <20211028143459.903439-1-kernel.hbk@gmail.com>
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
 drivers/net/ethernet/intel/igb/igb_main.c | 81 +++++++++++++----------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e67a71c3f141..c603f17e50be 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6732,12 +6732,52 @@ void igb_update_stats(struct igb_adapter *adapter)
 	}
 }
 
+static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	struct timespec64 ts;
+	u32 tsauxc;
+	int pin = ptp_find_pin(adapter->ptp_clock, PTP_PF_PEROUT, tsintr_tt);
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
+	struct e1000_hw *hw = &adapter->hw;
+	u32 sec, nsec;
+	struct ptp_clock_event event;
+	int pin = ptp_find_pin(adapter->ptp_clock, PTP_PF_EXTTS, tsintr_tt);
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
 	struct ptp_clock_event event;
-	struct timespec64 ts;
-	u32 ack = 0, tsauxc, sec, nsec, tsicr = rd32(E1000_TSICR);
+	u32 ack = 0, tsicr = rd32(E1000_TSICR);
 
 	if (tsicr & TSINTR_SYS_WRAP) {
 		event.type = PTP_CLOCK_PPS;
@@ -6753,51 +6793,22 @@ static void igb_tsync_interrupt(struct igb_adapter *adapter)
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

