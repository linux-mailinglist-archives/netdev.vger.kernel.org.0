Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B552EC1CE4
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfI3ITd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:19:33 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33682 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730042AbfI3IT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:19:28 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 53833C03A2;
        Mon, 30 Sep 2019 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569831567; bh=vw4KjFOd0WN5T5S8MRjnu1Dm0OyCo4xGHIGsN5RDZ7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=cS3H10BsAJ5AnYG5wZ1VEy+Zv6pwVLdXLYPS30+6qhRDGMZHshQhnqMZJmWZtEwnS
         Q3z5nYbsoNMZRWkOg78tyTpaye3cTXV+Wg4O7ATvmsltDkX3ZRsVKA2K5z0QrQnmk6
         3e29LNtVMEGQ325ckq2XNv+6XNh31jxGgIj+SgIvCN2WIcr90AzY9mrp2GGMUpsqF0
         wwqi6Qh0CM43aAYkXnSBwaLfMyD29oQ3jGwu3h7Zox256k0+HAFEBxDe1qX66DWrqx
         FsoUhZbVajMkhrmpbKDELOHFx/cubNG5JCsdA6FNpdZOADV9wQlAW6ytZO0ERxW4SI
         JRCWceCkZl0Aw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5CD31A0072;
        Mon, 30 Sep 2019 08:19:23 +0000 (UTC)
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
Subject: [PATCH v2 net 2/9] net: stmmac: xgmac: Detect Hash Table size dinamically
Date:   Mon, 30 Sep 2019 10:19:06 +0200
Message-Id: <765ffe12f3972556fc627526627e4fbb30ee9191.1569831229.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit b8ef7020d6e5 ("net: stmmac: add support for hash table size
128/256 in dwmac4"), we can detect the Hash Table dinamically.

Let's implement this feature in XGMAC cores and fix possible setups that
don't support the maximum size for Hash Table.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 5923ca62d793..f7eb06f8fb37 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -122,6 +122,7 @@
 #define XGMAC_HWFEAT_GMIISEL		BIT(1)
 #define XGMAC_HW_FEATURE1		0x00000120
 #define XGMAC_HWFEAT_L3L4FNUM		GENMASK(30, 27)
+#define XGMAC_HWFEAT_HASHTBLSZ		GENMASK(25, 24)
 #define XGMAC_HWFEAT_RSSEN		BIT(20)
 #define XGMAC_HWFEAT_TSOEN		BIT(18)
 #define XGMAC_HWFEAT_SPHEN		BIT(17)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 53c4a40d8386..965cbe3e6f51 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -380,6 +380,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	/* MAC HW feature 1 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE1);
 	dma_cap->l3l4fnum = (hw_cap & XGMAC_HWFEAT_L3L4FNUM) >> 27;
+	dma_cap->hash_tb_sz = (hw_cap & XGMAC_HWFEAT_HASHTBLSZ) >> 24;
 	dma_cap->rssen = (hw_cap & XGMAC_HWFEAT_RSSEN) >> 20;
 	dma_cap->tsoen = (hw_cap & XGMAC_HWFEAT_TSOEN) >> 18;
 	dma_cap->sphen = (hw_cap & XGMAC_HWFEAT_SPHEN) >> 17;
-- 
2.7.4

