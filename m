Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2177C4F623F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiDFO7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiDFO6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:58:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0302D32FDDA
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 19:54:31 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n9so801548plc.4
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 19:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FPvaCICXw+c0g+KlmjJUqVxWe1timKdAxr9cJCvAMc8=;
        b=VhuT9F/G5wBJSi9EU+UHIb4A4uWYsqWvMMAy7g6qEAEEy0nKvzPozMSI+CiJTui2NH
         eX5s80836v+6yaOIZ36LiUNejeCEhUIKkRDtJmb013vVTOTx0+qzpKRcOUqHIdocUKeJ
         NmQmgCH51mZmEti8UNPVc3PAxm5JOheQYz2+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FPvaCICXw+c0g+KlmjJUqVxWe1timKdAxr9cJCvAMc8=;
        b=RYiILzEELKdkPfmA0bhHLoZ1lZtLazzDZo+UCJNoY6BJSit6QBxNTpHm9BJ3EIstJ/
         X9q4uWnbnp8CN4Zf6+tl2d1xLM2VKs/SvZt1me1I6wVyQtc7n/H1j+YVnsub5MWXRFGx
         aEllfAq+zUSIaXeveAlYg01+uMf5r0E07vHldsNBpdDRt6u3Iq+i5Iyufk4GNajCtrDs
         fv1wAHhAcBYtWudUMHzJCpiskGhTbslG4TNd5J+GzV12BitvDhJPBK61Z0Z9Ld1tTBYK
         z9VpdE/ucxsnTanv2PsgCRgR0VSIyayjIztTrEHASEGr30UlEtSGPYyfMvQ9wIxqgeen
         bInQ==
X-Gm-Message-State: AOAM530F4C/0WE0VoGfpxZrO4s7AJKM6T8sUoSHXIX5ZKNfFSoTHVgcj
        Mth7bRIHALMC98cvBJXGHMzy3g==
X-Google-Smtp-Source: ABdhPJz92s5OjXOvFNxGujGTihBYdIG8dsp5pLr3rmxS+GwA0KoQuYwaMTgTneFhBO+MhcZQGifT1A==
X-Received: by 2002:a17:90b:4d08:b0:1c7:7567:9f6b with SMTP id mw8-20020a17090b4d0800b001c775679f6bmr7657433pjb.134.1649213660295;
        Tue, 05 Apr 2022 19:54:20 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a970900b001ca6c59b350sm3395111pjo.2.2022.04.05.19.54.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Apr 2022 19:54:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        bpf@vger.kernel.org, john.fastabend@gmail.com, toke@redhat.com,
        lorenzo@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        echaudro@redhat.com, pabeni@redhat.com
Subject: [PATCH net-next v3 03/11] bnxt: refactor bnxt_rx_pages operate on skb_shared_info
Date:   Tue,  5 Apr 2022 22:53:45 -0400
Message-Id: <1649213633-7662-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
References: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006e00bb05dbf37a7a"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006e00bb05dbf37a7a

From: Andy Gospodarek <gospo@broadcom.com>

Rather than operating on an sk_buff, add frags from the aggregation
ring into the frags of an skb_shared_info.  This will allow the
caller to use either an sk_buff or xdp_buff.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 50 +++++++++++++++--------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f6973f57ccd2..4ae94387d07b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1038,22 +1038,23 @@ static struct sk_buff *bnxt_rx_skb(struct bnxt *bp,
 	return skb;
 }
 
