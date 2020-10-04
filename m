Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C8F282D33
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgJDTX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgJDTXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 15:23:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73661C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 12:23:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a17so3464798pju.1
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 12:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FpoKpCTbdPLI9UR53Er1KFVnORcdcj7kwAsH/OEY/AA=;
        b=SGyzc42JvbwWgnBpnveexJaFBbnhFu7rdF7q+4zv3VoZB/i8DWS8A0CaNlBfCoMK3P
         ve3U2qC2UrwhpJjMLkWw+S45RQrpBtF8Czu0bLLftHaYkT5Y7k/BMfqs5T8zaz8+9sHL
         Q7F3YZuclmAoPHREfv7H1G6fGIC4NGVKtS4i8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FpoKpCTbdPLI9UR53Er1KFVnORcdcj7kwAsH/OEY/AA=;
        b=WEbUAFWNVQ88LkKaq6hZ+015+/2NWb5o6WzVGahFjHNCcia2W9lSb968Fat9jIKble
         LPsvhalmONvL3KYqi15ZbpO6U1SEfQgJx04yetvce7IKzfCZ7iqOJ/ViRiotkf8vBnjB
         fRGowkgtiYFkLA1QaL+o8Y3okxrwUJmTCWLb6gPxQPR+GHpHEFSQmxdBck0e++jnhqpi
         bcjH7mYpvqnhp6Cu9QydPnPRIe7cCrB4JRBiPYesMuNmsNCaCto8JC2DF8lRfBIHOQ/K
         sCHRZHumVy44CBqOf8m7/+AJJwAuHhD2wxaBX3IMJyog0zPhsmyyXLZe3tj1gN9hY4nN
         ojzw==
X-Gm-Message-State: AOAM5325SnrZQANL+6pjJG5F/pDEynL+mnFVwZNa1IZMVTJqNN1x3m4w
        bEhBO6cWP7Pz+3RjCrUbKv2KYw==
X-Google-Smtp-Source: ABdhPJzDSpxsRKV2/n3S/DDcgMccbXCB3wkuIhmm4M7lzwerEcByTPrKp3a6n++2PDFReVvzztUL3A==
X-Received: by 2002:a17:90a:7bcf:: with SMTP id d15mr12916988pjl.230.1601839404841;
        Sun, 04 Oct 2020 12:23:24 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 138sm9824234pfu.180.2020.10.04.12.23.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2020 12:23:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 02/11] bnxt_en: refactor bnxt_alloc_fw_health()
Date:   Sun,  4 Oct 2020 15:22:52 -0400
Message-Id: <1601839381-10446-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
References: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bc3dd005b0dd4c80"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bc3dd005b0dd4c80

From: Edwin Peer <edwin.peer@broadcom.com>

The allocator for the firmware health structure conflates allocation
and capability checks, limiting the reusability of the code. This patch
separates out the capability check and disablement and improves the
warning message to better describe the consequences of an allocation
failure.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 60 ++++++++++++++---------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 38bbd7631fca..cf730ec92a0f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7336,6 +7336,36 @@ static int bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(struct bnxt *bp)
 	return rc;
 }
 
+static int __bnxt_alloc_fw_health(struct bnxt *bp)
+{
+	if (bp->fw_health)
+		return 0;
+
+	bp->fw_health = kzalloc(sizeof(*bp->fw_health), GFP_KERNEL);
+	if (!bp->fw_health)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int bnxt_alloc_fw_health(struct bnxt *bp)
+{
+	int rc;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) &&
+	    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+		return 0;
+
+	rc = __bnxt_alloc_fw_health(bp);
+	if (rc) {
+		bp->fw_cap &= ~BNXT_FW_CAP_HOT_RESET;
+		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
+		return rc;
+	}
+
+	return 0;
+}
+
 static int bnxt_map_fw_health_regs(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
@@ -10966,23 +10996,6 @@ static void bnxt_init_dflt_coal(struct bnxt *bp)
 	bp->stats_coal_ticks = BNXT_DEF_STATS_COAL_TICKS;
 }
 
-static void bnxt_alloc_fw_health(struct bnxt *bp)
-{
-	if (bp->fw_health)
-		return;
-
-	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) &&
-	    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
-		return;
-
-	bp->fw_health = kzalloc(sizeof(*bp->fw_health), GFP_KERNEL);
-	if (!bp->fw_health) {
-		netdev_warn(bp->dev, "Failed to allocate fw_health\n");
-		bp->fw_cap &= ~BNXT_FW_CAP_HOT_RESET;
-		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
-	}
-}
-
 static int bnxt_fw_init_one_p1(struct bnxt *bp)
 {
 	int rc;
@@ -11029,11 +11042,14 @@ static int bnxt_fw_init_one_p2(struct bnxt *bp)
 		netdev_warn(bp->dev, "hwrm query adv flow mgnt failure rc: %d\n",
 			    rc);
 
-	bnxt_alloc_fw_health(bp);
-	rc = bnxt_hwrm_error_recovery_qcfg(bp);
-	if (rc)
-		netdev_warn(bp->dev, "hwrm query error recovery failure rc: %d\n",
-			    rc);
+	if (bnxt_alloc_fw_health(bp)) {
+		netdev_warn(bp->dev, "no memory for firmware error recovery\n");
+	} else {
+		rc = bnxt_hwrm_error_recovery_qcfg(bp);
+		if (rc)
+			netdev_warn(bp->dev, "hwrm query error recovery failure rc: %d\n",
+				    rc);
+	}
 
 	rc = bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false);
 	if (rc)
-- 
2.18.1


--000000000000bc3dd005b0dd4c80
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgMLBgWlzxkTLB
ovuYJ82T4HALfyEgkzj5dIlKM3GDBi8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDA0MTkyMzI1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADdy2cA2EdV69pBrIK6Nck1xnSrlIrg+
wIzDkRBKsYwseUEcHNXBpE4QNKh/9ws/GCQevXTI2Vu6AER7AmRVLuAwV4dp6bz/sKXPUsxbf5pR
MBMxkHcoygap+ViO0U/nCmGBaZIC1pXbWGQEehAWcxJlKJ0iNzfDqhevhOcrcGxAkaPS3+mlu2P/
j/laja6CODUYDj62VK/RhbT6i/cmJ+Pi8fBDaEFoHEnt9gik9mdHo4mda/cXAaVQ8WuW1SVUlzPe
iMIzaYuCz0eie0yjmlrBWUTGREb/udLe8Fm6M0zcL53M+/HvTjsKDoKZUoByk5U4aqPRDeDZHBwR
w5VfteQ=
--000000000000bc3dd005b0dd4c80--
