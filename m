Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD07B4384FD
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhJWTfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhJWTfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:35:00 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA9AC061766
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:40 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n12so418419plc.2
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TANaEXrgBlOdzwBVf+qsnGs0u70XSNYvucyILWvxOjY=;
        b=KG43scoVy9mUGK3d9IQ/dACCxajkkMwsGc7ffYZPFWDDR8u3qjUPFzX6ExMLD6NYsr
         CnNk1agtgX3DLqorHTqAykGU1RVCArSpJERUcEPa1sF0NIqv+mePl7uJoOKm30sFNT05
         lTydMG/PEt1SHqAlRHSkqMufwT7NOT2daVUIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TANaEXrgBlOdzwBVf+qsnGs0u70XSNYvucyILWvxOjY=;
        b=75qBScDixX5lkKe2FsAF0FN/O67q1Xw+c1voj4cu0zR/frWzFPl2CQTotQGwVNGjHd
         1f0lez7NLjQJhX2jFMIDrrJY6PYTeO/dr0lUBF1ZkJ6sesoWHQzwouoBrcksxuBXcZ4s
         OXQ292/TAd6I6sTlbTteNRfDPsVJLvj6TeTMsIUH3I7MlOzg5/AhqS1eJ9YjMRNBY6uq
         BR7qrzOtgkMvQ92xM1eyHQ9Q1Re3/DXNP0wQv1+awq1FrkGjmLALvLd2r+74KprC4xUU
         UFNgqHIlRHmcDRL6/Dhh3GcFhjFiAfzWEt7m4oSGXkwldiHbiCTiu/TtqWPqmEZpTOtZ
         rpOg==
X-Gm-Message-State: AOAM532N6Oh1ab46/JuYl4K3vlm58eKW11TrbpZytrNdFVAKVcKeaD9l
        upTNFbotrorLKKvXwBN7u8H2Ycgmyi0=
X-Google-Smtp-Source: ABdhPJwtikuwf8xE/trjaoIJ6EPm4j85RzJUlfWFMn/4zdJa9alHjBFg+jcm6GPcpq9lFWwv7SZ47Q==
X-Received: by 2002:a17:90a:5b0c:: with SMTP id o12mr23614923pji.11.1635017559871;
        Sat, 23 Oct 2021 12:32:39 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:39 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 17/19] bnxt_en: implement firmware live patching
Date:   Sat, 23 Oct 2021 15:32:04 -0400
Message-Id: <1635017526-16963-18-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e5e33705cf0a300a"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e5e33705cf0a300a

From: Edwin Peer <edwin.peer@broadcom.com>

Live patches are activated by using the 'limit no_reset' option when
performing a devlink dev reload fw_activate operation. These packages
must first be installed on the device in the usual way. For example,
via devlink dev flash or ethtool -f.

The devlink device info has also been enhanced to render stored and
running live patch versions.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 +
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 173 +++++++++++++++++-
 3 files changed, 174 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 137734cd585d..9b928e5f0f68 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7490,6 +7490,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_PTP_PPS;
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT))
 		bp->fw_cap |= BNXT_FW_CAP_HOT_RESET_IF;
+	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED))
+		bp->fw_cap |= BNXT_FW_CAP_LIVEPATCH;
 
 	bp->tx_push_thresh = 0;
 	if ((flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED) &&
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4fecfdb430b3..d0d5da9b78f8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1958,6 +1958,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
+	#define BNXT_FW_CAP_LIVEPATCH			0x08000000
 	#define BNXT_FW_CAP_PTP_PPS			0x10000000
 	#define BNXT_FW_CAP_HOT_RESET_IF		0x20000000
 	#define BNXT_FW_CAP_RING_MONITOR		0x40000000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index ae6ca2d2927d..bba5cb9f0fec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -326,6 +326,111 @@ void bnxt_dl_health_fw_recovery_done(struct bnxt *bp)
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack);
 
