Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152FE2773D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfEWHid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:38:33 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43604 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1730184AbfEWHhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:31 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EAE30C0195;
        Thu, 23 May 2019 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597058; bh=Kxoo3tFeh+IndKAXkRAf1eA/zYGpX0Qwa1o1ZxyUtTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=FIOFYFDEiVPIKimxy6kXSwJeEnF5qSDpKxlE5u/qEc4c8B5LVLqgwm0ZtFD6F+no6
         GtztvsRCyvQAv4omQKI+jvFNzgwvHomGZGQTI8aGq2taZLASTEuM0XukfahuLXtuBo
         v4XtkxHAxvcFs+f5RQ4+9gJXbeFwroIn0o5lRlZhtxHshBAOjoiL2uA3SOY/eAyCwh
         Mh4bFkv8wr7axxBh73OEOvZXLqh6NqL1AafXzOxRUSwS5atZXkvF/qDxTjthpzpD/n
         yqnUZeS/DrFpKmmi/xyfUOdlvoiUTdQSekDESP7UXIT3BjDEE10upTduR4t+zWWpdT
         AjAq6qLfdVwsw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 797CAA00AC;
        Thu, 23 May 2019 07:37:30 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 1B0753D96A;
        Thu, 23 May 2019 09:37:29 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 16/18] net: stmmac: dwxgmac2: Do not disable whole RX in dma_stop_rx()
Date:   Thu, 23 May 2019 09:37:06 +0200
Message-Id: <4d8827e2904c0d27e08363fe2bc9b0a9cd7a544b.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index e79037f511e1..7861a938420a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -299,10 +299,6 @@ static void dwxgmac2_dma_stop_rx(void __iomem *ioaddr, u32 chan)
 	value = readl(ioaddr + XGMAC_DMA_CH_RX_CONTROL(chan));
 	value &= ~XGMAC_RXST;
 	writel(value, ioaddr + XGMAC_DMA_CH_RX_CONTROL(chan));
-
-	value = readl(ioaddr + XGMAC_RX_CONFIG);
-	value &= ~XGMAC_CONFIG_RE;
-	writel(value, ioaddr + XGMAC_RX_CONFIG);
 }
 
 static int dwxgmac2_dma_interrupt(void __iomem *ioaddr,
-- 
2.7.4

