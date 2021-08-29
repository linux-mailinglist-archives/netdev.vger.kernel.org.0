Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200BA3FA9F5
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhH2HgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbhH2HgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:36:17 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BF6C061756
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:24 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a25so23720314ejv.6
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sypkhkn62vaYnEeJp7klgNVQCG3wMF7Qwy18rpJSoFA=;
        b=dkag/ExZTIW51CtOqSUfsZZjbTYhlAQPVQZi/ogqrOLvovqk03BpnRvvHuYHP4VG+P
         QZXJyzIZTqgYuIg7JYxlfBKHZ2A4PD0VDSrpViy3kdUYN2Sgs7ckk6V4gBc3imU5SrX6
         GSvWe/xu19O4LvPXkPolLaGZO7QDc6GdtetIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sypkhkn62vaYnEeJp7klgNVQCG3wMF7Qwy18rpJSoFA=;
        b=j7z/V7QsbZBcPolQcXBj0fZB+YoYefssyhu1wXZgAWxrsuT+LtEskkKHLePoqcYhe1
         ipmGZdn5W0Ropukz7OFFr23ZPHrZEvkmYOFEFD47zOs4/JCmVrb2LzO5jLwfTGQRVLm2
         EoCa6GFwZ4HIBxu+AoKwku15JnyLG1zIWBKzfpnT5fKrWEI7RbgHeOesiSWWtGM0UgJS
         XXKhMhb7I3jS6qmxRg3WkM3BeBEYaZWsw62Qfn+fOvRKDRLXOrgS8XgSpR5H7eKAyDdE
         HCDbtSJ18LNITOp0jY+dw9QVr7S0W6Cw4RbO7/Q1j2/2lyWBO9yWJa/3jIIbqbtIbBO9
         LHug==
X-Gm-Message-State: AOAM530PL52z4ZHJM/G5HMSOz6J+n8zB1kRnDPglpxpR4X0YsEafSdx5
        7mnMPQt3Q8V6Ljvhv6BO6OMIOw==
X-Google-Smtp-Source: ABdhPJwFfUUwiVDUrm1adP7/qxZzWsAX3KD/TN6aaaeMJl6SAL89CHKcUwQTbI8E27fy93uXtMd7eg==
X-Received: by 2002:a17:906:bb03:: with SMTP id jz3mr19545150ejb.79.1630222523175;
        Sun, 29 Aug 2021 00:35:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id dy7sm984007edb.38.2021.08.29.00.35.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Aug 2021 00:35:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next v2 02/11] bnxt_en: Refactor the HWRM_VER_GET firmware calls
Date:   Sun, 29 Aug 2021 03:34:57 -0400
Message-Id: <1630222506-19532-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006f19be05caadc21b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006f19be05caadc21b

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


--0000000000006f19be05caadc21b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINEP878kJmLg/sCAa3TRyKuhwbcs7NOR
+bmkkuzyiV25MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
OTA3MzUyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBb6PhCZAoa0C3WekjSwu+2xP8/bgVjT70CEK3znKi1S1fqtNbE
w0C63+VddEMVOMgjpgb4AbypaRv9XVCdryaRetHTejGWtPkGvkTipf1VZdFMTeqbLHBoWiYy5gDm
FJZy4AjQ9S0hxVmEbhV5XnR80tHqeGwjd5ITOsUBc+XM/tdsM3wdBKrY7XS5KgK2OcwfDb3w983L
3WDybEPQD+4BrSwq1lAadZdYMAlsAkHum8Gh/gBc8ib0axbJKnajq+cIUsJ4ubPWlt/vhY08Vb4M
qr2ITt8hXltj7mRuEQUVI4g1Tv3rEJQvaRBhXIrtnLuAXeWFstZ46Y9v+vxwyN7W
--0000000000006f19be05caadc21b--
