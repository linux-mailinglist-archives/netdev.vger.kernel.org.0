Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEFD846AB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387633AbfHGIDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:03:31 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:33728 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728235AbfHGID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:03:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9B944C0BC7;
        Wed,  7 Aug 2019 08:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565165009; bh=A6oJ3xy+X62gQqMeT+1xG7LvX7bhvMEUhkdkX+YYtXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YgAQBglMvUPpv/YlJ3KX/Z8ticroiUojCRdEnWVkkgf3uz8dsf99Eq3615Cfk3aW5
         exi94PBNPiLiuMQwadQJPHfrK51PUz7PRZLKcyUUHOHlcjMpYpxGJrkq7yG3pQxxks
         OYLMBvPrsZ8aEKEnyv4nPu10a8kBK3tK3Q1Q4cnb1LNfuUqL1rz3/7Rp1m1UWs2/kZ
         mk3Msj/vv3icxN4KFDXYBfHqS9pcG96DAR6ozIrGX3xyjC+F4tTN0nHXJAQs5NdnrL
         BUJhpjZC/7GVgYuzFbbGRdWmwpXmGRMxwinMK7eBdjEyF+ipz4CS7oeJQdvil1MKy4
         gcMqSrxPt3b4w==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 29675A0066;
        Wed,  7 Aug 2019 08:03:26 +0000 (UTC)
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
Subject: [PATCH net-next v3 02/10] net: stmmac: xgmac: Implement set_mtl_tx_queue_weight()
Date:   Wed,  7 Aug 2019 10:03:10 +0200
Message-Id: <c5b536e9eed3e0d8caa80e845a8ce508f8ef1b8f.1565164729.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565164729.git.joabreu@synopsys.com>
References: <cover.1565164729.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565164729.git.joabreu@synopsys.com>
References: <cover.1565164729.git.joabreu@synopsys.com>
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

