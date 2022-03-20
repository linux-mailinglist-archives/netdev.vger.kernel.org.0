Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9DB4E1A97
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 07:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244890AbiCTHAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 03:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244889AbiCTG7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 02:59:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6F2255BB
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 23:58:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so5774285pjq.2
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 23:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TX7HR277sdU5pieMFKc/Owdhxaq0BrhWwpUtqMCVjDQ=;
        b=d2WjAksHWIbS/TX5dv9s8Qu/0cHsbSmOxOBwQpB4Zwe3hFAMzMzYolmZRNQsD4UTID
         DuZJIckE5TUh8YQgxlQbUw3QNi9O9CBC4rIfDJZ0EBNoAFiW2ylvzehtKHIYXayj6cfk
         M+npzPykrL90pkEC0dwWcco7E4od5Z2zWVMeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TX7HR277sdU5pieMFKc/Owdhxaq0BrhWwpUtqMCVjDQ=;
        b=ykm+2cV+rmNPV3/+wqTbSpZ2gneR5wZAgfdptPeoLe8VIIfFs5c+ILB7m6qVFA6CwF
         +Zudv3YYU2fiysPSigl7cfL7omXr/JLIxNmPrXqgMqnLqdj+V88P4DvqiSLL7YaqqRq+
         6f++hZcH1AScbQgt56PaKtyiECOlYd8b8+n3YFXo7JTgZ1KKX52gnvC/MSUe+EnVlzQ8
         BeKJnwOxF7ERhgW4qL01H8xEBCOXcz6xvnz5L+1pM8UzOKnTh6xfw8HbiXWkT6GPbJkI
         Bf9QVYQgqb2B6csBhOt6K/Z0KWiwBZdJRVhbfeU6lxagtz6HAfwVS4gwhwEGx9ToRTSJ
         u6Ow==
X-Gm-Message-State: AOAM530IpdxUgae3z7RO5xMKPesjLAWUm97TmF+zz3+fi00w2O4hU3f/
        UmX0Ekxb0sRw87FML4XVxN3yTg==
X-Google-Smtp-Source: ABdhPJyaASegap9jIYhduge5BjqKICsWAOy8fBYSCbGijRO4WVm8zeDwi95Vj4GbvAQI90PwHoVVWA==
X-Received: by 2002:a17:902:f686:b0:151:d866:f657 with SMTP id l6-20020a170902f68600b00151d866f657mr7284115plg.112.1647759500022;
        Sat, 19 Mar 2022 23:58:20 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q4-20020a056a00150400b004f78d4821a0sm15359334pfu.204.2022.03.19.23.58.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Mar 2022 23:58:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 03/11] bnxt: refactor bnxt_rx_pages operate on skb_shared_info
Date:   Sun, 20 Mar 2022 02:57:45 -0400
Message-Id: <1647759473-2414-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647759473-2414-1-git-send-email-michael.chan@broadcom.com>
References: <1647759473-2414-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b951bc05daa0e72d"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b951bc05daa0e72d

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
index b7d7ee775fdc..ba01a353bb3f 100644
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


--000000000000b951bc05daa0e72d
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMttNjKgde+aMZYlrcoGSoBMoowJSOIM
wFMx8ZdnizcTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MDA2NTgyMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAYS/Xlm3ofLyOymgLWkqzfJV6tz1lR1wzxFdiWWuHWaeV6SAXK
DEe+qJleGsftBMXnuQkzJ9JwQoGWGSLtS9KN6gBaqwXwUzKiYnDAeFGmwC8A44hgIoWUjUfD7xZt
Fr9YbfcCUSh5T0oMP87yBmr/M4cOwzoId6iQaZv+Ql8JbbwNJBI5smYohgmAO3qIf1+G+Vd5WkRf
qdRVc1d3iX+YSN3zrGXuKJgM1nNy1rnH5ZzMYm7cFDh+G/yPUSOJ17H4pTETZ20j3hfJqkyPXA9Y
l7gUIBgklJ8JGdeFhQQfsYIIsJFDr3dvOSaWVbreRzAYzCsvu6h7pFRmbsk+VfhH
--000000000000b951bc05daa0e72d--
