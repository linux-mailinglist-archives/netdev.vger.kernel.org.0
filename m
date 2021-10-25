Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1D439C7F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhJYRDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234409AbhJYRDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B509C60EE3;
        Mon, 25 Oct 2021 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181238;
        bh=vvG536PuQUxV1m0gedO+Dn40TcRnR3gq2Q4ZLdq1GPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL2GcDLu/NpLENhRL5Ljh4Z2npdkEnoFC7S9Oag6adwc26XMxbDQX9ec46KnPhF2T
         BLLPGlI64cukX2R4dgLMlBzCp3Xt0JlvhF5rp52UGMNHORYTAc9ij4eB8/BrQHe2yh
         jSGI69dmcb+642ILrjx54IbsjGC89nrdVV5jMC90HvavSagB7tJ9lUN0KxYk/O/pyS
         Dxm3otJM984tbc6+jO2rgxiG77qtga63DiZDrXkKOhtDtB3rydhglIHGhfifkV76+p
         ITKR4/W5SGDiLV51fJD5u4XcU9l+lTvlTZB+m1jMhZCceNKoolDCDOV7Ml8uXQ14UD
         Tq5k7cqUEXXDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, isdn@linux-pingi.de,
        zou_wei@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/13] mISDN: Fix return values of the probe function
Date:   Mon, 25 Oct 2021 13:00:16 -0400
Message-Id: <20211025170023.1394358-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit e211210098cb7490db2183d725f5c0f10463a704 ]

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index e501cb03f211..bd087cca1c1d 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1994,14 +1994,14 @@ setup_hw(struct hfc_pci *hc)
 	pci_set_master(hc->pdev);
 	if (!hc->irq) {
 		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
-		return 1;
+		return -EINVAL;
 	}
 	hc->hw.pci_io =
 		(char __iomem *)(unsigned long)hc->pdev->resource[1].start;
 
 	if (!hc->hw.pci_io) {
 		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-		return 1;
+		return -ENOMEM;
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
@@ -2012,7 +2012,7 @@ setup_hw(struct hfc_pci *hc)
 	if (!buffer) {
 		printk(KERN_WARNING
 		       "HFC-PCI: Error allocating memory for FIFO!\n");
-		return 1;
+		return -ENOMEM;
 	}
 	hc->hw.fifos = buffer;
 	pci_write_config_dword(hc->pdev, 0x80, hc->hw.dmahandle);
@@ -2022,7 +2022,7 @@ setup_hw(struct hfc_pci *hc)
 		       "HFC-PCI: Error in ioremap for PCI!\n");
 		dma_free_coherent(&hc->pdev->dev, 0x8000, hc->hw.fifos,
 				  hc->hw.dmahandle);
-		return 1;
+		return -ENOMEM;
 	}
 
 	printk(KERN_INFO
-- 
2.33.0

