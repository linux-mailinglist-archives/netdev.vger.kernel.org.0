Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DC93FA7C4
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 23:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhH1WAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 18:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbhH1V75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 17:59:57 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB13C0617AE
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:59:04 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d6so15456640edt.7
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zztbr2RT08h2Gg3ZRLJOpdvZh0byniSaDhTvmmU6fp8=;
        b=eJe1d3HqlSqvH9mnzR1V5D2bQrI44+SshAM+y83hVcE6AHK/ltPH13c7PIQin7xZc2
         JSu1wFKALsqMF0qgy8Ce+55vY55lHHHB+k8thz5Enw5r6vntMzu1Dj4nvd+lwG9Yj8tn
         TJPod0+6lOb3csZbyMjaamBgzI9SfjBOoWoWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zztbr2RT08h2Gg3ZRLJOpdvZh0byniSaDhTvmmU6fp8=;
        b=PGEwlcdg8EOCMxO8L3J0iNrXd3wbUdLNGG2SUwOfSi/kDRfRvDZ6rPwWtiO9DYjWsT
         +e6niDdFItFBQ4OI/BTrDYb7W+McyzEi1xx3G8qD9mHpxqDPVW+ku+IJqBS6UpUm1LWB
         Kea8r7CIUU0hpMguL7XhSzPXXEzzwz3BC1pYLn4Xjm5SFbvlDKH0WOMhsH+lat6z+hUk
         crY1XPP950mUvupSBTN11WnsTqoLVFp/kapx6S0diMCJswo3jC4ifNOcAHXmOr7sEUBo
         2u/xoeJiSuUxROY0JxS9g1wRiQm194JA2yc2SogvUDu8kohg6/0v9yWl+Yfq1hNwqVdb
         6ABg==
X-Gm-Message-State: AOAM531eOtUtyDds/9I8DBAbpDyLLuM/nqdd06LlNO+5AwEScB387sGj
        xSqgKKnJfKwF0s8RyS5VPK8RPA==
X-Google-Smtp-Source: ABdhPJwDMk4PLtBdOKSBqa8LL1R8qxjmGMuBZLp2T2GE/Y0f4beMdWuO9gtE1Ovfotm31wbh3Ac48Q==
X-Received: by 2002:aa7:c799:: with SMTP id n25mr16067830eds.16.1630187943132;
        Sat, 28 Aug 2021 14:59:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cf11sm5361239edb.65.2021.08.28.14.59.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Aug 2021 14:59:02 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next 08/11] bnxt_en: use link_lock instead of hwrm_cmd_lock to protect link_info
Date:   Sat, 28 Aug 2021 17:58:27 -0400
Message-Id: <1630187910-22252-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
References: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004ca96805caa5b54a"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004ca96805caa5b54a

From: Edwin Peer <edwin.peer@broadcom.com>

We currently use the hwrm_cmd_lock to serialize the update of the
firmware's link status response data and the copying of link status data
to the VF.  This won't work when we update the firmware message APIs, so
we use the link_lock mutex instead.  All link_info data should be
updated under the link_lock mutex.  Also add link_lock to functions that
touch link_info in __bnxt_open_nic() and bnxt_probe_phy(). The locking
is probably not strictly necessary during probe, but it's more consistent.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 5 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 23486f382b91..b9aa56cc10d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10008,7 +10008,9 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	bnxt_tx_enable(bp);
 	mod_timer(&bp->timer, jiffies + bp->current_interval);
 	/* Poll link status and check for SFP+ module status */
+	mutex_lock(&bp->link_lock);
 	bnxt_get_port_module_status(bp);
+	mutex_unlock(&bp->link_lock);
 
 	/* VF-reps may need to be re-opened after the PF is re-opened */
 	if (BNXT_PF(bp))
@@ -12599,8 +12601,10 @@ static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 	if (!fw_dflt)
 		return 0;
 
+	mutex_lock(&bp->link_lock);
 	rc = bnxt_update_link(bp, false);
 	if (rc) {
+		mutex_unlock(&bp->link_lock);
 		netdev_err(bp->dev, "Probe phy can't update link (rc: %x)\n",
 			   rc);
 		return rc;
@@ -12613,6 +12617,7 @@ static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 		link_info->support_auto_speeds = link_info->support_speeds;
 
 	bnxt_init_ethtool_link_settings(bp);
+	mutex_unlock(&bp->link_lock);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 7b0e308e44c2..07e8e9f657e4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -1032,10 +1032,10 @@ static int bnxt_vf_set_link(struct bnxt *bp, struct bnxt_vf_info *vf)
 
 		phy_qcfg_req =
 		(struct hwrm_port_phy_qcfg_input *)vf->hwrm_cmd_req_addr;
-		mutex_lock(&bp->hwrm_cmd_lock);
+		mutex_lock(&bp->link_lock);
 		memcpy(&phy_qcfg_resp, &bp->link_info.phy_qcfg_resp,
 		       sizeof(phy_qcfg_resp));
-		mutex_unlock(&bp->hwrm_cmd_lock);
+		mutex_unlock(&bp->link_lock);
 		phy_qcfg_resp.resp_len = cpu_to_le16(sizeof(phy_qcfg_resp));
 		phy_qcfg_resp.seq_id = phy_qcfg_req->seq_id;
 		phy_qcfg_resp.valid = 1;
-- 
2.18.1


--0000000000004ca96805caa5b54a
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIH3jUtRkW69Zw5JNxeutJeDLwmt6Kk/d
lmrUFPSn00vrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
ODIxNTkwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCFrHLt/tlVfmXXQ8ljFAWGIOyS2ELXu8Mo4fzlk0ZUMjBPVdg6
tKyfaxJ6TksufaL/PN4p3S2w/d/zHSD618yiaRvS8iGBCz2iV1FxGnDSdcPOnyDr5NlDmcIHbw3u
Thd5kBExo9flCq5DLMWJgbYl//q8YPT5jmXXaMVsXXqPQkmhy0TKEpJi4BaL1hV6VvJCLJezWPAQ
CMzpyW183nyMsrjBjYEM7i+Ih9lp8RUgGFWPbtgJjm1jkcFS7kJqH9OkIrO1tjRTwkfVIJooMoUJ
Iq8Lp4QyTaqN+V/7nL4QKYJqXo3hBQB17K5j8huPSWFQh5xac09VkZkNpbqQbAPx
--0000000000004ca96805caa5b54a--
