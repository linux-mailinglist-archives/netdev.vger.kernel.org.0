Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A086367857
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhDVEKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbhDVEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77881C06174A;
        Wed, 21 Apr 2021 21:09:47 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a12so30780617pfc.7;
        Wed, 21 Apr 2021 21:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4KIdtN06FgF/t+etJxyiKFbFDdfz1IAmwoqjnTRUY1Q=;
        b=ekE6yKJ21GS2BTKeAlc+gBcCC1y9VzR7QBm1Rwve24KFcJ+0jNVnyEwmOwJl0lc/ho
         HyceoJIh+MUMTQjmMu4LScm0ubkQ0jjL01eKuoW4G65UuUYJ1l8W/0POGR2Deva/KspM
         G3jSY2RBu6FnW+ZPTIBOWgWnL7o7oHdYT5xTeTDJfQXG0rvU9U+Idr4pObH7IGrVtfe8
         7Dv9p0Z0i2BNeI382eLt+dvGT49vhsadMXHj7k4uzcHgaLigpt65RnT7/x/sucLZaoRD
         hlWse+uINeiHf2fiDhFmH0kqG+jmLHxbt57wz1a+kX923t/lX3ZHkr106Egkia+d9Wrj
         Du0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4KIdtN06FgF/t+etJxyiKFbFDdfz1IAmwoqjnTRUY1Q=;
        b=VuXGE0OF63DgvxWSEH2Cfgc6DGKMpuObiQ5keXbJQP5nM9nPxYmQom89hP5H2LQ6tN
         EscH+wtVqEOJcJ8Tk++T7fM59qt0HTl0yAD9OhfsMDp2hukx//DTBMRcfwVyUUOHsyZH
         EHG+6ao99K4A3VI1jmGRYEQXGMIP3V+ERpciPqx5mJMI5H41DhIWYK8Q3oG2BXp1ERKD
         SpMtd0zi32kaXyk7BbJrRzLRtntlXyUg5wq75/j3szKRQ3rSNRMXu7VcXGSz4jAYZzWv
         Z5OLLQY6r5QglA3O4xcNxZzc5zTOexNOsfGY7t+a3LXkwyiDwpzpmtRaESCsiZJ6zm/R
         b70A==
X-Gm-Message-State: AOAM5314XO9NRz0Smv1TAI0UeuTpmUZlqe6xMIj5qShurOhPYlwntjjC
        q5BQBZKYA76DER4UaBpN0T8=
X-Google-Smtp-Source: ABdhPJxj4FOHEJL6eLG9j3s9bhz2cI5WstGPCENCBwwWnpKmfpEhlE8pRtJ7/rs9B268HliKtl5R2w==
X-Received: by 2002:a63:4f21:: with SMTP id d33mr1525579pgb.434.1619064587028;
        Wed, 21 Apr 2021 21:09:47 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:46 -0700 (PDT)
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
Subject: [PATCH net-next 11/14] net: ethernet: mtk_eth_soc: only read the full RX descriptor if DMA is done
Date:   Wed, 21 Apr 2021 21:09:11 -0700
Message-Id: <20210422040914.47788-12-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Uncached memory access is expensive, and there is no need to access all
descriptor words if we can't process them anyway

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 01ad10c76d53..5a531bb83348 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -775,13 +775,18 @@ static inline int mtk_max_buf_size(int frag_size)
 	return buf_size;
 }
 
-static inline void mtk_rx_get_desc(struct mtk_rx_dma *rxd,
+static inline bool mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 				   struct mtk_rx_dma *dma_rxd)
 {
-	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd2 = READ_ONCE(dma_rxd->rxd2);
+	if (!(rxd->rxd2 & RX_DMA_DONE))
+		return false;
+
+	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd3 = READ_ONCE(dma_rxd->rxd3);
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
+
+	return true;
 }
 
 /* the qdma core needs scratch memory to be setup */
@@ -1253,8 +1258,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		rxd = &ring->dma[idx];
 		data = ring->data[idx];
 
-		mtk_rx_get_desc(&trxd, rxd);
-		if (!(trxd.rxd2 & RX_DMA_DONE))
+		if (!mtk_rx_get_desc(&trxd, rxd))
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-- 
2.31.1

