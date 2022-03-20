Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A37B4E1A98
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 07:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244889AbiCTHAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 03:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244911AbiCTG7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 02:59:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8306949C9C
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 23:58:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso7762086pjb.5
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 23:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C9H/kDVjsr0+4NzMNudtXwUQpFCKxpT6eONqNaqGcF4=;
        b=N+0REF53nqp5xmWc8adpaX4LB2n38boQLBMB1jMHxFJAsGS4P0ES+H6a7ET+82QJO+
         uz8en36wFyJDMcUDBp/xhFjRoURwrJbzamgN0CWuuDPTslm5jZ5Kbi1d2XYksOKjKOWo
         VlGiDpHE+yAMTr18FXntXsJv8Y8onsRTk8sGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C9H/kDVjsr0+4NzMNudtXwUQpFCKxpT6eONqNaqGcF4=;
        b=O4UnPMAmJpPx+DK1ELCrSoW2s8mHMsnjbwY4vfw1LKipw2cFcqDa2MbFQBdnF/2nq3
         ezl0iSnQ7EBy6VA/fUl2PibQc/PNJETwXGTB7GE93gvsDXIPvJXW0vCJSq3pvToDypQl
         OAVpHsCZiCe5gd8peA1t10FhKRW1JhqXQQ/jtDoIUowpTD5FaKtZF2SvmFEBARkM+0Go
         piblMGHDMvxGrazuuM+qOvucloGqwkKZj7MN3ZwdPFBIENirN44YwoyGS0V3uK3iATWr
         MnxrSsCaeUqvwsqeV0FM38HDJPKgXP57yvUuBtqazO5segrDhoNJQMLpSde0uhUS97JM
         uxyQ==
X-Gm-Message-State: AOAM532UlMdbmbeP5OL7uh2V2F6JTw+D5idGT1zPP9I2ZrzZyGhd20tE
        70sEAX2pW1Kc7tHBzcLzQw2JIg==
X-Google-Smtp-Source: ABdhPJwuhWVKumVZSnC9sG9FPrT6zuu6uciYH6nASfoN4lDdNVASWjbHSMRYbWxMzoncj37mPZnlzw==
X-Received: by 2002:a17:903:2306:b0:154:92f:67c3 with SMTP id d6-20020a170903230600b00154092f67c3mr7336300plh.157.1647759505726;
        Sat, 19 Mar 2022 23:58:25 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q4-20020a056a00150400b004f78d4821a0sm15359334pfu.204.2022.03.19.23.58.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Mar 2022 23:58:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 08/11] bnxt: add page_pool support for aggregation ring when using xdp
Date:   Sun, 20 Mar 2022 02:57:50 -0400
Message-Id: <1647759473-2414-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647759473-2414-1-git-send-email-michael.chan@broadcom.com>
References: <1647759473-2414-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000bec4605daa0e80b"
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

--0000000000000bec4605daa0e80b

From: Andy Gospodarek <gospo@broadcom.com>

If we are using aggregation rings with XDP enabled, allocate page
buffers for the aggregation rings from the page_pool.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 77 ++++++++++++++---------
 1 file changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b635b7ce6ba3..980c176d7c88 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -739,7 +739,6 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
-	*mapping += bp->rx_dma_offset;
 	return page;
 }
 
@@ -781,6 +780,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		if (!page)
 			return -ENOMEM;
 
