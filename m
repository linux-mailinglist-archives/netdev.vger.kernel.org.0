Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E041499BD
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgAZJD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:58 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41812 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgAZJD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id w62so3423729pfw.8
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uSSKMZZp+ULRQk0LXPp+WyBu4iWCwInPmoY+QTCF1dM=;
        b=ECVJHt+UZAqIDOJ0YvWA6r1QxgmN0hiUY4o2yWTT+wnBS1PcYGvuFax2t80/fDHVnh
         J6jC4SKAmrn8wxEpAf7qx7JL63s12RQ1Gd5L47txOgzwCPMtuhfMrYTchqOFXJp5cUs/
         pQwOHqWKOQORl/Ty4o1oyvEQRmFNTZ9XDzGD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uSSKMZZp+ULRQk0LXPp+WyBu4iWCwInPmoY+QTCF1dM=;
        b=sJaXLEH+VlxALPeGxHrCgmzRpvmamZhAJnYhCgWW8ZZUYF9RT8J7ub3hwM28XKOCsz
         jBDKJqsSjkKLPXOivhW7aj1YfJqt7p+hRfOhfnBr+DkaPOwwVh+aITtHmRU0zAhE2hcW
         Iv4ak8ax7hY8c+P8AMixWRkqKoFG2KP+Q2mtsDgPr4ZOxP0F4aWS7tYVW22fi9fmNf4Z
         +vQ2Z7ybZz9nxO5Fpa3TslPVeZji584XAC47Q4vCt8vgIwxFbq3zVDrZZRUBu1UCJHdz
         6DflSU1JNHjIxAsnfl3lhrtpcEVKg/vRk0lY6sGND5TJcLAI97KtCuLQby17AVb09Kha
         2/sw==
X-Gm-Message-State: APjAAAXB3fvTC6DnTdF+ZnsIdYt1ZmjE2XcD+j3Al2nAcBo8WvNE0R87
        jimviKVv+BGzApIpWjMZwHLQidE+ARU=
X-Google-Smtp-Source: APXvYqzyaP66eBmM6aKt5Co1qaloyDX1g9/EKhBrIWB+qp9ppKNbiVIvtJZIlTBhbDI++JI0jJz9GQ==
X-Received: by 2002:a62:5343:: with SMTP id h64mr10734522pfb.171.1580029436120;
        Sun, 26 Jan 2020 01:03:56 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:55 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 15/16] bnxt_en: Add support for devlink info command
Date:   Sun, 26 Jan 2020 04:03:09 -0500
Message-Id: <1580029390-32760-16-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Display the following information via devlink info command:
  - Driver name
  - Board id
  - Broad revision
  - Board Serial number
  - Board FW version
  - Board NVM CFG version
  - FW App version
  - FW management version
  - FW RoCE version

  Standard output example:
  $ devlink dev info pci/0000:3b:00.0
  pci/0000:3b:00.0:
  driver bnxt_en
  serial_number 00-10-18-FF-FE-AD-05-00
  versions:
      fixed:
        asic.id D802
        asic.rev 1
      running:
        fw 216.1.124.0
        board.nvm_cfg_ver 0.0.0
        fw.app 216.1.122.0
        fw.mgmt 864.0.32.0
        fw.roce 216.1.15.0

[ This version has incorporated changes suggested by Jakub Kicinski to
  use generic devlink version tags. ]

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 135 ++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   4 +
 2 files changed, 139 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 35e2a22..0297fa1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -284,11 +284,15 @@ void bnxt_dl_health_recovery_done(struct bnxt *bp)
 		devlink_health_reporter_recovery_done(hlth->fw_reset_reporter);
 }
 
+static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			    struct netlink_ext_ack *extack);
+
 static const struct devlink_ops bnxt_dl_ops = {
 #ifdef CONFIG_BNXT_SRIOV
 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
 	.eswitch_mode_get = bnxt_dl_eswitch_mode_get,
 #endif /* CONFIG_BNXT_SRIOV */
+	.info_get	  = bnxt_dl_info_get,
 	.flash_update	  = bnxt_dl_flash_update,
 };
 
@@ -355,6 +359,137 @@ static void bnxt_copy_from_nvm_data(union devlink_param_value *dst,
 		dst->vu8 = (u8)val32;
 }
 