+static void
+bnxt_dl_livepatch_report_err(struct bnxt *bp, struct netlink_ext_ack *extack,
+			     struct hwrm_fw_livepatch_output *resp)
+{
+	int err = ((struct hwrm_err_output *)resp)->cmd_err;
+
+	switch (err) {
+	case FW_LIVEPATCH_CMD_ERR_CODE_INVALID_OPCODE:
+		netdev_err(bp->dev, "Illegal live patch opcode");
+		NL_SET_ERR_MSG_MOD(extack, "Invalid opcode");
+		break;
+	case FW_LIVEPATCH_CMD_ERR_CODE_NOT_SUPPORTED:
+		NL_SET_ERR_MSG_MOD(extack, "Live patch operation not supported");
+		break;
+	case FW_LIVEPATCH_CMD_ERR_CODE_NOT_INSTALLED:
+		NL_SET_ERR_MSG_MOD(extack, "Live patch not found");
+		break;
+	case FW_LIVEPATCH_CMD_ERR_CODE_NOT_PATCHED:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Live patch deactivation failed. Firmware not patched.");
+		break;
+	case FW_LIVEPATCH_CMD_ERR_CODE_AUTH_FAIL:
+		NL_SET_ERR_MSG_MOD(extack, "Live patch not authenticated");
+		break;
+	case FW_LIVEPATCH_CMD_ERR_CODE_INVALID_HEADER:
+		NL_SET_ERR_MSG_MOD(extack, "Incompatible live patch");
+		break;
+	case FW_LIVEPATCH_CMD_ERR_CODE_INVALID_SIZE:
+		NL_SET_ERR_MSG_MOD(extack, "Live patch has invalid size");
+		break;
+	case FW_LIVEPATCH_CMD_ERR_CODE_ALREADY_PATCHED:
+		NL_SET_ERR_MSG_MOD(extack, "Live patch already applied");
+		break;
+	default:
+		netdev_err(bp->dev, "Unexpected live patch error: %hhd\n", err);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to activate live patch");
+		break;
+	}
+}
+
+static int
+bnxt_dl_livepatch_activate(struct bnxt *bp, struct netlink_ext_ack *extack)
+{
+	struct hwrm_fw_livepatch_query_output *query_resp;
+	struct hwrm_fw_livepatch_query_input *query_req;
+	struct hwrm_fw_livepatch_output *patch_resp;
+	struct hwrm_fw_livepatch_input *patch_req;
+	u32 installed = 0;
+	u16 flags;
+	u8 target;
+	int rc;
+
+	if (~bp->fw_cap & BNXT_FW_CAP_LIVEPATCH) {
+		NL_SET_ERR_MSG_MOD(extack, "Device does not support live patch");
+		return -EOPNOTSUPP;
+	}
+
+	rc = hwrm_req_init(bp, query_req, HWRM_FW_LIVEPATCH_QUERY);
+	if (rc)
+		return rc;
+	query_resp = hwrm_req_hold(bp, query_req);
+
+	rc = hwrm_req_init(bp, patch_req, HWRM_FW_LIVEPATCH);
+	if (rc) {
+		hwrm_req_drop(bp, query_req);
+		return rc;
+	}
+	patch_req->opcode = FW_LIVEPATCH_REQ_OPCODE_ACTIVATE;
+	patch_req->loadtype = FW_LIVEPATCH_REQ_LOADTYPE_NVM_INSTALL;
+	patch_resp = hwrm_req_hold(bp, patch_req);
+
+	for (target = 1; target <= FW_LIVEPATCH_REQ_FW_TARGET_LAST; target++) {
+		query_req->fw_target = target;
+		rc = hwrm_req_send(bp, query_req);
+		if (rc) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to query packages");
+			break;
+		}
+
+		flags = le16_to_cpu(query_resp->status_flags);
+		if (~flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL)
+			continue;
+		if ((flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE) &&
+		    !strncmp(query_resp->active_ver, query_resp->install_ver,
+			     sizeof(query_resp->active_ver)))
+			continue;
+
+		patch_req->fw_target = target;
+		rc = hwrm_req_send(bp, patch_req);
+		if (rc) {
+			bnxt_dl_livepatch_report_err(bp, extack, patch_resp);
+			break;
+		}
+		installed++;
+	}
+
+	if (!rc && !installed) {
+		NL_SET_ERR_MSG_MOD(extack, "No live patches found");
+		rc = -ENOENT;
+	}
+	hwrm_req_drop(bp, query_req);
+	hwrm_req_drop(bp, patch_req);
+	return rc;
+}
+
 static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
 			       enum devlink_reload_action action,
 			       enum devlink_reload_limit limit,
