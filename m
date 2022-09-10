Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69E5B4503
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 09:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiIJHy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 03:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIJHyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 03:54:52 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A309C25592;
        Sat, 10 Sep 2022 00:54:46 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28A3ng0b021854;
        Sat, 10 Sep 2022 00:54:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=sVX9PwxBRKnz7/OAA9gdPRlJbJf/Nr4NyRhduEfVjMM=;
 b=kcsqGRQxgKmFdxQ/u5Z8bMu5blxRzzp3KHvdIvVyWBEzyTVKhHB6uAcI74yGtOL2JB/L
 R9LbDzfqLkPyfF144zB6SUuBMayR0yV/cPaS4tpdhO0yoPdqZb5u2CiR4vgq1ZMSSOek
 x+fKR+eBOqx8MKDtE3YnXcTqJGFpsO3HhYSZg4hwyEaX/rZzi5CrdWoKIhoonB0FF52v
 yaTa8AqA9f06Z1zDxlqvK8HT/BxbiiHwdipeoCMic2tJtcUX9ufys5G5RVAfo0g13mYG
 i9BOLyi1TjLxgWhlfIgtLddrMlnEMYNw9c/tJpPnP7LQ0Ie/3Im9+tavsnQcIIS/9yst SQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jgjwm8h0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 10 Sep 2022 00:54:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 10 Sep
 2022 00:54:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 10 Sep 2022 00:54:33 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id CC5AE3F7048;
        Sat, 10 Sep 2022 00:54:29 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net-next PATCH 3/4] octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon
Date:   Sat, 10 Sep 2022 13:24:15 +0530
Message-ID: <20220910075416.22887-4-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220910075416.22887-1-naveenm@marvell.com>
References: <20220910075416.22887-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: OKxYQUX7kGuFppkTKltH_c_kmatBB0ot
X-Proofpoint-ORIG-GUID: OKxYQUX7kGuFppkTKltH_c_kmatBB0ot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-10_04,2022-09-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Errata:
The ptp_clock_hi rollsover to zero one clock cycle before it
reaches one second boundary. As a result, the pps threshold
comparison fails after one second and the pps output signal
won't toggle further.

