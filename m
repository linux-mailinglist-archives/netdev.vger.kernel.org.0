Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F236B8510
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCMWoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjCMWng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:43:36 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A1A888EC2;
        Mon, 13 Mar 2023 15:43:01 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 96BE1E0EC0;
        Tue, 14 Mar 2023 01:42:58 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=X30LbXauYddYhvPhR7vBPQjq66bDYO15OSX1bv9lZMo=; b=WvFHDUqmG/WY
        MM86mbD2uV0YWPZk9HvGN0FI9p4d7KusEnmPHxCjCmUrLwxx2da6CymBgJVkpM2F
        7/YOurxMXGfr3kG2S4xiG06/+sGOKXWSy+QYYZGOQpC7CN5d4BShK/ZSj5Mw45ff
        eIY5dXuhDxW4XcT0qHEtnWozxbZ3Ncw=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 73FEBE0EBB;
        Tue, 14 Mar 2023 01:42:58 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:42:57 +0300
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Qing Zhang <zhangqing@loongson.cn>
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
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 13/13] net: dwmac-loongson: Perceive zero IRQ as invalid
Date:   Tue, 14 Mar 2023 01:42:37 +0300
Message-ID: <20230313224237.28757-14-Sergey.Semin@baikalelectronics.ru>
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

Linux kernel defines zero IRQ number as invalid in case if IRQ couldn't be
mapped. Fix that for Loongson PCI MAC specific IRQs request procedure.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index a25c187d3185..907bdfcc07e9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -127,20 +127,20 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	res.addr = pcim_iomap_table(pdev)[0];
 
 	res.irq = of_irq_get_byname(np, "macirq");
-	if (res.irq < 0) {
+	if (res.irq <= 0) {
 		dev_err(&pdev->dev, "IRQ macirq not found\n");
 		ret = -ENODEV;
 		goto err_disable_msi;
 	}
 
 	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
-	if (res.wol_irq < 0) {
+	if (res.wol_irq <= 0) {
 		dev_info(&pdev->dev, "IRQ eth_wake_irq not found, using macirq\n");
 		res.wol_irq = res.irq;
 	}
 
 	res.lpi_irq = of_irq_get_byname(np, "eth_lpi");
-	if (res.lpi_irq < 0) {
+	if (res.lpi_irq <= 0) {
 		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
 		ret = -ENODEV;
 		goto err_disable_msi;
-- 
2.39.2


