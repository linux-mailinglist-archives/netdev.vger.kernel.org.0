Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9773BA50B3
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbfIBICS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:02:18 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:51338 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729867AbfIBICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6F2FCC0418;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=KtB3Uov2hN4nf9kUa8PMFbl3ixv9iikyZQaPSyHRMNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=HZkq/hvcG7zb3ZsmDrcm2MWAEu4O4wftlN9W0W90xfGrMwyBOJrjthcTc3QP5flSU
         2gWBUynEPd+sm+nPVWOKhd4PjRcs567J1k1lhK0/dAdtCPN861A3mNtGqrAcFdA91Z
         ZpwUT2p+0b2ZDyz3Ajng+2QdN1K/BHeGojbpdU3OZok5SEjhRFtNuTatAdiLKhgaAF
         EPSNzzDhP4oVsvhIbBNcLfgnP77M/49Z7lbVgTyCUU1A8wzKk8oDVn2TlJ2niLHdwu
         Fei5Ujv1tDJrE8AYISH9NOe5yBi8j1ugSeEjS/hpQ/EcP8hMjjGysLqaV3mk8UzXXy
         wHTHTfXLp061Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1CBFCA0068;
        Mon,  2 Sep 2019 08:02:15 +0000 (UTC)
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
Subject: [PATCH net-next 02/13] net: stmmac: xgmac: Add RBU handling in DMA interrupt
Date:   Mon,  2 Sep 2019 10:01:44 +0200
Message-Id: <dd52c10ba74b26a99ac3f1e32c21b37c6450f9f8.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
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

