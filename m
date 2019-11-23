Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A30A107DC4
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKWI06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43668 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfKWI04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:56 -0500
Received: by mail-pg1-f194.google.com with SMTP id b1so4608266pgq.10
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0S5tctSUVEfuozDe/2RMeXxMikYW3YuL9cNLbs4OwUg=;
        b=WTTcrUXH0F7JbNWL57+aJLVGFxqhhBtrx+Yrx2pd61GBJEiVYsVp89B46GtbEiUKNh
         YI4dd692OT6P15N/goewmljEdajaxOrJ1vPMd4rkR6/ekvdv9VQMNwyC4+BWezhVZ7GE
         6dJiKDPTLU+/Nkkybb7YW+vU1mZNNL8oDm0mk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0S5tctSUVEfuozDe/2RMeXxMikYW3YuL9cNLbs4OwUg=;
        b=mMqM0QE8gGP/jxLhF9S7/NWnMj1A23fRBmP3W+B4/ypJXtKzanlr7xPo6MzdiLQpYo
         BDXSdsem5Jan48c/F17P/wcftZ1Mt8Qi2f0q50kwAKS1yyjBdc4q4xBccENz7ZtsX2J+
         ZnYC/r+qcSrLd1GJovLE+aY3G4SCaRJuKXlXq77Ck2Z8yCXnfF4HK7mium3Jt9bVnETh
         r6+cv6waogLZd5TrlMhjlYFlhMzte9Y+B/Tj+HbBkN1H/MEwanijZxCsgLyrOeU8X9SZ
         vd20xPP4G99JlQv39Yd8M8txCiK1CMQ4jc3PShxSq/havnkTaL2PmS0b/BfydbmJfYm4
         xWNA==
X-Gm-Message-State: APjAAAWMRdrh5H7Cgu5vKCsBCBuqp/GSGGD2S+KI4KUG8jc6JU3rr3vo
        VOx2ctkvH82GizHfeC9IG+wzH52CsDQ=
X-Google-Smtp-Source: APXvYqx4743FS01i3meUob7KNfQgb3H+5MZj1P+DjvAOwsaPOBqIJXqRJEBm0+t+7wr4ORMUgT2hCg==
X-Received: by 2002:a63:d351:: with SMTP id u17mr17154039pgi.84.1574497616157;
        Sat, 23 Nov 2019 00:26:56 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:55 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 15/15] bnxt_en: Add support for devlink info command
Date:   Sat, 23 Nov 2019 03:26:10 -0500
Message-Id: <1574497570-22102-16-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
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
  - Board Package version
  - FW version
  - FW management version
  - FW RoCE version

  Standard output example:
  $ devlink dev info pci/0000:3b:00.0
  pci/0000:3b:00.0:
    driver bnxt_en
    serial_number B0-26-28-FF-FE-25-84-20
    versions:
        fixed:
          board.id C454
          board.rev 1
        running:
          board.package N/A
          fw.version 216.0.154.32004
          fw.mgmt 864.0.0.0
          fw.app 216.0.51.0

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 128 ++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   4 +
 2 files changed, 132 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 1c456fc..531d48f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -239,11 +239,15 @@ void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
 	health->fatal = false;
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
 
@@ -308,6 +312,130 @@ static void bnxt_copy_from_nvm_data(union devlink_param_value *dst,
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
+	rc = devlink_info_version_fixed_put(req, "board.id", buf);
+	if (rc)
+		return rc;
+
+	ver_resp = &bp->ver_resp;
+	sprintf(buf, "%X", ver_resp->chip_rev);
+	rc = devlink_info_version_fixed_put(req, "board.rev", buf);
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
+		    devlink_info_version_running_put(req, "board.package",
+						     ver_resp->active_pkg_name);
+		if (rc)
+			return rc;
+	}
+
+	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
+		u32 ver = nvm_cfg_ver.vu32;
+
+		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
+			ver & 0xF);
+		rc = devlink_info_version_running_put(req, "board.nvm_cfg_ver",
+						      buf);
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
+	rc = devlink_info_version_running_put(req, "fw.version", fw_ver);
+	if (rc)
+		return rc;
+
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
+		rc = devlink_info_version_running_put(req, "fw.mgmt", mgmt_ver);
+		if (rc)
+			return rc;
+
+		rc = devlink_info_version_running_put(req, "fw.app", roce_ver);
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
index 665d4bd..5b2e796 100644
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

