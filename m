Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6920E8D1F9
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 13:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfHNLSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 07:18:40 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:22998 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbfHNLSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 07:18:39 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 994EFA158E;
        Wed, 14 Aug 2019 13:18:36 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id KrlS1D99ZWEq; Wed, 14 Aug 2019 13:18:27 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH net-next 2/4 v2] net: ethernet: mediatek: Rename MTK_QMTK_INT_STATUS to MTK_QDMA_INT_STATUS
Date:   Wed, 14 Aug 2019 13:18:23 +0200
Message-Id: <20190814111825.10855-2-sr@denx.de>
In-Reply-To: <20190814111825.10855-1-sr@denx.de>
References: <20190814111825.10855-1-sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently all QDMA registers are named "MTK_QDMA_foo" in this driver
with one exception: MTK_QMTK_INT_STATUS. This patch renames
MTK_QMTK_INT_STATUS to MTK_QDMA_INT_STATUS so that all macros follow
this rule.

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: René van Dorst <opensource@vdorst.com>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
---
v2:
- New patch

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 ++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ddbffeb5701b..bee2cdca66e7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1122,11 +1122,11 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 	int tx_done = 0;
 
 	mtk_handle_status_irq(eth);
-	mtk_w32(eth, MTK_TX_DONE_INT, MTK_QMTK_INT_STATUS);
+	mtk_w32(eth, MTK_TX_DONE_INT, MTK_QDMA_INT_STATUS);
 	tx_done = mtk_poll_tx(eth, budget);
 
 	if (unlikely(netif_msg_intr(eth))) {
-		status = mtk_r32(eth, MTK_QMTK_INT_STATUS);
+		status = mtk_r32(eth, MTK_QDMA_INT_STATUS);
 		mask = mtk_r32(eth, MTK_QDMA_INT_MASK);
 		dev_info(eth->dev,
 			 "done tx %d, intr 0x%08x/0x%x\n",
@@ -1136,7 +1136,7 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 	if (tx_done == budget)
 		return budget;
 
-	status = mtk_r32(eth, MTK_QMTK_INT_STATUS);
+	status = mtk_r32(eth, MTK_QDMA_INT_STATUS);
 	if (status & MTK_TX_DONE_INT)
 		return budget;
 
@@ -1747,7 +1747,7 @@ static irqreturn_t mtk_handle_irq(int irq, void *_eth)
 			mtk_handle_irq_rx(irq, _eth);
 	}
 	if (mtk_r32(eth, MTK_QDMA_INT_MASK) & MTK_TX_DONE_INT) {
-		if (mtk_r32(eth, MTK_QMTK_INT_STATUS) & MTK_TX_DONE_INT)
+		if (mtk_r32(eth, MTK_QDMA_INT_STATUS) & MTK_TX_DONE_INT)
 			mtk_handle_irq_tx(irq, _eth);
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index bab94f763e2c..088e2bc621f7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -212,7 +212,7 @@
 #define FC_THRES_MIN		0x4444
 
 /* QDMA Interrupt Status Register */
-#define MTK_QMTK_INT_STATUS	0x1A18
+#define MTK_QDMA_INT_STATUS	0x1A18
 #define MTK_RX_DONE_DLY		BIT(30)
 #define MTK_RX_DONE_INT3	BIT(19)
 #define MTK_RX_DONE_INT2	BIT(18)
-- 
2.22.1

