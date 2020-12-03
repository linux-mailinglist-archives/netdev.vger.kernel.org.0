Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A652CDA0D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgLCPVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:21:46 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:59588 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgLCPVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:21:45 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0B3FFUBY008414;
        Thu, 3 Dec 2020 10:20:58 -0500
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap02.intersil.com with ESMTP id 356fuh8e5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 10:20:58 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Thu, 3 Dec 2020 10:20:56 -0500
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 3 Dec 2020 10:20:56 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net-next 3/4] ptp: clockmatrix: Fix non-zero phase_adj is lost after snap
Date:   Thu, 3 Dec 2020 10:20:18 -0500
Message-ID: <1607008819-29158-3-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607008819-29158-1-git-send-email-min.li.xe@renesas.com>
References: <1607008819-29158-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_08:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=4 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030092
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Fix non-zero phase_adj is lost after snap. Use ktime_sub
to do ktime_t subtraction.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 109 ++++++++++++++++++++++++++++++++++--------
 drivers/ptp/ptp_clockmatrix.h |   5 +-
 2 files changed, 90 insertions(+), 24 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 0398c3d..3066c9d 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -675,8 +675,9 @@ static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 
 		if (idtcm->calculate_overhead_flag) {
 			/* Assumption: I2C @ 400KHz */
-			total_overhead_ns =  ktime_to_ns(ktime_get_raw()
-							 - idtcm->start_time)
+			ktime_t diff = ktime_sub(ktime_get_raw(),
+						 idtcm->start_time);
+			total_overhead_ns =  ktime_to_ns(diff)
 					     + idtcm->tod_write_overhead_ns
 					     + SETTIME_CORRECTION;
 
@@ -759,6 +760,54 @@ static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
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
 static int _idtcm_settime(struct idtcm_channel *channel,
 			  struct timespec64 const *ts)
 {
@@ -883,6 +932,7 @@ static int set_tod_write_overhead(struct idtcm_channel *channel)
 
 	ktime_t start;
 	ktime_t stop;
+	ktime_t diff;
 
 	char buf[TOD_BYTE_COUNT] = {0};
 
@@ -902,7 +952,9 @@ static int set_tod_write_overhead(struct idtcm_channel *channel)
 
 		stop = ktime_get_raw();
 
-		current_ns = ktime_to_ns(stop - start);
+		diff = ktime_sub(stop, start);
+
+		current_ns = ktime_to_ns(diff);
 
 		if (i == 0) {
 			lowest_ns = current_ns;
@@ -1222,11 +1274,19 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
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
@@ -1236,8 +1296,7 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	else
 		val &= ~SQUELCH_DISABLE;
 
-	return idtcm_write(idtcm, OUTPUT_MODULE_FROM_INDEX(outn),
-			   OUT_CTRL_1, &val, sizeof(val));
+	return idtcm_write(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
 }
 
 static int idtcm_output_mask_enable(struct idtcm_channel *channel,
@@ -1280,6 +1339,23 @@ static int idtcm_perout_enable(struct idtcm_channel *channel,
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
@@ -1345,7 +1421,7 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 	else if (offset_ps < -MAX_ABS_WRITE_PHASE_PICOSECONDS)
 		offset_ps = -MAX_ABS_WRITE_PHASE_PICOSECONDS;
 
-	phase_50ps = DIV_ROUND_CLOSEST(div64_s64(offset_ps, 50), 1);
+	phase_50ps = div_s64(offset_ps, 50);
 
 	for (i = 0; i < 4; i++) {
 		buf[i] = phase_50ps & 0xff;
@@ -1362,7 +1438,6 @@ static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	u8 i;
-	bool neg_adj = 0;
 	int err;
 	u8 buf[6] = {0};
 	s64 fcw;
@@ -1386,18 +1461,11 @@ static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
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
@@ -2064,12 +2132,11 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
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

