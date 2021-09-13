Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610DD409E33
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 22:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243965AbhIMUeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 16:34:36 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:45628 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbhIMUef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 16:34:35 -0400
X-Greylist: delayed 1225 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2021 16:34:34 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 18DK20PD021207;
        Mon, 13 Sep 2021 16:12:54 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 3b0pmh0skm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 16:12:54 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2242.4; Mon, 13 Sep 2021 16:12:52 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Mon, 13 Sep 2021 16:12:52 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 2/3] ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)
Date:   Mon, 13 Sep 2021 16:12:33 -0400
Message-ID: <1631563954-6700-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1631563954-6700-1-git-send-email-min.li.xe@renesas.com>
References: <1631563954-6700-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Rh1_YT17UOQpLgRAHJER5lTQYznsVa1-
X-Proofpoint-ORIG-GUID: Rh1_YT17UOQpLgRAHJER5lTQYznsVa1-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-13_09:2021-09-09,2021-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130120
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

So far we don't need to support new 5.2 functions but different register
addresses

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/idt8a340_reg.h    |  61 +++++++++++++-
 drivers/ptp/ptp_clockmatrix.c | 179 ++++++++++++++++++++++--------------------
 drivers/ptp/ptp_clockmatrix.h |  17 ++--
 3 files changed, 165 insertions(+), 92 deletions(-)

diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
index ac524cf..dea8e1d 100644
--- a/drivers/ptp/idt8a340_reg.h
+++ b/drivers/ptp/idt8a340_reg.h
@@ -5,7 +5,7 @@
  * https://github.com/richardcochran/regen
  *
  * Hand modified to include some HW registers.
- * Based on 4.8.0, SCSR rev C commit a03c7ae5
+ * Based on 5.2.0, Family Programming Guide (Sept 30, 2020)
  */
 #ifndef HAVE_IDT8A340_REG
 #define HAVE_IDT8A340_REG
@@ -100,6 +100,7 @@
 
 #define RESET_CTRL                        0xc000
 #define SM_RESET                          0x0012
+#define SM_RESET_V520                     0x0013
 #define SM_RESET_CMD                      0x5A
 
 #define GENERAL_STATUS                    0xc014
@@ -130,6 +131,8 @@
 #define GPIO_USER_CONTROL                 0xc160
 #define GPIO0_TO_7_OUT                    0x0000
 #define GPIO8_TO_15_OUT                   0x0001
+#define GPIO0_TO_7_OUT_V520               0x0002
+#define GPIO8_TO_15_OUT_V520              0x0003
 
 #define STICKY_STATUS_CLEAR               0xc164
 
@@ -216,22 +219,27 @@
 #define DPLL_REF_MODE                     0x0035
 #define DPLL_PHASE_MEASUREMENT_CFG        0x0036
 #define DPLL_MODE                         0x0037
+#define DPLL_MODE_V520                    0x003B
 
 #define DPLL_1                            0xc400
 
 #define DPLL_2                            0xc438
+#define DPLL_2_V520                       0xc43c
 
 #define DPLL_3                            0xc480
 
 #define DPLL_4                            0xc4b8
+#define DPLL_4_V520                       0xc4bc
 
 #define DPLL_5                            0xc500
 
 #define DPLL_6                            0xc538
+#define DPLL_6_V520                       0xc53c
 
 #define DPLL_7                            0xc580
 
 #define SYS_DPLL                          0xc5b8
+#define SYS_DPLL_V520                     0xc5bc
 
 #define DPLL_CTRL_0                       0xc600
 #define DPLL_CTRL_DPLL_MANU_REF_CFG       0x0001
@@ -331,6 +339,7 @@
 #define GPIO_ALERT_OUT_CFG                0x000e
 #define GPIO_TOD_NOTIFICATION_CFG         0x000f
 #define GPIO_CTRL                         0x0010
+#define GPIO_CTRL_V520                    0x0011
 
 #define GPIO_1                            0xc8d4
 
@@ -365,6 +374,7 @@
 #define OUT_DIV_MUX                       0xca12
 
 #define OUTPUT_0                          0xca14
