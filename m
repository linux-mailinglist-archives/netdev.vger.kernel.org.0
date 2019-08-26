Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3A89C824
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbfHZD4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35297 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729618AbfHZD4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:56:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id d85so10888832pfd.2
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6yGGtsgjaIJGMt8lMNLm4NeX6+uu4tdTe/IEfgZC83I=;
        b=MJ31mo+j44a1qh9Dr5pEheVsaxgQ6LhTh93Vg5w7SRDMnWn5RD8I+cRSYVO0UXUAuZ
         aBHQbBE3HeYmj05hPnPazvtsocOxZGDA0YgxFjl4aSjwI2mj3SCUyAXaKNZ64YWRnxrV
         7GoWS88kKRQeuXnUG14iqvo/oEFPRveYZef44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6yGGtsgjaIJGMt8lMNLm4NeX6+uu4tdTe/IEfgZC83I=;
        b=SL0EtwZVQBOZm1lykJHbBP7f7ZLAnEsF0CG/OzBelMnLeXeR6q2h6/TeLelxqCc3Oh
         YG1hL5yEmXHzTqkSgaeU8ZS3DDtEWWrr53t3ieg4JuWH5CYeDPH2g8NawhGk8opeFx/3
         B4lmsLzx4QT8OWOAaj1aiR8uCDNaoYpzXcfkUIkRey09cNRzzPRd7Drr8JPqTFIbdV4g
         DGhj62fXgIBPmfOApl+aR3jEnhBp9H7ynEFwWvGcucIKV+Iv83Izi81Nn5AbZPzJX3gX
         Oo4/xzJYxI9kcm7hx5PnIKIbAT9924jTml2juGWdtEQqdB0BxmOIaEKbVQswjYCPGGf+
         8+4w==
X-Gm-Message-State: APjAAAU6oSohqekXKOZScxUlTZ7CjB0qSEDCTfN6l2WYMt4pJSTlXvJE
        /x7j9nfRCgZmvQAtZWIWh6WHNw==
X-Google-Smtp-Source: APXvYqwHb3CJPDLos6LTNL6wTcgt69jwp6nmdmSo9Gwg3lTtgqOXS+VQb54kGc0vgFdjuy63bMBioQ==
X-Received: by 2002:aa7:925a:: with SMTP id 26mr18013471pfp.198.1566791762681;
        Sun, 25 Aug 2019 20:56:02 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.56.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:56:01 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 11/14] bnxt_en: Retain user settings on a VF after RESET_NOTIFY event.
Date:   Sun, 25 Aug 2019 23:55:02 -0400
Message-Id: <1566791705-20473-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Retain the VF MAC address, default VLAN, TX rate control, trust settings
of VFs after firmware reset.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 50 +++++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h |  2 +-
 3 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 12ab4ae..87e51e0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9204,7 +9204,7 @@ static int bnxt_open(struct net_device *dev)
 			int n = pf->active_vfs;
 
 			if (n)
-				bnxt_cfg_hw_sriov(bp, &n);
+				bnxt_cfg_hw_sriov(bp, &n, true);
 		}
 		bnxt_hwmon_open(bp);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index e435374..03104bf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -486,10 +486,43 @@ static int bnxt_hwrm_func_buf_rgtr(struct bnxt *bp)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
