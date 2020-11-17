Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADFA2B695C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgKQQGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:06:34 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:43052 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKQQGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:06:33 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFsx83023024;
        Tue, 17 Nov 2020 11:06:31 -0500
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 34ta9m1b69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:06:31 -0500
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 17 Nov 2020 11:06:30 -0500
Received: from localhost (132.158.202.109) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 17 Nov 2020 11:06:29 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net-next 2/5] ptp: clockmatrix: reset device and check BOOT_STATUS
Date:   Tue, 17 Nov 2020 11:05:59 -0500
Message-ID: <1605629162-31876-3-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605629162-31876-1-git-send-email-min.li.xe@renesas.com>
References: <1605629162-31876-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=4 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170115
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

SM_RESET device only when loading full configuration and check
for BOOT_STATUS. Also remove polling for write trigger done in
_idtcm_settime().

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/idt8a340_reg.h    |   1 +
 drivers/ptp/ptp_clockmatrix.c | 152 ++++++++++++++++++++++++++++++++----------
 drivers/ptp/ptp_clockmatrix.h |   9 ++-
 3 files changed, 126 insertions(+), 36 deletions(-)

diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
index b297c4a..a664dfe 100644
--- a/drivers/ptp/idt8a340_reg.h
+++ b/drivers/ptp/idt8a340_reg.h
@@ -103,6 +103,7 @@
 #define SM_RESET_CMD                      0x5A
 
 #define GENERAL_STATUS                    0xc014
+#define BOOT_STATUS                       0x0000
 #define HW_REV_ID                         0x000A
 #define BOND_ID                           0x000B
 #define HW_CSR_ID                         0x000C
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index efe5639..6a3d02b 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -33,6 +33,45 @@ module_param(firmware, charp, 0);
 
 #define SETTIME_CORRECTION (0)
 
+static int contains_full_configuration(const struct firmware *fw)
+{
+	s32 full_count = FULL_FW_CFG_BYTES - FULL_FW_CFG_SKIPPED_BYTES;
+	struct idtcm_fwrc *rec = (struct idtcm_fwrc *) fw->data;
+	s32 count = 0;
+	u16 regaddr;
+	u8 loaddr;
+	s32 len;
+
+	/* If the firmware contains 'full configuration' SM_RESET can be used
+	 * to ensure proper configuration.
+	 *
+	 * Full configuration is defined as the number of programmable
+	 * bytes within the configuration range minus page offset addr range.
+	 */
+	for (len = fw->size; len > 0; len -= sizeof(*rec)) {
+		regaddr = rec->hiaddr << 8;
+		regaddr |= rec->loaddr;
+
+		loaddr = rec->loaddr;
+
+		rec++;
+
+		/* Top (status registers) and bottom are read-only */
+		if ((regaddr < GPIO_USER_CONTROL)
+		    || (regaddr >= SCRATCH))
+			continue;
+
+		/* Page size 128, last 4 bytes of page skipped */
+		if (((loaddr > 0x7b) && (loaddr <= 0x7f))
+		     || loaddr > 0xfb)
+			continue;
+
+		count++;
+	}
+
+	return (count >= full_count);
+}
+
 static long set_write_phase_ready(struct ptp_clock_info *ptp)
 {
 	struct idtcm_channel *channel =
@@ -302,6 +341,53 @@ static int idtcm_write(struct idtcm *idtcm,
 	return _idtcm_rdwr(idtcm, module + regaddr, buf, count, true);
 }
 
+static int clear_boot_status(struct idtcm *idtcm)
+{
+	int err;
+	u8 buf[4] = {0};
+
+	err = idtcm_write(idtcm, GENERAL_STATUS, BOOT_STATUS, buf, sizeof(buf));
+
+	return err;
+}
+
+static int read_boot_status(struct idtcm *idtcm, u32 *status)
+{
+	int err;
+	u8 buf[4] = {0};
+
+	err = idtcm_read(idtcm, GENERAL_STATUS, BOOT_STATUS, buf, sizeof(buf));
+
+	*status = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+
+	return err;
+}
+
+static int wait_for_boot_status_ready(struct idtcm *idtcm)
+{
+	u32 status = 0;
+	u8 i = 30;	/* 30 * 100ms = 3s */
+	int err;
+
+	do {
+		err = read_boot_status(idtcm, &status);
+
+		if (err)
+			return err;
+
+		if (status == 0xA0)
+			return 0;
+
+		msleep(100);
+		i--;
+
+	} while (i);
+
+	dev_warn(&idtcm->client->dev, "%s timed out\n", __func__);
+
+	return -EBUSY;
+}
+
 static int _idtcm_gettime(struct idtcm_channel *channel,
 			  struct timespec64 *ts)
 {
@@ -711,7 +797,7 @@ static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
 		if (err)
 			return err;
 
-		if (cmd == 0)
+		if ((cmd & TOD_WRITE_SELECTION_MASK) == 0)
 			break;
 
 		if (++count > 20) {
@@ -725,39 +811,16 @@ static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
 }
 
 static int _idtcm_settime(struct idtcm_channel *channel,
-			  struct timespec64 const *ts,
-			  enum hw_tod_write_trig_sel wr_trig)
+			  struct timespec64 const *ts)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
-	int i;
-	u8 trig_sel;
-
-	err = _idtcm_set_dpll_hw_tod(channel, ts, wr_trig);
-
-	if (err)
-		return err;
-
-	/* Wait for the operation to complete. */
-	for (i = 0; i < 10000; i++) {
-		err = idtcm_read(idtcm, channel->hw_dpll_n,
-				 HW_DPLL_TOD_CTRL_1, &trig_sel,
-				 sizeof(trig_sel));
-
-		if (err)
-			return err;
 
-		if (trig_sel == 0x4a)
-			break;
-
-		err = 1;
-	}
+	err = _idtcm_set_dpll_hw_tod(channel, ts, HW_TOD_WR_TRIG_SEL_MSB);
 
 	if (err) {
 		dev_err(&idtcm->client->dev,
-			"Failed at line %d in func %s!\n",
-			__LINE__,
-			__func__);
+			"%s: Set HW ToD failed\n", __func__);
 		return err;
 	}
 
