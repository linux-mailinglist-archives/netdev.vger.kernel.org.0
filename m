Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC56D3FA7BF
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhH1V7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 17:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhH1V7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 17:59:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3627CC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:58:52 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lc21so22028927ejc.7
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=96I0CbkrLQTttbpdacRS+/paMaw4hDYa0xqYSbHwxYM=;
        b=Bb8ZwTsJGa9gdORSLAq9R8Dzs/Q7pD+m2yk4LWbilr0GoWRZWGUYPtqrtttbanIoA7
         RHXqfB/nS1OCspe8W5DyZbYi4LXwcaZ/6HtGidpuJn+KfOtCHYI0aMzsSH5m7DGK50ux
         IjBNc8en5ft0QOSKsJWLmVtx5+0Tz2mWB+8Q4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=96I0CbkrLQTttbpdacRS+/paMaw4hDYa0xqYSbHwxYM=;
        b=VB9+WnOZBBsxLUIA53MQJx58Q4i+Cbxe17/W2uiCw0DczKfweV3akrN8YNrCkw9sB0
         ao7G9EH9uiT2BwqPIvcG3F+N3hK2yx79Pg6uB68XQ63aEJLgXLdeV9I8nu/vFhOi0y2q
         2fns0jegRtkMPQSmwitJX2XGRjSJbWinXC2UbjFJk+s1bDn8LHb2HEPu2dup+DzpBbte
         MZK2yaqQaeLK/8cKnaw/cR8bKMlCFLEUqwVcD600C0X3u1vmHp5tXHtHmA+NIzoE36i5
         ixzvPfmpNaYLpkPfUQaV84VkXzxzOXXYBNzsQGlEhyIeBFo7IAGG+TuXIhX6Cpsi9iaO
         v1lw==
X-Gm-Message-State: AOAM533BsWevVpQ2VhZKOQjXbidoK0zM5kSLYan5LjiDHgWwvFHOwXYx
        aZQ6HNpPp8x0x8jz4q+STO3uBA==
X-Google-Smtp-Source: ABdhPJw1p4PXRYcnhpOCVcDKDpmiBl0hbYB/S3jfFFd84WLhWbpEH85eYU4gyitJC9shiHtwb6S5Yg==
X-Received: by 2002:a17:906:af9a:: with SMTP id mj26mr16711441ejb.96.1630187930258;
        Sat, 28 Aug 2021 14:58:50 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cf11sm5361239edb.65.2021.08.28.14.58.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Aug 2021 14:58:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next 02/11] bnxt_en: Refactor the HWRM_VER_GET firmware calls
Date:   Sat, 28 Aug 2021 17:58:21 -0400
Message-Id: <1630187910-22252-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
References: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008a9dd205caa5b4de"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008a9dd205caa5b4de

From: Edwin Peer <edwin.peer@broadcom.com>

Refactor the code so that __bnxt_hwrm_ver_get() does not call
bnxt_hwrm_do_send_msg() directly.  The new APIs will not expose this
internal call.  Add a new bnxt_hwrm_poll() to poll the HWRM_VER_GET
firmware call silently.  The other bnxt_hwrm_ver_get() function will
send the HWRM_VER_GET message directly with error logs enabled.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fb75fa9614c5..dd2f80c394f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8036,7 +8036,7 @@ static int bnxt_hwrm_queue_qportcfg(struct bnxt *bp)
 	return rc;
 }
 
-static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
+static int bnxt_hwrm_poll(struct bnxt *bp)
 {
 	struct hwrm_ver_get_input req = {0};
 	int rc;
@@ -8046,21 +8046,26 @@ static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
 	req.hwrm_intf_min = HWRM_VERSION_MINOR;
 	req.hwrm_intf_upd = HWRM_VERSION_UPDATE;
 
-	rc = bnxt_hwrm_do_send_msg(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT,
-				   silent);
+	rc = _hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	return rc;
 }
 
 static int bnxt_hwrm_ver_get(struct bnxt *bp)
 {
 	struct hwrm_ver_get_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_ver_get_input req = {0};
 	u16 fw_maj, fw_min, fw_bld, fw_rsv;
 	u32 dev_caps_cfg, hwrm_ver;
 	int rc, len;
 
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_VER_GET, -1, -1);
 	bp->hwrm_max_req_len = HWRM_MAX_REQ_LEN;
+	req.hwrm_intf_maj = HWRM_VERSION_MAJOR;
+	req.hwrm_intf_min = HWRM_VERSION_MINOR;
+	req.hwrm_intf_upd = HWRM_VERSION_UPDATE;
+
 	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = __bnxt_hwrm_ver_get(bp, false);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
 		goto hwrm_ver_get_exit;
 
@@ -9791,7 +9796,7 @@ static int bnxt_try_recover_fw(struct bnxt *bp)
 		mutex_lock(&bp->hwrm_cmd_lock);
 		do {
 			sts = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
-			rc = __bnxt_hwrm_ver_get(bp, true);
+			rc = bnxt_hwrm_poll(bp);
 			if (!BNXT_FW_IS_BOOTING(sts) &&
 			    !BNXT_FW_IS_RECOVERING(sts))
 				break;
@@ -12234,7 +12239,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		fallthrough;
 	case BNXT_FW_RESET_STATE_POLL_FW:
 		bp->hwrm_cmd_timeout = SHORT_HWRM_CMD_TIMEOUT;
-		rc = __bnxt_hwrm_ver_get(bp, true);
+		rc = bnxt_hwrm_poll(bp);
 		if (rc) {
 			if (bnxt_fw_reset_timeout(bp)) {
 				netdev_err(bp->dev, "Firmware reset aborted\n");
-- 
2.18.1


--0000000000008a9dd205caa5b4de
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINEP878kJmLg/sCAa3TRyKuhwbcs7NOR
+bmkkuzyiV25MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
ODIxNTg1MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAb4IboH6xYP1JLcg4LvpVSRB5d4Kg3hRYo74P0wapBiNRRcYCx
oMc462RakiFQ1JodyHcUbINGhvLjEP+oUXBshucK8ZN081bhV0V2OURtIs8r57NuzIVpkVzvk/VW
MIbcph6tzqkFoRYJ+fe7LT0Nb8WllqpfhGcI5slyF9NfA6VqPX1xVR4SY6AOoStR6Z0UiKpBAaa5
FdUBg64LTcwJhWwAGc+mu8UmBc6ilZ0J08VMeA89sS3nbo2CBeOi0xGWkv1R481M1ywx7guYGe1f
5MFK2Cesu+QHs5PAy2PscR6vrl5tZCf6cEe+wUHJQBu1A/JpJPpTu53Ctw5mLBF1
--0000000000008a9dd205caa5b4de--
