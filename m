Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B0A43F807
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhJ2Hux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhJ2Hur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:50:47 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A3AC061745
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:19 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g184so9135730pgc.6
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AvESA1EBIL8OxfUSzxpBsJ9tkvqBWpKXElAH5fuprbw=;
        b=BnMcU5L8fgjsyzNS+xFxDOR7SucnJwpOlpxHLHeCpAzkpo7pLT3Wi3YZU/i+6wBuq0
         X82/82wSKNBumEI2JettzNMrcrPRkbiZ0NJ5j9HEVMqB2MofILnN36NfvsNNMV10Iwe5
         9SRJPF2Ilhetf5b5VL4Hcu5ph2gVXPmHuBzTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AvESA1EBIL8OxfUSzxpBsJ9tkvqBWpKXElAH5fuprbw=;
        b=WYOSxoeupkUkC1uoayZyHprNmW0LhbyGd3AJhYs7w9+ZfsvZGmyJrkqHyKfqwDNtXY
         EBW9HdwUfY/Q0/de8F3Q7T8Knf8j7l6+M00FKcV1K74reojDYjCMtD2bxqa5AGJMY+Zc
         tpquUhd18ojx1noHZxCi3Fs3iuihiNWv57dYNpSfDPPHVXNSRH2pfe+BGXjUdHT/e7oW
         tuu+GD7CUuzTDijMjDF+t/URK5PLQygrXzl5HWXPfduhdYdcLhNsjpngync+h2O0Ex2q
         QTWGyhfLB0SR0yIRFJYWHAVb21GX8pIajLjIw9Vk6uaBIfGl1pK2zrlKHnp+H1cpoqjf
         N5lA==
X-Gm-Message-State: AOAM531qlJQboKTY3sAbyVaM1iplHE/r2uPaBvZsvYfvz3wOgVZqegLP
        awJLkp3+6mjw62a9obWgUsgBVw==
X-Google-Smtp-Source: ABdhPJzGXy7n3wmO2Z0+cdYNdreoDwY9Hf40w9mo4Ihi/U478HEKS92O+nnCPK2UtrJqvW2i/zQ8qQ==
X-Received: by 2002:a63:f547:: with SMTP id e7mr1198212pgk.29.1635493698397;
        Fri, 29 Oct 2021 00:48:18 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:17 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 05/19] bnxt_en: add enable_remote_dev_reset devlink parameter
Date:   Fri, 29 Oct 2021 03:47:42 -0400
Message-Id: <1635493676-10767-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f62bab05cf790c12"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f62bab05cf790c12

From: Edwin Peer <edwin.peer@broadcom.com>

The reported parameter value should not take into account the state
of remote drivers. Firmware will reject remote resets as appropriate,
thus it is not strictly necessary to check HOT_RESET_ALLOWED before
attempting to initiate a reset. But we add the check so that we can
provide more intuitive messages when reset is not permitted.

This firmware setting needs to be restored from all functions after
a firmware reset.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 23 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 74 ++++++++++++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h | 11 +++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  5 ++
 5 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cd5932c75997..80fff3d8b31f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7476,6 +7476,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED;
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PPS_SUPPORTED))
 		bp->fw_cap |= BNXT_FW_CAP_PTP_PPS;
+	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT))
+		bp->fw_cap |= BNXT_FW_CAP_HOT_RESET_IF;
 
 	bp->tx_push_thresh = 0;
 	if ((flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED) &&
@@ -12010,6 +12012,27 @@ static void bnxt_fw_reset_writel(struct bnxt *bp, int reg_idx)
 	}
 }
 
