Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF23B292E1
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389730AbfEXIVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:21:19 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35536 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389470AbfEXIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CD76EC012B;
        Fri, 24 May 2019 08:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686045; bh=1Sh0bKGT6b18qK4QkPQ3P4ICh3+XvSkcsAAj1xWpVDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ZwkyMgBw7N4fJpGThjz+nV7B+E4mEf5qdGeZATA/VKb6NP7ptHIpVusW7w5p3CvY1
         c0kR0aGjbBGtQk6tNHDvcDxYK3wyqav7JzropH6kQedHjCM8eaxkxfBbm9TMqex485
         2j/g1omfKhzXmJMpEwkLTP/8TmzA9vF256I9m49so8JP8vRv7q8MCv62pjYWXhJ2un
         BjCAtK4i76Pesc1UGQ6wvuDtppyZ6mmfGtJMsy90SPK8zmVQLTTo8uadY02Iyru0SE
         buTjOzPPNjpg6odvsqBKDdJuqCrjd/NGwnkfKQ19SdDwPQG3j65xLPXBb6obPZiQ2/
         0Cyz2MZesMHFA==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1D61BA0247;
        Fri, 24 May 2019 08:20:38 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 769C23FB1F;
        Fri, 24 May 2019 10:20:36 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 15/18] net: stmmac: dwmac4/5: Do not disable whole RX in dma_stop_rx()
Date:   Fri, 24 May 2019 10:20:23 +0200
Message-Id: <b8bff7cc2f7824dcec27e6d6e484dfdc0335438f.1558685828.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to disable the whole RX when dma_stop_rx() is called
because there may be the need of just disabling 1 DMA channel.

This is also needed for stmmac Flow Control selftest.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 545cb9c47433..99f8a391964c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -88,10 +88,6 @@ void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 
 	value &= ~DMA_CONTROL_SR;
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
-
-	value = readl(ioaddr + GMAC_CONFIG);
-	value &= ~GMAC_CONFIG_RE;
-	writel(value, ioaddr + GMAC_CONFIG);
 }
 
 void dwmac4_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
-- 
2.7.4

