Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98248282D3D
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgJDTXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgJDTXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 15:23:32 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B64DC0613CF
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 12:23:32 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w21so5078484pfc.7
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 12:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vf4h/v0f9xFEjUd6u9Fu+p9uJGql5+ReFzx6/FwYIUg=;
        b=JtLW8wD0AXvW5Ci9ygNmkqmjVxuIhjxBmkhE4n2giv3U0/vtwcCkqk/AQlUkbMz6Lc
         Fyo5a3tMmvQ2gVt09B1ViCibyEItTqTo+fraitduZaVlaL4zgMn+tpJLQ5wFDjLOc999
         fWxBk1ev+S4WHvasMLF7dIHuU6J68W0DIJjoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vf4h/v0f9xFEjUd6u9Fu+p9uJGql5+ReFzx6/FwYIUg=;
        b=ta5+ctun8paGCuCfXIVrlouk6+JWpzk+MkCBOytFHZL2Cri3pdb4narw29JtIj9pn4
         N1CmbdVBhsfokXeg9v1K9pcObCm5/7YxKsyrVuaVlPWq07bPlp5sf/q8XbFQcwEB3YA3
         bicjivNACWN+ZIKgnPj83RKYA0M0XW8jPEUpAMF1zf7K0p1UTuO/IBXI7cgoP5THrc0Q
         qSux/STyb9C27rwqamlcl3URIJM0r/dbxlUPsPHpkAl2gKsUbL6ElWWUN5Xla0iOAqwc
         ZXQOOT53wRrjEdVE2BQ8W7qvcYROs9HylQ7eMFjQmz3YJDusnIu5+pdxFZZrYQPImRoC
         Vf8w==
X-Gm-Message-State: AOAM5327zPmI/6wvugt0EckdkUy2s00cDTz4oCKZImYhaIqA2mY9HJwe
        /tGp9SO9JTX4SCNpkQlhbGm5cg==
X-Google-Smtp-Source: ABdhPJzs4kC2c3hpsVjgY08L78fNpvAb+R7C4IETo+7UhE9BWn9pxZi9OhRNjGBIOf2+gspz/dOkmg==
X-Received: by 2002:a63:a0f:: with SMTP id 15mr10958218pgk.242.1601839411284;
        Sun, 04 Oct 2020 12:23:31 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 138sm9824234pfu.180.2020.10.04.12.23.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2020 12:23:30 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 07/11] bnxt_en: Refactor bnxt_init_one_rx_ring().
Date:   Sun,  4 Oct 2020 15:22:57 -0400
Message-Id: <1601839381-10446-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
References: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002112a105b0dd4d25"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002112a105b0dd4d25

bnxt_init_one_rx_ring() includes logic to initialize the BDs for one RX
ring and to allocate the buffers.  Separate the allocation logic into a
new bnxt_alloc_one_rx_ring() function.  The allocation function will be
used later to allocate new buffers for one specified RX ring when we
reset that RX ring.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 96 ++++++++++++-----------
 1 file changed, 50 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6d7e197c875c..ef0267060a46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3163,31 +3163,16 @@ static void bnxt_init_rxbd_pages(struct bnxt_ring_struct *ring, u32 type)
 	}
 }
 