+#define OUTPUT_0_V520                     0xca20
 /* FOD frequency output divider value */
 #define OUT_DIV                           0x0000
 #define OUT_DUTY_CYCLE_HIGH               0x0004
@@ -374,28 +384,40 @@
 #define OUT_PHASE_ADJ                     0x000c
 
 #define OUTPUT_1                          0xca24
+#define OUTPUT_1_V520                     0xca30
 
 #define OUTPUT_2                          0xca34
+#define OUTPUT_2_V520                     0xca40
 
 #define OUTPUT_3                          0xca44
+#define OUTPUT_3_V520                     0xca50
 
 #define OUTPUT_4                          0xca54
+#define OUTPUT_4_V520                     0xca60
 
 #define OUTPUT_5                          0xca64
+#define OUTPUT_5_V520                     0xca80
 
 #define OUTPUT_6                          0xca80
+#define OUTPUT_6_V520                     0xca90
 
 #define OUTPUT_7                          0xca90
+#define OUTPUT_7_V520                     0xcaa0
 
 #define OUTPUT_8                          0xcaa0
+#define OUTPUT_8_V520                     0xcab0
 
 #define OUTPUT_9                          0xcab0
+#define OUTPUT_9_V520                     0xcac0
 
 #define OUTPUT_10                         0xcac0
+#define OUTPUT_10_V520                     0xcad0
 
 #define OUTPUT_11                         0xcad0
+#define OUTPUT_11_V520                    0xcae0
 
 #define SERIAL                            0xcae0
+#define SERIAL_V520                       0xcaf0
 
 #define PWM_ENCODER_0                     0xcb00
 
@@ -416,50 +438,72 @@
 #define PWM_DECODER_0                     0xcb40
 
 #define PWM_DECODER_1                     0xcb48
+#define PWM_DECODER_1_V520                0xcb4a
 
 #define PWM_DECODER_2                     0xcb50
+#define PWM_DECODER_2_V520                0xcb54
 
 #define PWM_DECODER_3                     0xcb58
+#define PWM_DECODER_3_V520                0xcb5e
 
 #define PWM_DECODER_4                     0xcb60
+#define PWM_DECODER_4_V520                0xcb68
 
 #define PWM_DECODER_5                     0xcb68
+#define PWM_DECODER_5_V520                0xcb80
 
 #define PWM_DECODER_6                     0xcb70
+#define PWM_DECODER_6_V520                0xcb8a
 
 #define PWM_DECODER_7                     0xcb80
+#define PWM_DECODER_7_V520                0xcb94
 
 #define PWM_DECODER_8                     0xcb88
+#define PWM_DECODER_8_V520                0xcb9e
 
 #define PWM_DECODER_9                     0xcb90
+#define PWM_DECODER_9_V520                0xcba8
 
 #define PWM_DECODER_10                    0xcb98
+#define PWM_DECODER_10_V520               0xcbb2
 
 #define PWM_DECODER_11                    0xcba0
+#define PWM_DECODER_11_V520               0xcbbc
 
 #define PWM_DECODER_12                    0xcba8
+#define PWM_DECODER_12_V520               0xcbc6
 
 #define PWM_DECODER_13                    0xcbb0
+#define PWM_DECODER_13_V520               0xcbd0
 
 #define PWM_DECODER_14                    0xcbb8
+#define PWM_DECODER_14_V520               0xcbda
 
 #define PWM_DECODER_15                    0xcbc0
+#define PWM_DECODER_15_V520               0xcbe4
 
 #define PWM_USER_DATA                     0xcbc8
+#define PWM_USER_DATA_V520                0xcbf0
 
 #define TOD_0                             0xcbcc
+#define TOD_0_V520                        0xcc00
 
 /* Enable TOD counter, output channel sync and even-PPS mode */
 #define TOD_CFG                           0x0000
+#define TOD_CFG_V520                      0x0001
 
 #define TOD_1                             0xcbce
+#define TOD_1_V520                        0xcc02
 
 #define TOD_2                             0xcbd0
+#define TOD_2_V520                        0xcc04
 
 #define TOD_3                             0xcbd2
+#define TOD_3_V520                        0xcc06
 
 
 #define TOD_WRITE_0                       0xcc00
