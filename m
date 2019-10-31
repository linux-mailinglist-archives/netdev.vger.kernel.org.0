Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4F7EAE28
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfJaLBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:01:05 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:59344 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbfJaLBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:01:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A7428C08B3;
        Thu, 31 Oct 2019 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572519662; bh=YDnL8bpwK/tRJL9FcP1ml8xixy+yOmNErBznAAvEsXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ZVpASdIcb0OYgCvj4Jb0YMsy7mpfK6fWYwhIwgCijFhsDCNrVI0Y+lPejRbydOh0x
         Qjstn+OR1SuMJRa81MVppQH9zlp9LjfLqV/dizl3GK5giakYr5v+6TRUNUkg/Psqkh
         ygy31CYlNZvjoclqfvK0PI0I92C+rBt4fQCi43n54sGn/WjRbVXTzND3oXaaQCMl8j
         ta5jw+Iw4NtSOnxcphxUuCEngW6qiagsp4mGelzM0KpfvDeZpamMJHMnijYaolepp0
         wurJ0DsGPT5rrtFr1I0bKIVMtORptdnOgmRchJwz+GWs71AmwiIHL3SPPMNR/tmu0j
         wvHZLtEHSYIlg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5E65AA007E;
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
Subject: [PATCH net v2 08/10] net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in AV
Date:   Thu, 31 Oct 2019 12:00:46 +0100
Message-Id: <efeb1da2bc93722b9cce10c355bb540135cb7327.1572519070.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
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

