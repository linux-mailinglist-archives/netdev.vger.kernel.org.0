Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98C61D72F2
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 10:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgERIaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 04:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbgERIaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 04:30:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DFEC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:30:03 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h17so10705357wrc.8
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JSeHNQh3YXbQnjfpYLZf1waobdc3QloYou2esB8sNvE=;
        b=KgjgQRxGkNhrC8znOTZMFwX7oxxpvm2p1xYeV7zFpEz/ucgL9z2CLfeoAlw/gGuqYd
         2jRvQp+CWZ+3VJK4AFkszI5HeETUro7Kf8U2a29zzOHsF8lYWVEyvhGx5xPOPRBybJWA
         pgyVkwpV9si9xzq01idER/VtjRf0SIheQobwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JSeHNQh3YXbQnjfpYLZf1waobdc3QloYou2esB8sNvE=;
        b=OJUQI1BaV48L/Q7Ruw1Wtjh27IuaIhzm3eWp+N73yZXdXSXvV9+uU9YisqKK2sAWjS
         6jXhND2/kbWbNfbjIFTAuSgLUgOnwyekrJVKkqKKWhrhW29vrI9Pyeu/BW/32Fe404sm
         6DwljbMlOY3DVGwZftQT7vhYKNJKTdk+1kCBZNKF+flltm9b04VhnX7UPcCFcFtJXsPt
         yGw8pysFcEGkYt9dZJPZ+krfkf90E4/AF7JcEcdgGbTlEoJqG0inQ+uqNoh7jCHTBtyG
         nxlcYMFl4WHR10xuRq9H4ecrcgpFa2oQW6rvDn5Ylh0OaVCWKtVeHlA2q4jMjL47wizA
         Ippw==
X-Gm-Message-State: AOAM531fw18ctRGa2q3Wd6AiIgOTPLppv6GGbKp0cbPlfz2cdHAwBSn1
        i0mgdfUxV5gjoW+Ax73RwR2LVg==
X-Google-Smtp-Source: ABdhPJwW9lgyCamRO6n9jKYmXZvKvUEz1glxkGEtlQylO9nBRhPo78sjlVH+C+v6U1MDMj9EOAq/SA==
X-Received: by 2002:a5d:6087:: with SMTP id w7mr20147962wrt.158.1589790601590;
        Mon, 18 May 2020 01:30:01 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m7sm15350144wmc.40.2020.05.18.01.29.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 01:30:00 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 3/4] bnxt_en: Use enable_hot_fw_reset generic devlink parameter
Date:   Mon, 18 May 2020 13:57:18 +0530
Message-Id: <1589790439-10487-4-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enable_hot_fw_reset parameter supports both permanent and runtime
configuration modes. This parameter enables or disables the hot
firmware reset capability of the device which either resets the
currently running firmware or upgrades/downgrades flashed
firmware.

For the runtime parameter to be true, all the loaded host driver
interfaces must support hot firmware reset. If any driver's
interface capability is set to false by the user, the device cannot
support hot firmware reset. To re-enable the capability, all the
driver interfaces have to set the value to true.

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst         |  6 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 28 ++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 61 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 5 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 3dfd84c..69393d3 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -14,6 +14,7 @@ Parameters
 
    * - Name
      - Mode
+     - Description
    * - ``enable_sriov``
      - Permanent
    * - ``ignore_ari``
@@ -22,6 +23,11 @@ Parameters
      - Permanent
    * - ``msix_vec_per_pf_min``
      - Permanent
