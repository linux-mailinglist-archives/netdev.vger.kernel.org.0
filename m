Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C10368C8A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbhDWFW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240602AbhDWFWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:05 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF37FC06138D;
        Thu, 22 Apr 2021 22:21:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o16so11066563plg.5;
        Thu, 22 Apr 2021 22:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cVCvFP7FkhaoSFqQuRF6Qi4Ni9yogvujik129mGGQRY=;
        b=b8DQMctCJXEHiD048Y5scEAzRTZ7QYvWF0SxauygF7xjyqpaGVHJSji2oR+CngdSj/
         vvS7D2kVSZtdUKViEdS0uSACqA5QM0IpxROAN41YOz8O9yNm4+RSTCa2GYpdTTZnGvA/
         NrCPPzaCIkTwUEL+ftiCUwGmNEvco9FLYkjBz7WLg19cJk/cENK55WipKFnstSh1vyhm
         ldz7VUzgN1E782MgEVp44U7FVEY7gY2anAgw5F0BC7BUwMmHOuXyAkA3zUC0HUa58uxH
         MQo0nC9HZTuh+PjehkK4X4hHwiVBoTDa3ADj/945jPJatpfXrlT72yao2WwYMjrZRHn4
         OeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cVCvFP7FkhaoSFqQuRF6Qi4Ni9yogvujik129mGGQRY=;
        b=l+qbO7OMdFVJbdkLrWgIa9nbXET2ztOtCk+wawoLyr5TiDcEG8L5ZNz04xkXQ/3v3L
         TkISxKPuI31aMmLugVy9YmZsGaJtzHaTOMpGiYs1okxeFAB0Ta/zHJYHkPxDOsaK0IDo
         3Ow2MONBOQ5UVJiC9wSXfTFlVY0DrjerQyRD33G/LB6yKcsWbbelJYQhFkPDm9zHGZOo
         KZsmr618otCzbMZzmazxwSb/wMCeWBCMdhZ2jow2XYJTiKoPE/BJuKaJGfg27Tcj0YqS
         Dc2PM6DLMK5YG2dotbqfpZ+hFqUPjYN03iQ/4xrSwdT46OtPfcAEwEMApvv934StUWyC
         Zcsw==
X-Gm-Message-State: AOAM530CcQ+0s4FqKLDkxukGpQivtqcljlfzNkylCsow9msYnJ57JqKg
        zJAMgP5Jux3scNaD1Pg5Hew=
X-Google-Smtp-Source: ABdhPJzlYQGDMbvjAhTMbiHqgzZgVDWONAAlUkjdJXUrpAtnk/pfi10MLR7qP/KayIypU4kejcy7TA==
X-Received: by 2002:a17:90a:4f41:: with SMTP id w1mr3896776pjl.231.1619155289404;
        Thu, 22 Apr 2021 22:21:29 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:29 -0700 (PDT)
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
Subject: [PATCH net-next v2 13/15] net: ethernet: mtk_eth_soc: rework NAPI callbacks
Date:   Thu, 22 Apr 2021 22:21:06 -0700
Message-Id: <20210423052108.423853-14-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_complete_done to communicate total TX and RX work done to NAPI.
Count total RX work up instead of remaining work down for clarity.
Remove unneeded local variables for clarity. Use do {} while instead of
goto for clarity.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 54 +++++++++------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e1792ccaedc3..8faf8fb1c83a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1496,7 +1496,6 @@ static void mtk_handle_status_irq(struct mtk_eth *eth)
 static int mtk_napi_tx(struct napi_struct *napi, int budget)
 {
 	struct mtk_eth *eth = container_of(napi, struct mtk_eth, tx_napi);
-	u32 status, mask;
 	int tx_done = 0;
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
@@ -1505,21 +1504,19 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 	tx_done = mtk_poll_tx(eth, budget);
 
 	if (unlikely(netif_msg_intr(eth))) {
-		status = mtk_r32(eth, eth->tx_int_status_reg);
-		mask = mtk_r32(eth, eth->tx_int_mask_reg);
 		dev_info(eth->dev,
-			 "done tx %d, intr 0x%08x/0x%x\n",
-			 tx_done, status, mask);
+			 "done tx %d, intr 0x%08x/0x%x\n", tx_done,
+			 mtk_r32(eth, eth->tx_int_status_reg),
+			 mtk_r32(eth, eth->tx_int_mask_reg));
 	}
 
 	if (tx_done == budget)
 		return budget;
 
-	status = mtk_r32(eth, eth->tx_int_status_reg);
-	if (status & MTK_TX_DONE_INT)
+	if (mtk_r32(eth, eth->tx_int_status_reg) & MTK_TX_DONE_INT)
 		return budget;
 
-	if (napi_complete(napi))
+	if (napi_complete_done(napi, tx_done))
 		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
 
 	return tx_done;
@@ -1528,36 +1525,33 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 static int mtk_napi_rx(struct napi_struct *napi, int budget)
 {
 	struct mtk_eth *eth = container_of(napi, struct mtk_eth, rx_napi);
-	u32 status, mask;
-	int rx_done = 0;
-	int remain_budget = budget;
+	int rx_done_total = 0;
 
 	mtk_handle_status_irq(eth);
 
-poll_again:
-	mtk_w32(eth, MTK_RX_DONE_INT, MTK_PDMA_INT_STATUS);
-	rx_done = mtk_poll_rx(napi, remain_budget, eth);
+	do {
+		int rx_done;
 
-	if (unlikely(netif_msg_intr(eth))) {
-		status = mtk_r32(eth, MTK_PDMA_INT_STATUS);
-		mask = mtk_r32(eth, MTK_PDMA_INT_MASK);
-		dev_info(eth->dev,
-			 "done rx %d, intr 0x%08x/0x%x\n",
-			 rx_done, status, mask);
-	}
-	if (rx_done == remain_budget)
-		return budget;
+		mtk_w32(eth, MTK_RX_DONE_INT, MTK_PDMA_INT_STATUS);
+		rx_done = mtk_poll_rx(napi, budget - rx_done_total, eth);
+		rx_done_total += rx_done;
 
-	status = mtk_r32(eth, MTK_PDMA_INT_STATUS);
-	if (status & MTK_RX_DONE_INT) {
-		remain_budget -= rx_done;
-		goto poll_again;
-	}
+		if (unlikely(netif_msg_intr(eth))) {
+			dev_info(eth->dev,
+				 "done rx %d, intr 0x%08x/0x%x\n", rx_done,
+				 mtk_r32(eth, MTK_PDMA_INT_STATUS),
+				 mtk_r32(eth, MTK_PDMA_INT_MASK));
+		}
+
+		if (rx_done_total == budget)
+			return budget;
+
+	} while (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT);
 
-	if (napi_complete(napi))
+	if (napi_complete_done(napi, rx_done_total))
 		mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
 
-	return rx_done + budget - remain_budget;
+	return rx_done_total;
 }
 
 static int mtk_tx_alloc(struct mtk_eth *eth)
-- 
2.31.1

