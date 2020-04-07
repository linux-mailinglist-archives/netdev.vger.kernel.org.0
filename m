Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09E1A0354
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgDGAI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgDGABU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F05120768;
        Tue,  7 Apr 2020 00:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217679;
        bh=lCpe+4Dnaharjk9WK99w2h7l5Sscy3orPRfo6OQyoYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkzYwlahAs4zNU9M3I2uv0RydbTTiYagp/vYTif7aH61x6cxkudj860Od3xH97+Sx
         fpiLeAHka3AK+VTYnxdTkZqGUr0ovgfC38hvJ5Xo9q7qBeynCdOOc/eScz5SjuA07M
         Umsu4ERcjatED1ecyZ0V9r//Y6JpD/JJJRdo+ciA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Fuchs <mklntf@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 16/35] net: stmmac: platform: Fix misleading interrupt error msg
Date:   Mon,  6 Apr 2020 20:00:38 -0400
Message-Id: <20200407000058.16423-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Fuchs <mklntf@gmail.com>

[ Upstream commit fc191af1bb0d069dc7e981076e8b80af21f1e61d ]

Not every stmmac based platform makes use of the eth_wake_irq or eth_lpi
interrupts. Use the platform_get_irq_byname_optional variant for these
interrupts, so no error message is displayed, if they can't be found.
Rather print an information to hint something might be wrong to assist
debugging on platforms which use these interrupts.

Signed-off-by: Markus Fuchs <mklntf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index d10ac54bf385a..13fafd905db87 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -663,16 +663,22 @@ int stmmac_get_platform_resources(struct platform_device *pdev,
 	 * In case the wake up interrupt is not passed from the platform
 	 * so the driver will continue to use the mac irq (ndev->irq)
 	 */
-	stmmac_res->wol_irq = platform_get_irq_byname(pdev, "eth_wake_irq");
+	stmmac_res->wol_irq =
+		platform_get_irq_byname_optional(pdev, "eth_wake_irq");
 	if (stmmac_res->wol_irq < 0) {
 		if (stmmac_res->wol_irq == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
+		dev_info(&pdev->dev, "IRQ eth_wake_irq not found\n");
 		stmmac_res->wol_irq = stmmac_res->irq;
 	}
 
-	stmmac_res->lpi_irq = platform_get_irq_byname(pdev, "eth_lpi");
-	if (stmmac_res->lpi_irq == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	stmmac_res->lpi_irq =
+		platform_get_irq_byname_optional(pdev, "eth_lpi");
+	if (stmmac_res->lpi_irq < 0) {
+		if (stmmac_res->lpi_irq == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		dev_info(&pdev->dev, "IRQ eth_lpi not found\n");
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	stmmac_res->addr = devm_ioremap_resource(&pdev->dev, res);
-- 
2.20.1

