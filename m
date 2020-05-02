Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C841C22A0
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 06:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEBED2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 00:03:28 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:36262 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgEBED2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 00:03:28 -0400
X-Greylist: delayed 1633 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2020 00:03:26 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 0423WTuq012090;
        Fri, 1 May 2020 23:36:14 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 30mfccke9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 23:36:13 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Fri, 1 May 2020 23:36:12 -0400
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1531.3 via Frontend
 Transport; Fri, 1 May 2020 23:36:11 -0400
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v2 net-next 3/3] ptp: ptp_clockmatrix: Add adjphase() to support PHC write phase mode.
Date:   Fri, 1 May 2020 23:35:38 -0400
Message-ID: <1588390538-24589-4-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_18:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005020027
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Add idtcm_adjphase() to support PHC write phase mode.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 92 +++++++++++++++++++++++++++++++++++++++++++
 drivers/ptp/ptp_clockmatrix.h |  8 +++-
 2 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index a3f6088..ceb6bc5 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/timekeeping.h>
 
@@ -24,6 +25,16 @@ MODULE_LICENSE("GPL");
 
 #define SETTIME_CORRECTION (0)
 
+static long set_write_phase_ready(struct ptp_clock_info *ptp)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+
+	channel->write_phase_ready = 1;
+
+	return 0;
+}
+
 static int char_array_to_timespec(u8 *buf,
 				  u8 count,
 				  struct timespec64 *ts)
@@ -871,6 +882,64 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 
 /* PTP Hardware Clock interface */
 
+/**
+ * @brief Maximum absolute value for write phase offset in picoseconds
+ *
+ * Destination signed register is 32-bit register in resolution of 50ps
+ *
+ * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
+ */
+static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
+{
+	struct idtcm *idtcm = channel->idtcm;
+
+	int err;
+	u8 i;
+	u8 buf[4] = {0};
+	s32 phase_50ps;
+	s64 offset_ps;
+
+	if (channel->pll_mode != PLL_MODE_WRITE_PHASE) {
+
+		err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_PHASE);
+
+		if (err)
+			return err;
+
+		channel->write_phase_ready = 0;
+
+		ptp_schedule_worker(channel->ptp_clock,
+				    msecs_to_jiffies(WR_PHASE_SETUP_MS));
+	}
+
+	if (!channel->write_phase_ready)
+		delta_ns = 0;
+
+	offset_ps = (s64)delta_ns * 1000;
+
+	/*
+	 * Check for 32-bit signed max * 50:
+	 *
+	 * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
+	 */
+	if (offset_ps > MAX_ABS_WRITE_PHASE_PICOSECONDS)
+		offset_ps = MAX_ABS_WRITE_PHASE_PICOSECONDS;
+	else if (offset_ps < -MAX_ABS_WRITE_PHASE_PICOSECONDS)
+		offset_ps = -MAX_ABS_WRITE_PHASE_PICOSECONDS;
+
+	phase_50ps = DIV_ROUND_CLOSEST(div64_s64(offset_ps, 50), 1);
+
+	for (i = 0; i < 4; i++) {
+		buf[i] = phase_50ps & 0xff;
+		phase_50ps >>= 8;
+	}
+
+	err = idtcm_write(idtcm, channel->dpll_phase, DPLL_WR_PHASE,
+			  buf, sizeof(buf));
+
+	return err;
+}
+
 static int idtcm_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 {
 	struct idtcm_channel *channel =
@@ -977,6 +1046,24 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return err;
 }
 
+static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+
+	struct idtcm *idtcm = channel->idtcm;
+
+	int err;
+
+	mutex_lock(&idtcm->reg_lock);
+
+	err = _idtcm_adjphase(channel, delta);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	return err;
+}
+
 static int idtcm_enable(struct ptp_clock_info *ptp,
 			struct ptp_clock_request *rq, int on)
 {
@@ -1055,13 +1142,16 @@ static const struct ptp_clock_info idtcm_caps = {
 	.owner		= THIS_MODULE,
 	.max_adj	= 244000,
 	.n_per_out	= 1,
+	.adjphase	= &idtcm_adjphase,
 	.adjfreq	= &idtcm_adjfreq,
 	.adjtime	= &idtcm_adjtime,
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime,
 	.enable		= &idtcm_enable,
+	.do_aux_work	= &set_write_phase_ready,
 };
 
+
 static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 {
 	struct idtcm_channel *channel;
@@ -1146,6 +1236,8 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	if (!channel->ptp_clock)
 		return -ENOTSUPP;
 
+	channel->write_phase_ready = 0;
+
 	dev_info(&idtcm->client->dev, "PLL%d registered as ptp%d\n",
 		 index, channel->ptp_clock->index);
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 6c1f93a..3de0eb7 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -15,6 +15,8 @@
 #define FW_FILENAME	"idtcm.bin"
 #define MAX_PHC_PLL	4
 
+#define MAX_ABS_WRITE_PHASE_PICOSECONDS (107374182350LL)
+
 #define PLL_MASK_ADDR		(0xFFA5)
 #define DEFAULT_PLL_MASK	(0x04)
 
@@ -33,8 +35,9 @@
 
 #define POST_SM_RESET_DELAY_MS		(3000)
 #define PHASE_PULL_IN_THRESHOLD_NS	(150000)
-#define TOD_WRITE_OVERHEAD_COUNT_MAX    (5)
-#define TOD_BYTE_COUNT                  (11)
+#define TOD_WRITE_OVERHEAD_COUNT_MAX	(5)
+#define TOD_BYTE_COUNT			(11)
+#define WR_PHASE_SETUP_MS		(5000)
 
 /* Values of DPLL_N.DPLL_MODE.PLL_MODE */
 enum pll_mode {
@@ -77,6 +80,7 @@ struct idtcm_channel {
 	u16			hw_dpll_n;
 	enum pll_mode		pll_mode;
 	u16			output_mask;
+	int			write_phase_ready;
 };
 
 struct idtcm {
-- 
2.7.4

