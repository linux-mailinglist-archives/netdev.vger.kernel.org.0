Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916B16E4042
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjDQG6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjDQG6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:58:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A331BD2
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 23:58:37 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id w11so25057280pjh.5
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 23:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1681714717; x=1684306717;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PwI/EnbF7rZ1k9MzyO9Qxm7E/+W61hGgN7ymasifzXw=;
        b=L5TLkIglOHQq2eZyrjkdS/BOPBTJxn2kbwp/0os0y/A/7e76WxuD+5bXfDeynDmb17
         iH8T//FaeLzoj69JewszOYu5olgKNdoQ9yCqrKzPxWGq+C+DtWuVG1vLF2aqFM9hyekg
         hqn1bLw0DAkq/faWSC1DW5qPo90a3phhGwvdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681714717; x=1684306717;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PwI/EnbF7rZ1k9MzyO9Qxm7E/+W61hGgN7ymasifzXw=;
        b=EmgQx2EiU+i+ZHj7PhF6GyBPbT1nfnEfTq/XfrUiHi+3EprE85Je2LwU7/GyXduNJL
         L5L/aA0VmptIkhcSfmIF14UcrlJT5BG4Hen9yiOhZwX+vtgGY3qepiT5pkggyaFsE/zA
         k/+Aeyp4qtsvaZaNVouNywUY/VFFLpEWD66LwLuGMbL8xoHD8n+J2ZWHYYXL5kf1HmuY
         lhKd5xTe/+SI7BjCPH6vNbqc3LWEZcHMO4qWAnGTdKvHzbBz7Y4NbqwCTkITlaYBIMCB
         EBd3inBaNzxDd/HHAorR6AbtJQyhg0uZ8LALkXj0m6j8TVqW5Xm2KmQC+licnzTPI8kP
         O9Kg==
X-Gm-Message-State: AAQBX9cFmbrqgJNGjwmD00QD9sI5eVpJVETwv5/IpJihMVsXwhX+vmaw
        LnWI5Gmb1wfPzOh6UDYwb4Agmg==
X-Google-Smtp-Source: AKy350b+D3Wt52LiE99chOeIwzTRFqxqtAAlEqyCYNHgO1hi2Dgf5ycidICSPvwXC6sSCnmqMbkC3w==
X-Received: by 2002:a17:90a:7d06:b0:247:8ce1:996e with SMTP id g6-20020a17090a7d0600b002478ce1996emr2968865pjl.29.1681714716478;
        Sun, 16 Apr 2023 23:58:36 -0700 (PDT)
Received: from lvnvda1597.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id h15-20020a17090a050f00b00247abbb157fsm374132pjh.31.2023.04.16.23.58.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Apr 2023 23:58:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gospo@broadcom.com,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>
Subject: [PATCH net 2/2] bnxt_en: Fix a possible NULL pointer dereference in unload path
Date:   Sun, 16 Apr 2023 23:58:19 -0700
Message-Id: <20230417065819.122055-3-michael.chan@broadcom.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230417065819.122055-1-michael.chan@broadcom.com>
References: <20230417065819.122055-1-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000568c7f05f982b8e4"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000568c7f05f982b8e4
Content-Transfer-Encoding: 8bit

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

In the driver unload path, the driver currently checks the valid
BNXT_FLAG_ROCE_CAP flag in bnxt_rdma_aux_device_uninit() before
proceeding.  This is flawed because the flag may not be set initially
during driver load.  It may be set later after the NVRAM setting is
changed followed by a firmware reset.  Relying on the
BNXT_FLAG_ROCE_CAP flag may crash in bnxt_rdma_aux_device_uninit() if
the aux device was never initialized:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
PGD 8ae6aa067 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 39 PID: 42558 Comm: rmmod Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-348.el8.x86_64 #1
Hardware name: Dell Inc. PowerEdge R750/0WT8Y6, BIOS 1.5.4 12/17/2021
RIP: 0010:device_del+0x1b/0x410
Code: 89 a5 50 03 00 00 4c 89 a5 58 03 00 00 eb 89 0f 1f 44 00 00 41 56 41 55 41 54 4c 8d a7 80 00 00 00 55 53 48 89 fb 48 83 ec 18 <48> 8b 2f 4c 89 e7 65 48 8b 04 25 28 00 00 00 48 89 44 24 10 31 c0
RSP: 0018:ff7f82bf469a7dc8 EFLAGS: 00010292
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000206 RDI: 0000000000000000
RBP: ff31b7cd114b0ac0 R08: 0000000000000000 R09: ffffffff935c3400
R10: ff31b7cd45bc3440 R11: 0000000000000001 R12: 0000000000000080
R13: ffffffffc1069f40 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fc9903ce740(0000) GS:ff31b7d4ffac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000992fee004 CR4: 0000000000773ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 bnxt_rdma_aux_device_uninit+0x1f/0x30 [bnxt_en]
 bnxt_remove_one+0x2f/0x1f0 [bnxt_en]
 pci_device_remove+0x3b/0xc0
 device_release_driver_internal+0x103/0x1f0
 driver_detach+0x54/0x88
 bus_remove_driver+0x77/0xc9
 pci_unregister_driver+0x2d/0xb0
 bnxt_exit+0x16/0x2c [bnxt_en]
 __x64_sys_delete_module+0x139/0x280
 do_syscall_64+0x5b/0x1a0
 entry_SYSCALL_64_after_hwframe+0x65/0xca