This patch workarounds the issue by programming the pps_lo_incr
register to 500msec minus one clock cycle period, ensuring that
the pps threshold comparison succeeds at one second rollover
boundary and pps edge toggles. After that point, the driver will
have enough time (~500msec) to reset the pps threshold value.
After each one second boundary, hrtimer is invoked which resets
the pps threshold value.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  2 +
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 82 +++++++++++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  3 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 27 +++++--
 4 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index d7762577e285..e26c3b0c4dcb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1471,6 +1471,7 @@ enum ptp_op {
 	PTP_OP_GET_CLOCK = 1,
 	PTP_OP_GET_TSTMP = 2,
 	PTP_OP_SET_THRESH = 3,
+	PTP_OP_EXTTS_ON = 4,
 };
 
 struct ptp_req {
@@ -1478,6 +1479,7 @@ struct ptp_req {
 	u8 op;
 	s64 scaled_ppm;
 	u64 thresh;
+	int extts_on;
 };
 
 struct ptp_rsp {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index b2c3527fe665..01f7dbad6b92 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -9,6 +9,8 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/hrtimer.h>
+#include <linux/ktime.h>
 
 #include "ptp.h"
 #include "mbox.h"
@@ -77,6 +79,43 @@ static bool is_ptp_tsfmt_sec_nsec(struct ptp *ptp)
 	return false;
 }
 
+static enum hrtimer_restart ptp_reset_thresh(struct hrtimer *hrtimer)
+{
+	struct ptp *ptp = container_of(hrtimer, struct ptp, hrtimer);
+	ktime_t curr_ts = ktime_get();
+	ktime_t delta_ns, period_ns;
+	u64 ptp_clock_hi;
+
+	/* calculate the elapsed time since last restart */
+	delta_ns = ktime_to_ns(ktime_sub(curr_ts, ptp->last_ts));
+
+	/* if the ptp clock value has crossed 0.5 seconds,
+	 * its too late to update pps threshold value, so
+	 * update threshold after 1 second.
+	 */
+	ptp_clock_hi = readq(ptp->reg_base + PTP_CLOCK_HI);
+	if (ptp_clock_hi > 500000000) {
+		period_ns = ktime_set(0, (NSEC_PER_SEC + 100 - ptp_clock_hi));
+	} else {
+		writeq(500000000, ptp->reg_base + PTP_PPS_THRESH_HI);
+		period_ns = ktime_set(0, (NSEC_PER_SEC + 100 - delta_ns));
+	}
+
+	hrtimer_forward_now(hrtimer, period_ns);
+	ptp->last_ts = curr_ts;
+
+	return HRTIMER_RESTART;
+}
+
+static void ptp_hrtimer_start(struct ptp *ptp, ktime_t start_ns)
+{
+	ktime_t period_ns;
+
+	period_ns = ktime_set(0, (NSEC_PER_SEC + 100 - start_ns));
+	hrtimer_start(&ptp->hrtimer, period_ns, HRTIMER_MODE_REL);
+	ptp->last_ts = ktime_get();
+}
+
 static u64 read_ptp_tstmp_sec_nsec(struct ptp *ptp)
 {
 	u64 sec, sec1, nsec;
@@ -275,6 +314,18 @@ void ptp_start(struct ptp *ptp, u64 sclk, u32 ext_clk_freq, u32 extts)
 	/* Set 50% duty cycle for 1Hz output */
 	writeq(0x1dcd650000000000, ptp->reg_base + PTP_PPS_HI_INCR);
 	writeq(0x1dcd650000000000, ptp->reg_base + PTP_PPS_LO_INCR);
+	if (cn10k_ptp_errata(ptp)) {
+		/* The ptp_clock_hi rollsover to zero once clock cycle before it
+		 * reaches one second boundary. so, program the pps_lo_incr in
+		 * such a way that the pps threshold value comparison at one
+		 * second boundary will succeed and pps edge changes. After each
+		 * one second boundary, the hrtimer handler will be invoked and
+		 * reprograms the pps threshold value.
+		 */
+		ptp->clock_period = NSEC_PER_SEC / ptp->clock_rate;
+		writeq((0x1dcd6500ULL - ptp->clock_period) << 32,
+		       ptp->reg_base + PTP_PPS_LO_INCR);
+	}
 
 	if (cn10k_ptp_errata(ptp))
 		clock_comp = ptp_calc_adjusted_comp(ptp->clock_rate);
@@ -301,7 +352,25 @@ static int ptp_get_tstmp(struct ptp *ptp, u64 *clk)
 
 static int ptp_set_thresh(struct ptp *ptp, u64 thresh)
 {
-	writeq(thresh, ptp->reg_base + PTP_PPS_THRESH_HI);
+	if (!cn10k_ptp_errata(ptp))
+		writeq(thresh, ptp->reg_base + PTP_PPS_THRESH_HI);
+
+	return 0;
+}
+
+static int ptp_extts_on(struct ptp *ptp, int on)
+{
+	u64 ptp_clock_hi;
+
+	if (cn10k_ptp_errata(ptp)) {
+		if (on) {
+			ptp_clock_hi = readq(ptp->reg_base + PTP_CLOCK_HI);
+			ptp_hrtimer_start(ptp, (ktime_t)ptp_clock_hi);
+		} else {
+			if (hrtimer_active(&ptp->hrtimer))
+				hrtimer_cancel(&ptp->hrtimer);
+		}
+	}
 
 	return 0;
 }
@@ -341,6 +410,11 @@ static int ptp_probe(struct pci_dev *pdev,
 	else
 		ptp->read_ptp_tstmp = &read_ptp_tstmp_nsec;
 
+	if (cn10k_ptp_errata(ptp)) {
+		hrtimer_init(&ptp->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		ptp->hrtimer.function = ptp_reset_thresh;
+	}
+
 	return 0;
 
 error_free:
@@ -365,6 +439,9 @@ static void ptp_remove(struct pci_dev *pdev)
 	struct ptp *ptp = pci_get_drvdata(pdev);
 	u64 clock_cfg;
 
+	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
+		hrtimer_cancel(&ptp->hrtimer);
+
 	if (IS_ERR_OR_NULL(ptp))
 		return;
 
@@ -432,6 +509,9 @@ int rvu_mbox_handler_ptp_op(struct rvu *rvu, struct ptp_req *req,
 	case PTP_OP_SET_THRESH:
 		err = ptp_set_thresh(rvu->ptp, req->thresh);
 		break;
+	case PTP_OP_EXTTS_ON:
+		err = ptp_extts_on(rvu->ptp, req->extts_on);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
index 95a955159f40..b9d92abc3844 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
@@ -17,7 +17,10 @@ struct ptp {
 	void __iomem *reg_base;
 	u64 (*read_ptp_tstmp)(struct ptp *ptp);
 	spinlock_t ptp_lock; /* lock */
+	struct hrtimer hrtimer;
+	ktime_t last_ts;
 	u32 clock_rate;
+	u32 clock_period;
 };
 
 struct ptp *ptp_get(void);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 743c8a6d5dad..896b2f9bac34 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -73,6 +73,23 @@ static int ptp_set_thresh(struct otx2_ptp *ptp, u64 thresh)
 	return otx2_sync_mbox_msg(&ptp->nic->mbox);
 }
 
+static int ptp_extts_on(struct otx2_ptp *ptp, int on)
+{
+	struct ptp_req *req;
+
+	if (!ptp->nic)
+		return -ENODEV;
+
+	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->op = PTP_OP_EXTTS_ON;
+	req->extts_on = on;
+
+	return otx2_sync_mbox_msg(&ptp->nic->mbox);
+}
+
 static u64 ptp_cc_read(const struct cyclecounter *cc)
 {
 	struct otx2_ptp *ptp = container_of(cc, struct otx2_ptp, cycle_counter);
@@ -189,8 +206,6 @@ static void otx2_ptp_extts_check(struct work_struct *work)
 		event.index = 0;
 		event.timestamp = timecounter_cyc2time(&ptp->time_counter, tstmp);
 		ptp_clock_event(ptp->ptp_clock, &event);
-		ptp->last_extts = tstmp;
-
 		new_thresh = tstmp % 500000000;
 		if (ptp->thresh != new_thresh) {
 			mutex_lock(&ptp->nic->mbox.lock);
@@ -198,6 +213,7 @@ static void otx2_ptp_extts_check(struct work_struct *work)
 			mutex_unlock(&ptp->nic->mbox.lock);
 			ptp->thresh = new_thresh;
 		}
+		ptp->last_extts = tstmp;
 	}
 	schedule_delayed_work(&ptp->extts_work, msecs_to_jiffies(200));
 }
@@ -235,10 +251,13 @@ static int otx2_ptp_enable(struct ptp_clock_info *ptp_info,
 				   rq->extts.index);
 		if (pin < 0)
 			return -EBUSY;
-		if (on)
+		if (on) {
+			ptp_extts_on(ptp, on);
 			schedule_delayed_work(&ptp->extts_work, msecs_to_jiffies(200));
-		else
+		} else {
+			ptp_extts_on(ptp, on);
 			cancel_delayed_work_sync(&ptp->extts_work);
+		}
 		return 0;
 	default:
 		break;
-- 
2.16.5

