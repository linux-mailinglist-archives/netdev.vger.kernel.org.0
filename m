Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D262A73C5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgKEAaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:30:10 -0500
Received: from pbmsgap01.intersil.com ([192.157.179.201]:57792 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732071AbgKEA3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:29:50 -0500
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0A50MdEW026637;
        Wed, 4 Nov 2020 19:22:39 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 34h3f1a9md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 19:22:39 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 4 Nov 2020 19:22:38 -0500
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 4 Nov 2020 19:22:37 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v3 net-next 1/3] ptp: idt82p33: add adjphase support
Date:   Wed, 4 Nov 2020 19:22:13 -0500
Message-ID: <1604535735-19180-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_17:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=4 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050000
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Add idt82p33_adjphase() to support PHC write phase mode.

Changes since v1:
-Fix broken build

Changes since v2:
-Fix trailing space

Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_idt82p33.c | 222 ++++++++++++++++++++++++++++++++-------------
 drivers/ptp/ptp_idt82p33.h |   2 +
 2 files changed, 162 insertions(+), 62 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index 179f6c4..d52fa67 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -21,6 +21,7 @@ MODULE_DESCRIPTION("Driver for IDT 82p33xxx clock devices");
 MODULE_AUTHOR("IDT support-1588 <IDT-support-1588@lm.renesas.com>");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(FW_FILENAME);
 
 /* Module Parameters */
 static u32 sync_tod_timeout = SYNC_TOD_TIMEOUT_SEC;
@@ -129,8 +130,9 @@ static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
 static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
 			 unsigned char *buf, unsigned int count, bool write)
 {
-	u8 offset, page;
 	int err;
+	u8 page;
+	u8 offset;
 
 	page = _PAGE(regaddr);
 	offset = _OFFSET(regaddr);
@@ -145,13 +147,13 @@ static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
 }
 
 static int idt82p33_read(struct idt82p33 *idt82p33, unsigned int regaddr,
-			unsigned char *buf, unsigned int count)
+			 unsigned char *buf, unsigned int count)
 {
 	return idt82p33_rdwr(idt82p33, regaddr, buf, count, false);
 }
 
 static int idt82p33_write(struct idt82p33 *idt82p33, unsigned int regaddr,
-			unsigned char *buf, unsigned int count)
+			  unsigned char *buf, unsigned int count)
 {
 	return idt82p33_rdwr(idt82p33, regaddr, buf, count, true);
 }
@@ -448,8 +450,11 @@ static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 
 	err = idt82p33_measure_settime_gettime_gap_overhead(channel, &gap_ns);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 		return err;
+	}
 
 	err = idt82p33_measure_one_byte_write_overhead(channel,
 						       &one_byte_write_ns);
@@ -518,13 +523,10 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 	u8 sync_cnfg;
 	int err;
 
-	if (enable == channel->sync_tod_on) {
-		if (enable && sync_tod_timeout) {
-			mod_delayed_work(system_wq, &channel->sync_tod_work,
-					 sync_tod_timeout * HZ);
-		}
-		return 0;
-	}
+	/* Turn it off after sync_tod_timeout seconds */
+	if (enable && sync_tod_timeout)
+		ptp_schedule_worker(channel->ptp_clock,
+				    sync_tod_timeout * HZ);
 
 	err = idt82p33_read(idt82p33, channel->dpll_sync_cnfg,
 			    &sync_cnfg, sizeof(sync_cnfg));
@@ -541,20 +543,13 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 	if (err)
 		return err;
 
-	channel->sync_tod_on = enable;
-
-	if (enable && sync_tod_timeout) {
-		mod_delayed_work(system_wq, &channel->sync_tod_work,
-				 sync_tod_timeout * HZ);
-	}
-
 	return 0;
 }
 
-static void idt82p33_sync_tod_work_handler(struct work_struct *work)
+static long idt82p33_sync_tod_work_handler(struct ptp_clock_info *ptp)
 {
 	struct idt82p33_channel *channel =
-		container_of(work, struct idt82p33_channel, sync_tod_work.work);
+			container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 
 	mutex_lock(&idt82p33->reg_lock);
@@ -562,35 +557,51 @@ static void idt82p33_sync_tod_work_handler(struct work_struct *work)
 	(void)idt82p33_sync_tod(channel, false);
 
 	mutex_unlock(&idt82p33->reg_lock);
+
+	/* Return a negative value here to not reschedule */
+	return -1;
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
@@ -598,6 +609,20 @@ static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
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
@@ -611,15 +636,13 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	if (err)
 		return err;
 
-	err = idt82p33_pps_enable(channel, false);
-
-	if (err)
-		return err;
-
 	err = idt82p33_measure_tod_write_overhead(channel);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 		return err;
+	}
 
 	err = _idt82p33_settime(channel, &ts);
 
