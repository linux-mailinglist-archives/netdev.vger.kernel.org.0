Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD0348874B
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 02:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiAIBjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 20:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiAIBjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 20:39:07 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03777C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 17:39:07 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id pf13so1639110pjb.0
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 17:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0c2nF8CRrRuEHfD9t09yd9MMY2SMljvgVT6dAGqh6Pk=;
        b=NsC+OiNwiRpl/9ZsZrOgJ5F9Prsi3QKRS3hV/67ORpzzzdy4WJRJDooAji39FxaceW
         YAn9SCdTQwkNLjcOyqDP3v9PFY5+LzXjP0qg6Hq1txYSVqCMCbpDFZpZcWE+ue6bK+y1
         2tAl0ib4aMuF/4dGSEj9/KLIqh/iq1WeGuww0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0c2nF8CRrRuEHfD9t09yd9MMY2SMljvgVT6dAGqh6Pk=;
        b=dgsrrAwLNQ7/87893AdchZWi4dAzjnQAZRZshl1ZOW/UXGxz+NPgLp+iksJ/ois7op
         gsi/aPphfwECPH+dZFc++s7FnGlmNAunmSRmPPfnV5x/eQDscGcmHcz49J2nBUEWmhOA
         7TrwJAjexpK71+hCnQ3Gah81Nby2Ven1+mi5DqE/WbUpU5xUcNoop05bEUKqW4TiQ5+1
         JVaVwbrdFlA1GtpgUU7sxfMmBjEsUjKRwRIZBj7eU5K1cxUD9gLGiPPonLhd5CRiBhPc
         EQ2UJ/frMS4WUd0fVl/9tm87uSAboKx2vJYiRdtYSOF30Hx6pwFs083C6RPOcnZNqmlq
         degQ==
X-Gm-Message-State: AOAM5307WIfFYTz+NjZkbpaLUJErua/d6f7AnKq0O/N13WnPdsCrY60l
        teXsvjEC/rAM0FbpyxcJVZjb+bdkI+5mloUN
X-Google-Smtp-Source: ABdhPJzVc8//h9II7eSkjwzxOGv5KgCx14fWr6MfCIClAN+DJH9QdM6C/QGCDuwIzQ/KY0SH0BXiKg==
X-Received: by 2002:a17:902:d645:b0:149:b7bf:9932 with SMTP id y5-20020a170902d64500b00149b7bf9932mr31150115plh.48.1641692346243;
        Sat, 08 Jan 2022 17:39:06 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ng18sm1175988pjb.36.2022.01.08.17.39.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jan 2022 17:39:05 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 1/4] bnxt_en: add dynamic debug support for HWRM messages
Date:   Sat,  8 Jan 2022 20:38:45 -0500
Message-Id: <1641692328-11477-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1641692328-11477-1-git-send-email-michael.chan@broadcom.com>
References: <1641692328-11477-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000028fa6205d51c499b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000028fa6205d51c499b

From: Edwin Peer <edwin.peer@broadcom.com>

Add logging of firmware messages. These can be useful for diagnosing
issues in the field, but due to their verbosity are only appropriate
at a debug message level.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  3 +
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 68 +++++++++++++------
 2 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4d7ea62e24fb..203d2ddb5504 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2086,6 +2086,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	u32 data1 = le32_to_cpu(cmpl->event_data1);
 	u32 data2 = le32_to_cpu(cmpl->event_data2);
 