+bool bnxt_hwrm_reset_permitted(struct bnxt *bp)
+{
+	struct hwrm_func_qcfg_output *resp;
+	struct hwrm_func_qcfg_input *req;
+	bool result = true; /* firmware will enforce if unknown */
+
+	if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF)
+		return result;
+
+	if (hwrm_req_init(bp, req, HWRM_FUNC_QCFG))
+		return result;
+
+	req->fid = cpu_to_le16(0xffff);
+	resp = hwrm_req_hold(bp, req);
+	if (!hwrm_req_send(bp, req))
+		result = !!(le16_to_cpu(resp->flags) &
+			    FUNC_QCFG_RESP_FLAGS_HOT_RESET_ALLOWED);
+	hwrm_req_drop(bp, req);
+	return result;
+}
+
 static void bnxt_reset_all(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 38c23b4106a1..e56f2a27c67a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1935,6 +1935,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
 	#define BNXT_FW_CAP_PTP_PPS			0x10000000
+	#define BNXT_FW_CAP_HOT_RESET_IF		0x20000000
 	#define BNXT_FW_CAP_RING_MONITOR		0x40000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
@@ -2274,6 +2275,7 @@ void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		     int tx_xdp);
 int bnxt_fw_init_one(struct bnxt *bp);
+bool bnxt_hwrm_reset_permitted(struct bnxt *bp);
 int bnxt_setup_mq_tc(struct net_device *dev, u8 tc);
 int bnxt_get_max_rings(struct bnxt *, int *, int *, bool);
 int bnxt_restore_pf_fw_resources(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 9922c1428129..8673f3c4b581 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -42,6 +42,26 @@ bnxt_dl_flash_update(struct devlink *dl,
 	return rc;
 }
 
+static int bnxt_hwrm_remote_dev_reset_set(struct bnxt *bp, bool remote_reset)
+{
+	struct hwrm_func_cfg_input *req;
+	int rc;
+
+	if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF)
+		return -EOPNOTSUPP;
+
+	rc = hwrm_req_init(bp, req, HWRM_FUNC_CFG);
+	if (rc)
+		return rc;
+
+	req->fid = cpu_to_le16(0xffff);
+	req->enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT);
+	if (remote_reset)
+		req->flags = cpu_to_le32(FUNC_CFG_REQ_FLAGS_HOT_RESET_IF_EN_DIS);
+
+	return hwrm_req_send(bp, req);
+}
+
 static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 				     struct devlink_fmsg *fmsg,
 				     struct netlink_ext_ack *extack)
@@ -272,11 +292,13 @@ void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
 void bnxt_dl_health_recovery_done(struct bnxt *bp)
 {
 	struct bnxt_fw_health *hlth = bp->fw_health;
+	struct bnxt_dl *dl = devlink_priv(bp->dl);
 
 	if (hlth->fatal)
 		devlink_health_reporter_recovery_done(hlth->fw_fatal_reporter);
 	else
 		devlink_health_reporter_recovery_done(hlth->fw_reset_reporter);
+	bnxt_hwrm_remote_dev_reset_set(bp, dl->remote_reset);
 }
 
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
@@ -332,6 +354,11 @@ static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
 			NL_SET_ERR_MSG_MOD(extack, "Device not capable, requires reboot");
 			return -EOPNOTSUPP;
 		}
+		if (!bnxt_hwrm_reset_permitted(bp)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Reset denied by firmware, it may be inhibited by remote driver");
+			return -EPERM;
+		}
 		rtnl_lock();
 		if (bp->dev->reg_state == NETREG_UNREGISTERED) {
 			rtnl_unlock();
@@ -863,6 +890,32 @@ static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 	return 0;
 }
 
+static int bnxt_remote_dev_reset_get(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+
+	if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF)
+		return -EOPNOTSUPP;
+
+	ctx->val.vbool = bnxt_dl_get_remote_reset(dl);
+	return 0;
+}
+
+static int bnxt_remote_dev_reset_set(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	int rc;
+
+	rc = bnxt_hwrm_remote_dev_reset_set(bp, ctx->val.vbool);
+	if (rc)
+		return rc;
+
+	bnxt_dl_set_remote_reset(dl, ctx->val.vbool);
+	return rc;
+}
+
 static const struct devlink_param bnxt_dl_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_SRIOV,
 			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
@@ -885,17 +938,25 @@ static const struct devlink_param bnxt_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			     bnxt_dl_nvm_param_get, bnxt_dl_nvm_param_set,
 			     NULL),
