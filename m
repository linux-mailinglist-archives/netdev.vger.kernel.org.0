Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E9B31AA39
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 06:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhBMFhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 00:37:40 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:51286 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhBMFhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 00:37:38 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11D52i4q025400;
        Sat, 13 Feb 2021 00:06:22 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 36ntxd0ath-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 13 Feb 2021 00:06:22 -0500
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Sat, 13 Feb 2021 00:06:19 -0500
Received: from localhost (132.158.202.108) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 13 Feb 2021 00:06:19 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v2 net-next 1/3] ptp: ptp_clockmatrix: Add wait_for_sys_apll_dpll_lock.
Date:   Sat, 13 Feb 2021 00:06:04 -0500
Message-ID: <1613192766-14010-2-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_01:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130041
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Part of the device initialization aligns the rising edge of the output
clock to the internal 1 PPS clock. If the system APLL and DPLL is not
locked, then the alignment will fail and there will be a fixed offset
between the internal 1 PPS clock and the output clock.

After loading the device firmware, poll the system APLL and DPLL for
locked state prior to initialization, timing out after 2 seconds.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/idt8a340_reg.h    | 10 ++++++
 drivers/ptp/ptp_clockmatrix.c | 76 +++++++++++++++++++++++++++++++++++++++++--
 drivers/ptp/ptp_clockmatrix.h | 15 +++++++++
 3 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
index a664dfe..ac524cf 100644
--- a/drivers/ptp/idt8a340_reg.h
+++ b/drivers/ptp/idt8a340_reg.h
@@ -122,6 +122,8 @@
 #define OTP_SCSR_CONFIG_SELECT            0x0022
 
 #define STATUS                            0xc03c
+#define DPLL_SYS_STATUS                   0x0020
+#define DPLL_SYS_APLL_STATUS              0x0021
 #define USER_GPIO0_TO_7_STATUS            0x008a
 #define USER_GPIO8_TO_15_STATUS           0x008b
 
@@ -707,4 +709,12 @@
 /* Bit definitions for the DPLL_CTRL_COMBO_MASTER_CFG register */
 #define COMBO_MASTER_HOLD                 BIT(0)
 
+/* Bit definitions for DPLL_SYS_STATUS register */
+#define DPLL_SYS_STATE_MASK               (0xf)
+
+/* Bit definitions for SYS_APLL_STATUS register */
+#define SYS_APLL_LOSS_LOCK_LIVE_MASK       BIT(0)
+#define SYS_APLL_LOSS_LOCK_LIVE_LOCKED     0
+#define SYS_APLL_LOSS_LOCK_LIVE_UNLOCKED   1
+
 #endif
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 051511f..3de8411 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -335,6 +335,79 @@ static int wait_for_boot_status_ready(struct idtcm *idtcm)
 	return -EBUSY;
 }
 
+static int read_sys_apll_status(struct idtcm *idtcm, u8 *status)
+{
+	int err;
+
+	err = idtcm_read(idtcm, STATUS, DPLL_SYS_APLL_STATUS, status,
+			 sizeof(u8));
+
+	return err;
+}
+
+static int read_sys_dpll_status(struct idtcm *idtcm, u8 *status)
+{
+	int err;
+
+	err = idtcm_read(idtcm, STATUS, DPLL_SYS_STATUS, status, sizeof(u8));
+
+	return err;
+}
+
+static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
+{
+	const char *fmt = "%d ms SYS lock timeout: APLL Loss Lock %d  DPLL state %d";
+	u8 i = LOCK_TIMEOUT_MS / LOCK_POLL_INTERVAL_MS;
+	u8 apll = 0;
+	u8 dpll = 0;
+
+	int err;
+
+	do {
+		err = read_sys_apll_status(idtcm, &apll);
+
+		if (err)
+			return err;
+
+		err = read_sys_dpll_status(idtcm, &dpll);
+
+		if (err)
+			return err;
+
+		apll &= SYS_APLL_LOSS_LOCK_LIVE_MASK;
+		dpll &= DPLL_SYS_STATE_MASK;
+
+		if ((apll == SYS_APLL_LOSS_LOCK_LIVE_LOCKED)
+		    && (dpll == DPLL_STATE_LOCKED)) {
+			return 0;
+		} else if ((dpll == DPLL_STATE_FREERUN) ||
+			   (dpll == DPLL_STATE_HOLDOVER) ||
+			   (dpll == DPLL_STATE_OPEN_LOOP)) {
+			dev_warn(&idtcm->client->dev,
+				"No wait state: DPLL_SYS_STATE %d", dpll);
+			return -EPERM;
+		}
+
+		msleep(LOCK_POLL_INTERVAL_MS);
+		i--;
+
+	} while (i);
+
+	dev_warn(&idtcm->client->dev, fmt, LOCK_TIMEOUT_MS, apll, dpll);
+
+	return -ETIME;
+}
+
+static void wait_for_chip_ready(struct idtcm *idtcm)
+{
+	if (wait_for_boot_status_ready(idtcm))
+		dev_warn(&idtcm->client->dev, "BOOT_STATUS != 0xA0");
+
+	if (wait_for_sys_apll_dpll_lock(idtcm))
+		dev_warn(&idtcm->client->dev,
+			 "Continuing while SYS APLL/DPLL is not locked");
+}
+
 static int _idtcm_gettime(struct idtcm_channel *channel,
 			  struct timespec64 *ts)
 {
@@ -2235,8 +2308,7 @@ static int idtcm_probe(struct i2c_client *client,
 		dev_warn(&idtcm->client->dev,
 			 "loading firmware failed with %d\n", err);
 
-	if (wait_for_boot_status_ready(idtcm))
-		dev_warn(&idtcm->client->dev, "BOOT_STATUS != 0xA0\n");
+	wait_for_chip_ready(idtcm);
 
 	if (idtcm->tod_mask) {
 		for (i = 0; i < MAX_TOD; i++) {
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 645de2c..0233236 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -51,6 +51,9 @@
 #define TOD_WRITE_OVERHEAD_COUNT_MAX		(2)
 #define TOD_BYTE_COUNT				(11)
 
+#define LOCK_TIMEOUT_MS			(2000)
+#define LOCK_POLL_INTERVAL_MS		(10)
+
 #define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
 
 #define IDTCM_MAX_WRITE_COUNT		(512)
@@ -105,6 +108,18 @@ enum scsr_tod_write_type_sel {
 	SCSR_TOD_WR_TYPE_SEL_MAX = SCSR_TOD_WR_TYPE_SEL_DELTA_MINUS,
 };
 
+/* Values STATUS.DPLL_SYS_STATUS.DPLL_SYS_STATE */
+enum dpll_state {
+	DPLL_STATE_MIN = 0,
+	DPLL_STATE_FREERUN = DPLL_STATE_MIN,
+	DPLL_STATE_LOCKACQ = 1,
+	DPLL_STATE_LOCKREC = 2,
+	DPLL_STATE_LOCKED = 3,
+	DPLL_STATE_HOLDOVER = 4,
+	DPLL_STATE_OPEN_LOOP = 5,
+	DPLL_STATE_MAX = DPLL_STATE_OPEN_LOOP,
+};
+
 struct idtcm;
 
 struct idtcm_channel {
-- 
2.7.4

