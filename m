Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C67F3507D0
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbhCaUJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhCaUJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:17 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64F3C061574;
        Wed, 31 Mar 2021 13:09:16 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r12so31929771ejr.5;
        Wed, 31 Mar 2021 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6BtFP60GJ3rBYTRbobD3G+mjNuY8Ark7ywqMvtfDSOU=;
        b=P9ZBZDeIxAyz+PzOcLZuJWz7MmmgwwYlr0YUepH5OLhjinQaqCRq7vnJPEf4CcnDVH
         0TZxodwv3gfzmgIwMdfuqzY7NbcGXF3dj0OHpRBDMb+x5TsMsO2Rs+3qJxSq83+Lx5op
         ewAM5ATIpb4C+5unpvJbgPT3mAjkBJFHv0hV1w0jReaRWtVAASh5g5SNqbM4XCZHMhhC
         /cscMW935xUVM5t9rXwOtyEyNAEyeeSvl0+cGOu9DEbHeoflphtzGdAhd61X8bVjrdeg
         PezZLxz8UaNZnz/cPdl75Jhx8m+0MyPkG1ZdCPhEt2jEBdEGp3C9UmbEdhRCk7gMdu8G
         1mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6BtFP60GJ3rBYTRbobD3G+mjNuY8Ark7ywqMvtfDSOU=;
        b=MVtSOdLRcxTPUQKFonxhKavdnWX1WKxJIupiBtKHP7/ObgCivS2fwCyaEZGw8ZUoxB
         ryFO4/992PAUi5+tmfLMzgGYC7ADT1Fj0Z3BrX6UFu3Lg+okrKlUQqbhaR/yp6JXbmSa
         GhjCQKYK5rmRwfrV+p/qGsniU/vgOAU8pYcijsAO1p90K7oULIf6oBsxEemOHMZv7X/7
         psG9zfTlP8iRDMHEo+82FEPwyP9qMVRleSqMDKaLxuW+eb5eMb5F0pc06NIGa/dq5RxY
         rRfu8BVppNQ7TEL4UHzN2sjTcr+neyR059sZf3uIq3H05bG89L3tr+dOE0VFApG3mE7H
         acOw==
X-Gm-Message-State: AOAM533vRWwZjlek/9IStUrHWL3NdZA6okZPJtrG98rXYG3L9GiJU9AP
        p6Iq6RLcUwnaA9n53cydEiE=
X-Google-Smtp-Source: ABdhPJyYoF8LPo571KICu6JTEsa4k0rFRfMyf5OhQiEU0ipa7QqT4EqiNE6h6pQdLWczlt35C1H5pA==
X-Received: by 2002:a17:907:7745:: with SMTP id kx5mr5431657ejc.3.1617221355702;
        Wed, 31 Mar 2021 13:09:15 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/9] net: enetc: move skb creation into enetc_build_skb
Date:   Wed, 31 Mar 2021 23:08:50 +0300
Message-Id: <20210331200857.3274425-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We need to build an skb from two code paths now: from the plain RX data
path and from the XDP data path when the verdict is XDP_PASS.

Create a new enetc_build_skb function which contains the essential steps
for building an skb based on the first and last positions of buffer
descriptors within the RX ring.

We also squash the enetc_process_skb function into enetc_build_skb,
because what that function did wasn't very meaningful on its own.

The "rx_frm_cnt++" instruction has been moved around napi_gro_receive
for cosmetic reasons, to be in the same spot as rx_byte_cnt++, which
itself must be before napi_gro_receive, because that's when we lose
ownership of the skb.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 81 +++++++++++---------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 362cfba7ce14..b2071b8dc316 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -513,13 +513,6 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 #endif
 }
 
-static void enetc_process_skb(struct enetc_bdr *rx_ring,
-			      struct sk_buff *skb)
-{
-	skb_record_rx_queue(skb, rx_ring->index);
-	skb->protocol = eth_type_trans(skb, rx_ring->ndev);
-}
-
 static bool enetc_page_reusable(struct page *page)
 {
 	return (!page_is_pfmemalloc(page) && page_ref_count(page) == 1);
@@ -627,6 +620,47 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 	return true;
 }
 
+static struct sk_buff *enetc_build_skb(struct enetc_bdr *rx_ring,
+				       u32 bd_status, union enetc_rx_bd **rxbd,
+				       int *i, int *cleaned_cnt)
+{
+	struct sk_buff *skb;
+	u16 size;
+
+	size = le16_to_cpu((*rxbd)->r.buf_len);
+	skb = enetc_map_rx_buff_to_skb(rx_ring, *i, size);
+	if (!skb)
+		return NULL;
+
+	enetc_get_offloads(rx_ring, *rxbd, skb);
+
+	(*cleaned_cnt)++;
+
+	enetc_rxbd_next(rx_ring, rxbd, i);
+
+	/* not last BD in frame? */
+	while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
+		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
+		size = ENETC_RXB_DMA_SIZE;
+
+		if (bd_status & ENETC_RXBD_LSTATUS_F) {
+			dma_rmb();
+			size = le16_to_cpu((*rxbd)->r.buf_len);
+		}
+
+		enetc_add_rx_buff_to_skb(rx_ring, *i, size, skb);
+
+		(*cleaned_cnt)++;
+
+		enetc_rxbd_next(rx_ring, rxbd, i);
+	}
+
+	skb_record_rx_queue(skb, rx_ring->index);
+	skb->protocol = eth_type_trans(skb, rx_ring->ndev);
+
+	return skb;
+}
+
 #define ENETC_RXBD_BUNDLE 16 /* # of BDs to update at once */
 
 static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
@@ -643,7 +677,6 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		union enetc_rx_bd *rxbd;
 		struct sk_buff *skb;
 		u32 bd_status;
-		u16 size;
 
 		if (cleaned_cnt >= ENETC_RXBD_BUNDLE)
 			cleaned_cnt -= enetc_refill_rx_ring(rx_ring,
@@ -661,41 +694,15 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 						      &rxbd, &i))
 			break;
 
-		size = le16_to_cpu(rxbd->r.buf_len);
-		skb = enetc_map_rx_buff_to_skb(rx_ring, i, size);
+		skb = enetc_build_skb(rx_ring, bd_status, &rxbd, &i,
+				      &cleaned_cnt);
 		if (!skb)
 			break;
 
-		enetc_get_offloads(rx_ring, rxbd, skb);
-
-		cleaned_cnt++;
-
-		enetc_rxbd_next(rx_ring, &rxbd, &i);
-
-		/* not last BD in frame? */
-		while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
-			bd_status = le32_to_cpu(rxbd->r.lstatus);
-			size = ENETC_RXB_DMA_SIZE;
-
-			if (bd_status & ENETC_RXBD_LSTATUS_F) {
-				dma_rmb();
-				size = le16_to_cpu(rxbd->r.buf_len);
-			}
-
-			enetc_add_rx_buff_to_skb(rx_ring, i, size, skb);
-
-			cleaned_cnt++;
-
-			enetc_rxbd_next(rx_ring, &rxbd, &i);
-		}
-
 		rx_byte_cnt += skb->len;
-
-		enetc_process_skb(rx_ring, skb);
+		rx_frm_cnt++;
 
 		napi_gro_receive(napi, skb);
-
-		rx_frm_cnt++;
 	}
 
 	rx_ring->next_to_clean = i;
-- 
2.25.1

