Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6739BEAE16
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfJaLBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:01:04 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59388 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727312AbfJaLBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:01:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9D386C08B1;
        Thu, 31 Oct 2019 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572519662; bh=sqeaRb0tZGvD7E7A9/5JfuhQALlctRTMEjpejmhQcb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=aaUZO+VnhHutUUq/GPNueRdv8+q72ktCVq837Xz4XZwQu/FovuO/IlqaB5B6noqC5
         J7DTe7FDSjeoL7kn39mKuZqe9XOJgCd7ir0SfpfqiruXAThAI2Tztu9rtEycAzlJ6y
         qCbqWUU/KHGUWqMyYBq6zLJiJSvaUYaaLxFz7T8IPKZm3C/TWMkli2roQYXISIPbnh
         VJoocTSZXkAN0IOGyOMR41pt+9Nh/D2/YlcrJVQHse3y6s8qTPoAImPIPoIP+fm6WN
         9yTmBQkbeg1zZuROaTKyc3iPxaJ5BN/2ost4yB/n9KOU4pFkfKdbrOO2HCfLJCrpmd
         IPNcAbKTJDzQQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 56BB7A007B;
        Thu, 31 Oct 2019 11:01:00 +0000 (UTC)
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
Subject: [PATCH net v2 07/10] net: stmmac: xgmac: Fix AV Feature detection
Date:   Thu, 31 Oct 2019 12:00:45 +0100
Message-Id: <2a714b856ee9baad8e5f3ae2eb03c6d7204c6f18.1572519070.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix incorrect precedence of operators. For reference: AV implies AV
Feature but RAV implies only RX side AV Feature. As we want full AV
features we need to check RAV.

Fixes: c2b69474d63b ("net: stmmac: xgmac: Correct RAVSEL field interpretation")
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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 7cc331996cd8..7bd1447f9f47 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -372,7 +372,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->eee = (hw_cap & XGMAC_HWFEAT_EEESEL) >> 13;
 	dma_cap->atime_stamp = (hw_cap & XGMAC_HWFEAT_TSSEL) >> 12;
 	dma_cap->av = (hw_cap & XGMAC_HWFEAT_AVSEL) >> 11;
-	dma_cap->av &= !(hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10;
+	dma_cap->av &= !((hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10);
 	dma_cap->arpoffsel = (hw_cap & XGMAC_HWFEAT_ARPOFFSEL) >> 9;
 	dma_cap->rmon = (hw_cap & XGMAC_HWFEAT_MMCSEL) >> 8;
 	dma_cap->pmt_magic_frame = (hw_cap & XGMAC_HWFEAT_MGKSEL) >> 7;
-- 
2.7.4

