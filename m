Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8795E409E3C
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 22:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244376AbhIMUiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 16:38:14 -0400
Received: from pbmsgap01.intersil.com ([192.157.179.201]:35442 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241451AbhIMUiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 16:38:14 -0400
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 18DK36rl026133;
        Mon, 13 Sep 2021 16:12:53 -0400
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap01.intersil.com with ESMTP id 3b0r038t56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 16:12:52 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2242.4; Mon, 13 Sep 2021 16:12:50 -0400
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Mon, 13 Sep 2021 16:12:50 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 3/3] ptp: ptp_clockmatrix: Add support for pll_mode=0 and manual ref switch of WF and WP
Date:   Mon, 13 Sep 2021 16:12:34 -0400
Message-ID: <1631563954-6700-3-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1631563954-6700-1-git-send-email-min.li.xe@renesas.com>
References: <1631563954-6700-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kydTk9lugv6oQV-M2awbOv81H4-eTj92
X-Proofpoint-GUID: kydTk9lugv6oQV-M2awbOv81H4-eTj92
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-13_09:2021-09-09,2021-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130120
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Also correct how initialize_dco_operating_mode is called

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/idt8a340_reg.h    |   4 +
 drivers/ptp/ptp_clockmatrix.c | 372 +++++++++++++++++++++++++++++++++++++-----
 drivers/ptp/ptp_clockmatrix.h |  47 +++++-
 3 files changed, 376 insertions(+), 47 deletions(-)

diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
index dea8e1d..1c52101 100644
--- a/drivers/ptp/idt8a340_reg.h
+++ b/drivers/ptp/idt8a340_reg.h
@@ -635,6 +635,10 @@
 #define STATE_MODE_SHIFT                  (0)
 #define STATE_MODE_MASK                   (0x7)
 
+/* Bit definitions for the DPLL_MANU_REF_CFG register */
+#define MANUAL_REFERENCE_SHIFT            (0)
+#define MANUAL_REFERENCE_MASK             (0x1f)
+
 /* Bit definitions for the GPIO_CFG_GBL register */
 #define SUPPLY_MODE_SHIFT                 (0)
 #define SUPPLY_MODE_MASK                  (0x3)
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 2c552a0..1a2e3c2 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -33,6 +33,8 @@ module_param(firmware, charp, 0);
 
 #define SETTIME_CORRECTION (0)
 
+static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm);
+
 static int contains_full_configuration(struct idtcm *idtcm,
 				       const struct firmware *fw)
 {
@@ -657,8 +659,8 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 }
 
 static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
-			       struct timespec64 const *ts,
-			       enum hw_tod_write_trig_sel wr_trig)
+				  struct timespec64 const *ts,
+				  enum hw_tod_write_trig_sel wr_trig)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	u8 buf[TOD_BYTE_COUNT];
@@ -920,9 +922,9 @@ static int idtcm_start_phase_pull_in(struct idtcm_channel *channel)
 	return err;
 }
 