+#define TOD_WRITE_0_V520                  0xcc10
 /* 8-bit subns, 32-bit ns, 48-bit seconds */
 #define TOD_WRITE                         0x0000
 /* Counter increments after TOD write is completed */
@@ -470,12 +514,16 @@
 #define TOD_WRITE_CMD                     0x000f
 
 #define TOD_WRITE_1                       0xcc10
+#define TOD_WRITE_1_V520                  0xcc20
 
 #define TOD_WRITE_2                       0xcc20
+#define TOD_WRITE_2_V520                  0xcc30
 
 #define TOD_WRITE_3                       0xcc30
+#define TOD_WRITE_3_V520                  0xcc40
 
 #define TOD_READ_PRIMARY_0                0xcc40
+#define TOD_READ_PRIMARY_0_V520           0xcc50
 /* 8-bit subns, 32-bit ns, 48-bit seconds */
 #define TOD_READ_PRIMARY                  0x0000
 /* Counter increments after TOD write is completed */
@@ -484,22 +532,31 @@
 #define TOD_READ_PRIMARY_SEL_CFG_0        0x000c
 /* Read trigger selection */
 #define TOD_READ_PRIMARY_CMD              0x000e
+#define TOD_READ_PRIMARY_CMD_V520         0x000f
 
 #define TOD_READ_PRIMARY_1                0xcc50
+#define TOD_READ_PRIMARY_1_V520           0xcc60
 
 #define TOD_READ_PRIMARY_2                0xcc60
+#define TOD_READ_PRIMARY_2_V520           0xcc80
 
 #define TOD_READ_PRIMARY_3                0xcc80
+#define TOD_READ_PRIMARY_3_V520           0xcc90
 
 #define TOD_READ_SECONDARY_0              0xcc90
+#define TOD_READ_SECONDARY_0_V520         0xcca0
 
 #define TOD_READ_SECONDARY_1              0xcca0
+#define TOD_READ_SECONDARY_1_V520         0xccb0
 
 #define TOD_READ_SECONDARY_2              0xccb0
+#define TOD_READ_SECONDARY_2_V520         0xccc0
 
 #define TOD_READ_SECONDARY_3              0xccc0
+#define TOD_READ_SECONDARY_3_V520         0xccd0
 
 #define OUTPUT_TDC_CFG                    0xccd0
+#define OUTPUT_TDC_CFG_V520               0xcce0
 
 #define OUTPUT_TDC_0                      0xcd00
 
@@ -512,8 +569,10 @@
 #define INPUT_TDC                         0xcd20
 
 #define SCRATCH                           0xcf50
+#define SCRATCH_V520                      0xcf4c
 
 #define EEPROM                            0xcf68
+#define EEPROM_V520                       0xcf64
 
 #define OTP                               0xcf70
 
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 9b1c6b2..2c552a0 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -33,15 +33,21 @@ module_param(firmware, charp, 0);
 
 #define SETTIME_CORRECTION (0)
 
-static int contains_full_configuration(const struct firmware *fw)
+static int contains_full_configuration(struct idtcm *idtcm,
+				       const struct firmware *fw)
 {
-	s32 full_count = FULL_FW_CFG_BYTES - FULL_FW_CFG_SKIPPED_BYTES;
 	struct idtcm_fwrc *rec = (struct idtcm_fwrc *)fw->data;
+	u16 scratch = IDTCM_FW_REG(idtcm->fw_ver, V520, SCRATCH);
+	s32 full_count;
 	s32 count = 0;
 	u16 regaddr;
 	u8 loaddr;
 	s32 len;
 
+	/* 4 bytes skipped every 0x80 */
+	full_count = (scratch - GPIO_USER_CONTROL) -
+		     ((scratch >> 7) - (GPIO_USER_CONTROL >> 7)) * 4;
+
 	/* If the firmware contains 'full configuration' SM_RESET can be used
 	 * to ensure proper configuration.
 	 *
@@ -57,7 +63,7 @@ static int contains_full_configuration(const struct firmware *fw)
 		rec++;
 
 		/* Top (status registers) and bottom are read-only */
-		if (regaddr < GPIO_USER_CONTROL || regaddr >= SCRATCH)
+		if (regaddr < GPIO_USER_CONTROL || regaddr >= scratch)
 			continue;
 
 		/* Page size 128, last 4 bytes of page skipped */
@@ -152,6 +158,19 @@ static int idtcm_strverscmp(const char *version1, const char *version2)
 	return 0;
 }
 
