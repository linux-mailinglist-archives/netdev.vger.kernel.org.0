Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9948282D37
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgJDTXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgJDTXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 15:23:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B186BC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 12:23:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so5088401pff.6
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 12:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bFMb8yaeuZYoKzd/kmCqAu00E8Ad/AtDc1Y+CsBxR6I=;
        b=Hc6R+kANE8kR/UFrjz71Y8ayzF1uUYn4oi2vaa2nrAmuQ51Ziizn51B03j8EXT/jWt
         zjHS+HNbJr9S/3x5XxwPwQcTjCbfJr6yZe8B8o1RfpreGoW8BD4y7MYhPIByB58GbsHv
         PMrDu0GsR7Vb19wAnfLL+Mu1eKqr7Peta4098=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bFMb8yaeuZYoKzd/kmCqAu00E8Ad/AtDc1Y+CsBxR6I=;
        b=akYJt2N3QF4txy0VpfD9SvPw0MHkWmT58dU6ZjLCvs0H2bfKYq+txgT+sdhDphnQdJ
         uaHc2JuDrvOm+HUc6TClKtc7vz2MVrxxRzX4yzmp0OnGc0qm+K/WWRXdIqe4EBHIY1+s
         5zqCyz2NOgGZvCZWmWDl5uTS8Y3lnEgu1LS2kQVxsjexdhV4SoNfLcQSoy+NwStghyAu
         h09fRXcGSNhzA9jX6qVDFpeYFwY4Xb2OmC/dLbDf4+dODm1DXr0TNEDZERqbn4PIDs5j
         qKhsQYVlhmIcZEiOwgp9sVkx7JWGeJ+YChxepi3N6wptiyZkuWyHh+EeGvJgYISh6Ty7
         s9FA==
X-Gm-Message-State: AOAM53118svT/PiqIxaWweItEZFYNGNiZ7UgCC9uHuLqozvOx6dQnxal
        JH5UkVnhAj88yuL6oDlDR+4Lqw==
X-Google-Smtp-Source: ABdhPJyvQI/dC9zl0AMoPS6YDvXqqpqa4tgcfr3n8ygRCQ2gkcjF2blVy8TDSUWTNNJAdangzhH8pA==
X-Received: by 2002:a63:5fcb:: with SMTP id t194mr11713516pgb.364.1601839409962;
        Sun, 04 Oct 2020 12:23:29 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 138sm9824234pfu.180.2020.10.04.12.23.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2020 12:23:29 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 06/11] bnxt_en: Refactor bnxt_free_rx_skbs().
Date:   Sun,  4 Oct 2020 15:22:56 -0400
Message-Id: <1601839381-10446-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
References: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000c715b05b0dd4d5a"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000c715b05b0dd4d5a

bnxt_free_rx_skbs() frees all the allocated buffers and SKBs for
every RX ring.  Refactor this function by calling a new function
bnxt_free_one_rx_ring_skbs() to free these buffers on one specified
RX ring at a time.  This is preparation work for resetting one RX
ring during run-time.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 134 +++++++++++-----------
 1 file changed, 66 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 27fbe0cef2a9..6d7e197c875c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2540,93 +2540,91 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
 	}
 }
 
