Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8624F368C7C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbhDWFWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240451AbhDWFV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:21:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A1CC06138D;
        Thu, 22 Apr 2021 22:21:22 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id y32so34429111pga.11;
        Thu, 22 Apr 2021 22:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VddRnX0bE97CmvaALzam+ApYpCJ5QzcFqH5F34H/Njg=;
        b=joV3J9h1Tn+aV8SS5MNFC/VGzBuKjiBRrMggkam1ZnBX6VW1YfhMIYGe9j6VsyClqk
         3kGCcITNUb2WQxv8k0UzIv7s+r70pZ0MQ/nNpHF0ivP2NA15IsKmx7vrkbAxDB84yAL9
         sEiYi55+jLK1NbaL7LHlqUHOEP3j5lHJ03hRDcLF6X3qhBhaOu0wFzYmFl0DRzCOgwvr
         LcWgzDf0pVeU0m2iltwEEsWtshqZ0NEmCQ46wflAazkL6l2xjJFUgbhbu/m5X3nB/FOj
         x00rhsyeMQzmjMI5lxarCgHUcPrZNSTUEg7ORrIIaZb7gesP8kbUtYxNuo3bnNP52b8b
         r2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VddRnX0bE97CmvaALzam+ApYpCJ5QzcFqH5F34H/Njg=;
        b=jXdmtFafSCLSWij/fzTGnfspHnTZRePpTnIJloPzgzkQY5Nt68mcHxIJwzJtCK1pip
         8dKNJiL/8Xqzmggh0yg4IbEVcLh9vYdnocHXttKtsrciqL5aOjYIhx4VxebXGAvd07Aa
         7hlWR7mlM5uW9YuQcF4L2fij9+F9P0WMVnBm9ebHDwsrxmY0cxnBkxKwZKtQKVJ7Ev9R
         JZUP/LzecCJSjP0qvw+kspe9o0U5GC64Jruhf6CM9UNNRLjGkoX4HuawYzbqYb8hPH8P
         iAFsoC8TEMTVXFI8eP7WEdhnO5tU8Th2c1pS05fUU8eu6Hji1xgutECKF8Z3LMhs/e8E
         nZUw==
X-Gm-Message-State: AOAM532pISu5w+l7jj7TwGYheyHPgxT2q2UjNjkHfknfo054hoLTiUnN
        ciUDra33mQjsWS0R51UV40Q=
X-Google-Smtp-Source: ABdhPJzvwQj5389BqDSDkiHBaH24ca03aWG0rJvfV0xgiI9wYJxOtUVDhmwwNFLi+bcqrW0T8d0Pxg==
X-Received: by 2002:a63:344:: with SMTP id 65mr2186120pgd.24.1619155281653;
        Thu, 22 Apr 2021 22:21:21 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:21 -0700 (PDT)
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
Subject: [PATCH net-next v2 04/15] net: ethernet: mtk_eth_soc: use napi_consume_skb
Date:   Thu, 22 Apr 2021 22:20:57 -0700
Message-Id: <20210423052108.423853-5-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
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

