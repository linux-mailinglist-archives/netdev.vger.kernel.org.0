Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D95A2DB5
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfH3D4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:56:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33913 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfH3Dzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so2814589pgc.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0UNuGC2TWPExonNMZaU6pLKyK/dYi3ZU8EySZfDMJeM=;
        b=PHldSmdf4aRvi6Wwbf9YM1LtNumswaiee3laHk5qUdaf9cjiGwd9xIFAczcLpegHAO
         kAnHDwveqyDAZf9s5RmaVomgC5ji4a2THpI8dPX6jDsufQelMEINud5xaKtfLtDN1GyV
         4cnxOTIJlO7bIzce/KxDG7ZfrQ6aqtcnOiyQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0UNuGC2TWPExonNMZaU6pLKyK/dYi3ZU8EySZfDMJeM=;
        b=H22zcvfJ6GfuYpLQDYNtQ+TuF8B8vOBy/1aYeo0EwwfH1UqvexkfhIkGRBv2rFjfed
         cJ7wybleoH6nVLsUJ4LH+/+UyaabuBqugn921sNFgplAd48V1pbRrsb+k/shvpsCoagg
         eUyNDoGPTC4tByk+3Pe9mDjUqIsaVw6YL0kepRS+8plciuO1a0Y7YrbOd/8s7RqyL8TN
         EKrWsNxwmIEozdcVErWHcztjGJFJuK6WWEloseufaZkG8N/oQaAljMw5TVHZWnT5pJIQ
         Cpjpq0l1guIcHVSM73obbX23UjWd1mgUHYdxsaFpeJLXlSKLrSHog14gksD6E1Jkq1xR
         fNZw==
X-Gm-Message-State: APjAAAVQ/unK5sQGCR7V8L2xEA+bKT5RSeLDP1bo8qnlKsDWv8rxHBdf
        gmVFCnG4edV1LesII9wqn5PDpw==
X-Google-Smtp-Source: APXvYqy8iUoWgmG1Od9vcFCMyEBPpMwI1ePQgN9tGQRzoPK5CRkyiz0E2PV1l/nDh1HicldigrcFsQ==
X-Received: by 2002:a65:64ce:: with SMTP id t14mr11198675pgv.137.1567137350651;
        Thu, 29 Aug 2019 20:55:50 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 19/22] bnxt_en: Do not send firmware messages if firmware is in error state.
Date:   Thu, 29 Aug 2019 23:55:02 -0400
Message-Id: <1567137305-5853-20-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a flag to mark that the firmware has encountered fatal condition.
The driver will not send any more firmware messages and will return
error to the caller.  Fix up some clean up functions to continue
and not abort when the firmware message function returns error.

This is preparation work to fully handle firmware error recovery
under fatal conditions.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 18 +++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ff911d6..f584a6b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4173,6 +4173,9 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		return -EBUSY;
+
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
 		if (msg_len > bp->hwrm_max_ext_req_len ||
 		    !bp->hwrm_short_cmd_req_addr)
@@ -5042,8 +5045,6 @@ static int bnxt_hwrm_vnic_free_one(struct bnxt *bp, u16 vnic_id)
 			cpu_to_le32(bp->vnic_info[vnic_id].fw_vnic_id);
 
 		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-		if (rc)
-			return rc;
 		bp->vnic_info[vnic_id].fw_vnic_id = INVALID_HW_RING_ID;
 	}
 	return rc;
@@ -5183,8 +5184,6 @@ static int bnxt_hwrm_ring_grp_free(struct bnxt *bp)
 
 		rc = _hwrm_send_message(bp, &req, sizeof(req),
 					HWRM_CMD_TIMEOUT);
-		if (rc)
-			break;
 		bp->grp_info[i].fw_grp_id = INVALID_HW_RING_ID;
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
@@ -5503,6 +5502,9 @@ static int hwrm_ring_free_send_msg(struct bnxt *bp,
 	struct hwrm_ring_free_output *resp = bp->hwrm_cmd_resp_addr;
 	u16 error_code;
 
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		return 0;
+
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_RING_FREE, cmpl_ring_id, -1);
 	req.ring_type = ring_type;
 	req.ring_id = cpu_to_le16(ring->fw_ring_id);
@@ -6300,8 +6302,6 @@ static int bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 
 			rc = _hwrm_send_message(bp, &req, sizeof(req),
 						HWRM_CMD_TIMEOUT);
-			if (rc)
-				break;
 
 			cpr->hw_stats_ctx_id = INVALID_STATS_CTX_ID;
 		}
@@ -7415,6 +7415,8 @@ static int bnxt_set_tpa(struct bnxt *bp, bool set_tpa)
 
 	if (set_tpa)
 		tpa_flags = bp->flags & BNXT_FLAG_TPA;
+	else if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		return 0;
 	for (i = 0; i < bp->nr_vnics; i++) {
 		rc = bnxt_hwrm_vnic_set_tpa(bp, i, tpa_flags);
 		if (rc) {
@@ -10009,7 +10011,8 @@ void bnxt_fw_reset(struct bnxt *bp)
 	if (test_bit(BNXT_STATE_OPEN, &bp->state) &&
 	    !test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
 		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-		if (BNXT_PF(bp) && bp->pf.active_vfs) {
+		if (BNXT_PF(bp) && bp->pf.active_vfs &&
+		    !test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
 			rc = bnxt_hwrm_func_qcfg(bp);
 			if (rc) {
 				netdev_err(bp->dev, "Firmware reset aborted, first func_qcfg cmd failed, rc = %d\n",
@@ -10439,6 +10442,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
+		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
 			goto fw_reset_abort;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d65625f..f3a6aad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1617,6 +1617,7 @@ struct bnxt {
 #define BNXT_STATE_FW_RESET_DET 3
 #define BNXT_STATE_IN_FW_RESET	4
 #define BNXT_STATE_ABORT_ERR	5
+#define BNXT_STATE_FW_FATAL_COND	6
 
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
-- 
2.5.1

