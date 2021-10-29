Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E537A43F80A
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhJ2Hu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbhJ2Huv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:50:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EAEC061220
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id in13so4275986pjb.1
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HjefWMgP0SHP6oA3c26FCih7v0DMdAmNVvARrevEl24=;
        b=Nhcsn34qy3WePYtq3yUkEoJwB7C0y5VvSBV46wjtzc7FkONGbyRhkw100dY2HgGldI
         rB3vj4q1Xly0X1z9S/mjbB/IQq2rUJPK7d8s1r/b6PBV2qmzBKPNmb/bNvPkQuaZYqMf
         5feVoZht2sOpmawKjgDg0gYRgUO1KjUIksXsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HjefWMgP0SHP6oA3c26FCih7v0DMdAmNVvARrevEl24=;
        b=1fxfqL1fbENk/1NRR0SDzF+b8h4UB6YwbmK7sWl0dAYRRUBOT0nXrhRt50iIJoQ6f3
         hEL+gymaZXEHDpM/Iw+UoYnwObq9x7VCO3LaO0MXqV2nJzlQM3yQ1+A2/S7OA7CSvAQd
         51o5lTHDHA9tJ2e5E6iEFUOaRP87u/o5P/tTt/APxDZpG52rWxORCZ+ABsxYl9CT7FnH
         zPl+iyfGgTvU7PPlFueEhf2ku0soNaL3CjEP3c9C4covgdgmrNCHbT6FzzzmV6lTK7eT
         j8Da9IbAWw6YMC8XuPMP3agtOXu2BPAlcIG+KD+rlaES7+xrXGS7g899Js8BSR+i6jiI
         +QRg==
X-Gm-Message-State: AOAM531nNZRjQb+qw6TjCM0r9LlH7sVj2GHbkt4ZiO9dUGv60Hlogyb0
        h6DqwhYLwmzpLXz0bCq9Brmz9F4RQTvEhA==
X-Google-Smtp-Source: ABdhPJx9/Ru7Duq3knYVANpWE7iMuO1e1bjX+hqHfy1O/nd9CNes+VNpwBL2HqHj/pESkHMyXrizyw==
X-Received: by 2002:a17:90b:f82:: with SMTP id ft2mr8691246pjb.107.1635493701940;
        Fri, 29 Oct 2021 00:48:21 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:21 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 08/19] bnxt_en: consolidate fw devlink health reporters
Date:   Fri, 29 Oct 2021 03:47:45 -0400
Message-Id: <1635493676-10767-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003308b005cf790d66"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003308b005cf790d66

From: Edwin Peer <edwin.peer@broadcom.com>

Merge 'fw' and 'fw_fatal' health reporters.  There is no longer a need
to distinguish between firmware reporters. Only bonafide errors are
reported now and no reports were being generated for the 'fw' reporter.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 -
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 71 ++++++-------------
 2 files changed, 21 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e640df62d296..2873f600a7dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1551,7 +1551,6 @@ struct bnxt_fw_health {
 	u32 echo_req_data1;
 	u32 echo_req_data2;
 	struct devlink_health_reporter	*fw_reporter;
-	struct devlink_health_reporter *fw_fatal_reporter;
 };
 
 #define BNXT_FW_HEALTH_REG_TYPE_MASK	3
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 2c72f3b3708f..a295d2042b6e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -71,9 +71,9 @@ static int bnxt_hwrm_remote_dev_reset_set(struct bnxt *bp, bool remote_reset)
 	return hwrm_req_send(bp, req);
 }
 
-static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
-				     struct devlink_fmsg *fmsg,
-				     struct netlink_ext_ack *extack)
+static int bnxt_fw_diagnose(struct devlink_health_reporter *reporter,
+			    struct devlink_fmsg *fmsg,
+			    struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
 	u32 val;
@@ -110,14 +110,9 @@ static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 	return 0;
 }
 
-static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
-	.name = "fw",
-	.diagnose = bnxt_fw_reporter_diagnose,
-};
-
-static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
-				 void *priv_ctx,
-				 struct netlink_ext_ack *extack)
+static int bnxt_fw_recover(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
 
@@ -127,43 +122,26 @@ static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
 	return -EINPROGRESS;
 }
 
