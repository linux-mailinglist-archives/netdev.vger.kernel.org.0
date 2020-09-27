Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D428B27A21B
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgI0Rm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgI0Rmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:42:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5004C0613D4
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:52 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jw11so2275544pjb.0
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f2A3y8a/pIamjkm535iP31KHAAvuOchU9in9iAHNxpA=;
        b=bk9R1tXUrDpCfNI97aX1LkPcfClIHnmrfK3YOTH1Mvj7m8PTuAVhqhXdKIHcTWOKRV
         9LvfVANMR4+poQ0+y/bdVpJGQc9dhYQ9//azQDuJQ0cU63N4wTQDbjytRnkCUwCHuLVb
         RbZ26GMAoYCBmf6ubu3L+Nz3iUBQkLRETdwBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f2A3y8a/pIamjkm535iP31KHAAvuOchU9in9iAHNxpA=;
        b=N1fNkG29A9wj7MlGG94HOvkA4Q9eIynToQpQ9Wqob18zawtMsF7weyhT0cgr6P+XGc
         x9J2R8Pz2NsnDSucoLwxYNOFk/2bydljdMh7XGgfEmahQ1U/nVywztjUnNzP7Okt2KGr
         WqHwlHTO4Huq4b8Xkq+wtt7gsPe7U9Qn2GFGcBsWVEQHdXoES+YCZ3+bjyqfhxY6odab
         Z3ytVb00LQTiApIgMzuWYU06cz+TsMes9eLG/Xkfmd2NqNO7JWkcsmcpe8M262lCFMTc
         uPGR+DhyxHAV+bAIpXi8OQtaZROUKBzBCSw3AftcRFiQCX5JbxhmM8r74Oe54o1bS7lu
         KwYw==
X-Gm-Message-State: AOAM532c5NfsAYXh/rYzxjY9VXFRabht48tkZRAH9XXVuE98KYPz8GRA
        KhuVdmJEq9tsfGf3Ser8bqCkmGu4oNe+gA==
X-Google-Smtp-Source: ABdhPJz7ovUVoR5QJ05m963o4bCZxG1rtzoeI7IVdKG0vwlJgWTnRu/eBFloEv97ZlDTX/yT8C01gQ==
X-Received: by 2002:a17:902:bf06:b029:d2:8abd:c8f3 with SMTP id bi6-20020a170902bf06b02900d28abdc8f3mr619958plb.13.1601228572163;
        Sun, 27 Sep 2020 10:42:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm8765570pfp.64.2020.09.27.10.42.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:42:51 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/11] bnxt_en: Handle ethernet link being disabled by firmware.
Date:   Sun, 27 Sep 2020 13:42:15 -0400
Message-Id: <1601228540-20852-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004619ac05b04f14ba"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004619ac05b04f14ba

On some 200G dual port NICs, if one port is configured to 200G,
firmware will disable the ethernet link on the other port.  Firmware
will send notification to the driver for the disabled port when this
happens.  Define a new field in the link_info structure to keep track
of this state.  The new phy_state field replaces the unused loop_back
field.

Log a message when the phy_state changes state.  In the disabled state,
disallow any PHY configurations on the disabled port as the firmware
will fail all calls to configure the PHY in this state.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 22 ++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 10 +++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f97b3ba8fc09..a76ae6a68ca2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8777,6 +8777,16 @@ static void bnxt_report_link(struct bnxt *bp)
 	}
 }
 
+static bool bnxt_phy_qcaps_no_speed(struct hwrm_port_phy_qcaps_output *resp)
+{
+	if (!resp->supported_speeds_auto_mode &&
+	    !resp->supported_speeds_force_mode &&
+	    !resp->supported_pam4_speeds_auto_mode &&
+	    !resp->supported_pam4_speeds_force_mode)
+		return true;
+	return false;
+}
+
 static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 {
 	int rc = 0;
@@ -8824,6 +8834,18 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET)
 		bp->fw_cap |= BNXT_FW_CAP_PORT_STATS_NO_RESET;
 
