Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220CA4DA371
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351464AbiCOTro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351455AbiCOTrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:47:43 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA0351E6E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:46:30 -0700 (PDT)
Received: (qmail 80695 invoked by uid 89); 15 Mar 2022 19:46:27 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 15 Mar 2022 19:46:27 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next] ptp: ocp: Fix PTP_PF_* verification requests
Date:   Tue, 15 Mar 2022 12:46:26 -0700
Message-Id: <20220315194626.1895-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update and check functionality for pin configuration requests:

PTP_PF_NONE: requests "IN: None", disabling the pin.

  # testptp -d /dev/ptp3 -L3,0 -i1
  set pin function okay
  # cat sma4
  IN: None

PTP_PF_EXTTS: should configure external timestamps, but since the
timecard can steer inputs to multiple inputs as well as timestamps,
allow the request, but don't change configurations.

  # testptp -d /dev/ptp3 -L3,1 -i1
  set pin function okay

  (no functional or configuration change here yet)

PTP_PF_PEROUT: Channel 0 is the PHC, at 1PPS.  Channels 1-4 are
the programmable frequency generators.

  # fails because period is not 1PPS.
  # testptp -d /dev/ptp3 -L3,2 -i0  -p 500000000
  PTP_PEROUT_REQUEST: Invalid argument

  # testptp -d /dev/ptp3 -L3,2 -i0  -p 1000000000
  periodic output request okay
  # cat sma4
  OUT: PHC

  # testptp -d /dev/ptp3 -L3,2 -i1 -p 500000000 -w 200000000
  periodic output request okay
  # cat sma4
  OUT: GEN1
  # cat gen1/signal
  500000000 40 0 1 2022-03-10T23:55:26 TAI
  # cat gen1/running
  1

  # testptp -d /dev/ptp3 -L3,2 -i1 -p 0
  periodic output request okay
  # cat gen1/running
  0

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 56b04a7bba3a..d8cefc89a588 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -970,13 +970,25 @@ ptp_ocp_verify(struct ptp_clock_info *ptp_info, unsigned pin,
 	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
 	char buf[16];
 
-	if (func != PTP_PF_PEROUT)
+	switch (func) {
+	case PTP_PF_NONE:
+		sprintf(buf, "IN: None");
+		break;
+	case PTP_PF_EXTTS:
+		/* Allow timestamps, but require sysfs configuration. */
+		return 0;
+	case PTP_PF_PEROUT:
+		/* channel 0 is 1PPS from PHC.
+		 * channels 1..4 are the frequency generators.
+		 */
+		if (chan)
+			sprintf(buf, "OUT: GEN%d", chan);
+		else
+			sprintf(buf, "OUT: PHC");
+		break;
+	default:
 		return -EOPNOTSUPP;
-
-	if (chan)
-		sprintf(buf, "OUT: GEN%d", chan);
-	else
-		sprintf(buf, "OUT: PHC");
+	}
 
 	return ptp_ocp_sma_store(bp, buf, pin + 1);
 }
@@ -2922,7 +2934,7 @@ _signal_summary_show(struct seq_file *s, struct ptp_ocp *bp, int nr)
 		return;
 
 	on = signal->running;
-	sprintf(label, "GEN%d", nr);
+	sprintf(label, "GEN%d", nr + 1);
 	seq_printf(s, "%7s: %s, period:%llu duty:%d%% phase:%llu pol:%d",
 		   label, on ? " ON" : "OFF",
 		   signal->period, signal->duty, signal->phase,
@@ -2947,7 +2959,7 @@ _frequency_summary_show(struct seq_file *s, int nr,
 	if (!reg)
 		return;
 
-	sprintf(label, "FREQ%d", nr);
+	sprintf(label, "FREQ%d", nr + 1);
 	val = ioread32(&reg->ctrl);
 	on = val & 1;
 	val = (val >> 8) & 0xff;
-- 
2.31.1