+/* Caller holds bp->hwrm_cmd_lock mutex lock */
+static void __bnxt_set_vf_params(struct bnxt *bp, int vf_id)
+{
+	struct hwrm_func_cfg_input req = {0};
+	struct bnxt_vf_info *vf;
+
+	vf = &bp->pf.vf[vf_id];
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
+	req.fid = cpu_to_le16(vf->fw_fid);
+	req.flags = cpu_to_le32(vf->func_flags);
+
+	if (is_valid_ether_addr(vf->mac_addr)) {
+		req.enables |= cpu_to_le32(FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR);
+		memcpy(req.dflt_mac_addr, vf->mac_addr, ETH_ALEN);
+	}
+	if (vf->vlan) {
+		req.enables |= cpu_to_le32(FUNC_CFG_REQ_ENABLES_DFLT_VLAN);
+		req.dflt_vlan = cpu_to_le16(vf->vlan);
+	}
+	if (vf->max_tx_rate) {
+		req.enables |= cpu_to_le32(FUNC_CFG_REQ_ENABLES_MAX_BW);
+		req.max_bw = cpu_to_le32(vf->max_tx_rate);
+#ifdef HAVE_IFLA_TX_RATE
+		req.enables |= cpu_to_le32(FUNC_CFG_REQ_ENABLES_MIN_BW);
+		req.min_bw = cpu_to_le32(vf->min_tx_rate);
+#endif
+	}
+	if (vf->flags & BNXT_VF_TRUST)
+		req.flags |= cpu_to_le32(FUNC_CFG_REQ_FLAGS_TRUSTED_VF_ENABLE);
+
+	_hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+}
+
 /* Only called by PF to reserve resources for VFs, returns actual number of
  * VFs configured, or < 0 on error.
  */
-static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs)
+static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 {
 	struct hwrm_func_vf_resource_cfg_input req = {0};
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
@@ -561,6 +594,9 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs)
 
 	mutex_lock(&bp->hwrm_cmd_lock);
 	for (i = 0; i < num_vfs; i++) {
+		if (reset)
+			__bnxt_set_vf_params(bp, i);
+
 		req.vf_id = cpu_to_le16(pf->first_vf_id + i);
 		rc = _hwrm_send_message(bp, &req, sizeof(req),
 					HWRM_CMD_TIMEOUT);
@@ -679,15 +715,15 @@ static int bnxt_hwrm_func_cfg(struct bnxt *bp, int num_vfs)
 	return rc;
 }
 
-static int bnxt_func_cfg(struct bnxt *bp, int num_vfs)
+static int bnxt_func_cfg(struct bnxt *bp, int num_vfs, bool reset)
 {
 	if (BNXT_NEW_RM(bp))
-		return bnxt_hwrm_func_vf_resc_cfg(bp, num_vfs);
+		return bnxt_hwrm_func_vf_resc_cfg(bp, num_vfs, reset);
 	else
 		return bnxt_hwrm_func_cfg(bp, num_vfs);
 }
 
-int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
+int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs, bool reset)
 {
 	int rc;
 
@@ -697,7 +733,7 @@ int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
 		return rc;
 
 	/* Reserve resources for VFs */
-	rc = bnxt_func_cfg(bp, *num_vfs);
+	rc = bnxt_func_cfg(bp, *num_vfs, reset);
 	if (rc != *num_vfs) {
 		if (rc <= 0) {
 			netdev_warn(bp->dev, "Unable to reserve resources for SRIOV.\n");
@@ -778,7 +814,7 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 	if (rc)
 		goto err_out1;
 
-	rc = bnxt_cfg_hw_sriov(bp, num_vfs);
+	rc = bnxt_cfg_hw_sriov(bp, num_vfs, false);
 	if (rc)
 		goto err_out2;
 
@@ -1205,7 +1241,7 @@ int bnxt_approve_mac(struct bnxt *bp, u8 *mac, bool strict)
 }
 #else
 
-int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
+int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs, bool reset)
 {
 	if (*num_vfs)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
index 0abf18e..629641b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
@@ -36,7 +36,7 @@ int bnxt_set_vf_link_state(struct net_device *, int, int);
 int bnxt_set_vf_spoofchk(struct net_device *, int, bool);
 int bnxt_set_vf_trust(struct net_device *dev, int vf_id, bool trust);
 int bnxt_sriov_configure(struct pci_dev *pdev, int num_vfs);
-int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs);
+int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs, bool reset);
 void bnxt_sriov_disable(struct bnxt *);
 void bnxt_hwrm_exec_fwd_req(struct bnxt *);
 void bnxt_update_vf_mac(struct bnxt *);
-- 
2.5.1

