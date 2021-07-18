Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F533CCA74
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhGRTjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 15:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhGRTjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 15:39:52 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCE6C061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 12:36:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a127so14349834pfa.10
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 12:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dERt6o2UteVPOsj5iZQehtuP4vuXB7YNcVjFqprJn+c=;
        b=RzxroMmoyCsavmP1Km+RPtKZ3Q0LH7pea3O4IcVe4xlBsneH8zynqhOrrheOfJLgw4
         PqkSxoyN7Wub6Ygzi/ryg2vW65ALEDiHShmR9CF1EKSLFZ3D4/QIancsfZKCSdbfXzyb
         +vBxdLKW9QsQ1Dsagv6zl+HbeLQtJ0VqsP6Ac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dERt6o2UteVPOsj5iZQehtuP4vuXB7YNcVjFqprJn+c=;
        b=J99CSUxURXxYw0Q/5eoK4rkNc4q6mbvYq3hpDU6PtzqVxmUF+Z4e4Dsxme+GsIg7Pm
         9NNfyNljn3owcmQzd4BfKZrtgzBLfXGpYRn9+7S1ZQ81sJ3cYagsoAXqcd8umLTgh+8k
         0qx+pWSWcXXAcKViJNlrAcn2R/eidfdT1VYjLHqtFgqO67+kFfujbjQzSuMIoavkdpNp
         z4yVc8MY0Ej0/S8TgVaEfJc3Pn2EyUXd0Yh1lNMiHhC7I/GDEbTmZ8UdyaTYxszl7bIS
         B0RSaTgfRd5jIMurOWL+Q/iwjKLRrIEfBXFzDij2fVjYKAg+4FqCiTpvnukf05+4gP1q
         rq5w==
X-Gm-Message-State: AOAM531mDKPHnzsui4ZCqjJKqAFyHyiqxp7pvA7ZVo9Jz/X+AkSWHkey
        gy1JT3Kcn5CimHOx/a/bfa8GEicljyJ8cXaw
X-Google-Smtp-Source: ABdhPJyC1WOWo/aIE/qSy9+4zDtL4CUvm1ROFIdnTtvmLtCJgVXZac+djByCdt4q4CkDySSjmUQ2Kg==
X-Received: by 2002:a65:6a0b:: with SMTP id m11mr21525359pgu.380.1626637012956;
        Sun, 18 Jul 2021 12:36:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm16743648pfo.80.2021.07.18.12.36.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Jul 2021 12:36:52 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 5/9] bnxt_en: fix error path of FW reset
Date:   Sun, 18 Jul 2021 15:36:29 -0400
Message-Id: <1626636993-31926-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
References: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005d1c9405c76af162"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005d1c9405c76af162

From: Somnath Kotur <somnath.kotur@broadcom.com>

When bnxt_open() fails in the firmware reset path, the driver needs to
gracefully abort, but it is executing code that should be invoked only
in the success path.  Define a function to abort FW reset and
consolidate all error paths to call this new function.

Fixes: dab62e7c2de7 ("bnxt_en: Implement faster recovery for firmware fatal error.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 31 +++++++++++++++--------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 39908a3d9460..f2f1136fd492 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11959,10 +11959,21 @@ static bool bnxt_fw_reset_timeout(struct bnxt *bp)
 			  (bp->fw_reset_max_dsecs * HZ / 10));
 }
 
+static void bnxt_fw_reset_abort(struct bnxt *bp, int rc)
+{
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	if (bp->fw_reset_state != BNXT_FW_RESET_STATE_POLL_VF) {
+		bnxt_ulp_start(bp, rc);
+		bnxt_dl_health_status_update(bp, false);
+	}
+	bp->fw_reset_state = 0;
+	dev_close(bp->dev);
+}
+
 static void bnxt_fw_reset_task(struct work_struct *work)
 {
 	struct bnxt *bp = container_of(work, struct bnxt, fw_reset_task.work);
-	int rc;
+	int rc = 0;
 
 	if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
 		netdev_err(bp->dev, "bnxt_fw_reset_task() called when not in fw reset mode!\n");
@@ -11993,8 +12004,9 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bp->fw_reset_timestamp = jiffies;
 		rtnl_lock();
 		if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state)) {
+			bnxt_fw_reset_abort(bp, rc);
 			rtnl_unlock();
-			goto fw_reset_abort;
+			return;
 		}
 		bnxt_fw_reset_close(bp);
 		if (bp->fw_cap & BNXT_FW_CAP_ERR_RECOVER_RELOAD) {
@@ -12043,6 +12055,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			if (val == 0xffff) {
 				if (bnxt_fw_reset_timeout(bp)) {
 					netdev_err(bp->dev, "Firmware reset aborted, PCI config space invalid\n");
+					rc = -ETIMEDOUT;
 					goto fw_reset_abort;
 				}
 				bnxt_queue_fw_reset_work(bp, HZ / 1000);
@@ -12052,6 +12065,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
+			rc = -ENODEV;
 			goto fw_reset_abort;
 		}
 		pci_set_master(bp->pdev);
@@ -12078,9 +12092,10 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		}
 		rc = bnxt_open(bp->dev);
 		if (rc) {
-			netdev_err(bp->dev, "bnxt_open_nic() failed\n");
-			clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-			dev_close(bp->dev);
+			netdev_err(bp->dev, "bnxt_open() failed during FW reset\n");
+			bnxt_fw_reset_abort(bp, rc);
+			rtnl_unlock();
+			return;
 		}
 
 		bp->fw_reset_state = 0;
@@ -12107,12 +12122,8 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		netdev_err(bp->dev, "fw_health_status 0x%x\n", sts);
 	}
 fw_reset_abort:
-	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-	if (bp->fw_reset_state != BNXT_FW_RESET_STATE_POLL_VF)
-		bnxt_dl_health_status_update(bp, false);
-	bp->fw_reset_state = 0;
 	rtnl_lock();
-	dev_close(bp->dev);
+	bnxt_fw_reset_abort(bp, rc);
 	rtnl_unlock();
 }
 
-- 
2.18.1


--0000000000005d1c9405c76af162
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIu3Sh1X+NJ3+/ochq850MfCa7w4+rZH
Z/NjpkY11DsVMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDcx
ODE5MzY1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBeTex0MpqEseqmt7dnypKWCjRXCX2gJSbKtsFtt5qqo2V8zgVy
wQMNIwHQvi0051IS5FtE0XInhLKwgAYngm1aBcFiTw/1AhdC5f7xWgnzAPS3+UlVDQwE7dT9Roy2
i7rD9HVPWUk+5GI37VVw2fpqkK27qBNiealpeW6KIuPOTIauLo1BuZoHO4MmtzicwAzvpyhl/jpQ
bkbb9vx/2SLPoMTCLfRqo/Y6uYwiZe07UplUm5QfTOvlvU1erRST1zxKuFzt6prRwFBQrTLKzwLE
BmxfjDw0osGvyRDQK0/iZk30Rpf6LvfJHoDhXbLaUVSbagJ/wyc0myxOWK+XtvrQ
--0000000000005d1c9405c76af162--
