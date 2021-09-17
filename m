Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD3541006B
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 22:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244187AbhIQUwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 16:52:07 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:41240 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbhIQUv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 16:51:58 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 18HKoY6X007130;
        Fri, 17 Sep 2021 16:50:34 -0400
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap02.intersil.com with ESMTP id 3b4e7wrb0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 16:50:33 -0400
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2242.4; Fri, 17 Sep 2021 16:50:32 -0400
Received: from localhost (132.158.202.109) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Fri, 17 Sep 2021 16:50:32 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time correction
Date:   Fri, 17 Sep 2021 16:50:21 -0400
Message-ID: <1631911821-31142-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1631911821-31142-1-git-send-email-min.li.xe@renesas.com>
References: <1631911821-31142-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: T6Dqxy6BBwL41Sl1mOCyopys7o34BzYP
X-Proofpoint-ORIG-GUID: T6Dqxy6BBwL41Sl1mOCyopys7o34BzYP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-17_08:2021-09-17,2021-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109150000 definitions=main-2109170123
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Current adjtime is not accurate when delta is smaller than 10000ns. So
for small time correction, we will switch to DCO mode to pull phase
more precisely in one second duration.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
Change log
-create delayed_accurate_adjtime parameter to choose the optimized adjtime suggested by Richard
-fix checkpatch issues

 drivers/ptp/ptp_idt82p33.c | 170 +++++++++++++++++++++++++++++++++------------
 drivers/ptp/ptp_idt82p33.h |   6 +-
 2 files changed, 131 insertions(+), 45 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index abe628c..609b4da 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -29,6 +29,14 @@ module_param(phase_snap_threshold, uint, 0);
 MODULE_PARM_DESC(phase_snap_threshold,
 "threshold (1000ns by default) below which adjtime would ignore");
 
+static bool delayed_accurate_adjtime;
+module_param(delayed_accurate_adjtime, bool, false);
+MODULE_PARM_DESC(delayed_accurate_adjtime,
+"set to true to use more accurate adjtime that is delayed to next 1PPS signal");
+
+static char *firmware;
+module_param(firmware, charp, 0);
+
 static void idt82p33_byte_array_to_timespec(struct timespec64 *ts,
 					    u8 buf[TOD_BYTE_COUNT])
 {
@@ -389,25 +397,22 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 	int err, i;
 	s64 fcw;
 
-	if (scaled_ppm == channel->current_freq_ppb)
-		return 0;
-
 	/*
-	 * Frequency Control Word unit is: 1.68 * 10^-10 ppm
+	 * Frequency Control Word unit is: 1.6861512 * 10^-10 ppm
 	 *
 	 * adjfreq:
-	 *       ppb * 10^9
-	 * FCW = ----------
-	 *          168
+	 *       ppb * 10^14
+	 * FCW = -----------
+	 *         16861512
 	 *
 	 * adjfine:
-	 *       scaled_ppm * 5^12
-	 * FCW = -------------
-	 *         168 * 2^4
+	 *       scaled_ppm * 5^12 * 10^5
+	 * FCW = ------------------------
+	 *            16861512 * 2^4
 	 */
 
-	fcw = scaled_ppm * 244140625ULL;
-	fcw = div_s64(fcw, 2688);
+	fcw = scaled_ppm * 762939453125ULL;
+	fcw = div_s64(fcw, 8430756LL);
 
 	for (i = 0; i < 5; i++) {
 		buf[i] = fcw & 0xff;
@@ -422,26 +427,77 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 	err = idt82p33_write(idt82p33, channel->dpll_freq_cnfg,
 			     buf, sizeof(buf));
 
-	if (err == 0)
-		channel->current_freq_ppb = scaled_ppm;
-
 	return err;
 }
 
+/* ppb = scaled_ppm * 125 / 2^13 */
+static s32 idt82p33_ddco_scaled_ppm(long current_ppm, s32 ddco_ppb)
+{
+	s64 scaled_ppm = (ddco_ppb << 13) / 125;
+	s64 max_scaled_ppm = (DCO_MAX_PPB << 13) / 125;
+
+	current_ppm += scaled_ppm;
+
+	if (current_ppm > max_scaled_ppm)
+		current_ppm = max_scaled_ppm;
+	else if (current_ppm < -max_scaled_ppm)
+		current_ppm = -max_scaled_ppm;
+
+	return (s32)current_ppm;
+}
+
+static int idt82p33_stop_ddco(struct idt82p33_channel *channel)
+{
+	channel->ddco = false;
+	return _idt82p33_adjfine(channel, channel->current_freq);
+}
+
+static int idt82p33_start_ddco(struct idt82p33_channel *channel, s32 delta_ns)
+{
+	s32 current_ppm = channel->current_freq;
+	u32 duration_ms = MSEC_PER_SEC;
+	s32 ppb;
+	int err;
+
+	/* If the ToD correction is less than 5 nanoseconds, then skip it.
+	 * The error introduced by the ToD adjustment procedure would be bigger
+	 * than the required ToD correction
+	 */
+	if (abs(delta_ns) < DDCO_THRESHOLD_NS)
+		return 0;
+
+	/* For most cases, keep ddco duration 1 second */
+	ppb = delta_ns;
+	while (abs(ppb) > DCO_MAX_PPB) {
+		duration_ms *= 2;
+		ppb /= 2;
+	}
+
+	err = _idt82p33_adjfine(channel,
+				idt82p33_ddco_scaled_ppm(current_ppm, ppb));
+	if (err)
+		return err;
+
+	/* schedule the worker to cancel ddco */
+	ptp_schedule_worker(channel->ptp_clock,
+			    msecs_to_jiffies(duration_ms) - 1);
+	channel->ddco = true;
+
+	return 0;
+}
+
 static int idt82p33_measure_one_byte_write_overhead(
 		struct idt82p33_channel *channel, s64 *overhead_ns)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	ktime_t start, stop;
+	u8 trigger = 0;
 	s64 total_ns;
-	u8 trigger;
 	int err;
 	u8 i;
 
 	total_ns = 0;
 	*overhead_ns = 0;
-	trigger = TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
 
 	for (i = 0; i < MAX_MEASURMENT_COUNT; i++) {
 
@@ -658,6 +714,20 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 			      &sync_cnfg, sizeof(sync_cnfg));
 }
 
