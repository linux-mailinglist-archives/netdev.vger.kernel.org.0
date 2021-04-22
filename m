Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6893F367850
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbhDVEKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhDVEKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C09C06174A;
        Wed, 21 Apr 2021 21:09:41 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id e2so18529065plh.8;
        Wed, 21 Apr 2021 21:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VddRnX0bE97CmvaALzam+ApYpCJ5QzcFqH5F34H/Njg=;
        b=OC1c6YzvFa23FAL/pDrjpfiIHhd4LbVftEgeZu10htyxa3D2HLXIcV/IK2zjfuGkQ0
         p7qs0zFMFgEH4GD0lO21HSL3aNG716uIKTiBehI4t0T3kRMzZ9FTC8ARTTtdjmdkLEly
         kcTsgYbQR/nl7odAWxFVm0X2+KgrzZST/HsxFxJMIVJwXyAU9EKP/Dso8FlpCPodUPiF
         xNJ0cbpnoq+XPExtBEocFtJ5bWaAMIQRiJY7bT1nV4v1ujzii/B/O0sRUbFQtugvbALs
         uzdr5n0sU2oDeSfGjqAPH1PTrldw7/7zaVuiSftGPnjUZLFl11E8LmgM+mO9kOj0LmTm
         1S0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VddRnX0bE97CmvaALzam+ApYpCJ5QzcFqH5F34H/Njg=;
        b=mCOCuSnT18TBYf9aPMREvpykSL0OzaYDpCUaZ39ln7D/XnfkQ1lKsRKAMfGJuRKbEB
         OrF/aNPi/Yv7Khg7glivYFmxntMXtG5P+JlMVp2ENfk9B8M8pZTKvZeytLI+0zGTDTjd
         A3H19H/98ZnYGPU6Mv9r2MkfK3EHH6adPqcd12XFgUPw/2qziMVfyjuXfDEd/XpzlGIL
         IHTvwMD27DvkCPVGrBol0VliLArgrabSfyPNVrYdNEieqWAztR78wfmzw3FIMrbSKyEI
         a67zU7C9d6dkeHSaUaeghihckgMjR7t7qGilpf6MvptCtdvVhoWquvgrtcrsOKRQ/GWr
         aHRg==
X-Gm-Message-State: AOAM532YC9bgjZgPRj3Du9EPIS3M1GiIIfdP7OjD9zshvUsFMcVT/wvq
        Am2q+k33fmt2vSmJ3npJPJM=
X-Google-Smtp-Source: ABdhPJxd4KNi/Xrd2gMVsnisMzoprD9mj//cMmuHvr1XiE3yzrkkSh+87wCc4+casFD6zSp4KEAxUQ==
X-Received: by 2002:a17:902:9886:b029:e6:2bc6:b74 with SMTP id s6-20020a1709029886b02900e62bc60b74mr1404270plp.13.1619064580913;
        Wed, 21 Apr 2021 21:09:40 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:40 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 04/14] net: ethernet: mtk_eth_soc: use napi_consume_skb
Date:   Wed, 21 Apr 2021 21:09:04 -0700
Message-Id: <20210422040914.47788-5-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Should improve performance, since it can use bulk free

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 07daa5de8bec..5cf64de3ddf8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -858,7 +858,8 @@ static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma)
 	return ((void *)dma - (void *)ring->dma) / sizeof(*dma);
 }
 
-static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf)
+static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
+			 bool napi)
 {
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
 		if (tx_buf->flags & MTK_TX_FLAGS_SINGLE0) {
@@ -890,8 +891,12 @@ static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf)
 
 	tx_buf->flags = 0;
 	if (tx_buf->skb &&
-	    (tx_buf->skb != (struct sk_buff *)MTK_DMA_DUMMY_DESC))
-		dev_kfree_skb_any(tx_buf->skb);
+	    (tx_buf->skb != (struct sk_buff *)MTK_DMA_DUMMY_DESC)) {
+		if (napi)
+			napi_consume_skb(tx_buf->skb, napi);
+		else
+			dev_kfree_skb_any(tx_buf->skb);
+	}
 	tx_buf->skb = NULL;
 }
 
@@ -1069,7 +1074,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		tx_buf = mtk_desc_to_tx_buf(ring, itxd);
 
 		/* unmap dma */
-		mtk_tx_unmap(eth, tx_buf);
+		mtk_tx_unmap(eth, tx_buf, false);
 
 		itxd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
@@ -1388,7 +1393,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 			done[mac]++;
 			budget--;
 		}
-		mtk_tx_unmap(eth, tx_buf);
+		mtk_tx_unmap(eth, tx_buf, true);
 
 		ring->last_free = desc;
 		atomic_inc(&ring->free_count);
@@ -1425,7 +1430,7 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 			budget--;
 		}
 
-		mtk_tx_unmap(eth, tx_buf);
+		mtk_tx_unmap(eth, tx_buf, true);
 
 		desc = &ring->dma[cpu];
 		ring->last_free = desc;
@@ -1627,7 +1632,7 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 
 	if (ring->buf) {
 		for (i = 0; i < MTK_DMA_SIZE; i++)
-			mtk_tx_unmap(eth, &ring->buf[i]);
+			mtk_tx_unmap(eth, &ring->buf[i], false);
 		kfree(ring->buf);
 		ring->buf = NULL;
 	}
-- 
2.31.1

