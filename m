Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F79A2DB4
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfH3D4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:56:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46532 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfH3Dzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id o3so2660358plb.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e+f3vojnYcItmAqa0Vd7Zu6FESBQFX13d84LIXdRekM=;
        b=KAuPK+6T9kYusxqRCqvG/9EIz7aB5PSVA32LNMOHwbGmSw0zGNSV+SYhWz+WzQemkF
         z5zUTksICiGu7stbfeKswFJ2ZL8ePODnTMHVu0W59YGozqy3F81Y2e5iwUJSlAnFxw/p
         fQveEM2gZzOdkYocMnp/vWQ4zVwbWihILuEAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e+f3vojnYcItmAqa0Vd7Zu6FESBQFX13d84LIXdRekM=;
        b=CA5O7W7IXwF/3I8Y1O6UDEZvlYvLFBntOkFB3Cu9vY3x9ZPFHRKY02QrGYPcmtl5UD
         8Km5W77RpJpb3S26eyUgzCwUkbhPfgDfm1jwPyqyfOM2aR3euHZNRxN7ERJWYwTrYy1X
         ibfu5YUdLaLK4bBK8nI75XhgKE/pa84DnAZ57Hr/U6C7EonjT8XKs7+MRvUwzhW+t4vr
         vPv9YCQs/zO8JLOjlLD69pvlCSoKlG90koULtyMc2ueZamlXsZgTa5KA6T7JTpEz7lmO
         eaUn5ktXYADR3yEDEUwcBCLGb6Gspb/r1xY50zlMGMn+7HvEIKZ1/pIrQtQbrJ9bMfcN
         Qsgw==
X-Gm-Message-State: APjAAAWUPJpbG0KaTm+lP144RZ5SxfC90HTdatW3CpxzZ+7R+lStlFid
        Vyt+7krO5pLW/cBhHfpJFeIIaCJeiI0=
X-Google-Smtp-Source: APXvYqzLGqV21vBBgTM/gPcDN9wcCksn1fMKg83yJhz9lFKb5lPeCZ/3u0/nqcjgC5sPOK1CNMlo/Q==
X-Received: by 2002:a17:902:d20c:: with SMTP id t12mr10166445ply.196.1567137351729;
        Thu, 29 Aug 2019 20:55:51 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:51 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 20/22] bnxt_en: Add RESET_FW state logic to bnxt_fw_reset_task().
Date:   Thu, 29 Aug 2019 23:55:03 -0400
Message-Id: <1567137305-5853-21-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This state handles driver initiated chip reset during error recovery.
Only the master function will perform this step during error recovery.
The next patch will add code to initiate this reset from the master
function.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 64 +++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f584a6b..51cf679 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10402,6 +10402,62 @@ static int bnxt_fw_init_one(struct bnxt *bp)
 	return 0;
 }
 
+static void bnxt_fw_reset_writel(struct bnxt *bp, int reg_idx)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	u32 reg = fw_health->fw_reset_seq_regs[reg_idx];
+	u32 val = fw_health->fw_reset_seq_vals[reg_idx];
+	u32 reg_type, reg_off, delay_msecs;
+
+	delay_msecs = fw_health->fw_reset_seq_delay_msec[reg_idx];
+	reg_type = BNXT_FW_HEALTH_REG_TYPE(reg);
+	reg_off = BNXT_FW_HEALTH_REG_OFF(reg);
+	switch (reg_type) {
+	case BNXT_FW_HEALTH_REG_TYPE_CFG:
+		pci_write_config_dword(bp->pdev, reg_off, val);
+		break;
+	case BNXT_FW_HEALTH_REG_TYPE_GRC:
+		writel(reg_off & BNXT_GRC_BASE_MASK,
+		       bp->bar0 + BNXT_GRCPF_REG_WINDOW_BASE_OUT + 4);
+		reg_off = (reg_off & BNXT_GRC_OFFSET_MASK) + 0x2000;
+		/* fall through */
+	case BNXT_FW_HEALTH_REG_TYPE_BAR0:
+		writel(val, bp->bar0 + reg_off);
+		break;
+	case BNXT_FW_HEALTH_REG_TYPE_BAR1:
+		writel(val, bp->bar1 + reg_off);
+		break;
+	}
+	if (delay_msecs) {
+		pci_read_config_dword(bp->pdev, 0, &val);
+		msleep(delay_msecs);
+	}
+}
+
+static void bnxt_reset_all(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	int i;
+
+	if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_HOST) {
+		for (i = 0; i < fw_health->fw_reset_seq_cnt; i++)
+			bnxt_fw_reset_writel(bp, i);
+	} else if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU) {
+		struct hwrm_fw_reset_input req = {0};
+		int rc;
+
+		bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_RESET, -1, -1);
+		req.resp_addr = cpu_to_le64(bp->hwrm_cmd_kong_resp_dma_addr);
+		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP;
+		req.selfrst_status = FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP;
+		req.flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
+		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+		if (rc)
+			netdev_warn(bp->dev, "Unable to reset FW rc=%d\n", rc);
+	}
+	bp->fw_reset_timestamp = jiffies;
+}
+
 static void bnxt_fw_reset_task(struct work_struct *work)
 {
 	struct bnxt *bp = container_of(work, struct bnxt, fw_reset_task.work);
@@ -10441,6 +10497,14 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		rtnl_unlock();
 		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
+	case BNXT_FW_RESET_STATE_RESET_FW: {
+		u32 wait_dsecs = bp->fw_health->post_reset_wait_dsecs;
+
+		bnxt_reset_all(bp);
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+		bnxt_queue_fw_reset_work(bp, wait_dsecs * HZ / 10);
+		return;
+	}
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
-- 
2.5.1