+	if (bp->hwrm_spec_code >= 0x10a01) {
+		if (bnxt_phy_qcaps_no_speed(resp)) {
+			link_info->phy_state = BNXT_PHY_STATE_DISABLED;
+			netdev_warn(bp->dev, "Ethernet link disabled\n");
+		} else if (link_info->phy_state == BNXT_PHY_STATE_DISABLED) {
+			link_info->phy_state = BNXT_PHY_STATE_ENABLED;
+			netdev_info(bp->dev, "Ethernet link enabled\n");
+			/* Phy re-enabled, reprobe the speeds */
+			link_info->support_auto_speeds = 0;
+			link_info->support_pam4_auto_speeds = 0;
+		}
+	}
 	if (resp->supported_speeds_auto_mode)
 		link_info->support_auto_speeds =
 			le16_to_cpu(resp->supported_speeds_auto_mode);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 8ba113622425..fbbc30288fa6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1152,7 +1152,10 @@ struct bnxt_link_info {
 #define BNXT_LINK_SIGNAL	PORT_PHY_QCFG_RESP_LINK_SIGNAL
 #define BNXT_LINK_LINK		PORT_PHY_QCFG_RESP_LINK_LINK
 	u8			wire_speed;
-	u8			loop_back;
+	u8			phy_state;
+#define BNXT_PHY_STATE_ENABLED		0
+#define BNXT_PHY_STATE_DISABLED		1
+
 	u8			link_up;
 	u8			duplex;
 #define BNXT_LINK_DUPLEX_HALF	PORT_PHY_QCFG_RESP_DUPLEX_STATE_HALF
@@ -1601,8 +1604,9 @@ struct bnxt {
 #define BNXT_NPAR(bp)		((bp)->port_partition_type)
 #define BNXT_MH(bp)		((bp)->flags & BNXT_FLAG_MULTI_HOST)
 #define BNXT_SINGLE_PF(bp)	(BNXT_PF(bp) && !BNXT_NPAR(bp) && !BNXT_MH(bp))
-#define BNXT_PHY_CFG_ABLE(bp)	(BNXT_SINGLE_PF(bp) ||			\
-				 ((bp)->fw_cap & BNXT_FW_CAP_SHARED_PORT_CFG))
+#define BNXT_PHY_CFG_ABLE(bp)	((BNXT_SINGLE_PF(bp) ||			\
+				  ((bp)->fw_cap & BNXT_FW_CAP_SHARED_PORT_CFG)) && \
+				 (bp)->link_info.phy_state == BNXT_PHY_STATE_ENABLED)
 #define BNXT_CHIP_TYPE_NITRO_A0(bp) ((bp)->flags & BNXT_FLAG_CHIP_NITRO_A0)
 #define BNXT_RX_PAGE_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_PAGE_MODE)
 #define BNXT_SUPPORTS_TPA(bp)	(!BNXT_CHIP_TYPE_NITRO_A0(bp) &&	\
-- 
2.18.1


--0000000000004619ac05b04f14ba
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgyOchypMWkrwP
BY2KZqwvxe4PmPcMW8jrSYFm7ls7XIUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAwOTI3MTc0MjUyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFdAfenufIFWBQPgm4ZhP4MRnjZutkMX
VPgCzqFsNtRn8KtXp3PNoed78YaHjbSPA9VR3oShc1nTFPIsEhKylMetMS2ENuhqHytGWWpfj/GR
K6f+dhrJ13EL0mHMsx3+7szhfst2KowA45WNN5aOVyeGNfCDSbbpCDFyRjWyH5Ay8zNcaWR55Yl/
GXzrCr2qRKHeioQ4L8p+MdwpeY57tGclVHkdjCkPpG6TqRBV5JcpVuyoZATtyZbqOy7ba2pmWc/O
W4w10e882HGKfw2Hubp3aWjK8kYtqaKnPdTcvsgiJTB887a7/gU64PjhBMwsdIXYjX0Hm1mut9P4
p85dyGk=
--0000000000004619ac05b04f14ba--