+static enum fw_version idtcm_fw_version(const char *version)
+{
+	enum fw_version ver = V_DEFAULT;
+
+	if (idtcm_strverscmp(version, "4.8.7") >= 0)
+		ver = V487;
+
+	if (idtcm_strverscmp(version, "5.2.0") >= 0)
+		ver = V520;
+
+	return ver;
+}
+
 static int idtcm_xfer_read(struct idtcm *idtcm,
 			   u8 regaddr,
 			   u8 *buf,
@@ -353,8 +372,8 @@ static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
 		apll &= SYS_APLL_LOSS_LOCK_LIVE_MASK;
 		dpll &= DPLL_SYS_STATE_MASK;
 
-		if (apll == SYS_APLL_LOSS_LOCK_LIVE_LOCKED
-		    && dpll == DPLL_STATE_LOCKED) {
+		if (apll == SYS_APLL_LOSS_LOCK_LIVE_LOCKED &&
+		    dpll == DPLL_STATE_LOCKED) {
 			return 0;
 		} else if (dpll == DPLL_STATE_FREERUN ||
 			   dpll == DPLL_STATE_HOLDOVER ||
@@ -388,13 +407,14 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 			  struct timespec64 *ts)
 {
 	struct idtcm *idtcm = channel->idtcm;
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_PRIMARY_CMD);
 	u8 buf[TOD_BYTE_COUNT];
 	u8 timeout = 10;
 	u8 trigger;
 	int err;
 
 	err = idtcm_read(idtcm, channel->tod_read_primary,
-			 TOD_READ_PRIMARY_CMD, &trigger, sizeof(trigger));
+			 tod_read_cmd, &trigger, sizeof(trigger));
 	if (err)
 		return err;
 
@@ -403,7 +423,7 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 	trigger &= ~TOD_READ_TRIGGER_MODE; /* single shot */
 
 	err = idtcm_write(idtcm, channel->tod_read_primary,
-			  TOD_READ_PRIMARY_CMD, &trigger, sizeof(trigger));
+			  tod_read_cmd, &trigger, sizeof(trigger));
 	if (err)
 		return err;
 
@@ -413,7 +433,7 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 			idtcm->start_time = ktime_get_raw();
 
 		err = idtcm_read(idtcm, channel->tod_read_primary,
-				 TOD_READ_PRIMARY_CMD, &trigger,
+				 tod_read_cmd, &trigger,
 				 sizeof(trigger));
 		if (err)
 			return err;
@@ -559,35 +579,10 @@ static int _sync_pll_output(struct idtcm *idtcm,
 	return err;
 }
 
-static int sync_source_dpll_tod_pps(u16 tod_addr, u8 *sync_src)
-{
-	int err = 0;
-
-	switch (tod_addr) {
-	case TOD_0:
-		*sync_src = SYNC_SOURCE_DPLL0_TOD_PPS;
-		break;
-	case TOD_1:
-		*sync_src = SYNC_SOURCE_DPLL1_TOD_PPS;
-		break;
-	case TOD_2:
-		*sync_src = SYNC_SOURCE_DPLL2_TOD_PPS;
-		break;
-	case TOD_3:
-		*sync_src = SYNC_SOURCE_DPLL3_TOD_PPS;
-		break;
-	default:
-		err = -EINVAL;
-	}
-
-	return err;
-}
-
 static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	u8 pll;
-	u8 sync_src;
 	u8 qn;
 	u8 qn_plus_1;
 	int err = 0;
@@ -596,10 +591,6 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	u8 temp;
 	u16 output_mask = channel->output_mask;
 
-	err = sync_source_dpll_tod_pps(channel->tod_n, &sync_src);
-	if (err)
-		return err;
-
 	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
 			 &temp, sizeof(temp));
 	if (err)
@@ -655,8 +646,8 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 		}
 
 		if (qn != 0 || qn_plus_1 != 0)
