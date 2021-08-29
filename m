Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AB03FA9F4
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbhH2HgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhH2HgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:36:14 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0840CC061756
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lc21so23751331ejc.7
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zKSfEjWbgza5dW75Y24HkAlQgDAyB19zoMa55nFHqPY=;
        b=AiZCBSRKfIO1P13J7MxnwprJ3CfRIsI1AQLeuhkU73zEdfkifjfrDl2kWgb60Y+Fjx
         XgUIu1FAZx8A1f5o9FSqR4dzxSiUaHi9Qk4TjoDmQwS7rADMG7MTqsoTUo1o4JkYZVEo
         WUhysIsGcVjxP34h0fnpbeX+xHoh1f5KD7A9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zKSfEjWbgza5dW75Y24HkAlQgDAyB19zoMa55nFHqPY=;
        b=GwgLw/PeWeRLqy1PZfXGc26b3G46eZ8K+SVk2xdD3AbqtzpEAq/Zxo27nlVbZi8bmQ
         xGUlSsj7BkQ5t+r3pGATBuh+SF0JRu216Y7GMnWmLFEZTN0DTcOVyPbRxYGVXs4ijply
         AgCsNw7ongDkt8BFQrHgkEQku5hrq0uLX/hPqc+QsGx+ZCoMkXLNVR/VJUh8tOlKySPb
         3QzprB0zxbNOBtUC4JyDSLKP5FpU4XlqMM9+sxyWK6ia4ep5Y3U19owSQq6SLiCld684
         tqfZBL29EK9pT/aQis+l0LT4j0xxiKeof7TQGVrBrRlwwtffoDaU2ui536RMLOYHLXFl
         fhtQ==
X-Gm-Message-State: AOAM5319d8W6hyBcwt6dNFImm6Q3M/7mDf/BHDGOiS0cqYh89psRHWkR
        JvtJnRki4bAUh9C2wIxoVyZ+yA==
X-Google-Smtp-Source: ABdhPJy3SlY01vu0e4TBVumh5i8h/20zAMjnJkkExhvV3ublO0tJcbAEpA4urZK3OKv9l0Fl+ORGzw==
X-Received: by 2002:a17:906:3e1b:: with SMTP id k27mr18895364eji.284.1630222521232;
        Sun, 29 Aug 2021 00:35:21 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id dy7sm984007edb.38.2021.08.29.00.35.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Aug 2021 00:35:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next v2 01/11] bnxt_en: remove DMA mapping for KONG response
Date:   Sun, 29 Aug 2021 03:34:56 -0400
Message-Id: <1630222506-19532-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000512d4a05caadc28b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000512d4a05caadc28b

From: Edwin Peer <edwin.peer@broadcom.com>

The additional response buffer serves no useful purpose. There can
be only one firmware command in flight due to the hwrm_cmd_lock mutex,
which is taken for the entire duration of any command completion,
KONG or otherwise. It is thus safe to share a single DMA buffer.

Removing the code associated with the additional mapping will simplify
matters in the next patch, which allocates response buffers from DMA
pools on a per request basis.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 42 +++--------------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 16 ++-------
 2 files changed, 7 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ccf1e47d9e92..fb75fa9614c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3962,30 +3962,6 @@ static void bnxt_free_hwrm_resources(struct bnxt *bp)
 				  bp->hwrm_cmd_resp_dma_addr);
 		bp->hwrm_cmd_resp_addr = NULL;
 	}
-
-	if (bp->hwrm_cmd_kong_resp_addr) {
-		dma_free_coherent(&pdev->dev, PAGE_SIZE,
-				  bp->hwrm_cmd_kong_resp_addr,
-				  bp->hwrm_cmd_kong_resp_dma_addr);
-		bp->hwrm_cmd_kong_resp_addr = NULL;
-	}
-}
-
-static int bnxt_alloc_kong_hwrm_resources(struct bnxt *bp)
-{
-	struct pci_dev *pdev = bp->pdev;
-
-	if (bp->hwrm_cmd_kong_resp_addr)
-		return 0;
-
-	bp->hwrm_cmd_kong_resp_addr =
-		dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
-				   &bp->hwrm_cmd_kong_resp_dma_addr,
-				   GFP_KERNEL);
-	if (!bp->hwrm_cmd_kong_resp_addr)
-		return -ENOMEM;
-
-	return 0;
 }
 
 static int bnxt_alloc_hwrm_resources(struct bnxt *bp)
@@ -4581,10 +4557,7 @@ void bnxt_hwrm_cmd_hdr_init(struct bnxt *bp, void *request, u16 req_type,
 	req->req_type = cpu_to_le16(req_type);
 	req->cmpl_ring = cpu_to_le16(cmpl_ring);
 	req->target_id = cpu_to_le16(target_id);
-	if (bnxt_kong_hwrm_message(bp, req))
-		req->resp_addr = cpu_to_le64(bp->hwrm_cmd_kong_resp_dma_addr);
-	else
-		req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
+	req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
 }
 
 static int bnxt_hwrm_to_stderr(u32 hwrm_err)
