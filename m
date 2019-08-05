Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE0B82465
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfHESBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:01:36 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:56196 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728759AbfHESBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:01:35 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DB78EC0A64;
        Mon,  5 Aug 2019 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565028094; bh=+VdnwuZAGWVKwnSobbw+sFsG8nzeWPjFkEbLTwBDpGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=QyGUFRH0bPLd50yThyeBWMu8WFrZEVI8DdG6PZeH+c+QyohIZum34T4GQzgZcgDo3
         UBWykO4w/EDJpCregUlQ2StLxdXXxa6866sufxAyXC2cH3APi4zU8ApFZEmQvteAbk
         U5uQuQYA+Jhaq+FJYwKGILOOw1I480O/5wvNygQ+WM8zej3YRyy/5LI/4tL/xHnbAt
         kSzAQSa86GcdYHpp3E36/p1+3DXmwEw2+b+hVmMF0F2tgd6j0JDpUY9waoDH/12XvH
         +d9hWLx0BDVDmg53DXcmLvEu9T76b+x6urQm84efVayooQLgItkD2FjAMOKu9yy1vM
         F8keRAMalh/NA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9EB91A006A;
        Mon,  5 Aug 2019 18:01:32 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/10] net: stmmac: xgmac: Implement set_mtl_tx_queue_weight()
Date:   Mon,  5 Aug 2019 20:01:17 +0200
Message-Id: <3954867cf30aebcc0a86e83b61da48ef32bf645e.1565027782.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565027782.git.joabreu@synopsys.com>
References: <cover.1565027782.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565027782.git.joabreu@synopsys.com>
References: <cover.1565027782.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the TX Queue Weight callback. In order for this to be active
we also need to set ETS algorithm when configuring Queue.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
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
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 85c68b7ee8c6..ce6503dfc86d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -144,7 +144,9 @@ static void dwxgmac2_prog_mtl_tx_algorithms(struct mac_device_info *hw,
 					    u32 tx_alg)
 {
 	void __iomem *ioaddr = hw->pcsr;
+	bool ets = true;
 	u32 value;
+	int i;
 
 	value = readl(ioaddr + XGMAC_MTL_OPMODE);
 	value &= ~XGMAC_ETSALG;
@@ -160,10 +162,28 @@ static void dwxgmac2_prog_mtl_tx_algorithms(struct mac_device_info *hw,
 		value |= XGMAC_DWRR;
 		break;
 	default:
+		ets = false;
 		break;
 	}
 
 	writel(value, ioaddr + XGMAC_MTL_OPMODE);
+
+	/* Set ETS if desired */
+	for (i = 0; i < MTL_MAX_TX_QUEUES; i++) {
+		value = readl(ioaddr + XGMAC_MTL_TCx_ETS_CONTROL(i));
+		value &= ~XGMAC_TSA;
+		if (ets)
+			value |= XGMAC_ETS;
+		writel(value, ioaddr + XGMAC_MTL_TCx_ETS_CONTROL(i));
+	}
+}
+
+static void dwxgmac2_set_mtl_tx_queue_weight(struct mac_device_info *hw,
+					     u32 weight, u32 queue)
+{
+	void __iomem *ioaddr = hw->pcsr;
+
+	writel(weight, ioaddr + XGMAC_MTL_TCx_QUANTUM_WEIGHT(queue));
 }
 
 static void dwxgmac2_map_mtl_to_dma(struct mac_device_info *hw, u32 queue,
@@ -412,7 +432,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.rx_queue_routing = NULL,
 	.prog_mtl_rx_algorithms = dwxgmac2_prog_mtl_rx_algorithms,
 	.prog_mtl_tx_algorithms = dwxgmac2_prog_mtl_tx_algorithms,
-	.set_mtl_tx_queue_weight = NULL,
+	.set_mtl_tx_queue_weight = dwxgmac2_set_mtl_tx_queue_weight,
 	.map_mtl_to_dma = dwxgmac2_map_mtl_to_dma,
 	.config_cbs = dwxgmac2_config_cbs,
 	.dump_regs = NULL,
-- 
2.7.4