-			err = _sync_pll_output(idtcm, pll, sync_src, qn,
-					       qn_plus_1);
+			err = _sync_pll_output(idtcm, pll, channel->sync_src,
+					       qn, qn_plus_1);
 
 		if (err)
 			return err;
@@ -793,46 +784,46 @@ static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
 	return 0;
 }
 
-static int get_output_base_addr(u8 outn)
+static int get_output_base_addr(enum fw_version ver, u8 outn)
 {
 	int base;
 
 	switch (outn) {
 	case 0:
-		base = OUTPUT_0;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_0);
 		break;
 	case 1:
-		base = OUTPUT_1;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_1);
 		break;
 	case 2:
-		base = OUTPUT_2;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_2);
 		break;
 	case 3:
-		base = OUTPUT_3;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_3);
 		break;
 	case 4:
-		base = OUTPUT_4;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_4);
 		break;
 	case 5:
-		base = OUTPUT_5;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_5);
 		break;
 	case 6:
-		base = OUTPUT_6;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_6);
 		break;
 	case 7:
-		base = OUTPUT_7;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_7);
 		break;
 	case 8:
-		base = OUTPUT_8;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_8);
 		break;
 	case 9:
-		base = OUTPUT_9;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_9);
 		break;
 	case 10:
-		base = OUTPUT_10;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_10);
 		break;
 	case 11:
-		base = OUTPUT_11;
+		base = IDTCM_FW_REG(ver, V520, OUTPUT_11);
 		break;
 	default:
 		base = -EINVAL;
@@ -1032,7 +1023,9 @@ static int idtcm_state_machine_reset(struct idtcm *idtcm)
 
 	clear_boot_status(idtcm);
 