@@ -932,7 +995,7 @@ static int _idtcm_adjtime(struct idtcm_channel *channel, s64 delta)
 
 		ts = ns_to_timespec64(now);
 
-		err = _idtcm_settime(channel, &ts, HW_TOD_WR_TRIG_SEL_MSB);
+		err = _idtcm_settime(channel, &ts);
 	}
 
 	return err;
@@ -940,13 +1003,31 @@ static int _idtcm_adjtime(struct idtcm_channel *channel, s64 delta)
 
 static int idtcm_state_machine_reset(struct idtcm *idtcm)
 {
-	int err;
 	u8 byte = SM_RESET_CMD;
+	u32 status = 0;
+	int err;
+	u8 i;
+
+	clear_boot_status(idtcm);
 
 	err = idtcm_write(idtcm, RESET_CTRL, SM_RESET, &byte, sizeof(byte));
 
-	if (!err)
-		msleep_interruptible(POST_SM_RESET_DELAY_MS);
+	if (!err) {
+		for (i = 0; i < 30; i++) {
+			msleep_interruptible(100);
+			read_boot_status(idtcm, &status);
+
+			if (status == 0xA0) {
+				dev_dbg(&idtcm->client->dev,
+					"SM_RESET completed in %d ms\n",
+					i * 100);
+				break;
+			}
+		}
+
+		if (!status)
+			dev_err(&idtcm->client->dev, "Timed out waiting for CM_RESET to complete\n");
+	}
 
 	return err;
 }
@@ -1140,7 +1221,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 
 	rec = (struct idtcm_fwrc *) fw->data;
 
-	if (fw->size > 0)
+	if (contains_full_configuration(fw))
 		idtcm_state_machine_reset(idtcm);
 
 	for (len = fw->size; len > 0; len -= sizeof(*rec)) {
@@ -1420,7 +1501,7 @@ static int idtcm_settime(struct ptp_clock_info *ptp,
 
 	mutex_lock(&idtcm->reg_lock);
 
-	err = _idtcm_settime(channel, ts, HW_TOD_WR_TRIG_SEL_MSB);
+	err = _idtcm_settime(channel, ts);
 
 	if (err)
 		dev_err(&idtcm->client->dev,
@@ -1851,7 +1932,7 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
 	if (err)
 		return err;
 
-	return _idtcm_settime(channel, &ts, HW_TOD_WR_TRIG_SEL_MSB);
+	return _idtcm_settime(channel, &ts);
 }
 
 static void idtcm_display_version_info(struct idtcm *idtcm)
@@ -2143,6 +2224,9 @@ static int idtcm_probe(struct i2c_client *client,
 		dev_warn(&idtcm->client->dev,
 			 "loading firmware failed with %d\n", err);
 
+	if (wait_for_boot_status_ready(idtcm))
+		dev_warn(&idtcm->client->dev, "BOOT_STATUS != 0xA0\n");
+
 	if (idtcm->tod_mask) {
 		for (i = 0; i < MAX_TOD; i++) {
 			if (idtcm->tod_mask & (1 << i)) {
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 82840d7..713e41a 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -53,9 +53,14 @@
 
 #define OUTPUT_MODULE_FROM_INDEX(index)	(OUTPUT_0 + (index) * 0x10)
 
-#define PEROUT_ENABLE_OUTPUT_MASK		(0xdeadbeef)
+#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
 
-#define IDTCM_MAX_WRITE_COUNT			(512)
+#define IDTCM_MAX_WRITE_COUNT		(512)
+
+#define FULL_FW_CFG_BYTES		(SCRATCH - GPIO_USER_CONTROL)
+#define FULL_FW_CFG_SKIPPED_BYTES	(((SCRATCH >> 7) \
+					  - (GPIO_USER_CONTROL >> 7)) \
+					 * 4) /* 4 bytes skipped every 0x80 */
 
 /* Values of DPLL_N.DPLL_MODE.PLL_MODE */
 enum pll_mode {
-- 
2.7.4