@@ -638,10 +661,8 @@ static void idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
 
 		channel = &idt82p33->channel[i];
 
-		if (channel->ptp_clock) {
+		if (channel->ptp_clock)
 			ptp_clock_unregister(channel->ptp_clock);
-			cancel_delayed_work_sync(&channel->sync_tod_work);
-		}
 	}
 }
 
@@ -659,14 +680,16 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 
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
@@ -674,6 +697,49 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
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
+	offsetRegVal = div_s64(offsetInFs * 1000, IDT_T0DPLL_PHASE_RESOL);
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
+			"Failed in %s with err %d!\n", __func__, err);
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
@@ -683,6 +749,9 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_adjfine(channel, scaled_ppm);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -706,10 +775,15 @@ static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns)
 
 	if (err) {
 		mutex_unlock(&idt82p33->reg_lock);
+		dev_err(&idt82p33->client->dev,
+			"Adjtime failed in %s with err %d!\n", __func__, err);
 		return err;
 	}
 
 	err = idt82p33_sync_tod(channel, true);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Sync_tod failed in %s with err %d!\n", __func__, err);
 
 	mutex_unlock(&idt82p33->reg_lock);
 
@@ -725,6 +799,9 @@ static int idt82p33_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_gettime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -740,6 +817,9 @@ static int idt82p33_settime(struct ptp_clock_info *ptp,
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_settime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -772,9 +852,6 @@ static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
 		return -EINVAL;
 	}
 
-	INIT_DELAYED_WORK(&channel->sync_tod_work,
-			  idt82p33_sync_tod_work_handler);
-	channel->sync_tod_on = false;
 	channel->current_freq_ppb = 0;
 
 	return 0;
@@ -784,11 +861,14 @@ static void idt82p33_caps_init(struct ptp_clock_info *caps)
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
@@ -802,23 +882,18 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 	channel = &idt82p33->channel[index];
 
 	err = idt82p33_channel_init(channel, index);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Channel_init failed in %s with err %d!\n",
+			__func__, err);
 		return err;
+	}
 
 	channel->idt82p33 = idt82p33;
 
 	idt82p33_caps_init(&channel->caps);
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT 82P33 PLL%u", index);
-	channel->caps.n_per_out = hweight8(channel->output_mask);
-
-	err = idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
-	if (err)
-		return err;
-
-	err = idt82p33_enable_tod(channel);
-	if (err)
-		return err;
 
 	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
 
@@ -831,6 +906,22 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 	if (!channel->ptp_clock)
 		return -ENOTSUPP;
 
+	err = idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Dpll_set_mode failed in %s with err %d!\n",
+			__func__, err);
+		return err;
+	}
+
+	err = idt82p33_enable_tod(channel);
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Enable_tod failed in %s with err %d!\n",
+			__func__, err);
+		return err;
+	}
+
 	dev_info(&idt82p33->client->dev, "PLL%d registered as ptp%d\n",
 		 index, channel->ptp_clock->index);
 
@@ -839,19 +930,22 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
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
+	dev_dbg(&idt82p33->client->dev, "requesting firmware '%s'\n", fname);
 
-	err = request_firmware(&fw, FW_FILENAME, &idt82p33->client->dev);
+	err = request_firmware(&fw, fname, &idt82p33->client->dev);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 		return err;
+	}
 
 	dev_dbg(&idt82p33->client->dev, "firmware size %zu bytes\n", fw->size);
 
@@ -935,8 +1029,12 @@ static int idt82p33_probe(struct i2c_client *client,
 		for (i = 0; i < MAX_PHC_PLL; i++) {
 			if (idt82p33->pll_mask & (1 << i)) {
 				err = idt82p33_enable_channel(idt82p33, i);
-				if (err)
+				if (err) {
+					dev_err(&idt82p33->client->dev,
+						"Failed in %s with err %d!\n",
+						__func__, err);
 					break;
+				}
 			}
 		}
 	} else {
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 9d46966..3a0e001 100644
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
-- 
2.7.4