@@ -4641,11 +4614,10 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 			return -EINVAL;
 	}
 
-	if (bnxt_hwrm_kong_chnl(bp, req)) {
+	if (bnxt_kong_hwrm_message(bp, req)) {
 		dst = BNXT_HWRM_CHNL_KONG;
 		bar_offset = BNXT_GRCPF_REG_KONG_COMM;
 		doorbell_offset = BNXT_GRCPF_REG_KONG_COMM_TRIGGER;
-		resp = bp->hwrm_cmd_kong_resp_addr;
 	}
 
 	memset(resp, 0, PAGE_SIZE);
@@ -11948,12 +11920,6 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 			return rc;
 	}
 
-	if (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL) {
-		rc = bnxt_alloc_kong_hwrm_resources(bp);
-		if (rc)
-			bp->fw_cap &= ~BNXT_FW_CAP_KONG_MB_CHNL;
-	}
-
 	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
 	    bp->hwrm_max_ext_req_len > BNXT_HWRM_MAX_REQ_LEN) {
 		rc = bnxt_alloc_hwrm_short_cmd_req(bp);
@@ -12136,8 +12102,8 @@ static void bnxt_reset_all(struct bnxt *bp)
 	} else if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU) {
 		struct hwrm_fw_reset_input req = {0};
 
-		bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_RESET, -1, -1);
-		req.resp_addr = cpu_to_le64(bp->hwrm_cmd_kong_resp_dma_addr);
+		bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_RESET, -1,
+				       HWRM_TARGET_ID_KONG);
 		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP;
 		req.selfrst_status = FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP;
 		req.flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index dc96dd6957c9..a4fb1aa12b24 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1915,8 +1915,6 @@ struct bnxt {
 	dma_addr_t		hwrm_short_cmd_req_dma_addr;
 	void			*hwrm_cmd_resp_addr;
 	dma_addr_t		hwrm_cmd_resp_dma_addr;
-	void			*hwrm_cmd_kong_resp_addr;
-	dma_addr_t		hwrm_cmd_kong_resp_dma_addr;
 
 	struct rtnl_link_stats64	net_stats_prev;
 	struct bnxt_stats_mem	port_stats;
@@ -2216,21 +2214,13 @@ static inline bool bnxt_cfa_hwrm_message(u16 req_type)
 static inline bool bnxt_kong_hwrm_message(struct bnxt *bp, struct input *req)
 {
 	return (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL &&
-		bnxt_cfa_hwrm_message(le16_to_cpu(req->req_type)));
-}
-
-static inline bool bnxt_hwrm_kong_chnl(struct bnxt *bp, struct input *req)
-{
-	return (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL &&
-		req->resp_addr == cpu_to_le64(bp->hwrm_cmd_kong_resp_dma_addr));
+		(bnxt_cfa_hwrm_message(le16_to_cpu(req->req_type)) ||
+		 le16_to_cpu(req->target_id) == HWRM_TARGET_ID_KONG));
 }
 
 static inline void *bnxt_get_hwrm_resp_addr(struct bnxt *bp, void *req)
 {
-	if (bnxt_hwrm_kong_chnl(bp, (struct input *)req))
-		return bp->hwrm_cmd_kong_resp_addr;
-	else
-		return bp->hwrm_cmd_resp_addr;
+	return bp->hwrm_cmd_resp_addr;
 }
 
 static inline u16 bnxt_get_hwrm_seq_id(struct bnxt *bp, u16 dst)
-- 
2.18.1


--000000000000512d4a05caadc28b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEPgBqcFGFtzNPRMZPCm4G1QJvlGVomR
onH+xREAyxGdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
OTA3MzUyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAUY3qFtSprLIFje8i8XqIOsDGr45iKdsYGi40AKQhOZ+02rsvJ
jY7tXadpABAZtVUHBg+fTXxEb4Am0F1KK9Fj75RNxlSGYciNjmJOy9/OtVxAsTJohmTDoT4+zF//
6ALm5Jke51FaBmN3pCIgBqPRy0t8NAXRBH+dJWkqJrr1M9qcTrXWWf/IYuAtIYox3AZ9gZgWL3hp
NxFWmEEWmMws8V3TViCNbVOwOoM3tkp82ODNdZXdRvEyStL5B3uqIQqriP2bU17HqDLNv7O/RPw7
spTwKJvASwyeXeEmSqfhpwte3TZPG3Hv57sh1rAuXXXL4RsBylnCrhUFnmpUHAFb
--000000000000512d4a05caadc28b--
