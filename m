Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B74C222EB1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGPXJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgGPXJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:21 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157EAC08C5F6
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:48 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n22so5559203ejy.3
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gVZr11T9TES+/flLKY6HHJmHetSXp+ij4Gmzdm/bTEU=;
        b=H2f18hPYex1vHPHSPceTtYajJWk45mFiu8FgbKWtCyXB/6KSkf8pR14c/hesx+A6Th
         xihqX1eeDoWCWrMKzxLwzIuo2g8Le+yxk9CAXGCr4Apk+uQsSSUIr7XAwqi4LphQyl1l
         yXj5MkDStv5wAdDbz46IrICiCS4h3T4UpStd0kvAPH1/qrrGmDFje5r3awBFx3AbGZln
         qc02qrCYxVPxucIeNXeGF6CgwkeEppMPFRFmed9oI4Dbbj+l9RuNo8CjqfOeYFSGiN6d
         YT+Se4hHB4k2YBhykT2j0w/FxKQ6bQglOKx7C2pLMVrOZEVgpZ8LCyt+lLFmEQ4flZ2g
         0Rkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gVZr11T9TES+/flLKY6HHJmHetSXp+ij4Gmzdm/bTEU=;
        b=NH7woGpdrnWKcknZC7mnNhJKlFQIq0ncqCHaInJqeRRCF5gRTRCt5u7U/dJ8Qz24GE
         qWcRvYpjid4pHdz0Q7LDN0z2FuxoBgEVdKy8zHNo5ws1C/j4ctQKwt8/amzpI/Xt8udN
         eq+9qiTr4arxIaDfwqIfEkRw4TZgUBsNLoNuxIWa5axBycXZ5+q5oSXTB94qHP74IKUs
         vzZHxJL2GIQ2ZHsKyFsckBt0SV2OZbJhK0YVSKmXZJXT+E3q3LSvKboMAMFDj1XO4FYG
         ebrn87C0a9b3NTJVIJj7pJzSVV8EWvn6uJotnLd4q2WjBlTwLbHegsQ37Bf2or2LR2mz
         okHw==
X-Gm-Message-State: AOAM530ye4Dw3U1RMQJtJ12WEqr/29ni+DO+65uDqqhJuwzHWn3DOpFk
        LTm74FSKU0XhPp/xx7wdczb8ofMl
X-Google-Smtp-Source: ABdhPJy14tk5Xqf2SSDTAZZ0BPPHcb9YT7PU9m6YJFk7dB+BCq7PBb6DAWLKCXqbnkelj3znmPl50Q==
X-Received: by 2002:a17:906:408c:: with SMTP id u12mr5762361ejj.162.1594939666633;
        Thu, 16 Jul 2020 15:47:46 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id ce15sm6285512ejc.86.2020.07.16.15.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 15:47:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 3/3] net: mscc: ocelot: add support for PTP waveform configuration
Date:   Fri, 17 Jul 2020 01:45:31 +0300
Message-Id: <20200716224531.1040140-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716224531.1040140-1-olteanv@gmail.com>
References: <20200716224531.1040140-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For PPS output (perout period is 1.000000000), accept the new "phase"
parameter from the periodic output request structure.

For both PPS and freeform output, accept the new "on" argument for
specifying the duty cycle of the generated signal. Preserve the old
defaults for this "on" time: 1 us for PPS, and half the period for
freeform output.

