Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C093313F2C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfEELRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:34 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44148 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfEELR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id d3so903975plj.11
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0oPgTCV4/zK11AAJ6NDQa4GOuZHE3P/DZzC5V3PnvzU=;
        b=a/4irsxcqUwRFn5rtMXnW52XeWk/TY5zbs8N+RlkwLCdCQqwTa8U0ZwxFHI8UgbPBC
         1AV3MN5jKDVOSctWN0C50xcMMezowZaYGPXvO+IbYd7m5IdXoCQ66vzTVTHsaFFRrnGA
         0OFl41Hn4UOxUtVirFPBR+KYFxDU+LqdY0BHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0oPgTCV4/zK11AAJ6NDQa4GOuZHE3P/DZzC5V3PnvzU=;
        b=J/YLFMdd9xB7u3BJcD3dW7p7N/m7Vc8bbH9DVC0sMUR0f19EemLq1glatfMRudV9Yj
         D0leCxBwn0CE/RQU+g1LradcgeOu1X2CtWeAdGML8W3hlS1sobtfVBawJvDfJU/Gs7e/
         XirAUPDA2jwOQe0XKoJJDbvN0T0Ir6+ffxiEjseFXrXCTlXL4mM5oppfFbTjCYmcz08/
         ezu+3uTJc1QXKcDWZGnvxYnq41qgHGpdr443TZNaeZCAevh9w4ZMQZI4z7nepm/yADC8
         AnKHW913KWuTLmaaRoHhv1rO6+yYHQr/J1mrqDEDSEVLpAIxY3Krne3KvglVVfE2rqGN
         ZQig==
X-Gm-Message-State: APjAAAWNQpRdVkKumQ4CLpVA4fSuYZtRYhF8/AG2f4zR9A6Ff3L8J+2q
        smW8gf9qA0j70FM3X27uJ4t8OBq+7w0=
X-Google-Smtp-Source: APXvYqwRIp7xuBNtSJWgEkXkRL/hOe26q0pgB7YGEb0z6djxz+ziHYlPOBBCIM06EIci99/3czP61A==
X-Received: by 2002:a17:902:a582:: with SMTP id az2mr24428895plb.315.1557055048269;
        Sun, 05 May 2019 04:17:28 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 09/11] bnxt_en: Query firmware capability to support aRFS on 57500 chips.
Date:   Sun,  5 May 2019 07:17:06 -0400
Message-Id: <1557055028-14816-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Query support for the aRFS ring table index in the firmware.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 43 ++++++++++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  2 ++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cdbadc6..c9dad7c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6621,6 +6621,34 @@ static int bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	return 0;
 }
 
+static int bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(struct bnxt *bp)
+{
+	struct hwrm_cfa_adv_flow_mgnt_qcaps_input req = {0};
+	struct hwrm_cfa_adv_flow_mgnt_qcaps_output *resp;
+	int rc = 0;
+	u32 flags;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_CFA_ADV_FLOW))
+		return 0;
+
+	resp = bp->hwrm_cmd_resp_addr;
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_CFA_ADV_FLOW_MGNT_QCAPS, -1, -1);
+
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		goto hwrm_cfa_adv_qcaps_exit;
+
+	flags = le32_to_cpu(resp->flags);
+	if (flags &
+	    CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX;
+
+hwrm_cfa_adv_qcaps_exit:
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
 static int bnxt_hwrm_func_reset(struct bnxt *bp)
 {
 	struct hwrm_func_reset_input req = {0};
@@ -6753,6 +6781,10 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 	    VER_GET_RESP_DEV_CAPS_CFG_TRUSTED_VF_SUPPORTED)
 		bp->fw_cap |= BNXT_FW_CAP_TRUSTED_VF;
 
+	if (dev_caps_cfg &
+	    VER_GET_RESP_DEV_CAPS_CFG_CFA_ADV_FLOW_MGNT_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_CFA_ADV_FLOW;
+
 hwrm_ver_get_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
@@ -9063,8 +9095,11 @@ static bool bnxt_can_reserve_rings(struct bnxt *bp)
 /* If the chip and firmware supports RFS */
 static bool bnxt_rfs_supported(struct bnxt *bp)
 {
-	if (bp->flags & BNXT_FLAG_CHIP_P5)
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		if (bp->fw_cap & BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX)
+			return true;
 		return false;
+	}
 	if (BNXT_PF(bp) && !BNXT_CHIP_TYPE_NITRO_A0(bp))
 		return true;
 	if (bp->flags & BNXT_FLAG_NEW_RSS_CAP)
@@ -10665,6 +10700,12 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		rc = -1;
 		goto init_err_pci_clean;
 	}
+
+	rc = bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(bp);
+	if (rc)
+		netdev_warn(bp->dev, "hwrm query adv flow mgnt failure rc: %d\n",
+			    rc);
+
 	rc = bnxt_init_mac_addr(bp);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to initialize mac address.\n");
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index bc4c37a..eca36dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1483,6 +1483,8 @@ struct bnxt {
 	#define BNXT_FW_CAP_OVS_64BIT_HANDLE		0x00000400
 	#define BNXT_FW_CAP_TRUSTED_VF			0x00000800
 	#define BNXT_FW_CAP_PKG_VER			0x00004000
+	#define BNXT_FW_CAP_CFA_ADV_FLOW		0x00008000
+	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX	0x00010000
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 
-- 
2.5.1

