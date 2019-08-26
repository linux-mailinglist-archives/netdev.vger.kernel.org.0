Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864B69C825
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfHZD4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38107 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbfHZDz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:55:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id o70so10873496pfg.5
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H1OUvQbKCsO4tFHwlKdYG2lSaIPKSjLb6lpaMm/0fuE=;
        b=MDXGjOrenhjLDvakx/Ch+yeGmB9mkfELzA4onNkaUUqwoCKcHqVLqJkub5dqevqJLU
         XK9CAeaEY4RZd7tCQHZSZ+j3Oc9G9gxeRMHhnVify91okGLofGiKXMyErwoewU6XhuzI
         Y8cHYySFkWZCrfSK2FL+rfK5/XG8Tyk+9SX7U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H1OUvQbKCsO4tFHwlKdYG2lSaIPKSjLb6lpaMm/0fuE=;
        b=Yp0aRrGBEw8F23YGF2McVR66E4mL+ANccyazhiEvhOKJV7ZIK/sQXo0qIkE6Q1ib96
         nv65+6kjxB+moaQAg8hABVIXmzvpmTAG+dujI/q9opef/vF7Q9VvEnCNxf2jS1XRkBdW
         HO/rRv78y3fwomFVK37uLOFY2U5y/yIlYRYPhSHfVVTcerE/DiE1pCDSfFIrswNirAzh
         cVjsvz5Guu2ojyMuv1liaDhWHtDBFfA/2XvU1nyDnGc8v1mTW1BBwt2zIEl5F4kX3kM+
         0Nf5L2avawJBI+aXRrxtByELlx9gHviOIweF3NbhDvutef/x1DSPO3Zne26+/dITH5fG
         OSRQ==
X-Gm-Message-State: APjAAAVBhSXkZmjqW4tjC0+LPlpc6SfL79r5hmTEqIoRVvZOARyt/+Ss
        7TjEF3xgG17AnYHt18554LA+FA==
X-Google-Smtp-Source: APXvYqx8/kNHLjmLLo3E8AZLSo4IlNatitopjw1RBMGIko+rkdbWR3g0vs+1o8hM5zbJewI+WWtZtg==
X-Received: by 2002:a17:90a:2764:: with SMTP id o91mr17815591pje.57.1566791756584;
        Sun, 25 Aug 2019 20:55:56 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:56 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 05/14] bnxt_en: Discover firmware error recovery capabilities.
Date:   Sun, 25 Aug 2019 23:54:56 -0400
Message-Id: <1566791705-20473-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call the new firmware API HWRM_ERROR_RECOVERY_QCFG if it is supported
to discover the firmware health and recovery capabilities and settings.
This feature allows the driver to reset the chip if firmware crashes and
becomes unresponsive.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 79 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 38 +++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 94641c9..ef43f9e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6833,6 +6833,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_PCIE_STATS_SUPPORTED;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_EXT_STATS_SUPPORTED)
 		bp->fw_cap |= BNXT_FW_CAP_EXT_STATS_SUPPORTED;
+	if (flags &  FUNC_QCAPS_RESP_FLAGS_ERROR_RECOVERY_CAPABLE)
+		bp->fw_cap |= BNXT_FW_CAP_ERROR_RECOVERY;
 
 	bp->tx_push_thresh = 0;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED)
@@ -6934,6 +6936,76 @@ static int bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(struct bnxt *bp)
 	return rc;
 }
 