-static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
+static int bnxt_alloc_one_rx_ring(struct bnxt *bp, int ring_nr)
 {
+	struct bnxt_rx_ring_info *rxr = &bp->rx_ring[ring_nr];
 	struct net_device *dev = bp->dev;
-	struct bnxt_rx_ring_info *rxr;
-	struct bnxt_ring_struct *ring;
-	u32 prod, type;
+	u32 prod;
 	int i;
 
-	type = (bp->rx_buf_use_size << RX_BD_LEN_SHIFT) |
-		RX_BD_TYPE_RX_PACKET_BD | RX_BD_FLAGS_EOP;
-
-	if (NET_IP_ALIGN == 2)
-		type |= RX_BD_FLAGS_SOP;
-
-	rxr = &bp->rx_ring[ring_nr];
-	ring = &rxr->rx_ring_struct;
-	bnxt_init_rxbd_pages(ring, type);
-
-	if (BNXT_RX_PAGE_MODE(bp) && bp->xdp_prog) {
-		bpf_prog_add(bp->xdp_prog, 1);
-		rxr->xdp_prog = bp->xdp_prog;
-	}
 	prod = rxr->rx_prod;
 	for (i = 0; i < bp->rx_ring_size; i++) {
-		if (bnxt_alloc_rx_data(bp, rxr, prod, GFP_KERNEL) != 0) {
+		if (bnxt_alloc_rx_data(bp, rxr, prod, GFP_KERNEL)) {
 			netdev_warn(dev, "init'ed rx ring %d with %d/%d skbs only\n",
 				    ring_nr, i, bp->rx_ring_size);
 			break;
@@ -3195,22 +3180,13 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 		prod = NEXT_RX(prod);
 	}
 	rxr->rx_prod = prod;
-	ring->fw_ring_id = INVALID_HW_RING_ID;
-
-	ring = &rxr->rx_agg_ring_struct;
-	ring->fw_ring_id = INVALID_HW_RING_ID;
 
 	if (!(bp->flags & BNXT_FLAG_AGG_RINGS))
 		return 0;
 
-	type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
-		RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
-
-	bnxt_init_rxbd_pages(ring, type);
-
 	prod = rxr->rx_agg_prod;
 	for (i = 0; i < bp->rx_agg_ring_size; i++) {
-		if (bnxt_alloc_rx_page(bp, rxr, prod, GFP_KERNEL) != 0) {
+		if (bnxt_alloc_rx_page(bp, rxr, prod, GFP_KERNEL)) {
 			netdev_warn(dev, "init'ed rx ring %d with %d/%d pages only\n",
 				    ring_nr, i, bp->rx_ring_size);
 			break;
@@ -3219,30 +3195,58 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 	}
 	rxr->rx_agg_prod = prod;
 
-	if (bp->flags & BNXT_FLAG_TPA) {
-		if (rxr->rx_tpa) {
-			u8 *data;
-			dma_addr_t mapping;
+	if (rxr->rx_tpa) {
+		dma_addr_t mapping;
+		u8 *data;
 
-			for (i = 0; i < bp->max_tpa; i++) {
-				data = __bnxt_alloc_rx_data(bp, &mapping,
-							    GFP_KERNEL);
-				if (!data)
-					return -ENOMEM;
+		for (i = 0; i < bp->max_tpa; i++) {
+			data = __bnxt_alloc_rx_data(bp, &mapping, GFP_KERNEL);
+			if (!data)
+				return -ENOMEM;
 
-				rxr->rx_tpa[i].data = data;
-				rxr->rx_tpa[i].data_ptr = data + bp->rx_offset;
-				rxr->rx_tpa[i].mapping = mapping;
-			}
-		} else {
-			netdev_err(bp->dev, "No resource allocated for LRO/GRO\n");
-			return -ENOMEM;
+			rxr->rx_tpa[i].data = data;
+			rxr->rx_tpa[i].data_ptr = data + bp->rx_offset;
+			rxr->rx_tpa[i].mapping = mapping;
 		}
 	}
-
 	return 0;
 }
 
+static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
+{
+	struct bnxt_rx_ring_info *rxr;
+	struct bnxt_ring_struct *ring;
+	u32 type;
+
+	type = (bp->rx_buf_use_size << RX_BD_LEN_SHIFT) |
+		RX_BD_TYPE_RX_PACKET_BD | RX_BD_FLAGS_EOP;
+
+	if (NET_IP_ALIGN == 2)
+		type |= RX_BD_FLAGS_SOP;
+
+	rxr = &bp->rx_ring[ring_nr];
+	ring = &rxr->rx_ring_struct;
+	bnxt_init_rxbd_pages(ring, type);
+
+	if (BNXT_RX_PAGE_MODE(bp) && bp->xdp_prog) {
+		bpf_prog_add(bp->xdp_prog, 1);
+		rxr->xdp_prog = bp->xdp_prog;
+	}
+	ring->fw_ring_id = INVALID_HW_RING_ID;
+
+	ring = &rxr->rx_agg_ring_struct;
+	ring->fw_ring_id = INVALID_HW_RING_ID;
+
+	if ((bp->flags & BNXT_FLAG_AGG_RINGS)) {
+		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
+			RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
+
+		bnxt_init_rxbd_pages(ring, type);
+	}
+
+	return bnxt_alloc_one_rx_ring(bp, ring_nr);
+}
+
 static void bnxt_init_cp_rings(struct bnxt *bp)
 {
 	int i, j;
-- 
2.18.1


--0000000000002112a105b0dd4d25
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgIaxIc4thqTTp
K8G/aqRRd9ZQ+Ipl2BgJ5MKllNCUtOMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDA0MTkyMzMxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKJjy1ehwiTtzBPuAPEIv59AvvDvuaQg
BJroJ1mI2xESwr+ycHWv7RVLWMPdIiiitk42I4fyH/U2GoHLuTGIh6GJn9Ta+keJGiHm/NdmlFpX
iZamQxuICkFY/LGSCq7n2SbFzs5qbfwfvy1Sq8AlJWyAKm4LKUwikg6WBKNylM6VTNij9/WU+4gh
7Pr0qlcb2iL2S7GkIiq2DlHF81GlsCvF5USMcLqtCqDqGN1OldysvEPv33nWT/6Vs2jSPiTh4NsR
e9lvWnPNASm2GHwww3SPOlPVtUweE8iGC/FuGng+Suey604Y/YmJ9vItpeUXGCMOF+qHpxlo6aoL
jvcojHI=
--0000000000002112a105b0dd4d25--
