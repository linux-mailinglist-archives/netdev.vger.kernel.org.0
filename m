Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80B628A6F1
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 12:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgJKKXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 06:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgJKKXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 06:23:30 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA87C0613D5
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:23:29 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w21so10787087pfc.7
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r2BHCJHlWVuv0GsFJ5mqbEK4wFFnjhnFJcE2N7Qz3NY=;
        b=SNTedbf37W59tovTVUP19ukRakP/o1Bxy8duMN8yMhzvSPqpoxMfye++tvpoqVFirW
         Nbk46L8aHRBrIQycm328iD/D6F0h0ErvKQtfLdOCDVzp7jHQwBi2yus5N6tQxYSkx4J4
         3b/jh7ekdOJmrA0ZHvhJ6mIGOFlKoHseTpoMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r2BHCJHlWVuv0GsFJ5mqbEK4wFFnjhnFJcE2N7Qz3NY=;
        b=l6rkI90tDRA9OSZ1eFBQP8H/G7RJyeIHWfCsCBjQg4YZX/4nv725ZXyTBvV+5ZrtHg
         2Ym6m6gO36Nh0LY0uKiW32Jne8ERXdKEM+t7jBIc8VQtO7UnbEK5E+efZZuCA2RxZ7a6
         SATxuc1iQhF3zIrn/nkhc98S7BYNZIMVGSEfn93L1J6/WdcRnsBG0+2zVmKNm3SjRywV
         c0MDCWmfdw7O8IKjzd8YFqZlgmyrEgJ7FiOdBJRZXm5yCCexLfLR++xtpbBq1kWNhpyS
         mVrcaUJFrzbpF2sf3q/wu+jVzxlM8oFG9nGwH1aoPw7XXaF2AED/akpqq+L/jvf1dmrt
         ys4g==
X-Gm-Message-State: AOAM533mzdaxEno2YiDd8Kf3hrmxaw05sHQXHVgqQCZX5QG7e2nlFfvU
        kEc3+5W62IhocIfxikTUkORjCyLtbnj2Dg==
X-Google-Smtp-Source: ABdhPJzDzLGn9iw0d5228Fj6AJdklLPwvJZlOBt0yYg/EOj+Ovdem+c68EDtiVL0gVJG2PulKn8ODg==
X-Received: by 2002:a63:5043:: with SMTP id q3mr9543278pgl.293.1602411809159;
        Sun, 11 Oct 2020 03:23:29 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i1sm20155057pjh.52.2020.10.11.03.23.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 03:23:28 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 8/9] bnxt_en: Refactor bnxt_dl_info_get().
Date:   Sun, 11 Oct 2020 06:23:00 -0400
Message-Id: <1602411781-6012-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b1b0b205b1629210"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b1b0b205b1629210

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add a new function bnxt_dl_info_put() to simplify the code, as there
are more stored firmware version fields to be added in the next patch.

Also, rename fw_ver variable name to ncsi_ver for better naming while
copying to devlink info_get cb.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 112 ++++++++++--------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |   6 +
 2 files changed, 70 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index d436134bdc40..65e8da1f7a01 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -382,6 +382,29 @@ static int bnxt_hwrm_get_nvm_cfg_ver(struct bnxt *bp,
 	return rc;
 }
 
+static int bnxt_dl_info_put(struct bnxt *bp, struct devlink_info_req *req,
+			    enum bnxt_dl_version_type type, const char *key,
+			    char *buf)
+{
+	if (!strlen(buf))
+		return 0;
+
+	if ((bp->flags & BNXT_FLAG_CHIP_P5) &&
+	    (!strcmp(key, DEVLINK_INFO_VERSION_GENERIC_FW_NCSI) ||
+	     !strcmp(key, DEVLINK_INFO_VERSION_GENERIC_FW_ROCE)))
+		return 0;
+
+	switch (type) {
+	case BNXT_VERSION_FIXED:
+		return devlink_info_version_fixed_put(req, key, buf);
+	case BNXT_VERSION_RUNNING:
+		return devlink_info_version_running_put(req, key, buf);
+	case BNXT_VERSION_STORED:
+		return devlink_info_version_stored_put(req, key, buf);
+	}
+	return 0;
+}
+
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack)
 {
@@ -390,7 +413,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	struct hwrm_ver_get_output *ver_resp;
 	char mgmt_ver[FW_VER_STR_LEN];
 	char roce_ver[FW_VER_STR_LEN];
-	char fw_ver[FW_VER_STR_LEN];
+	char ncsi_ver[FW_VER_STR_LEN];
 	char buf[32];
 	int rc;
 
@@ -398,10 +421,11 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
-	if (strlen(bp->board_partno)) {
-		rc = devlink_info_version_fixed_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
-			bp->board_partno);
+	if (BNXT_PF(bp) && (bp->flags & BNXT_FLAG_DSN_VALID)) {
+		sprintf(buf, "%02X-%02X-%02X-%02X-%02X-%02X-%02X-%02X",
+			bp->dsn[7], bp->dsn[6], bp->dsn[5], bp->dsn[4],
+			bp->dsn[3], bp->dsn[2], bp->dsn[1], bp->dsn[0]);
+		rc = devlink_info_serial_number_put(req, buf);
 		if (rc)
 			return rc;
 	}
@@ -412,54 +436,49 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_FIXED,
+			      DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+			      bp->board_partno);
+	if (rc)
+		return rc;
+
 	sprintf(buf, "%X", bp->chip_num);
