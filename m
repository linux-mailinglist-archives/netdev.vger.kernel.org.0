Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CEF56AADC
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbiGGSc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiGGSch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:32:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619907390F
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:30:29 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x184so7690465pfx.2
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2iF+ZHkFCTwYd4Yvwc9G5mnDztkKAEk5nCv7bF/mqMY=;
        b=BWtaMq2vvtVTTP9uHZdusDTiiGE/ZXbzhgPer4TRxDbjPGTRExSaYD95kUJkQoOejI
         Yi7lBS4uXdEIfMa4SwNk+hZ8GJ+GtHGbEAb+kM6oqjU21rZPOGTPc3grKY3gW/2aJ+kH
         P/9hBz3LYdwImpkuOeftPNmUtA79uxA99YU9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2iF+ZHkFCTwYd4Yvwc9G5mnDztkKAEk5nCv7bF/mqMY=;
        b=hzyX2BiMDFj0Uc01UpLA6b3w2ownB3ITqo0nVrgBW8dxqE9xRx1lj0Hk+C6ZVTa2fY
         KHL+v++OEdUfP6nt5DaX+HoDvFKKTFzFGGbana2kDKpxEsUOLXYhNorYEWfUbnFz8UnJ
         6GJnqfjoUPuM6JUQmJsfBlZFVBfR64O+bKPIfAqfarh/rp2VrSmLPFcmdlprc8tT72bt
         mk01ce1Q6ub2FU6u+2zzNcG2JzLuejScWUp38d4QySbC5LEd4S4qgNPlVUSZfxjSfJJ5
         AstIvRGSbRovt6AbvIWkbuTqzCt2CWey4Uf1cKMW1ILPwIPjFiNC8R7V+pmWyptfnoGp
         7iYg==
X-Gm-Message-State: AJIora9pAPAcHNZTuerILVmwrZcKJuzwdBVf6sC4WsTXGDSzCrKcLhY+
        NWnwUtz0t+fPmxRyHMjyUAl/CA==
X-Google-Smtp-Source: AGRyM1tr2rckdiQhpNFCnKhsqFufKLKyd9E6n0dOtWltUlZ2Mde1QjlqFc6GuJOwghapQVXYvgcCnA==
X-Received: by 2002:a05:6a00:24c1:b0:50d:33cf:811f with SMTP id d1-20020a056a0024c100b0050d33cf811fmr54220336pfv.78.1657218626129;
        Thu, 07 Jul 2022 11:30:26 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id pj9-20020a17090b4f4900b001ef92e0e7c1sm7132234pjb.10.2022.07.07.11.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 11:30:25 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, leon@kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com,
        andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH net-next v2 2/3] bnxt_en: refactor NVM APIs
Date:   Thu,  7 Jul 2022 23:59:49 +0530
Message-Id: <20220707182950.29348-3-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220707182950.29348-1-vikas.gupta@broadcom.com>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008fa45305e33b47a6"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008fa45305e33b47a6

modify declaration for NVM APIs so that they can be
used with devlink and ethtool both.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 24 +++++++++----------
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h | 12 ++++++++++
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7191e5d74208..87eb5362ad70 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2176,14 +2176,14 @@ static void bnxt_print_admin_err(struct bnxt *bp)
 	netdev_info(bp->dev, "PF does not have admin privileges to flash or reset the device\n");
 }
 
-static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
-				u16 ext, u16 *index, u32 *item_length,
-				u32 *data_length);
+int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
+			 u16 ext, u16 *index, u32 *item_length,
+			 u32 *data_length);
 
-static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
-			    u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
-			    u32 dir_item_len, const u8 *data,
-			    size_t data_len)
+int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
+		     u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
+		     u32 dir_item_len, const u8 *data,
+		     size_t data_len)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct hwrm_nvm_write_input *req;
@@ -2836,8 +2836,8 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	return rc;
 }
 
-static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
-			       u32 length, u8 *data)
+int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
+			u32 length, u8 *data)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	int rc;
@@ -2871,9 +2871,9 @@ static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
 	return rc;
 }
 
-static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
-				u16 ext, u16 *index, u32 *item_length,
-				u32 *data_length)
+int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
+			 u16 ext, u16 *index, u32 *item_length,
+			 u32 *data_length)
 {
 	struct hwrm_nvm_find_dir_entry_output *output;
 	struct hwrm_nvm_find_dir_entry_input *req;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index a59284215e78..a8ecef8ab82c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -58,5 +58,17 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size);
 void bnxt_ethtool_init(struct bnxt *bp);
 void bnxt_ethtool_free(struct bnxt *bp);
+int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
+			 u16 ext, u16 *index, u32 *item_length,
+			 u32 *data_length);
+int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
+			 u16 ext, u16 *index, u32 *item_length,
+			 u32 *data_length);
+int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
+		     u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
+		     u32 dir_item_len, const u8 *data,
+		     size_t data_len);
+int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
+			u32 length, u8 *data);
 
 #endif
-- 
2.31.1


--0000000000008fa45305e33b47a6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIChy1m/MG2rd7tLtfQn0MOUiEkdR32mZmp/r
aCubfblkMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcwNzE4
MzAyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQCH2h5+SgDR5Qe7iGSDzuxvzhQlDNmRmrOgS8Dli4u2I1yv4InflWKR
pjKHfqCWPWKjJFM6YTrCwHS1BESDF9LlG3pD/dsPK5ILvuAXLYIrXz/ry4L9nU9gdIHeZAkr7sTS
NhGH+lJBdU+7sEQko3vaRBrOY3g21N6nZ0IuOTkED2utq9LqEwJQCo3CF8djKwBHpZsRtRD7Lg+z
ibgG7BfIjBD7n9gpM/d8E1RbMP4Cb6TPbHhVjJOpbVv1dsJ9wRLb+1GFdrGqd6L0uC0ezqzyCZHn
3xDkoSV3kWP/Gs/pXZeVK8jLsonG9z9Vi3wukMawNMXJFD0+56umn4I8fuej
--0000000000008fa45305e33b47a6--
