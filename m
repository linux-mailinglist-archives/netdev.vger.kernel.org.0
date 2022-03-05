Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6114CE3B1
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiCEIzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCEIzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:55:53 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1393225259F
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:55:04 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 6so4916152pgg.0
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eC1lzqanh4BuhcfVyujuAm3QV1fvH0oW+3+onCEn47g=;
        b=BXmKFNH4PhSFGss4glGJYyD6HCjGBQjRP5jxi1Nn3q7s7EUOqcvVQHzs5SognaLATe
         JmD3Xql4EA/G3oIvSHwT4YkSa+kDAqp2q1dB1QiVvsJDd4dV/77qbgx8xjBDbVe8NTcn
         lkVTNOevE39sHecDSxroJ5WZ4sx7LazrRv6+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eC1lzqanh4BuhcfVyujuAm3QV1fvH0oW+3+onCEn47g=;
        b=bqbXvWJFmzfcORBaKBwGB+7qHlVFHgn4A3P/UyUETZE5iTwBIhuyCe94nrAa6jPUq7
         OQU1hZl2j51hKhlAa9on350s5ZLkQdh53Bfyc0Ej9dm2fmQv38mj1VYuiJTnz/cgTtFK
         EiPiwsQGBlFUZhYm5lkojlDVKqNn/iH4favfTTEQCAnNnYJ+uUErGzoYb6xDqYxX6zFT
         jS7UjT5IopIFpUOGQjppEchnEiqEa0CT1ZCVAMXzeJuuWfBRvCHrSOh4EikVuuOAe8en
         BkzvUXjh+TLVUbHROJc4J0fK4cOgv33Wa5q2wsOozanWfNbvH429KDteMLy4CsCAGvNJ
         MmcA==
X-Gm-Message-State: AOAM531R250Cyl+TM6LepHq/EMPnnFvGYGi8k3TVSzPR8pKhGCi++LLi
        nsxNq2/xrcvMJySsdv+i4Tj+KQ==
X-Google-Smtp-Source: ABdhPJw0Ad9mJW3w6Vx/XecBMBa8eV4mlz1RlsMEe9AAyU3LyfGwhnFtZICZBgEeriqA6BhuG0K1Bg==
X-Received: by 2002:a05:6a00:1a47:b0:4e1:5bc7:840d with SMTP id h7-20020a056a001a4700b004e15bc7840dmr2810666pfv.10.1646470502851;
        Sat, 05 Mar 2022 00:55:02 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm9213261pfh.21.2022.03.05.00.55.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:55:02 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 1/9] bnxt_en: refactor error handling of HWRM_NVM_INSTALL_UPDATE
Date:   Sat,  5 Mar 2022 03:54:34 -0500
Message-Id: <1646470482-13763-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000083967705d974c9fc"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000083967705d974c9fc

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

This is in anticipation of handling more "cmd_err" from FW in the next
patch.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 26 +++++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index fecb03b49f01..59838a4f45fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2512,6 +2512,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	u8 *kmem = NULL;
 	u32 modify_len;
 	u32 item_len;
+	u8 cmd_err;
 	u16 index;
 	int rc;
 
@@ -2595,6 +2596,8 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 		}
 
 		rc = hwrm_req_send_silent(bp, install);
+		if (!rc)
+			break;
 
 		if (defrag_attempted) {
 			/* We have tried to defragment already in the previous
@@ -2603,15 +2606,20 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 			break;
 		}
 
-		if (rc && ((struct hwrm_err_output *)resp)->cmd_err ==
-		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
+		cmd_err = ((struct hwrm_err_output *)resp)->cmd_err;
+
+		switch (cmd_err) {
+		case NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR:
 			install->flags =
 				cpu_to_le16(NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
 
 			rc = hwrm_req_send_silent(bp, install);
+			if (!rc)
+				break;
+
+			cmd_err = ((struct hwrm_err_output *)resp)->cmd_err;
 
-			if (rc && ((struct hwrm_err_output *)resp)->cmd_err ==
-			    NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE) {
+			if (cmd_err == NVM_INSTALL_UPDATE_CMD_ERR_CODE_NO_SPACE) {
 				/* FW has cleared NVM area, driver will create
 				 * UPDATE directory and try the flash again
 				 */
@@ -2621,11 +2629,13 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 						      BNX_DIR_TYPE_UPDATE,
 						      BNX_DIR_ORDINAL_FIRST,
 						      0, 0, item_len, NULL, 0);
-			} else if (rc) {
-				netdev_err(dev, "HWRM_NVM_INSTALL_UPDATE failure rc :%x\n", rc);
+				if (!rc)
+					break;
 			}
-		} else if (rc) {
-			netdev_err(dev, "HWRM_NVM_INSTALL_UPDATE failure rc :%x\n", rc);
+			fallthrough;
+		default:
+			netdev_err(dev, "HWRM_NVM_INSTALL_UPDATE failure rc :%x cmd_err :%x\n",
+				   rc, cmd_err);
 		}
 	} while (defrag_attempted && !rc);
 
-- 
2.18.1


--00000000000083967705d974c9fc
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDBUsWcVu+APZ6H1jdFD5nOsHGnN51ig
GCBMz8+xJ0puMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMw
NTA4NTUwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCXHRuUCAukciMCq2+7fra4frsla/QVcE4Zs/imKM1yxzw8co9/
B4QJG47D7o4MLuWHqCqGYxqUEIJUPGHUTIJRDhJix9RsyivbVamZDEmDV1eyg6tWEHCj4l0jwTV/
88XeEpV3bMnOAAECRt4u0lQ8p1QSyYkweVIsGvuw5jt5/0YoLa/pOISMZicr05nGB2YeyFVdYDz3
gbp6BnZ/qesRW6+pZ2aVWVwIYB9btedcK86HZo3MYsp39UXCxEMQ+eZ11jjycTi0H8ftJaIXDexp
SXmTBMW/MGRptdn6RMp8jzOJArh7C5n+ZEde8lUDY/Jrv4nhSOtTOM88FFgCbYPY
--00000000000083967705d974c9fc--
