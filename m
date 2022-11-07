Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0640E61E7DA
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 01:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiKGAQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 19:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiKGAQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 19:16:50 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7656312
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 16:16:49 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id l15so6156505qtv.4
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 16:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VntKCbdjZiKAfVtxA1cO9Em2DH7VASH/XkiZ7ooDlck=;
        b=S6ME/6CosPBheu/VlA8aOFxIxlPQwq7siKNTsr/BY8Carhz7G8+9qYXSAPYUyKq7Tb
         OCVKN2nUChVcfKymCfgkTY78XeUxssU5ZBQ+eJ75dOc+qVP+JvZYBKc5upU6ystjtXxF
         FOB+eQb98stpSRwkM9f26Dm3YJ0OY8VnjZPic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VntKCbdjZiKAfVtxA1cO9Em2DH7VASH/XkiZ7ooDlck=;
        b=VVEwsSJZeIt7feAd+irmb3kk0ulKw+WtrTXssHSmwS2/0ae0+zYOzYblnlbslDZwPw
         e8g++2U3mKQRUs+RWoE2ibWkteU56GBRHQh708AUCa1q+cNecaLgbHTpeY0XLQMs3GwU
         W3UyTn3KmBnpIncEGgR1aeCr0Iz42+Ukp4h7GKyH1rUeQUNhuL2CgXdlJOkqOjUBVkco
         iE0GYQr8joYu0Z76/yPKQtqzwPVMZ5itl+sy9bnpvp/cdwjGaSn2RsqJ0+Z1y1LheKUJ
         hGNeAkO9+lzUhZth8+NwKG76VuHpM2TrDjqERMWLPFmMr7fO49vXpXxPW3FKchQhrjZJ
         sG0A==
X-Gm-Message-State: ANoB5pkeIHHpjg+9UzxudW3G6eTBvoP0hz9HPstipoDe5dYGh43ZQobq
        aVNBS+tYvYUIVZ6u+x4rLxYKIQ==
X-Google-Smtp-Source: AA0mqf5IS3RkQYQ/mxG7nn71IhdLBH+fkovGJrjAcdUqriCY7ItJptZGg/FIeBaap89kx7vCXyQtNw==
X-Received: by 2002:ac8:4d59:0:b0:3a5:8a23:ceb2 with SMTP id x25-20020ac84d59000000b003a58a23ceb2mr2374081qtv.116.1667780207761;
        Sun, 06 Nov 2022 16:16:47 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k2-20020ac80742000000b0035badb499c7sm4904079qth.21.2022.11.06.16.16.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Nov 2022 16:16:47 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, pavan.chebbi@broadcom.com
Subject: [PATCH net-next 1/3] bnxt_en: refactor VNIC RSS update functions
Date:   Sun,  6 Nov 2022 19:16:30 -0500
Message-Id: <1667780192-3700-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
References: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000de8e8505ecd65694"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000de8e8505ecd65694

From: Edwin Peer <edwin.peer@broadcom.com>

Extract common code into a new function. This will avoid duplication
in the next patch, which changes the update algorithm for both the P5
and legacy code paths.

No functional changes.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 +++++++++++------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 03272aa48511..15edb6cb3656 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5250,7 +5250,7 @@ int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
 	return 1;
 }
 
-static void __bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
+static void bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 {
 	bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);
 	u16 i, j;
@@ -5263,8 +5263,8 @@ static void __bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 	}
 }
 
-static void __bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
-				      struct bnxt_vnic_info *vnic)
+static void bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
+				    struct bnxt_vnic_info *vnic)
 {
 	__le16 *ring_tbl = vnic->rss_table;
 	struct bnxt_rx_ring_info *rxr;
@@ -5285,12 +5285,19 @@ static void __bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
 	}
 }
 
-static void bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
+static void
+__bnxt_hwrm_vnic_set_rss(struct bnxt *bp, struct hwrm_vnic_rss_cfg_input *req,
+			 struct bnxt_vnic_info *vnic)
 {
 	if (bp->flags & BNXT_FLAG_CHIP_P5)
-		__bnxt_fill_hw_rss_tbl_p5(bp, vnic);
+		bnxt_fill_hw_rss_tbl_p5(bp, vnic);
 	else
-		__bnxt_fill_hw_rss_tbl(bp, vnic);
+		bnxt_fill_hw_rss_tbl(bp, vnic);
+
+	req->hash_type = cpu_to_le32(bp->rss_hash_cfg);
+	req->hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
+	req->ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
+	req->hash_key_tbl_addr = cpu_to_le64(vnic->rss_hash_key_dma_addr);
 }
 
 static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
@@ -5307,14 +5314,8 @@ static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 	if (rc)
 		return rc;
 
-	if (set_rss) {
-		bnxt_fill_hw_rss_tbl(bp, vnic);
-		req->hash_type = cpu_to_le32(bp->rss_hash_cfg);
-		req->hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
-		req->ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
-		req->hash_key_tbl_addr =
-			cpu_to_le64(vnic->rss_hash_key_dma_addr);
-	}
+	if (set_rss)
+		__bnxt_hwrm_vnic_set_rss(bp, req, vnic);
 	req->rss_ctx_idx = cpu_to_le16(vnic->fw_rss_cos_lb_ctx[0]);
 	return hwrm_req_send(bp, req);
 }
@@ -5335,10 +5336,7 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 	if (!set_rss)
 		return hwrm_req_send(bp, req);
 
-	bnxt_fill_hw_rss_tbl(bp, vnic);
-	req->hash_type = cpu_to_le32(bp->rss_hash_cfg);
-	req->hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
-	req->hash_key_tbl_addr = cpu_to_le64(vnic->rss_hash_key_dma_addr);
+	__bnxt_hwrm_vnic_set_rss(bp, req, vnic);
 	ring_tbl_map = vnic->rss_table_dma_addr;
 	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
 
-- 
2.18.1


--000000000000de8e8505ecd65694
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIA1eQXkH1lZaTmq4jXuR30Qi2viC2Q82
wOcJbVQMWpDXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEw
NzAwMTY0OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAsD3Vl82Z+wg+A4lYgU/UtB0oD4eS/Y5I1SbuIJgWeYg4h1riV
a12/qAYcfbfh7r+RRq0rBg2qSwHKtkQhNq9+1LRBtPZ50oU3ecdCVbhtk19VZ+8GNgEjeEo5R57L
1wubwsrxSmtFtgduO7/x5oI26ZTfTJq32+0MYZYCefsuO4wo1L1ypYSrM452G7utJGZ0ETmJPMBv
DNhg6eqX1r+ZJ6mlxRvqlZzdok00LaJ4U+kqqnqlwFhg8z/2VlnVFerWDhSubML0V5VAiTPSCMUo
M9c1vKUOvkIjosVhdoKd01NOGEuaqQBaIBGsTZsjs4MgTb4yAET9HzChyUOEXM7m
--000000000000de8e8505ecd65694--
