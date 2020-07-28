Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA842313FF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgG1Udn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:33:43 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:47640 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgG1Udm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:33:42 -0400
X-Greylist: delayed 1961 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2020 16:33:39 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 06SJqKuS016206;
        Tue, 28 Jul 2020 16:00:57 -0400
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 32gewc9ba1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 16:00:56 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 28 Jul 2020 16:00:55 -0400
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 28 Jul 2020 16:00:54 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net] ptp: ptp_clockmatrix: update to support 4.8.7 firmware
Date:   Tue, 28 Jul 2020 16:00:30 -0400
Message-ID: <1595966430-8603-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_16:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2007280140
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

With 4.8.7 firmware, adjtime can change delta instead of absolute time,
which greately increases snap accuracy. PPS alignment doesn't have to
be set for every single TOD change. Other minor changes includes:
adding more debug logs, increasing snap accuracy for pre 4.8.7 firmware
and supporting new tcs2bin format.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/idt8a340_reg.h    |   48 ++
 drivers/ptp/ptp_clockmatrix.c | 1151 ++++++++++++++++++++++++++++++++++-------
 drivers/ptp/ptp_clockmatrix.h |   61 ++-
 3 files changed, 1048 insertions(+), 212 deletions(-)

diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
index 69eedda..b297c4a 100644
--- a/drivers/ptp/idt8a340_reg.h
+++ b/drivers/ptp/idt8a340_reg.h
@@ -20,6 +20,10 @@
 #define HW_DPLL_1                         (0x8b00)
 #define HW_DPLL_2                         (0x8c00)
 #define HW_DPLL_3                         (0x8d00)
+#define HW_DPLL_4                         (0x8e00)
+#define HW_DPLL_5                         (0x8f00)
+#define HW_DPLL_6                         (0x9000)
+#define HW_DPLL_7                         (0x9100)
 
 #define HW_DPLL_TOD_SW_TRIG_ADDR__0       (0x080)
 #define HW_DPLL_TOD_CTRL_1                (0x089)
@@ -57,6 +61,43 @@
 #define SYNCTRL1_Q1_DIV_SYNC_TRIG	BIT(1)
 #define SYNCTRL1_Q0_DIV_SYNC_TRIG	BIT(0)
 
+#define HW_Q8_CTRL_SPARE  (0xa7d4)
+#define HW_Q11_CTRL_SPARE (0xa7ec)
+
+/**
+ * Select FOD5 as sync_trigger for Q8 divider.
+ * Transition from logic zero to one
+ * sets trigger to sync Q8 divider.
+ *
+ * Unused when FOD4 is driving Q8 divider (normal operation).
+ */
+#define Q9_TO_Q8_SYNC_TRIG  BIT(1)
+
+/**
+ * Enable FOD5 as driver for clock and sync for Q8 divider.
+ * Enable fanout buffer for FOD5.
+ *
+ * Unused when FOD4 is driving Q8 divider (normal operation).
+ */
+#define Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK  (BIT(0) | BIT(2))
+
+/**
+ * Select FOD6 as sync_trigger for Q11 divider.
+ * Transition from logic zero to one
+ * sets trigger to sync Q11 divider.
+ *
+ * Unused when FOD7 is driving Q11 divider (normal operation).
+ */
+#define Q10_TO_Q11_SYNC_TRIG  BIT(1)
+
+/**
+ * Enable FOD6 as driver for clock and sync for Q11 divider.
+ * Enable fanout buffer for FOD6.
+ *
+ * Unused when FOD7 is driving Q11 divider (normal operation).
+ */
+#define Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK  (BIT(0) | BIT(2))
+
 #define RESET_CTRL                        0xc000
 #define SM_RESET                          0x0012
 #define SM_RESET_CMD                      0x5A
@@ -191,6 +232,7 @@
 
 #define DPLL_CTRL_0                       0xc600
 #define DPLL_CTRL_DPLL_MANU_REF_CFG       0x0001
+#define DPLL_CTRL_COMBO_MASTER_CFG        0x003a
 
 #define DPLL_CTRL_1                       0xc63c
 
@@ -646,6 +688,9 @@
 /* Bit definitions for the TOD_WRITE_CMD register */
 #define TOD_WRITE_SELECTION_SHIFT         (0)
 #define TOD_WRITE_SELECTION_MASK          (0xf)
+/* 4.8.7 */
+#define TOD_WRITE_TYPE_SHIFT              (4)
+#define TOD_WRITE_TYPE_MASK               (0x3)
 
 /* Bit definitions for the TOD_READ_PRIMARY_SEL_CFG_0 register */
 #define RD_PWM_DECODER_INDEX_SHIFT        (4)
@@ -658,4 +703,7 @@
 #define TOD_READ_TRIGGER_SHIFT            (0)
 #define TOD_READ_TRIGGER_MASK             (0xf)
 
+/* Bit definitions for the DPLL_CTRL_COMBO_MASTER_CFG register */
+#define COMBO_MASTER_HOLD                 BIT(0)
+
 #endif
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index ceb6bc5..73aaae5 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -13,6 +13,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/timekeeping.h>
+#include <linux/string.h>
 
 #include "ptp_private.h"
 #include "ptp_clockmatrix.h"
@@ -23,6 +24,13 @@ MODULE_AUTHOR("IDT support-1588 <IDT-support-1588@lm.renesas.com>");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
 
+/*
+ * The name of the firmware file to be loaded
+ * over-rides any automatic selection
+ */
+static char *firmware;
+module_param(firmware, charp, 0);
+
 #define SETTIME_CORRECTION (0)
 
 static long set_write_phase_ready(struct ptp_clock_info *ptp)
@@ -95,6 +103,45 @@ static int timespec_to_char_array(struct timespec64 const *ts,
 	return 0;
 }
 
