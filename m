Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C78082488
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfHESCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:02:24 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:56220 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728867AbfHESBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:01:35 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DEDE5C0A69;
        Mon,  5 Aug 2019 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565028094; bh=0tXrBzavpJ30SObdk4JISSwIOZOnt+7gyCH6maN+jEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Hy+1gQdwRmP7AR2ROWw0ejrFMfuJcyoPf4BM04d5yXH6Nk0knMnSBXT8VZLv7nWyh
         BidllMaJRqbAZl2VUg0/gCgOxqbXM+nN7GTkisGDDKzO1u1/kVmyejHDYA8tnSNJ7Q
         FeNkoanAupcAYvjkKqZ79f6LRr7w94kFGhdXEljwUdU6uIGNS5rnZliViW+LVWQKlb
         bjFx9kXCMjFiD+R+ZirhZzkKkzxh3PESa9/PA3BOt0iyKvhBGaMQ4M2LIpzU/YeY9r
         KkKptMbvT8Q4zZ/g6p0P8wp2qumSGPQbdUyS7Hvcfn3mmMghn/+wHQbyXs81JUIFRK
         8NjXnv/hSSSZg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 971A5A0067;
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
Subject: [PATCH net-next 03/10] net: stmmac: Fix issues when number of Queues >= 4
Date:   Mon,  5 Aug 2019 20:01:16 +0200
Message-Id: <5e95bb1761f9438361f198d744640685a34790ea.1565027782.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565027782.git.joabreu@synopsys.com>
References: <cover.1565027782.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565027782.git.joabreu@synopsys.com>
References: <cover.1565027782.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When queues >= 4 we use different registers but we were not subtracting
the offset of 4. Fix this.

Found out by Coverity.

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
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c   | 4 ++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 01c2e2d83e76..fc9954e4a772 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -85,6 +85,8 @@ static void dwmac4_rx_queue_priority(struct mac_device_info *hw,
 	u32 value;
 
 	base_register = (queue < 4) ? GMAC_RXQ_CTRL2 : GMAC_RXQ_CTRL3;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + base_register);
 
@@ -102,6 +104,8 @@ static void dwmac4_tx_queue_priority(struct mac_device_info *hw,
 	u32 value;
 
 	base_register = (queue < 4) ? GMAC_TXQ_PRTY_MAP0 : GMAC_TXQ_PRTY_MAP1;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + base_register);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 03a6a59650ca..85c68b7ee8c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -108,6 +108,8 @@ static void dwxgmac2_rx_queue_prio(struct mac_device_info *hw, u32 prio,
 	u32 value, reg;
 
 	reg = (queue < 4) ? XGMAC_RXQ_CTRL2 : XGMAC_RXQ_CTRL3;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + reg);
 	value &= ~XGMAC_PSRQ(queue);
@@ -171,6 +173,8 @@ static void dwxgmac2_map_mtl_to_dma(struct mac_device_info *hw, u32 queue,
 	u32 value, reg;
 
 	reg = (queue < 4) ? XGMAC_MTL_RXQ_DMA_MAP0 : XGMAC_MTL_RXQ_DMA_MAP1;
+	if (queue >= 4)
+		queue -= 4;
 
 	value = readl(ioaddr + reg);
 	value &= ~XGMAC_QxMDMACH(queue);
-- 
2.7.4