+static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
+{
+	struct hwrm_error_recovery_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct hwrm_error_recovery_qcfg_input req = {0};
+	int rc, i;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+		return 0;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_ERROR_RECOVERY_QCFG, -1, -1);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc) {
+		rc = -EOPNOTSUPP;
+		goto err_recovery_out;
+	}
+	if (!fw_health) {
+		fw_health = kzalloc(sizeof(*fw_health), GFP_KERNEL);
+		bp->fw_health = fw_health;
+		if (!fw_health) {
+			rc = -ENOMEM;
+			goto err_recovery_out;
+		}
+	}
+	fw_health->flags = le32_to_cpu(resp->flags);
+	if ((fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU) &&
+	    !(bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL)) {
+		rc = -EINVAL;
+		goto err_recovery_out;
+	}
+	fw_health->polling_dsecs = le32_to_cpu(resp->driver_polling_freq);
+	fw_health->master_func_wait_dsecs =
+		le32_to_cpu(resp->master_func_wait_period);
+	fw_health->normal_func_wait_dsecs =
+		le32_to_cpu(resp->normal_func_wait_period);
+	fw_health->post_reset_wait_dsecs =
+		le32_to_cpu(resp->master_func_wait_period_after_reset);
+	fw_health->post_reset_max_wait_dsecs =
+		le32_to_cpu(resp->max_bailout_time_after_reset);
+	fw_health->regs[BNXT_FW_HEALTH_REG] =
+		le32_to_cpu(resp->fw_health_status_reg);
+	fw_health->regs[BNXT_FW_HEARTBEAT_REG] =
+		le32_to_cpu(resp->fw_heartbeat_reg);
+	fw_health->regs[BNXT_FW_RESET_CNT_REG] =
+		le32_to_cpu(resp->fw_reset_cnt_reg);
+	fw_health->regs[BNXT_FW_RESET_INPROG_REG] =
+		le32_to_cpu(resp->reset_inprogress_reg);
+	fw_health->fw_reset_inprog_reg_mask =
+		le32_to_cpu(resp->reset_inprogress_reg_mask);
+	fw_health->fw_reset_seq_cnt = resp->reg_array_cnt;
+	if (fw_health->fw_reset_seq_cnt >= 16) {
+		rc = -EINVAL;
+		goto err_recovery_out;
+	}
+	for (i = 0; i < fw_health->fw_reset_seq_cnt; i++) {
+		fw_health->fw_reset_seq_regs[i] =
+			le32_to_cpu(resp->reset_reg[i]);
+		fw_health->fw_reset_seq_vals[i] =
+			le32_to_cpu(resp->reset_reg_val[i]);
+		fw_health->fw_reset_seq_delay_msec[i] =
+			resp->delay_after_reset[i];
+	}
+err_recovery_out:
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	if (rc)
+		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
+	return rc;
+}
+
 static int bnxt_hwrm_func_reset(struct bnxt *bp)
 {
 	struct hwrm_func_reset_input req = {0};
@@ -10048,6 +10120,11 @@ static int bnxt_fw_init_one_p2(struct bnxt *bp)
 		netdev_warn(bp->dev, "hwrm query adv flow mgnt failure rc: %d\n",
 			    rc);
 
+	rc = bnxt_hwrm_error_recovery_qcfg(bp);
+	if (rc)
+		netdev_warn(bp->dev, "hwrm query error recovery failure rc: %d\n",
+			    rc);
+
 	rc = bnxt_hwrm_func_drv_rgtr(bp);
 	if (rc)
 		return -ENODEV;
@@ -11228,6 +11305,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
+	kfree(bp->fw_health);
+	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
 
 init_err_free:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index b515d83e..741ae68 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1333,6 +1333,41 @@ struct bnxt_ctx_mem_info {
 	struct bnxt_ctx_pg_info *tqm_mem[9];
 };
 
+struct bnxt_fw_health {
+	u32 flags;
+	u32 polling_dsecs;
+	u32 master_func_wait_dsecs;
+	u32 normal_func_wait_dsecs;
+	u32 post_reset_wait_dsecs;
+	u32 post_reset_max_wait_dsecs;
+	u32 regs[4];
+	u32 mapped_regs[4];
+#define BNXT_FW_HEALTH_REG		0
+#define BNXT_FW_HEARTBEAT_REG		1
+#define BNXT_FW_RESET_CNT_REG		2
+#define BNXT_FW_RESET_INPROG_REG	3
+	u32 fw_reset_inprog_reg_mask;
+	u32 last_fw_heartbeat;
+	u32 last_fw_reset_cnt;
+	u8 enabled:1;
+	u8 master:1;
+	u8 tmr_multiplier;
+	u8 tmr_counter;
+	u8 fw_reset_seq_cnt;
+	u32 fw_reset_seq_regs[16];
+	u32 fw_reset_seq_vals[16];
+	u32 fw_reset_seq_delay_msec[16];
+};
+
+#define BNXT_FW_HEALTH_REG_TYPE_MASK	3
+#define BNXT_FW_HEALTH_REG_TYPE_CFG	0
+#define BNXT_FW_HEALTH_REG_TYPE_GRC	1
+#define BNXT_FW_HEALTH_REG_TYPE_BAR0	2
+#define BNXT_FW_HEALTH_REG_TYPE_BAR1	3
+
+#define BNXT_FW_HEALTH_REG_TYPE(reg)	((reg) & BNXT_FW_HEALTH_REG_TYPE_MASK)
+#define BNXT_FW_HEALTH_REG_OFF(reg)	((reg) & ~BNXT_FW_HEALTH_REG_TYPE_MASK)
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
@@ -1581,6 +1616,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_KONG_MB_CHNL		0x00000080
 	#define BNXT_FW_CAP_OVS_64BIT_HANDLE		0x00000400
 	#define BNXT_FW_CAP_TRUSTED_VF			0x00000800
+	#define BNXT_FW_CAP_ERROR_RECOVERY		0x00002000
 	#define BNXT_FW_CAP_PKG_VER			0x00004000
 	#define BNXT_FW_CAP_CFA_ADV_FLOW		0x00008000
 	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX	0x00010000
@@ -1666,6 +1702,8 @@ struct bnxt {
 #define BNXT_UPDATE_PHY_SP_EVENT	16
 #define BNXT_RING_COAL_NOW_SP_EVENT	17
 
+	struct bnxt_fw_health	*fw_health;
+
 	struct bnxt_hw_resc	hw_resc;
 	struct bnxt_pf_info	pf;
 	struct bnxt_ctx_mem_info	*ctx;
-- 
2.5.1

