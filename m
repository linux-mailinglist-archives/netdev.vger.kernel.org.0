Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367CA48874E
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 02:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiAIBjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 20:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiAIBjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 20:39:11 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8C2C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 17:39:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so17842369pjj.2
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 17:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X/5V8FhE2gV9nll3bB6ijWDIAOxaFrBjpyi1OzA2jaA=;
        b=argMaAwu0TW07hqD7TVbbjHfWYpnnS7pfqPIvJ1VYcaevo0csjPjaWh7HxbmO9HBVq
         xY7frz1O/1HshUkE8O93wrKNwDIudam7qc7WwXt/AXvdXuKeWGAo6xdhikLIsHB3jQkP
         h3900l9WvFY3Gf3a5ccfaU1DNccIEHdMvnx/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X/5V8FhE2gV9nll3bB6ijWDIAOxaFrBjpyi1OzA2jaA=;
        b=QrP9c/72IFJmt5AwFlL7XdaDee5/qOMqylolsl/y+kC6hZWIVYZR74iCPNMQE9lqDN
         e/BIDS9OngjXtSd9m6qM00QJOD/LwfIUzxcitcfdmX9bzOT2DIh81k52FK45MMJdT1wu
         JJT6BhuMWrGIuxExdusOtDRO9jmG9Q/RpxOae87dex0n/2l615o0S7Wu3p2nxOaE3ITH
         YDFm4ksPORU6CO9pr21orQGEa2ecu5jR8TnKoLI4K6JvJlLTMbuqPGXtKI24fT6WBvi8
         Ta+dv3wa9oKuzMTPIkJJ36cAOj+H+eY0WJMLQo9Zz9vNL99V4uDfo6uiWHUwx3SNQDep
         gmsA==
X-Gm-Message-State: AOAM531ETBu0qG+DEHV7pRdgIBc+bl/ikq+L2M4kwHoTg0V5YSrtGxKw
        eh4scg2tw+ift21NdPZ85YRyaA==
X-Google-Smtp-Source: ABdhPJwWKmZoDxreuYzpE8Nq3Zwgb3roAVZGxy/HOSFNMr/Ps1W0rJiHwXFQTSR4FDmEdFQUpR8KXQ==
X-Received: by 2002:a17:902:7c05:b0:149:a3b4:934c with SMTP id x5-20020a1709027c0500b00149a3b4934cmr42681775pll.42.1641692350131;
        Sat, 08 Jan 2022 17:39:10 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ng18sm1175988pjb.36.2022.01.08.17.39.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jan 2022 17:39:09 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 4/4] bnxt_en: improve firmware timeout messaging
Date:   Sat,  8 Jan 2022 20:38:48 -0500
Message-Id: <1641692328-11477-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1641692328-11477-1-git-send-email-michael.chan@broadcom.com>
References: <1641692328-11477-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000636b3005d51c49f2"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000636b3005d51c49f2

From: Edwin Peer <edwin.peer@broadcom.com>

While it has always been possible to infer that an HWRM command was
abandoned due to an unhealthy firmware status by the shortened timeout
reported, this change improves the log messaging to account for this
case explicitly. In the interests of further clarity, the firmware
status is now also reported in these new messages.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 13 --------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 -
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 32 +++++++++++++++----
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    |  4 ---
 4 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a5539eb26808..351b55b3464b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7694,19 +7694,6 @@ static void __bnxt_map_fw_health_reg(struct bnxt *bp, u32 reg)
 					 BNXT_FW_HEALTH_WIN_MAP_OFF);
 }
 
-bool bnxt_is_fw_healthy(struct bnxt *bp)
-{
-	if (bp->fw_health && bp->fw_health->status_reliable) {
-		u32 fw_status;
-
-		fw_status = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
-		if (fw_status && !BNXT_FW_IS_HEALTHY(fw_status))
-			return false;
-	}
-
-	return true;
-}
-
 static void bnxt_inv_fw_health_reg(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 0da68dc35c69..440dfeb4948b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2305,7 +2305,6 @@ int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset);
 int bnxt_hwrm_alloc_wol_fltr(struct bnxt *bp);
 int bnxt_hwrm_free_wol_fltr(struct bnxt *bp);
 int bnxt_hwrm_func_resc_qcaps(struct bnxt *bp, bool all);