-static int idtcm_do_phase_pull_in(struct idtcm_channel *channel,
-				  s32 offset_ns,
-				  u32 max_ffo_ppb)
+static int do_phase_pull_in_fw(struct idtcm_channel *channel,
+			       s32 offset_ns,
+			       u32 max_ffo_ppb)
 {
 	int err;
 
@@ -991,7 +993,7 @@ static int _idtcm_adjtime_deprecated(struct idtcm_channel *channel, s64 delta)
 	s64 now;
 
 	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS_DEPRECATED) {
-		err = idtcm_do_phase_pull_in(channel, delta, 0);
+		err = channel->do_phase_pull_in(channel, delta, 0);
 	} else {
 		idtcm->calculate_overhead_flag = 1;
 
@@ -1220,7 +1222,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 	if (firmware) /* module parameter */
 		snprintf(fname, sizeof(fname), "%s", firmware);
 
-	dev_dbg(&idtcm->client->dev, "requesting firmware '%s'", fname);
+	dev_info(&idtcm->client->dev, "firmware '%s'", fname);
 
 	err = request_firmware(&fw, fname, dev);
 	if (err) {
@@ -1354,7 +1356,7 @@ static int idtcm_perout_enable(struct idtcm_channel *channel,
 }
 
 static int idtcm_get_pll_mode(struct idtcm_channel *channel,
-			      enum pll_mode *pll_mode)
+			      enum pll_mode *mode)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
@@ -1366,13 +1368,13 @@ static int idtcm_get_pll_mode(struct idtcm_channel *channel,
 	if (err)
 		return err;
 
-	*pll_mode = (dpll_mode >> PLL_MODE_SHIFT) & PLL_MODE_MASK;
+	*mode = (dpll_mode >> PLL_MODE_SHIFT) & PLL_MODE_MASK;
 
 	return 0;
 }
 
 static int idtcm_set_pll_mode(struct idtcm_channel *channel,
-			      enum pll_mode pll_mode)
+			      enum pll_mode mode)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
@@ -1386,23 +1388,298 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 
 	dpll_mode &= ~(PLL_MODE_MASK << PLL_MODE_SHIFT);
 
-	dpll_mode |= (pll_mode << PLL_MODE_SHIFT);
-
-	channel->pll_mode = pll_mode;
+	dpll_mode |= (mode << PLL_MODE_SHIFT);
 
 	err = idtcm_write(idtcm, channel->dpll_n,
 			  IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_MODE),
 			  &dpll_mode, sizeof(dpll_mode));
+	return err;
+}
+
+static int idtcm_get_manual_reference(struct idtcm_channel *channel,
+				      enum manual_reference *ref)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	u8 dpll_manu_ref_cfg;
+	int err;
+
+	err = idtcm_read(idtcm, channel->dpll_ctrl_n,
+			 DPLL_CTRL_DPLL_MANU_REF_CFG,
+			 &dpll_manu_ref_cfg, sizeof(dpll_manu_ref_cfg));
+	if (err)
+		return err;
+
+	dpll_manu_ref_cfg &= (MANUAL_REFERENCE_MASK << MANUAL_REFERENCE_SHIFT);
+
+	*ref = dpll_manu_ref_cfg >> MANUAL_REFERENCE_SHIFT;
+
+	return 0;
+}
+
+static int idtcm_set_manual_reference(struct idtcm_channel *channel,
+				      enum manual_reference ref)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	u8 dpll_manu_ref_cfg;
+	int err;
+
+	err = idtcm_read(idtcm, channel->dpll_ctrl_n,
+			 DPLL_CTRL_DPLL_MANU_REF_CFG,
+			 &dpll_manu_ref_cfg, sizeof(dpll_manu_ref_cfg));
+	if (err)
+		return err;
+
+	dpll_manu_ref_cfg &= ~(MANUAL_REFERENCE_MASK << MANUAL_REFERENCE_SHIFT);
+
+	dpll_manu_ref_cfg |= (ref << MANUAL_REFERENCE_SHIFT);
+
+	err = idtcm_write(idtcm, channel->dpll_ctrl_n,
+			  DPLL_CTRL_DPLL_MANU_REF_CFG,
+			  &dpll_manu_ref_cfg, sizeof(dpll_manu_ref_cfg));
+
+	return err;
+}
+
+static int configure_dpll_mode_write_frequency(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_FREQUENCY);
+
+	if (err)
+		dev_err(&idtcm->client->dev, "Failed to set pll mode to write frequency");
+	else
+		channel->mode = PTP_PLL_MODE_WRITE_FREQUENCY;
+
+	return err;
+}
+
+static int configure_dpll_mode_write_phase(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_PHASE);
+
+	if (err)
+		dev_err(&idtcm->client->dev, "Failed to set pll mode to write phase");
+	else
+		channel->mode = PTP_PLL_MODE_WRITE_PHASE;
+
+	return err;
+}
+
+static int configure_manual_reference_write_frequency(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	err = idtcm_set_manual_reference(channel, MANU_REF_WRITE_FREQUENCY);
+
+	if (err)
+		dev_err(&idtcm->client->dev, "Failed to set manual reference to write frequency");
+	else
+		channel->mode = PTP_PLL_MODE_WRITE_FREQUENCY;
+
+	return err;
+}
+
+static int configure_manual_reference_write_phase(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	err = idtcm_set_manual_reference(channel, MANU_REF_WRITE_PHASE);
+
+	if (err)
+		dev_err(&idtcm->client->dev, "Failed to set manual reference to write phase");
+	else
+		channel->mode = PTP_PLL_MODE_WRITE_PHASE;
+
+	return err;
+}
+
+static int idtcm_stop_phase_pull_in(struct idtcm_channel *channel)
+{
+	int err;
+
+	err = _idtcm_adjfine(channel, channel->current_freq_scaled_ppm);
 	if (err)
 		return err;
 
+	channel->phase_pull_in = false;
+
 	return 0;
 }
 
