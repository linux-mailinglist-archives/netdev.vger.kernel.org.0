Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3457D12236C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 06:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfLQFMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 00:12:24 -0500
Received: from mxout2.idt.com ([157.165.5.26]:54554 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfLQFMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 00:12:23 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 00:12:21 EST
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id xBH53I3G031495;
        Mon, 16 Dec 2019 21:03:18 -0800
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id xBH53I4e026492;
        Mon, 16 Dec 2019 21:03:18 -0800
Received: from vcheng-VirtualBox.localdomain (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id xBH53GV16998;
        Mon, 16 Dec 2019 21:03:16 -0800 (PST)
From:   vincent.cheng.xh@renesas.com
To:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 3/3] ptp: clockmatrix: Rework clockmatrix version information.
Date:   Tue, 17 Dec 2019 00:03:08 -0500
Message-Id: <1576558988-20837-4-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Remove pipeline id, bond id, csr id, and irq id.
Changes source register for reading HW rev id.
Add OTP config select.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 63 ++++++++-----------------------------------
 1 file changed, 11 insertions(+), 52 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 66e3266..4ba5ea48 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -597,36 +597,7 @@ static int cm_state_machine_reset(struct cm *cm)
 
 static int cm_read_hw_rev_id(struct cm *cm, u8 *hw_rev_id)
 {
-	return cm_read(cm, GENERAL_STATUS, HW_REV_ID, hw_rev_id, sizeof(u8));
-}
-
-static int cm_read_bond_id(struct cm *cm, u8 *bond_id)
-{
-	return cm_read(cm, GENERAL_STATUS, BOND_ID, bond_id, sizeof(u8));
-}
-
-static int cm_read_hw_csr_id(struct cm *cm, u16 *hw_csr_id)
-{
-	int err;
-	u8 buf[2] = {0};
-
-	err = cm_read(cm, GENERAL_STATUS, HW_CSR_ID, buf, sizeof(buf));
-
-	*hw_csr_id = (buf[1] << 8) | buf[0];
-
-	return err;
-}
-
-static int cm_read_hw_irq_id(struct cm *cm, u16 *hw_irq_id)
-{
-	int err;
-	u8 buf[2] = {0};
-
-	err = cm_read(cm, GENERAL_STATUS, HW_IRQ_ID, buf, sizeof(buf));
-
-	*hw_irq_id = (buf[1] << 8) | buf[0];
-
-	return err;
+	return cm_read(cm, HW_REVISION, REV_ID, hw_rev_id, sizeof(u8));
 }
 
 static int cm_read_product_id(struct cm *cm, u16 *product_id)
@@ -663,16 +634,10 @@ static int cm_read_hotfix_release(struct cm *cm, u8 *hotfix)
 	return cm_read(cm, GENERAL_STATUS, HOTFIX_REL, hotfix, sizeof(u8));
 }
 
-static int cm_read_pipeline(struct cm *cm, u32 *pipeline)
+static int cm_read_otp_scsr_config_select(struct cm *cm, u8 *config_select)
 {
-	int err;
-	u8 buf[4] = {0};
-
-	err = cm_read(cm, GENERAL_STATUS, PIPELINE_ID, &buf[0], sizeof(buf));
-
-	*pipeline = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
-
-	return err;
+	return cm_read(cm, GENERAL_STATUS, OTP_SCSR_CONFIG_SELECT,
+		       config_select, sizeof(u8));
 }
 
 static int process_pll_mask(struct cm *cm, u32 addr, u8 val, u8 *mask)
@@ -1062,28 +1027,22 @@ static void cm_display_version_info(struct cm *cm)
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
 
 	cm_read_major_release(cm, &major);
 	cm_read_minor_release(cm, &minor);
 	cm_read_hotfix_release(cm, &hotfix);
-	cm_read_pipeline(cm, &pipeline);
 
 	cm_read_product_id(cm, &product_id);
 	cm_read_hw_rev_id(cm, &hw_rev_id);
-	cm_read_bond_id(cm, &bond_id);
-	cm_read_hw_csr_id(cm, &csr_id);
-	cm_read_hw_irq_id(cm, &irq_id);
-
-	dev_info(&cm->client->dev, "Version:  %d.%d.%d, Pipeline %u\t"
-		 "0x%04x, Rev %d, Bond %d, CSR %d, IRQ %d\n",
-		 major, minor, hotfix, pipeline,
-		 product_id, hw_rev_id, bond_id, csr_id, irq_id);
+
+	cm_read_otp_scsr_config_select(cm, &config_select);
+
+	dev_info(&cm->client->dev, fmt, major, minor, hotfix, product_id,
+		 hw_rev_id, config_select);
 }
 
 static struct ptp_clock_info cm_caps = {
-- 
2.7.4