-static const
-struct devlink_health_reporter_ops bnxt_dl_fw_fatal_reporter_ops = {
-	.name = "fw_fatal",
-	.recover = bnxt_fw_fatal_recover,
+static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
+	.name = "fw",
+	.diagnose = bnxt_fw_diagnose,
+	.recover = bnxt_fw_recover,
 };
 
 void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!health)
+	if (!health || health->fw_reporter)
 		return;
 
-	if (!health->fw_reporter) {
-		health->fw_reporter =
-			devlink_health_reporter_create(bp->dl,
-						       &bnxt_dl_fw_reporter_ops,
-						       0, bp);
-		if (IS_ERR(health->fw_reporter)) {
-			netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
-				    PTR_ERR(health->fw_reporter));
-			health->fw_reporter = NULL;
-			return;
-		}
-	}
-
-	if (health->fw_fatal_reporter)
-		return;
-
-	health->fw_fatal_reporter =
-		devlink_health_reporter_create(bp->dl,
-					       &bnxt_dl_fw_fatal_reporter_ops,
+	health->fw_reporter =
+		devlink_health_reporter_create(bp->dl, &bnxt_dl_fw_reporter_ops,
 					       0, bp);
-	if (IS_ERR(health->fw_fatal_reporter)) {
-		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
-			    PTR_ERR(health->fw_fatal_reporter));
-		health->fw_fatal_reporter = NULL;
+	if (IS_ERR(health->fw_reporter)) {
+		netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
+			    PTR_ERR(health->fw_reporter));
+		health->fw_reporter = NULL;
 		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
 	}
 }
@@ -182,11 +160,6 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 		devlink_health_reporter_destroy(health->fw_reporter);
 		health->fw_reporter = NULL;
 	}
-
-	if (health->fw_fatal_reporter) {
-		devlink_health_reporter_destroy(health->fw_fatal_reporter);
-		health->fw_fatal_reporter = NULL;
-	}
 }
 
 void bnxt_devlink_health_fw_report(struct bnxt *bp)
@@ -196,13 +169,12 @@ void bnxt_devlink_health_fw_report(struct bnxt *bp)
 	if (!fw_health)
 		return;
 
-	if (!fw_health->fw_fatal_reporter) {
+	if (!fw_health->fw_reporter) {
 		__bnxt_fw_recover(bp);
 		return;
 	}
 
-	devlink_health_report(fw_health->fw_fatal_reporter,
-			      "FW fatal error reported", NULL);
+	devlink_health_report(fw_health->fw_reporter, "FW error reported", NULL);
 }
 
 void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy)
@@ -215,15 +187,14 @@ void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy)
 	else
 		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
 
-	devlink_health_reporter_state_update(health->fw_fatal_reporter, state);
+	devlink_health_reporter_state_update(health->fw_reporter, state);
 }
 
 void bnxt_dl_health_fw_recovery_done(struct bnxt *bp)
 {
-	struct bnxt_fw_health *hlth = bp->fw_health;
 	struct bnxt_dl *dl = devlink_priv(bp->dl);
 
-	devlink_health_reporter_recovery_done(hlth->fw_fatal_reporter);
+	devlink_health_reporter_recovery_done(bp->fw_health->fw_reporter);
 	bnxt_hwrm_remote_dev_reset_set(bp, dl->remote_reset);
 }
 
-- 
2.18.1


--0000000000003308b005cf790d66
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMkG0Ab8gDYulOMBhkAPHW8KwHXIuM+R
ERV8n9Jf91omMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAYT8ZQhN7alTJorpCBDOFPexsUqQ8e1HHdK+JPPWQWlncE06Fy
biuj2moC9bpNw8gwLQP8ijsMtvIoFfvkxexf5VapJNG+GdoHO6MTLdVHp4T5Ke0gyKVeqgmzIxE7
I9dIpMLAa5ioc9jEyXjQHOfJzInbICNBIJ8bYbQMgDAtZ2ZlirF0pzlTC8aDX4XcYhot5bs6R6Zr
sw3ddZNsp1aPSI4OTipa7rVanEfktaUEXQaGvPcR1XI2IByBCp74ojpNsyclJGCo+D8lnW/TeXW+
CygRO86uVJlZcRMZr1zB5z31ISS0C05HUqpGlcgL6mkkage08MWaylC+CHkkD4hW
--0000000000003308b005cf790d66--
