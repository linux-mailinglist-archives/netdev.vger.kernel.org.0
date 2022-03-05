Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D854CE3B8
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiCEI4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiCEI4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:56:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E11F254A9A
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:55:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso9510484pjq.1
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PIGXVqns4U9Qy7E9Gb+B0/UKAvd8V3LTZva1AI8QZC8=;
        b=LJ2zxf+u2rGELA0x87CIHtcSLNdUpd8cyF4gYRtaqD8Ii3lS2g1ElGgCio9vD1ohlW
         FUQj9LhRaUInHeT3XGD8xwZOH31uMXL9k0ZSZPIKfvetU+oxIsIbvTEjzUvIxUEJxXDq
         UnlueGFuCBDft5XrNZbjaWnl1VzuXTTfodmu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PIGXVqns4U9Qy7E9Gb+B0/UKAvd8V3LTZva1AI8QZC8=;
        b=gW73Xp/BGY5tmm6lqYbcQdlIrbW3shAsdUOknC2wUzw6vjw6FlkyBgloXB9FvzIAkX
         kBQ9ujUsCdewdl75f27QUpp4fv6u7feXZ2O69mF9o5SplqCnMpqsaC22qoxRAnovNByD
         4IzA2JzGVccEfqwPNRBqRJ21FdEqlOmutqTdMYOZExwt/LzdQHeg1u+qMfPwcEYBRUA6
         PJP3j5jagpkakge86Vf85JRYnNF6xHCip+rxkh8P+RC/EV0B0Ndnaiw3tJ82lhtC+w1g
         1cYxXdd0kLRg912t+9mUgonEmoOPazrIbYXllGjX74wWsmvD3kYrbZPWshvmK88nhIhG
         OR6Q==
X-Gm-Message-State: AOAM531NSUjqSsRCwxfAdw+SDcr2un/P9woE2xMOIaFs9SH2bqISyFg+
        e8lKbuTAAAGlAL0S562jBUie9lEqgvJG1g==
X-Google-Smtp-Source: ABdhPJydq3/bf3KiqVTgag1JbbWnx5nkzRYPIXTwkUDdgdlO11LhGXy77jqqC61PXOt+SIH9psKo5g==
X-Received: by 2002:a17:902:f782:b0:14b:63db:9bc1 with SMTP id q2-20020a170902f78200b0014b63db9bc1mr2502659pln.60.1646470507319;
        Sat, 05 Mar 2022 00:55:07 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm9213261pfh.21.2022.03.05.00.55.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:55:07 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 5/9] bnxt_en: Properly report no pause support on some cards
Date:   Sat,  5 Mar 2022 03:54:38 -0500
Message-Id: <1646470482-13763-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c6419e05d974c908"
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

--000000000000c6419e05d974c908

Some cards are configured to never support link pause or PFC.  Discover
these cards and properly report no pause support to ethtool.  Disable
PFC settings from DCBNL if PFC is unsupported.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  6 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |  3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 ++++++++++-----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1ed71b6fed8a..2280b189f3d6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9416,7 +9416,7 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 	if (rc)
 		goto hwrm_phy_qcaps_exit;
 
