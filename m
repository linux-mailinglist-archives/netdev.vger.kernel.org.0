Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C4423BFFB
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgHDTbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:31:40 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:42844 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHDTbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:31:39 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2020 15:31:38 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 074JCRaZ005063;
        Tue, 4 Aug 2020 15:12:36 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 32n2jcsbjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 04 Aug 2020 15:12:36 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 4 Aug 2020 15:12:34 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 4 Aug 2020 15:12:34 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net] ptp: ptp_idt82p33: update to support adjphase
Date:   Tue, 4 Aug 2020 15:12:14 -0400
Message-ID: <1596568334-17070-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-04_04:2020-08-03,2020-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2008040136
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

This update includes adjphase support, more debug logs, firmware name
parameter, correct PTP_CLK_REQ_PEROUT support and use do_aux_work to
do delay work.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 233 +++++++++++++++++++++++++++++++++++++--------
 drivers/ptp/ptp_idt82p33.h |   4 +-
 2 files changed, 193 insertions(+), 44 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index 179f6c4..b5bf2f0 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -33,6 +33,9 @@ module_param(phase_snap_threshold, uint, 0);
 MODULE_PARM_DESC(phase_snap_threshold,
 "threshold (150000ns by default) below which adjtime would ignore");
 
+static char *firmware;
+module_param(firmware, charp, 0);
+
 static void idt82p33_byte_array_to_timespec(struct timespec64 *ts,
 					    u8 buf[TOD_BYTE_COUNT])
 {
@@ -86,6 +89,7 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
 	struct i2c_client *client = idt82p33->client;
 	struct i2c_msg msg[2];
 	int cnt;
+	char *fmt = "i2c_transfer failed at %d in %s for %s, at addr: %04X!\n";
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
@@ -99,7 +103,12 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
 
 	cnt = i2c_transfer(client->adapter, msg, 2);
 	if (cnt < 0) {
-		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
+		dev_err(&client->dev,
+			fmt,
+			__LINE__,
+			__func__,
+			write ? "write" : "read",
+			(u8) regaddr);
 		return cnt;
 	} else if (cnt != 2) {
 		dev_err(&client->dev,
@@ -448,8 +457,13 @@ static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 
 	err = idt82p33_measure_settime_gettime_gap_overhead(channel, &gap_ns);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = idt82p33_measure_one_byte_write_overhead(channel,
 						       &one_byte_write_ns);
@@ -520,8 +534,8 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 
 	if (enable == channel->sync_tod_on) {
 		if (enable && sync_tod_timeout) {
-			mod_delayed_work(system_wq, &channel->sync_tod_work,
-					 sync_tod_timeout * HZ);
+			ptp_schedule_worker(channel->ptp_clock,
+					    sync_tod_timeout * HZ);
 		}
 		return 0;
 	}
@@ -544,53 +558,69 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 	channel->sync_tod_on = enable;
 
 	if (enable && sync_tod_timeout) {
-		mod_delayed_work(system_wq, &channel->sync_tod_work,
-				 sync_tod_timeout * HZ);
+		ptp_schedule_worker(channel->ptp_clock,
+				    sync_tod_timeout * HZ);
 	}
 
 	return 0;
 }
 
-static void idt82p33_sync_tod_work_handler(struct work_struct *work)
+static long idt82p33_sync_tod_work_handler(struct ptp_clock_info *ptp)
 {
 	struct idt82p33_channel *channel =
-		container_of(work, struct idt82p33_channel, sync_tod_work.work);
+			container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
+	int ret;
 
 	mutex_lock(&idt82p33->reg_lock);
 
-	(void)idt82p33_sync_tod(channel, false);
+	ret = idt82p33_sync_tod(channel, false);
 
 	mutex_unlock(&idt82p33->reg_lock);
+
+	return ret;
 }
 
-static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
+static int idt82p33_output_enable(struct idt82p33_channel *channel,
+				  bool enable, unsigned int outn)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
-	u8 mask, outn, val;
 	int err;
+	u8 val;
+
+	err = idt82p33_read(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
+
+	if (err)
+		return err;
+
+	if (enable)
+		val &= ~SQUELCH_ENABLE;
+	else
+		val |= SQUELCH_ENABLE;
+
+	return idt82p33_write(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
+}
+
+static int idt82p33_output_mask_enable(struct idt82p33_channel *channel,
+				       bool enable)
+{
+	u16 mask;
+	int err;
+	u8 outn;
 
 	mask = channel->output_mask;
 	outn = 0;
 
 	while (mask) {
-		if (mask & 0x1) {
-			err = idt82p33_read(idt82p33, OUT_MUX_CNFG(outn),
-					    &val, sizeof(val));
-			if (err)
-				return err;
 
-			if (enable)
-				val &= ~SQUELCH_ENABLE;
-			else
-				val |= SQUELCH_ENABLE;
+		if (mask & 0x1) {
 
-			err = idt82p33_write(idt82p33, OUT_MUX_CNFG(outn),
-					     &val, sizeof(val));
+			err = idt82p33_output_enable(channel, enable, outn);
 
 			if (err)
 				return err;
 		}
+
 		mask >>= 0x1;
 		outn++;
 	}
@@ -598,6 +628,20 @@ static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
 	return 0;
 }
 
+static int idt82p33_perout_enable(struct idt82p33_channel *channel,
+				  bool enable,
+				  struct ptp_perout_request *perout)
+{
+	unsigned int flags = perout->flags;
+
+	/* Enable/disable output based on output_mask */
+	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
+		return idt82p33_output_mask_enable(channel, enable);
+
+	/* Enable/disable individual output instead */
+	return idt82p33_output_enable(channel, enable, perout->index);
+}
+
 static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
@@ -611,15 +655,23 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	if (err)
 		return err;
 
-	err = idt82p33_pps_enable(channel, false);
-
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = idt82p33_measure_tod_write_overhead(channel);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = _idt82p33_settime(channel, &ts);
 
@@ -638,10 +690,8 @@ static void idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
 
 		channel = &idt82p33->channel[i];
 
-		if (channel->ptp_clock) {
+		if (channel->ptp_clock)
 			ptp_clock_unregister(channel->ptp_clock);
-			cancel_delayed_work_sync(&channel->sync_tod_work);
-		}
 	}
 }
 
@@ -659,14 +709,16 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 
 	if (rq->type == PTP_CLK_REQ_PEROUT) {
 		if (!on)
-			err = idt82p33_pps_enable(channel, false);
+			err = idt82p33_perout_enable(channel, false,
+						     &rq->perout);
 
 		/* Only accept a 1-PPS aligned to the second. */
 		else if (rq->perout.start.nsec || rq->perout.period.sec != 1 ||
 		    rq->perout.period.nsec) {
 			err = -ERANGE;
 		} else
-			err = idt82p33_pps_enable(channel, true);
+			err = idt82p33_perout_enable(channel, true,
+						     &rq->perout);
 	}
 
 	mutex_unlock(&idt82p33->reg_lock);
@@ -674,6 +726,51 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 	return err;
 }
 
+static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offsetNs)
+{
+	struct idt82p33_channel *channel =
+		container_of(ptp, struct idt82p33_channel, caps);
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	s64 offsetInFs;
+	s64 offsetRegVal;
+	u8 val[4] = {0};
+	int err;
+
+	offsetInFs = (s64)(-offsetNs) * 1000000;
+
+	if (offsetInFs > WRITE_PHASE_OFFSET_LIMIT)
+		offsetInFs = WRITE_PHASE_OFFSET_LIMIT;
+	else if (offsetInFs < -WRITE_PHASE_OFFSET_LIMIT)
+		offsetInFs = -WRITE_PHASE_OFFSET_LIMIT;
+
+	/* Convert from phaseOffsetInFs to register value */
+	offsetRegVal = ((offsetInFs * 1000) / IDT_T0DPLL_PHASE_RESOL);
+
+	val[0] = offsetRegVal & 0xFF;
+	val[1] = (offsetRegVal >> 8) & 0xFF;
+	val[2] = (offsetRegVal >> 16) & 0xFF;
+	val[3] = (offsetRegVal >> 24) & 0x1F;
+	val[3] |= PH_OFFSET_EN;
+
+	mutex_lock(&idt82p33->reg_lock);
+
+	err = idt82p33_dpll_set_mode(channel, PLL_MODE_WPH);
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+		goto out;
+	}
+
+	err = idt82p33_write(idt82p33, channel->dpll_phase_cnfg, val,
+			     sizeof(val));
+
+out:
+	mutex_unlock(&idt82p33->reg_lock);
+	return err;
+}
+
 static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct idt82p33_channel *channel =