+	/* keep REMOTE_DEV_RESET last, it is excluded based on caps */
+	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      bnxt_remote_dev_reset_get,
+			      bnxt_remote_dev_reset_set, NULL),
 };
 
 static int bnxt_dl_params_register(struct bnxt *bp)
 {
+	int num_params = ARRAY_SIZE(bnxt_dl_params);
 	int rc;
 
 	if (bp->hwrm_spec_code < 0x10600)
 		return 0;
 
-	rc = devlink_params_register(bp->dl, bnxt_dl_params,
-				     ARRAY_SIZE(bnxt_dl_params));
+	if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF)
+		num_params--;
+
+	rc = devlink_params_register(bp->dl, bnxt_dl_params, num_params);
 	if (rc)
 		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d\n",
 			    rc);
@@ -904,11 +965,15 @@ static int bnxt_dl_params_register(struct bnxt *bp)
 
 static void bnxt_dl_params_unregister(struct bnxt *bp)
 {
+	int num_params = ARRAY_SIZE(bnxt_dl_params);
+
 	if (bp->hwrm_spec_code < 0x10600)
 		return;
 
-	devlink_params_unregister(bp->dl, bnxt_dl_params,
-				  ARRAY_SIZE(bnxt_dl_params));
+	if (~bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF)
+		num_params--;
+
+	devlink_params_unregister(bp->dl, bnxt_dl_params, num_params);
 }
 
 int bnxt_dl_register(struct bnxt *bp)
@@ -933,6 +998,7 @@ int bnxt_dl_register(struct bnxt *bp)
 	bp->dl = dl;
 	bp_dl = devlink_priv(dl);
 	bp_dl->bp = bp;
+	bnxt_dl_set_remote_reset(dl, true);
 
 	/* Add switchdev eswitch mode setting, if SRIOV supported */
 	if (pci_find_ext_capability(bp->pdev, PCI_EXT_CAP_ID_SRIOV) &&
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index a189cfe1e441..456e18c4badf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -13,6 +13,7 @@
 /* Struct to hold housekeeping info needed by devlink interface */
 struct bnxt_dl {
 	struct bnxt *bp;	/* back ptr to the controlling dev */
+	bool remote_reset;
 };
 
 static inline struct bnxt *bnxt_get_bp_from_dl(struct devlink *dl)
@@ -27,6 +28,16 @@ static inline void bnxt_dl_remote_reload(struct bnxt *bp)
 						BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
 }
 
+static inline bool bnxt_dl_get_remote_reset(struct devlink *dl)
+{
+	return ((struct bnxt_dl *)devlink_priv(dl))->remote_reset;
+}
+
+static inline void bnxt_dl_set_remote_reset(struct devlink *dl, bool value)
+{
+	((struct bnxt_dl *)devlink_priv(dl))->remote_reset = value;
+}
+
 #define NVM_OFF_MSIX_VEC_PER_PF_MAX	108
 #define NVM_OFF_MSIX_VEC_PER_PF_MIN	114
 #define NVM_OFF_IGNORE_ARI		164
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ac8df5c6906f..15c518024965 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2187,6 +2187,11 @@ int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 	struct hwrm_fw_reset_input *req;
 	int rc;
 
+	if (!bnxt_hwrm_reset_permitted(bp)) {
+		netdev_warn(bp->dev, "Reset denied by firmware, it may be inhibited by remote driver");
+		return -EPERM;
+	}
+
 	rc = hwrm_req_init(bp, req, HWRM_FW_RESET);
 	if (rc)
 		return rc;
-- 
2.18.1


--000000000000f62bab05cf790c12
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL/37p5B8iD4Cuy3r9p1LgSprRC88dRL
jpHOePsCT28mMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBCLkWmYHs8WByU7/Du70x1Bh01oE2RMnMIsgXxfil9Caepa+o6
IAsDzlj0UjllY8yc/htNAjJFeBSMbEJI/0/ndCTzpposacwFieo9tCIo+7hYyiA6USPPSTcPp9Eo
9PStjldhemdkra7HesODftqn7klSuJTFHqTcb7Iradf7TJnMT1CY5Y7YA8rdGA6/HJAExy61ebl2
M6xPw6sHhE099nMDfToCcOT3ryL3MCWbNxHfKkXHdKVhQoW5PTCqHkPhsIY+WtqBXdKnz+XiXZK3
M06c8dK4BEgbua7DgWTTbrl8Y8YAlJvORzuwQBqhJFOZAJBf8nl/HHNLftRGEBnq
--000000000000f62bab05cf790c12--