-	err = idtcm_write(idtcm, RESET_CTRL, SM_RESET, &byte, sizeof(byte));
+	err = idtcm_write(idtcm, RESET_CTRL,
+			  IDTCM_FW_REG(idtcm->fw_ver, V520, SM_RESET),
+			  &byte, sizeof(byte));
 
 	if (!err) {
 		for (i = 0; i < 30; i++) {
@@ -1214,6 +1207,7 @@ static void display_pll_and_masks(struct idtcm *idtcm)
 static int idtcm_load_firmware(struct idtcm *idtcm,
 			       struct device *dev)
 {
+	u16 scratch = IDTCM_FW_REG(idtcm->fw_ver, V520, SCRATCH);
 	char fname[128] = FW_FILENAME;
 	const struct firmware *fw;
 	struct idtcm_fwrc *rec;
@@ -1239,7 +1233,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 
 	rec = (struct idtcm_fwrc *) fw->data;
 
-	if (contains_full_configuration(fw))
+	if (contains_full_configuration(idtcm, fw))
 		idtcm_state_machine_reset(idtcm);
 
 	for (len = fw->size; len > 0; len -= sizeof(*rec)) {
@@ -1263,7 +1257,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 			err = 0;
 
 			/* Top (status registers) and bottom are read-only */
-			if (regaddr < GPIO_USER_CONTROL || regaddr >= SCRATCH)
+			if (regaddr < GPIO_USER_CONTROL || regaddr >= scratch)
 				continue;
 
 			/* Page size 128, last 4 bytes of page skipped */
@@ -1292,7 +1286,7 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	int err;
 	u8 val;
 
-	base = get_output_base_addr(outn);
+	base = get_output_base_addr(idtcm->fw_ver, outn);
 
 	if (!(base > 0)) {
 		dev_err(&idtcm->client->dev,
@@ -1366,7 +1360,8 @@ static int idtcm_get_pll_mode(struct idtcm_channel *channel,
 	int err;
 	u8 dpll_mode;
 
-	err = idtcm_read(idtcm, channel->dpll_n, DPLL_MODE,
+	err = idtcm_read(idtcm, channel->dpll_n,
+			 IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_MODE),
 			 &dpll_mode, sizeof(dpll_mode));
 	if (err)
 		return err;
@@ -1383,7 +1378,8 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 	int err;
 	u8 dpll_mode;
 
-	err = idtcm_read(idtcm, channel->dpll_n, DPLL_MODE,
+	err = idtcm_read(idtcm, channel->dpll_n,
+			 IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_MODE),
 			 &dpll_mode, sizeof(dpll_mode));
 	if (err)
 		return err;
@@ -1394,7 +1390,8 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 
 	channel->pll_mode = pll_mode;
 
-	err = idtcm_write(idtcm, channel->dpll_n, DPLL_MODE,
+	err = idtcm_write(idtcm, channel->dpll_n,
+			  IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_MODE),
 			  &dpll_mode, sizeof(dpll_mode));
 	if (err)
 		return err;
@@ -1404,8 +1401,8 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 
 /* PTP Hardware Clock interface */
 
-/*
- * Maximum absolute value for write phase offset in picoseconds
+/**
+ * @brief Maximum absolute value for write phase offset in picoseconds
  *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
@@ -1679,23 +1676,31 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	struct timespec64 ts = {0, 0};
+	u16 tod_cfg = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_CFG);
 	u8 cfg;
 	int err;
 
+	/* STEELAI-366 - Temporary workaround for ts2phc compatibility */
+	if (0) {
+		err = idtcm_output_mask_enable(channel, false);
+		if (err)
+			return err;
+	}
+
 	/*
 	 * Start the TOD clock ticking.
 	 */
-	err = idtcm_read(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
+	err = idtcm_read(idtcm, channel->tod_n, tod_cfg, &cfg, sizeof(cfg));
 	if (err)
 		return err;
 
 	cfg |= TOD_ENABLE;
 
-	err = idtcm_write(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
+	err = idtcm_write(idtcm, channel->tod_n, tod_cfg, &cfg, sizeof(cfg));
 	if (err)
 		return err;
 
-	if (idtcm->deprecated)
+	if (idtcm->fw_ver < V487)
 		return _idtcm_settime_deprecated(channel, &ts);
 	else
 		return _idtcm_settime(channel, &ts,
@@ -1723,10 +1728,7 @@ static void idtcm_set_version_info(struct idtcm *idtcm)
 	snprintf(idtcm->version, sizeof(idtcm->version), "%u.%u.%u",
 		 major, minor, hotfix);
 
-	if (idtcm_strverscmp(idtcm->version, "4.8.7") >= 0)
-		idtcm->deprecated = 0;
-	else
-		idtcm->deprecated = 1;
+	idtcm->fw_ver = idtcm_fw_version(idtcm->version);
 
 	dev_info(&idtcm->client->dev,
 		 "%d.%d.%d, Id: 0x%04x  HW Rev: %d  OTP Config Select: %d",
@@ -1760,6 +1762,7 @@ static const struct ptp_clock_info idtcm_caps_deprecated = {
 
 static int configure_channel_pll(struct idtcm_channel *channel)
 {
+	struct idtcm *idtcm = channel->idtcm;
 	int err = 0;
 
 	switch (channel->pll) {
@@ -1781,7 +1784,7 @@ static int configure_channel_pll(struct idtcm_channel *channel)
 		break;
 	case 2:
 		channel->dpll_freq = DPLL_FREQ_2;
-		channel->dpll_n = DPLL_2;
+		channel->dpll_n = IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_2);
 		channel->hw_dpll_n = HW_DPLL_2;
 		channel->dpll_phase = DPLL_PHASE_2;
 		channel->dpll_ctrl_n = DPLL_CTRL_2;
@@ -1797,7 +1800,7 @@ static int configure_channel_pll(struct idtcm_channel *channel)
 		break;
 	case 4:
 		channel->dpll_freq = DPLL_FREQ_4;
-		channel->dpll_n = DPLL_4;
+		channel->dpll_n = IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_4);
 		channel->hw_dpll_n = HW_DPLL_4;
 		channel->dpll_phase = DPLL_PHASE_4;
 		channel->dpll_ctrl_n = DPLL_CTRL_4;
@@ -1813,7 +1816,7 @@ static int configure_channel_pll(struct idtcm_channel *channel)
 		break;
 	case 6:
 		channel->dpll_freq = DPLL_FREQ_6;
-		channel->dpll_n = DPLL_6;
+		channel->dpll_n = IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_6);
 		channel->hw_dpll_n = HW_DPLL_6;
 		channel->dpll_phase = DPLL_PHASE_6;
 		channel->dpll_ctrl_n = DPLL_CTRL_6;
@@ -1836,6 +1839,7 @@ static int configure_channel_pll(struct idtcm_channel *channel)
 
 static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 {
+	enum fw_version fw_ver = idtcm->fw_ver;
 	struct idtcm_channel *channel;
 	int err;
 
@@ -1843,6 +1847,7 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 		return -EINVAL;
 
 	channel = &idtcm->channel[index];
+	channel->idtcm = idtcm;
 
 	/* Set pll addresses */
 	err = configure_channel_pll(channel);
@@ -1852,32 +1857,34 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	/* Set tod addresses */
 	switch (index) {
 	case 0:
-		channel->tod_read_primary = TOD_READ_PRIMARY_0;
-		channel->tod_write = TOD_WRITE_0;
-		channel->tod_n = TOD_0;
+		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_0);
+		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_0);
+		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_0);
+		channel->sync_src = SYNC_SOURCE_DPLL0_TOD_PPS;
 		break;
 	case 1:
-		channel->tod_read_primary = TOD_READ_PRIMARY_1;
-		channel->tod_write = TOD_WRITE_1;
-		channel->tod_n = TOD_1;
+		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_1);
+		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_1);
+		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_1);
+		channel->sync_src = SYNC_SOURCE_DPLL1_TOD_PPS;
 		break;
 	case 2:
-		channel->tod_read_primary = TOD_READ_PRIMARY_2;
-		channel->tod_write = TOD_WRITE_2;
-		channel->tod_n = TOD_2;
+		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_2);
+		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_2);
+		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_2);
+		channel->sync_src = SYNC_SOURCE_DPLL2_TOD_PPS;
 		break;
 	case 3:
-		channel->tod_read_primary = TOD_READ_PRIMARY_3;
-		channel->tod_write = TOD_WRITE_3;
-		channel->tod_n = TOD_3;
+		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_3);
+		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_3);
+		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_3);
+		channel->sync_src = SYNC_SOURCE_DPLL3_TOD_PPS;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	channel->idtcm = idtcm;
-
-	if (idtcm->deprecated)
+	if (idtcm->fw_ver < V487)
 		channel->caps = idtcm_caps_deprecated;
 	else
 		channel->caps = idtcm_caps;
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index fb32327..843a9d7 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -57,10 +57,10 @@
 
 #define IDTCM_MAX_WRITE_COUNT		(512)
 
-#define FULL_FW_CFG_BYTES		(SCRATCH - GPIO_USER_CONTROL)
-#define FULL_FW_CFG_SKIPPED_BYTES	(((SCRATCH >> 7) \
-					  - (GPIO_USER_CONTROL >> 7)) \
-					 * 4) /* 4 bytes skipped every 0x80 */
+/*
+ * Return register address based on passed in firmware version
+ */
+#define IDTCM_FW_REG(FW, VER, REG)	(((FW) < (VER)) ? (REG) : (REG##_##VER))
 
 /* Values of DPLL_N.DPLL_MODE.PLL_MODE */
 enum pll_mode {
@@ -119,6 +119,12 @@ enum dpll_state {
 	DPLL_STATE_MAX = DPLL_STATE_OPEN_LOOP,
 };
 
+enum fw_version {
+	V_DEFAULT = 0,
+	V487 = 1,
+	V520 = 2,
+};
+
 struct idtcm;
 
 struct idtcm_channel {
@@ -134,6 +140,7 @@ struct idtcm_channel {
 	u16			tod_write;
 	u16			tod_n;
 	u16			hw_dpll_n;
+	u8			sync_src;
 	enum pll_mode		pll_mode;
 	u8			pll;
 	u16			output_mask;
@@ -145,7 +152,7 @@ struct idtcm {
 	u8			page_offset;
 	u8			tod_mask;
 	char			version[16];
-	u8			deprecated;
+	enum fw_version		fw_ver;
 
 	/* Overhead calculation for adjtime */
 	u8			calculate_overhead_flag;
-- 
2.7.4

