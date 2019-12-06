Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8516111502B
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 13:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLFMKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 07:10:44 -0500
Received: from lgeamrelo12.lge.com ([156.147.23.52]:42552 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbfLFMKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 07:10:44 -0500
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
        by 156.147.23.52 with ESMTP; 6 Dec 2019 20:40:41 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: neidhard.kim@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.32.48)
        by 156.147.1.121 with ESMTP; 6 Dec 2019 20:40:41 +0900
X-Original-SENDERIP: 10.178.32.48
X-Original-MAILFROM: neidhard.kim@lge.com
From:   Jongsung Kim <neidhard.kim@lge.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, davem@davemloft.net,
        joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, Jongsung Kim <neidhard.kim@lge.com>
Subject: [PATCH] net: stmmac: reset Tx desc base address before restarting Tx
Date:   Fri,  6 Dec 2019 20:40:00 +0900
Message-Id: <20191206114000.27283-1-neidhard.kim@lge.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refer to the databook of DesignWare Cores Ethernet MAC Universal:

6.2.1.5 Register 4 (Transmit Descriptor List Address Register

If this register is not changed when the ST bit is set to 0, then
the DMA takes the descriptor address where it was stopped earlier.

The stmmac_tx_err() does zero indices to Tx descriptors, but does
not reset HW current Tx descriptor address. To fix inconsistency,
the base address of the Tx descriptors should be rewritten before
restarting Tx.

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 644cb5d1fd4f..bbc65bd332a8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2009,6 +2009,8 @@ static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
 	tx_q->cur_tx = 0;
 	tx_q->mss = 0;
 	netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, chan));
+	stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
+			    tx_q->dma_tx_phy, chan);
 	stmmac_start_tx_dma(priv, chan);
 
 	priv->dev->stats.tx_errors++;
-- 
2.20.1

