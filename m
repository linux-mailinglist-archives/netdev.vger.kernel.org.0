Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2DCA2DB6
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfH3D4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:56:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42155 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfH3Dzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id 26so1311236pfp.9
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zQiWwMic5fccg73yut2q6nfs6Kd6i7k927CvjReuM2w=;
        b=CYdvOvTR7vN91dvWDMSYUV2pavCcBR5/alNSNoq5wW457qsfd0jQrBX95CrlBHoUIU
         j539gVrQ1pznGiis3u7gLvM1T7g2bgqG2PAueoGUD8p7QZgT7SOncV9/cZvIELiPrY3v
         uO98IyNAI58MyIewQqW1f8Dd8Og+1Y0Dyxia4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zQiWwMic5fccg73yut2q6nfs6Kd6i7k927CvjReuM2w=;
        b=ueBh1gI9RVIxukK/VcQuYtJsuDvRaIckPq/stgLxXLCOrAfE18x5Ykkh5EGAjxgoCU
         tETMqFB23o6BbxI1ZkQYUtXA0KxvQYsLMeJCRhNoHBxXQ0Jeb69jCCPkic/p/z8pm+X+
         bDaBAcTHOvHakOvuvSvb6G2rBXr3xMvVwdia+8jm0J0jZhndzLGY7PmNmQELtI6CdChN
         0WYlQEA2ytudiTZrAOVRinYRQB8qkfMoGsqwVLxW34/EeUrBqlFyb+vl+Eky3QUT0/03
         xB/e+AfAUzVBPOPE/HylBifn18Gr2zJJfRIAkUXFtL05aq8KvYZQCQwEvcnSCadYMj0Q
         NeQQ==
X-Gm-Message-State: APjAAAWycV0NqXHoaeS44wGWAfO4/jE4rKk/gbTMfkD/meSXfLLuSm9Q
        8bBA6u3onJsPBogjRWoeeNyuZQ==
X-Google-Smtp-Source: APXvYqyihE6EMhlKT9kfzu1g3pd9lSJ4neSA46qXWTeas+7ntOyhA2cyBkuDkk+UwK9PYEL4LHc78Q==
X-Received: by 2002:a63:b904:: with SMTP id z4mr11034185pge.388.1567137349453;
        Thu, 29 Aug 2019 20:55:49 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:48 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 18/22] bnxt_en: Retain user settings on a VF after RESET_NOTIFY event.
Date:   Thu, 29 Aug 2019 23:55:01 -0400
Message-Id: <1567137305-5853-19-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
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
index cd20067..ff911d6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9211,7 +9211,7 @@ static int bnxt_open(struct net_device *dev)
 			int n = pf->active_vfs;
 
 			if (n)
-				bnxt_cfg_hw_sriov(bp, &n);
+				bnxt_cfg_hw_sriov(bp, &n, true);
 		}
 		bnxt_hwmon_open(bp);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 4aacfc3..f6f3454 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -470,10 +470,43 @@ static int bnxt_hwrm_func_buf_rgtr(struct bnxt *bp)
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
@@ -545,6 +578,9 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs)
 
 	mutex_lock(&bp->hwrm_cmd_lock);
 	for (i = 0; i < num_vfs; i++) {
+		if (reset)
+			__bnxt_set_vf_params(bp, i);
+
 		req.vf_id = cpu_to_le16(pf->first_vf_id + i);
 		rc = _hwrm_send_message(bp, &req, sizeof(req),
 					HWRM_CMD_TIMEOUT);
@@ -659,15 +695,15 @@ static int bnxt_hwrm_func_cfg(struct bnxt *bp, int num_vfs)
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
 
@@ -677,7 +713,7 @@ int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
 		return rc;
 
 	/* Reserve resources for VFs */
-	rc = bnxt_func_cfg(bp, *num_vfs);
+	rc = bnxt_func_cfg(bp, *num_vfs, reset);
 	if (rc != *num_vfs) {
 		if (rc <= 0) {
 			netdev_warn(bp->dev, "Unable to reserve resources for SRIOV.\n");
@@ -758,7 +794,7 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 	if (rc)
 		goto err_out1;
 
-	rc = bnxt_cfg_hw_sriov(bp, num_vfs);
+	rc = bnxt_cfg_hw_sriov(bp, num_vfs, false);
 	if (rc)
 		goto err_out2;
 
@@ -1144,7 +1180,7 @@ int bnxt_approve_mac(struct bnxt *bp, u8 *mac, bool strict)
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