-	rc = devlink_info_version_fixed_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_FIXED,
+			      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
 	if (rc)
 		return rc;
 
 	ver_resp = &bp->ver_resp;
 	sprintf(buf, "%X", ver_resp->chip_rev);
-	rc = devlink_info_version_fixed_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_ASIC_REV, buf);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_FIXED,
+			      DEVLINK_INFO_VERSION_GENERIC_ASIC_REV, buf);
 	if (rc)
 		return rc;
 
-	if (BNXT_PF(bp)) {
-		sprintf(buf, "%02X-%02X-%02X-%02X-%02X-%02X-%02X-%02X",
-			bp->dsn[7], bp->dsn[6], bp->dsn[5], bp->dsn[4],
-			bp->dsn[3], bp->dsn[2], bp->dsn[1], bp->dsn[0]);
-		rc = devlink_info_serial_number_put(req, buf);
-		if (rc)
-			return rc;
-	}
-
-	if (strlen(ver_resp->active_pkg_name)) {
-		rc =
-		    devlink_info_version_running_put(req,
-					DEVLINK_INFO_VERSION_GENERIC_FW,
-					ver_resp->active_pkg_name);
-		if (rc)
-			return rc;
-	}
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW,
+			      ver_resp->active_pkg_name);
+	if (rc)
+		return rc;
 
 	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
 		u32 ver = nvm_cfg_ver.vu32;
 
 		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
 			ver & 0xF);
-		rc = devlink_info_version_running_put(req,
-				DEVLINK_INFO_VERSION_GENERIC_FW_PSID, buf);
+		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+				      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
+				      buf);
 		if (rc)
 			return rc;
 	}
 
 	if (ver_resp->flags & VER_GET_RESP_FLAGS_EXT_VER_AVAIL) {
-		snprintf(fw_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
 			 ver_resp->hwrm_fw_major, ver_resp->hwrm_fw_minor,
 			 ver_resp->hwrm_fw_build, ver_resp->hwrm_fw_patch);
 
-		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		snprintf(ncsi_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
 			 ver_resp->mgmt_fw_major, ver_resp->mgmt_fw_minor,
 			 ver_resp->mgmt_fw_build, ver_resp->mgmt_fw_patch);
 
@@ -467,11 +486,11 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			 ver_resp->roce_fw_major, ver_resp->roce_fw_minor,
 			 ver_resp->roce_fw_build, ver_resp->roce_fw_patch);
 	} else {
-		snprintf(fw_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
 			 ver_resp->hwrm_fw_maj_8b, ver_resp->hwrm_fw_min_8b,
 			 ver_resp->hwrm_fw_bld_8b, ver_resp->hwrm_fw_rsvd_8b);
 
-		snprintf(mgmt_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
+		snprintf(ncsi_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
 			 ver_resp->mgmt_fw_maj_8b, ver_resp->mgmt_fw_min_8b,
 			 ver_resp->mgmt_fw_bld_8b, ver_resp->mgmt_fw_rsvd_8b);
 
@@ -479,29 +498,26 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			 ver_resp->roce_fw_maj_8b, ver_resp->roce_fw_min_8b,
 			 ver_resp->roce_fw_bld_8b, ver_resp->roce_fw_rsvd_8b);
 	}
-	rc = devlink_info_version_running_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, fw_ver);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, mgmt_ver);
 	if (rc)
 		return rc;
 
-	rc = devlink_info_version_running_put(req,
-				DEVLINK_INFO_VERSION_GENERIC_FW_MGMT_API,
-				bp->hwrm_ver_supp);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT_API,
+			      bp->hwrm_ver_supp);
 	if (rc)
 		return rc;
 
-	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
-		rc = devlink_info_version_running_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_FW_NCSI, mgmt_ver);
-		if (rc)
-			return rc;
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_NCSI, ncsi_ver);
+	if (rc)
+		return rc;
 
-		rc = devlink_info_version_running_put(req,
-			DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
-		if (rc)
-			return rc;
-	}
-	return 0;
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_RUNNING,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+
+	return rc;
 }
 
 static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index d5c8bd49383a..d22cab5d6856 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -60,6 +60,12 @@ struct bnxt_dl_nvm_param {
 	u8 dl_num_bytes;
 };
 
+enum bnxt_dl_version_type {
+	BNXT_VERSION_FIXED,
+	BNXT_VERSION_RUNNING,
+	BNXT_VERSION_STORED,
+};
+
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
 void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy);
 void bnxt_dl_health_recovery_done(struct bnxt *bp);
-- 
2.18.1


--000000000000b1b0b205b1629210
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgKxGXruSCnPsy
wiHh8YpsMF4tLgAcZ/ZctYO336s3ZrYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDExMTAyMzI5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGteyS9qE+vmw21u8cXxS7oD6uAUnpUv
KGtoeqx3fUzMRMZu5wlJ/wo3g0LUcflbALuJ3hqVUdaTK8Vs57E6Z291gbhgbONIpDAvp9lJ1QQ6
et8O4q9F5wUledHvPSqdGeKtSM+lHOE4oBaa/Uf9IvLwAFrDIXjklhRnDfJmgwacLVnuyfktMJl9
tni+DXbTgjl51KscECUktli/sL7TSVxvunG03bpmmm+DlSWBlHdKua8fabcoGHNx6yfIlNzG9+vc
g4prbPLWq4CyrvdSieffyKMFYMxidV/hpfeKAluokz3S0rFGMMdtY89YbgtNh6NZrgex93baaMep
XZHB3+s=
--000000000000b1b0b205b1629210--
