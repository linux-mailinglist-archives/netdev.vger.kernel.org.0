Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02CB4384ED
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhJWTel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhJWTek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:34:40 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012CEC061714
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:21 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m26so6726724pff.3
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QItRxK+CCOab87YB93ZE+qJZunlUZYgYkpFH9KRQnDk=;
        b=RULlgtU1sNBIZ0F2KmakPWuFNgS4EyWmDnUmBOyHR8tq0h+3K44wbybt7DEcQf/xo3
         JB6qOBJc2yXDnxaVpdlIgM7guBl5NXlPdZp+fvA6r0AQZl8Fw/qfZCqLEL27icNRIpmn
         6IUDe9bAyk5GozggXNvlfO9HxF+HGQjiL6y8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QItRxK+CCOab87YB93ZE+qJZunlUZYgYkpFH9KRQnDk=;
        b=7yynnB/y+oH26tujwaR9bODa4xDqwJMaKEaF6CcVNMebH5fli5mTsAlbmcJ6H6fMh+
         /jxg/NX9QVBuUJEHN8MhzGuZN8zwXcYRS2cZPJQTRopfTS0QaShf7WHCXUEqDlrMQday
         qe/UwTRJRzqnBhm8DiLo95+3YlFIkAriiXJJCVYdd8s4CeyjNqVJCxD4N/JVr0bLyZox
         7KzxslBrCYxwTOK5dg+c+bRxPNSW5LFuSsEF13dvzcLBVy5jlACNivbEaBZPZXgRR717
         uh3XJGn4nH4OYdP0Fh0URkgNO7ABUAwIJ1633LzINZtJM9Az175q1kMY/VbTCK8dxixu
         /J+g==
X-Gm-Message-State: AOAM532dw/Q1ggrpTtwQGupF3UGE64elAtJHXUbrd70vuL2r+N1N2ZlC
        Xu6Wj2p+GjWrT2en8S9X0JMHYg==
X-Google-Smtp-Source: ABdhPJwg58le4m/WVbAtear4lfeQ/9v/g3z1HzCYSw3nAIIpL1qksffCKD1Ln64HNElFQs6Q0t+8sA==
X-Received: by 2002:a05:6a00:1592:b0:44d:25e9:759e with SMTP id u18-20020a056a00159200b0044d25e9759emr7827772pfk.19.1635017539705;
        Sat, 23 Oct 2021 12:32:19 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 01/19] bnxt_en: refactor printing of device info
Date:   Sat, 23 Oct 2021 15:31:48 -0400
Message-Id: <1635017526-16963-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b79c0305cf0a2f93"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b79c0305cf0a2f93

From: Edwin Peer <edwin.peer@broadcom.com>

The device info logged during probe will be reused by the devlink
driver_reinit code in a following patch. Extract this logic into
the new bnxt_print_device_info() function. The board index needs
to be saved in the driver context so that the board information
can be retrieved at a later time, outside of the probe function.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 67 +++++------------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 51 ++++++++++++++++-
 2 files changed, 63 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 66263aa0d96b..8ff398525488 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -85,55 +85,7 @@ MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
 
 #define BNXT_TX_PUSH_THRESH 164
 
-enum board_idx {
-	BCM57301,
-	BCM57302,
-	BCM57304,
-	BCM57417_NPAR,
-	BCM58700,
-	BCM57311,
-	BCM57312,
-	BCM57402,
-	BCM57404,
-	BCM57406,
-	BCM57402_NPAR,
-	BCM57407,
-	BCM57412,
-	BCM57414,
-	BCM57416,
-	BCM57417,
-	BCM57412_NPAR,
-	BCM57314,
-	BCM57417_SFP,
-	BCM57416_SFP,
-	BCM57404_NPAR,
-	BCM57406_NPAR,
-	BCM57407_SFP,
-	BCM57407_NPAR,
-	BCM57414_NPAR,
-	BCM57416_NPAR,
-	BCM57452,
-	BCM57454,
-	BCM5745x_NPAR,
-	BCM57508,
-	BCM57504,
-	BCM57502,
-	BCM57508_NPAR,
-	BCM57504_NPAR,
-	BCM57502_NPAR,
-	BCM58802,
-	BCM58804,
-	BCM58808,
-	NETXTREME_E_VF,
-	NETXTREME_C_VF,
-	NETXTREME_S_VF,
-	NETXTREME_C_VF_HV,
-	NETXTREME_E_VF_HV,
-	NETXTREME_E_P5_VF,
-	NETXTREME_E_P5_VF_HV,
-};
-
-/* indexed by enum above */
+/* indexed by enum board_idx */
 static const struct {
 	char *name;
 } board_info[] = {
@@ -13186,6 +13138,15 @@ static int bnxt_map_db_bar(struct bnxt *bp)
 	return 0;
 }
 
