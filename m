Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F7DE8A73
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389177AbfJ2OPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:15:18 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:53332 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388988AbfJ2OPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:15:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7D27FC0C3F;
        Tue, 29 Oct 2019 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572358517; bh=sqeaRb0tZGvD7E7A9/5JfuhQALlctRTMEjpejmhQcb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=O06JVMIhjb9OPQoasP74FxSvDbiGET/AOIwdvqbMYpsBMFoYkUckqKoaourMQgstj
         RGBakA9pyn+7W8RSDtxYh/8Wp3ETSIsDMJUd8jCtjRg+9Ui4iqu6Tl3Y/x7DwQMU/M
         31cJncjuEtU9QHm84XEYJ8fmkx2WSKmvYOgf1TPbeL0sb5HEtAyldwjwH7um78o3Dh
         DMtu0uzuGKBkQENSYZPKIYfo/upznRZVKywgjLchSQTD61kW9uVGvltiaF1Q29heow
         XAZda1SfCRbpb1045105W9pux19MqMiLmrI4ztpPhpUAFNmdlF+A1I2O77egSqyD0Y
         k6Qa5e1sDvU2g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 186C1A0079;
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
Subject: [PATCH net 7/9] net: stmmac: xgmac: Fix AV Feature detection
Date:   Tue, 29 Oct 2019 15:14:51 +0100
Message-Id: <210c64859abaa41d4bd9fb68c4df3a2c8a9cf29c.1572355609.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
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

