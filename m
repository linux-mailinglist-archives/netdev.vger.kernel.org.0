Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E36822C4
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfHEQpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:45:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:39856 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728518AbfHEQp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:45:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7E4F9C01A8;
        Mon,  5 Aug 2019 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565023529; bh=fbtQFB9LCewR+4CQnQA+pjZHqX6A89CQKWKrIGkEz44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=TAy/GifFfCsgt1WBqf69BuaoZfVvRpQfw9TkvdaeQ4SVB2ppxUTsyrZ1cerPpa8QX
         oh1/Anj+LRTjwj3er1l45O8pjDuiXCFLQv+23KYMhcYr9MsSjlpH8nt3vd7SoDtnO5
         5OxhK88QSb8laK86oZqiwkvnDqSKk/BDpj4zzupoPECqujYiEWT5vPM65w344xjHuc
         XZj/7+CE+hOgSMvRan03YA38mF7g3VthpD5gjhdtyR6KPx++gjgwOLjgKSrH1Oe1/Y
         H4/RmF6/fV4bX+Hl9/QJPon+hLwFDFS7jGXt8qUrro0/Tt5HndFxzfIKjot5V+MPuJ
         Rti94f84VYrzQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 36FE5A006D;
        Mon,  5 Aug 2019 16:45:27 +0000 (UTC)
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
Subject: [PATCH net-next 05/26] net: stmmac: xgmac: Implement tx_queue_prio()
Date:   Mon,  5 Aug 2019 18:44:32 +0200
Message-Id: <e0536be2fc13bdd7df7815f4863fef57accfab48.1565022597.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the TX Queue Priority callback in XGMAC core.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h      |  4 ++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 19 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 86a42bc39d21..b77091161765 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -127,6 +127,10 @@
 #define XGMAC_MTL_RXQ_DMA_MAP1		0x00001034
 #define XGMAC_QxMDMACH(x)		GENMASK((x) * 8 + 3, (x) * 8)
 #define XGMAC_QxMDMACH_SHIFT(x)		((x) * 8)
+#define XGMAC_TC_PRTY_MAP0		0x00001040
+#define XGMAC_TC_PRTY_MAP1		0x00001044
+#define XGMAC_PSTC(x)			GENMASK((x) * 8 + 7, (x) * 8)
+#define XGMAC_PSTC_SHIFT(x)		((x) * 8)
 #define XGMAC_MTL_TXQ_OPMODE(x)		(0x00001100 + (0x80 * (x)))
 #define XGMAC_TQS			GENMASK(25, 16)
 #define XGMAC_TQS_SHIFT			16
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index ce6503dfc86d..bfbd5ae11540 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -118,6 +118,23 @@ static void dwxgmac2_rx_queue_prio(struct mac_device_info *hw, u32 prio,
 	writel(value, ioaddr + reg);
 }
 
+static void dwxgmac2_tx_queue_prio(struct mac_device_info *hw, u32 prio,
+				   u32 queue)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value, reg;
+
+	reg = (queue < 4) ? XGMAC_TC_PRTY_MAP0 : XGMAC_TC_PRTY_MAP1;
+	if (queue >= 4)
+		queue -= 4;
+
+	value = readl(ioaddr + reg);
+	value &= ~XGMAC_PSTC(queue);
+	value |= (prio << XGMAC_PSTC_SHIFT(queue)) & XGMAC_PSTC(queue);
+
+	writel(value, ioaddr + reg);
+}
+
 static void dwxgmac2_prog_mtl_rx_algorithms(struct mac_device_info *hw,
 					    u32 rx_alg)
 {
@@ -428,7 +445,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.rx_ipc = dwxgmac2_rx_ipc,
 	.rx_queue_enable = dwxgmac2_rx_queue_enable,
 	.rx_queue_prio = dwxgmac2_rx_queue_prio,
-	.tx_queue_prio = NULL,
+	.tx_queue_prio = dwxgmac2_tx_queue_prio,
 	.rx_queue_routing = NULL,
 	.prog_mtl_rx_algorithms = dwxgmac2_prog_mtl_rx_algorithms,
 	.prog_mtl_tx_algorithms = dwxgmac2_prog_mtl_tx_algorithms,
-- 
2.7.4

