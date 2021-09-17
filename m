Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB0F40FB41
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245152AbhIQPH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:07:28 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:54000 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343629AbhIQPHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:07:11 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 18HEPDGX008354;
        Fri, 17 Sep 2021 10:40:16 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 3b4e7wr7xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 10:40:15 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2242.4; Fri, 17 Sep 2021 10:40:14 -0400
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Fri, 17 Sep 2021 10:40:13 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v2 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Date:   Fri, 17 Sep 2021 10:39:48 -0400
Message-ID: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: O6kALiFYIkRbbIGJ8qcoJg3VWEeDKTkQ
X-Proofpoint-ORIG-GUID: O6kALiFYIkRbbIGJ8qcoJg3VWEeDKTkQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-17_06:2021-09-17,2021-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109150000 definitions=main-2109170092
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

The current adjtime implementation is read-modify-write and immediately
triggered, which is not accurate due to slow i2c bus access. Therefore,
we will use internally generated 1 PPS pulse as trigger, which will
improve adjtime accuracy significantly. On the other hand, the new trigger
will not change TOD immediately but delay it to the next 1 PPS pulse.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 221 ++++++++++++++++++++++++++++++---------------
 drivers/ptp/ptp_idt82p33.h |  28 +++---
 2 files changed, 165 insertions(+), 84 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index c1c959f..abe628c 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -24,15 +24,10 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FW_FILENAME);
 
 /* Module Parameters */
-static u32 sync_tod_timeout = SYNC_TOD_TIMEOUT_SEC;
-module_param(sync_tod_timeout, uint, 0);
-MODULE_PARM_DESC(sync_tod_timeout,
-"duration in second to keep SYNC_TOD on (set to 0 to keep it always on)");
-
 static u32 phase_snap_threshold = SNAP_THRESHOLD_NS;
 module_param(phase_snap_threshold, uint, 0);
 MODULE_PARM_DESC(phase_snap_threshold,
-"threshold (150000ns by default) below which adjtime would ignore");
+"threshold (1000ns by default) below which adjtime would ignore");
 
 static void idt82p33_byte_array_to_timespec(struct timespec64 *ts,
 					    u8 buf[TOD_BYTE_COUNT])
@@ -206,26 +201,47 @@ static int idt82p33_dpll_set_mode(struct idt82p33_channel *channel,
 	if (err)
 		return err;
 
-	channel->pll_mode = dpll_mode;
+	channel->pll_mode = mode;
 
 	return 0;
 }
 
-static int _idt82p33_gettime(struct idt82p33_channel *channel,
-			     struct timespec64 *ts)
+static int idt82p33_set_tod_trigger(struct idt82p33_channel *channel,
+				    u8 trigger, bool write)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
-	u8 buf[TOD_BYTE_COUNT];
-	u8 trigger;
 	int err;
+	u8 cfg;
 
-	trigger = TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
+	if (trigger > WR_TRIG_SEL_MAX)
+		return -EINVAL;
 
+	err = idt82p33_read(idt82p33, channel->dpll_tod_trigger,
+			    &cfg, sizeof(cfg));
 
-	err = idt82p33_write(idt82p33, channel->dpll_tod_trigger,
-			     &trigger, sizeof(trigger));
+	if (err)
+		return err;
+
+	if (write == true)
+		trigger = (trigger << WRITE_TRIGGER_SHIFT) |
+			  (cfg & READ_TRIGGER_MASK);
+	else
+		trigger = (trigger << READ_TRIGGER_SHIFT) |
+			  (cfg & WRITE_TRIGGER_MASK);
+
+	return idt82p33_write(idt82p33, channel->dpll_tod_trigger,
+			      &trigger, sizeof(trigger));
+}
+
+static int _idt82p33_gettime(struct idt82p33_channel *channel,
+			     struct timespec64 *ts)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	u8 buf[TOD_BYTE_COUNT];
+	int err;
 
+	err = idt82p33_set_tod_trigger(channel, HW_TOD_RD_TRIG_SEL_LSB_TOD_STS,
+				       false);
 	if (err)
 		return err;
 
