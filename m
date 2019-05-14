Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769A51C0FE
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfENDhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:37:40 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:60003 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726677AbfENDhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 23:37:39 -0400
X-UUID: 3e8f6e16f38e4db2badf82b5f7f493f0-20190514
X-UUID: 3e8f6e16f38e4db2badf82b5f7f493f0-20190514
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 990929432; Tue, 14 May 2019 11:37:32 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 14 May 2019 11:37:29 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 14 May 2019 11:37:29 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.comi>,
        <boon.leong.ong@intel.com>
Subject: [v3, PATCH 1/4] net: stmmac: update rx tail pointer register to fix rx dma hang issue.
Date:   Tue, 14 May 2019 11:37:23 +0800
Message-ID: <1557805046-306-2-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1557805046-306-1-git-send-email-biao.huang@mediatek.com>
References: <1557805046-306-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: E088786E60850BAFA2F416078B4746A1156CA15658EC3916A3A3E2ED30BAED4A2000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we will not update the receive descriptor tail pointer in
stmmac_rx_refill. Rx dma will think no available descriptors and stop
once received packets exceed DMA_RX_SIZE, so that the rx only test will fail.

Update the receive tail pointer in stmmac_rx_refill to add more descriptors
to the rx channel, so packets can be received continually

Fixes: 54139cf3bb33 ("net: stmmac: adding multiple buffers for rx")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 97c5e1a..906f2be 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3336,6 +3336,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		entry = STMMAC_GET_ENTRY(entry, DMA_RX_SIZE);
 	}
 	rx_q->dirty_rx = entry;
+	stmmac_set_rx_tail_ptr(priv, priv->ioaddr, rx_q->rx_tail_addr, queue);
 }
 
 /**
-- 
1.7.9.5