+		mapping += bp->rx_dma_offset;
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + bp->rx_offset;
 	} else {
@@ -841,33 +841,41 @@ static inline int bnxt_alloc_rx_page(struct bnxt *bp,
 	u16 sw_prod = rxr->rx_sw_agg_prod;
 	unsigned int offset = 0;
 
-	if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
-		page = rxr->rx_page;
-		if (!page) {
+	if (BNXT_RX_PAGE_MODE(bp)) {
+		page = __bnxt_alloc_rx_page(bp, &mapping, rxr, gfp);
+
+		if (!page)
+			return -ENOMEM;
+
+	} else {
+		if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
+			page = rxr->rx_page;
+			if (!page) {
+				page = alloc_page(gfp);
+				if (!page)
+					return -ENOMEM;
+				rxr->rx_page = page;
+				rxr->rx_page_offset = 0;
+			}
+			offset = rxr->rx_page_offset;
+			rxr->rx_page_offset += BNXT_RX_PAGE_SIZE;
+			if (rxr->rx_page_offset == PAGE_SIZE)
+				rxr->rx_page = NULL;
+			else
+				get_page(page);
+		} else {
 			page = alloc_page(gfp);
 			if (!page)
 				return -ENOMEM;
-			rxr->rx_page = page;
-			rxr->rx_page_offset = 0;
 		}
-		offset = rxr->rx_page_offset;
-		rxr->rx_page_offset += BNXT_RX_PAGE_SIZE;
-		if (rxr->rx_page_offset == PAGE_SIZE)
-			rxr->rx_page = NULL;
-		else
-			get_page(page);
-	} else {
-		page = alloc_page(gfp);
-		if (!page)
-			return -ENOMEM;
-	}
 
-	mapping = dma_map_page_attrs(&pdev->dev, page, offset,
-				     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
-				     DMA_ATTR_WEAK_ORDERING);
-	if (dma_mapping_error(&pdev->dev, mapping)) {
-		__free_page(page);
-		return -EIO;
+		mapping = dma_map_page_attrs(&pdev->dev, page, offset,
+					     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
+					     DMA_ATTR_WEAK_ORDERING);
+		if (dma_mapping_error(&pdev->dev, mapping)) {
+			__free_page(page);
+			return -EIO;
+		}
 	}
 
 	if (unlikely(test_bit(sw_prod, rxr->rx_agg_bmap)))
@@ -1105,7 +1113,7 @@ static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
 		}
 
 		dma_unmap_page_attrs(&pdev->dev, mapping, BNXT_RX_PAGE_SIZE,
-				     DMA_FROM_DEVICE,
+				     bp->rx_dir,
 				     DMA_ATTR_WEAK_ORDERING);
 
 		total_frag_len += frag_len;
@@ -2936,14 +2944,23 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 		if (!page)
 			continue;
 
-		dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
-				     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
-				     DMA_ATTR_WEAK_ORDERING);
+		if (BNXT_RX_PAGE_MODE(bp)) {
+			dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
+					     BNXT_RX_PAGE_SIZE, bp->rx_dir,
+					     DMA_ATTR_WEAK_ORDERING);
+			rx_agg_buf->page = NULL;
+			__clear_bit(i, rxr->rx_agg_bmap);
 
-		rx_agg_buf->page = NULL;
-		__clear_bit(i, rxr->rx_agg_bmap);
+			page_pool_recycle_direct(rxr->page_pool, page);
+		} else {
+			dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
+					     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
+					     DMA_ATTR_WEAK_ORDERING);
+			rx_agg_buf->page = NULL;
+			__clear_bit(i, rxr->rx_agg_bmap);
 
-		__free_page(page);
+			__free_page(page);
+		}
 	}
 
 skip_rx_agg_free:
-- 
2.18.1


--0000000000000bec4605daa0e80b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFMolila4rw+wpVk0naNQxowGmbpQNSW
WScz1EawDmU3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MDA2NTgyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAGeInUIhxkuoQy2abiNowUsQbKn3hLokn52tVQrkx8SuxlMX/f
lep+ZQwCHM4bjZVn/dKZ6aueHy1hheOl71QPEg7iVEwzG2yxFg9e9KqOAlzQtJMf7mAcRhTNy/kB
bFyR5FP5Q1e/koQg1n8h8IeoUFavFCy0G50F9jhvJc9hIZzhlRhcp3SlnHMVxUTyCNJi2dfTm5tJ
J8CYSGjMkOugFnP+f55aGmS/38qQopYnTsUQZnBAgFBoDZXCNxyL9iRvKkSy+0nOYoXDrLQ092cg
qeah2AiY+Q5aF2xlNm1/PHC9qRI4WFRWHHfc8mfK1oGNlg+2pkpI4L8aMsC3rCic
--0000000000000bec4605daa0e80b--
