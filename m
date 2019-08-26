Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A719C81F
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbfHZD4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33808 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbfHZD4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:56:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id b24so10896583pfp.1
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YVwIXJSH79W9h06l9F2mAyTCRJzS3IBCtSSBX7VfJec=;
        b=FD7gqelCx81zpY6WwXIXeqyX86RRZ+2p37Nu3zdGElXMEJEkdX7+Zr2OkPSF/aHOfS
         DxisX1kHE/I7tD52iB5Bf269NI11YGbWwfsxRIrGrvVXpZGcGBvkTB7toJT+U44hw82p
         lm3EhTbDcKAWHJoONoOXGZxZUGRCyVwTl0XmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YVwIXJSH79W9h06l9F2mAyTCRJzS3IBCtSSBX7VfJec=;
        b=gkQNjTA1MF03tBLYVY6y9c1b7AazOuW7+s8FnQmcvL0CDnTIm0cbBuNM92a0i/H437
         yX6RSkrLZoAZY/ZHfXfCM/s6xe9s0kP+2BJIq6quY/WAqz59YClL5DFM9IuyEDKAWYV+
         4IrxkuJx9zWD7g8noXpBAi08OOF2Md6jPdhaetuOrgbrkBB1+tv7yt6rMxwpQi2kvibu
         1H59fH8HCJm3oYBFpj5ZChfgtZnwgF2sE3X3WLCLBIBkGwNmQY4B/5MuFeFJMwaf5Les
         kiJTOZ8PF/YJK0q5GPfM96RByDpbDN4wzwsHbj8a8t5roSm++16em5fc/fOKKLy6YF39
         a8zA==
X-Gm-Message-State: APjAAAVG3OF8zBORf86PdP91lIeeTNU6TyChTtB+iwFyLx4n9Ptnyo8K
        iP17Gijr4XQ2Ko+ntxJeME9Clg==
X-Google-Smtp-Source: APXvYqy8fQ+kzr9pKWFqzVFIePoPOtyBA15ZYZjsgPQf2xUszmxet2Ey6K/Ug03eB6P1S1ddjXkJnQ==
X-Received: by 2002:a17:90a:8b98:: with SMTP id z24mr5001819pjn.77.1566791764807;
        Sun, 25 Aug 2019 20:56:04 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.56.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:56:04 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 13/14] bnxt_en: Add RESET_FW state logic to bnxt_fw_reset_task().
Date:   Sun, 25 Aug 2019 23:55:04 -0400
Message-Id: <1566791705-20473-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
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
index 5d0f028..1687a1a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10389,6 +10389,62 @@ static int bnxt_fw_init_one(struct bnxt *bp)
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
@@ -10427,6 +10483,14 @@ static void bnxt_fw_reset_task(struct work_struct *work)
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

