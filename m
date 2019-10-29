Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA6E8A81
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389116AbfJ2OPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:15:17 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:53308 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389039AbfJ2OPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:15:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 848F2C0C41;
        Tue, 29 Oct 2019 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572358517; bh=ntn5h+EtiIr26cxuzm1ZrBPes0SSBYvLTZygjleUGzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gCIsjn8Ku5XeJLlLhtD2SPNIXN5ekmpgV5MLXScQWNw5wDoAXrpYULQWFFBbwztSU
         Ix8E+4shQdeqEqR4uFMH0I0kKW5YbVUBIHIdPhU+/dB0+liDtGQWoh2jiJ5TdofOH7
         pb0oJYWpmPS0smMcuShMfyrU1Y6/McdwmCwpqgXHtxBlqA7k0nuhJSDvLw1csBHZ4T
         +S1Ij/+5nE34GhEzuHZXvUetVDWTx/2SqQSIhpQtQJKFPteZsR0ydZmsJ28Y0yushQ
         yVVso3+RzmXVKzzVOFaVYdA5BQ/d/3Xq4DVONg0kQ1FToMu1rXAM4cvnGXeu4xfSv9
         I04ctY+eZfdgw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 29016A0081;
        Tue, 29 Oct 2019 14:15:15 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 9/9] net: stmmac: xgmac: Disable MMC interrupts by default
Date:   Tue, 29 Oct 2019 15:14:53 +0100
Message-Id: <4c77b55e43cf7a3243086a465b50568eb352d534.1572355609.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MMC interrupts were being enabled, which is not what we want because it
will lead to a storm of interrupts that are not handled at all. Fix it
by disabling all MMC interrupts for XGMAC.

Fixes: b6cdf09f51c2 ("net: stmmac: xgmac: Implement MMC counters")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
index a223584f5f9a..252cf48c5816 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
@@ -176,6 +176,7 @@
 #define MMC_XGMAC_RX_PKT_SMD_ERR	0x22c
 #define MMC_XGMAC_RX_PKT_ASSEMBLY_OK	0x230
 #define MMC_XGMAC_RX_FPE_FRAG		0x234
+#define MMC_XGMAC_RX_IPC_INTR_MASK	0x25c
 
 static void dwmac_mmc_ctrl(void __iomem *mmcaddr, unsigned int mode)
 {
@@ -333,8 +334,9 @@ static void dwxgmac_mmc_ctrl(void __iomem *mmcaddr, unsigned int mode)
 
 static void dwxgmac_mmc_intr_all_mask(void __iomem *mmcaddr)
 {
-	writel(MMC_DEFAULT_MASK, mmcaddr + MMC_RX_INTR_MASK);
-	writel(MMC_DEFAULT_MASK, mmcaddr + MMC_TX_INTR_MASK);
+	writel(0x0, mmcaddr + MMC_RX_INTR_MASK);
+	writel(0x0, mmcaddr + MMC_TX_INTR_MASK);
+	writel(MMC_DEFAULT_MASK, mmcaddr + MMC_XGMAC_RX_IPC_INTR_MASK);
 }
 
 static void dwxgmac_read_mmc_reg(void __iomem *addr, u32 reg, u32 *dest)
-- 
2.7.4

