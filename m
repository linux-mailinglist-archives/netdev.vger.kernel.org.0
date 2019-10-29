Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288D9E8A7D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbfJ2OPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:15:18 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:53318 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389090AbfJ2OPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:15:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 814CFC0C40;
        Tue, 29 Oct 2019 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572358517; bh=YDnL8bpwK/tRJL9FcP1ml8xixy+yOmNErBznAAvEsXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Rwr5V11uBs9LeQGmi99GYlUb0IqNiA6e1qolrjxyTpqCuC3Cicfk2uT/nzBGpxk8W
         +jXvIMeQWjJJdOYq4RFQodQhJ35/PeYcUY5P/9BOS7YyatD0N2V6Lx+EPQxfRW9AoB
         7lkkWZGcO7j91ONJr/NgaVMV9rnpPQMVBztHuZaCXEdRXoqLTtIuEPBphduL++PF7J
         g6ZZmBgUmtNFFRmwtz3Kl9c9J3GUXp+vO2nGt1n+6N9pQOx6DqEZc/syY4FedsHdwN
         7OELlq3edN8pp9W8Ke7U0HwvpyErLglkwj517Qes3BwCTyyqN2B3anTxr6rh2SPl71
         0gxP4YXRZiz/A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 20D86A007D;
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
Subject: [PATCH net 8/9] net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in AV
Date:   Tue, 29 Oct 2019 15:14:52 +0100
Message-Id: <238f9ff3de526e122a4f2db43a597553649c4339.1572355609.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When in AVB mode we need to disable flow control to prevent MAC from
pausing in TX side.

Fixes: ec6ea8e3eee9 ("net: stmmac: Add CBS support in XGMAC2")
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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 7bd1447f9f47..f148cb2061d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -473,6 +473,7 @@ static void dwxgmac2_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
 static void dwxgmac2_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
 {
 	u32 value = readl(ioaddr + XGMAC_MTL_TXQ_OPMODE(channel));
+	u32 flow = readl(ioaddr + XGMAC_RX_FLOW_CTRL);
 
 	value &= ~XGMAC_TXQEN;
 	if (qmode != MTL_QUEUE_AVB) {
@@ -480,6 +481,7 @@ static void dwxgmac2_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
 		writel(0, ioaddr + XGMAC_MTL_TCx_ETS_CONTROL(channel));
 	} else {
 		value |= 0x1 << XGMAC_TXQEN_SHIFT;
+		writel(flow & (~XGMAC_RFE), ioaddr + XGMAC_RX_FLOW_CTRL);
 	}
 
 	writel(value, ioaddr +  XGMAC_MTL_TXQ_OPMODE(channel));
-- 
2.7.4