+void bnxt_print_device_info(struct bnxt *bp)
+{
+	netdev_info(bp->dev, "%s found at mem %lx, node addr %pM\n",
+		    board_info[bp->board_idx].name,
+		    (long)pci_resource_start(bp->pdev, 0), bp->dev->dev_addr);
+
+	pcie_print_link_status(bp->pdev);
+}
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *dev;
@@ -13209,10 +13170,11 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	bp = netdev_priv(dev);
+	bp->board_idx = ent->driver_data;
 	bp->msg_enable = BNXT_DEF_MSG_ENABLE;
 	bnxt_set_max_func_irqs(bp, max_irqs);
 
-	if (bnxt_vf_pciid(ent->driver_data))
+	if (bnxt_vf_pciid(bp->board_idx))
 		bp->flags |= BNXT_FLAG_VF;
 
 	if (pdev->msix_cap)
@@ -13382,10 +13344,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 	bnxt_dl_fw_reporters_create(bp);
 
-	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
-		    board_info[ent->driver_data].name,
-		    (long)pci_resource_start(pdev, 0), dev->dev_addr);
-	pcie_print_link_status(pdev);
+	bnxt_print_device_info(bp);
 
 	pci_save_state(pdev);
 	return 0;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 19fe6478e9b4..55da89cb62b5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1586,6 +1586,54 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_RETRY			5
 #define BNXT_FW_IF_RETRY		10
 
+enum board_idx {
+	BCM57301,
+	BCM57302,
+	BCM57304,
+	BCM57417_NPAR,
+	BCM58700,
+	BCM57311,
+	BCM57312,
+	BCM57402,
+	BCM57404,
+	BCM57406,
+	BCM57402_NPAR,
+	BCM57407,
+	BCM57412,
+	BCM57414,
+	BCM57416,
+	BCM57417,
+	BCM57412_NPAR,
+	BCM57314,
+	BCM57417_SFP,
+	BCM57416_SFP,
+	BCM57404_NPAR,
+	BCM57406_NPAR,
+	BCM57407_SFP,
+	BCM57407_NPAR,
+	BCM57414_NPAR,
+	BCM57416_NPAR,
+	BCM57452,
+	BCM57454,
+	BCM5745x_NPAR,
+	BCM57508,
+	BCM57504,
+	BCM57502,
+	BCM57508_NPAR,
+	BCM57504_NPAR,
+	BCM57502_NPAR,
+	BCM58802,
+	BCM58804,
+	BCM58808,
+	NETXTREME_E_VF,
+	NETXTREME_C_VF,
+	NETXTREME_S_VF,
+	NETXTREME_C_VF_HV,
+	NETXTREME_E_VF_HV,
+	NETXTREME_E_P5_VF,
+	NETXTREME_E_P5_VF_HV,
+};
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
@@ -2049,6 +2097,7 @@ struct bnxt {
 	struct list_head	tc_indr_block_list;
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
+	enum board_idx		board_idx;
 };
 
 #define BNXT_NUM_RX_RING_STATS			8
@@ -2219,5 +2268,5 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 			    struct netdev_phys_item_id *ppid);
 void bnxt_dim_work(struct work_struct *work);
 int bnxt_hwrm_set_ring_coal(struct bnxt *bp, struct bnxt_napi *bnapi);
-
+void bnxt_print_device_info(struct bnxt *bp);
 #endif
-- 
2.18.1


--000000000000b79c0305cf0a2f93
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICAQblpFbSjwuFa0vTQmmvHexXSyaP4X
aLzgbbZVA+bgMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzIyMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCew88msekiin8z/Xc3dW1sx9+OFz9KKw0gDovxJ2CFoANkqIi0
mRu/LEOY0u2dvCPDGxsavLtw4gbktG1pUrwQpgIpfIPkseItQy96dDaE8YMuGhuI00Az4oknGyJo
zf0AOsg+7XzcqZzrbAm8wYQGG68aEEEAR95/ynlx80zvfBp6otECaZUZiRMCJJtoVGtdE2S0LMKu
i4o67Gue87XhGyYVWlp1JntTDB/LtrceG7bRxK3yoTqpBiMiZGQcKRzJHwF9B90JdKanQJ/6dqjF
3HbPwKgexJq1vTYhYxxMWpj87xp9pFVS06Z60hPPrJfFJdwSTbWf1pimn2XV2uvN
--000000000000b79c0305cf0a2f93--
