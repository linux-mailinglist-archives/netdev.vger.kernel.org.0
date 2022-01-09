Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0BD488D69
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbiAIXzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbiAIXzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:55:08 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710A0C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 15:55:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id pj2so10636876pjb.2
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 15:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z2HJW4BhCjKyvE6F5pBywzLmRxIImQViFOcqCzo54j8=;
        b=dvPFOpglwhf3VqctNki8ibECqRSxp1t4HlwZA/lUDGRcmzscsUI8qqInIDmUAmtaqc
         ClkQgXo6unJ/wEDjuzJIPmxp/KdGt6IxDRY1ox2Ma91y7KUixnCQ7SL7Z9Q6ZdoMB/tl
         Su9y36X5kyXvH1uR5pNU824DkR9kUrH7Ri1+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z2HJW4BhCjKyvE6F5pBywzLmRxIImQViFOcqCzo54j8=;
        b=E/CL/4obh6rSBsjtJdM5C3lliFrsiC7CTayukLst1aUb9U+gwsz+syZ6LgEcdoANT5
         n9Fyv2RoQ5EvXmzdOkjGfDIPD/lJih007HYZ8SHHe766cN+W5tnqPed5v5Jj53mz67Y8
         Hb0gAFh4+TWfXP1NNiS5FvrsPSVrmZE34O2COwFqP4Gm2t+/fClhq9wlBqqBM77oX0Rd
         1LENOMo/pK5kLTuTtXKMWh1FwOx5jTejEtVDbs9n4PlUS2KkpSxhI3ep1h0tuYCpPojT
         kiMmKxZAdLh0EbAyD0yCs7ONY8v/KwDer+CwiYXibmeXlrHxtQuC5ezcqsUp1Qun4e8p
         8zAw==
X-Gm-Message-State: AOAM531m5aL+tKi5SlH0XfkJ2F6cx+z6E+ac7mvipsWiYDZzcUnQHYYi
        4FtITtY2YApUZqh/JxUp3zYZag==
X-Google-Smtp-Source: ABdhPJzbVtg+14IS3JylM2VCYSiYlqetlG7kieni5tkj05D8p63rrZonZbTcpDv3kHfcwaGPuGHnQQ==
X-Received: by 2002:a17:902:8546:b0:149:d79a:1f2a with SMTP id d6-20020a170902854600b00149d79a1f2amr21283994plo.86.1641772507715;
        Sun, 09 Jan 2022 15:55:07 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ls6sm6948611pjb.33.2022.01.09.15.55.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jan 2022 15:55:07 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 4/4] bnxt_en: improve firmware timeout messaging
Date:   Sun,  9 Jan 2022 18:54:45 -0500
Message-Id: <1641772485-10421-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
References: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000026e6ed05d52ef351"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000026e6ed05d52ef351

From: Edwin Peer <edwin.peer@broadcom.com>

While it has always been possible to infer that an HWRM command was
abandoned due to an unhealthy firmware status by the shortened timeout
reported, this change improves the log messaging to account for this
case explicitly. In the interests of further clarity, the firmware
status is now also reported in these new messages.

v2: Remove inline keyword for hwrm_wait_must_abort() in .c file.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 13 --------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 -
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 31 +++++++++++++++----
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    |  4 ---
 4 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2a000d5ae3bf..4f94136a011a 100644
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
index 4c4027cfb322..566c9487ef55 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -444,6 +444,18 @@ static void hwrm_req_dbg(struct bnxt *bp, struct input *req)
 			netdev_err((bp)->dev, fmt, __VA_ARGS__);       \
 	} while (0)
 
+static bool hwrm_wait_must_abort(struct bnxt *bp, u32 req_type, u32 *fw_status)
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
@@ -455,8 +467,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	unsigned int i, timeout, tmo_count;
 	u32 *data = (u32 *)ctx->req;
 	u32 msg_len = ctx->req_len;
+	u32 req_type, sts;
 	int rc = -EBUSY;
-	u32 req_type;
 	u16 len = 0;
 	u8 *valid;
 
@@ -556,8 +568,11 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
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
@@ -608,15 +623,19 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
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
index 9a9fc4e8041b..d52bd2d63aec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -82,10 +82,6 @@ void hwrm_update_token(struct bnxt *bp, u16 seq, enum bnxt_hwrm_wait_state s);
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


--00000000000026e6ed05d52ef351
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKYV7Cd9Seq6KTkFp1PMN8U/0fA2CCqr
NVtZSBxMBMJVMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEw
OTIzNTUwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCEcw7Qe9ek/ZWq2KJwDwMm8Wc4M2t/9HcWd0mPxKn4/Qrc11p9
/ditQzkzXCE7CZ/KSIHV0qzb2AksTMD6270aTfE70HGybq54zXnpnjmwKabLVAA9jTpgYIQUkMM8
23Hh+rld+0TITtHj8MyvUqOprk1pPZAwTKQK6wIpB6vSWVviT4vXLeLm5wywUoaWYRXGLyRryoQI
0ULiD5dj4uqNdsAPpau1Rv0fAFH3Vu1g3LA/d2K9ciIh5EhZK193kZbepTZZRdPR66eC2pINqQQ7
K/kxFB6Y3wsWpEriVskJ4YYfDKPWVjaXSly4Z9ymIYFMUT8jKospiYpflxM4b9mo
--00000000000026e6ed05d52ef351--
