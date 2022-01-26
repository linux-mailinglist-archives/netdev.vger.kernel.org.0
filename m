Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2090249C2B5
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiAZEki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiAZEkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:40:36 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE9AC06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:35 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o64so22197061pjo.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1Rv8q/Tn35fSrhYqgIYlz+o0VC1ITQsNAgoiqK3u5bs=;
        b=fXy6M3lmahrpjHVAwvJOSd5MQyahtLQoIN0wj3m1dwYfSNU7sxOUthoYZIezLQ3HfU
         aE0/M+7O69WM9XmWXRcfftAO0reS4ypTFRF6mIRJncbShEf15gNgiG/5vV3f+5qDJrNM
         +EGhC8zRAOFn3+Bc6bP3s9Hg1G3QG9sw1xSbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1Rv8q/Tn35fSrhYqgIYlz+o0VC1ITQsNAgoiqK3u5bs=;
        b=0YdHpok5HJa9EE09gaJQblk7kA4+ikLbKcOuavJkw4lrMW2ee91Hw6Ty3b7CVcMRpX
         sC9wLCJaMn89jme4NHbelIi/IO0V+nvAGlDAb0jKDlrjM2ytWJXAzvmXbV4+IkHdn0Mm
         FpMNinvjytOymwtYFAtPsHCjZUgj5fcv7/tZleMG25XoaaQe/2r75B7viOheYp4mBFKE
         H+DxHUzSy9W3uqrHbGT58BM4s33iaeXO3+mW6VT3zRF6x3z8R4G0E9Wij/t1Jkplos5s
         DIVjDJndgNNxvHIV8CW/19WWZXvqFjJXBp+egacgsWtIMZJCooHUn9V3OWbONgWAWLSq
         6Q4w==
X-Gm-Message-State: AOAM532lkZlUTlAdZ0n3fRwwm3Jwd7D1op/i93FV96yUgHvkn4RLdiHU
        WPtGGdnn5o6Dk3dg9exSXXwJ6Q==
X-Google-Smtp-Source: ABdhPJydHQJAlSwdtEFznTI7Yeer1hHCUCE7K0Kx6tUvemEM3nZlXO6i1kPprwa+Y3qs/z2S2XA6iQ==
X-Received: by 2002:a17:902:ea10:b0:14a:f84a:bfa0 with SMTP id s16-20020a170902ea1000b0014af84abfa0mr21559269plg.163.1643172034981;
        Tue, 25 Jan 2022 20:40:34 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s12sm559957pfk.65.2022.01.25.20.40.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 20:40:34 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        pavan.chebbi@broadcom.com,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 2/5] bnxt_en: PTP: Refactor PTP initialization functions
Date:   Tue, 25 Jan 2022 23:40:10 -0500
Message-Id: <1643172013-31729-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
References: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007e2b8505d674cd69"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007e2b8505d674cd69

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Making the ptp free and timecounter initialization code into separate
functions so that later patches can use them.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 45 +++++++++++++------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 48520967746f..921aa7f75c9a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -714,6 +714,34 @@ static bool bnxt_pps_config_ok(struct bnxt *bp)
 	return !(bp->fw_cap & BNXT_FW_CAP_PTP_PPS) == !ptp->ptp_info.pin_config;
 }
 
+static void bnxt_ptp_timecounter_init(struct bnxt *bp, bool init_tc)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (!ptp->ptp_clock) {
+		memset(&ptp->cc, 0, sizeof(ptp->cc));
+		ptp->cc.read = bnxt_cc_read;
+		ptp->cc.mask = CYCLECOUNTER_MASK(48);
+		ptp->cc.shift = 0;
+		ptp->cc.mult = 1;
+		ptp->next_overflow_check = jiffies + BNXT_PHC_OVERFLOW_PERIOD;
+	}
+	if (init_tc)
+		timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
+}
+
+static void bnxt_ptp_free(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (ptp->ptp_clock) {
+		ptp_clock_unregister(ptp->ptp_clock);
+		ptp->ptp_clock = NULL;
+		kfree(ptp->ptp_info.pin_config);
+		ptp->ptp_info.pin_config = NULL;
+	}
+}
+
 int bnxt_ptp_init(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -729,23 +757,12 @@ int bnxt_ptp_init(struct bnxt *bp)
 	if (ptp->ptp_clock && bnxt_pps_config_ok(bp))
 		return 0;
 
-	if (ptp->ptp_clock) {
-		ptp_clock_unregister(ptp->ptp_clock);
-		ptp->ptp_clock = NULL;
-		kfree(ptp->ptp_info.pin_config);
-		ptp->ptp_info.pin_config = NULL;
-	}
+	bnxt_ptp_free(bp);
+
 	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
 	spin_lock_init(&ptp->ptp_lock);
 
-	memset(&ptp->cc, 0, sizeof(ptp->cc));
-	ptp->cc.read = bnxt_cc_read;
-	ptp->cc.mask = CYCLECOUNTER_MASK(48);
-	ptp->cc.shift = 0;
-	ptp->cc.mult = 1;
-
-	ptp->next_overflow_check = jiffies + BNXT_PHC_OVERFLOW_PERIOD;
-	timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
+	bnxt_ptp_timecounter_init(bp, true);
 
 	ptp->ptp_info = bnxt_ptp_caps;
 	if ((bp->fw_cap & BNXT_FW_CAP_PTP_PPS)) {
-- 
2.18.1


--0000000000007e2b8505d674cd69
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIiQF7k67o8iGzsYl/PRE1qxvu3C9bbL
VW7Ukja+rUQpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEy
NjA0NDAzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBvlPXji/2wlkMJ22rEqAWPPEd3N5/eybd+BaCyUL7sSr1E1pvH
N1UVrw9edA0gIrec2+gW0jrXG+rhhetXaKnjWunjF20DFfNSsaoQylWH5THm9VNyUPTi/tfB/sBx
pZ6UzBnCZzXz+qhHZashWlyenw/E4Q8mq8ljazuc3O4GwXNjw013Zexhmf59JgziuhDwroGLeOcV
cKlJYtJRJazSho9zpV7sf4JWTk2StcQdX8yjz6klmQ4P09BWwZvoMCcjwG5ZFf/12PkJlunhhgvO
dRVqRrtlc3GrAL/8flz4yZ16dv6akVImVw0yDvvUjikuN8qvHZpGPKKaoOkCaMdM
--0000000000007e2b8505d674cd69--
