Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA12B511B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 20:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgKPT2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 14:28:05 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:35826 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbgKPT2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 14:28:04 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0AGJNLIH010641;
        Mon, 16 Nov 2020 14:28:01 -0500
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap02.intersil.com with ESMTP id 34ta9m0y5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 14:28:01 -0500
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Mon, 16 Nov 2020 14:27:59 -0500
Received: from localhost (132.158.202.109) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 16 Nov 2020 14:27:59 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net-next 4/5] ptp: clockmatrix: Fix non-zero phase_adj is lost after snap
Date:   Mon, 16 Nov 2020 14:27:29 -0500
Message-ID: <1605554850-14437-4-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605554850-14437-1-git-send-email-min.li.xe@renesas.com>
References: <1605554850-14437-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=4 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160114
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Fix non-zero phase_adj is lost after snap. Use ktime_sub
to do ktime_t subtraction.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 210 +++++++++++++++++++++++++++++++++++++-----
 drivers/ptp/ptp_clockmatrix.h |   5 +-
 2 files changed, 190 insertions(+), 25 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 9af6335..9b3ba92 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -716,8 +716,9 @@ static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 
 		if (idtcm->calculate_overhead_flag) {
 			/* Assumption: I2C @ 400KHz */
-			total_overhead_ns =  ktime_to_ns(ktime_get_raw()
-							 - idtcm->start_time)
+			ktime_t diff = ktime_sub(ktime_get_raw(),
+						 idtcm->start_time);
+			total_overhead_ns =  ktime_to_ns(diff)
 					     + idtcm->tod_write_overhead_ns
 					     + SETTIME_CORRECTION;
 
@@ -800,12 +801,154 @@ static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
 	return 0;
 }
 