@@ -683,6 +780,11 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_adjfine(channel, scaled_ppm);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -706,10 +808,19 @@ static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns)
 
 	if (err) {
 		mutex_unlock(&idt82p33->reg_lock);
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
 	}
 
 	err = idt82p33_sync_tod(channel, true);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 
 	mutex_unlock(&idt82p33->reg_lock);
 
@@ -725,6 +836,11 @@ static int idt82p33_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_gettime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -740,6 +856,11 @@ static int idt82p33_settime(struct ptp_clock_info *ptp,
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_settime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -772,8 +893,6 @@ static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
 		return -EINVAL;
 	}
 
-	INIT_DELAYED_WORK(&channel->sync_tod_work,
-			  idt82p33_sync_tod_work_handler);
 	channel->sync_tod_on = false;
 	channel->current_freq_ppb = 0;
 
@@ -784,11 +903,14 @@ static void idt82p33_caps_init(struct ptp_clock_info *caps)
 {
 	caps->owner = THIS_MODULE;
 	caps->max_adj = 92000;
+	caps->n_per_out = 11;
+	caps->adjphase = idt82p33_adjwritephase;
 	caps->adjfine = idt82p33_adjfine;
 	caps->adjtime = idt82p33_adjtime;
 	caps->gettime64 = idt82p33_gettime;
 	caps->settime64 = idt82p33_settime;
 	caps->enable = idt82p33_enable;
+	caps->do_aux_work = idt82p33_sync_tod_work_handler;
 }
 
 static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