-static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
-				     struct bnxt_cp_ring_info *cpr,
-				     struct sk_buff *skb, u16 idx,
-				     u32 agg_bufs, bool tpa)
+static u32 __bnxt_rx_pages(struct bnxt *bp,
+			   struct bnxt_cp_ring_info *cpr,
+			   struct skb_shared_info *shinfo,
+			   u16 idx, u32 agg_bufs, bool tpa)
 {
 	struct bnxt_napi *bnapi = cpr->bnapi;
 	struct pci_dev *pdev = bp->pdev;
 	struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 	u16 prod = rxr->rx_agg_prod;
+	u32 i, total_frag_len = 0;
 	bool p5_tpa = false;
-	u32 i;
 
 	if ((bp->flags & BNXT_FLAG_CHIP_P5) && tpa)
 		p5_tpa = true;
 
 	for (i = 0; i < agg_bufs; i++) {
+		skb_frag_t *frag = &shinfo->frags[i];
 		u16 cons, frag_len;
 		struct rx_agg_cmp *agg;
 		struct bnxt_sw_rx_agg_bd *cons_rx_buf;
@@ -1069,8 +1070,10 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 			    RX_AGG_CMP_LEN) >> RX_AGG_CMP_LEN_SHIFT;
 
 		cons_rx_buf = &rxr->rx_agg_ring[cons];
-		skb_fill_page_desc(skb, i, cons_rx_buf->page,
-				   cons_rx_buf->offset, frag_len);
+		skb_frag_off_set(frag, cons_rx_buf->offset);
+		skb_frag_size_set(frag, frag_len);
+		__skb_frag_set_page(frag, cons_rx_buf->page);
+		shinfo->nr_frags = i + 1;
 		__clear_bit(cons, rxr->rx_agg_bmap);
 
 		/* It is possible for bnxt_alloc_rx_page() to allocate
@@ -1082,15 +1085,10 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 		cons_rx_buf->page = NULL;
 
 		if (bnxt_alloc_rx_page(bp, rxr, prod, GFP_ATOMIC) != 0) {
-			struct skb_shared_info *shinfo;
 			unsigned int nr_frags;
 
-			shinfo = skb_shinfo(skb);
 			nr_frags = --shinfo->nr_frags;
 			__skb_frag_set_page(&shinfo->frags[nr_frags], NULL);
-
-			dev_kfree_skb(skb);
-
 			cons_rx_buf->page = page;
 
 			/* Update prod since possibly some pages have been
@@ -1098,20 +1096,38 @@ static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
 			 */
 			rxr->rx_agg_prod = prod;
 			bnxt_reuse_rx_agg_bufs(cpr, idx, i, agg_bufs - i, tpa);
-			return NULL;
+			return 0;
 		}
 
 		dma_unmap_page_attrs(&pdev->dev, mapping, BNXT_RX_PAGE_SIZE,
 				     DMA_FROM_DEVICE,
 				     DMA_ATTR_WEAK_ORDERING);
 
-		skb->data_len += frag_len;
-		skb->len += frag_len;
-		skb->truesize += PAGE_SIZE;
-
+		total_frag_len += frag_len;
 		prod = NEXT_RX_AGG(prod);
 	}
 	rxr->rx_agg_prod = prod;
+	return total_frag_len;
+}
+
+static struct sk_buff *bnxt_rx_pages(struct bnxt *bp,
+				     struct bnxt_cp_ring_info *cpr,
+				     struct sk_buff *skb, u16 idx,
+				     u32 agg_bufs, bool tpa)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	u32 total_frag_len = 0;
+
+	total_frag_len = __bnxt_rx_pages(bp, cpr, shinfo, idx, agg_bufs, tpa);
+
+	if (!total_frag_len) {
+		dev_kfree_skb(skb);
+		return NULL;
+	}
+
+	skb->data_len += total_frag_len;
+	skb->len += total_frag_len;
+	skb->truesize += PAGE_SIZE * agg_bufs;
 	return skb;
 }
 
-- 
2.18.1


--0000000000006e00bb05dbf37a7a
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIG6TXDQzcGy6epznpWKziYCIPBFCg1+C
RPyqsU0PV3t0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQw
NjAyNTQyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQArPLeyizGjC4MuJKUTS0jeXuzMsKXIThjR6GjyDEZLPM0WApnz
B8FFtIu+wYcT4nO/BWNto0rE5PlmIH1IAAsm1gIRJ/d353qrtFgLr8pBH1Z8k82LB5BszosCQ434
BL7eU6W9Tzv0SCsPPSJMDQgn9XO95biIBXciW78P9hcaw4RC3Y5qzuujkBehfkTl4/xQQpZadxzy
+SuIxZIUJuGYki28a0/8+Kodm/QBFMBqluCJ8FJVbu/LFKDoIAnxhu438vS3BitGe6AYbp5cRkLq
/buHOkEec6hxqsA2POA4Yf0x6coBfUmFRmm+3Bvkddb2MmgxFFH9r4bx9zSCjOM3
--0000000000006e00bb05dbf37a7a--
