Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD180BAB30
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 21:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439183AbfIVTfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 15:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390102AbfIVSqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0603121971;
        Sun, 22 Sep 2019 18:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177997;
        bh=ljyOOYLOrVHKPq0GoGX1yqA6Ygi+ssZEBM2nuLc3eP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUq8QizUVz2QnQ3Z6YN0ZP57X3gj7MCozIBNimEKXGey9Ut0uFYcScAJ4FgmaJv5L
         NzuPtWnNG32ME0RBWMgKEvqL0fMbE+Q3r+ombJTproeWfNFs21YUi5iYnhdJ963o5k
         5ubVpfARuj6d2Co8Q4V8HjcszwTFaxoKEVvW6U+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 088/203] net: lpc-enet: fix printk format strings
Date:   Sun, 22 Sep 2019 14:41:54 -0400
Message-Id: <20190922184350.30563-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit de6f97b2bace0e2eb6c3a86e124d1e652a587b56 ]

compile-testing this driver on other architectures showed
multiple warnings:

  drivers/net/ethernet/nxp/lpc_eth.c: In function 'lpc_eth_drv_probe':
  drivers/net/ethernet/nxp/lpc_eth.c:1337:19: warning: format '%d' expects argument of type 'int', but argument 4 has type 'resource_size_t {aka long long unsigned int}' [-Wformat=]

  drivers/net/ethernet/nxp/lpc_eth.c:1342:19: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]

Use format strings that work on all architectures.

Link: https://lore.kernel.org/r/20190809144043.476786-10-arnd@arndb.de
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index f7e11f1b0426c..b0c8be127bee1 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1344,13 +1344,14 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	pldat->dma_buff_base_p = dma_handle;
 
 	netdev_dbg(ndev, "IO address space     :%pR\n", res);
-	netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));
+	netdev_dbg(ndev, "IO address size      :%zd\n",
+			(size_t)resource_size(res));
 	netdev_dbg(ndev, "IO address (mapped)  :0x%p\n",
 			pldat->net_base);
 	netdev_dbg(ndev, "IRQ number           :%d\n", ndev->irq);
-	netdev_dbg(ndev, "DMA buffer size      :%d\n", pldat->dma_buff_size);
-	netdev_dbg(ndev, "DMA buffer P address :0x%08x\n",
-			pldat->dma_buff_base_p);
+	netdev_dbg(ndev, "DMA buffer size      :%zd\n", pldat->dma_buff_size);
+	netdev_dbg(ndev, "DMA buffer P address :%pad\n",
+			&pldat->dma_buff_base_p);
 	netdev_dbg(ndev, "DMA buffer V address :0x%p\n",
 			pldat->dma_buff_base_v);
 
@@ -1397,8 +1398,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_out_unregister_netdev;
 
-	netdev_info(ndev, "LPC mac at 0x%08x irq %d\n",
-	       res->start, ndev->irq);
+	netdev_info(ndev, "LPC mac at 0x%08lx irq %d\n",
+	       (unsigned long)res->start, ndev->irq);
 
 	device_init_wakeup(dev, 1);
 	device_set_wakeup_enable(dev, 0);
-- 
2.20.1