-bool bnxt_is_fw_healthy(struct bnxt *bp);
 int bnxt_hwrm_fw_set_time(struct bnxt *);
 int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 4c4027cfb322..084936288970 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -444,6 +444,19 @@ static void hwrm_req_dbg(struct bnxt *bp, struct input *req)
 			netdev_err((bp)->dev, fmt, __VA_ARGS__);       \
 	} while (0)
 
+static inline bool
+hwrm_wait_must_abort(struct bnxt *bp, u32 req_type, u32 *fw_status)
+{
+	if (req_type == HWRM_VER_GET)
+		return false;
+
+	if (!bp->fw_health || !bp->fw_health->status_reliable)
+		return false;
+
+	*fw_status = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+	return *fw_status && !BNXT_FW_IS_HEALTHY(*fw_status);
+}
+
 static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 {
 	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
@@ -455,8 +468,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	unsigned int i, timeout, tmo_count;
 	u32 *data = (u32 *)ctx->req;
 	u32 msg_len = ctx->req_len;
+	u32 req_type, sts;
 	int rc = -EBUSY;
-	u32 req_type;
 	u16 len = 0;
 	u8 *valid;
 
@@ -556,8 +569,11 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
 					     HWRM_SHORT_MAX_TIMEOUT);
 			} else {
-				if (HWRM_WAIT_MUST_ABORT(bp, ctx))
-					break;
+				if (hwrm_wait_must_abort(bp, req_type, &sts)) {
+					hwrm_err(bp, ctx, "Resp cmpl intr abandoning msg: 0x%x due to firmware status: 0x%x\n",
+						 req_type, sts);
+					goto exit;
+				}
 				usleep_range(HWRM_MIN_TIMEOUT,
 					     HWRM_MAX_TIMEOUT);
 			}
@@ -608,15 +624,19 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
 					     HWRM_SHORT_MAX_TIMEOUT);
 			} else {
-				if (HWRM_WAIT_MUST_ABORT(bp, ctx))
-					goto timeout_abort;
+				if (hwrm_wait_must_abort(bp, req_type, &sts)) {
+					hwrm_err(bp, ctx, "Abandoning msg {0x%x 0x%x} len: %d due to firmware status: 0x%x\n",
+						 req_type,
+						 le16_to_cpu(ctx->req->seq_id),
+						 len, sts);
+					goto exit;
+				}
 				usleep_range(HWRM_MIN_TIMEOUT,
 					     HWRM_MAX_TIMEOUT);
 			}
 		}
 
 		if (i >= tmo_count) {
-timeout_abort:
 			hwrm_err(bp, ctx, "Error (timeout: %u) msg {0x%x 0x%x} len:%d\n",
 				 hwrm_total_timeout(i), req_type,
 				 le16_to_cpu(ctx->req->seq_id), len);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 08258d201086..179ac93af706 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -83,10 +83,6 @@ void hwrm_update_token(struct bnxt *bp, u16 seq, enum bnxt_hwrm_wait_state s);
 #define HWRM_MIN_TIMEOUT		25
 #define HWRM_MAX_TIMEOUT		40
 
-#define HWRM_WAIT_MUST_ABORT(bp, ctx)					\
-	(le16_to_cpu((ctx)->req->req_type) != HWRM_VER_GET &&		\
-	 !bnxt_is_fw_healthy(bp))
-
 static inline unsigned int hwrm_total_timeout(unsigned int n)
 {
 	return n <= HWRM_SHORT_TIMEOUT_COUNTER ? n * HWRM_SHORT_MIN_TIMEOUT :
-- 
2.18.1


--000000000000636b3005d51c49f2
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAycnBEPONZQ5xkAhTpXLR2EL84dplqr
Sf/XehSSU2tXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEw
OTAxMzkxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAhL0G1hn8eCPeSqIuz7YliCgbqJC6QGhjnbuUYr3HHKL/P2PIH
+8v2OZX6PNJD7UXyqt+Vuwcgy7443axQAPYfjwjRGb2fRf7aI4xdHzmPvHvPUzZJtjBBoG8NpsKP
LOz0Gt8k5WEsv7VS4PdW7Cs5tUjbkEaZbYpH3suDjRfU5KmF682+SNwHaQMuZMoPCIuOa3of1Htj
2/qMEGgUNO6z69QbR4XcR6TOIG7ZJa/81mrPCoFU+ApVU7yUpsSxb5RHzxvcVW/z5puT6dvakT52
cL2Rw5CW204ul7R89SMQml+xMy1IGDLW9ZDjj0/vWtKWBKZ1ETaPhud8eJQFsA9C
--000000000000636b3005d51c49f2--
