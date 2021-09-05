Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD90D401120
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 20:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbhIESMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 14:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbhIESMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 14:12:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C8EC061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 11:11:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso3060212pjb.3
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 11:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xpl/IVGaIhLii+8suXr89jhWI6f+0uDEi0qgAhmHLQs=;
        b=SV3pAjlUZw/jVwh6n6aTSoJgUN5GxssaYumjFYmpSbL6RtnVaie3KfrdPDXXmaoHHU
         t5bXSzRmjAPIjrT/eHyZGgK+cb+ta3Vy6mVOlIrD9erGRNyCItpa1FQg+aYsvHhwDU9V
         IPNJdjcltkEaWI6CL961rdL65vVrI212XTndQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xpl/IVGaIhLii+8suXr89jhWI6f+0uDEi0qgAhmHLQs=;
        b=IQHznfhzgSSooIjORFyvCTq9JLMMcD0KWyPdkKPhSG9t8F9QLr7D7xVTxbj5hbY5Mi
         hpBLimINeyBKQ6kO+6X4ahL7f0xrKv4RqWwIPvxZjD3RESKPNbmY6pIpw6bAU0NSgm02
         Tui5lZgFCse9lQA53jld7pFM+gg1a0BR896bMWek6C7tNAHHOSJFDC08CjJivbEu1CWS
         /ubEjQG1dGElhsaIFkPUGJYjDaAuHCY0MMR8TBMTA8x9Vfv6/GeeOUMywmaI9g6oNJjU
         mCIVo1YQQTLOeo0mAbsXmY2SQ/DUTkv3tWkuVdofNeKFzaxXD5RukRG2ACJbclV1rfR2
         7MhA==
X-Gm-Message-State: AOAM531IB2dJZONWLx+fHw8hi0mWV8zfOFea572yN4BSVElMK7bSECql
        caQ87G0cbv3hW4ei+eA+WXQotA==
X-Google-Smtp-Source: ABdhPJwvtttYApLhKmA7n5GGpopICOAaBrDmMjMsaCFlLfBLvmFwxp0ZbGDODLWdlZ26jm+9y6XMog==
X-Received: by 2002:a17:902:ce87:b0:138:941a:5c72 with SMTP id f7-20020a170902ce8700b00138941a5c72mr7757910plg.24.1630865488258;
        Sun, 05 Sep 2021 11:11:28 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d13sm5058115pfn.114.2021.09.05.11.11.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Sep 2021 11:11:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net 2/5] bnxt_en: fix read of stored FW_PSID version on P5 devices
Date:   Sun,  5 Sep 2021 14:10:56 -0400
Message-Id: <1630865459-19146-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
References: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000026773005cb4376bc"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000026773005cb4376bc

From: Edwin Peer <edwin.peer@broadcom.com>

P5 devices store NVM arrays using a different internal representation.
This implementation detail permeates into the HWRM API, requiring the
caller to explicitly index the array elements in HWRM_NVM_GET_VARIABLE
on these devices. Conversely, older devices do not support the indexed
mode of operation and require reading the raw NVM content.