@@ -255,16 +271,11 @@ static int _idt82p33_settime(struct idt82p33_channel *channel,
 	struct timespec64 local_ts = *ts;
 	char buf[TOD_BYTE_COUNT];
 	s64 dynamic_overhead_ns;
-	unsigned char trigger;
 	int err;
 	u8 i;
 
-	trigger = TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
-
-	err = idt82p33_write(idt82p33, channel->dpll_tod_trigger,
-			&trigger, sizeof(trigger));
-
+	err = idt82p33_set_tod_trigger(channel, HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
+				       true);
 	if (err)
 		return err;
 
@@ -292,7 +303,8 @@ static int _idt82p33_settime(struct idt82p33_channel *channel,
 	return err;
 }
 
-static int _idt82p33_adjtime(struct idt82p33_channel *channel, s64 delta_ns)
+static int _idt82p33_adjtime_immediate(struct idt82p33_channel *channel,
+				       s64 delta_ns)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	struct timespec64 ts;
@@ -316,6 +328,60 @@ static int _idt82p33_adjtime(struct idt82p33_channel *channel, s64 delta_ns)
 	return err;
 }
 
+static int _idt82p33_adjtime_internal_triggered(struct idt82p33_channel *channel,
+						s64 delta_ns)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	char buf[TOD_BYTE_COUNT];
+	struct timespec64 ts;
+	const u8 delay_ns = 32;
+	s32 delay_ns_remainder;
+	s64 ns;
+	int err;
+
+	err = _idt82p33_gettime(channel, &ts);
+
+	if (err)
+		return err;
+
+	if (ts.tv_nsec > (NSEC_PER_SEC - 5 * NSEC_PER_MSEC)) {
+		/*  Too close to miss next trigger, so skip it */
+		mdelay(6);
+		ns = (ts.tv_sec + 2) * NSEC_PER_SEC + delta_ns + delay_ns;
+	} else
+		ns = (ts.tv_sec + 1) * NSEC_PER_SEC + delta_ns + delay_ns;
+
+	ts = ns_to_timespec64(ns);
+	idt82p33_timespec_to_byte_array(&ts, buf);
+
+	/*
+	 * Store the new time value.
+	 */
+	err = idt82p33_write(idt82p33, channel->dpll_tod_cnfg, buf, sizeof(buf));
+	if (err)
+		return err;
+
+	/* Schedule to implement the workaround in one second */
+	div_s64_rem(delta_ns, NSEC_PER_SEC, &delay_ns_remainder);
+	if (delay_ns_remainder)
+		schedule_delayed_work(&channel->adjtime_work, HZ);
+
+	return idt82p33_set_tod_trigger(channel, HW_TOD_TRIG_SEL_TOD_PPS, true);
+}
+
+static void idt82p33_adjtime_workaround(struct work_struct *work)
+{
+	struct idt82p33_channel *channel = container_of(work,
+							struct idt82p33_channel,
+							adjtime_work.work);
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+
+	mutex_lock(&idt82p33->reg_lock);
+	/* Workaround for TOD-to-output alignment issue */
+	_idt82p33_adjtime_internal_triggered(channel, 0);
+	mutex_unlock(&idt82p33->reg_lock);
+}
+
 static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
@@ -397,6 +463,39 @@ static int idt82p33_measure_one_byte_write_overhead(
 	return err;
 }
 
