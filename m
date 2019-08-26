Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90A19C81B
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfHZDz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:55:59 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46452 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbfHZDz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:55:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id m3so9693392pgv.13
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PAypCOPlWbvR0spjsUYN2aIzwgzxpXqzhUkgAPHZow0=;
        b=KPswpr9H7GtMcfJ6VZOn738yu30nPLXOyVbCTrsRmxSF+oC8MZIwxpUmMX9lDaqyj6
         Y4m/klSOcjEpjuF37Dv11J2+QSplR1+EsFOqzTW2HvQnksKIq3qxoRwc6qEaydhRTo/K
         CxcLPYYSO5AYxjBtmfIWdPINRq8fq+c7FEE+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PAypCOPlWbvR0spjsUYN2aIzwgzxpXqzhUkgAPHZow0=;
        b=qhqDQRyNhhOD+eRlHvAoBGidxwIiv62PxuT2ZI0c23+PQhCE2N9cTblE0MuiHPEbcc
         77F+9iG521iIiczkubrqXswcjKquZvCZzfDREbDJersTQBpeQT4BNLMtVZPPcVwy2q34
         60GTGbdQNKgTsSieX6aaTk9Zy/nggTNnwpGObx6vq21t9gkpkv5dHfrCYkCbD1/y6m7A
         BMZcjU1SzI7RhMHOF0a3n9OfkdNTeUguJm905pFEDaCvSTh9fC6IIddjKxLfafp9MKP5
         eZ/C3YKa7bXnOFGrSc5Ew9n65dSP9SFOBaREcznoylKR9QsMPsu9G6OGrZkDSfXWMU84
         5I9g==
X-Gm-Message-State: APjAAAW9xlHCG2s/IxaP4ZlJmsssDZ8lVrURk4h65S/H6IOGUrz2L/e2
        bb4ln9EWuCLqlkUU0yE/eaDngw==
X-Google-Smtp-Source: APXvYqxLlbBk8JYJvl/Fs++jHh04WIhlN8HfTsSNVaL1OgY2TVcwTDdOmI8nGtXpIjxKJIyxgaKsHA==
X-Received: by 2002:a17:90a:80ca:: with SMTP id k10mr18151044pjw.59.1566791755652;
        Sun, 25 Aug 2019 20:55:55 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:55 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 04/14] bnxt_en: Handle firmware reset status during IF_UP.
Date:   Sun, 25 Aug 2019 23:54:55 -0400
Message-Id: <1566791705-20473-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During IF_UP, newer firmware has a new status flag that indicates that
firmware has reset.  Add new function bnxt_fw_init_one() to re-probe the
firmware and re-setup VF resources on the PF if necessary.  If the
re-probe fails, set a flag to prevent bnxt_open() from proceeding again.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 112 ++++++++++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |   2 +
 2 files changed, 93 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3e7a559..94641c9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7005,7 +7005,9 @@ static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
 
 	rc = bnxt_hwrm_do_send_msg(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT,
 				   silent);
-	return rc;
+	if (rc)
+		return -ENODEV;
+	return 0;
 }
 
 static int bnxt_hwrm_ver_get(struct bnxt *bp)
