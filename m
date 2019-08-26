Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943C79C823
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbfHZD4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:15 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44536 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbfHZD4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:56:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id c81so10848883pfc.11
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RQZQt+LwCUhPmGLmVN0COksBWv/Cdp9caOyirk93CWI=;
        b=LoevPDQSCNZCpoxBWHAkEvDMgpohtkWCQK+3NpS1DN3Rghs80hlxI7EIMkGATrVZEg
         /Qe84Ip3dggad+SFQSNJZgLoH4YAYaAFsaKHnEDny8/Qr7BcKmWLtADcW8or+g/i+XLa
         tXK3UQ5MstMs5rJsdGwxTdGitGZBWs7fmrFNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RQZQt+LwCUhPmGLmVN0COksBWv/Cdp9caOyirk93CWI=;
        b=UzU/uRsGnrW22XaZz+Cm4L67nVDEhxPR69j3dxZpKZbgSN7ygoIqS/qTYNuDlNHSMK
         ApxptZqQNfbKkMTL6plbMlsgwc08nP2leXQza8Iw2BU1eZPlZWW1VCbbFj7DtqV2hW2m
         3IsQqP4txyT4Yoic+ALYeQTezoTJlS01EUta9V/ootLs/hX6x33s9w8B7UTUROvu2En1
         ufpbEaL11Sn6IzZo2CEhMfl5u99aku/6EiFf9vHErWu2qBEp9UXHQm56NqsURxg5y7ZY
         7FT/r++5T47FRMrrFlLcdZEjCTyZn5pvOa41Fhbd8ldZbeuY5oVG7zVvLR5NQ97o+7av
         Imaw==
X-Gm-Message-State: APjAAAV6vSebZhvG2i/zDMCuKpGZ3G8UaP+7jkucVMbcQpbO4pdIIlnV
        TdeihEmCeIfQFftHuuRdj3DKsA==
X-Google-Smtp-Source: APXvYqztm8OZRNd261RXUzxOMzdcqozXxzyS0apMVaBsssXM7ia4yT0tN6K/nZINM7waimsVTW48Bw==
X-Received: by 2002:a62:3887:: with SMTP id f129mr18438421pfa.245.1566791763908;
        Sun, 25 Aug 2019 20:56:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.56.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:56:03 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 12/14] bnxt_en: Do not send firmware messages if firmware is in error state.
Date:   Sun, 25 Aug 2019 23:55:03 -0400
Message-Id: <1566791705-20473-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
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
index 87e51e0..5d0f028 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4147,6 +4147,9 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		return -EBUSY;
+
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
 		if (msg_len > bp->hwrm_max_ext_req_len ||
 		    !bp->hwrm_short_cmd_req_addr)
@@ -5021,8 +5024,6 @@ static int bnxt_hwrm_vnic_free_one(struct bnxt *bp, u16 vnic_id)
 			cpu_to_le32(bp->vnic_info[vnic_id].fw_vnic_id);
 
 		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-		if (rc)
-			return rc;
 		bp->vnic_info[vnic_id].fw_vnic_id = INVALID_HW_RING_ID;
 	}
 	return rc;
@@ -5162,8 +5163,6 @@ static int bnxt_hwrm_ring_grp_free(struct bnxt *bp)
 
 		rc = _hwrm_send_message(bp, &req, sizeof(req),
 					HWRM_CMD_TIMEOUT);
-		if (rc)
-			break;
 		bp->grp_info[i].fw_grp_id = INVALID_HW_RING_ID;
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
@@ -5482,6 +5481,9 @@ static int hwrm_ring_free_send_msg(struct bnxt *bp,
 	struct hwrm_ring_free_output *resp = bp->hwrm_cmd_resp_addr;
 	u16 error_code;
 
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		return 0;
+
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_RING_FREE, cmpl_ring_id, -1);
 	req.ring_type = ring_type;
 	req.ring_id = cpu_to_le16(ring->fw_ring_id);
@@ -6283,8 +6285,6 @@ static int bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 
 			rc = _hwrm_send_message(bp, &req, sizeof(req),
 						HWRM_CMD_TIMEOUT);
-			if (rc)
-				break;
 
 			cpr->hw_stats_ctx_id = INVALID_STATS_CTX_ID;
 		}
@@ -7406,6 +7406,8 @@ static int bnxt_set_tpa(struct bnxt *bp, bool set_tpa)
 
 	if (set_tpa)
 		tpa_flags = bp->flags & BNXT_FLAG_TPA;
+	else if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		return 0;
 	for (i = 0; i < bp->nr_vnics; i++) {
 		rc = bnxt_hwrm_vnic_set_tpa(bp, i, tpa_flags);
 		if (rc) {
@@ -9996,7 +9998,8 @@ void bnxt_fw_reset(struct bnxt *bp)
 	if (test_bit(BNXT_STATE_OPEN, &bp->state) &&
 	    !test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
 		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-		if (BNXT_PF(bp) && bp->pf.active_vfs) {
+		if (BNXT_PF(bp) && bp->pf.active_vfs &&
+		    test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
 			rc = bnxt_hwrm_func_qcfg(bp);
 			if (rc) {
 				netdev_err(bp->dev, "Firmware reset aborted, first func_qcfg cmd failed, rc = %d\n",
@@ -10425,6 +10428,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
+		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
 			goto fw_reset_abort;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cb9a9a4..078900a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1617,6 +1617,7 @@ struct bnxt {
 #define BNXT_STATE_FW_RESET_DET 3
 #define BNXT_STATE_IN_FW_RESET	4
 #define BNXT_STATE_PROBE_ERR	5
+#define BNXT_STATE_FW_FATAL_COND	6
 
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
-- 
2.5.1