+static int idt82p33_measure_one_byte_read_overhead(
+		struct idt82p33_channel *channel, s64 *overhead_ns)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	ktime_t start, stop;
+	u8 trigger = 0;
+	s64 total_ns;
+	int err;
+	u8 i;
+
+	total_ns = 0;
+	*overhead_ns = 0;
+
+	for (i = 0; i < MAX_MEASURMENT_COUNT; i++) {
+
+		start = ktime_get_raw();
+
+		err = idt82p33_read(idt82p33, channel->dpll_tod_trigger,
+				    &trigger, sizeof(trigger));
+
+		stop = ktime_get_raw();
+
+		if (err)
+			return err;
+
+		total_ns += ktime_to_ns(stop) - ktime_to_ns(start);
+	}
+
+	*overhead_ns = div_s64(total_ns, MAX_MEASURMENT_COUNT);
+
+	return err;
+}
+
 static int idt82p33_measure_tod_write_9_byte_overhead(
 			struct idt82p33_channel *channel)
 {
@@ -458,7 +557,7 @@ static int idt82p33_measure_settime_gettime_gap_overhead(
 
 static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 {
-	s64 trailing_overhead_ns, one_byte_write_ns, gap_ns;
+	s64 trailing_overhead_ns, one_byte_write_ns, gap_ns, one_byte_read_ns;
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
@@ -478,12 +577,19 @@ static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 	if (err)
 		return err;
 
+	err = idt82p33_measure_one_byte_read_overhead(channel,
+						      &one_byte_read_ns);
+
+	if (err)
+		return err;
+
 	err = idt82p33_measure_tod_write_9_byte_overhead(channel);
 
 	if (err)
 		return err;
 
-	trailing_overhead_ns = gap_ns - (2 * one_byte_write_ns);
+	trailing_overhead_ns = gap_ns - 2 * one_byte_write_ns
+			       - one_byte_read_ns;
 
 	idt82p33->tod_write_overhead_ns -= trailing_overhead_ns;
 
@@ -500,7 +606,7 @@ static int idt82p33_check_and_set_masks(struct idt82p33 *idt82p33,
 	if (page == PLLMASK_ADDR_HI && offset == PLLMASK_ADDR_LO) {
 		if ((val & 0xfc) || !(val & 0x3)) {
 			dev_err(&idt82p33->client->dev,
-				"Invalid PLL mask 0x%hhx\n", val);
+				"Invalid PLL mask 0x%02x\n", val);
 			err = -EINVAL;
 		} else {
 			idt82p33->pll_mask = val;
@@ -539,11 +645,6 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 	u8 sync_cnfg;
 	int err;
 
-	/* Turn it off after sync_tod_timeout seconds */
-	if (enable && sync_tod_timeout)
-		ptp_schedule_worker(channel->ptp_clock,
-				    sync_tod_timeout * HZ);
-
 	err = idt82p33_read(idt82p33, channel->dpll_sync_cnfg,
 			    &sync_cnfg, sizeof(sync_cnfg));
 	if (err)
@@ -557,22 +658,6 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 			      &sync_cnfg, sizeof(sync_cnfg));
 }
 
-static long idt82p33_sync_tod_work_handler(struct ptp_clock_info *ptp)
-{
-	struct idt82p33_channel *channel =
-			container_of(ptp, struct idt82p33_channel, caps);
-	struct idt82p33 *idt82p33 = channel->idt82p33;
-
-	mutex_lock(&idt82p33->reg_lock);
-
-	(void)idt82p33_sync_tod(channel, false);
-
-	mutex_unlock(&idt82p33->reg_lock);
-
-	/* Return a negative value here to not reschedule */
-	return -1;
-}
-
 static int idt82p33_output_enable(struct idt82p33_channel *channel,
 				  bool enable, unsigned int outn)
 {
@@ -634,13 +719,6 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	struct timespec64 ts = {0, 0};
 	int err;
-	u8 val;
-
-	val = 0;
-	err = idt82p33_write(idt82p33, channel->dpll_input_mode_cnfg,
-			     &val, sizeof(val));
-	if (err)
-		return err;
 
 	err = idt82p33_measure_tod_write_overhead(channel);
 
@@ -664,11 +742,12 @@ static void idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
 	u8 i;
 
 	for (i = 0; i < MAX_PHC_PLL; i++) {
-
 		channel = &idt82p33->channel[i];
 
-		if (channel->ptp_clock)
+		if (channel->ptp_clock) {
+			channel = &idt82p33->channel[i];
 			ptp_clock_unregister(channel->ptp_clock);
+		}
 	}
 }
 
@@ -753,10 +832,11 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_adjfine(channel, scaled_ppm);
+	mutex_unlock(&idt82p33->reg_lock);
+
 	if (err)
 		dev_err(&idt82p33->client->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
 }
@@ -775,21 +855,16 @@ static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns)
 		return 0;
 	}
 
-	err = _idt82p33_adjtime(channel, delta_ns);
+	/* Use more accurate internal 1pps triggered write first */
+	err = _idt82p33_adjtime_internal_triggered(channel, delta_ns);
+	if (err && delta_ns > IMMEDIATE_SNAP_THRESHOLD_NS)
+		err = _idt82p33_adjtime_immediate(channel, delta_ns);
 
-	if (err) {
-		mutex_unlock(&idt82p33->reg_lock);
-		dev_err(&idt82p33->client->dev,
-			"Adjtime failed in %s with err %d!\n", __func__, err);
-		return err;
-	}
+	mutex_unlock(&idt82p33->reg_lock);
 
-	err = idt82p33_sync_tod(channel, true);
 	if (err)
 		dev_err(&idt82p33->client->dev,
-			"Sync_tod failed in %s with err %d!\n", __func__, err);
-
-	mutex_unlock(&idt82p33->reg_lock);
+			"Adjtime failed in %s with err %d!\n", __func__, err);
 
 	return err;
 }
