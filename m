Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C9F846FD
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387517AbfHGITl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:19:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48348 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727914AbfHGITl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 04:19:41 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3E98B9D8B2DA0D96AA77;
        Wed,  7 Aug 2019 16:19:39 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 7 Aug 2019 16:19:32 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
CC:     yuqi jin <jinyuqi@huawei.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH] net: stmmac: Fix the miscalculation of mapping from rxq to dma channel
Date:   Wed, 7 Aug 2019 16:17:29 +0800
Message-ID: <1565165849-16246-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yuqi jin <jinyuqi@huawei.com>

XGMAC_MTL_RXQ_DMA_MAP1 will be configured if the number of queues is
greater than 3, but local variable chan will shift left more than 32-bits.
Let's fix this issue.

Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 0a32c96a7854..de4b15f31727 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -166,13 +166,14 @@ static void dwxgmac2_map_mtl_to_dma(struct mac_device_info *hw, u32 queue,
 				    u32 chan)
 {
 	void __iomem *ioaddr = hw->pcsr;
-	u32 value, reg;
+	u32 value, reg, index;
 
 	reg = (queue < 4) ? XGMAC_MTL_RXQ_DMA_MAP0 : XGMAC_MTL_RXQ_DMA_MAP1;
+	index = (queue < 4) ? queue : queue - 4;
 
 	value = readl(ioaddr + reg);
-	value &= ~XGMAC_QxMDMACH(queue);
-	value |= (chan << XGMAC_QxMDMACH_SHIFT(queue)) & XGMAC_QxMDMACH(queue);
+	value &= ~XGMAC_QxMDMACH(index);
+	value |= (chan << XGMAC_QxMDMACH_SHIFT(index)) & XGMAC_QxMDMACH(index);
 
 	writel(value, ioaddr + reg);
 }
-- 
2.7.4

