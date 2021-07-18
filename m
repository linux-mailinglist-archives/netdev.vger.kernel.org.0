Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8883CCA76
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhGRTj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 15:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbhGRTj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 15:39:56 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD41C061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 12:36:57 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b12so8373264plh.10
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 12:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jYwmHsW35NQS3Aohxxgr18T541gZRV2ob9hEfPoaBYw=;
        b=AGYa4vbntUiDl8XZDwrRSDFEGNGEHNONi4W8h5RfYWRkId04/VmFBlciQS7Yp/1349
         zDaFBipwDyOPOhiXYDVIhfZZwKQyxxEsRKVZPNZUG+oLSAZH70CX9c13mVC//cAbadxI
         UgcjBs3EnchTNTrfgQn4mH9WdZWud8ruo6A1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jYwmHsW35NQS3Aohxxgr18T541gZRV2ob9hEfPoaBYw=;
        b=MWQvQAVCmlkSRRHuZHD1HrjdtuieA5tlDZ4gLTAjisBxhxUYoUkgPAmY94sjuQEIdk
         P/PeddA7n1o/1DDAziOMuF8xxmicLg4rXCq+BtYlBM4Dk39ubmO2ynV6rsWJ9sMEIPZF
         wiNbPyknzm0tfGx1Zc8bzt+3HYAsZ+VksiMlJ/Pk23sgwwLWeJ/m2ZeLjo9JLbApdb+g
         gYXaN3SdN3qLI56FBN8A+8SxA9vTdkcaMT9CUGibMmoWkQLasq9jph0YOxcmPHT6KUu4
         Z3gOwQ9vchAmoWE2lRfKOmhDs7pjBSmHscpR8HJUmBmCUeyfodhLgIjUoZdzaIDJWplC
         1ikw==
X-Gm-Message-State: AOAM531XxwOoVTuFiezMQP+LaM03xWM/h2m3AR+JdspzoRmag3AjXimU
        9r8fkvaoSMwtg8bsbbC0PhpqWw==
X-Google-Smtp-Source: ABdhPJwMfKmOIqm80bmFzjmOYjuSVLByXi7CKr4KhK8M0mrHwIAqyJaZc6MzWomuJYdD7A5Q4UneVQ==
X-Received: by 2002:a17:903:2284:b029:12b:329:651e with SMTP id b4-20020a1709032284b029012b0329651emr16593857plh.44.1626637016488;
        Sun, 18 Jul 2021 12:36:56 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm16743648pfo.80.2021.07.18.12.36.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Jul 2021 12:36:55 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net 8/9] bnxt_en: Move bnxt_ptp_init() to bnxt_open()
Date:   Sun, 18 Jul 2021 15:36:32 -0400
Message-Id: <1626636993-31926-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
References: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009924d705c76af13a"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009924d705c76af13a

The device needs to be in ifup state for PTP to function, so move
bnxt_ptp_init() to bnxt_open().  This means that the PHC will be
registered during bnxt_open().

This also makes firmware reset work correctly.  PTP configurations
may change after firmware upgrade or downgrade.  bnxt_open() will
be called after firmware reset, so it will work properly.

bnxt_ptp_start() is now incorporated into bnxt_ptp_init().  We now
also need to call bnxt_ptp_clear() in bnxt_close().

Fixes: 93cb62d98e9c ("bnxt_en: Enable hardware PTP support")
Cc: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 16 +++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 24 ++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  1 -
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 31eb3c00851a..b8b73c210995 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10134,7 +10134,6 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 		}
 	}
 