+	netdev_dbg(bp->dev, "hwrm event 0x%x {0x%x, 0x%x}\n",
+		   event_id, data1, data2);
+
 	/* TODO CHIMP_FW: Define event id's for link change, error etc */
 	switch (event_id) {
 	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CFG_CHANGE: {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index bb7327b82d0b..a16d1ff6359c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -416,6 +416,32 @@ hwrm_update_token(struct bnxt *bp, u16 seq_id, enum bnxt_hwrm_wait_state state)
 	netdev_err(bp->dev, "Invalid hwrm seq id %d\n", seq_id);
 }
 
+static void hwrm_req_dbg(struct bnxt *bp, struct input *req)
+{
+	u32 ring = le16_to_cpu(req->cmpl_ring);
+	u32 type = le16_to_cpu(req->req_type);
+	u32 tgt = le16_to_cpu(req->target_id);
+	u32 seq = le16_to_cpu(req->seq_id);
+	char opt[32] = "\n";
+
+	if (unlikely(ring != (u16)BNXT_HWRM_NO_CMPL_RING))
+		snprintf(opt, 16, " ring %d\n", ring);
+
+	if (unlikely(tgt != BNXT_HWRM_TARGET))
+		snprintf(opt + strlen(opt) - 1, 16, " tgt 0x%x\n", tgt);
+
+	netdev_dbg(bp->dev, "sent hwrm req_type 0x%x seq id 0x%x%s",
+		   type, seq, opt);
+}
+
+#define hwrm_err(bp, ctx, fmt, ...)				       \
+	do {							       \
+		if ((ctx)->flags & BNXT_HWRM_CTX_SILENT)	       \
+			netdev_dbg((bp)->dev, fmt, __VA_ARGS__);       \
+		else						       \
+			netdev_err((bp)->dev, fmt, __VA_ARGS__);       \
+	} while (0)
+
 static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 {
 	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
@@ -436,8 +462,11 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		memset(ctx->resp, 0, PAGE_SIZE);
 
 	req_type = le16_to_cpu(ctx->req->req_type);
-	if (BNXT_NO_FW_ACCESS(bp) && req_type != HWRM_FUNC_RESET)
+	if (BNXT_NO_FW_ACCESS(bp) && req_type != HWRM_FUNC_RESET) {
+		netdev_dbg(bp->dev, "hwrm req_type 0x%x skipped, FW channel down\n",
+			   req_type);
 		goto exit;
+	}
 
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN &&
 	    msg_len > bp->hwrm_max_ext_req_len) {
@@ -490,6 +519,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	/* Ring channel doorbell */
 	writel(1, bp->bar0 + doorbell_offset);
 
+	hwrm_req_dbg(bp, ctx->req);
+
 	if (!pci_is_enabled(bp->pdev)) {
 		rc = -ENODEV;
 		goto exit;
@@ -531,9 +562,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		}
 
 		if (READ_ONCE(token->state) != BNXT_HWRM_COMPLETE) {
-			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
-				netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
-					   le16_to_cpu(ctx->req->req_type));
+			hwrm_err(bp, ctx, "Resp cmpl intr err msg: 0x%x\n",
+				 req_type);
 			goto exit;
 		}
 		len = le16_to_cpu(READ_ONCE(ctx->resp->resp_len));
@@ -565,7 +595,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 				if (resp_seq != seen_out_of_seq) {
 					netdev_warn(bp->dev, "Discarding out of seq response: 0x%x for msg {0x%x 0x%x}\n",
 						    le16_to_cpu(resp_seq),
-						    le16_to_cpu(ctx->req->req_type),
+						    req_type,
 						    le16_to_cpu(ctx->req->seq_id));
 					seen_out_of_seq = resp_seq;
 				}
@@ -585,11 +615,9 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 
 		if (i >= tmo_count) {
 timeout_abort:
-			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
-				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d\n",
-					   hwrm_total_timeout(i),
-					   le16_to_cpu(ctx->req->req_type),
-					   le16_to_cpu(ctx->req->seq_id), len);
+			hwrm_err(bp, ctx, "Error (timeout: %u) msg {0x%x 0x%x} len:%d\n",
+				 hwrm_total_timeout(i), req_type,
+				 le16_to_cpu(ctx->req->seq_id), len);
 			goto exit;
 		}
 
@@ -604,12 +632,9 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
-			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
-				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
-					   hwrm_total_timeout(i),
-					   le16_to_cpu(ctx->req->req_type),
-					   le16_to_cpu(ctx->req->seq_id), len,
-					   *valid);
+			hwrm_err(bp, ctx, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
+				 hwrm_total_timeout(i), req_type,
+				 le16_to_cpu(ctx->req->seq_id), len, *valid);
 			goto exit;
 		}
 	}
@@ -620,11 +645,12 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	 */
 	*valid = 0;
 	rc = le16_to_cpu(ctx->resp->error_code);
-	if (rc && !(ctx->flags & BNXT_HWRM_CTX_SILENT)) {
-		netdev_err(bp->dev, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
-			   le16_to_cpu(ctx->resp->req_type),
-			   le16_to_cpu(ctx->resp->seq_id), rc);
-	}
+	if (rc == HWRM_ERR_CODE_BUSY && !(ctx->flags & BNXT_HWRM_CTX_SILENT))
+		netdev_warn(bp->dev, "FW returned busy, hwrm req_type 0x%x\n",
+			    req_type);
+	else if (rc)
+		hwrm_err(bp, ctx, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
+			 req_type, token->seq_id, rc);
 	rc = __hwrm_to_stderr(rc);
 exit:
 	if (token)
-- 
2.18.1


--00000000000028fa6205d51c499b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAHj25zCndi/D+TPy+MbejwZpfuu231u
ZM7neI95O/jIMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEw
OTAxMzkwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAqDTrCrCxsb8gt1LvAeBV2jew+aM0NGviEofNLNFPet960PnnO
9g0oQ+bCPpEEwj6aVvmXslKDH7KRIuVQ5aWFOpFKz+FNtcfQzFLhrNiPIoKxoqrwvFxRV8bHsETR
BaiNzR1MfR30oNehDWfJs+ngx0KYBSTVAXBusAlDF5+6YA8jq9UMYQB9N3bOPFbh6rvJfZpkwKB0
zxd5qS09LVgouXYyMW0PHTpVU15x2yg7TScqSFNGajVKTwGg4xjxLs4nydHLl5vAkAX4t+ltWwjh
D1o/Bb3dnU4WwsCqrucTxaG2YstwZSJUjhIO3XFFPE/sS43P89gxBe7/RsIWp2vM
--00000000000028fa6205d51c499b--