+static int idtcm_strverscmp(const char *ver1, const char *ver2)
+{
+	u8 num1;
+	u8 num2;
+	int result = 0;
+
+	/* loop through each level of the version string */
+	while (result == 0) {
+		/* extract leading version numbers */
+		if (kstrtou8(ver1, 10, &num1) < 0)
+			return -1;
+
+		if (kstrtou8(ver2, 10, &num2) < 0)
+			return -1;
+
+		/* if numbers differ, then set the result */
+		if (num1 < num2)
+			result = -1;
+		else if (num1 > num2)
+			result = 1;
+		else {
+			/* if numbers are the same, go to next level */
+			ver1 = strchr(ver1, '.');
+			ver2 = strchr(ver2, '.');
+			if (!ver1 && !ver2)
+				break;
+			else if (!ver1)
+				result = -1;
+			else if (!ver2)
+				result = 1;
+			else {
+				ver1++;
+				ver2++;
+			}
+		}
+	}
+	return result;
+}
+
 static int idtcm_xfer(struct idtcm *idtcm,
 		      u8 regaddr,
 		      u8 *buf,
@@ -104,6 +151,7 @@ static int idtcm_xfer(struct idtcm *idtcm,
 	struct i2c_client *client = idtcm->client;
 	struct i2c_msg msg[2];
 	int cnt;
+	char *fmt = "i2c_transfer failed at %d in %s for %s, at addr: %04X!\n";
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
@@ -118,7 +166,12 @@ static int idtcm_xfer(struct idtcm *idtcm,
 	cnt = i2c_transfer(client->adapter, msg, 2);
 
 	if (cnt < 0) {
-		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
+		dev_err(&client->dev,
+			fmt,
+			__LINE__,
+			__func__,
+			write ? "write" : "read",
+			regaddr);
 		return cnt;
 	} else if (cnt != 2) {
 		dev_err(&client->dev,
@@ -144,10 +197,12 @@ static int idtcm_page_offset(struct idtcm *idtcm, u8 val)
 
 	err = idtcm_xfer(idtcm, PAGE_ADDR, buf, sizeof(buf), 1);
 
-	if (err)
+	if (err) {
+		idtcm->page_offset = 0xff;
 		dev_err(&idtcm->client->dev, "failed to set page offset\n");
-	else
+	} else {
 		idtcm->page_offset = val;
+	}
 
 	return err;
 }
@@ -198,6 +253,7 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 {
 	struct idtcm *idtcm = channel->idtcm;
 	u8 buf[TOD_BYTE_COUNT];
+	u8 timeout = 10;
 	u8 trigger;
 	int err;
 
@@ -208,16 +264,29 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 
 	trigger &= ~(TOD_READ_TRIGGER_MASK << TOD_READ_TRIGGER_SHIFT);
 	trigger |= (1 << TOD_READ_TRIGGER_SHIFT);
-	trigger |= TOD_READ_TRIGGER_MODE;
+	trigger &= ~TOD_READ_TRIGGER_MODE; /* single shot */
 
 	err = idtcm_write(idtcm, channel->tod_read_primary,
 			  TOD_READ_PRIMARY_CMD, &trigger, sizeof(trigger));
-
 	if (err)
 		return err;
 
-	if (idtcm->calculate_overhead_flag)
-		idtcm->start_time = ktime_get_raw();
+	/* wait trigger to be 0 */
+	while (trigger & TOD_READ_TRIGGER_MASK) {
+
+		if (idtcm->calculate_overhead_flag)
+			idtcm->start_time = ktime_get_raw();
+
+		err = idtcm_read(idtcm, channel->tod_read_primary,
+				 TOD_READ_PRIMARY_CMD, &trigger,
+				 sizeof(trigger));
+
+		if (err)
+			return err;
+
+		if (--timeout == 0)
+			return -EIO;
+	}
 
 	err = idtcm_read(idtcm, channel->tod_read_primary,
 			 TOD_READ_PRIMARY, buf, sizeof(buf));
@@ -240,6 +309,7 @@ static int _sync_pll_output(struct idtcm *idtcm,
 	u8 val;
 	u16 sync_ctrl0;
 	u16 sync_ctrl1;
+	u8 temp;
 
 	if ((qn == 0) && (qn_plus_1 == 0))
 		return 0;
@@ -305,6 +375,50 @@ static int _sync_pll_output(struct idtcm *idtcm,
 	if (err)
 		return err;
 
+	/* PLL5 can have OUT8 as second additional output. */
+	if ((pll == 5) && (qn_plus_1 != 0)) {
+		err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
+				 &temp, sizeof(temp));
+		if (err)
+			return err;
+
+		temp &= ~(Q9_TO_Q8_SYNC_TRIG);
+
+		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
+				  &temp, sizeof(temp));
+		if (err)
+			return err;
+
+		temp |= Q9_TO_Q8_SYNC_TRIG;
+
+		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
+				  &temp, sizeof(temp));
+		if (err)
+			return err;
+	}
+
+	/* PLL6 can have OUT11 as second additional output. */
+	if ((pll == 6) && (qn_plus_1 != 0)) {
+		err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
+				 &temp, sizeof(temp));
+		if (err)
+			return err;
+
+		temp &= ~(Q10_TO_Q11_SYNC_TRIG);
+
+		err = idtcm_write(idtcm, 0, HW_Q11_CTRL_SPARE,
+				  &temp, sizeof(temp));
+		if (err)
+			return err;
+
+		temp |= Q10_TO_Q11_SYNC_TRIG;
+
+		err = idtcm_write(idtcm, 0, HW_Q11_CTRL_SPARE,
+				  &temp, sizeof(temp));
+		if (err)
+			return err;
+	}
+
 	/* Place master sync out of reset */
 	val &= ~(SYNCTRL1_MASTER_SYNC_RST);
 	err = idtcm_write(idtcm, 0, sync_ctrl1, &val, sizeof(val));
@@ -312,6 +426,30 @@ static int _sync_pll_output(struct idtcm *idtcm,
 	return err;
 }
 
+static int sync_source_dpll_tod_pps(u16 tod_addr, u8 *sync_src)
+{
+	int err = 0;
+
+	switch (tod_addr) {
+	case TOD_0:
+		*sync_src = SYNC_SOURCE_DPLL0_TOD_PPS;
+		break;
+	case TOD_1:
+		*sync_src = SYNC_SOURCE_DPLL1_TOD_PPS;
+		break;
+	case TOD_2:
+		*sync_src = SYNC_SOURCE_DPLL2_TOD_PPS;
+		break;
+	case TOD_3:
+		*sync_src = SYNC_SOURCE_DPLL3_TOD_PPS;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 {
 	struct idtcm *idtcm = channel->idtcm;
@@ -321,37 +459,68 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	u8 qn;
 	u8 qn_plus_1;
 	int err = 0;
+	u8 out8_mux = 0;
+	u8 out11_mux = 0;
+	u8 temp;
 
 	u16 output_mask = channel->output_mask;
 
-	switch (channel->dpll_n) {
-	case DPLL_0:
-		sync_src = SYNC_SOURCE_DPLL0_TOD_PPS;
-		break;
-	case DPLL_1:
-		sync_src = SYNC_SOURCE_DPLL1_TOD_PPS;
-		break;
-	case DPLL_2:
-		sync_src = SYNC_SOURCE_DPLL2_TOD_PPS;
-		break;
-	case DPLL_3:
-		sync_src = SYNC_SOURCE_DPLL3_TOD_PPS;
-		break;
-	default:
-		return -EINVAL;
-	}
+	err = sync_source_dpll_tod_pps(channel->tod_n, &sync_src);
+	if (err)
+		return err;
 
-	for (pll = 0; pll < 8; pll++) {
+	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
+			 &temp, sizeof(temp));
+	if (err)
+		return err;
+
+	if ((temp & Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK) ==
+	    Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
+		out8_mux = 1;
+
+	err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
+			 &temp, sizeof(temp));
+	if (err)
+		return err;
+
+	if ((temp & Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK) ==
+	    Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
+		out11_mux = 1;
 
-		qn = output_mask & 0x1;
-		output_mask = output_mask >> 1;
+	for (pll = 0; pll < 8; pll++) {
+		qn = 0;
+		qn_plus_1 = 0;
 
 		if (pll < 4) {
 			/* First 4 pll has 2 outputs */
+			qn = output_mask & 0x1;
+			output_mask = output_mask >> 1;
 			qn_plus_1 = output_mask & 0x1;
 			output_mask = output_mask >> 1;
-		} else {
-			qn_plus_1 = 0;
+		} else if (pll == 4) {
+			if (out8_mux == 0) {
+				qn = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
+		} else if (pll == 5) {
+			if (out8_mux) {
+				qn_plus_1 = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
+			qn = output_mask & 0x1;
+			output_mask = output_mask >> 1;
+		} else if (pll == 6) {
+			qn = output_mask & 0x1;
+			output_mask = output_mask >> 1;
+			if (out11_mux) {
+				qn_plus_1 = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
+		} else if (pll == 7) {
+			if (out11_mux == 0) {
+				qn = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
 		}
 
 		if ((qn != 0) || (qn_plus_1 != 0))
@@ -365,7 +534,7 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	return err;
 }
 
-static int _idtcm_set_dpll_tod(struct idtcm_channel *channel,
+static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 			       struct timespec64 const *ts,
 			       enum hw_tod_write_trig_sel wr_trig)
 {
@@ -439,17 +608,78 @@ static int _idtcm_set_dpll_tod(struct idtcm_channel *channel,
 	return err;
 }
 
+static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
+				    struct timespec64 const *ts,
+				    enum scsr_tod_write_trig_sel wr_trig,
+				    enum scsr_tod_write_type_sel wr_type)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	unsigned char buf[TOD_BYTE_COUNT], cmd;
+	struct timespec64 local_ts = *ts;
+	int err, count = 0;
+
+	timespec64_add_ns(&local_ts, SETTIME_CORRECTION);
+
+	err = timespec_to_char_array(&local_ts, buf, sizeof(buf));
+
+	if (err)
+		return err;
+
+	err = idtcm_write(idtcm, channel->tod_write, TOD_WRITE,
+			  buf, sizeof(buf));
+	if (err)
+		return err;
+
+	/* Trigger the write operation. */
+	err = idtcm_read(idtcm, channel->tod_write, TOD_WRITE_CMD,
+			 &cmd, sizeof(cmd));
+	if (err)
+		return err;
+
+	cmd &= ~(TOD_WRITE_SELECTION_MASK << TOD_WRITE_SELECTION_SHIFT);
+	cmd &= ~(TOD_WRITE_TYPE_MASK << TOD_WRITE_TYPE_SHIFT);
+	cmd |= (wr_trig << TOD_WRITE_SELECTION_SHIFT);
+	cmd |= (wr_type << TOD_WRITE_TYPE_SHIFT);
+
+	err = idtcm_write(idtcm, channel->tod_write, TOD_WRITE_CMD,
+			   &cmd, sizeof(cmd));
+	if (err)
+		return err;
+
+	/* Wait for the operation to complete. */
+	while (1) {
+		/* pps trigger takes up to 1 sec to complete */
+		if (wr_trig == SCSR_TOD_WR_TRIG_SEL_TODPPS)
+			msleep(50);
+
+		err = idtcm_read(idtcm, channel->tod_write, TOD_WRITE_CMD,
+				 &cmd, sizeof(cmd));
+		if (err)
+			return err;
+
+		if (cmd == 0)
+			break;
+
+		if (++count > 20) {
+			dev_err(&idtcm->client->dev,
+				"Timed out waiting for the write counter\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 static int _idtcm_settime(struct idtcm_channel *channel,
 			  struct timespec64 const *ts,
 			  enum hw_tod_write_trig_sel wr_trig)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	s32 retval;
 	int err;
 	int i;
 	u8 trig_sel;
 
-	err = _idtcm_set_dpll_tod(channel, ts, wr_trig);
+	err = _idtcm_set_dpll_hw_tod(channel, ts, wr_trig);
 
 	if (err)
 		return err;
@@ -469,12 +699,24 @@ static int _idtcm_settime(struct idtcm_channel *channel,
 		err = 1;
 	}
 
-	if (err)
+	if (err) {
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
-	retval = idtcm_sync_pps_output(channel);
+	return idtcm_sync_pps_output(channel);
+}
 
-	return retval;
+static int _idtcm_settime_v487(struct idtcm_channel *channel,
+			       struct timespec64 const *ts,
+			       enum scsr_tod_write_type_sel wr_type)
+{
+	return _idtcm_set_dpll_scsr_tod(channel, ts,
+					SCSR_TOD_WR_TRIG_SEL_IMMEDIATE,
+					wr_type);
 }
 
 static int idtcm_set_phase_pull_in_offset(struct idtcm_channel *channel,
@@ -565,6 +807,50 @@ static int idtcm_do_phase_pull_in(struct idtcm_channel *channel,
 	return err;
 }
 
+static int set_tod_write_overhead(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	s64 current_ns = 0;
+	s64 lowest_ns = 0;
+	int err;
+	u8 i;
+
+	ktime_t start;
+	ktime_t stop;
+
+	char buf[TOD_BYTE_COUNT] = {0};
+
+	/* Set page offset */
+	idtcm_write(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_OVR__0,
+		    buf, sizeof(buf));
+
+	for (i = 0; i < TOD_WRITE_OVERHEAD_COUNT_MAX; i++) {
+
+		start = ktime_get_raw();
+
+		err = idtcm_write(idtcm, channel->hw_dpll_n,
+				  HW_DPLL_TOD_OVR__0, buf, sizeof(buf));
+
+		if (err)
+			return err;
+
+		stop = ktime_get_raw();
+
+		current_ns = ktime_to_ns(stop - start);
+
+		if (i == 0) {
+			lowest_ns = current_ns;
+		} else {
+			if (current_ns < lowest_ns)
+				lowest_ns = current_ns;
+		}
+	}
+
+	idtcm->tod_write_overhead_ns = lowest_ns;
+
+	return err;
+}
+
 static int _idtcm_adjtime(struct idtcm_channel *channel, s64 delta)
 {
 	int err;
@@ -577,6 +863,11 @@ static int _idtcm_adjtime(struct idtcm_channel *channel, s64 delta)
 	} else {
 		idtcm->calculate_overhead_flag = 1;
 
+		err = set_tod_write_overhead(channel);
+
+		if (err)
+			return err;
+
 		err = _idtcm_gettime(channel, &ts);
 
 		if (err)
@@ -656,93 +947,118 @@ static int idtcm_read_otp_scsr_config_select(struct idtcm *idtcm,
 			  config_select, sizeof(u8));
 }
 
-static int process_pll_mask(struct idtcm *idtcm, u32 addr, u8 val, u8 *mask)
-{
-	int err = 0;
-
-	if (addr == PLL_MASK_ADDR) {
-		if ((val & 0xf0) || !(val & 0xf)) {
-			dev_err(&idtcm->client->dev,
-				"Invalid PLL mask 0x%hhx\n", val);
-			err = -EINVAL;
-		}
-		*mask = val;
-	}
-
-	return err;
-}
-
 static int set_pll_output_mask(struct idtcm *idtcm, u16 addr, u8 val)
 {
 	int err = 0;
 
 	switch (addr) {
-	case OUTPUT_MASK_PLL0_ADDR:
+	case TOD0_OUT_ALIGN_MASK_ADDR:
 		SET_U16_LSB(idtcm->channel[0].output_mask, val);
 		break;
-	case OUTPUT_MASK_PLL0_ADDR + 1:
+	case TOD0_OUT_ALIGN_MASK_ADDR + 1:
 		SET_U16_MSB(idtcm->channel[0].output_mask, val);
 		break;
-	case OUTPUT_MASK_PLL1_ADDR:
+	case TOD1_OUT_ALIGN_MASK_ADDR:
 		SET_U16_LSB(idtcm->channel[1].output_mask, val);
 		break;
-	case OUTPUT_MASK_PLL1_ADDR + 1:
+	case TOD1_OUT_ALIGN_MASK_ADDR + 1:
 		SET_U16_MSB(idtcm->channel[1].output_mask, val);
 		break;
-	case OUTPUT_MASK_PLL2_ADDR:
+	case TOD2_OUT_ALIGN_MASK_ADDR:
 		SET_U16_LSB(idtcm->channel[2].output_mask, val);
 		break;
-	case OUTPUT_MASK_PLL2_ADDR + 1:
+	case TOD2_OUT_ALIGN_MASK_ADDR + 1:
 		SET_U16_MSB(idtcm->channel[2].output_mask, val);
 		break;
-	case OUTPUT_MASK_PLL3_ADDR:
+	case TOD3_OUT_ALIGN_MASK_ADDR:
 		SET_U16_LSB(idtcm->channel[3].output_mask, val);
 		break;
-	case OUTPUT_MASK_PLL3_ADDR + 1:
+	case TOD3_OUT_ALIGN_MASK_ADDR + 1:
 		SET_U16_MSB(idtcm->channel[3].output_mask, val);
 		break;
 	default:
-		err = -EINVAL;
+		err = -EFAULT; /* Bad address */;
 		break;
 	}
 
 	return err;
 }
 
+static int set_tod_ptp_pll(struct idtcm *idtcm, u8 index, u8 pll)
+{
+	if (index >= MAX_TOD) {
+		dev_err(&idtcm->client->dev, "ToD%d not supported\n", index);
+		return -EINVAL;
+	}
+
+	if (pll >= MAX_PLL) {
+		dev_err(&idtcm->client->dev, "Pll%d not supported\n", pll);
+		return -EINVAL;
+	}
+
+	idtcm->channel[index].pll = pll;
+
+	return 0;
+}
+
 static int check_and_set_masks(struct idtcm *idtcm,
 			       u16 regaddr,
 			       u8 val)
 {
 	int err = 0;
 
-	if (set_pll_output_mask(idtcm, regaddr, val)) {
-		/* Not an output mask, check for pll mask */
-		err = process_pll_mask(idtcm, regaddr, val, &idtcm->pll_mask);
+	switch (regaddr) {
+	case TOD_MASK_ADDR:
+		if ((val & 0xf0) || !(val & 0x0f)) {
+			dev_err(&idtcm->client->dev,
+				"Invalid TOD mask 0x%hhx\n", val);
+			err = -EINVAL;
+		} else {
+			idtcm->tod_mask = val;
+		}
+		break;
+	case TOD0_PTP_PLL_ADDR:
+		err = set_tod_ptp_pll(idtcm, 0, val);
+		break;
+	case TOD1_PTP_PLL_ADDR:
+		err = set_tod_ptp_pll(idtcm, 1, val);
+		break;
+	case TOD2_PTP_PLL_ADDR:
+		err = set_tod_ptp_pll(idtcm, 2, val);
+		break;
+	case TOD3_PTP_PLL_ADDR:
+		err = set_tod_ptp_pll(idtcm, 3, val);
+		break;
+	default:
+		err = set_pll_output_mask(idtcm, regaddr, val);
+		break;
 	}
 
 	return err;
 }
 
-static void display_pll_and_output_masks(struct idtcm *idtcm)
+static void display_pll_and_masks(struct idtcm *idtcm)
 {
 	u8 i;
 	u8 mask;
 
-	dev_dbg(&idtcm->client->dev, "pllmask = 0x%02x\n", idtcm->pll_mask);
+	dev_dbg(&idtcm->client->dev, "tod_mask = 0x%02x\n", idtcm->tod_mask);
 
-	for (i = 0; i < MAX_PHC_PLL; i++) {
+	for (i = 0; i < MAX_TOD; i++) {
 		mask = 1 << i;
 
-		if (mask & idtcm->pll_mask)
+		if (mask & idtcm->tod_mask)
 			dev_dbg(&idtcm->client->dev,
-				"PLL%d output_mask = 0x%04x\n",
-				i, idtcm->channel[i].output_mask);
+				"TOD%d pll = %d    output_mask = 0x%04x\n",
+				i, idtcm->channel[i].pll,
+				idtcm->channel[i].output_mask);
 	}
 }
 
 static int idtcm_load_firmware(struct idtcm *idtcm,
 			       struct device *dev)
 {
+	char fname[128] = FW_FILENAME;
 	const struct firmware *fw;
 	struct idtcm_fwrc *rec;
 	u32 regaddr;
@@ -751,12 +1067,20 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 	u8 val;
 	u8 loaddr;
 
-	dev_dbg(&idtcm->client->dev, "requesting firmware '%s'\n", FW_FILENAME);
+	if (firmware) /* module parameter */
+		snprintf(fname, sizeof(fname), "%s", firmware);
 
-	err = request_firmware(&fw, FW_FILENAME, dev);
+	dev_dbg(&idtcm->client->dev, "requesting firmware '%s'\n", fname);
 
-	if (err)
+	err = request_firmware(&fw, fname, dev);
+
+	if (err) {
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	dev_dbg(&idtcm->client->dev, "firmware size %zu bytes\n", fw->size);
 
@@ -783,7 +1107,9 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 			err = check_and_set_masks(idtcm, regaddr, val);
 		}
 
-		if (err == 0) {
+		if (err != -EINVAL) {
+			err = 0;
+
 			/* Top (status registers) and bottom are read-only */
 			if ((regaddr < GPIO_USER_CONTROL)
 			    || (regaddr >= SCRATCH))
@@ -801,42 +1127,22 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 			goto out;
 	}
 
-	display_pll_and_output_masks(idtcm);
+	display_pll_and_masks(idtcm);
 
 out:
 	release_firmware(fw);
 	return err;
 }
 
-static int idtcm_pps_enable(struct idtcm_channel *channel, bool enable)
+static int idtcm_output_enable(struct idtcm_channel *channel,
+			       bool enable, unsigned int outn)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	u32 module;
-	u8 val;
 	int err;
+	u8 val;
 
-	/*
-	 * This assumes that the 1-PPS is on the second of the two
-	 * output.  But is this always true?
-	 */
-	switch (channel->dpll_n) {
-	case DPLL_0:
-		module = OUTPUT_1;
-		break;
-	case DPLL_1:
-		module = OUTPUT_3;
-		break;
-	case DPLL_2:
-		module = OUTPUT_5;
-		break;
-	case DPLL_3:
-		module = OUTPUT_7;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	err = idtcm_read(idtcm, module, OUT_CTRL_1, &val, sizeof(val));
+	err = idtcm_read(idtcm, OUTPUT_MODULE_FROM_INDEX(outn),
+			 OUT_CTRL_1, &val, sizeof(val));
 
 	if (err)
 		return err;
@@ -846,14 +1152,50 @@ static int idtcm_pps_enable(struct idtcm_channel *channel, bool enable)
 	else
 		val &= ~SQUELCH_DISABLE;
 
-	err = idtcm_write(idtcm, module, OUT_CTRL_1, &val, sizeof(val));
+	return idtcm_write(idtcm, OUTPUT_MODULE_FROM_INDEX(outn),
+			   OUT_CTRL_1, &val, sizeof(val));
+}
 
-	if (err)
-		return err;
+static int idtcm_output_mask_enable(struct idtcm_channel *channel,
+				    bool enable)
+{
+	u16 mask;
+	int err;
+	u8 outn;
+
+	mask = channel->output_mask;
+	outn = 0;
+
+	while (mask) {
+
+		if (mask & 0x1) {
+
+			err = idtcm_output_enable(channel, enable, outn);
+
+			if (err)
+				return err;
+		}
+
+		mask >>= 0x1;
+		outn++;
+	}
 
 	return 0;
 }
 
+static int idtcm_perout_enable(struct idtcm_channel *channel,
+			       bool enable,
+			       struct ptp_perout_request *perout)
+{
+	unsigned int flags = perout->flags;
+
+	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
+		return idtcm_output_mask_enable(channel, enable);
+
+	/* Enable/disable individual output instead */
+	return idtcm_output_enable(channel, enable, perout->index);
+}
+
 static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 			      enum pll_mode pll_mode)
 {
@@ -940,10 +1282,8 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 	return err;
 }
 
-static int idtcm_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
 	u8 i;
 	bool neg_adj = 0;
@@ -970,15 +1310,15 @@ static int idtcm_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 	 * FCW = -------------
 	 *         111 * 2^4
 	 */
-	if (ppb < 0) {
+	if (scaled_ppm < 0) {
 		neg_adj = 1;
-		ppb = -ppb;
+		scaled_ppm = -scaled_ppm;
 	}
 
 	/* 2 ^ -53 = 1.1102230246251565404236316680908e-16 */
-	fcw = ppb * 1000000000000ULL;
+	fcw = scaled_ppm * 244140625ULL;
 
-	fcw = div_u64(fcw, 111022);
+	fcw = div_u64(fcw, 1776);
 
 	if (neg_adj)
 		fcw = -fcw;
@@ -988,12 +1328,9 @@ static int idtcm_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 		fcw >>= 8;
 	}
 
-	mutex_lock(&idtcm->reg_lock);
-
 	err = idtcm_write(idtcm, channel->dpll_freq, DPLL_WR_FREQ,
 			  buf, sizeof(buf));
 
-	mutex_unlock(&idtcm->reg_lock);
 	return err;
 }
 
@@ -1008,6 +1345,12 @@ static int idtcm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	err = _idtcm_gettime(channel, ts);
 
+	if (err)
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+
 	mutex_unlock(&idtcm->reg_lock);
 
 	return err;
@@ -1025,12 +1368,19 @@ static int idtcm_settime(struct ptp_clock_info *ptp,
 
 	err = _idtcm_settime(channel, ts, HW_TOD_WR_TRIG_SEL_MSB);
 
+	if (err)
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+
 	mutex_unlock(&idtcm->reg_lock);
 
 	return err;
 }
 
-static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
+static int idtcm_settime_v487(struct ptp_clock_info *ptp,
+			 const struct timespec64 *ts)
 {
 	struct idtcm_channel *channel =
 		container_of(ptp, struct idtcm_channel, caps);
@@ -1039,14 +1389,84 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 	mutex_lock(&idtcm->reg_lock);
 
-	err = _idtcm_adjtime(channel, delta);
+	err = _idtcm_settime_v487(channel, ts, SCSR_TOD_WR_TYPE_SEL_ABSOLUTE);
+
+	if (err)
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 
 	mutex_unlock(&idtcm->reg_lock);
 
 	return err;
 }
 
-static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
+static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm *idtcm = channel->idtcm;
+	int err;
+
+	mutex_lock(&idtcm->reg_lock);
+
+	err = _idtcm_adjtime(channel, delta);
+
+	if (err)
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	return err;
+}
+
+static int idtcm_adjtime_v487(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct idtcm_channel *channel =
+		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm *idtcm = channel->idtcm;
+	struct timespec64 ts;
+	enum scsr_tod_write_type_sel type;
+	int err;
+
+	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS_V487) {
+		err = idtcm_do_phase_pull_in(channel, delta, 0);
+		if (err)
+			dev_err(&idtcm->client->dev,
+				"Failed at line %d in func %s!\n",
+				__LINE__,
+				__func__);
+		return err;
+	}
+
+	if (delta >= 0) {
+		ts = ns_to_timespec64(delta);
+		type = SCSR_TOD_WR_TYPE_SEL_DELTA_PLUS;
+	} else {
+		ts = ns_to_timespec64(-delta);
+		type = SCSR_TOD_WR_TYPE_SEL_DELTA_MINUS;
+	}
+
+	mutex_lock(&idtcm->reg_lock);
+
+	err = _idtcm_settime_v487(channel, &ts, type);
+
+	if (err)
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	return err;
+}
+
+static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
 {
 	struct idtcm_channel *channel =
 		container_of(ptp, struct idtcm_channel, caps);
@@ -1059,6 +1479,36 @@ static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
 
 	err = _idtcm_adjphase(channel, delta);
 
+	if (err)
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+
+	mutex_unlock(&idtcm->reg_lock);
+
+	return err;
+}
+
+static int idtcm_adjfine(struct ptp_clock_info *ptp,  long scaled_ppm)
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
+	err = _idtcm_adjfine(channel, scaled_ppm);
+
+	if (err)
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+
 	mutex_unlock(&idtcm->reg_lock);
 
 	return err;
@@ -1067,20 +1517,35 @@ static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
 static int idtcm_enable(struct ptp_clock_info *ptp,
 			struct ptp_clock_request *rq, int on)
 {
+	int err;
+
 	struct idtcm_channel *channel =
 		container_of(ptp, struct idtcm_channel, caps);
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
-		if (!on)
-			return idtcm_pps_enable(channel, false);
+		if (!on) {
+			err = idtcm_perout_enable(channel, false, &rq->perout);
+			if (err)
+				dev_err(&channel->idtcm->client->dev,
+					"Failed at line %d in func %s!\n",
+					__LINE__,
+					__func__);
+			return err;
+		}
 
 		/* Only accept a 1-PPS aligned to the second. */
 		if (rq->perout.start.nsec || rq->perout.period.sec != 1 ||
 		    rq->perout.period.nsec)
 			return -ERANGE;
 
-		return idtcm_pps_enable(channel, true);
+		err = idtcm_perout_enable(channel, true, &rq->perout);
+		if (err)
+			dev_err(&channel->idtcm->client->dev,
+				"Failed at line %d in func %s!\n",
+				__LINE__,
+				__func__);
+		return err;
 	default:
 		break;
 	}
@@ -1088,17 +1553,237 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 	return -EOPNOTSUPP;
 }
 
-static int idtcm_enable_tod(struct idtcm_channel *channel)
+static int _enable_pll_tod_sync(struct idtcm *idtcm,
+				u8 pll,
+				u8 sync_src,
+				u8 qn,
+				u8 qn_plus_1)
+{
+	int err;
+	u8 val;
+	u16 dpll;
+	u16 out0 = 0, out1 = 0;
+
+	if ((qn == 0) && (qn_plus_1 == 0))
+		return 0;
+
+	switch (pll) {
+	case 0:
+		dpll = DPLL_0;
+		if (qn)
+			out0 = OUTPUT_0;
+		if (qn_plus_1)
+			out1 = OUTPUT_1;
+		break;
+	case 1:
+		dpll = DPLL_1;
+		if (qn)
+			out0 = OUTPUT_2;
+		if (qn_plus_1)
+			out1 = OUTPUT_3;
+		break;
+	case 2:
+		dpll = DPLL_2;
+		if (qn)
+			out0 = OUTPUT_4;
+		if (qn_plus_1)
+			out1 = OUTPUT_5;
+		break;
+	case 3:
+		dpll = DPLL_3;
+		if (qn)
+			out0 = OUTPUT_6;
+		if (qn_plus_1)
+			out1 = OUTPUT_7;
+		break;
+	case 4:
+		dpll = DPLL_4;
+		if (qn)
+			out0 = OUTPUT_8;
+		break;
+	case 5:
+		dpll = DPLL_5;
+		if (qn)
+			out0 = OUTPUT_9;
+		if (qn_plus_1)
+			out1 = OUTPUT_8;
+		break;
+	case 6:
+		dpll = DPLL_6;
+		if (qn)
+			out0 = OUTPUT_10;
+		if (qn_plus_1)
+			out1 = OUTPUT_11;
+		break;
+	case 7:
+		dpll = DPLL_7;
+		if (qn)
+			out0 = OUTPUT_11;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Enable OUTPUT OUT_SYNC.
+	 */
+	if (out0) {
+		err = idtcm_read(idtcm, out0, OUT_CTRL_1, &val, sizeof(val));
+
+		if (err)
+			return err;
+
+		val &= ~OUT_SYNC_DISABLE;
+
+		err = idtcm_write(idtcm, out0, OUT_CTRL_1, &val, sizeof(val));
+
+		if (err)
+			return err;
+	}
+
+	if (out1) {
+		err = idtcm_read(idtcm, out1, OUT_CTRL_1, &val, sizeof(val));
+
+		if (err)
+			return err;
+
+		val &= ~OUT_SYNC_DISABLE;
+
+		err = idtcm_write(idtcm, out1, OUT_CTRL_1, &val, sizeof(val));
+
+		if (err)
+			return err;
+	}
+
+	/* enable dpll sync tod pps, must be set before dpll_mode */
+	err = idtcm_read(idtcm, dpll, DPLL_TOD_SYNC_CFG, &val, sizeof(val));
+	if (err)
+		return err;
+
+	val &= ~(TOD_SYNC_SOURCE_MASK << TOD_SYNC_SOURCE_SHIFT);
+	val |= (sync_src << TOD_SYNC_SOURCE_SHIFT);
+	val |= TOD_SYNC_EN;
+
+	return idtcm_write(idtcm, dpll, DPLL_TOD_SYNC_CFG, &val, sizeof(val));
+}
+
+static int idtcm_enable_tod_sync(struct idtcm_channel *channel)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	struct timespec64 ts = {0, 0};
+
+	u8 pll;
+	u8 sync_src;
+	u8 qn;
+	u8 qn_plus_1;
 	u8 cfg;
-	int err;
+	int err = 0;
+	u16 output_mask = channel->output_mask;
+	u8 out8_mux = 0;
+	u8 out11_mux = 0;
+	u8 temp;
 
-	err = idtcm_pps_enable(channel, false);
+	/*
+	 * set tod_out_sync_enable to 0.
+	 */
+	err = idtcm_read(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
 	if (err)
 		return err;
 
+	cfg &= ~TOD_OUT_SYNC_ENABLE;
+
+	err = idtcm_write(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
+	if (err)
+		return err;
+
+	switch (channel->tod_n) {
+	case TOD_0:
+		sync_src = 0;
+		break;
+	case TOD_1:
+		sync_src = 1;
+		break;
+	case TOD_2:
+		sync_src = 2;
+		break;
+	case TOD_3:
+		sync_src = 3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
+			 &temp, sizeof(temp));
+	if (err)
+		return err;
+
+	if ((temp & Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK) ==
+	    Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
+		out8_mux = 1;
+
+	err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
+			 &temp, sizeof(temp));
+	if (err)
+		return err;
+
+	if ((temp & Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK) ==
+	    Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
+		out11_mux = 1;
+
+	for (pll = 0; pll < 8; pll++) {
+		qn = 0;
+		qn_plus_1 = 0;
+
+		if (pll < 4) {
+			/* First 4 pll has 2 outputs */
+			qn = output_mask & 0x1;
+			output_mask = output_mask >> 1;
+			qn_plus_1 = output_mask & 0x1;
+			output_mask = output_mask >> 1;
+		} else if (pll == 4) {
+			if (out8_mux == 0) {
+				qn = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
+		} else if (pll == 5) {
+			if (out8_mux) {
+				qn_plus_1 = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
+			qn = output_mask & 0x1;
+			output_mask = output_mask >> 1;
+		} else if (pll == 6) {
+			qn = output_mask & 0x1;
+			output_mask = output_mask >> 1;
+			if (out11_mux) {
+				qn_plus_1 = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
+		} else if (pll == 7) {
+			if (out11_mux == 0) {
+				qn = output_mask & 0x1;
+				output_mask = output_mask >> 1;
+			}
+		}
+
+		if ((qn != 0) || (qn_plus_1 != 0))
+			err = _enable_pll_tod_sync(idtcm, pll, sync_src, qn,
+					       qn_plus_1);
+
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int idtcm_enable_tod(struct idtcm_channel *channel)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	struct timespec64 ts = {0, 0};
+	u8 cfg;
+	int err;
+
 	/*
 	 * Start the TOD clock ticking.
 	 */
@@ -1134,16 +1819,32 @@ static void idtcm_display_version_info(struct idtcm *idtcm)
 
 	idtcm_read_otp_scsr_config_select(idtcm, &config_select);
 
+	snprintf(idtcm->version, sizeof(idtcm->version), "%u.%u.%u",
+		 major, minor, hotfix);
+
 	dev_info(&idtcm->client->dev, fmt, major, minor, hotfix,
 		 product_id, hw_rev_id, config_select);
 }
 
+static const struct ptp_clock_info idtcm_caps_v487 = {
+	.owner		= THIS_MODULE,
+	.max_adj	= 244000,
+	.n_per_out	= 12,
+	.adjphase	= &idtcm_adjphase,
+	.adjfine	= &idtcm_adjfine,
+	.adjtime	= &idtcm_adjtime_v487,
+	.gettime64	= &idtcm_gettime,
+	.settime64	= &idtcm_settime_v487,
+	.enable		= &idtcm_enable,
+	.do_aux_work	= &set_write_phase_ready,
+};
+
 static const struct ptp_clock_info idtcm_caps = {
 	.owner		= THIS_MODULE,
 	.max_adj	= 244000,
-	.n_per_out	= 1,
+	.n_per_out	= 12,
 	.adjphase	= &idtcm_adjphase,
-	.adjfreq	= &idtcm_adjfreq,
+	.adjfine	= &idtcm_adjfine,
 	.adjtime	= &idtcm_adjtime,
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime,
@@ -1151,24 +1852,14 @@ static const struct ptp_clock_info idtcm_caps = {
 	.do_aux_work	= &set_write_phase_ready,
 };
 
-
-static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
+static int configure_channel_pll(struct idtcm_channel *channel)
 {
-	struct idtcm_channel *channel;
-	int err;
-
-	if (!(index < MAX_PHC_PLL))
-		return -EINVAL;
-
-	channel = &idtcm->channel[index];
+	int err = 0;
 
-	switch (index) {
+	switch (channel->pll) {
 	case 0:
 		channel->dpll_freq = DPLL_FREQ_0;
 		channel->dpll_n = DPLL_0;
-		channel->tod_read_primary = TOD_READ_PRIMARY_0;
-		channel->tod_write = TOD_WRITE_0;
-		channel->tod_n = TOD_0;
 		channel->hw_dpll_n = HW_DPLL_0;
 		channel->dpll_phase = DPLL_PHASE_0;
 		channel->dpll_ctrl_n = DPLL_CTRL_0;
@@ -1177,9 +1868,6 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	case 1:
 		channel->dpll_freq = DPLL_FREQ_1;
 		channel->dpll_n = DPLL_1;
-		channel->tod_read_primary = TOD_READ_PRIMARY_1;
-		channel->tod_write = TOD_WRITE_1;
-		channel->tod_n = TOD_1;
 		channel->hw_dpll_n = HW_DPLL_1;
 		channel->dpll_phase = DPLL_PHASE_1;
 		channel->dpll_ctrl_n = DPLL_CTRL_1;
@@ -1188,9 +1876,6 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	case 2:
 		channel->dpll_freq = DPLL_FREQ_2;
 		channel->dpll_n = DPLL_2;
-		channel->tod_read_primary = TOD_READ_PRIMARY_2;
-		channel->tod_write = TOD_WRITE_2;
-		channel->tod_n = TOD_2;
 		channel->hw_dpll_n = HW_DPLL_2;
 		channel->dpll_phase = DPLL_PHASE_2;
 		channel->dpll_ctrl_n = DPLL_CTRL_2;
@@ -1199,31 +1884,129 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	case 3:
 		channel->dpll_freq = DPLL_FREQ_3;
 		channel->dpll_n = DPLL_3;
-		channel->tod_read_primary = TOD_READ_PRIMARY_3;
-		channel->tod_write = TOD_WRITE_3;
-		channel->tod_n = TOD_3;
 		channel->hw_dpll_n = HW_DPLL_3;
 		channel->dpll_phase = DPLL_PHASE_3;
 		channel->dpll_ctrl_n = DPLL_CTRL_3;
 		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_3;
 		break;
+	case 4:
+		channel->dpll_freq = DPLL_FREQ_4;
+		channel->dpll_n = DPLL_4;
+		channel->hw_dpll_n = HW_DPLL_4;
+		channel->dpll_phase = DPLL_PHASE_4;
+		channel->dpll_ctrl_n = DPLL_CTRL_4;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_4;
+		break;
+	case 5:
+		channel->dpll_freq = DPLL_FREQ_5;
+		channel->dpll_n = DPLL_5;
+		channel->hw_dpll_n = HW_DPLL_5;
+		channel->dpll_phase = DPLL_PHASE_5;
+		channel->dpll_ctrl_n = DPLL_CTRL_5;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_5;
+		break;
+	case 6:
+		channel->dpll_freq = DPLL_FREQ_6;
+		channel->dpll_n = DPLL_6;
+		channel->hw_dpll_n = HW_DPLL_6;
+		channel->dpll_phase = DPLL_PHASE_6;
+		channel->dpll_ctrl_n = DPLL_CTRL_6;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_6;
+		break;
+	case 7:
+		channel->dpll_freq = DPLL_FREQ_7;
+		channel->dpll_n = DPLL_7;
+		channel->hw_dpll_n = HW_DPLL_7;
+		channel->dpll_phase = DPLL_PHASE_7;
+		channel->dpll_ctrl_n = DPLL_CTRL_7;
+		channel->dpll_phase_pull_in = DPLL_PHASE_PULL_IN_7;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
+{
+	struct idtcm_channel *channel;
+	int err;
+
+	if (!(index < MAX_TOD))
+		return -EINVAL;
+
+	channel = &idtcm->channel[index];
+
+	/* Set pll addresses */
+	err = configure_channel_pll(channel);
+	if (err)
+		return err;
+
+	/* Set tod addresses */
+	switch (index) {
+	case 0:
+		channel->tod_read_primary = TOD_READ_PRIMARY_0;
+		channel->tod_write = TOD_WRITE_0;
+		channel->tod_n = TOD_0;
+		break;
+	case 1:
+		channel->tod_read_primary = TOD_READ_PRIMARY_1;
+		channel->tod_write = TOD_WRITE_1;
+		channel->tod_n = TOD_1;
+		break;
+	case 2:
+		channel->tod_read_primary = TOD_READ_PRIMARY_2;
+		channel->tod_write = TOD_WRITE_2;
+		channel->tod_n = TOD_2;
+		break;
+	case 3:
+		channel->tod_read_primary = TOD_READ_PRIMARY_3;
+		channel->tod_write = TOD_WRITE_3;
+		channel->tod_n = TOD_3;
+		break;
 	default:
 		return -EINVAL;
 	}
 
 	channel->idtcm = idtcm;
 
-	channel->caps = idtcm_caps;
+	if (idtcm_strverscmp(idtcm->version, "4.8.7") >= 0)
+		channel->caps = idtcm_caps_v487;
+	else
+		channel->caps = idtcm_caps;
+
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
-		 "IDT CM PLL%u", index);
+		 "IDT CM TOD%u", index);
+
+	if (idtcm_strverscmp(idtcm->version, "4.8.7") >= 0) {
+		err = idtcm_enable_tod_sync(channel);
+		if (err) {
+			dev_err(&idtcm->client->dev,
+				"Failed at line %d in func %s!\n",
+				__LINE__,
+				__func__);
+			return err;
+		}
+	}
 
 	err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_FREQUENCY);
-	if (err)
+	if (err) {
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = idtcm_enable_tod(channel);
-	if (err)
+	if (err) {
+		dev_err(&idtcm->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
 
@@ -1249,7 +2032,7 @@ static void ptp_clock_unregister_all(struct idtcm *idtcm)
 	u8 i;
 	struct idtcm_channel *channel;
 
-	for (i = 0; i < MAX_PHC_PLL; i++) {
+	for (i = 0; i < MAX_TOD; i++) {
 
 		channel = &idtcm->channel[i];
 
@@ -1260,7 +2043,12 @@ static void ptp_clock_unregister_all(struct idtcm *idtcm)
 
 static void set_default_masks(struct idtcm *idtcm)
 {
-	idtcm->pll_mask = DEFAULT_PLL_MASK;
+	idtcm->tod_mask = DEFAULT_TOD_MASK;
+
+	idtcm->channel[0].pll = DEFAULT_TOD0_PTP_PLL;
+	idtcm->channel[1].pll = DEFAULT_TOD1_PTP_PLL;
+	idtcm->channel[2].pll = DEFAULT_TOD2_PTP_PLL;
+	idtcm->channel[3].pll = DEFAULT_TOD3_PTP_PLL;
 
 	idtcm->channel[0].output_mask = DEFAULT_OUTPUT_MASK_PLL0;
 	idtcm->channel[1].output_mask = DEFAULT_OUTPUT_MASK_PLL1;
@@ -1268,51 +2056,13 @@ static void set_default_masks(struct idtcm *idtcm)
 	idtcm->channel[3].output_mask = DEFAULT_OUTPUT_MASK_PLL3;
 }
 
-static int set_tod_write_overhead(struct idtcm *idtcm)
-{
-	int err;
-	u8 i;
-
-	s64 total_ns = 0;
-
-	ktime_t start;
-	ktime_t stop;
-
-	char buf[TOD_BYTE_COUNT];
-
-	struct idtcm_channel *channel = &idtcm->channel[2];
-
-	/* Set page offset */
-	idtcm_write(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_OVR__0,
-		    buf, sizeof(buf));
-
-	for (i = 0; i < TOD_WRITE_OVERHEAD_COUNT_MAX; i++) {
-
-		start = ktime_get_raw();
-
-		err = idtcm_write(idtcm, channel->hw_dpll_n,
-				  HW_DPLL_TOD_OVR__0, buf, sizeof(buf));
-
-		if (err)
-			return err;
-
-		stop = ktime_get_raw();
-
-		total_ns += ktime_to_ns(stop - start);
-	}
-
-	idtcm->tod_write_overhead_ns = div_s64(total_ns,
-					       TOD_WRITE_OVERHEAD_COUNT_MAX);
-
-	return err;
-}
-
 static int idtcm_probe(struct i2c_client *client,
 		       const struct i2c_device_id *id)
 {
 	struct idtcm *idtcm;
 	int err;
 	u8 i;
+	char *fmt = "Failed at %d in line %s with channel output %d!\n";
 
 	/* Unused for now */
 	(void)id;
@@ -1333,25 +2083,24 @@ static int idtcm_probe(struct i2c_client *client,
 
 	idtcm_display_version_info(idtcm);
 
-	err = set_tod_write_overhead(idtcm);
-
-	if (err) {
-		mutex_unlock(&idtcm->reg_lock);
-		return err;
-	}
-
 	err = idtcm_load_firmware(idtcm, &client->dev);
 
 	if (err)
 		dev_warn(&idtcm->client->dev,
 			 "loading firmware failed with %d\n", err);
 
-	if (idtcm->pll_mask) {
-		for (i = 0; i < MAX_PHC_PLL; i++) {
-			if (idtcm->pll_mask & (1 << i)) {
+	if (idtcm->tod_mask) {
+		for (i = 0; i < MAX_TOD; i++) {
+			if (idtcm->tod_mask & (1 << i)) {
 				err = idtcm_enable_channel(idtcm, i);
-				if (err)
+				if (err) {
+					dev_err(&idtcm->client->dev,
+						fmt,
+						__LINE__,
+						__func__,
+						i);
 					break;
+				}
 			}
 		}
 	} else {
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 3de0eb7..ffae56c 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -13,32 +13,48 @@
 #include "idt8a340_reg.h"
 
 #define FW_FILENAME	"idtcm.bin"
-#define MAX_PHC_PLL	4
+#define MAX_TOD		(4)
+#define MAX_PLL		(8)
 
 #define MAX_ABS_WRITE_PHASE_PICOSECONDS (107374182350LL)
 
-#define PLL_MASK_ADDR		(0xFFA5)
-#define DEFAULT_PLL_MASK	(0x04)
+#define TOD_MASK_ADDR		(0xFFA5)
+#define DEFAULT_TOD_MASK	(0x04)
 
 #define SET_U16_LSB(orig, val8) (orig = (0xff00 & (orig)) | (val8))
 #define SET_U16_MSB(orig, val8) (orig = (0x00ff & (orig)) | (val8 << 8))
 
-#define OUTPUT_MASK_PLL0_ADDR		(0xFFB0)
-#define OUTPUT_MASK_PLL1_ADDR		(0xFFB2)
-#define OUTPUT_MASK_PLL2_ADDR		(0xFFB4)
-#define OUTPUT_MASK_PLL3_ADDR		(0xFFB6)
+#define TOD0_PTP_PLL_ADDR		(0xFFA8)
+#define TOD1_PTP_PLL_ADDR		(0xFFA9)
+#define TOD2_PTP_PLL_ADDR		(0xFFAA)
+#define TOD3_PTP_PLL_ADDR		(0xFFAB)
+
+#define TOD0_OUT_ALIGN_MASK_ADDR	(0xFFB0)
+#define TOD1_OUT_ALIGN_MASK_ADDR	(0xFFB2)
+#define TOD2_OUT_ALIGN_MASK_ADDR	(0xFFB4)
+#define TOD3_OUT_ALIGN_MASK_ADDR	(0xFFB6)
 
 #define DEFAULT_OUTPUT_MASK_PLL0	(0x003)
 #define DEFAULT_OUTPUT_MASK_PLL1	(0x00c)
 #define DEFAULT_OUTPUT_MASK_PLL2	(0x030)
 #define DEFAULT_OUTPUT_MASK_PLL3	(0x0c0)
 
+#define DEFAULT_TOD0_PTP_PLL		(0)
+#define DEFAULT_TOD1_PTP_PLL		(1)
+#define DEFAULT_TOD2_PTP_PLL		(2)
+#define DEFAULT_TOD3_PTP_PLL		(3)
+
 #define POST_SM_RESET_DELAY_MS		(3000)
 #define PHASE_PULL_IN_THRESHOLD_NS	(150000)
-#define TOD_WRITE_OVERHEAD_COUNT_MAX	(5)
+#define PHASE_PULL_IN_THRESHOLD_NS_V487	(15000)
+#define TOD_WRITE_OVERHEAD_COUNT_MAX	(2)
 #define TOD_BYTE_COUNT			(11)
 #define WR_PHASE_SETUP_MS		(5000)
 
+#define OUTPUT_MODULE_FROM_INDEX(index)	(OUTPUT_0 + (index) * 0x10)
+
+#define PEROUT_ENABLE_OUTPUT_MASK		(0xdeadbeef)
+
 /* Values of DPLL_N.DPLL_MODE.PLL_MODE */
 enum pll_mode {
 	PLL_MODE_MIN = 0,
@@ -48,7 +64,8 @@ enum pll_mode {
 	PLL_MODE_GPIO_INC_DEC = 3,
 	PLL_MODE_SYNTHESIS = 4,
 	PLL_MODE_PHASE_MEASUREMENT = 5,
-	PLL_MODE_MAX = PLL_MODE_PHASE_MEASUREMENT,
+	PLL_MODE_DISABLED = 6,
+	PLL_MODE_MAX = PLL_MODE_DISABLED,
 };
 
 enum hw_tod_write_trig_sel {
@@ -63,6 +80,26 @@ enum hw_tod_write_trig_sel {
 	WR_TRIG_SEL_MAX = HW_TOD_WR_TRIG_SEL_FOD_SYNC,
 };
 
+/* 4.8.7 only */
+enum scsr_tod_write_trig_sel {
+	SCSR_TOD_WR_TRIG_SEL_DISABLE = 0,
+	SCSR_TOD_WR_TRIG_SEL_IMMEDIATE = 1,
+	SCSR_TOD_WR_TRIG_SEL_REFCLK = 2,
+	SCSR_TOD_WR_TRIG_SEL_PWMPPS = 3,
+	SCSR_TOD_WR_TRIG_SEL_TODPPS = 4,
+	SCSR_TOD_WR_TRIG_SEL_SYNCFOD = 5,
+	SCSR_TOD_WR_TRIG_SEL_GPIO = 6,
+	SCSR_TOD_WR_TRIG_SEL_MAX = SCSR_TOD_WR_TRIG_SEL_GPIO,
+};
+
+/* 4.8.7 only */
+enum scsr_tod_write_type_sel {
+	SCSR_TOD_WR_TYPE_SEL_ABSOLUTE = 0,
+	SCSR_TOD_WR_TYPE_SEL_DELTA_PLUS = 1,
+	SCSR_TOD_WR_TYPE_SEL_DELTA_MINUS = 2,
+	SCSR_TOD_WR_TYPE_SEL_MAX = SCSR_TOD_WR_TYPE_SEL_DELTA_MINUS,
+};
+
 struct idtcm;
 
 struct idtcm_channel {
@@ -79,15 +116,17 @@ struct idtcm_channel {
 	u16			tod_n;
 	u16			hw_dpll_n;
 	enum pll_mode		pll_mode;
+	u8			pll;
 	u16			output_mask;
 	int			write_phase_ready;
 };
 
 struct idtcm {
-	struct idtcm_channel	channel[MAX_PHC_PLL];
+	struct idtcm_channel	channel[MAX_TOD];
 	struct i2c_client	*client;
 	u8			page_offset;
-	u8			pll_mask;
+	u8			tod_mask;
+	char			version[16];
 
 	/* Overhead calculation for adjtime */
 	u8			calculate_overhead_flag;
-- 
2.7.4