-static void bnxt_free_rx_skbs(struct bnxt *bp)
+static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 {
-	int i, max_idx, max_agg_idx;
+	struct bnxt_rx_ring_info *rxr = &bp->rx_ring[ring_nr];
 	struct pci_dev *pdev = bp->pdev;
-
-	if (!bp->rx_ring)
-		return;
+	struct bnxt_tpa_idx_map *map;
+	int i, max_idx, max_agg_idx;
 
 	max_idx = bp->rx_nr_pages * RX_DESC_CNT;
 	max_agg_idx = bp->rx_agg_nr_pages * RX_DESC_CNT;
-	for (i = 0; i < bp->rx_nr_rings; i++) {
-		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
-		struct bnxt_tpa_idx_map *map;
-		int j;
-
-		if (rxr->rx_tpa) {
-			for (j = 0; j < bp->max_tpa; j++) {
-				struct bnxt_tpa_info *tpa_info =
-							&rxr->rx_tpa[j];
-				u8 *data = tpa_info->data;
+	if (!rxr->rx_tpa)
+		goto skip_rx_tpa_free;
 
-				if (!data)
-					continue;
+	for (i = 0; i < bp->max_tpa; i++) {
+		struct bnxt_tpa_info *tpa_info = &rxr->rx_tpa[i];
+		u8 *data = tpa_info->data;
 
-				dma_unmap_single_attrs(&pdev->dev,
-						       tpa_info->mapping,
-						       bp->rx_buf_use_size,
-						       bp->rx_dir,
-						       DMA_ATTR_WEAK_ORDERING);
+		if (!data)
+			continue;
 
-				tpa_info->data = NULL;
+		dma_unmap_single_attrs(&pdev->dev, tpa_info->mapping,
+				       bp->rx_buf_use_size, bp->rx_dir,
+				       DMA_ATTR_WEAK_ORDERING);
 
-				kfree(data);
-			}
-		}
+		tpa_info->data = NULL;
 
-		for (j = 0; j < max_idx; j++) {
-			struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[j];
-			dma_addr_t mapping = rx_buf->mapping;
-			void *data = rx_buf->data;
+		kfree(data);
+	}
 
-			if (!data)
-				continue;
+skip_rx_tpa_free:
+	for (i = 0; i < max_idx; i++) {
+		struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[i];
+		dma_addr_t mapping = rx_buf->mapping;
+		void *data = rx_buf->data;
 
-			rx_buf->data = NULL;
+		if (!data)
+			continue;
 
-			if (BNXT_RX_PAGE_MODE(bp)) {
-				mapping -= bp->rx_dma_offset;
-				dma_unmap_page_attrs(&pdev->dev, mapping,
-						     PAGE_SIZE, bp->rx_dir,
-						     DMA_ATTR_WEAK_ORDERING);
-				page_pool_recycle_direct(rxr->page_pool, data);
-			} else {
-				dma_unmap_single_attrs(&pdev->dev, mapping,
-						       bp->rx_buf_use_size,
-						       bp->rx_dir,
-						       DMA_ATTR_WEAK_ORDERING);
-				kfree(data);
-			}
+		rx_buf->data = NULL;
+		if (BNXT_RX_PAGE_MODE(bp)) {
+			mapping -= bp->rx_dma_offset;
+			dma_unmap_page_attrs(&pdev->dev, mapping, PAGE_SIZE,
+					     bp->rx_dir,
+					     DMA_ATTR_WEAK_ORDERING);
+			page_pool_recycle_direct(rxr->page_pool, data);
+		} else {
+			dma_unmap_single_attrs(&pdev->dev, mapping,
+					       bp->rx_buf_use_size, bp->rx_dir,
+					       DMA_ATTR_WEAK_ORDERING);
+			kfree(data);
 		}
+	}
+	for (i = 0; i < max_agg_idx; i++) {
+		struct bnxt_sw_rx_agg_bd *rx_agg_buf = &rxr->rx_agg_ring[i];
+		struct page *page = rx_agg_buf->page;
 
-		for (j = 0; j < max_agg_idx; j++) {
-			struct bnxt_sw_rx_agg_bd *rx_agg_buf =
-				&rxr->rx_agg_ring[j];
-			struct page *page = rx_agg_buf->page;
-
-			if (!page)
-				continue;
+		if (!page)
+			continue;
 
-			dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
-					     BNXT_RX_PAGE_SIZE,
-					     PCI_DMA_FROMDEVICE,
-					     DMA_ATTR_WEAK_ORDERING);
+		dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
+				     BNXT_RX_PAGE_SIZE, PCI_DMA_FROMDEVICE,
+				     DMA_ATTR_WEAK_ORDERING);
 
-			rx_agg_buf->page = NULL;
-			__clear_bit(j, rxr->rx_agg_bmap);
+		rx_agg_buf->page = NULL;
+		__clear_bit(i, rxr->rx_agg_bmap);
 
-			__free_page(page);
-		}
-		if (rxr->rx_page) {
-			__free_page(rxr->rx_page);
-			rxr->rx_page = NULL;
-		}
-		map = rxr->rx_tpa_idx_map;
-		if (map)
-			memset(map->agg_idx_bmap, 0, sizeof(map->agg_idx_bmap));
+		__free_page(page);
+	}
+	if (rxr->rx_page) {
+		__free_page(rxr->rx_page);
+		rxr->rx_page = NULL;
 	}
+	map = rxr->rx_tpa_idx_map;
+	if (map)
+		memset(map->agg_idx_bmap, 0, sizeof(map->agg_idx_bmap));
+}
+
+static void bnxt_free_rx_skbs(struct bnxt *bp)
+{
+	int i;
+
+	if (!bp->rx_ring)
+		return;
+
+	for (i = 0; i < bp->rx_nr_rings; i++)
+		bnxt_free_one_rx_ring_skbs(bp, i);
 }
 
 static void bnxt_free_skbs(struct bnxt *bp)
-- 
2.18.1


--0000000000000c715b05b0dd4d5a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgUHYhNtWM+UmP
OrUQUlP0HRQiVvUpGmz9IkbgU13fDjIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDA0MTkyMzMwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACBfK2Oi4rRuV+YAG2dKDOernhq9udoS
o+4wSXvMpLNRIoEXx95p09ZLGhnourIPdxisL87/Zw97DmEmNebPutyIqLIY5uSqtel7JDNHrPSv
Upop7KMeztZ1kMHmCoXWjHl7TELJpuDEBtpJbx+70EVnjIwmrYP7gp9ThzGOe0QI447YVQ3Ae5vs
pqVutqz69wttPRUQHYRN0OQUcUrDj9nX5CA/QqudvgcDfFLOAUnwm0VSz2M4XO4gmQyIRwETU6ZM
AHcwyqDx050VmxpNtJLXaBXolM/k4BZu9z8MszWEkh2XdyLkiV23thmmHp9AsnQnv+ETlSEaQPeX
HKuuD6Q=
--0000000000000c715b05b0dd4d5a--
