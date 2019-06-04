Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225B135440
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfFDXbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfFDXWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF8220883;
        Tue,  4 Jun 2019 23:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690568;
        bh=7RKqnTF0UoxISxDPFG8OSp8mtQWT95S3Wu+raiusIB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kY6Tf3KA56BwzXJXrgYB/ypNjByf3yvGW7kPUMxw+kei4H/SzdZs2uiz/gJmvQeTu
         L2Qvn8c09Tiac0rGWxLXaX37iAuEE0Ufb60kW4DzwQxx3ctApWtIU+6ARyugBtY1vY
         UtnsuTDJLdM89Kx4YPTa0leX63pS0vcLFXLO2Clg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 22/60] net: macb: fix error format in dev_err()
Date:   Tue,  4 Jun 2019 19:21:32 -0400
Message-Id: <20190604232212.6753-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Ceresoli <luca@lucaceresoli.net>

[ Upstream commit f413cbb332a0b5251a790f396d0eb4ebcade5dec ]

Errors are negative numbers. Using %u shows them as very large positive
numbers such as 4294967277 that don't make sense. Use the %d format
instead, and get a much nicer -19.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Fixes: b48e0bab142f ("net: macb: Migrate to devm clock interface")
Fixes: 93b31f48b3ba ("net/macb: unify clock management")
Fixes: 421d9df0628b ("net/macb: merge at91_ether driver into macb driver")
Fixes: aead88bd0e99 ("net: ethernet: macb: Add support for rx_clk")
Fixes: f5473d1d44e4 ("net: macb: Support clock management for tsu_clk")
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a6535e226d84..d005ed12b4d1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3377,7 +3377,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get macb_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
 		return err;
 	}
 
@@ -3386,7 +3386,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
 		return err;
 	}
 
@@ -3404,31 +3404,31 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
 	err = clk_prepare_enable(*hclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable hclk (%d)\n", err);
 		goto err_disable_pclk;
 	}
 
 	err = clk_prepare_enable(*tx_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable tx_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable tx_clk (%d)\n", err);
 		goto err_disable_hclk;
 	}
 
 	err = clk_prepare_enable(*rx_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable rx_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable rx_clk (%d)\n", err);
 		goto err_disable_txclk;
 	}
 
 	err = clk_prepare_enable(*tsu_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable tsu_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable tsu_clk (%d)\n", err);
 		goto err_disable_rxclk;
 	}
 
@@ -3902,7 +3902,7 @@ static int at91ether_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
-- 
2.20.1

