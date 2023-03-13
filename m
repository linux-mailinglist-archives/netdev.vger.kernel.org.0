Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4D86B850E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCMWn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCMWnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:43:25 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4C9690B70;
        Mon, 13 Mar 2023 15:42:58 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 0A842E0EBE;
        Tue, 14 Mar 2023 01:42:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=MMTDeeiuyc0pzzHSuO/Rc/eYSTeHJthGjOCtbtYlG0E=; b=ZcThLAGsnX6J
        8iB9AOckyNeuUTeNraGhpyZ0oUOH/iCOoD3adNkzyVp6sDtwNVOYvK3WDotdFTfd
        GtviYZIcRmH5c/2nb3trChdUzR5FaOlH5re8uSiFt+v+JCFXWkc0qmCn7WSV6J4/
        K9x2+RIhvKM8Tbe7ynZoAwjrO7CvnLQ=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id ED1A8E0EBB;
        Tue, 14 Mar 2023 01:42:55 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:55 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net 11/13] net: stmmac: gmac4: Use dwmac410_disable_dma_irq for DW MAC v4.10 DMA
Date:   Tue, 14 Mar 2023 01:42:35 +0300
Message-ID: <20230313224237.28757-12-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From the very beginning of the DW GMAC v4.10 IP support the driver has used
an invalid DMA IRQ disable method to switch the DMA IRQs off. Since
commit 021bd5e36970 ("net: stmmac: Let TX and RX interrupts be
independently enabled/disabled") a valid method has been added to the
dwmac4_lib.c module, but the commit author forgot to initialize the
corresponding field of the DW MAC DMA operations descriptor with it. That
mistake hasn't caused any problem so far just because the RIE/TIE fields
match in both 4.x and 4.10 IPs. Anyway fix the inconsistency in order to
at least have a coherent driver code.

Fixes: 021bd5e36970 ("net: stmmac: Let TX and RX interrupts be independently enabled/disabled")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index d99fa028c646..2b85819a560f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -557,7 +557,7 @@ const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.dma_rx_mode = dwmac4_dma_rx_chan_op_mode,
 	.dma_tx_mode = dwmac4_dma_tx_chan_op_mode,
 	.enable_dma_irq = dwmac410_enable_dma_irq,
-	.disable_dma_irq = dwmac4_disable_dma_irq,
+	.disable_dma_irq = dwmac410_disable_dma_irq,
 	.start_tx = dwmac4_dma_start_tx,
 	.stop_tx = dwmac4_dma_stop_tx,
 	.start_rx = dwmac4_dma_start_rx,
-- 
2.39.2


