Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B98A132942
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgAGOsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:48:24 -0500
Received: from mxout2.idt.com ([157.165.5.26]:45224 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgAGOsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 09:48:24 -0500
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id 007EmKLg025903;
        Tue, 7 Jan 2020 06:48:20 -0800
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id 007EmKVC009801;
        Tue, 7 Jan 2020 06:48:20 -0800
Received: from vcheng-VirtualBox.na.ads.idt.com (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id 007EmJV02488;
        Tue, 7 Jan 2020 06:48:19 -0800 (PST)
From:   vincent.cheng.xh@renesas.com
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v4 net-next 1/1] ptp: clockmatrix: Rework clockmatrix version information.
Date:   Tue,  7 Jan 2020 09:47:57 -0500
Message-Id: <1578408477-4650-2-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578408477-4650-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1578408477-4650-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Simplify and fix the version information displayed by the driver.
The new info better relects what is needed to support the hardware.

Prev:
Version: 4.8.0, Pipeline 22169 0x4001, Rev 0, Bond 5, CSR 311, IRQ 2

New:
Version: 4.8.0, Id: 0x4001  Hw Rev: 5  OTP Config Select: 15

- Remove pipeline, CSR and IRQ because version x.y.z already incorporates
  this information.
- Remove bond number because it is not used.
- Remove rev number because register was not implemented, always 0
- Add HW Rev ID register to replace rev number
- Add OTP config select to show the user configuration chosen by
  the configurable GPIO pins on start-up

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/idt8a340_reg.h    |  2 ++
 drivers/ptp/ptp_clockmatrix.c | 77 ++++++++-----------------------------------
 2 files changed, 15 insertions(+), 64 deletions(-)

diff --git a/drivers/ptp/idt8a340_reg.h b/drivers/ptp/idt8a340_reg.h
index 9263bc3..69eedda 100644
--- a/drivers/ptp/idt8a340_reg.h
+++ b/drivers/ptp/idt8a340_reg.h
@@ -77,6 +77,8 @@
 #define JTAG_DEVICE_ID                    0x001c
 #define PRODUCT_ID                        0x001e
 
+#define OTP_SCSR_CONFIG_SELECT            0x0022
+
 #define STATUS                            0xc03c
 #define USER_GPIO0_TO_7_STATUS            0x008a
 #define USER_GPIO8_TO_15_STATUS           0x008b
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index e858367..032e112 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -405,6 +405,7 @@ static int _idtcm_set_dpll_tod(struct idtcm_channel *channel,
 	if (wr_trig == HW_TOD_WR_TRIG_SEL_MSB) {
 
 		if (idtcm->calculate_overhead_flag) {
+			/* Assumption: I2C @ 400KHz */
 			total_overhead_ns =  ktime_to_ns(ktime_get_raw()
 							 - idtcm->start_time)
 					     + idtcm->tod_write_overhead_ns
@@ -596,44 +597,7 @@ static int idtcm_state_machine_reset(struct idtcm *idtcm)
 
 static int idtcm_read_hw_rev_id(struct idtcm *idtcm, u8 *hw_rev_id)
 {
-	return idtcm_read(idtcm,
-			  GENERAL_STATUS,
-			  HW_REV_ID,
-			  hw_rev_id,
-			  sizeof(u8));
-}
-
-static int idtcm_read_bond_id(struct idtcm *idtcm, u8 *bond_id)
-{
-	return idtcm_read(idtcm,
-			  GENERAL_STATUS,
-			  BOND_ID,
-			  bond_id,
-			  sizeof(u8));
-}
-
-static int idtcm_read_hw_csr_id(struct idtcm *idtcm, u16 *hw_csr_id)
-{
-	int err;
-	u8 buf[2] = {0};
-
-	err = idtcm_read(idtcm, GENERAL_STATUS, HW_CSR_ID, buf, sizeof(buf));
-
-	*hw_csr_id = (buf[1] << 8) | buf[0];
-
-	return err;
-}
-
-static int idtcm_read_hw_irq_id(struct idtcm *idtcm, u16 *hw_irq_id)
-{
-	int err;
-	u8 buf[2] = {0};
-
-	err = idtcm_read(idtcm, GENERAL_STATUS, HW_IRQ_ID, buf, sizeof(buf));
-
-	*hw_irq_id = (buf[1] << 8) | buf[0];
-
-	return err;
+	return idtcm_read(idtcm, HW_REVISION, REV_ID, hw_rev_id, sizeof(u8));
 }
 
 static int idtcm_read_product_id(struct idtcm *idtcm, u16 *product_id)
@@ -674,20 +638,11 @@ static int idtcm_read_hotfix_release(struct idtcm *idtcm, u8 *hotfix)
 			  sizeof(u8));
 }
 
-static int idtcm_read_pipeline(struct idtcm *idtcm, u32 *pipeline)
+static int idtcm_read_otp_scsr_config_select(struct idtcm *idtcm,
+					     u8 *config_select)
 {
-	int err;
-	u8 buf[4] = {0};
-
-	err = idtcm_read(idtcm,
-			 GENERAL_STATUS,
-			 PIPELINE_ID,
-			 &buf[0],
-			 sizeof(buf));
-
-	*pipeline = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
-
-	return err;
+	return idtcm_read(idtcm, GENERAL_STATUS, OTP_SCSR_CONFIG_SELECT,
+			  config_select, sizeof(u8));
 }
 
 static int process_pll_mask(struct idtcm *idtcm, u32 addr, u8 val, u8 *mask)
@@ -1078,28 +1033,22 @@ static void idtcm_display_version_info(struct idtcm *idtcm)
 	u8 major;
 	u8 minor;
 	u8 hotfix;
-	u32 pipeline;
 	u16 product_id;
-	u16 csr_id;
-	u16 irq_id;
 	u8 hw_rev_id;
-	u8 bond_id;
+	u8 config_select;
+	char *fmt = "%d.%d.%d, Id: 0x%04x  HW Rev: %d  OTP Config Select: %d\n";
 
 	idtcm_read_major_release(idtcm, &major);
 	idtcm_read_minor_release(idtcm, &minor);
 	idtcm_read_hotfix_release(idtcm, &hotfix);
-	idtcm_read_pipeline(idtcm, &pipeline);
 
 	idtcm_read_product_id(idtcm, &product_id);
 	idtcm_read_hw_rev_id(idtcm, &hw_rev_id);
-	idtcm_read_bond_id(idtcm, &bond_id);
-	idtcm_read_hw_csr_id(idtcm, &csr_id);
-	idtcm_read_hw_irq_id(idtcm, &irq_id);
-
-	dev_info(&idtcm->client->dev, "Version:  %d.%d.%d, Pipeline %u\t"
-		 "0x%04x, Rev %d, Bond %d, CSR %d, IRQ %d\n",
-		 major, minor, hotfix, pipeline,
-		 product_id, hw_rev_id, bond_id, csr_id, irq_id);
+
+	idtcm_read_otp_scsr_config_select(idtcm, &config_select);
+
+	dev_info(&idtcm->client->dev, fmt, major, minor, hotfix,
+		 product_id, hw_rev_id, config_select);
 }
 
 static const struct ptp_clock_info idtcm_caps = {
-- 
2.7.4