Fixes: db28b6c77f40 ("bnxt_en: Fix devlink info's stored fw.psid version format.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 45 +++++++++++++------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |  4 +-
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 01c21d75f4d4..cb20e627282a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -352,13 +352,16 @@ static void bnxt_copy_from_nvm_data(union devlink_param_value *dst,
 		dst->vu8 = (u8)val32;
 }
 
-static int bnxt_hwrm_get_nvm_cfg_ver(struct bnxt *bp,
-				     union devlink_param_value *nvm_cfg_ver)
+static int bnxt_hwrm_get_nvm_cfg_ver(struct bnxt *bp, u32 *nvm_cfg_ver)
 {
 	struct hwrm_nvm_get_variable_input *req;
+	u16 bytes = BNXT_NVM_CFG_VER_BYTES;
+	u16 bits = BNXT_NVM_CFG_VER_BITS;
+	union devlink_param_value ver;
 	union bnxt_nvm_data *data;
 	dma_addr_t data_dma_addr;
-	int rc;
+	int rc, i = 2;
+	u16 dim = 1;
 
 	rc = hwrm_req_init(bp, req, HWRM_NVM_GET_VARIABLE);
 	if (rc)
@@ -370,16 +373,34 @@ static int bnxt_hwrm_get_nvm_cfg_ver(struct bnxt *bp,
 		goto exit;
 	}
 
+	/* earlier devices present as an array of raw bytes */
+	if (!BNXT_CHIP_P5(bp)) {
+		dim = 0;
+		i = 0;
+		bits *= 3;  /* array of 3 version components */
+		bytes *= 4; /* copy whole word */
+	}
+
 	hwrm_req_hold(bp, req);
 	req->dest_data_addr = cpu_to_le64(data_dma_addr);
-	req->data_len = cpu_to_le16(BNXT_NVM_CFG_VER_BITS);
+	req->data_len = cpu_to_le16(bits);
 	req->option_num = cpu_to_le16(NVM_OFF_NVM_CFG_VER);
+	req->dimensions = cpu_to_le16(dim);
 
-	rc = hwrm_req_send_silent(bp, req);
-	if (!rc)
-		bnxt_copy_from_nvm_data(nvm_cfg_ver, data,
-					BNXT_NVM_CFG_VER_BITS,
-					BNXT_NVM_CFG_VER_BYTES);
+	while (i >= 0) {
+		req->index_0 = cpu_to_le16(i--);
+		rc = hwrm_req_send_silent(bp, req);
+		if (rc)
+			goto exit;
+		bnxt_copy_from_nvm_data(&ver, data, bits, bytes);
+
+		if (BNXT_CHIP_P5(bp)) {
+			*nvm_cfg_ver <<= 8;
+			*nvm_cfg_ver |= ver.vu8;
+		} else {
+			*nvm_cfg_ver = ver.vu32;
+		}
+	}
 
 exit:
 	hwrm_req_drop(bp, req);
@@ -416,12 +437,12 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 {
 	struct hwrm_nvm_get_dev_info_output nvm_dev_info;
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
-	union devlink_param_value nvm_cfg_ver;
 	struct hwrm_ver_get_output *ver_resp;
 	char mgmt_ver[FW_VER_STR_LEN];
 	char roce_ver[FW_VER_STR_LEN];
 	char ncsi_ver[FW_VER_STR_LEN];
 	char buf[32];
+	u32 ver = 0;
 	int rc;
 
 	rc = devlink_info_driver_name_put(req, DRV_MODULE_NAME);
@@ -475,9 +496,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
-	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
-		u32 ver = nvm_cfg_ver.vu32;
-
+	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &ver)) {
 		sprintf(buf, "%d.%d.%d", (ver >> 16) & 0xff, (ver >> 8) & 0xff,
 			ver & 0xff);
 		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index d22cab5d6856..d889f240da2b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -40,8 +40,8 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 #define NVM_OFF_ENABLE_SRIOV		401
 #define NVM_OFF_NVM_CFG_VER		602
 
-#define BNXT_NVM_CFG_VER_BITS		24
-#define BNXT_NVM_CFG_VER_BYTES		4
+#define BNXT_NVM_CFG_VER_BITS		8
+#define BNXT_NVM_CFG_VER_BYTES		1
 
 #define BNXT_MSIX_VEC_MAX	512
 #define BNXT_MSIX_VEC_MIN_MAX	128
-- 
2.18.1


--00000000000026773005cb4376bc
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJBch/zdHK0SPWSMoBQ0VPFZNGzFTO31
1T2nXK/P8JorMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkw
NTE4MTEyOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAYl83rQfgd5I/YjMp3q0dB4X8PlTBSviRaKHa4PY3SDaKLgTZ5
pDy/55hdlBklgxye8vUU+UR8G3zLHgjJ1G8falcGZJy7J5Hpdbo1rEV851pJ4x3DKVjPRBOy+vcE
iF+EacBELB9epMtpaqzacoRQMqn0XA4aT/vsgwYe0DLNYVKfCYkSAXmzdWr5GUFcPdvJAB5aqhPH
RFUaDAMEmpWYHR/eIFiQ8ZDo5G9LgfbA36NBRG4zallST/FYOqZYCYlNqlAlIBinWDHUvUbKu3dB
ClvVRXQ0kbHSK+xo7xrttINjCGDin1AMsrL5nurWaL2lEhxdOOWkjphwApLLmkRc
--00000000000026773005cb4376bc--