@@ -803,10 +878,11 @@ static int idt82p33_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_gettime(channel, ts);
+	mutex_unlock(&idt82p33->reg_lock);
+
 	if (err)
 		dev_err(&idt82p33->client->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
 }
@@ -821,11 +897,11 @@ static int idt82p33_settime(struct ptp_clock_info *ptp,
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_settime(channel, ts);
+	mutex_unlock(&idt82p33->reg_lock);
+
 	if (err)
 		dev_err(&idt82p33->client->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-	mutex_unlock(&idt82p33->reg_lock);
-
 	return err;
 }
 
@@ -872,7 +948,6 @@ static void idt82p33_caps_init(struct ptp_clock_info *caps)
 	caps->gettime64 = idt82p33_gettime;
 	caps->settime64 = idt82p33_settime;
 	caps->enable = idt82p33_enable;
-	caps->do_aux_work = idt82p33_sync_tod_work_handler;
 }
 
 static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
@@ -895,6 +970,8 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
 	channel->idt82p33 = idt82p33;
 
+	INIT_DELAYED_WORK(&channel->adjtime_work, idt82p33_adjtime_workaround);
+
 	idt82p33_caps_init(&channel->caps);
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT 82P33 PLL%u", index);
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 1c7a0f0..a8b0923 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -89,13 +89,13 @@ enum hw_tod_trig_sel {
 };
 
 /* Register bit definitions end */
-#define FW_FILENAME	"idt82p33xxx.bin"
-#define MAX_PHC_PLL (2)
-#define TOD_BYTE_COUNT (10)
-#define MAX_MEASURMENT_COUNT (5)
-#define SNAP_THRESHOLD_NS (150000)
-#define SYNC_TOD_TIMEOUT_SEC (5)
-#define IDT82P33_MAX_WRITE_COUNT (512)
+#define FW_FILENAME			"idt82p33xxx.bin"
+#define MAX_PHC_PLL			(2)
+#define TOD_BYTE_COUNT			(10)
+#define MAX_MEASURMENT_COUNT		(5)
+#define SNAP_THRESHOLD_NS		(10000)
+#define IMMEDIATE_SNAP_THRESHOLD_NS	(50000)
+#define IDT82P33_MAX_WRITE_COUNT	(512)
 
 #define PLLMASK_ADDR_HI	0xFF
 #define PLLMASK_ADDR_LO	0xA5
@@ -116,15 +116,19 @@ enum hw_tod_trig_sel {
 #define DEFAULT_OUTPUT_MASK_PLL0	(0xc0)
 #define DEFAULT_OUTPUT_MASK_PLL1	DEFAULT_OUTPUT_MASK_PLL0
 
+/* Bit definitions for DPLL_TOD_TRIGGER register */
+#define READ_TRIGGER_MASK	(0xF)
+#define READ_TRIGGER_SHIFT	(0x0)
+#define WRITE_TRIGGER_MASK	(0xF0)
+#define WRITE_TRIGGER_SHIFT	(0x4)
+
 /* PTP Hardware Clock interface */
 struct idt82p33_channel {
 	struct ptp_clock_info	caps;
 	struct ptp_clock	*ptp_clock;
-	struct idt82p33	*idt82p33;
-	enum pll_mode	pll_mode;
-	/* task to turn off SYNC_TOD bit after pps sync */
-	struct delayed_work	sync_tod_work;
-	bool			sync_tod_on;
+	struct idt82p33		*idt82p33;
+	enum pll_mode		pll_mode;
+	struct delayed_work	adjtime_work;
 	s32			current_freq_ppb;
 	u8			output_mask;
 	u16			dpll_tod_cnfg;
-- 
2.7.4