-	bnxt_ptp_start(bp);
 	rc = bnxt_init_nic(bp, irq_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
@@ -10273,9 +10272,16 @@ static int bnxt_open(struct net_device *dev)
 	rc = bnxt_hwrm_if_change(bp, true);
 	if (rc)
 		return rc;
+
+	if (bnxt_ptp_init(bp)) {
+		netdev_warn(dev, "PTP initialization failed.\n");
+		kfree(bp->ptp_cfg);
+		bp->ptp_cfg = NULL;
+	}
 	rc = __bnxt_open_nic(bp, true, true);
 	if (rc) {
 		bnxt_hwrm_if_change(bp, false);
+		bnxt_ptp_clear(bp);
 	} else {
 		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state)) {
 			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
@@ -10366,6 +10372,7 @@ static int bnxt_close(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
+	bnxt_ptp_clear(bp);
 	bnxt_hwmon_close(bp);
 	bnxt_close_nic(bp, true, true);
 	bnxt_hwrm_shutdown_link(bp);
@@ -11352,6 +11359,7 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
 		bnxt_clear_int_mode(bp);
 		pci_disable_device(bp->pdev);
 	}
+	bnxt_ptp_clear(bp);
 	__bnxt_close_nic(bp, true, false);
 	bnxt_vf_reps_free(bp);
 	bnxt_clear_int_mode(bp);
@@ -12694,7 +12702,6 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	if (BNXT_PF(bp))
 		devlink_port_type_clear(&bp->dl_port);
 
-	bnxt_ptp_clear(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
@@ -13278,11 +13285,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				   rc);
 	}
 
-	if (bnxt_ptp_init(bp)) {
-		netdev_warn(dev, "PTP initialization failed.\n");
-		kfree(bp->ptp_cfg);
-		bp->ptp_cfg = NULL;
-	}
 	bnxt_inv_fw_health_reg(bp);
 	bnxt_dl_register(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index f698b6bd4ff8..9089e7f3fbd4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -385,22 +385,6 @@ int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts)
 	return 0;
 }
 
-void bnxt_ptp_start(struct bnxt *bp)
-{
-	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
-
-	if (!ptp)
-		return;
-
-	if (bp->flags & BNXT_FLAG_CHIP_P5) {
-		spin_lock_bh(&ptp->ptp_lock);
-		ptp->current_time = bnxt_refclk_read(bp, NULL);
-		WRITE_ONCE(ptp->old_time, ptp->current_time);
-		spin_unlock_bh(&ptp->ptp_lock);
-		ptp_schedule_worker(ptp->ptp_clock, 0);
-	}
-}
-
 static const struct ptp_clock_info bnxt_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "bnxt clock",
@@ -450,7 +434,13 @@ int bnxt_ptp_init(struct bnxt *bp)
 		bnxt_unmap_ptp_regs(bp);
 		return err;
 	}
-
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		spin_lock_bh(&ptp->ptp_lock);
+		ptp->current_time = bnxt_refclk_read(bp, NULL);
+		WRITE_ONCE(ptp->old_time, ptp->current_time);
+		spin_unlock_bh(&ptp->ptp_lock);
+		ptp_schedule_worker(ptp->ptp_clock, 0);
+	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 6b6245750e20..4135ea3ec788 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -75,7 +75,6 @@ int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
 int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
-void bnxt_ptp_start(struct bnxt *bp);
 int bnxt_ptp_init(struct bnxt *bp);
 void bnxt_ptp_clear(struct bnxt *bp);
 #endif
-- 
2.18.1


--0000000000009924d705c76af13a
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIK4RlvTkJcZK6ST5fQT6WTKnJzxqEohY
p96StGMV3AR9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDcx
ODE5MzY1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAqhU7Y91H+InMJvFi/3vkE1X86oIJax8KngGDKNxf9dv+azet2
zsHpngyJRDJO3Rh6QRpxoAotRJkWQirMzOHyDTvOTi6xQ3RL3XIFDhGbdTs49immHF5rA38iHLWi
GjA+vVVM+IISt+WwNlzHtux4Dn+TtW0HVPDk3TsXwtxCKFzWdHfhInNmlxPKgMoExNky/d4cF0sb
h6yOnnRHbe0+CiKjpWXRwHy8RHMcbW+sKWG8lOwOQh7DGts7GtdvghWIgPtquhaYWGLItqYIwC3w
9ha105sU26VqY0bvkKVYFxiI6bHgPXO8qpIfIEjl6ZztjFEu2EA0aYhulfoEo9dZ
--0000000000009924d705c76af13a--
