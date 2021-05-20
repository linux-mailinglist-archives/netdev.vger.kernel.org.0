Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660C238A03F
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 10:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhETIxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 04:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbhETIxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 04:53:51 -0400
X-Greylist: delayed 540 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 May 2021 01:52:30 PDT
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [IPv6:2001:67c:2050:1::465:107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE2CC061574
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 01:52:30 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4Fm3DG6p0CzQjhb;
        Thu, 20 May 2021 10:43:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id 8Nxzs3qch9o5; Thu, 20 May 2021 10:43:21 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Reto Schneider <code@reto-schneider.ch>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: Fix DIM support for MT7628/88
Date:   Thu, 20 May 2021 10:43:18 +0200
Message-Id: <20210520084319.1358911-1-sr@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.66 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9986F17E8
X-Rspamd-UID: 4232cf
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When updating to latest mainline for some testing on the GARDENA smart
gateway based on the MT7628, I noticed that ethernet does not work any
more. Commit e9229ffd550b ("net: ethernet: mtk_eth_soc: implement
dynamic interrupt moderation") introduced this problem, as it missed the
RX_DIM & TX_DIM configuration for this SoC variant. This patch fixes
this by calling mtk_dim_rx() & mtk_dim_tx() in this case as well.

Signed-off-by: Stefan Roese <sr@denx.de>
Fixes: e9229ffd550b ("net: ethernet: mtk_eth_soc: implement dynamic interrupt moderation")
Cc: Felix Fietkau <nbd@nbd.name>
Cc: John Crispin <john@phrozen.org>
Cc: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Reto Schneider <code@reto-schneider.ch>
Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ed4eacef17ce..d6cc06ee0caa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2423,7 +2423,8 @@ static void mtk_dim_rx(struct work_struct *work)
 	val |= cur << MTK_PDMA_DELAY_RX_PINT_SHIFT;
 
 	mtk_w32(eth, val, MTK_PDMA_DELAY_INT);
-	mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
 
 	spin_unlock_bh(&eth->dim_lock);
 
@@ -2452,7 +2453,8 @@ static void mtk_dim_tx(struct work_struct *work)
 	val |= cur << MTK_PDMA_DELAY_TX_PINT_SHIFT;
 
 	mtk_w32(eth, val, MTK_PDMA_DELAY_INT);
-	mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
 
 	spin_unlock_bh(&eth->dim_lock);
 
@@ -2480,6 +2482,10 @@ static int mtk_hw_init(struct mtk_eth *eth)
 			goto err_disable_pm;
 		}
 
+		/* set interrupt delays based on current Net DIM sample */
+		mtk_dim_rx(&eth->rx_dim.work);
+		mtk_dim_tx(&eth->tx_dim.work);
+
 		/* disable delay and normal interrupt */
 		mtk_tx_irq_disable(eth, ~0);
 		mtk_rx_irq_disable(eth, ~0);
-- 
2.31.1

