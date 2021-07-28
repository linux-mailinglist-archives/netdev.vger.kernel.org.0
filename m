Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1653D950D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhG1SME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhG1SMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:12:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571BAC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:01 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n10so3693922plf.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OigGUz1+gvxIgnPeat1fHQ9zeRBLm/RVvWz5JrC72xg=;
        b=TqEBtuqEuWWmDiINItlgCbQSFLdMShDJDxzuTZnUg4owwUXKqJ8NIg4KpP5cXjG13J
         a625jyHSl8C+NHldAAD+hWJCUdcRMzhbaisyfCZHYW0zlpN90Cqo/dwYlycEYQzKN2qb
         NV+/eOnTKMkr2MD+vXDm8D2R5MCgVFigj86Kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OigGUz1+gvxIgnPeat1fHQ9zeRBLm/RVvWz5JrC72xg=;
        b=WsBUaLsR8YRqVol0CKzq7pqpaZN3r2S53hgBAd759RdETP2CpPaZC3kzoTDM2otYQu
         +G8V9Sv0E3n0YE0DsRLfJHcvBA1RYkPScRCuXQlWKyoZn4VyEP9Y9LIPsZOKp2dABh3L
         f3tLZvN5wGthWTbO32j6Vzwcpradj1sz9Q41Y6ULuaDFUCyNlCPqMYHSdmPd9k5GI1vk
         vryfMycVziLnoB7ax3T/fH0ALMxRPWo5whf/CDtXivVnBRJ0TES5v7amujsyUVibQ8iW
         ghRELYX8NZuvPOfOSA7f/el6a8ltrxnINN9HkEkyVVQ/5If9Y8JkukSkhBB0jsCsM8/F
         yIjQ==
X-Gm-Message-State: AOAM530IVxaU8qBbQWDk87nEyecKGlsu2t8f3eqlm08khzyZH6dhsrH4
        VLlUY4X6ABS9psmUvYphzMpyxiQzYqpSuQ==
X-Google-Smtp-Source: ABdhPJy7DM123P0pO7sAjvTzsaI3oOOExET4s+hBexcduf93WuD7FA/yMTKnUPVW+DyrmrgS3RVZZA==
X-Received: by 2002:a17:90b:a54:: with SMTP id gw20mr969348pjb.215.1627495920379;
        Wed, 28 Jul 2021 11:12:00 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a16sm678901pfo.66.2021.07.28.11.11.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 11:11:59 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 1/6] bnxt_en: Move bnxt_ptp_init() from bnxt_open() back to bnxt_init_one()
Date:   Wed, 28 Jul 2021 14:11:40 -0400
Message-Id: <1627495905-17396-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
References: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000040704c05c832ec58"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000040704c05c832ec58

It was pointed out by Richard Cochran that registering the PHC during
probe is better than during ifup, so move bnxt_ptp_init() back to
bnxt_init_one().  In order to work correctly after firmware reset which
may result in PTP config. changes, we modify bnxt_ptp_init() to return
if the PHC has been registered earlier.  If PTP is no longer supported
by the new firmware, we will unregister the PHC and clean up.

This partially reverts:

d7859afb6880 ("bnxt_en: Move bnxt_ptp_init() to bnxt_open()")

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 18 +++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c |  3 +++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4db162cee911..7cb2b79c154c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7495,9 +7495,14 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 		rc = -ENODEV;
 		goto no_ptp;
 	}
-	return 0;
+	rc = bnxt_ptp_init(bp);
+	if (!rc)
+		return 0;
+
+	netdev_warn(bp->dev, "PTP initialization failed.\n");
 
 no_ptp:
+	bnxt_ptp_clear(bp);
 	kfree(ptp);
 	bp->ptp_cfg = NULL;
 	return rc;
@@ -7577,6 +7582,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		if (flags & FUNC_QCAPS_RESP_FLAGS_PTP_SUPPORTED) {
 			__bnxt_hwrm_ptp_qcfg(bp);
 		} else {
+			bnxt_ptp_clear(bp);
 			kfree(bp->ptp_cfg);
 			bp->ptp_cfg = NULL;
 		}
@@ -10277,15 +10283,9 @@ static int bnxt_open(struct net_device *dev)
 	if (rc)
 		return rc;
 
-	if (bnxt_ptp_init(bp)) {
-		netdev_warn(dev, "PTP initialization failed.\n");
-		kfree(bp->ptp_cfg);
-		bp->ptp_cfg = NULL;
-	}
 	rc = __bnxt_open_nic(bp, true, true);
 	if (rc) {
 		bnxt_hwrm_if_change(bp, false);
-		bnxt_ptp_clear(bp);
 	} else {
 		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state)) {
 			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
@@ -10376,7 +10376,6 @@ static int bnxt_close(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
-	bnxt_ptp_clear(bp);
 	bnxt_hwmon_close(bp);
 	bnxt_close_nic(bp, true, true);
 	bnxt_hwrm_shutdown_link(bp);
@@ -11363,7 +11362,6 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
 		bnxt_clear_int_mode(bp);
 		pci_disable_device(bp->pdev);
 	}
-	bnxt_ptp_clear(bp);
 	__bnxt_close_nic(bp, true, false);
 	bnxt_vf_reps_free(bp);
 	bnxt_clear_int_mode(bp);
@@ -12706,6 +12704,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	if (BNXT_PF(bp))
 		devlink_port_type_clear(&bp->dl_port);
 
+	bnxt_ptp_clear(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
@@ -13318,6 +13317,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
 	bnxt_ethtool_free(bp);
+	bnxt_ptp_clear(bp);
 	kfree(bp->ptp_cfg);
 	bp->ptp_cfg = NULL;
 	kfree(bp->fw_health);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 9089e7f3fbd4..d2bd4fc1091b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -414,6 +414,9 @@ int bnxt_ptp_init(struct bnxt *bp)
 	if (rc)
 		return rc;
 
+	if (ptp->ptp_clock)
+		return 0;
+
 	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
 	spin_lock_init(&ptp->ptp_lock);
 
-- 
2.18.1


--00000000000040704c05c832ec58
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIM2QukcE4NSptN6Bozeqk0KfSJQElxzv
yGu9kGqFijLMMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDcy
ODE4MTIwMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAgUbzGvCFC4TPOAPwgmvm+2KSix4bA/6O/oamtd85fyMZgmjeo
uCtOphmpaGPhF2nSM7/temENpO13jBBf5y26k41b/PtJmOR8DFWiHoM61wqJeFwMtO6R/9McIyhi
ntkpboLkAKTSx9M8SKWRYPP1hRMLCpwX7/Run0bwNmOvW/42w+BpniTDFM/ro/QAvq0T0x8diSPN
JRxgwbzsVeQLr791SMyBmk0gUjiI5cIW/XxQdTZLeru5llPoW3aVwVB5PC4z3fvJsn0kwwS0/dsN
mhzuMp9HcVqODosaHgIHkWikWdGOP+ndpNL/x6iCiFlbrbMXoDIFKKzoeMbQWd4x
--00000000000040704c05c832ec58--