-	bp->phy_flags = resp->flags;
+	bp->phy_flags = resp->flags | (le16_to_cpu(resp->flags2) << 8);
 	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED) {
 		struct ethtool_eee *eee = &bp->eee;
 		u16 fw_speeds = le16_to_cpu(resp->supported_speeds_eee_mode);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5d743976cb35..447a9406b8a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2104,8 +2104,8 @@ struct bnxt {
 	u32			lpi_tmr_lo;
 	u32			lpi_tmr_hi;
 
-	/* copied from flags in hwrm_port_phy_qcaps_output */
-	u8			phy_flags;
+	/* copied from flags and flags2 in hwrm_port_phy_qcaps_output */
+	u32			phy_flags;
 #define BNXT_PHY_FL_EEE_CAP		PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED
 #define BNXT_PHY_FL_EXT_LPBK		PORT_PHY_QCAPS_RESP_FLAGS_EXTERNAL_LPBK_SUPPORTED
 #define BNXT_PHY_FL_AN_PHY_LPBK		PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED
@@ -2114,6 +2114,8 @@ struct bnxt {
 #define BNXT_PHY_FL_NO_PHY_LPBK		PORT_PHY_QCAPS_RESP_FLAGS_LOCAL_LPBK_NOT_SUPPORTED
 #define BNXT_PHY_FL_FW_MANAGED_LKDN	PORT_PHY_QCAPS_RESP_FLAGS_FW_MANAGED_LINK_DOWN
 #define BNXT_PHY_FL_NO_FCS		PORT_PHY_QCAPS_RESP_FLAGS_NO_FCS
+#define BNXT_PHY_FL_NO_PAUSE		(PORT_PHY_QCAPS_RESP_FLAGS2_PAUSE_UNSUPPORTED << 8)
+#define BNXT_PHY_FL_NO_PFC		(PORT_PHY_QCAPS_RESP_FLAGS2_PFC_UNSUPPORTED << 8)
 
 	u8			num_tests;
 	struct bnxt_test_info	*test_info;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index 217ff597cdf2..caab3d626a2a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -627,7 +627,8 @@ static int bnxt_dcbnl_ieee_setpfc(struct net_device *dev, struct ieee_pfc *pfc)
 	int rc;
 
 	if (!(bp->dcbx_cap & DCB_CAP_DCBX_VER_IEEE) ||
-	    !(bp->dcbx_cap & DCB_CAP_DCBX_HOST))
+	    !(bp->dcbx_cap & DCB_CAP_DCBX_HOST) ||
+	    (bp->phy_flags & BNXT_PHY_FL_NO_PAUSE))
 		return -EINVAL;
 
 	if (!my_pfc) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 519edad70f16..7cc69957e529 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1662,15 +1662,19 @@ static void bnxt_fw_to_ethtool_support_fec(struct bnxt_link_info *link_info,
 static void bnxt_fw_to_ethtool_support_spds(struct bnxt_link_info *link_info,
 				struct ethtool_link_ksettings *lk_ksettings)
 {
+	struct bnxt *bp = container_of(link_info, struct bnxt, link_info);
 	u16 fw_speeds = link_info->support_speeds;
 
 	BNXT_FW_TO_ETHTOOL_SPDS(fw_speeds, 0, lk_ksettings, supported);
 	fw_speeds = link_info->support_pam4_speeds;
 	BNXT_FW_TO_ETHTOOL_PAM4_SPDS(fw_speeds, lk_ksettings, supported);
 
-	ethtool_link_ksettings_add_link_mode(lk_ksettings, supported, Pause);
-	ethtool_link_ksettings_add_link_mode(lk_ksettings, supported,
-					     Asym_Pause);
+	if (!(bp->phy_flags & BNXT_PHY_FL_NO_PAUSE)) {
+		ethtool_link_ksettings_add_link_mode(lk_ksettings, supported,
+						     Pause);
+		ethtool_link_ksettings_add_link_mode(lk_ksettings, supported,
+						     Asym_Pause);
+	}
 
 	if (link_info->support_auto_speeds ||
 	    link_info->support_pam4_auto_speeds)
@@ -1901,7 +1905,8 @@ static int bnxt_set_link_ksettings(struct net_device *dev,
 		/* any change to autoneg will cause link change, therefore the
 		 * driver should put back the original pause setting in autoneg
 		 */
-		set_pause = true;
+		if (!(bp->phy_flags & BNXT_PHY_FL_NO_PAUSE))
+			set_pause = true;
 	} else {
 		u8 phy_type = link_info->phy_type;
 
@@ -2093,7 +2098,7 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_link_info *link_info = &bp->link_info;
 
-	if (!BNXT_PHY_CFG_ABLE(bp))
+	if (!BNXT_PHY_CFG_ABLE(bp) || (bp->phy_flags & BNXT_PHY_FL_NO_PAUSE))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&bp->link_lock);
-- 
2.18.1


--000000000000c6419e05d974c908
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIH2QcVKZq57Kx6YdkiiZWacFhryJSevi
N0XqXYyNOz2EMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMw
NTA4NTUwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDXkrPMGpi+8psyu/eczdQDoYC/MOlP860Aobvt4aTCCUDEUyb4
EjT5Fwvq6rjZgaY732vX+j66lrMXWti6glJqKNKhvIfp6m6PaVUyuk5duCzJJZTASBgPWDZnFn+n
LRDkGqPXM1GCb26CPEm4rqXu+ojhycIHiFbbISBMSpjRATWUO+JyW2jbvBrJKcDvoffwwXZseOsr
1i3UN+sqCrlpA9ymXRRkF8Ws3EPRTPh2n3Isne+R/3PKlhQvVMCpTiLwx1iW3h5PcBz7oxnKDd9j
O5XDOCjBYbFsiUy1bxDS2yjbAJdbii2pMp5RLP1AG4OcYYb1cwkxK7RgGmUZ5iWw
--000000000000c6419e05d974c908--