@@ -8513,11 +8515,14 @@ static int bnxt_hwrm_shutdown_link(struct bnxt *bp)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
+static int bnxt_fw_init_one(struct bnxt *bp);
+
 static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 {
 	struct hwrm_func_drv_if_change_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_func_drv_if_change_input req = {0};
-	bool resc_reinit = false;
+	bool resc_reinit = false, fw_reset = false;
+	u32 flags = 0;
 	int rc;
 
 	if (!(bp->fw_cap & BNXT_FW_CAP_IF_CHANGE))
@@ -8528,26 +8533,53 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 		req.flags = cpu_to_le32(FUNC_DRV_IF_CHANGE_REQ_FLAGS_UP);
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (!rc && (resp->flags &
-		    cpu_to_le32(FUNC_DRV_IF_CHANGE_RESP_FLAGS_RESC_CHANGE)))
-		resc_reinit = true;
+	if (!rc)
+		flags = le32_to_cpu(resp->flags);
 	mutex_unlock(&bp->hwrm_cmd_lock);
+	if (rc)
+		return -EIO;
 
-	if (up && resc_reinit && BNXT_NEW_RM(bp)) {
-		struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
+	if (!up)
+		return 0;
 
-		rc = bnxt_hwrm_func_resc_qcaps(bp, true);
-		hw_resc->resv_cp_rings = 0;
-		hw_resc->resv_stat_ctxs = 0;
-		hw_resc->resv_irqs = 0;
-		hw_resc->resv_tx_rings = 0;
-		hw_resc->resv_rx_rings = 0;
-		hw_resc->resv_hw_ring_grps = 0;
-		hw_resc->resv_vnics = 0;
-		bp->tx_nr_rings = 0;
-		bp->rx_nr_rings = 0;
+	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_RESC_CHANGE)
+		resc_reinit = true;
+	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE)
+		fw_reset = true;
+
+	if (resc_reinit || fw_reset) {
+		if (fw_reset) {
+			rc = bnxt_fw_init_one(bp);
+			if (rc) {
+				set_bit(BNXT_STATE_PROBE_ERR, &bp->state);
+				return rc;
+			}
+			bnxt_clear_int_mode(bp);
+			rc = bnxt_init_int_mode(bp);
+			if (rc) {
+				netdev_err(bp->dev, "init int mode failed\n");
+				return rc;
+			}
+			set_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
+		}
+		if (BNXT_NEW_RM(bp)) {
+			struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
+
+			rc = bnxt_hwrm_func_resc_qcaps(bp, true);
+			hw_resc->resv_cp_rings = 0;
+			hw_resc->resv_stat_ctxs = 0;
+			hw_resc->resv_irqs = 0;
+			hw_resc->resv_tx_rings = 0;
+			hw_resc->resv_rx_rings = 0;
+			hw_resc->resv_hw_ring_grps = 0;
+			hw_resc->resv_vnics = 0;
+			if (!fw_reset) {
+				bp->tx_nr_rings = 0;
+				bp->rx_nr_rings = 0;
+			}
+		}
 	}
-	return rc;
+	return 0;
 }
 
 static int bnxt_hwrm_port_led_qcaps(struct bnxt *bp)
@@ -8699,6 +8731,9 @@ static void bnxt_hwmon_open(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
 
+	if (bp->hwmon_dev)
+		return;
+
 	bp->hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
 							  DRV_MODULE_NAME, bp,
 							  bnxt_groups);
@@ -8964,12 +8999,26 @@ static int bnxt_open(struct net_device *dev)
 	struct bnxt *bp = netdev_priv(dev);
 	int rc;
 
-	bnxt_hwrm_if_change(bp, true);
-	rc = __bnxt_open_nic(bp, true, true);
+	if (test_bit(BNXT_STATE_PROBE_ERR, &bp->state))
+		return -ENODEV;
+
+	rc = bnxt_hwrm_if_change(bp, true);
 	if (rc)
+		return rc;
+	rc = __bnxt_open_nic(bp, true, true);
+	if (rc) {
 		bnxt_hwrm_if_change(bp, false);
+	} else {
+		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state) &&
+		    BNXT_PF(bp)) {
+			struct bnxt_pf_info *pf = &bp->pf;
+			int n = pf->active_vfs;
 
-	bnxt_hwmon_open(bp);
+			if (n)
+				bnxt_cfg_hw_sriov(bp, &n);
+		}
+		bnxt_hwmon_open(bp);
+	}
 
 	return rc;
 }
@@ -10062,6 +10111,27 @@ static void bnxt_fw_init_one_p3(struct bnxt *bp)
 	bnxt_hwrm_coal_params_qcaps(bp);
 }
 
+static int bnxt_fw_init_one(struct bnxt *bp)
+{
+	int rc;
+
+	rc = bnxt_fw_init_one_p1(bp);
+	if (rc) {
+		netdev_err(bp->dev, "Firmware init phase 1 failed\n");
+		return rc;
+	}
+	rc = bnxt_fw_init_one_p2(bp);
+	if (rc) {
+		netdev_err(bp->dev, "Firmware init phase 2 failed\n");
+		return rc;
+	}
+	rc = bnxt_approve_mac(bp, bp->dev->dev_addr, false);
+	if (rc)
+		return rc;
+	bnxt_fw_init_one_p3(bp);
+	return 0;
+}
+
 static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 {
 	int rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 1b1610d..b515d83e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1555,6 +1555,8 @@ struct bnxt {
 #define BNXT_STATE_OPEN		0
 #define BNXT_STATE_IN_SP_TASK	1
 #define BNXT_STATE_READ_STATS	2
+#define BNXT_STATE_FW_RESET_DET 3
+#define BNXT_STATE_PROBE_ERR	5
 
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
-- 
2.5.1