+static int get_output_base_addr(u8 outn)
+{
+	int base;
+
+	switch (outn) {
+	case 0:
+		base = OUTPUT_0;
+		break;
+	case 1:
+		base = OUTPUT_1;
+		break;
+	case 2:
+		base = OUTPUT_2;
+		break;
+	case 3:
+		base = OUTPUT_3;
+		break;
+	case 4:
+		base = OUTPUT_4;
+		break;
+	case 5:
+		base = OUTPUT_5;
+		break;
+	case 6:
+		base = OUTPUT_6;
+		break;
+	case 7:
+		base = OUTPUT_7;
+		break;
+	case 8:
+		base = OUTPUT_8;
+		break;
+	case 9:
+		base = OUTPUT_9;
+		break;
+	case 10:
+		base = OUTPUT_10;
+		break;
+	case 11:
+		base = OUTPUT_11;
+		break;
+	default:
+		base = -EINVAL;
+	}
+
+	return base;
+}
+
+static void save_and_clear_output_phase_adj(struct idtcm_channel *channel)
+{
+	u16 output_mask = channel->output_mask;
+	struct idtcm *idtcm = channel->idtcm;
+	int delay_needed = 0;
+	u8 zero[4] = {0};
+	u8 outn = 0;
+	int base;
+
+	while (output_mask) {
+
+		if (output_mask & 1) {
+
+			base = get_output_base_addr(outn);
+
+			if (!(base > 0)) {
+				dev_err(&idtcm->client->dev,
+					"%s - Unsupported out%d",
+					__func__, outn);
+				return;
+			}
+
+			/* Save output_phase_adj for outn */
+			idtcm_read(idtcm, (u16)base, OUT_PHASE_ADJ,
+				   &channel->output_phase_adj[outn][0],
+				   sizeof(channel->output_phase_adj[outn]));
+
+			if (channel->output_phase_adj[outn][0] |
+			    channel->output_phase_adj[outn][1] |
+			    channel->output_phase_adj[outn][2] |
+			    channel->output_phase_adj[outn][3]) {
+				delay_needed = 1;
+
+				idtcm_write(idtcm, base, OUT_PHASE_ADJ,
+					    &zero[0], sizeof(zero));
+			}
+		}
+
+		output_mask = output_mask >> 1;
+		outn += 1;
+	}
+
+	/* Ensure output phase adjust has settled */
+	if (delay_needed)
+		msleep(5000);
+}
+
+
+static void restore_output_phase_adj(struct idtcm_channel *channel)
+{
+	u16 output_mask = channel->output_mask;
+	struct idtcm *idtcm = channel->idtcm;
+	u8 wait_once = 0;
+	u8 outn = 0;
+	int base;
+
+	while (output_mask) {
+
+		if ((output_mask & 1) &&
+		    (channel->output_phase_adj[outn][0] |
+		     channel->output_phase_adj[outn][1] |
+		     channel->output_phase_adj[outn][2] |
+		     channel->output_phase_adj[outn][3])) {
+
+			if (!wait_once) {
+				/* Ensure idtcm_sync_pps_output() is done */
+				msleep(5000);
+				wait_once = 1;
+			}
+
+			base = get_output_base_addr(outn);
+
+			if (!(base > 0)) {
+				dev_err(&idtcm->client->dev,
+					"%s - Unsupported out%d",
+					__func__, outn);
+				return;
+			}
+
+			/* Restore non-zero output_phase_adj */
+			idtcm_write(idtcm, base, OUT_PHASE_ADJ,
+				    &channel->output_phase_adj[outn][0],
+				    sizeof(channel->output_phase_adj[outn]));
+		}
+
+		output_mask = output_mask >> 1;
+		outn += 1;
+	}
+}
+
 static int _idtcm_settime(struct idtcm_channel *channel,
 			  struct timespec64 const *ts)
 {
 	struct idtcm *idtcm = channel->idtcm;
+	int retval;
 	int err;
 
+	/* Save and clear out_phase_adj */
+	save_and_clear_output_phase_adj(channel);
+
 	err = _idtcm_set_dpll_hw_tod(channel, ts, HW_TOD_WR_TRIG_SEL_MSB);
 
 	if (err) {
@@ -814,7 +957,12 @@ static int _idtcm_settime(struct idtcm_channel *channel,
 		return err;
 	}
 
-	return idtcm_sync_pps_output(channel);
+	retval = idtcm_sync_pps_output(channel);
+
+	/* Restore out_phase_adj */
+	restore_output_phase_adj(channel);
+
+	return retval;
 }
 
 static int _idtcm_settime_v487(struct idtcm_channel *channel,
@@ -924,6 +1072,7 @@ static int set_tod_write_overhead(struct idtcm_channel *channel)
 
 	ktime_t start;
 	ktime_t stop;
+	ktime_t diff;
 
 	char buf[TOD_BYTE_COUNT] = {0};
 
@@ -943,7 +1092,9 @@ static int set_tod_write_overhead(struct idtcm_channel *channel)
 
 		stop = ktime_get_raw();
 
-		current_ns = ktime_to_ns(stop - start);
+		diff = ktime_sub(stop, start);
+
+		current_ns = ktime_to_ns(diff);
 
 		if (i == 0) {
 			lowest_ns = current_ns;
@@ -1263,11 +1414,19 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 			       bool enable, unsigned int outn)
 {
 	struct idtcm *idtcm = channel->idtcm;
+	int base;
 	int err;
 	u8 val;
 
-	err = idtcm_read(idtcm, OUTPUT_MODULE_FROM_INDEX(outn),
-			 OUT_CTRL_1, &val, sizeof(val));
+	base = get_output_base_addr(outn);
+
+	if (!(base > 0)) {
+		dev_err(&idtcm->client->dev,
+			"%s - Unsupported out%d", __func__, outn);
+		return base;
+	}
+
+	err = idtcm_read(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
 
 	if (err)
 		return err;
@@ -1277,8 +1436,7 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	else
 		val &= ~SQUELCH_DISABLE;
 
-	return idtcm_write(idtcm, OUTPUT_MODULE_FROM_INDEX(outn),
-			   OUT_CTRL_1, &val, sizeof(val));
+	return idtcm_write(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
 }
 
 static int idtcm_output_mask_enable(struct idtcm_channel *channel,
@@ -1321,6 +1479,23 @@ static int idtcm_perout_enable(struct idtcm_channel *channel,
 	return idtcm_output_enable(channel, enable, perout->index);
 }
 
+static int idtcm_get_pll_mode(struct idtcm_channel *channel,
+			      enum pll_mode *pll_mode)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+	u8 dpll_mode;
+
+	err = idtcm_read(idtcm, channel->dpll_n, DPLL_MODE,
+			 &dpll_mode, sizeof(dpll_mode));
+	if (err)
+		return err;
+
+	*pll_mode = (dpll_mode >> PLL_MODE_SHIFT) & PLL_MODE_MASK;
+
+	return 0;
+}
+
 static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 			      enum pll_mode pll_mode)
 {
@@ -1386,7 +1561,7 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 	else if (offset_ps < -MAX_ABS_WRITE_PHASE_PICOSECONDS)
 		offset_ps = -MAX_ABS_WRITE_PHASE_PICOSECONDS;
 
-	phase_50ps = DIV_ROUND_CLOSEST(div64_s64(offset_ps, 50), 1);
+	phase_50ps = div_s64(offset_ps, 50);
 
 	for (i = 0; i < 4; i++) {
 		buf[i] = phase_50ps & 0xff;
@@ -1403,7 +1578,6 @@ static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	u8 i;
-	bool neg_adj = 0;
 	int err;
 	u8 buf[6] = {0};
 	s64 fcw;
@@ -1427,18 +1601,11 @@ static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
 	 * FCW = -------------
 	 *         111 * 2^4
 	 */
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
 
 	/* 2 ^ -53 = 1.1102230246251565404236316680908e-16 */
 	fcw = scaled_ppm * 244140625ULL;
 
-	fcw = div_u64(fcw, 1776);
-
-	if (neg_adj)
-		fcw = -fcw;
+	fcw = div_s64(fcw, 1776);
 
 	for (i = 0; i < 6; i++) {
 		buf[i] = fcw & 0xff;
@@ -2105,12 +2272,11 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 		}
 	}
 
-	err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_FREQUENCY);
+	/* Sync pll mode with hardware */
+	err = idtcm_get_pll_mode(channel, &channel->pll_mode);
 	if (err) {
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"Error: %s - Unable to read pll mode\n", __func__);
 		return err;
 	}
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index dd3436e..3790dfa 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -15,6 +15,7 @@
 #define FW_FILENAME	"idtcm.bin"
 #define MAX_TOD		(4)
 #define MAX_PLL		(8)
+#define MAX_OUTPUT	(12)
 
 #define MAX_ABS_WRITE_PHASE_PICOSECONDS (107374182350LL)
 
@@ -49,9 +50,6 @@
 #define PHASE_PULL_IN_THRESHOLD_NS_V487	(15000)
 #define TOD_WRITE_OVERHEAD_COUNT_MAX	(2)
 #define TOD_BYTE_COUNT			(11)
-#define WR_PHASE_SETUP_MS		(5000)
-
-#define OUTPUT_MODULE_FROM_INDEX(index)	(OUTPUT_0 + (index) * 0x10)
 
 #define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
 
@@ -125,6 +123,7 @@ struct idtcm_channel {
 	enum pll_mode		pll_mode;
 	u8			pll;
 	u16			output_mask;
+	u8			output_phase_adj[MAX_OUTPUT][4];
 };
 
 struct idtcm {
-- 
2.7.4

