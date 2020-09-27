Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AE527A215
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgI0Rmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgI0Rmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:42:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2D2C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k13so7202496pfg.1
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vKQNi/8vMqi+uOb0XbfWK4EhmKrw4Wn+WrxCP7CP8Xc=;
        b=F08AjgZHDQzGjq2bdD+JumWjuc5yidRCzY9Z3rgUeTq3zzRMSlU+4h7rhuVW/xr0zP
         8yhka1vwBkoXYGvGlKZjs459dRfwIfrgKfWNXsPN0iarhIM7XpbusPCAvOpvTcI+LdBT
         LM4g8RAS05oJ4U/s11uKlXvyRPWFPrJHbd4tQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vKQNi/8vMqi+uOb0XbfWK4EhmKrw4Wn+WrxCP7CP8Xc=;
        b=TiiNCN8k9PGhJG8P6o5x5rVvcevZgMlGNvdD+cGme1UkkOf1KZPmM6TV4soe3TnkuT
         zxMH8Ghp2WZKVFfATJj7TWAazQkTPf2AcWTO1FcWuUXHITjgfUFiH2n2ZLfClI4JPfbA
         ViME1aXXtK+a468a4YzIdBOzPJoewRXwOGzuwICB6p83PtpVwuzhyj5kd7Zlziha+A7i
         +VvXl171ILyCBKUG2w/fmgyyI4oGtAg3ZW+UuUUeeqYbYKGqqyAyg6nZpdDBEJOKasGe
         eimtrha+TRpPDcOT8XYg2PWiWFWqBbkacvmW0Rrx9zmh7e8KDItj6D8bOycn2kuQnQpK
         VIZg==
X-Gm-Message-State: AOAM531pw+aa9y2Ja5Gk+ji2t5UezfeiIAVmwcby3e5jlzdBYPJrNZ7i
        bT5eTMIHxLu8a4R6pi1kYKCLhbkGUwJ8kA==
X-Google-Smtp-Source: ABdhPJyVPhnmpNuUSqHIxU/4P9wdk2HURR8KsHHTdhvliB7a5Kt/gqCTRpZrgeokOLbcf+UwldSTYg==
X-Received: by 2002:a62:26c1:0:b029:142:2501:35ef with SMTP id m184-20020a6226c10000b0290142250135efmr7494860pfm.79.1601228568489;
        Sun, 27 Sep 2020 10:42:48 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm8765570pfp.64.2020.09.27.10.42.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:42:47 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 03/11] bnxt_en: refactor bnxt_get_fw_speed()
Date:   Sun, 27 Sep 2020 13:42:12 -0400
Message-Id: <1601228540-20852-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000dd08505b04f1465"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000dd08505b04f1465

From: Edwin Peer <edwin.peer@broadcom.com>

It will be necessary to update more than one field in the link_info
structure when PAM4 speeds are added in a later patch. Instead of
merely translating ethtool speed values to firmware speed values,
change the responsiblity of this function to update all the necessary
link_info fields required to force the speed change to the desired
ethtool value. This also reduces code duplication somewhat at the two
call sites, which otherwise both have to independently update link_info
fields to turn off auto negotiation advertisements.

Also use the appropriate REQ_FORCE_LINK_SPEED definitions. These happen
to have the same values, but req_link_speed is utilimately passed as
force_link_speed in HWRM_PORT_PHY_CFG which is not defined in terms of
REQ_AUTO_LINK_SPEED.

Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 47 ++++++++++---------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 9703ff48f2ab..ad6a5967ac21 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1636,55 +1636,63 @@ static int bnxt_get_link_ksettings(struct net_device *dev,
 	return 0;
 }
 
-static u32 bnxt_get_fw_speed(struct net_device *dev, u32 ethtool_speed)
+static int bnxt_force_link_speed(struct net_device *dev, u32 ethtool_speed)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_link_info *link_info = &bp->link_info;
 	u16 support_spds = link_info->support_speeds;