+static int bnxt_hwrm_get_nvm_cfg_ver(struct bnxt *bp,
+				     union devlink_param_value *nvm_cfg_ver)
+{
+	struct hwrm_nvm_get_variable_input req = {0};
+	union bnxt_nvm_data *data;
+	dma_addr_t data_dma_addr;
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_GET_VARIABLE, -1, -1);
+	data = dma_alloc_coherent(&bp->pdev->dev, sizeof(*data),
+				  &data_dma_addr, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	req.dest_data_addr = cpu_to_le64(data_dma_addr);
+	req.data_len = cpu_to_le16(BNXT_NVM_CFG_VER_BITS);
+	req.option_num = cpu_to_le16(NVM_OFF_NVM_CFG_VER);
+
+	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
+		bnxt_copy_from_nvm_data(nvm_cfg_ver, data,
+					BNXT_NVM_CFG_VER_BITS,
+					BNXT_NVM_CFG_VER_BYTES);
+
+	dma_free_coherent(&bp->pdev->dev, sizeof(*data), data, data_dma_addr);
+	return rc;
+}
+
+static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			    struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	union devlink_param_value nvm_cfg_ver;
+	struct hwrm_ver_get_output *ver_resp;
+	char mgmt_ver[FW_VER_STR_LEN];
+	char roce_ver[FW_VER_STR_LEN];
+	char fw_ver[FW_VER_STR_LEN];
+	char buf[32];
+	int rc;
+
+	rc = devlink_info_driver_name_put(req, DRV_MODULE_NAME);
+	if (rc)
+		return rc;
+
+	sprintf(buf, "%X", bp->chip_num);
+	rc = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
+	if (rc)
+		return rc;
+
+	ver_resp = &bp->ver_resp;
+	sprintf(buf, "%X", ver_resp->chip_rev);
+	rc = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_ASIC_REV, buf);
+	if (rc)
+		return rc;
+
+	if (BNXT_PF(bp)) {
+		sprintf(buf, "%02X-%02X-%02X-%02X-%02X-%02X-%02X-%02X",
+			bp->dsn[7], bp->dsn[6], bp->dsn[5], bp->dsn[4],
+			bp->dsn[3], bp->dsn[2], bp->dsn[1], bp->dsn[0]);
+		rc = devlink_info_serial_number_put(req, buf);
+		if (rc)
+			return rc;
+	}
+
+	if (strlen(ver_resp->active_pkg_name)) {
+		rc =
+		    devlink_info_version_running_put(req,
+					DEVLINK_INFO_VERSION_GENERIC_FW,
+					ver_resp->active_pkg_name);
+		if (rc)
+			return rc;
+	}
+
+	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
+		u32 ver = nvm_cfg_ver.vu32;
+
+		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
+			ver & 0xF);
+		rc = devlink_info_version_running_put(req,
+				DEVLINK_INFO_VERSION_GENERIC_BOARD_NVM_CFG,
+				buf);
+		if (rc)
+			return rc;
+	}
+
+	if (ver_resp->flags & VER_GET_RESP_FLAGS_EXT_VER_AVAIL) {
+		snprintf(fw_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+			 ver_resp->hwrm_fw_major, ver_resp->hwrm_fw_minor,
+			 ver_resp->hwrm_fw_build, ver_resp->hwrm_fw_patch);
+
+		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+			 ver_resp->mgmt_fw_major, ver_resp->mgmt_fw_minor,
+			 ver_resp->mgmt_fw_build, ver_resp->mgmt_fw_patch);
+
+		snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+			 ver_resp->roce_fw_major, ver_resp->roce_fw_minor,
+			 ver_resp->roce_fw_build, ver_resp->roce_fw_patch);
+	} else {
+		snprintf(fw_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+			 ver_resp->hwrm_fw_maj_8b, ver_resp->hwrm_fw_min_8b,
+			 ver_resp->hwrm_fw_bld_8b, ver_resp->hwrm_fw_rsvd_8b);
+
+		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+			 ver_resp->mgmt_fw_maj_8b, ver_resp->mgmt_fw_min_8b,
+			 ver_resp->mgmt_fw_bld_8b, ver_resp->mgmt_fw_rsvd_8b);
+
+		snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+			 ver_resp->roce_fw_maj_8b, ver_resp->roce_fw_min_8b,
+			 ver_resp->roce_fw_bld_8b, ver_resp->roce_fw_rsvd_8b);
+	}
+	rc = devlink_info_version_running_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_FW_APP, fw_ver);
+	if (rc)
+		return rc;
+
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
+		rc = devlink_info_version_running_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, mgmt_ver);
+		if (rc)
+			return rc;
+
+		rc = devlink_info_version_running_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
 static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 			     int msg_len, union devlink_param_value *val)
 {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 08aaa44..95f893f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -38,6 +38,10 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 #define NVM_OFF_IGNORE_ARI		164
 #define NVM_OFF_DIS_GRE_VER_CHECK	171
 #define NVM_OFF_ENABLE_SRIOV		401
+#define NVM_OFF_NVM_CFG_VER		602
+
+#define BNXT_NVM_CFG_VER_BITS		24
+#define BNXT_NVM_CFG_VER_BYTES		4
 
 #define BNXT_MSIX_VEC_MAX	1280
 #define BNXT_MSIX_VEC_MIN_MAX	128
-- 
2.5.1