+   * - ``enable_hot_fw_reset``
+     - Permanent, runtime
+     - For the runtime parameter to be true, all the loaded host driver
+       interfaces must support hot firmware reset. To re-enable the
+       capability, all the driver interfaces have to set the value to true.
 
 The ``bnxt`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f86b621..535fe8f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6955,7 +6955,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	struct hwrm_func_qcaps_input req = {0};
 	struct hwrm_func_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	u32 flags;
+	u32 flags, flags_ext;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCAPS, -1, -1);
 	req.fid = cpu_to_le16(0xffff);
@@ -6985,6 +6985,10 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED)
 		bp->tx_push_thresh = BNXT_TX_PUSH_THRESH;
 
+	flags_ext = le32_to_cpu(resp->flags_ext);
+	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT)
+		bp->fw_cap |= BNXT_FW_CAP_HOT_RESET_IF_SUPPORT;
+
 	hw_resc->max_rsscos_ctxs = le16_to_cpu(resp->max_rsscos_ctx);
 	hw_resc->max_cp_rings = le16_to_cpu(resp->max_cmpl_rings);
 	hw_resc->max_tx_rings = le16_to_cpu(resp->max_tx_rings);
@@ -8773,6 +8777,28 @@ static int bnxt_hwrm_shutdown_link(struct bnxt *bp)
 
 static int bnxt_fw_init_one(struct bnxt *bp);
 
+int bnxt_hwrm_get_hot_reset(struct bnxt *bp, bool *hot_reset_allowed)
+{
+	struct hwrm_func_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_func_qcfg_input req = {0};
+	int rc;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF_SUPPORT)) {
+		*hot_reset_allowed = !!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET);
+		return 0;
+	}
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCFG, -1, -1);
+	req.fid = cpu_to_le16(0xffff);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
+		*hot_reset_allowed = !!(le16_to_cpu(resp->flags) &
+					FUNC_QCFG_RESP_FLAGS_HOT_RESET_ALLOWED);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
 static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 {
 	struct hwrm_func_drv_if_change_output *resp = bp->hwrm_cmd_resp_addr;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c04ac4a..fd6592e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1710,6 +1710,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
 	#define BNXT_FW_CAP_SHARED_PORT_CFG		0x00400000
+	#define BNXT_FW_CAP_HOT_RESET_IF_SUPPORT	0x08000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
@@ -2062,5 +2063,6 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 			    struct netdev_phys_item_id *ppid);
 void bnxt_dim_work(struct work_struct *work);
 int bnxt_hwrm_set_ring_coal(struct bnxt *bp, struct bnxt_napi *bnapi);
+int bnxt_hwrm_get_hot_reset(struct bnxt *bp, bool *hot_reset_allowed);
 
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb..61bf630 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -314,6 +314,8 @@ enum bnxt_dl_param_id {
 	 NVM_OFF_MSIX_VEC_PER_PF_MIN, BNXT_NVM_SHARED_CFG, 7, 4},
 	{BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK, NVM_OFF_DIS_GRE_VER_CHECK,
 	 BNXT_NVM_SHARED_CFG, 1, 1},
+	{DEVLINK_PARAM_GENERIC_ID_ENABLE_HOT_FW_RESET,
+	 NVM_OFF_LIVE_FW_UPGRADE, BNXT_NVM_SHARED_CFG, 1, 1},
 };
 
 union bnxt_nvm_data {
@@ -618,6 +620,61 @@ static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 	return 0;
 }
 
+static int bnxt_dl_param_get(struct devlink *dl, u32 id,
+			     struct devlink_param_gset_ctx *ctx)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+
+	if (ctx->cmode == DEVLINK_PARAM_CMODE_PERMANENT)
+		return bnxt_dl_nvm_param_get(dl, id, ctx);
+	else if (ctx->cmode == DEVLINK_PARAM_CMODE_RUNTIME)
+		return bnxt_hwrm_get_hot_reset(bp, &ctx->val.vbool);
+
+	return -EOPNOTSUPP;
+}
+
+static int bnxt_hwrm_set_hot_reset(struct bnxt *bp, bool hot_reset_if_support)
+{
+	struct hwrm_func_cfg_input req = {0};
+	bool hot_reset_allowed;
+	int rc;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF_SUPPORT))
+		return -EOPNOTSUPP;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
+	req.fid = cpu_to_le16(0xffff);
+	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT);
+	if (hot_reset_if_support)
+		req.flags = cpu_to_le32(FUNC_CFG_REQ_FLAGS_HOT_RESET_IF_EN_DIS);
+
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		return rc;
+
+	rc = bnxt_hwrm_get_hot_reset(bp, &hot_reset_allowed);
+	if (rc)
+		return rc;
+
+	if (hot_reset_if_support && !hot_reset_allowed)
+		netdev_info(bp->dev, "Hot FW Reset enabled, but is disallowed as it is disabled on other interface(s) of this device.\n");
+
+	return 0;
+}
+
+static int bnxt_dl_param_set(struct devlink *dl, u32 id,
+			     struct devlink_param_gset_ctx *ctx)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+
+	if (ctx->cmode == DEVLINK_PARAM_CMODE_PERMANENT)
+		return bnxt_dl_nvm_param_set(dl, id, ctx);
+	else if (ctx->cmode == DEVLINK_PARAM_CMODE_RUNTIME)
+		return bnxt_hwrm_set_hot_reset(bp, ctx->val.vbool);
+
+	return -EOPNOTSUPP;
+}
+
 static const struct devlink_param bnxt_dl_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_SRIOV,
 			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
@@ -640,6 +697,10 @@ static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			     bnxt_dl_nvm_param_get, bnxt_dl_nvm_param_set,
 			     NULL),
+	DEVLINK_PARAM_GENERIC(ENABLE_HOT_FW_RESET,
+			      BIT(DEVLINK_PARAM_CMODE_PERMANENT) |
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      bnxt_dl_param_get, bnxt_dl_param_set, NULL),
 };
 
 static const struct devlink_param bnxt_dl_port_params[] = {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index d5c8bd4..0a5efff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -39,6 +39,7 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 #define NVM_OFF_DIS_GRE_VER_CHECK	171
 #define NVM_OFF_ENABLE_SRIOV		401
 #define NVM_OFF_NVM_CFG_VER		602
+#define NVM_OFF_LIVE_FW_UPGRADE		917
 
 #define BNXT_NVM_CFG_VER_BITS		24
 #define BNXT_NVM_CFG_VER_BYTES		4
-- 
1.8.3.1

