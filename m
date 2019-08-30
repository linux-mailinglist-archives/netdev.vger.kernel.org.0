Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E1BA2DAE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfH3Dzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46519 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbfH3Dzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id o3so2660125plb.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LXut3Klo9K/buv0eAVok2vqGI9dnWul7qMeGZ7VUkKE=;
        b=NZvLbqL0pxmkNeC4YAp6F7NeCByrHkq1G0nyoyGryRvbTs5I7PA+dz67Kk+WimIhlL
         YKlP+xBg7V473oVqXQ82GW5dH0QLbfp95pZdwQC3yMmoe3AvLtpAiDXNpIQF8zNLstWc
         lRhw7RWr9jCA/FaTujiiT+KI3tFeAd9JtY9ic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LXut3Klo9K/buv0eAVok2vqGI9dnWul7qMeGZ7VUkKE=;
        b=CeKsZEJ1UMgUa7LLGUuhl2yRDZ9DbFeJGngDGcu/Pru/uPfD7sRAzxvZ+awZh/LEt6
         /9gtFK3j5Op5KduL17aX71D0gcHz7lx7ANWd+LtlGvA5E+5nFpCvAzsVi49a9s5g7RSc
         mHfeO578u14D9+4yypDHg5SPCIsm6vNOuk7ToYqVTYKpBhHf451dG+AZJzG6kHt+XfLW
         FHd0+O443pasPd+eDwnlT4BGTYGf247H/QzKL1+V7Y2nX6u9oDbgY4YgQCjYH1yCS7lr
         EsHWQnnf+I5XMhAzZESBt7G2r5Xa9HKpIpNjww52M6KSv2GryoR46DuXUrObEveOXDWC
         io0A==
X-Gm-Message-State: APjAAAUuAejRnAmHv5RYx/2C5RM8a/doLateA3hadK9Ctx/Pz/CmTd+M
        zG3piSE76qt9XYUUXN07KOgPiA==
X-Google-Smtp-Source: APXvYqz2g/gCJuSHS3svaIhpCreaOjwowHkY4B1pzK+9XhlcXmx6F8BkFY+vkaHN8Jb8vULwFuKwWA==
X-Received: by 2002:a17:902:44c:: with SMTP id 70mr13278536ple.225.1567137340703;
        Thu, 29 Aug 2019 20:55:40 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:40 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 09/22] bnxt_en: Handle firmware reset status during IF_UP.
Date:   Thu, 29 Aug 2019 23:54:52 -0400
Message-Id: <1567137305-5853-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 107 ++++++++++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |   2 +
 2 files changed, 89 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 696a548..303933b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8523,11 +8523,14 @@ static int bnxt_hwrm_shutdown_link(struct bnxt *bp)
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
@@ -8538,26 +8541,53 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
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
+		return rc;
 
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
+				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
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
@@ -8977,12 +9007,28 @@ static int bnxt_open(struct net_device *dev)
 	struct bnxt *bp = netdev_priv(dev);
 	int rc;
 
-	bnxt_hwrm_if_change(bp, true);
-	rc = __bnxt_open_nic(bp, true, true);
+	if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state)) {
+		netdev_err(bp->dev, "A previous firmware reset did not complete, aborting\n");
+		return -ENODEV;
+	}
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
@@ -10075,6 +10121,27 @@ static void bnxt_fw_init_one_p3(struct bnxt *bp)
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
index 1b1610d..3e0fcc2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1555,6 +1555,8 @@ struct bnxt {
 #define BNXT_STATE_OPEN		0
 #define BNXT_STATE_IN_SP_TASK	1
 #define BNXT_STATE_READ_STATS	2
+#define BNXT_STATE_FW_RESET_DET 3
+#define BNXT_STATE_ABORT_ERR	5
 
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
-- 
2.5.1