Also preserve the old behavior that accepted the "phase" via the "start"
argument.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
Made sure it applies to net-next.

 drivers/net/ethernet/mscc/ocelot_ptp.c | 74 +++++++++++++++++---------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index a3088a1676ed..1e08fe4daaef 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -184,18 +184,20 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 		      struct ptp_clock_request *rq, int on)
 {
 	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
-	struct timespec64 ts_start, ts_period;
+	struct timespec64 ts_phase, ts_period;
 	enum ocelot_ptp_pins ptp_pin;
 	unsigned long flags;
 	bool pps = false;
 	int pin = -1;
+	s64 wf_high;
+	s64 wf_low;
 	u32 val;
-	s64 ns;
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
 		/* Reject requests with unsupported flags */
-		if (rq->perout.flags)
+		if (rq->perout.flags & ~(PTP_PEROUT_DUTY_CYCLE |
+					 PTP_PEROUT_PHASE))
 			return -EOPNOTSUPP;
 
 		pin = ptp_find_pin(ocelot->ptp_clock, PTP_PF_PEROUT,
@@ -211,22 +213,12 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 		else
 			return -EBUSY;
 
-		ts_start.tv_sec = rq->perout.start.sec;
-		ts_start.tv_nsec = rq->perout.start.nsec;
 		ts_period.tv_sec = rq->perout.period.sec;
 		ts_period.tv_nsec = rq->perout.period.nsec;
 
 		if (ts_period.tv_sec == 1 && ts_period.tv_nsec == 0)
 			pps = true;
 
-		if (ts_start.tv_sec || (ts_start.tv_nsec && !pps)) {
-			dev_warn(ocelot->dev,
-				 "Absolute start time not supported!\n");
-			dev_warn(ocelot->dev,
-				 "Accept nsec for PPS phase adjustment, otherwise start time should be 0 0.\n");
-			return -EINVAL;
-		}
-
 		/* Handle turning off */
 		if (!on) {
 			spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
@@ -236,16 +228,48 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 			break;
 		}
 
+		if (rq->perout.flags & PTP_PEROUT_PHASE) {
+			ts_phase.tv_sec = rq->perout.phase.sec;
+			ts_phase.tv_nsec = rq->perout.phase.nsec;
+		} else {
+			/* Compatibility */
+			ts_phase.tv_sec = rq->perout.start.sec;
+			ts_phase.tv_nsec = rq->perout.start.nsec;
+		}
+		if (ts_phase.tv_sec || (ts_phase.tv_nsec && !pps)) {
+			dev_warn(ocelot->dev,
+				 "Absolute start time not supported!\n");
+			dev_warn(ocelot->dev,
+				 "Accept nsec for PPS phase adjustment, otherwise start time should be 0 0.\n");
+			return -EINVAL;
+		}
+
+		/* Calculate waveform high and low times */
+		if (rq->perout.flags & PTP_PEROUT_DUTY_CYCLE) {
+			struct timespec64 ts_on;
+
+			ts_on.tv_sec = rq->perout.on.sec;
+			ts_on.tv_nsec = rq->perout.on.nsec;
+
+			wf_high = timespec64_to_ns(&ts_on);
+		} else {
+			if (pps) {
+				wf_high = 1000;
+			} else {
+				wf_high = timespec64_to_ns(&ts_period);
+				wf_high = div_s64(wf_high, 2);
+			}
+		}
+
+		wf_low = timespec64_to_ns(&ts_period);
+		wf_low -= wf_high;
+
 		/* Handle PPS request */
 		if (pps) {
 			spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-			/* Pulse generated perout.start.nsec after TOD has
-			 * increased seconds.
-			 * Pulse width is set to 1us.
-			 */
-			ocelot_write_rix(ocelot, ts_start.tv_nsec,
+			ocelot_write_rix(ocelot, ts_phase.tv_nsec,
 					 PTP_PIN_WF_LOW_PERIOD, ptp_pin);
-			ocelot_write_rix(ocelot, 1000,
+			ocelot_write_rix(ocelot, wf_high,
 					 PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
 			val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
 			val |= PTP_PIN_CFG_SYNC;
@@ -255,14 +279,16 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 		}
 
 		/* Handle periodic clock */
-		ns = timespec64_to_ns(&ts_period);
-		ns = ns >> 1;
-		if (ns > 0x3fffffff || ns <= 0x6)
+		if (wf_high > 0x3fffffff || wf_high <= 0x6)
+			return -EINVAL;
+		if (wf_low > 0x3fffffff || wf_low <= 0x6)
 			return -EINVAL;
 
 		spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_LOW_PERIOD, ptp_pin);
-		ocelot_write_rix(ocelot, ns, PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
+		ocelot_write_rix(ocelot, wf_low, PTP_PIN_WF_LOW_PERIOD,
+				 ptp_pin);
+		ocelot_write_rix(ocelot, wf_high, PTP_PIN_WF_HIGH_PERIOD,
+				 ptp_pin);
 		val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
 		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
 		spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-- 
2.25.1