-	u32 fw_speed = 0;
+	u16 fw_speed = 0;
 
 	switch (ethtool_speed) {
 	case SPEED_100:
 		if (support_spds & BNXT_LINK_SPEED_MSK_100MB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_100MB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_100MB;
 		break;
 	case SPEED_1000:
 		if (support_spds & BNXT_LINK_SPEED_MSK_1GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_1GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_1GB;
 		break;
 	case SPEED_2500:
 		if (support_spds & BNXT_LINK_SPEED_MSK_2_5GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_2_5GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_2_5GB;
 		break;
 	case SPEED_10000:
 		if (support_spds & BNXT_LINK_SPEED_MSK_10GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_10GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_10GB;
 		break;
 	case SPEED_20000:
 		if (support_spds & BNXT_LINK_SPEED_MSK_20GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_20GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_20GB;
 		break;
 	case SPEED_25000:
 		if (support_spds & BNXT_LINK_SPEED_MSK_25GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_25GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_25GB;
 		break;
 	case SPEED_40000:
 		if (support_spds & BNXT_LINK_SPEED_MSK_40GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_40GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_40GB;
 		break;
 	case SPEED_50000:
 		if (support_spds & BNXT_LINK_SPEED_MSK_50GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_50GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_50GB;
 		break;
 	case SPEED_100000:
 		if (support_spds & BNXT_LINK_SPEED_MSK_100GB)
-			fw_speed = PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_100GB;
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_100GB;
 		break;
-	default:
+	}
+
+	if (!fw_speed) {
 		netdev_err(dev, "unsupported speed!\n");
-		break;
+		return -EINVAL;
 	}
-	return fw_speed;
+
+	link_info->req_link_speed = fw_speed;
+	link_info->req_duplex = BNXT_LINK_DUPLEX_FULL;
+	link_info->autoneg = 0;
+	link_info->advertising = 0;
+
+	return 0;
 }
 
 u16 bnxt_get_fw_auto_link_speeds(u32 advertising)
@@ -1737,7 +1745,6 @@ static int bnxt_set_link_ksettings(struct net_device *dev,
 		 */
 		set_pause = true;
 	} else {
-		u16 fw_speed;
 		u8 phy_type = link_info->phy_type;
 
 		if (phy_type == PORT_PHY_QCFG_RESP_PHY_TYPE_BASET  ||
@@ -1753,15 +1760,9 @@ static int bnxt_set_link_ksettings(struct net_device *dev,
 			goto set_setting_exit;
 		}
 		speed = base->speed;
-		fw_speed = bnxt_get_fw_speed(dev, speed);
-		if (!fw_speed) {
-			rc = -EINVAL;
+		rc = bnxt_force_link_speed(dev, speed);
+		if (rc)
 			goto set_setting_exit;
-		}
-		link_info->req_link_speed = fw_speed;
-		link_info->req_duplex = BNXT_LINK_DUPLEX_FULL;
-		link_info->autoneg = 0;
-		link_info->advertising = 0;
 	}
 
 	if (netif_running(dev))
-- 
2.18.1


--0000000000000dd08505b04f1465
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgf9oJJAb6EvrN
bqYAg0NTpIJMOPJOl1StHDanW5/oCD4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAwOTI3MTc0MjQ4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADDkzEGm6FUy64Scm2jYMHnfcq6JNf1c
nSeLBo7Kw1IQvay6rbvhElpwTaMAqzJEV0dA3mHgqpKhw59e4dvPWM1KdL4Omp6ajeWHtGHsKAIE
guojIx5ULMzEy3n6fnC9j5UOuw6uVmAmYQMhIQrDxLXfd8/ufg1i8bSUCT9TslCdkpV/QUvFK69T
2vPPocs8xU762IvyPsG1XVEzUKS3Dq07GVXIX0sLj6UO6A6g2bKBIasmUPDwtfGRjhblro48pGeH
Jh70sPtrgEHhGi0r6d4eugA2+jUBfsmW3gk57AIBkvqAsEoG7gOk6E4IaXzPCFIxMch3vkVtH8F0
wtZQ+aI=
--0000000000000dd08505b04f1465--