RIP: 0033:0x7fc98f3af71b

Fix this by modifying the check inside bnxt_rdma_aux_device_uninit()
to check for bp->aux_priv instead.  We also need to make some changes
in bnxt_rdma_aux_device_init() to make sure that bp->aux_priv is set
only when the aux device is fully initialized.

Fixes: d80d88b0dfff ("bnxt_en: Add auxiliary driver support")
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index e7b5e28ee29f..852eb449ccae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -304,7 +304,7 @@ void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
 	struct auxiliary_device *adev;
 
 	/* Skip if no auxiliary device init was done. */
-	if (!(bp->flags & BNXT_FLAG_ROCE_CAP))
+	if (!bp->aux_priv)
 		return;
 
 	aux_priv = bp->aux_priv;
@@ -324,6 +324,7 @@ static void bnxt_aux_dev_release(struct device *dev)
 	bp->edev = NULL;
 	kfree(aux_priv->edev);
 	kfree(aux_priv);
+	bp->aux_priv = NULL;
 }
 
 static void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
@@ -359,19 +360,18 @@ void bnxt_rdma_aux_device_init(struct bnxt *bp)
 	if (!(bp->flags & BNXT_FLAG_ROCE_CAP))
 		return;
 
-	bp->aux_priv = kzalloc(sizeof(*bp->aux_priv), GFP_KERNEL);
-	if (!bp->aux_priv)
+	aux_priv = kzalloc(sizeof(*bp->aux_priv), GFP_KERNEL);
+	if (!aux_priv)
 		goto exit;
 
-	bp->aux_priv->id = ida_alloc(&bnxt_aux_dev_ids, GFP_KERNEL);
-	if (bp->aux_priv->id < 0) {
+	aux_priv->id = ida_alloc(&bnxt_aux_dev_ids, GFP_KERNEL);
+	if (aux_priv->id < 0) {
 		netdev_warn(bp->dev,
 			    "ida alloc failed for ROCE auxiliary device\n");
-		kfree(bp->aux_priv);
+		kfree(aux_priv);
 		goto exit;
 	}
 
-	aux_priv = bp->aux_priv;
 	aux_dev = &aux_priv->aux_dev;
 	aux_dev->id = aux_priv->id;
 	aux_dev->name = "rdma";
@@ -380,10 +380,11 @@ void bnxt_rdma_aux_device_init(struct bnxt *bp)
 
 	rc = auxiliary_device_init(aux_dev);
 	if (rc) {
-		ida_free(&bnxt_aux_dev_ids, bp->aux_priv->id);
-		kfree(bp->aux_priv);
+		ida_free(&bnxt_aux_dev_ids, aux_priv->id);
+		kfree(aux_priv);
 		goto exit;
 	}
+	bp->aux_priv = aux_priv;
 
 	/* From this point, all cleanup will happen via the .release callback &
 	 * any error unwinding will need to include a call to
-- 
2.18.1


--000000000000568c7f05f982b8e4
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
XzCCBUwwggQ0oAMCAQICDF5AaMOe0cZvaJpCQjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODIxMzhaFw0yNTA5MTAwODIxMzhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDE1pY2hhZWwgQ2hhbjEoMCYGCSqGSIb3DQEJ
ARYZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALhEmG7egFWvPKcrDxuNhNcn2oHauIHc8AzGhPyJxU4S6ZUjHM/psoNo5XxlMSRpYE7g7vLx
J4NBefU36XTEWVzbEkAuOSuJTuJkm98JE3+wjeO+aQTbNF3mG2iAe0AZbAWyqFxZulWitE8U2tIC
9mttDjSN/wbltcwuti7P57RuR+WyZstDlPJqUMm1rJTbgDqkF2pnvufc4US2iexnfjGopunLvioc
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKjlkyNr98LR2yPa5Rd/t5lmvtk2/7TF
5SUMYVIBt4l1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDQx
NzA2NTgzN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB4sawwtmUy1vckWjqIU3O4hcyk4WNxfsblDiZ9cMZu25rKWhUb
yfiQArAHZ73WB/XI6Snw+qpGJxtm32yF3erjr9lQJPNoTs6bWUZNtq3l2eQVyIkYo7/YpKWNA/6m
ivKuMJga64o0zsrjI34EXQOjRKZ8Z54u3ZOAnQA9A5d0Ejy3fxS+D4vEmymuIJdfJptQo1DzCQgE
hluoSGLrOnee9JyE8Z5QY6w43tNZDsa52mxeI+yn8D7BOCjF3zSGjS/K4NhlIIfy6ChNuB2NBuUE
sykiPAuZQFAQ+39/iCRZPxsqUZu0VLpUNaFXioa/bEhmQouQ49qHPkCyIiP+3aX0
--000000000000568c7f05f982b8e4--