+static long idt82p33_work_handler(struct ptp_clock_info *ptp)
+{
+	struct idt82p33_channel *channel =
+			container_of(ptp, struct idt82p33_channel, caps);
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+
+	mutex_lock(&idt82p33->reg_lock);
+	(void)idt82p33_stop_ddco(channel);
+	mutex_unlock(&idt82p33->reg_lock);
+
+	/* Return a negative value here to not reschedule */
+	return -1;
+}
+
 static int idt82p33_output_enable(struct idt82p33_channel *channel,
 				  bool enable, unsigned int outn)
 {
@@ -743,23 +813,20 @@ static void idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
 
 	for (i = 0; i < MAX_PHC_PLL; i++) {
 		channel = &idt82p33->channel[i];
-
 		if (channel->ptp_clock) {
-			channel = &idt82p33->channel[i];
+			cancel_delayed_work_sync(&channel->adjtime_work);
 			ptp_clock_unregister(channel->ptp_clock);
 		}
 	}
 }
 
 static int idt82p33_enable(struct ptp_clock_info *ptp,
-			 struct ptp_clock_request *rq, int on)
+			   struct ptp_clock_request *rq, int on)
 {
 	struct idt82p33_channel *channel =
 			container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
-	int err;
-
-	err = -EOPNOTSUPP;
+	int err = -EOPNOTSUPP;
 
 	mutex_lock(&idt82p33->reg_lock);
 
@@ -769,15 +836,18 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 						     &rq->perout);
 		/* Only accept a 1-PPS aligned to the second. */
 		else if (rq->perout.start.nsec || rq->perout.period.sec != 1 ||
-		    rq->perout.period.nsec) {
+			 rq->perout.period.nsec)
 			err = -ERANGE;
-		} else
+		else
 			err = idt82p33_perout_enable(channel, true,
 						     &rq->perout);
 	}
 
 	mutex_unlock(&idt82p33->reg_lock);
 
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 	return err;
 }
 
@@ -830,14 +900,18 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
+	if (channel->ddco == true || scaled_ppm == channel->current_freq)
+		return 0;
+
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_adjfine(channel, scaled_ppm);
+	if (err == 0)
+		channel->current_freq = scaled_ppm;
 	mutex_unlock(&idt82p33->reg_lock);
 
 	if (err)
 		dev_err(&idt82p33->client->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-
 	return err;
 }
 