@@ -367,6 +472,8 @@ static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
 		break;
 	}
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE: {
+		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
+			return bnxt_dl_livepatch_activate(bp, extack);
 		if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET) {
 			NL_SET_ERR_MSG_MOD(extack, "Device not capable, requires reboot");
 			return -EOPNOTSUPP;
@@ -423,6 +530,8 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
 		unsigned long start = jiffies;
 		unsigned long timeout = start + BNXT_DFLT_FW_RST_MAX_DSECS * HZ / 10;
 
+		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
+			break;
 		if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
 			timeout = start + bp->fw_health->normal_func_wait_dsecs * HZ / 10;
 		if (!netif_running(bp->dev))
@@ -476,6 +585,7 @@ static const struct devlink_ops bnxt_dl_ops = {
 	.flash_update	  = bnxt_dl_flash_update,
 	.reload_actions	  = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
+	.reload_limits	  = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
 	.reload_down	  = bnxt_dl_reload_down,
 	.reload_up	  = bnxt_dl_reload_up,
 };
@@ -621,6 +731,57 @@ static int bnxt_dl_info_put(struct bnxt *bp, struct devlink_info_req *req,
 	return 0;
 }
 
+#define BNXT_FW_SRT_PATCH	"fw.srt.patch"
+#define BNXT_FW_CRT_PATCH	"fw.crt.patch"
+
+static int bnxt_dl_livepatch_info_put(struct bnxt *bp,
+				      struct devlink_info_req *req,
+				      const char *key)
+{
+	struct hwrm_fw_livepatch_query_input *query;
+	struct hwrm_fw_livepatch_query_output *resp;
+	u16 flags;
+	int rc;
+
+	if (~bp->fw_cap & BNXT_FW_CAP_LIVEPATCH)
+		return 0;
+
+	rc = hwrm_req_init(bp, query, HWRM_FW_LIVEPATCH_QUERY);
+	if (rc)
+		return rc;
+
+	if (!strcmp(key, BNXT_FW_SRT_PATCH))
+		query->fw_target = FW_LIVEPATCH_QUERY_REQ_FW_TARGET_SECURE_FW;
+	else if (!strcmp(key, BNXT_FW_CRT_PATCH))
+		query->fw_target = FW_LIVEPATCH_QUERY_REQ_FW_TARGET_COMMON_FW;
+	else
+		goto exit;
+
+	resp = hwrm_req_hold(bp, query);
+	rc = hwrm_req_send(bp, query);
+	if (rc)
+		goto exit;
+
+	flags = le16_to_cpu(resp->status_flags);
+	if (flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE) {
+		resp->active_ver[sizeof(resp->active_ver) - 1] = '\0';
+		rc = devlink_info_version_running_put(req, key, resp->active_ver);
+		if (rc)
+			goto exit;
+	}
+
+	if (flags & FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL) {
+		resp->install_ver[sizeof(resp->install_ver) - 1] = '\0';
+		rc = devlink_info_version_stored_put(req, key, resp->install_ver);
+		if (rc)
+			goto exit;
+	}
+
+exit:
+	hwrm_req_drop(bp, query);
+	return rc;
+}
+
 #define HWRM_FW_VER_STR_LEN	16
 
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
@@ -774,8 +935,16 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
 		 nvm_dev_info.roce_fw_major, nvm_dev_info.roce_fw_minor,
 		 nvm_dev_info.roce_fw_build, nvm_dev_info.roce_fw_patch);
-	return bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
-				DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+	if (rc)
+		return rc;
+
+	rc = bnxt_dl_livepatch_info_put(bp, req, BNXT_FW_SRT_PATCH);
+	if (rc)
+		return rc;
+	return bnxt_dl_livepatch_info_put(bp, req, BNXT_FW_CRT_PATCH);
+
 }
 
 static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
-- 
2.18.1


--000000000000e5e33705cf0a300a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDBB5T5jqFt6c/NEwmzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE0MTRaFw0yMjA5MjIxNDQzNDhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDE1pY2hhZWwgQ2hhbjEoMCYGCSqGSIb3DQEJ
ARYZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBANtwBQrLJBrTcbQ1kmjdo+NJT2hFaBFsw1IOi34uVzWz21AZUqQkNVktkT740rYuB1m1No7W
EBvfLuKxbgQO2pHk9mTUiTHsrX2CHIw835Du8Co2jEuIqAsocz53NwYmk4Sj0/HqAfxgtHEleK2l
CR56TX8FjvCKYDsIsXIjMzm3M7apx8CQWT6DxwfrDBu607V6LkfuHp2/BZM2GvIiWqy2soKnUqjx
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPgEq9Dn1kY4kvvV8irYvp5+OUwqF8IN
HRJq9tm3jYhaMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzI0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAR4yQl9fFteOJU1H3GwafyM2RfxjmNOCyqReM9rXzERCVCfHY5
ViuzVUDOuh1u7Sgr73P7L705npxRHAosjpT+iBNABZ2KxNKwNCsH/w3t9fJqRFkULjNLud64OMox
zqdr9D5CAJUOAuku+Eke/HXqVDYYmE4kLIbPYAgRmiU0ZjnXxOi0FXBugPThxezjunsFH76Qu65j
Odd+tL9J/sQZY27mL/HlvGC8pwMC+isCnVJLUBCJ4d8G0fbkZz0sgB/LCCUqZjPYiJNPxTOf7yEr
8V53sfbUyDi+srnbXZ/7jFIcANcfrHVuPOwwj4esoKQpXMjo+yYxKHPf0Ct9Cc6U
--000000000000e5e33705cf0a300a--
