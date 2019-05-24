Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F37D292DE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389780AbfEXIVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:21:21 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:35544 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389482AbfEXIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F1A97C00EC;
        Fri, 24 May 2019 08:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686046; bh=Kxoo3tFeh+IndKAXkRAf1eA/zYGpX0Qwa1o1ZxyUtTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=QlmtG9c0MTaldq2my9ir94mpGfxSHUFzXsauGy7JcM5QbWAePT9eXNATiZ/utuOy6
         cOzGYAZy+TigHtrF/AdTOy3THmKkHdFRSzpgVfsmMJCsrrGWri8f8m6fmh5E3U7Oo+
         KCJIkLpmigNWsj6E0VBioSkkSzxStHW7Hsvc6GExqP+qdmTQA1OunMMRs8CiUtVYJ/
         iObbkyam/45Cc5X5WsmtDSvtnNGjZO1csGQTum8BBNHTwuv506+5Rz8JeJe6T1624o
         OWXrsrXB+3iRVeHvwBi4YWu2jGQGMx5Z2F9RL8RGVcC8RG1ssMsO6roZTgqPUeAaam
         n+R9673OgaNhw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1D641A024B;
        Fri, 24 May 2019 08:20:38 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 867DD3FB22;
        Fri, 24 May 2019 10:20:36 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 16/18] net: stmmac: dwxgmac2: Do not disable whole RX in dma_stop_rx()
Date:   Fri, 24 May 2019 10:20:24 +0200
Message-Id: <fbb9b4e2df0913d42410f0eda29dd3b8d83b05d6.1558685828.git.joabreu@synopsys.com>
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

