Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DD6A844E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbfIDNRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:17:33 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:33594 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730452AbfIDNRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:17:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 78F4EC5740;
        Wed,  4 Sep 2019 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567603037; bh=KtB3Uov2hN4nf9kUa8PMFbl3ixv9iikyZQaPSyHRMNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=TTl1bzQi9wafn8aTGF4cwQ9XIZVRroMxpt87Sjf3ljSSbsf0iCqDT2n1K6IS0hT+c
         J4N7o59AmdUA/+UXlEL8VKjexhaVnohJ8i1zrk3UMC/oD09gqs0+jdqwn3y492O1RS
         wlORvU6iAUiZVrFvzgsJFNo0LSwXhoWKU9iU8HRpYKk3xazRjGoIrIreOWWiqIQv54
         7Nqw5Z/QWWVQE9/HHd+XUXhryWhsjFJRCGykyZteitT8r6OPbBWPP3fMjnwOD6CT4f
         6QRvkZXrcv9qdruoS+mLADL/hkbjD2rN7V85sM8JqiDijCk4o3E/tjbMWbQ/HX0DsO
         c4a/kac5Ft5Zw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 2888FA0066;
        Wed,  4 Sep 2019 13:17:12 +0000 (UTC)
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
Subject: [PATCH v2 net-next 02/13] net: stmmac: xgmac: Add RBU handling in DMA interrupt
Date:   Wed,  4 Sep 2019 15:16:54 +0200
Message-Id: <42759cafe734764d692597437835b42eec66e059.1567602867.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the handling of Receive Buffer Unavailable interrupt in the DMA
handler of XGMAC cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 64956465c030..e77eb0ddf9b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -322,6 +322,10 @@ static int dwxgmac2_dma_interrupt(void __iomem *ioaddr,
 
 	/* ABNORMAL interrupts */
 	if (unlikely(intr_status & XGMAC_AIS)) {
+		if (unlikely(intr_status & XGMAC_RBU)) {
+			x->rx_buf_unav_irq++;
+			ret |= handle_rx;
+		}
 		if (unlikely(intr_status & XGMAC_TPS)) {
 			x->tx_process_stopped_irq++;
 			ret |= tx_hard_error;
-- 
2.7.4

