Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D61F13F957
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgAPQwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgAPQwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399992073A;
        Thu, 16 Jan 2020 16:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193565;
        bh=zpzci73/WOYggS/ZHbcKp5B5Qj5/qqYf8+daUsf7X+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oJYVDzJOyuKZVvho3neOYFgWmjuZTt0Lxr+Dtx9U1HGpQo3RcGsTnAud6gnXlMZi
         F4bEvpa5nKs+aQQq5zmygQi5w7yKuq8RNFqpS1diGBWexRjIe5IR6iBQ7cCkLp+HqR
         24iOCpfwgB2b7wEGV9B9tbl8hJU1fEL54iD9ULU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 109/205] net: axienet: Fix error return code in axienet_probe()
Date:   Thu, 16 Jan 2020 11:41:24 -0500
Message-Id: <20200116164300.6705-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit eb34e98baf4ce269423948dacefea6747e963b48 ]

In the DMA memory resource get failed case, the error is not
set and 0 will be returned. Fix it by removing redundant check
since devm_ioremap_resource() will handle it.

Fixes: 28ef9ebdb64c ("net: axienet: make use of axistream-connected attribute optional")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 676006f32f91..479325eeaf8a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1790,10 +1790,6 @@ static int axienet_probe(struct platform_device *pdev)
 		/* Check for these resources directly on the Ethernet node. */
 		struct resource *res = platform_get_resource(pdev,
 							     IORESOURCE_MEM, 1);
-		if (!res) {
-			dev_err(&pdev->dev, "unable to get DMA memory resource\n");
-			goto free_netdev;
-		}
 		lp->dma_regs = devm_ioremap_resource(&pdev->dev, res);
 		lp->rx_irq = platform_get_irq(pdev, 1);
 		lp->tx_irq = platform_get_irq(pdev, 0);
-- 
2.20.1

