Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E16FC588
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKNLnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:43:08 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:56978 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbfKNLm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:42:57 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B73E2C04C7;
        Thu, 14 Nov 2019 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573731776; bh=6mDOD0LZwNVU4TcplrWHtHQ3iiQNzYDGcKk37WCw+xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ld9Mv1FjLKGY6kbHtQOQjldc+dP1qXoobUF1syq5aotA20lUk5Cwlk73/u5m4LLqJ
         6Jel6i/PDuxs8UPzXIrBn38j+zaqWjsv9grAZWVCyMJiYyaN01NU5iU6JgRmMHaMa1
         /Plpd3U5TaGmdBhULCLtckLOUcFqSnAIPzYsV8CYVXJx8i24oTqfABlBBp9BEJ3eJh
         dYuzi59dEpGD7Nej3PDiv08TQhFaAIDEOwOS2ZNb/VmKY/9JBJzvFulrX5gDRNUcnV
         BSRbZMmTy1wf/KsxFj9EvaTI9C98WcC9hJvflba+yw1J3d8jVgcJr89PQ4ntJoUgnz
         KuN1Zdc1YhQbA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6973CA008A;
        Thu, 14 Nov 2019 11:42:53 +0000 (UTC)
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
Subject: [PATCH v2 net-next 3/7] net: stmmac: gmac4+: Remove uneeded computation for RFA/RFD
Date:   Thu, 14 Nov 2019 12:42:47 +0100
Message-Id: <5d366123e4216001e5e7069e74e1810c9a8c7b45.1573731453.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573731453.git.Jose.Abreu@synopsys.com>
References: <cover.1573731453.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573731453.git.Jose.Abreu@synopsys.com>
References: <cover.1573731453.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFA and RFD should not be dependent on FIFO size. In fact, the more FIFO
space we have, the later we can activate Flow Control. Let's use
hard-coded values for RFA and RFD for all FIFO sizes with the exception
of 4k, which is a special case.

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
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 36a0af8bf89f..c15409030710 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -252,19 +252,9 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 			rfa = 0x01; /* Full-1.5K */
 			break;
 
-		case 8192:
-			rfd = 0x06; /* Full-4K */
-			rfa = 0x0a; /* Full-6K */
-			break;
-
-		case 16384:
-			rfd = 0x06; /* Full-4K */
-			rfa = 0x12; /* Full-10K */
-			break;
-
 		default:
-			rfd = 0x06; /* Full-4K */
-			rfa = 0x1e; /* Full-16K */
+			rfd = 0x07; /* Full-4.5K */
+			rfa = 0x04; /* Full-3K */
 			break;
 		}
 
-- 
2.7.4