@@ -848,20 +922,29 @@ static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
+	if (delayed_accurate_adjtime == false) {
+		if (abs(delta_ns) < IMMEDIATE_SNAP_THRESHOLD_NS)
+			return 0;
+		mutex_lock(&idt82p33->reg_lock);
+		err = _idt82p33_adjtime_immediate(channel, delta_ns);
+		mutex_unlock(&idt82p33->reg_lock);
+		goto exit;
+	}
+
+	if (channel->ddco == true)
+		return 0;
+
 	mutex_lock(&idt82p33->reg_lock);
 
 	if (abs(delta_ns) < phase_snap_threshold) {
+		err = idt82p33_start_ddco(channel, delta_ns);
 		mutex_unlock(&idt82p33->reg_lock);
-		return 0;
+		return err;
 	}
 
-	/* Use more accurate internal 1pps triggered write first */
 	err = _idt82p33_adjtime_internal_triggered(channel, delta_ns);
-	if (err && delta_ns > IMMEDIATE_SNAP_THRESHOLD_NS)
-		err = _idt82p33_adjtime_immediate(channel, delta_ns);
-
 	mutex_unlock(&idt82p33->reg_lock);
-
+exit:
 	if (err)
 		dev_err(&idt82p33->client->dev,
 			"Adjtime failed in %s with err %d!\n", __func__, err);
@@ -932,7 +1015,7 @@ static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
 		return -EINVAL;
 	}
 
-	channel->current_freq_ppb = 0;
+	channel->current_freq = 0;
 
 	return 0;
 }
@@ -940,7 +1023,7 @@ static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
 static void idt82p33_caps_init(struct ptp_clock_info *caps)
 {
 	caps->owner = THIS_MODULE;
-	caps->max_adj = 92000;
+	caps->max_adj = DCO_MAX_PPB;
 	caps->n_per_out = 11;
 	caps->adjphase = idt82p33_adjwritephase;
 	caps->adjfine = idt82p33_adjfine;
@@ -948,6 +1031,7 @@ static void idt82p33_caps_init(struct ptp_clock_info *caps)
 	caps->gettime64 = idt82p33_gettime;
 	caps->settime64 = idt82p33_settime;
 	caps->enable = idt82p33_enable;
+	caps->do_aux_work = idt82p33_work_handler;
 }
 
 static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
@@ -1011,16 +1095,19 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
 static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 {
+	char fname[128] = FW_FILENAME;
 	const struct firmware *fw;
 	struct idt82p33_fwrc *rec;
 	u8 loaddr, page, val;
 	int err;
 	s32 len;
 
-	dev_dbg(&idt82p33->client->dev,
-		"requesting firmware '%s'\n", FW_FILENAME);
+	if (firmware) /* module parameter */
+		snprintf(fname, sizeof(fname), "%s", firmware);
+
+	dev_dbg(&idt82p33->client->dev, "requesting firmware '%s'\n", fname);
 
-	err = request_firmware(&fw, FW_FILENAME, &idt82p33->client->dev);
+	err = request_firmware(&fw, fname, &idt82p33->client->dev);
 
 	if (err) {
 		dev_err(&idt82p33->client->dev,
@@ -1050,13 +1137,8 @@ static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 		}
 
 		if (err == 0) {
-			/* maximum 8 pages  */
-			if (page >= PAGE_NUM)
-				continue;
-
 			/* Page size 128, last 4 bytes of page skipped */
-			if (((loaddr > 0x7b) && (loaddr <= 0x7f))
-			     || loaddr > 0xfb)
+			if (loaddr > 0x7b)
 				continue;
 
 			err = idt82p33_write(idt82p33, _ADDR(page, loaddr),
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index a8b0923..6564f1c 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -92,9 +92,11 @@ enum hw_tod_trig_sel {
 #define FW_FILENAME			"idt82p33xxx.bin"
 #define MAX_PHC_PLL			(2)
 #define TOD_BYTE_COUNT			(10)
+#define DCO_MAX_PPB			(92000)
 #define MAX_MEASURMENT_COUNT		(5)
 #define SNAP_THRESHOLD_NS		(10000)
 #define IMMEDIATE_SNAP_THRESHOLD_NS	(50000)
+#define DDCO_THRESHOLD_NS		(5)
 #define IDT82P33_MAX_WRITE_COUNT	(512)
 
 #define PLLMASK_ADDR_HI	0xFF
@@ -129,7 +131,9 @@ struct idt82p33_channel {
 	struct idt82p33		*idt82p33;
 	enum pll_mode		pll_mode;
 	struct delayed_work	adjtime_work;
-	s32			current_freq_ppb;
+	s32			current_freq;
+	/* double dco mode */
+	bool			ddco;
 	u8			output_mask;
 	u16			dpll_tod_cnfg;
 	u16			dpll_tod_trigger;
-- 
2.7.4