+static long idtcm_work_handler(struct ptp_clock_info *ptp)
+{
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm *idtcm = channel->idtcm;
+
+	mutex_lock(&idtcm->reg_lock);
+
+	(void)idtcm_stop_phase_pull_in(channel);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	/* Return a negative value here to not reschedule */
+	return -1;
+}
+
+static s32 phase_pull_in_scaled_ppm(s32 current_ppm, s32 phase_pull_in_ppb)
+{
+	/* ppb = scaled_ppm * 125 / 2^13 */
+	/* scaled_ppm = ppb * 2^13 / 125 */
+
+	s64 max_scaled_ppm = (PHASE_PULL_IN_MAX_PPB << 13) / 125;
+	s64 scaled_ppm = (phase_pull_in_ppb << 13) / 125;
+
+	current_ppm += scaled_ppm;
+
+	if (current_ppm > max_scaled_ppm)
+		current_ppm = max_scaled_ppm;
+	else if (current_ppm < -max_scaled_ppm)
+		current_ppm = -max_scaled_ppm;
+
+	return current_ppm;
+}
+
+static int do_phase_pull_in_sw(struct idtcm_channel *channel,
+			       s32 delta_ns,
+			       u32 max_ffo_ppb)
+{
+	s32 current_ppm = channel->current_freq_scaled_ppm;
+	u32 duration_ms = MSEC_PER_SEC;
+	s32 delta_ppm;
+	s32 ppb;
+	int err;
+
+	/* If the ToD correction is less than PHASE_PULL_IN_MIN_THRESHOLD_NS,
+	 * skip. The error introduced by the ToD adjustment procedure would
+	 * be bigger than the required ToD correction
+	 */
+	if (abs(delta_ns) < PHASE_PULL_IN_MIN_THRESHOLD_NS)
+		return 0;
+
+	if (max_ffo_ppb == 0)
+		max_ffo_ppb = PHASE_PULL_IN_MAX_PPB;
+
+	/* For most cases, keep phase pull-in duration 1 second */
+	ppb = delta_ns;
+	while (abs(ppb) > max_ffo_ppb) {
+		duration_ms *= 2;
+		ppb /= 2;
+	}
+
+	delta_ppm = phase_pull_in_scaled_ppm(current_ppm, ppb);
+
+	err = _idtcm_adjfine(channel, delta_ppm);
+
+	if (err)
+		return err;
+
+	/* schedule the worker to cancel phase pull-in */
+	ptp_schedule_worker(channel->ptp_clock,
+			    msecs_to_jiffies(duration_ms) - 1);
+
+	channel->phase_pull_in = true;
+
+	return 0;
+}
+
+static int initialize_operating_mode_with_manual_reference(struct idtcm_channel *channel,
+							   enum manual_reference ref)
+{
+	struct idtcm *idtcm = channel->idtcm;
+
+	channel->mode = PTP_PLL_MODE_UNSUPPORTED;
+	channel->configure_write_frequency = configure_manual_reference_write_frequency;
+	channel->configure_write_phase = configure_manual_reference_write_phase;
+	channel->do_phase_pull_in = do_phase_pull_in_sw;
+
+	switch (ref) {
+	case MANU_REF_WRITE_PHASE:
+		channel->mode = PTP_PLL_MODE_WRITE_PHASE;
+		break;
+	case MANU_REF_WRITE_FREQUENCY:
+		channel->mode = PTP_PLL_MODE_WRITE_FREQUENCY;
+		break;
+	default:
+		dev_warn(&idtcm->client->dev,
+			 "Unsupported MANUAL_REFERENCE: 0x%02x", ref);
+	}
+
+	return 0;
+}
+
+static int initialize_operating_mode_with_pll_mode(struct idtcm_channel *channel,
+						   enum pll_mode mode)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	int err = 0;
+
+	channel->mode = PTP_PLL_MODE_UNSUPPORTED;
+	channel->configure_write_frequency = configure_dpll_mode_write_frequency;
+	channel->configure_write_phase = configure_dpll_mode_write_phase;
+	channel->do_phase_pull_in = do_phase_pull_in_fw;
+
+	switch (mode) {
+	case  PLL_MODE_WRITE_PHASE:
+		channel->mode = PTP_PLL_MODE_WRITE_PHASE;
+		break;
+	case PLL_MODE_WRITE_FREQUENCY:
+		channel->mode = PTP_PLL_MODE_WRITE_FREQUENCY;
+		break;
+	default:
+		dev_err(&idtcm->client->dev,
+			"Unsupported PLL_MODE: 0x%02x", mode);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static int initialize_dco_operating_mode(struct idtcm_channel *channel)
+{
+	enum manual_reference ref = MANU_REF_XO_DPLL;
+	enum pll_mode mode = PLL_MODE_DISABLED;
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	channel->mode = PTP_PLL_MODE_UNSUPPORTED;
+
+	err = idtcm_get_pll_mode(channel, &mode);
+	if (err) {
+		dev_err(&idtcm->client->dev, "Unable to read pll mode!");
+		return err;
+	}
+
+	if (mode == PLL_MODE_PLL) {
+		err = idtcm_get_manual_reference(channel, &ref);
+		if (err) {
+			dev_err(&idtcm->client->dev, "Unable to read manual reference!");
+			return err;
+		}
+		err = initialize_operating_mode_with_manual_reference(channel, ref);
+	} else {
+		err = initialize_operating_mode_with_pll_mode(channel, mode);
+	}
+
+	if (channel->mode == PTP_PLL_MODE_WRITE_PHASE)
+		channel->configure_write_frequency(channel);
+
+	return err;
+}
+
 /* PTP Hardware Clock interface */
 
 /**
- * @brief Maximum absolute value for write phase offset in picoseconds
+ * Maximum absolute value for write phase offset in picoseconds
+ *
+ * @channel:  channel
+ * @delta_ns: delta in nanoseconds
  *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
@@ -1417,8 +1694,8 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 	s32 phase_50ps;
 	s64 offset_ps;
 
-	if (channel->pll_mode != PLL_MODE_WRITE_PHASE) {
-		err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_PHASE);
+	if (channel->mode != PTP_PLL_MODE_WRITE_PHASE) {
+		err = channel->configure_write_phase(channel);
 		if (err)
 			return err;
 	}
@@ -1456,8 +1733,8 @@ static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
 	u8 buf[6] = {0};
 	s64 fcw;
 
-	if (channel->pll_mode  != PLL_MODE_WRITE_FREQUENCY) {
-		err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_FREQUENCY);
+	if (channel->mode  != PTP_PLL_MODE_WRITE_FREQUENCY) {
+		err = channel->configure_write_frequency(channel);
 		if (err)
 			return err;
 	}
@@ -1574,29 +1851,29 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	enum scsr_tod_write_type_sel type;
 	int err;
 
+	if (channel->phase_pull_in == true)
+		return 0;
+
+	mutex_lock(&idtcm->reg_lock);
+
 	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS) {
-		err = idtcm_do_phase_pull_in(channel, delta, 0);
+		err = channel->do_phase_pull_in(channel, delta, 0);
 		if (err)
 			dev_err(&idtcm->client->dev,
 				"Failed at line %d in %s!", __LINE__, __func__);
-		return err;
-	}
-
-	if (delta >= 0) {
-		ts = ns_to_timespec64(delta);
-		type = SCSR_TOD_WR_TYPE_SEL_DELTA_PLUS;
 	} else {
-		ts = ns_to_timespec64(-delta);
-		type = SCSR_TOD_WR_TYPE_SEL_DELTA_MINUS;
+		if (delta >= 0) {
+			ts = ns_to_timespec64(delta);
+			type = SCSR_TOD_WR_TYPE_SEL_DELTA_PLUS;
+		} else {
+			ts = ns_to_timespec64(-delta);
+			type = SCSR_TOD_WR_TYPE_SEL_DELTA_MINUS;
+		}
+		err = _idtcm_settime(channel, &ts, type);
+		if (err)
+			dev_err(&idtcm->client->dev,
+				"Failed at line %d in %s!", __LINE__, __func__);
 	}
-
-	mutex_lock(&idtcm->reg_lock);
-
-	err = _idtcm_settime(channel, &ts, type);
-	if (err)
-		dev_err(&idtcm->client->dev,
-			"Failed at line %d in %s!", __LINE__, __func__);
-
 	mutex_unlock(&idtcm->reg_lock);
 
 	return err;
@@ -1626,15 +1903,21 @@ static int idtcm_adjfine(struct ptp_clock_info *ptp,  long scaled_ppm)
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
 
+	if (channel->phase_pull_in == true)
+		return 0;
+
+	if (scaled_ppm == channel->current_freq_scaled_ppm)
+		return 0;
+
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_adjfine(channel, scaled_ppm);
-	if (err)
-		dev_err(&idtcm->client->dev,
-			"Failed at line %d in %s!", __LINE__, __func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
+	if (!err)
+		channel->current_freq_scaled_ppm = scaled_ppm;
+
 	return err;
 }
 
@@ -1746,6 +2029,7 @@ static const struct ptp_clock_info idtcm_caps = {
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime,
 	.enable		= &idtcm_enable,
+	.do_aux_work	= &idtcm_work_handler,
 };
 
 static const struct ptp_clock_info idtcm_caps_deprecated = {
@@ -1758,6 +2042,7 @@ static const struct ptp_clock_info idtcm_caps_deprecated = {
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime_deprecated,
 	.enable		= &idtcm_enable,
+	.do_aux_work	= &idtcm_work_handler,
 };
 
 static int configure_channel_pll(struct idtcm_channel *channel)
@@ -1847,7 +2132,9 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 		return -EINVAL;
 
 	channel = &idtcm->channel[index];
+
 	channel->idtcm = idtcm;
+	channel->current_freq_scaled_ppm = 0;
 
 	/* Set pll addresses */
 	err = configure_channel_pll(channel);
@@ -1892,13 +2179,9 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT CM TOD%u", index);
 
-	/* Sync pll mode with hardware */
-	err = idtcm_get_pll_mode(channel, &channel->pll_mode);
-	if (err) {
-		dev_err(&idtcm->client->dev,
-			"Error: %s - Unable to read pll mode", __func__);
+	err = initialize_dco_operating_mode(channel);
+	if (err)
 		return err;
-	}
 
 	err = idtcm_enable_tod(channel);
 	if (err) {
@@ -1931,7 +2214,6 @@ static void ptp_clock_unregister_all(struct idtcm *idtcm)
 
 	for (i = 0; i < MAX_TOD; i++) {
 		channel = &idtcm->channel[i];
-
 		if (channel->ptp_clock)
 			ptp_clock_unregister(channel->ptp_clock);
 	}
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 843a9d7..833e590 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -57,15 +57,27 @@
 
 #define IDTCM_MAX_WRITE_COUNT		(512)
 
+#define PHASE_PULL_IN_MAX_PPB		(144000)
+#define PHASE_PULL_IN_MIN_THRESHOLD_NS	(2)
+
 /*
  * Return register address based on passed in firmware version
  */
 #define IDTCM_FW_REG(FW, VER, REG)	(((FW) < (VER)) ? (REG) : (REG##_##VER))
 
+/* PTP PLL Mode */
+enum ptp_pll_mode {
+	PTP_PLL_MODE_MIN = 0,
+	PTP_PLL_MODE_WRITE_FREQUENCY = PTP_PLL_MODE_MIN,
+	PTP_PLL_MODE_WRITE_PHASE,
+	PTP_PLL_MODE_UNSUPPORTED,
+	PTP_PLL_MODE_MAX = PTP_PLL_MODE_UNSUPPORTED,
+};
+
 /* Values of DPLL_N.DPLL_MODE.PLL_MODE */
 enum pll_mode {
 	PLL_MODE_MIN = 0,
-	PLL_MODE_NORMAL = PLL_MODE_MIN,
+	PLL_MODE_PLL = PLL_MODE_MIN,
 	PLL_MODE_WRITE_PHASE = 1,
 	PLL_MODE_WRITE_FREQUENCY = 2,
 	PLL_MODE_GPIO_INC_DEC = 3,
@@ -75,6 +87,31 @@ enum pll_mode {
 	PLL_MODE_MAX = PLL_MODE_DISABLED,
 };
 
+/* Values of DPLL_CTRL_n.DPLL_MANU_REF_CFG.MANUAL_REFERENCE */
+enum manual_reference {
+	MANU_REF_MIN = 0,
+	MANU_REF_CLK0 = MANU_REF_MIN,
+	MANU_REF_CLK1,
+	MANU_REF_CLK2,
+	MANU_REF_CLK3,
+	MANU_REF_CLK4,
+	MANU_REF_CLK5,
+	MANU_REF_CLK6,
+	MANU_REF_CLK7,
+	MANU_REF_CLK8,
+	MANU_REF_CLK9,
+	MANU_REF_CLK10,
+	MANU_REF_CLK11,
+	MANU_REF_CLK12,
+	MANU_REF_CLK13,
+	MANU_REF_CLK14,
+	MANU_REF_CLK15,
+	MANU_REF_WRITE_PHASE,
+	MANU_REF_WRITE_FREQUENCY,
+	MANU_REF_XO_DPLL,
+	MANU_REF_MAX = MANU_REF_XO_DPLL,
+};
+
 enum hw_tod_write_trig_sel {
 	HW_TOD_WR_TRIG_SEL_MIN = 0,
 	HW_TOD_WR_TRIG_SEL_MSB = HW_TOD_WR_TRIG_SEL_MIN,
@@ -141,7 +178,13 @@ struct idtcm_channel {
 	u16			tod_n;
 	u16			hw_dpll_n;
 	u8			sync_src;
-	enum pll_mode		pll_mode;
+	enum ptp_pll_mode	mode;
+	int			(*configure_write_frequency)(struct idtcm_channel *channel);
+	int			(*configure_write_phase)(struct idtcm_channel *channel);
+	int			(*do_phase_pull_in)(struct idtcm_channel *channel,
+						    s32 offset_ns, u32 max_ffo_ppb);
+	s32			current_freq_scaled_ppm;
+	bool			phase_pull_in;
 	u8			pll;
 	u16			output_mask;
 };
-- 
2.7.4

