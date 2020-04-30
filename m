Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D971BED5C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgD3BC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:02:56 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:58736 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgD3BC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:02:56 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 03U0ROcm022639;
        Wed, 29 Apr 2020 20:28:48 -0400
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 30mfccj8cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 20:28:48 -0400
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Wed, 29 Apr 2020 20:28:47 -0400
Received: from localhost (132.158.202.109) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.1531.3 via Frontend
 Transport; Wed, 29 Apr 2020 20:28:46 -0400
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 3/3] ptp: ptp_clockmatrix: Add adjphase() to support PHC write phase mode.
Date:   Wed, 29 Apr 2020 20:28:25 -0400
Message-ID: <1588206505-21773-4-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_11:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2004300000
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Add idtcm_adjphase() to support PHC write phase mode.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 123 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ptp/ptp_clockmatrix.h |  11 +++-
 2 files changed, 132 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index a3f6088..07b13c3 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -24,6 +24,15 @@ MODULE_LICENSE("GPL");
 
 #define SETTIME_CORRECTION (0)
 
+static void set_write_phase_ready(struct kthread_work *work)
+{
+	struct idtcm_channel *ch = container_of(work,
+						struct idtcm_channel,
+						write_phase_ready_work.work);
+
+	ch->write_phase_ready = 1;
+}
+
 static int char_array_to_timespec(u8 *buf,
 				  u8 count,
 				  struct timespec64 *ts)
@@ -871,6 +880,69 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 
 /* PTP Hardware Clock interface */
 
+/**
+ * @brief Maximum absolute value for write phase offset in picoseconds
+ *
+ * Destination signed register is 32-bit register in resolution of 50ps
+ *
+ * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
+ */
+static int _idtcm_adjphase(struct idtcm_channel *channel, s32 deltaNs)
+{
+	struct idtcm *idtcm = channel->idtcm;
+
+	int err;
+	u8 i;
+	u8 buf[4] = {0};
+	s32 phaseIn50Picoseconds;
+	s64 phaseOffsetInPs;
+
+	if (channel->pll_mode != PLL_MODE_WRITE_PHASE) {
+
+		kthread_cancel_delayed_work_sync(
+			&channel->write_phase_ready_work);
+
+		err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_PHASE);
+
+		if (err)
+			return err;
+
+		channel->write_phase_ready = 0;
+
+		kthread_queue_delayed_work(channel->kworker,
+					   &channel->write_phase_ready_work,
+					   msecs_to_jiffies(WR_PHASE_SETUP_MS));
+	}
+
+	if (!channel->write_phase_ready)
+		deltaNs = 0;
+
+	phaseOffsetInPs = (s64)deltaNs * 1000;
+
+	/*
+	 * Check for 32-bit signed max * 50:
+	 *
+	 * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
+	 */
+	if (phaseOffsetInPs > MAX_ABS_WRITE_PHASE_PICOSECONDS)
+		phaseOffsetInPs = MAX_ABS_WRITE_PHASE_PICOSECONDS;
+	else if (phaseOffsetInPs < -MAX_ABS_WRITE_PHASE_PICOSECONDS)
+		phaseOffsetInPs = -MAX_ABS_WRITE_PHASE_PICOSECONDS;
+
+	phaseIn50Picoseconds = DIV_ROUND_CLOSEST(div64_s64(phaseOffsetInPs, 50),
+						 1);
+
+	for (i = 0; i < 4; i++) {
+		buf[i] = phaseIn50Picoseconds & 0xff;
+		phaseIn50Picoseconds >>= 8;
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
@@ -977,6 +1049,24 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
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
@@ -1055,6 +1145,7 @@ static const struct ptp_clock_info idtcm_caps = {
 	.owner		= THIS_MODULE,
 	.max_adj	= 244000,
 	.n_per_out	= 1,
+	.adjphase	= &idtcm_adjphase,
 	.adjfreq	= &idtcm_adjfreq,
 	.adjtime	= &idtcm_adjtime,
 	.gettime64	= &idtcm_gettime,
@@ -1062,6 +1153,21 @@ static const struct ptp_clock_info idtcm_caps = {
 	.enable		= &idtcm_enable,
 };
 
+static int write_phase_worker_setup(struct idtcm_channel *channel, int index)
+{
+	channel->kworker = kthread_create_worker(0, "channel%d", index);
+
+	if (IS_ERR(channel->kworker))
+		return PTR_ERR(channel->kworker);
+
+	channel->write_phase_ready = 0;
+
+	kthread_init_delayed_work(&channel->write_phase_ready_work,
+				  set_write_phase_ready);
+
+	return 0;
+}
+
 static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 {
 	struct idtcm_channel *channel;
@@ -1146,6 +1252,10 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	if (!channel->ptp_clock)
 		return -ENOTSUPP;
 
+	err = write_phase_worker_setup(channel, index);
+	if (err)
+		return err;
+
 	dev_info(&idtcm->client->dev, "PLL%d registered as ptp%d\n",
 		 index, channel->ptp_clock->index);
 
@@ -1284,6 +1394,19 @@ static int idtcm_remove(struct i2c_client *client)
 {
 	struct idtcm *idtcm = i2c_get_clientdata(client);
 
+	int i;
+	struct idtcm_channel *channel;
+
+	for (i = 0; i < MAX_PHC_PLL; i++) {
+		channel = &idtcm->channel[i];
+
+		if (channel->kworker) {
+			kthread_cancel_delayed_work_sync(
+				&channel->write_phase_ready_work);
+			kthread_destroy_worker(channel->kworker);
+		}
+	}
+
 	ptp_clock_unregister_all(idtcm);
 
 	mutex_destroy(&idtcm->reg_lock);
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 6c1f93a..36e133d 100644
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
@@ -77,6 +80,10 @@ struct idtcm_channel {
 	u16			hw_dpll_n;
 	enum pll_mode		pll_mode;
 	u16			output_mask;
+	int			write_phase_ready;
+
+	struct kthread_worker		*kworker;
+	struct kthread_delayed_work	write_phase_ready_work;
 };
 
 struct idtcm {
-- 
2.7.4