@@ -802,23 +924,37 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 	channel = &idt82p33->channel[index];
 
 	err = idt82p33_channel_init(channel, index);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	channel->idt82p33 = idt82p33;
 
 	idt82p33_caps_init(&channel->caps);
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT 82P33 PLL%u", index);
-	channel->caps.n_per_out = hweight8(channel->output_mask);
 
 	err = idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = idt82p33_enable_tod(channel);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
 
@@ -839,19 +975,27 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
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
 
-	err = request_firmware(&fw, FW_FILENAME, &idt82p33->client->dev);
+	dev_dbg(&idt82p33->client->dev, "requesting firmware '%s'\n", fname);
 
-	if (err)
+	err = request_firmware(&fw, fname, &idt82p33->client->dev);
+
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	dev_dbg(&idt82p33->client->dev, "firmware size %zu bytes\n", fw->size);
 
@@ -935,8 +1079,13 @@ static int idt82p33_probe(struct i2c_client *client,
 		for (i = 0; i < MAX_PHC_PLL; i++) {
 			if (idt82p33->pll_mask & (1 << i)) {
 				err = idt82p33_enable_channel(idt82p33, i);
-				if (err)
+				if (err) {
+					dev_err(&idt82p33->client->dev,
+						"Failed at %d in func %s!\n",
+						__LINE__,
+						__func__);
 					break;
+				}
 			}
 		}
 	} else {
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 9d46966..5008998 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -56,6 +56,8 @@
 #define PLL_MODE_SHIFT                    (0)
 #define PLL_MODE_MASK                     (0x1F)
 
+#define PEROUT_ENABLE_OUTPUT_MASK         (0xdeadbeef)
+
 enum pll_mode {
 	PLL_MODE_MIN = 0,
 	PLL_MODE_AUTOMATIC = PLL_MODE_MIN,
@@ -119,8 +121,6 @@ struct idt82p33_channel {
 	struct ptp_clock	*ptp_clock;
 	struct idt82p33	*idt82p33;
 	enum pll_mode	pll_mode;
-	/* task to turn off SYNC_TOD bit after pps sync */
-	struct delayed_work	sync_tod_work;
 	bool			sync_tod_on;
 	s32			current_freq_ppb;
 	u8			output_mask;
-- 
2.7.4

