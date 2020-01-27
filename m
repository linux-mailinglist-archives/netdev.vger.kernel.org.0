Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4501014A153
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgA0J5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:33 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50351 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgA0J53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:29 -0500
Received: by mail-pj1-f65.google.com with SMTP id r67so2760699pjb.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7hHpY9zxloH1l0xrOGJ+sLWrQBlQdEasMw85ZBXGnm8=;
        b=Z+7br3HnZvPGbmdKs18i7NKPQYJZ9hp/0R7XddTshRK2T6LqmISbQIAb1aop129jQc
         2EGzB7a5ZVRtDN5AVOPa00tv9/lHP2av8mImyiUWYv4VUr5a2Nb66GZF27869Lgiehsi
         UBTrfECM+EmO7fmkS6jwGpCFdSCIA8jRLQ7Co=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7hHpY9zxloH1l0xrOGJ+sLWrQBlQdEasMw85ZBXGnm8=;
        b=D2x2hll4e3AXCpQEWxfMOgrML7SY2r/QZ2WKtexhPOoDKWIKshDuA23OucNj16loba
         svClw76eyQ23swNlXnnAl7gmsEaCdZ8xbj++cZXGp8HnVYtGtloGevzdV8otYhKu/rQM
         SUmSGWh5gqjP9efxIqwmUDkbBgZbQ9+L+FFWVvc4tj5FDKqSKcH8e50B8DkSoQFzJvue
         Mk3lbiZ692Q7DTYSAJmr91H4Mud4rLf5jXipt02IN5glUzBzfQb6aqshnYG1B72KZQc6
         L6lz+wr4jNLtDrOXYL8dDoRinRnuAk4Qrecgppr/PUAlQsa0CCNlUgeJC3e3jK2nBawE
         GPqA==
X-Gm-Message-State: APjAAAVnVFCaiRbuGIp7F4M3gz7uOhn1bGCLAyyf7GBuShcH3Qed21YX
        eluiigbjX0jus7kHv5+Koi1AFM4wN94=
X-Google-Smtp-Source: APXvYqzHwzapV5ElEOCznthUB/cTrD5Q9RX2sFxmizAOcYSp/m6JxApSzsC/mBMAy+YKVRmcf6B1qQ==
X-Received: by 2002:a17:90a:e28e:: with SMTP id d14mr14171216pjz.56.1580119048036;
        Mon, 27 Jan 2020 01:57:28 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:27 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 14/15] bnxt_en: Add support for devlink info command
Date:   Mon, 27 Jan 2020 04:56:26 -0500
Message-Id: <1580118987-30052-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
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
  - FW parameter set version
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
        fw.psid 0.0.0
        fw.app 216.1.122.0
        fw.mgmt 864.0.32.0
        fw.roce 216.1.15.0

[ This version has incorporated changes suggested by Jakub Kicinski to
  use generic devlink version tags. ]

v2: Use fw.psid

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 134 ++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   4 +
 2 files changed, 138 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 35e2a22..eec0168 100644
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
 
@@ -355,6 +359,136 @@ static void bnxt_copy_from_nvm_data(union devlink_param_value *dst,
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
+				DEVLINK_INFO_VERSION_GENERIC_FW_PSID, buf);
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

